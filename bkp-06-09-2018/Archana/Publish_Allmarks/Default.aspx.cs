namespace AbleCommerce
{
    using System;
    using System.IO;
    using System.Web.Configuration;

    // this file should not use ablecommercepage base class
    // it is a dummy placeholder file that should never be used
    // it will only be activated if the application is not installed
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // make sure application is not yet installed, by checking database connection string
            string connectString = WebConfigurationManager.ConnectionStrings["AbleCommerce"].ConnectionString;
            if (string.IsNullOrEmpty(connectString) || connectString.Equals("CONNECTIONSTRING"))
            {
                // application is no installed, redirect to installation pages
                string installScript = Server.MapPath("~/Install/Default.aspx");
                if (File.Exists(installScript))
                {
                    Response.Redirect("~/Install/Default.aspx");
                }
            }
        }
    }
}