//-----------------------------------------------------------------------
// <copyright file="Licensing.aspx.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Admin._Store.Security
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using CommerceBuilder.Common;
    using CommerceBuilder.Configuration;
    using CommerceBuilder.Licensing;
    using CommerceBuilder.Utility;

    public partial class Licensing : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            List<string> messages = new List<string>();

            bool permissionsValid = this.TestPermissions(messages);
            if (!permissionsValid || !string.IsNullOrEmpty(Request.QueryString["PERMTEST"]))
            {
                // SOMETHING IS WRONG WITH PERMISSIONS, WE SHOULD DISPLAY THE TEST RESULTS
                phUpdateKey.Visible = false;
                phPermissions.Visible = true;
                ProcessIdentity.Text = this.GetProcessIdentity();
                PermissionsTestResult.Text = string.Join(string.Empty, messages.ToArray());
            }
        }

        private bool TestPermissions(List<string> messages)
        {
            // FLAG TO TRACK RESULT OF TESTS
            bool permissionsValid = true;
            Exception testException;

            // DETERMINE THE BASE APPLICATION DIRECTORY
            string baseDirectory = Server.MapPath("~");
            string testFile = Server.MapPath("~/App_Data/CommerceBuilder.lic");
            testException = FileHelper.CanWriteExistingFile(testFile);
            if (testException != null)
            {
                // ACCESS EXCEPTION OCCURRED, SHOW ANY DIRECTORY PATH RELATIVE TO INSTALL
                string cleanFileName = testFile.Replace(baseDirectory, "~").Replace("\\", "/");
                string cleanMessage = testException.Message.Replace(baseDirectory, "~").Replace("\\", "/");
                messages.Add("Testing write access to " + cleanFileName + " : <font color=red>FAILED</font><blockquote>" + cleanMessage + "</blockquote>");
                permissionsValid = false;
            }

            return permissionsValid;
        }

        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            CommerceBuilder.Licensing.License license = null;
            license = KeyService.GetCurrentLicense();
            LicenseType.Text = license.KeyType.ToString();
            DomainList.DataSource = license.Domains.ToArray();
            DomainList.DataBind();
            if (license.SubscriptionDate != null)
            {
                if (license.SubscriptionDate < LocaleHelper.LocalNow)
                {
                    SubscriptionDate.Text = "Ended on " + license.SubscriptionDate.Value.ToString("dd-MMM-yyyy");
                }
                else
                {
                    SubscriptionDate.Text = "Ends on " + license.SubscriptionDate.Value.ToString("dd-MMM-yyyy");
                }
            }
            else SubscriptionDate.Text = "None";
            if (license.Expiration != null)
            {
                trExpiration.Visible = true;
                Expiration.Text = license.Expiration.Value.ToString("yyyy-MMM-dd");
            }

            // FOR NON-DEMO LICENSES, SHOW DEMO MODE PANEL
            if (license.KeyType != LicenseKeyType.DEMO)
            {
                DemoModePanel.Visible = true;
                if (ApplicationSettings.Instance.UseDemoMode)
                {
                    DemoModeButton.Text = "Disable Demo Mode";
                    DemoModeEnabledText.Visible = true;
                    DemoModeDisabledText.Visible = false;
                }
                else
                {
                    DemoModeButton.Text = "Enable Demo Mode";
                    DemoModeEnabledText.Visible = false;
                    DemoModeDisabledText.Visible = true;
                }
            }
            else
            {
                //FOR DEMO LICENSES, HIDE DEMO MODE PANEL
                DemoModePanel.Visible = false;
            }

            if (Session["StoreLicenseUpdated"] != null)
            {
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                Session.Remove("StoreLicenseUpdated");
            }
        }

        protected void DemoModeButton_Click(object sender, EventArgs e)
        {
            // REDIRECT TO REFRESH PAGE
            ApplicationSettings.Instance.UseDemoMode = !ApplicationSettings.Instance.UseDemoMode;
            ApplicationSettings.Instance.Save();
            Response.Redirect(Request.Url.ToString());
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            KeyReply response = KeyService.RequestKey(LicenseKey.Text);
            if (response.Success)
            {
                File.WriteAllText(Server.MapPath("~/App_Data/CommerceBuilder.lic"), response.LicenseKey);

                // WE HAVE TO REFRESH THIS PAGE TO SHOW THE UPDATED LICENSE
                // THE TOKEN MUST BE RE-INITIALIZED TO DISPLAY THE NEW LICENSE DATA
                Session["StoreLicenseUpdated"] = true;
                Response.Redirect(Request.Url.ToString());
            }
            else
            {
                HandleError(response.Message);
            }
        }

        private void HandleError(string errorMessage)
        {
            FailedMessage.Text = string.Format(FailedMessage.Text, errorMessage);
            FailedMessage.Visible = true;
        }

        private string GetProcessIdentity()
        {
            string processIdentity;
            try
            {
                processIdentity = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
            }
            catch
            {
                processIdentity = "Unable to determine.  Generally NETWORK SERVICE (Windows 2003/XP) or ASPNET (Windows 2000)";
            }
            return processIdentity;
        }
    }
}