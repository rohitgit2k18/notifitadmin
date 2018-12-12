namespace AbleCommerce.Admin.UserControls
{
    using System;
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class AccountDataViewport : System.Web.UI.UserControl
    {
        public int PaymentId
        {
            get
            {
                return AlwaysConvert.ToInt(ViewState["PaymentId"]);
            }
            set
            {
                ViewState["PaymentId"] = value;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // INITIALIZE THE ACCOUNT DATA VIEWPORT
            Payment payment = PaymentDataSource.Load(this.PaymentId);
            if (!IsAccountDataAvailable(payment))
            {
                // ACCOUNT DATA NOT PRESENT OR USER IS NOT PERMITTED
                ShowAccountData.Visible = false;
                SSLRequiredMessage.Visible = false;
                UnavailableMessage.Visible = true;
            }
            else
            {
                //ACCOUNT DATA IS PRESENT AND USER HAS PERMISSION
                if (Request.IsSecureConnection)
                {
                    // FOR PAYMENT TYPES OTHER THAN CREDIT CARD
                    // WE CAN BIND THE ACCOUNT DETAILS RIGHT AWAY
                    if (payment.PaymentMethod != null
                        && !payment.PaymentMethod.IsCreditOrDebitCard())
                    {
                        BindAccountData(payment);
                    }
                }
                else
                {
                    //SECURE CONNECTION NOT AVAILABLE
                    SSLRequiredMessage.Visible = true;
                    ShowAccountData.Visible = false;
                    UnavailableMessage.Visible = false;
                }
            }
        }

        protected void ShowAccountData_Click(object sender, EventArgs e)
        {
            Payment payment = PaymentDataSource.Load(this.PaymentId);
            if (IsAccountDataAvailable(payment))
            {
                // ACCOUNT DATA IS PRESENT AND USER HAS PERMISSION
                Logger.Audit(AuditEventType.ViewCardData, true, string.Empty, AbleContext.Current.User, payment.Order.Id);
                BindAccountData(payment);
            }
        }

        private void BindAccountData(Payment payment)
        {
            ShowAccountData.Visible = false;
            AccountData.Visible = true;
            AccountData.DataSource = new AccountDataDictionary(payment.AccountData);
            AccountData.DataBind();
        }

        private bool IsAccountDataAvailable(Payment payment)
        {
            return payment != null && payment.HasAccountData && AbleContext.Current.User.IsInRole(Role.OrderAdminRoles);
        }
    }
}