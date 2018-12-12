using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Utility;
using CommerceBuilder.Users;
using CommerceBuilder.Common;
using CommerceBuilder.Orders;
using CommerceBuilder.Payments;

namespace AbleCommerce.Admin.People.Users
{
    public partial class PaymentProfiles : System.Web.UI.UserControl
    {
        private int _UserId;
        protected void Page_Load(object sender, EventArgs e)
        {
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
            PaymentProfileGrid.DataSource = GatewayPaymentProfileDataSource.LoadForUser(_UserId);
            PaymentProfileGrid.DataBind();
        }

        protected string GetExpirationDate(object o)
        {
            GatewayPaymentProfile profile = o as GatewayPaymentProfile;
            if (profile.Expiry.HasValue && profile.Expiry.Value > DateTime.MinValue && profile.Expiry.Value.Year != DateTime.MaxValue.Year)
                return string.Format("{0:y}", profile.Expiry);
            else return "N/A";
        }
    }
}