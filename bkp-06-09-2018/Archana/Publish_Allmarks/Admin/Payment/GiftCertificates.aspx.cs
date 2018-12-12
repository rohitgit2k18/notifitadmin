namespace AbleCommerce.Admin._Payment
{
    using System;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;

    public partial class GiftCertificates : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {   
        }

        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            bool multiDeleteOptionVisible = StatusList.SelectedIndex > 0 && GiftCertificatesGrid.Rows.Count > 0;
            GiftCertificatesGrid.Columns[0].Visible = multiDeleteOptionVisible;
            MultipleRowDelete.Visible = multiDeleteOptionVisible;
        }

        protected bool HasSerialNumber(object obj)
        {
            GiftCertificate oigc = (GiftCertificate)obj;
            return oigc.SerialNumber != null && oigc.SerialNumber.Length > 0;
        }

        protected void GiftCertificatesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {   
            int GiftCertificateId = AlwaysConvert.ToInt(e.CommandArgument);
            GiftCertificate gc = GiftCertificateDataSource.Load(GiftCertificateId);
            if (gc == null) return;
            IGiftCertKeyProvider provider = AbleContext.Container.Resolve<IGiftCertKeyProvider>();
            if (e.CommandName.Equals("Generate"))
            {
                gc.SerialNumber = provider.GenerateGiftCertificateKey();
                gc.AddActivatedTransaction();
                gc.Save();
                GiftCertificatesGrid.DataBind();
            }
            else if (e.CommandName.Equals("Deactivate"))
            {
                gc.SerialNumber = "";
                gc.AddDeactivatedTransaction();
                gc.Save();
                GiftCertificatesGrid.DataBind();
            }
        }

        protected bool IsDeleteable(int giftCertificateId)
        {
            GiftCertificate gc = GiftCertificateDataSource.Load(giftCertificateId);
            if (HasSerialNumber(gc) && !gc.IsExpired())
            {
                // IF ZERO BALANCE WITH ACTIVE GIFT CERTIFICATE
                if (gc.Balance == 0) return true;
                else return false;
            }
            else return true;
        }

        protected void MultipleRowDelete_Click(object sender, EventArgs e)
        {
            // Looping through all the rows in the GridView
            foreach (GridViewRow row in GiftCertificatesGrid.Rows)
            {
                CheckBox checkbox = (CheckBox)row.FindControl("DeleteCheckbox");
                if ((checkbox != null) && (checkbox.Checked))
                {
                    // Retreive the GiftCertificateId
                    int giftCertificateId = Convert.ToInt32(GiftCertificatesGrid.DataKeys[row.RowIndex].Value);
                    GiftCertificate gc = GiftCertificateDataSource.Load(giftCertificateId);
                    if (gc != null) gc.Delete();
                }
            }
            GiftCertificatesGrid.DataBind();
        }
    }
}