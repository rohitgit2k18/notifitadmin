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

    public partial class AddTaxRule : CommerceBuilder.UI.AbleCommerceAdminPage
    {
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
            ListItem item = new ListItem("Round to Even", ((int)CommerceBuilder.Taxes.RoundingRule.RoundToEven).ToString());
            item.Selected = true;
            RoundingRule.Items.Add(item);
            RoundingRule.Items.Add(new ListItem("Always Round Up", ((int)CommerceBuilder.Taxes.RoundingRule.AlwaysRoundUp).ToString()));
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            trZoneList.Visible = (ZoneRule.SelectedIndex > 0);
            trAddressNexus.Visible = trZoneList.Visible;
            trGroupList.Visible = (GroupRule.SelectedIndex > 0);
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
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
                //SAVE TAX RULE
                TaxRule taxRule = new TaxRule();
                taxRule.Name = Name.Text;
                taxRule.TaxRate = AlwaysConvert.ToDecimal(TaxRate.Text);
                taxRule.UseBillingAddress = AlwaysConvert.ToBool(UseBillingAddress.SelectedValue.Equals("1"), false);
                taxRule.TaxCodeId = AlwaysConvert.ToInt(TaxCode.SelectedValue);
                taxRule.Priority = AlwaysConvert.ToInt16(Priority.Text);
                taxRule.UsePerItemTax = PerUnitCalculation.Checked;
                taxRule.Save();
                //UPDATE TAX CODES
                taxRule.TaxCodes.Clear();
                taxRule.Save();
                foreach (ListItem listItem in TaxCodes.Items)
                {
                    if (listItem.Selected)
                    {
                        TaxCode taxCode = TaxCodeDataSource.Load(AlwaysConvert.ToInt(listItem.Value));
                        taxRule.TaxCodes.Add(taxCode);
                        listItem.Selected = false;
                    }
                }
                //UPDATE ZONES
                taxRule.ShipZones.Clear();
                if (ZoneRule.SelectedIndex > 0)
                {
                    foreach (ListItem item in ZoneList.Items)
                    {
                        ShipZone shipZone = ShipZoneDataSource.Load(AlwaysConvert.ToInt(item.Value));
                        if (item.Selected) taxRule.ShipZones.Add(shipZone);
                    }
                }
                //UPDATE GROUP FILTER
                taxRule.Groups.Clear();
                taxRule.GroupRule = (FilterRule)GroupRule.SelectedIndex;
                if (taxRule.GroupRule != FilterRule.All)
                {
                    foreach (ListItem item in GroupList.Items)
                    {
                        Group group = GroupDataSource.Load(AlwaysConvert.ToInt(item.Value));
                        if (item.Selected) taxRule.Groups.Add(group);
                    }
                }
                //IF NO GROUPS ARE SELECTED, APPLY TO ALL GROUPS
                if (taxRule.Groups.Count == 0) taxRule.GroupRule = FilterRule.All;

                // UPDATE ROUNDING RULE
                taxRule.RoundingRuleId = AlwaysConvert.ToByte(RoundingRule.SelectedValue);

                taxRule.Save();
                //UPDATE THE ADD MESSAGE
                Response.Redirect("TaxRules.aspx");
            }
        }
    }
}