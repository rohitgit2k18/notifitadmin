namespace AbleCommerce.Admin.Payment
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class AddPaymentMethodDialog : System.Web.UI.UserControl
    {
        //DEFINE AN EVENT TO TRIGGER WHEN AN ITEM IS ADDED 
        public event PersistentItemEventHandler ItemAdded;
        private const bool ShowIntlPaymentMethods = true;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // LOAD INSTRUMENT SELECT BOX
                List<ListItem> tempItems = new List<ListItem>();
                foreach (object enumItem in Enum.GetValues(typeof(PaymentInstrumentType)))
                {
                    PaymentInstrumentType instrument = ((PaymentInstrumentType)enumItem);
                    switch (instrument)
                    {
                        case PaymentInstrumentType.Check:
                        case PaymentInstrumentType.Discover:
                        case PaymentInstrumentType.JCB:
                        case PaymentInstrumentType.Mail:
                        case PaymentInstrumentType.MasterCard:
                        case PaymentInstrumentType.PayPal:
                        case PaymentInstrumentType.Visa:
                        case PaymentInstrumentType.Amazon:
                            tempItems.Add(new ListItem(instrument.ToString(), ((short)instrument).ToString()));
                            break;
                        case PaymentInstrumentType.AmericanExpress:
                            tempItems.Add(new ListItem("American Express", ((short)instrument).ToString()));
                            break;
                        case PaymentInstrumentType.DinersClub:
                            if (ShowIntlPaymentMethods) tempItems.Add(new ListItem("Diner's Club", ((short)instrument).ToString()));
                            break;
                        case PaymentInstrumentType.PhoneCall:
                            tempItems.Add(new ListItem("Phone Call", ((short)instrument).ToString()));
                            break;
                        case PaymentInstrumentType.SwitchSolo:
                            if (ShowIntlPaymentMethods) tempItems.Add(new ListItem("Switch/Solo", ((short)instrument).ToString()));
                            break;
                        case PaymentInstrumentType.VisaDebit:
                            if (ShowIntlPaymentMethods) tempItems.Add(new ListItem("Visa Debit (Delta/Electron)", ((short)instrument).ToString()));
                            break;
                        case PaymentInstrumentType.Maestro:
                            if (ShowIntlPaymentMethods) tempItems.Add(new ListItem(instrument.ToString(), ((short)instrument).ToString()));
                            break;
                        case PaymentInstrumentType.PurchaseOrder:
                            tempItems.Add(new ListItem("Purchase Order", ((short)instrument).ToString()));
                            break;
                        case PaymentInstrumentType.CreditCard:
                            tempItems.Add(new ListItem("Credit Card", ((short)instrument).ToString()));
                            break;
                    }
                    tempItems.Sort(delegate(ListItem x, ListItem y) { return x.Text.CompareTo(y.Text); });
                    PaymentInstrumentList.Items.Clear();
                    PaymentInstrumentList.Items.Add(new ListItem(string.Empty));
                    PaymentInstrumentList.Items.AddRange(tempItems.ToArray());
                }
                // LOAD GATEWAY SELECT BOX
                GatewayList.Items.Add(new ListItem("", ""));
                foreach (PaymentGateway gateway in AbleContext.Current.Store.PaymentGateways)
                {
                    if (IsAssignableGateway(gateway))
                    {
                        GatewayList.Items.Add(new ListItem(gateway.Name, gateway.Id.ToString()));
                    }
                }
                //GROUP RESTRICTION
                UseGroupRestriction.SelectedIndex = 0;
                BindGroups();
            }

            // trAllowSubscriptionPayments.Visible = AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled;
            refStar.Visible = !AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled;
            refStarTr.Visible = refStar.Visible;
        }

        private bool IsAssignableGateway(PaymentGateway gateway)
        {
            string gcerClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.GiftCertificatePaymentProvider));
#pragma warning disable 618
            string gchkClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.GoogleCheckout.GoogleCheckout));
#pragma warning restore 618
            //string ppalClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.PayPal.PayPalProvider));

            if (gcerClassId.Equals(gateway.ClassId)
                || gchkClassId.Equals(gateway.ClassId)
                /*|| ppalClassId.Equals(gateway.ClassId)*/)
            {
                return false;
            }
            return true;
        }

        protected void PaymentInstrumentList_SelectedIndexChanged(object sender, System.EventArgs e)
        {
            if (string.IsNullOrEmpty(Name.Text))
            {
                Name.Text = PaymentInstrumentList.SelectedItem.Text;
            }
            if (PaymentInstrumentList.SelectedValue == ((short)PaymentInstrumentType.PayPal).ToString())
            {
                GatewayList.SelectedIndex = 0;
                GatewayList.Enabled = false;
            }
            else
            {
                GatewayList.Enabled = true;
            }
        }

        protected void AddButton_Click(object sender, System.EventArgs e)
        {
            PaymentMethod method = new PaymentMethod();
            method.Name = Name.Text;
            method.PaymentInstrumentType = (PaymentInstrumentType)AlwaysConvert.ToInt16(PaymentInstrumentList.SelectedValue);
            method.PaymentGateway = PaymentGatewayDataSource.Load(AlwaysConvert.ToInt(GatewayList.SelectedValue));
            method.AllowSubscriptions = AllowSubscriptionPayments.Checked;
            //GROUP RESTRICTION
            if (UseGroupRestriction.SelectedIndex > 0)
            {
                foreach (ListItem item in GroupList.Items)
                {
                    Group group = GroupDataSource.Load(AlwaysConvert.ToInt(item.Value));
                    if (item.Selected) method.Groups.Add(group);
                }
            }
            method.OrderBy = (short)PaymentMethodDataSource.GetNextOrderBy();
            method.Save();
            //UPDATE THE ADD MESSAGE
            AddedMessage.Text = string.Format(AddedMessage.Text, method.Name);
            AddedMessage.Visible = true;
            //RESET THE ADD FORM
            PaymentInstrumentList.SelectedIndex = -1;
            Name.Text = string.Empty;
            GatewayList.SelectedIndex = -1;
            AllowSubscriptionPayments.Checked = false;
            UseGroupRestriction.SelectedIndex = 0;
            BindGroups();
            //TRIGER ANY EVENT ATTACHED TO THE UPDATE
            if (ItemAdded != null) ItemAdded(this, new PersistentItemEventArgs(method.Id, method.Name));
        }

        protected void UseGroupRestriction_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindGroups();
        }

        protected void BindGroups()
        {
            GroupListPanel.Visible = (UseGroupRestriction.SelectedIndex > 0);
            if (GroupListPanel.Visible)
            {
                GroupList.DataSource = GroupDataSource.LoadAll("Name");
                GroupList.DataBind();
            }
        }
    }
}
