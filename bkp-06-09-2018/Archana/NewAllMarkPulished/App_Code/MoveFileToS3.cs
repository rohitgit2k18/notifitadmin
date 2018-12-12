using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using Amazon.S3;
using Amazon;
using Amazon.S3.Transfer;
using System.IO;
using System.Web;
using System.Web.Hosting;


public class MoveFileToS3
{
    // Move all LOCAL files to S3
    public static void Do(string requestData)
    {
        using (Redi.Utility.SqlText select = new Redi.Utility.SqlText(
                "Select JobFileFileName, Id, FolderName, VersionNo, DisplayName " +
                "From ALL_JobFile " +
                "Where FileSystem='LOCAL' AND Deleted = 0 "))
        {
            DbDataReader myReader = select.ExecuteReader();
            while (myReader.Read())
            {
                string fileName = myReader.GetString(0);
                Int32 fileId = myReader.GetInt32(1);
                string folderName = "";
                if (!myReader.IsDBNull(2))
                    folderName = myReader.GetString(2);
                Int32 version = myReader.GetInt32(3);
                string displayName = "";
                if (!myReader.IsDBNull(4))
                    displayName = myReader.GetString(4);
                else
                    displayName = fileName;

                string wkCurrentPath = HostingEnvironment.MapPath("\\" + folderName.Trim('/') + "\\" + fileName);
                if (MoveFile(fileName, folderName, version, wkCurrentPath))
                {
                    using (Redi.Utility.SqlText update = new Redi.Utility.SqlText(
                        "Update ALL_JobFile " +
                        "Set FileSystem = 'S3', " +
                        "    DisplayName = @DisplayName " +
                        "Where Id = @Id "))
                    {
                        update.AddParameter("@DisplayName", displayName);
                        update.AddParameter("@Id", fileId);
                        update.ExecuteNonQuery();
                    }
                }
            }
        }
    }

    private static Boolean MoveFile(string saveAsFileName, string wkBaseFolder, Int32 wkVersionNo, string currentFilePath)
    {
        try
        {
            string destFile = wkBaseFolder + "/" + wkVersionNo.ToString() + "/" + saveAsFileName;

            AmazonS3Config config = new AmazonS3Config();
            config.ServiceURL = AWSHelpers.GetS3EndPoint();
            using (var client = AWSClientFactory.CreateAmazonS3Client(AWSHelpers.GetAccesskey(), AWSHelpers.GetSecretkey(), config))
            {
                TransferUtility s3TransferUtil = new TransferUtility(client);

                TransferUtilityUploadRequest s3TrfrReq = new TransferUtilityUploadRequest();
                s3TrfrReq.CannedACL = Amazon.S3.Model.S3CannedACL.BucketOwnerFullControl;
                s3TrfrReq.FilePath = currentFilePath;
                s3TrfrReq.BucketName = AWSHelpers.GetBucketname();
                s3TrfrReq.Key = destFile;
                s3TransferUtil.Upload(s3TrfrReq);

                // Delete the temporary PDF on the web server
                FileInfo TheFile = new FileInfo(s3TrfrReq.FilePath);
                if (TheFile.Exists)
                {
                    // File found so delete it.
                    TheFile.Delete();
                }
            }

            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

}

