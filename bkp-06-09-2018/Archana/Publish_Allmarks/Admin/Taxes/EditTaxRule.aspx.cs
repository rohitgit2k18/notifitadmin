namespace AbleCommerce.Admin.Taxes
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class EditTaxRule : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _TaxRuleId;
        private TaxRule _TaxRule;

        protected void Page_Init()
        {
            IList<TaxCode> taxCodes = TaxCodeDataSource.LoadAll();
            TaxCodes.DataSource = taxCodes;
            TaxCodes.DataBind();
            TaxCode.Items.Clear();
            TaxCode.Items.Add("");
            TaxCode.DataSource = taxCodes;
            TaxCode.DataBind();
            ZoneList.DataSource = ShipZoneDataSource.LoadAll("Name");
            ZoneList.DataBind();
            GroupList.DataSource = GroupDataSource.LoadAll("Name");
            GroupList.DataBind();

            // ROUNDING RULE
            RoundingRule.Items.Clear();
            RoundingRule.Items.Add(new ListItem("Common Method", ((int)CommerceBuilder.Taxes.RoundingRule.Common).ToString()));
            RoundingRule.Items.Add(new ListItem("Round to Even", ((int)CommerceBuilder.Taxes.RoundingRule.RoundToEven).ToString()));
            RoundingRule.Items.Add(new ListItem("Always Round Up", ((int)CommerceBuilder.Taxes.RoundingRule.AlwaysRoundUp).ToString()));
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            trZoneList.Visible = (ZoneRule.SelectedIndex > 0);
            trAddressNexus.Visible = trZoneList.Visible;
            trGroupList.Visible = (GroupRule.SelectedIndex > 0);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _TaxRuleId = AlwaysConvert.ToInt(Request.QueryString["TaxRuleId"]);
            _TaxRule = TaxRuleDataSource.Load(_TaxRuleId);
            if (_TaxRule == null) Response.Redirect("TaxRules.aspx");
            Caption.Text = string.Format(Caption.Text, _TaxRule.Name);
            if (!Page.IsPostBack)
            {
                Name.Text = _TaxRule.Name;
                foreach (ListItem taxCodeItem in this.TaxCodes.Items)
                {
                    TaxCode taxCode = TaxCodeDataSource.Load(AlwaysConvert.ToInt(taxCodeItem.Value));
                    taxCodeItem.Selected = (_TaxRule.TaxCodes.IndexOf(taxCode) > -1);
                }
                TaxRate.Text = string.Format("{0:0.00##}", _TaxRule.TaxRate);
                ZoneRule.SelectedIndex = (_TaxRule.ShipZones.Count == 0) ? 0 : 1;
                foreach (ShipZone item in _TaxRule.ShipZones)
                {
                    ListItem listItem = ZoneList.Items.FindByValue(item.Id.ToString());
                    if (listItem != null) listItem.Selected = true;
                }
                UseBillingAddress.SelectedIndex = _TaxRule.UseBillingAddress ? 1 : 0;
                GroupRule.SelectedIndex = _TaxRule.GroupRuleId;
                foreach (Group item in _TaxRule.Groups)
                {
                    ListItem listItem = GroupList.Items.FindByValue(item.Id.ToString());
                    if (listItem != null) listItem.Selected = true;
                }
                ListItem selectedCode = TaxCode.Items.FindByValue(_TaxRule.TaxCodeId.ToString());
                if (selectedCode != null) selectedCode.Selected = true;
                Priority.Text = _TaxRule.Priority.ToString();


                ListItem roundingRuleItem = RoundingRule.Items.FindByValue(_TaxRule.RoundingRuleId.ToString());
                if (roundingRuleItem != null)
                {
                    RoundingRule.SelectedItem.Selected = false;
                    roundingRuleItem.Selected = true;
                }

                PerUnitCalculation.Checked = _TaxRule.UsePerItemTax;
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveTaxRule();
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            }
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveTaxRule();
                Response.Redirect("TaxRules.aspx");
            }
        }

        private void SaveTaxRule()
        {
            //CHECK IF NAME WAS CHANGED
            if (_TaxRule.Name != Name.Text)
            {
                // DUPLICATE TAX RULE NAMES SHOULD NOT BE ALLOWED                        
                int taxRuleId = TaxRuleDataSource.GetTaxRuleIdByName(Name.Text);
                if (taxRuleId > 0)
                {
                    // TAX RULE(S) WITH SAME NAME ALREADY EXIST
                    CustomValidator customNameValidator = new CustomValidator();
                    customNameValidator.ControlToValidate = "Name";
                    customNameValidator.Text = "*";
                    customNameValidator.ErrorMessage = "A Tax Rule with the same name already exists.";
                    customNameValidator.IsValid = false;
                    phNameValidator.Controls.Add(customNameValidator);
                    return;
                }
            }
            //SAVE TAX RULE
            _TaxRule.Name = Name.Text;
            _TaxRule.TaxRate = AlwaysConvert.ToDecimal(TaxRate.Text);
            _TaxRule.UseBillingAddress = AlwaysConvert.ToBool(UseBillingAddress.SelectedValue.Equals("1"), false);
            _TaxRule.TaxCodeId = AlwaysConvert.ToInt(TaxCode.SelectedValue);
            _TaxRule.Priority = AlwaysConvert.ToInt16(Priority.Text);
            _TaxRule.UsePerItemTax = PerUnitCalculation.Checked;
            _TaxRule.Save();
            //UPDATE TAX CODES
            _TaxRule.TaxCodes.Clear();
            foreach (ListItem listItem in TaxCodes.Items)
            {
                if (listItem.Selected)
                {
                    TaxCode taxCode = TaxCodeDataSource.Load(AlwaysConvert.ToInt(listItem.Value));
                    _TaxRule.TaxCodes.Add(taxCode);
                }
            }
            //UPDATE ZONES
            _TaxRule.ShipZones.Clear();
            if (ZoneRule.SelectedIndex > 0)
            {
                foreach (ListItem item in ZoneList.Items)
                {
                    ShipZone shipZone = ShipZoneDataSource.Load(AlwaysConvert.ToInt(item.Value));
                    if (item.Selected) _TaxRule.ShipZones.Add(shipZone);
                }
            }
            //UPDATE GROUP FILTER
            _TaxRule.Groups.Clear();
            _TaxRule.Save();
            _TaxRule.GroupRule = (FilterRule)GroupRule.SelectedIndex;
            if (_TaxRule.GroupRule != FilterRule.All)
            {
                foreach (ListItem item in GroupList.Items)
                {
                    Group group = GroupDataSource.Load(AlwaysConvert.ToInt(item.Value));
                    if (item.Selected) _TaxRule.Groups.Add(group);
                }
            }
            //IF NO GROUPS ARE SELECTED, APPLY TO ALL GROUPS
            if (_TaxRule.Groups.Count == 0) _TaxRule.GroupRule = FilterRule.All;

            // UPDATE ROUNDING RULE
            _TaxRule.RoundingRuleId = AlwaysConvert.ToByte(RoundingRule.SelectedValue);

            _TaxRule.Save();            
        }
    }
}