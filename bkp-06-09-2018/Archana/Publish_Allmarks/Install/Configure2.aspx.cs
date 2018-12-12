//-----------------------------------------------------------------------
// <copyright file="Configure2.aspx.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Install
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.IO;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Services;
    using CommerceBuilder.Configuration;

    public partial class Configure2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                PageCaption.Text = string.Format(PageCaption.Text, AbleContext.Current.ReleaseLabel + " (build " + AbleContext.Current.Version.Revision.ToString() + ")");
            }
        }

        protected void InstallButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // update some settings that we can determine from the script
                Store store = AbleContext.Current.Store;
                store.Name = StoreName.Text;
                store.Save();
                store.StoreUrl = GetStoreUrl();
                store.Settings.TimeZoneOffset = GetDefaultTzOffset();
                store.Settings.TimeZoneCode = store.Settings.TimeZoneOffset.ToString();

                // update default store email
                string defaultEmailAddress = StoreEmail.Text.Trim();
                
                // use admin email if store email is not available
                if(string.IsNullOrEmpty(defaultEmailAddress))
                    defaultEmailAddress = Email.Text.Trim();
                store.Settings.DefaultEmailAddress = defaultEmailAddress;
                store.Settings.Save();

                // update the store address
                Warehouse warehouse = store.DefaultWarehouse;
                warehouse.Name = store.Name;
                warehouse.Address1 = Address1.Text;
                warehouse.Address2 = Address2.Text;
                warehouse.City = City.Text;
                warehouse.Province = Province.Text;
                warehouse.PostalCode = PostalCode.Text;
                warehouse.CountryCode = Country.Text;
                warehouse.Phone = Phone.Text;
                warehouse.Fax = Fax.Text;
                warehouse.Email = StoreEmail.Text;
                warehouse.Save();

                // update the admin user
                User admin = UserDataSource.Load(1);
                admin.UserName = Email.Text;
                admin.Email = Email.Text;
                admin.Save();
                admin.SetPassword(Password.Text);

                // add admin user to default group
                CommerceBuilder.Users.Group defaultGroup = AbleContext.Container.Resolve<IGroupRepository>()
                    .LoadForName(CommerceBuilder.Users.Group.DefaultUserGroupName);
                if (defaultGroup != null)
                {
                    admin.UserGroups.Add(new UserGroup(admin, defaultGroup));
                    admin.Save();
                }

                Address address = admin.PrimaryAddress;
                address.Email = Email.Text;
                address.Address1 = Address1.Text;
                address.Address2 = Address2.Text;
                address.City = City.Text;
                address.Province = Province.Text;
                address.PostalCode = PostalCode.Text;
                address.CountryCode = Country.Text;
                address.Phone = Phone.Text;
                address.Fax = Fax.Text;
                address.Save();

                // copy email templates
                string sourceDir = Server.MapPath("~/App_Data/EmailTemplates/Default");
                string targetDir = Server.MapPath("~/App_Data/EmailTemplates/1");                
                Directory.CreateDirectory(targetDir);
                foreach (var file in Directory.GetFiles(sourceDir))
                    File.Copy(file, Path.Combine(targetDir, Path.GetFileName(file)), true);

                if (IncludeSampleData.Checked)
                {
                    // add the sample data to the database
                    string connectionString = ConfigurationManager.ConnectionStrings["AbleCommerce"].ConnectionString;
                    List<string> errorList = RunScript(connectionString, Server.MapPath("~/Install/SampleData.sql"));

                    // extract the sample image and email files
                    CompressionHelper.ExtractArchive(Server.MapPath("~/install/ProductImages.zip"), Server.MapPath("~/Assets/ProductImages"));
                    
                    // generate a sample digital good
                    File.WriteAllText(Server.MapPath("~/App_Data/DigitalGoods/sample.txt"), "This is a sample text file for use with digital delivery.");

                    // check for errors in script
                    if (errorList.Count > 0)
                    {
                        InstallSucceededPanel.Visible = false;
                        InstallErrorPanel.Visible = true;
                        InstallErrorList.Text = "<p>" + string.Join("</p><p>", errorList.ToArray()) + "</p>";
                    }
                }

                // Make SQL the default search provider on new installs (JIRA ISSUE # AC8-1998)
                ApplicationSettings.Instance.SearchProvider = "SqlSearchProvider";
                ApplicationSettings.Instance.Save();

                // display complete message
                FormPanel.Visible = false;
                InstallCompletePanel.Visible = true;
            }
        }

        protected void Country_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (Country.SelectedValue == "US")
            {
                ProvinceRequired.ValidationExpression = "AL|AK|AZ|AR|CA|CO|CT|DE|DC|FL|GA|HI|ID|IL|IN|IA|KS|KY|LA|ME|MD|MA|MI|MN|MS|MO|MT|NE|NV|NH|NJ|NM|NY|NC|ND|OH|OK|OR|PA|RI|SC|SD|TN|TX|UT|VT|VA|WA|WV|WI|WY";
                ProvinceRequired.ErrorMessage = "Please provide a valid two letter US state code (in capital letters).";
                ProvinceRequired.Enabled = true;

                PostalCodeRequired.ValidationExpression = "\\d{5}";
                PostalCodeRequired.ErrorMessage = "You must enter a valid US ZIP (#####).";
                PostalCodeRequired.Enabled = true;
            }
            else if (Country.SelectedValue == "CA")
            {
                ProvinceRequired.ValidationExpression = "AB|BC|MB|NB|NL|NT|NS|NU|ON|PE|QC|SK|YT";
                ProvinceRequired.ErrorMessage = "Please provide a valid two letter CA state code (in capital letters).";
                ProvinceRequired.Enabled = true;

                PostalCodeRequired.ValidationExpression = "^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$";
                PostalCodeRequired.ErrorMessage = "You must enter a valid CA ZIP (A#A #A#)";
                PostalCodeRequired.Enabled = true;
            }
            else
            {
                ProvinceRequired.Enabled = false;
                PostalCodeRequired.Enabled = false;
            }
        }

        private string GetStoreUrl()
        {
            string tempUrl = Request.Url.ToString();
            int index = tempUrl.IndexOf("?");
            if (index > -1)
            {
                tempUrl = tempUrl.Substring(0, index);
            }
            tempUrl = tempUrl.ToLowerInvariant().Replace("install/configure2.aspx", string.Empty);
            return tempUrl;
        }

        private double GetDefaultTzOffset()
        {
            DateTime localNow = DateTime.Now;
            DateTime utcNow = localNow.ToUniversalTime();
            if (localNow == utcNow)
            {
                return 0;
            }
            else if (localNow < utcNow)
            {
                TimeSpan ts = utcNow - localNow;
                return -1 * ts.TotalHours;
            }
            else
            {
                TimeSpan ts = localNow - utcNow;
                return ts.TotalHours;
            }
        }

        private List<string> RunScript(string connectionString, string sqlScriptFile)
        {
            // initialize the error list
            List<string> errorList = new List<string>();

            // load up the specified scriptfile
            string sqlScript = FileHelper.ReadText(sqlScriptFile);

            // REMOVE SCRIPT COMMENTS
            sqlScript = Regex.Replace(sqlScript, @"/\*.*?\*/", string.Empty);

            // SPLIT INTO COMMANDS
            string[] commands = StringHelper.Split(sqlScript, "\r\nGO\r\n");

            // SETUP DATABASE CONNECTION
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Run each command on the database
                conn.Open();
                foreach (string sql in commands)
                {
                    try
                    {
                        SqlCommand command = new SqlCommand(sql, conn);
                        command.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        errorList.Add("<b>SQL:</b> " + sql);
                        errorList.Add("<b>Error:</b> " + ex.Message);
                    }
                }
                conn.Close();
            }
            return errorList;
        }
    }
}