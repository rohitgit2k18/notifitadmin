namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Users;
    using CommerceBuilder.Common;

    public partial class WhoIsOnline : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_PreInit(object sender, EventArgs e)
        {
            // READ ONLY SESSION
            AbleContext.Current.Database.GetSession().DefaultReadOnly = true;
        }

        protected void Page_SaveStateComplete(object sender, EventArgs e)
        {
            // END READ ONLY SESSION
            AbleContext.Current.Database.GetSession().DefaultReadOnly = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //initialize form
                ActivityThreshold.Text = "30";
            }
        }

        protected void ApplyButton_Click(object sender, EventArgs e)
        {
            OnlineUserGrid.DataBind();
        }

        protected string GetIpAddress(object usrObj)
        {
            User usr = usrObj as User;
            if (usr == null) return "";

            if (usr.PageViews.Count > 0)
            {
                CommerceBuilder.Reporting.PageView pv = usr.PageViews[0];
                return pv.RemoteIP;
            }

            return "";
        }
    }
}