namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;

    public partial class EditAddresses : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Order _Order;

        protected void Page_Load(object sender, EventArgs e)
        {
            int orderId = AbleCommerce.Code.PageHelper.GetOrderId();
            _Order = OrderDataSource.Load(orderId);
            if (_Order == null) Response.Redirect("Default.aspx");
            CancelButon.NavigateUrl += "?OrderNumber=" + _Order.OrderNumber;
            if (!Page.IsPostBack)
            {
                BindBilling();
                BindShipping();
            }
        }

        protected void BindBilling()
        {
            //INITIALIZE VALUES
            Store store = AbleContext.Current.Store;
            BillToFirstName.Text = _Order.BillToFirstName;
            BillToLastName.Text = _Order.BillToLastName;
            BillToCompany.Text = _Order.BillToCompany;
            BillToAddress1.Text = _Order.BillToAddress1;
            BillToAddress2.Text = _Order.BillToAddress2;
            BillToCity.Text = _Order.BillToCity;
            BillToProvince.Text = _Order.BillToProvince;
            BillToPostalCode.Text = _Order.BillToPostalCode;
            BillToCountryCode.DataSource = store.Countries;
            BillToCountryCode.DataBind();
            ListItem selectedCountry = BillToCountryCode.Items.FindByValue(_Order.BillToCountryCode.ToString());
            if (selectedCountry != null) selectedCountry.Selected = true;
            BillToPhone.Text = _Order.BillToPhone;
            BillToEmail.Text = _Order.BillToEmail;
        }

        protected void BindShipping()
        {
            ShipmentRepeater.DataSource = _Order.Shipments;
            ShipmentRepeater.DataBind();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                //save addresses
                SaveAddresses();

                //show confirmation
                SavedMessage.Text = string.Format(SavedMessage.Text, DateTime.UtcNow.ToLocalTime());
                SavedMessage.Visible = true;
                EditAddressAjax.Update();
            }
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save addresses
                SaveAddresses();

                // redirect away
                Response.Redirect(CancelButon.NavigateUrl);
            }
        }

        private void SaveAddresses()
        {
            _Order.BillToFirstName = BillToFirstName.Text;
            _Order.BillToLastName = BillToLastName.Text;
            _Order.BillToCompany = BillToCompany.Text;
            _Order.BillToAddress1 = BillToAddress1.Text;
            _Order.BillToAddress2 = BillToAddress2.Text;
            _Order.BillToCity = BillToCity.Text;
            _Order.BillToProvince = BillToProvince.Text;
            _Order.BillToPostalCode = BillToPostalCode.Text;
            _Order.BillToCountryCode = BillToCountryCode.Items[BillToCountryCode.SelectedIndex].Value;
            _Order.BillToPhone = BillToPhone.Text;
            _Order.BillToEmail = BillToEmail.Text;
            int index = 0;
            foreach (OrderShipment shipment in _Order.Shipments)
            {
                RepeaterItem item = ShipmentRepeater.Items[index];
                shipment.ShipToFirstName = GetControlValue(item, "ShipToFirstName");
                shipment.ShipToLastName = GetControlValue(item, "ShipToLastName");
                shipment.ShipToCompany = GetControlValue(item, "ShipToCompany");
                shipment.ShipToAddress1 = GetControlValue(item, "ShipToAddress1");
                shipment.ShipToAddress2 = GetControlValue(item, "ShipToAddress2");
                shipment.ShipToCity = GetControlValue(item, "ShipToCity");
                shipment.ShipToProvince = GetControlValue(item, "ShipToProvince");
                shipment.ShipToPostalCode = GetControlValue(item, "ShipToPostalCode");
                shipment.ShipToCountryCode = GetControlValue(item, "ShipToCountryCode");
                shipment.ShipToPhone = GetControlValue(item, "ShipToPhone");
                index++;
            }
            _Order.Save(false, false);
        }
        protected void SetControlValue(Control parent, string controlName, string controlValue)
        {
            Control control = AbleCommerce.Code.PageHelper.RecursiveFindControl(parent, controlName);
            if (control != null)
            {
                TextBox tb = control as TextBox;
                if (tb != null) tb.Text = controlValue;
            }
        }

        protected string GetControlValue(Control parent, string controlName)
        {
            Control control = AbleCommerce.Code.PageHelper.RecursiveFindControl(parent, controlName);
            if (control != null)
            {
                TextBox tb = control as TextBox;
                if (tb != null) return tb.Text;
                DropDownList ddl = control as DropDownList;
                if (ddl != null) return ddl.Items[ddl.SelectedIndex].Value;
            }
            return string.Empty;
        }

        protected void ShipmentRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            OrderShipment shipment = (OrderShipment)e.Item.DataItem;
            SetControlValue(e.Item, "ShipToFirstName", shipment.ShipToFirstName);
            SetControlValue(e.Item, "ShipToLastName", shipment.ShipToLastName);
            SetControlValue(e.Item, "ShipToCompany", shipment.ShipToCompany);
            SetControlValue(e.Item, "ShipToAddress1", shipment.ShipToAddress1);
            SetControlValue(e.Item, "ShipToAddress2", shipment.ShipToAddress2);
            SetControlValue(e.Item, "ShipToCity", shipment.ShipToCity);
            SetControlValue(e.Item, "ShipToProvince", shipment.ShipToProvince);
            SetControlValue(e.Item, "ShipToPostalCode", shipment.ShipToPostalCode);
            DropDownList shipToCountry = (DropDownList)AbleCommerce.Code.PageHelper.RecursiveFindControl(e.Item, "ShipToCountryCode");
            shipToCountry.DataSource = AbleContext.Current.Store.Countries;
            shipToCountry.DataBind();
            ListItem selectedCountry = shipToCountry.Items.FindByValue(shipment.ShipToCountryCode.ToString());
            if (selectedCountry != null) selectedCountry.Selected = true;
            SetControlValue(e.Item, "ShipToPhone", shipment.ShipToPhone);
        }
    }
}