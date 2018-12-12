using System;
using System.Configuration;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Amazon.SecurityToken;
using Amazon.SecurityToken.Model;
using Amazon.S3.Model;
using Amazon;


class AWSHelpers
{
    // Set constants for keynames in the Web.config file
    private const String CONFIG_BUCKETNAME = "AmazonBucketName";
    private const String CONFIG_AWSACCESSKEY = "AmazonAccessKey";
    private const String CONFIG_SECRETKEY = "AmazonSecretKey";
    private const string CONFIG_S3ENDPOINT = "AmazonS3EndPoint";
    // Set the duration of the requested session
    private const int SESSION_DURATION = 8;


    public static TemporaryAWSCredentials GetSecurityToken(string userName)
    {
        TemporaryAWSCredentials temporaryCreds = new TemporaryAWSCredentials();
        Credentials sessionCredentials;

        // Create a client using the credentials from the Web.config file
        AmazonSecurityTokenServiceConfig config = new AmazonSecurityTokenServiceConfig();
        AmazonSecurityTokenServiceClient client = new AmazonSecurityTokenServiceClient(
                                                      GetAccesskey(),
                                                      GetSecretkey(),
                                                      config);

        // Build the aws username
        string awsUsername = BuildAWSUsername(userName);

        // Map policy based on whether this is an internal or external user.
        string policy = BuildAWSPolicy(UserType.Internal);

        // Store the attributes and request a new 
        // Federated session(temporary security creds)
        GetFederationTokenRequest request = new GetFederationTokenRequest
        {
            DurationSeconds = 3600 * SESSION_DURATION,
            Name = awsUsername,
            Policy = policy
        };

        GetFederationTokenResponse startSessionResponse = null;
        startSessionResponse = client.GetFederationToken(request);

        // Check the result returned i.e. Valid security credentials or null?
        if (startSessionResponse != null)
        {
            GetFederationTokenResult startSessionResult = startSessionResponse.GetFederationTokenResult;
            sessionCredentials = startSessionResult.Credentials;
            // Store all the returned keys and token to TemporarySecurityCreds object.
            temporaryCreds.User = userName;
            temporaryCreds.AccessKeyId = sessionCredentials.AccessKeyId;
            temporaryCreds.SecretAccessKey = sessionCredentials.SecretAccessKey;
            temporaryCreds.Expiration = sessionCredentials.Expiration;
            temporaryCreds.Token = sessionCredentials.SessionToken;
            return temporaryCreds;
        }
        else
        {
            throw new Exception("Error in retrieving AWS temporary security creds,recieved NULL");
        }

    }

    public static string PreSignedUrl(TemporaryAWSCredentials creds, string fileKey)
    {
        string url = "";

        //var s3Client = new AmazonS3Client(new SessionAWSCredentials(creds.AccessKeyId, creds.SecretAccessKey, creds.Token)))

        ResponseHeaderOverrides headerOverrides = new ResponseHeaderOverrides();
        headerOverrides.ContentType = "application/pdf";

        int secs = 0;
        do
        {
            using (var s3Client = AWSClientFactory.CreateAmazonS3Client(GetAccesskey(), GetSecretkey()))
            {
                GetPreSignedUrlRequest request = new GetPreSignedUrlRequest()
                    .WithBucketName(GetBucketname())
                    .WithKey(fileKey.TrimStart('/'))
                    .WithProtocol(Protocol.HTTP)
                    .WithVerb(HttpVerb.GET)
                    //.WithResponseHeaderOverrides(headerOverrides)
                    .WithExpires(DateTime.Now.AddMinutes(120).AddSeconds(secs));

                url = s3Client.GetPreSignedURL(request);
                secs++;
            }
        } while ((url.Contains("%2B") || url.Contains("%2b") || url.Contains("+")) && secs < 30); // try again until a signature with no + sign is generated.


        return url;
    }

    //--------------------------------------------------------------------
    /* HELPER FUNCTIONS */
    //--------------------------------------------------------------------
    // Function to retrieve the S3 bucket name, AWSAccessKey, AWSSecretKey
    //--------------------------------------------------------------------
    public static String GetBucketname()
    {
        // Retrieve "value" corresponding to the key for "bucketname" 
        // from web.config file.
        NameValueCollection appConfig = ConfigurationManager.AppSettings;
        string bucketName = appConfig[CONFIG_BUCKETNAME];

        // Check if valid S3 bucket name was retrieved from Web.config file
        if (bucketName == null)
        {
            throw new Exception("Unable to fetch policy for '" + CONFIG_BUCKETNAME +
            "' from Web.config");
        }
        return bucketName;
    }
    public static String GetAccesskey()
    {
        // Retrieve "value" corresponding to the key for "accesskey" 
        // from web.config file.
        NameValueCollection appConfig = ConfigurationManager.AppSettings;
        string accessKey = appConfig[CONFIG_AWSACCESSKEY];

        // Check if valid AWS access key was retrieved from Web.config file
        if (accessKey == null)
        {
            throw new Exception("Unable to fetch policy for '" + CONFIG_AWSACCESSKEY +
            "' from Web.config");
        }
        return accessKey;
    }
    public static String GetS3EndPoint()
    {
        // Retrieve "value" corresponding to the key for "accesskey" 
        // from web.config file.
        NameValueCollection appConfig = ConfigurationManager.AppSettings;
        string endPoint = appConfig[CONFIG_S3ENDPOINT];

        // Check if valid AWS end point was retrieved from Web.config file
        if (endPoint == null)
        {
            throw new Exception("Unable to fetch policy for '" + CONFIG_AWSACCESSKEY +
            "' from Web.config");
        }
        return endPoint;
    }
    public static String GetSecretkey()
    {
        // Retrieve "value" corresponding to the key for "secretkey" 
        // from web.config file
        NameValueCollection appConfig = ConfigurationManager.AppSettings;
        string secretKey = appConfig[CONFIG_SECRETKEY];

        // Check if valid AWS secret key was retrieved from Web.config file
        if (secretKey == null)
        {
            throw new Exception("Unable to fetch policy for '" + CONFIG_SECRETKEY +
            "' from Web.config");
        }
        return secretKey;
    }

    public enum UserType
    {
        Internal,
        External
    }

    //----------------------------------------------------------------------
    // Retrieve the policy corresponding to key "policy_?" from web.config
    //----------------------------------------------------------------------
    public static String BuildAWSPolicy(UserType userType)
    {
        // User Type is Internal or External
        string uType = userType.ToString("G");

        // Prepend the username with "policy_" string.
        // Retrieve Access policy corresponding to the "policy_"+username 
        // key from web.config file.

        NameValueCollection appConfig = ConfigurationManager.AppSettings;
        string policy = appConfig["policy_" + uType];

        // Check if valid policy was retrieved from Web.config file
        if (policy == null)
        {
            throw new Exception("Unable to fetch policy for '" + uType +
            "' from Web.config");
        }

        // Replace the [*] values with real values at runtime.
        policy = policy.Replace("[BUCKET-NAME]", GetBucketname());
        policy = policy.Replace("[USER-NAME]", uType.ToLowerInvariant());
        policy = policy.Replace("'", "\"");
        return policy;
    }

    //----------------------------------------------------------------------
    // Function to Split the username since it is received in the format 
    // Domain\\Username
    //----------------------------------------------------------------------
    public static String BuildAWSUsername(String userName)
    {
        string[] usernameParts = userName.Split('\\');
        if (!CheckSpecialCharacters(usernameParts[0]))
        {
            throw new Exception("Username retrieved " +
            "should strictly be alphanumeric");
        }
        // Return result in the form of username@domain
        return usernameParts[0]; // + "@" + usernameParts[0];
    }
    //----------------------------------------------------------------------
    // Function to check if user name contains special characters
    // only alphanumeric usernames are permitted.
    //----------------------------------------------------------------------
    public static Boolean CheckSpecialCharacters(string userName)
    {
        string pattern = @"^[a-zA-Z0-9]*$";
        Regex unameRgx = new Regex(pattern);
        return unameRgx.IsMatch(userName);
    }

}// End of class

[Serializable]
public class TemporaryAWSCredentials
{
    public string User { get; set; }

    public string AccessKeyId { get; set; }

    public string SecretAccessKey { get; set; }

    public string Token { get; set; }

    public DateTime Expiration { get; set; }

}

