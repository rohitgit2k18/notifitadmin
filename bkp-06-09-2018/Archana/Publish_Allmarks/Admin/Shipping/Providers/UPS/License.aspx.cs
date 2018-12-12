namespace AbleCommerce.Admin.Shipping.Providers._UPS
{
    using System;
    using CommerceBuilder.Shipping.Providers.UPS;

    public partial class License : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LicenseAgreement.Text = UPS.GetAgreement().Trim();
        }

        protected void NextButton_Click(object sender, System.EventArgs e)
        {
            if (YesButton.Checked)
            {
                Response.Redirect("Register.aspx");
            }
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("../Default.aspx");
        }
    }
}