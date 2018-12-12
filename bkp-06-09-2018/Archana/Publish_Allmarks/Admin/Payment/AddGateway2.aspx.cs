namespace AbleCommerce.Admin._Payment
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers;
    using CommerceBuilder.Utility;

    public partial class AddGateway2 : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private List<PaymentMethod> _PaymentMethods;
        private string _ProviderClassId = string.Empty;
        private IPaymentProvider _ProviderInstance = null;

        private string ProviderClassId
        {
            get
            {
                if (string.IsNullOrEmpty(_ProviderClassId))
                {
                    _ProviderClassId = ViewState["ProviderClassId"] as string;
                    if (string.IsNullOrEmpty(_ProviderClassId))
                    {
                        Guid sessionKey = AlwaysConvert.ToGuid(Request.QueryString["ProviderClassId"]);
                        if ((sessionKey != Guid.Empty))
                        {
                            _ProviderClassId = (string)Session[sessionKey.ToString()];
                            ViewState["ProviderClassId"] = _ProviderClassId;
                        }
                    }
                }
                return _ProviderClassId;
            }
        }

        private IPaymentProvider ProviderInstance
        {
            get
            {
                if (_ProviderInstance == null)
                {
                    if (!string.IsNullOrEmpty(ProviderClassId))
                    {
                        _ProviderInstance = Activator.CreateInstance(Type.GetType(ProviderClassId)) as IPaymentProvider;
                        if (_ProviderInstance != null)
                        {
                            _ProviderInstance.Initialize(0, GetConfigData());
                        }
                    }
                }
                return _ProviderInstance;
            }
        }

        protected void Page_Init(object sender, System.EventArgs e)
        {
            // REDIRECT IF NO PROVIDER AVAILABLE
            if (ProviderInstance == null) Response.Redirect("AddGateway.aspx");

            // INITIALIZE THE FORM
            Caption.Text = string.Format(Caption.Text, ProviderInstance.Name);
            ProviderInstance.BuildConfigForm(phInputForm);

            // DETERMINE IF PAYMENT METHODS SHOULD SHOW FOR THIS PROVIDER
            if (ShowPaymentMethods(ProviderInstance))
            {
                LoadPaymentMethods();
            }
            else
            {
                trPaymentMethods.Visible = false;
            }
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
            // DO NOT CHECK ANY PAYMENT ALREADY ASSIGNED TO A GATEWAY
            PaymentMethod method = (PaymentMethod)dataItem;
            if (method.Id != 0) return false;

            // DEFAULT CHECKED FOR UNASSIGNED CREDIT CARD METHODS
            if (method.IsCreditOrDebitCard()) return true;

            // DEFAULT CHECKED FOR PAYPAL IF THIS IS PAYPAL GATEWAY
            if (method.PaymentInstrumentType == PaymentInstrumentType.PayPal)
            {
                bool isPayPalGateway = (_ProviderInstance is CommerceBuilder.Payments.Providers.PayPal.PayPalProvider);
                return isPayPalGateway;
            }
            return false;
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            ClearSessionKey();
            Response.Redirect("Gateways.aspx");
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            PaymentGateway gateway = new PaymentGateway();
            gateway.ClassId = ProviderClassId;
            gateway.Name = ProviderInstance.Name;
            gateway.UpdateConfigData(this.GetConfigData());
            gateway.Save();
            ClearSessionKey();
            if (ShowPaymentMethods(ProviderInstance))
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
                        if (cbMethod.Checked) method.PaymentGateway = gateway;
                        method.Save();
                    }
                    index++;
                }
            }
            Response.Redirect("Gateways.aspx");
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
            PaymentInstrumentType[] hiddenMethods = { PaymentInstrumentType.GiftCertificate, PaymentInstrumentType.GoogleCheckout, PaymentInstrumentType.Mail, PaymentInstrumentType.PhoneCall, PaymentInstrumentType.PurchaseOrder };
            //DO NOT SHOW HIDDEN PAYMENT INTRUMENTS
            if (Array.IndexOf(hiddenMethods, method.PaymentInstrumentType) > -1) return false;
            //ONLY SHOW PAYPAL FOR THAT GATEWAY
            bool isPayPalGateway = (_ProviderInstance is CommerceBuilder.Payments.Providers.PayPal.PayPalProvider);
            if (method.PaymentInstrumentType == PaymentInstrumentType.PayPal) return isPayPalGateway;
            //MUST BE CREDIT CARD, CHECK, OR UNKNOWN
            return true;
        }

        private bool ShowPaymentMethods(IPaymentProvider provider)
        {
            string providerClassId = Misc.GetClassId(provider.GetType());
            string gcerClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.GiftCertificatePaymentProvider));
#pragma warning disable 618
            string gchkClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.GoogleCheckout.GoogleCheckout));
#pragma warning restore 618
            bool unassignable = gcerClassId.Equals(providerClassId) || gchkClassId.Equals(providerClassId);
            return !unassignable;
        }

        private void ClearSessionKey()
        {
            Guid sessionKey = AlwaysConvert.ToGuid(Request.QueryString["ProviderClassId"]);
            if ((sessionKey != Guid.Empty))
            {
                Session.Remove(sessionKey.ToString());
            }
        }
    }
}