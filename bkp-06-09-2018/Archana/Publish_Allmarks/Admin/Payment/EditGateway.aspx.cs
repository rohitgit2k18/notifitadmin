namespace AbleCommerce.Admin._Payment
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers;
    using CommerceBuilder.Utility;

    public partial class EditGateway : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _PaymentGatewayId = 0;
        private PaymentGateway _PaymentGateway;
        private IPaymentProvider _ProviderInstance;
        private List<PaymentMethod> _PaymentMethods;

        protected void Page_Init(object sender, EventArgs e)
        {
            // REDIRECT IF NO PROVIDER AVAILABLE
            _PaymentGatewayId = AlwaysConvert.ToInt(Request.QueryString["PaymentGatewayId"]);
            _PaymentGateway = PaymentGatewayDataSource.Load(_PaymentGatewayId);
            if (_PaymentGateway == null) Response.Redirect("Gateways.aspx");
            _ProviderInstance = _PaymentGateway.GetInstance();
            if (_ProviderInstance == null) Response.Redirect("Gateways.aspx");

            // INITIALIZE THE FORM
            Caption.Text = string.Format(Caption.Text, _ProviderInstance.Name);            

            // DETERMINE IF PAYMENT METHODS SHOULD SHOW FOR THIS PROVIDER
            if (ShowPaymentMethods(_PaymentGateway))
            {
                LoadPaymentMethods();
            }
            else
            {
                trPaymentMethods.Visible = false;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            _ProviderInstance.BuildConfigForm(phInputForm);
        }

        protected void LoadPaymentMethods()
        {
            _PaymentMethods = new List<PaymentMethod>();
            IList<PaymentMethod> allPaymentMethods = PaymentMethodDataSource.LoadAll("Name");
            foreach (PaymentMethod method in allPaymentMethods)
            {
                if (IsMethodVisible(method))
                {
                    _PaymentMethods.Add(method);
                }
            }
            PaymentMethodList.DataSource = _PaymentMethods;
            PaymentMethodList.DataBind();
            trPaymentMethods.Visible = (_PaymentMethods.Count > 0);
        }

        protected bool IsMethodAssigned(object dataItem)
        {
            PaymentMethod method = (PaymentMethod)dataItem;
            foreach (PaymentMethod assignedMethod in _PaymentGateway.PaymentMethods)
            {
                if (assignedMethod.Id == method.Id) return true;
            }
            return false;
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("Gateways.aspx");
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveGateWay();
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            }            
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveGateWay();
                Response.Redirect("Gateways.aspx");
            }
        }

        private void SaveGateWay()
        {
            _PaymentGateway.UpdateConfigData(this.GetConfigData());
            _PaymentGateway.Save();
            _ProviderInstance = _PaymentGateway.GetInstance();
            if (ShowPaymentMethods(_PaymentGateway))
            {
                //UPDATE PAYMENT METHODS
                int index = 0;
                foreach (DataListItem item in PaymentMethodList.Items)
                {
                    int paymentMethodId = AlwaysConvert.ToInt(PaymentMethodList.DataKeys[index]);
                    PaymentMethod method = GetPaymentMethod(paymentMethodId);
                    if (method != null)
                    {
                        CheckBox cbMethod = (CheckBox)AbleCommerce.Code.PageHelper.RecursiveFindControl(item, "Method");
                        if (cbMethod.Checked)
                        {
                            method.PaymentGateway = PaymentGatewayDataSource.Load(_PaymentGatewayId);
                        }
                        else if (method.PaymentGateway != null && method.PaymentGateway.Id == _PaymentGatewayId)
                        {
                            method.PaymentGateway = null;
                        }
                        method.Save();
                    }
                    index++;
                }
            }
        }

        private Dictionary<string, string> GetConfigData()
        {   
            Dictionary<string, string> configData = new Dictionary<String, String>();
            string configPrefix = phInputForm.Parent.UniqueID + "$Config_";
            foreach (string key in Request.Form)
            {
                if (key.StartsWith(configPrefix))
                {
                    configData.Add(key.Remove(0, configPrefix.Length), Request.Form[key]);
                }                
            }
            return configData;
        }

        private PaymentMethod GetPaymentMethod(int paymentMethodId)
        {
            foreach (PaymentMethod method in _PaymentMethods)
            {
                if (method.Id == paymentMethodId) return method;
            }
            return null;
        }

        private bool IsMethodVisible(PaymentMethod method)
        {
            // DO NOT SHOW HIDDEN PAYMENT INTRUMENTS
            PaymentInstrumentType[] hiddenMethods = { PaymentInstrumentType.GiftCertificate, PaymentInstrumentType.GoogleCheckout, PaymentInstrumentType.Mail, PaymentInstrumentType.PhoneCall, PaymentInstrumentType.PurchaseOrder };
            if (Array.IndexOf(hiddenMethods, method.PaymentInstrumentType) > -1) return false;

            // ONLY SHOW PAYPAL FOR THAT GATEWAY
            bool isPayPalGateway = (_ProviderInstance is CommerceBuilder.Payments.Providers.PayPal.PayPalProvider);
            if (method.PaymentInstrumentType == PaymentInstrumentType.PayPal) return isPayPalGateway;

            // ONLY SHOW AMAZON INSTRUMENTS FOR THE AMAZON GATEWAY
            string classId = Misc.GetClassId(_ProviderInstance.GetType());
            bool isAmazon = classId.EndsWith("CommerceBuilder.Amazon");
            if (isAmazon)
            {
                return method.PaymentInstrumentType == PaymentInstrumentType.Amazon;
            }
            
            // MUST BE CREDIT CARD, CHECK, OR UNKNOWN
            return true;
        }

        private bool ShowPaymentMethods(PaymentGateway gateway)
        {
            string gcerClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.GiftCertificatePaymentProvider));
#pragma warning disable 618
            string gchkClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.GoogleCheckout.GoogleCheckout));
#pragma warning restore 618
            bool unassignable = gcerClassId.Equals(gateway.ClassId) || gchkClassId.Equals(gateway.ClassId);
            return !unassignable;
        }
    }
}