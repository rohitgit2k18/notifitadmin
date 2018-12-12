namespace AbleCommerce.Members
{
    using System;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class EditAffiliateAccount : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            Affiliate affiliate = AffiliateDataSource.Load(AlwaysConvert.ToInt(Request.QueryString["AffiliateId"]));
            if (affiliate == null
                || affiliate.Group == null
                || !user.IsInGroup(affiliate.GroupId)) Response.Redirect("~/Members/MyAffiliateAccount.aspx");
            AffiliateForm.Affiliate = affiliate;
        }
    }
}