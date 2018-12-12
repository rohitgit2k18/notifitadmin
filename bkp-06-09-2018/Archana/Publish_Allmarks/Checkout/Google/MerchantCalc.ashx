<%@ WebHandler Language="C#" Class="AbleCommerce.Checkout.Google.MerchantCalc" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CommerceBuilder.Payments.Providers.GoogleCheckout.Util;
using System.Security.Principal;
using System.IO;
using CommerceBuilder.Payments.Providers.GoogleCheckout.MerchantCalculation;
using CommerceBuilder.Utility;
using CommerceBuilder.Payments.Providers.GoogleCheckout.AC;

namespace AbleCommerce.Checkout.Google
{
    [System.Obsolete("Google Checkout is retired - effective November 20th 2013")]
    public class MerchantCalc : BasicAuthenticationHandler
    {

        public override void ProcessRequest(HttpContext context)
        {
            HttpRequest request = context.Request;
            HttpResponse response = context.Response;

            string AuthHeader = request.Headers["Authorization"];
            string userName = GetUserName(AuthHeader);
            string password = GetPassword(AuthHeader);

            if (UserHasAccess(userName, password))
            {
                context.User = new GenericPrincipal(new GenericIdentity(userName, "Google.Checkout.Basic"), new string[1] { "User" });

                // Extract the XML from the request.
                Stream requestStream = request.InputStream;
                StreamReader requestStreamReader = new StreamReader(requestStream);
                string requestXml = requestStreamReader.ReadToEnd();
                requestStream.Close();

                // Process the incoming XML.
                context.Trace.Write("Google Request: " + requestXml);
                CallbackProcessor P = new CallbackProcessor(new AcCallbackRules());
                byte[] responseXml = P.Process(requestXml);
                context.Trace.Write("AC Response: " + XmlUtility.Utf8BytesToString(responseXml));

                // SEND THE RESPONSE TO THE CALLING CLIENT
                response.BinaryWrite(responseXml);
            }
            else
            {
                response.ClearContent();
                response.SuppressContent = true;
                response.StatusCode = 401;
                response.StatusDescription = "Access Denied";
                response.AppendHeader("WWW-Authenticate", "Basic Realm=\"CheckoutCallbackRealm\"");
                response.Flush();
                context.ApplicationInstance.CompleteRequest();
            }
        }

        public override bool IsReusable
        {
            get
            {
                return true;
            }
        }
    }
}