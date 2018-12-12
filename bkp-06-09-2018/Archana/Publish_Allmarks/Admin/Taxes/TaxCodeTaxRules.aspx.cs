namespace AbleCommerce.Admin.Taxes
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Utility;

    public partial class TaxCodeTaxRules : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _TaxCodeId;
        private TaxCode _TaxCode;

        protected void Page_Load(object sender, EventArgs e)
        {
            _TaxCodeId = AlwaysConvert.ToInt(Request.QueryString["TaxCodeId"]);
            _TaxCode = TaxCodeDataSource.Load(_TaxCodeId);
            if (_TaxCode == null) Response.Redirect("TaxCodes.aspx");
            if (!Page.IsPostBack)
            {
                Caption.Text = string.Format(Caption.Text, _TaxCode.Name);
            }
        }

        protected bool IsLinked(object dataItem)
        {
            TaxRule rule = (TaxRule)dataItem;
            return (rule.TaxCodes.IndexOf(_TaxCode) > -1);
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            _TaxCode.TaxRules.Clear();
            foreach (GridViewRow gvr in TaxRuleGrid.Rows)
            {
                int taxRuleId = (int)TaxRuleGrid.DataKeys[gvr.DataItemIndex].Value;
                TaxRule taxRule = TaxRuleDataSource.Load(taxRuleId);
                CheckBox Linked = gvr.FindControl("Linked") as CheckBox;
                if (Linked.Checked)
                {
                    if (taxRule.TaxCodes.IndexOf(_TaxCode) < 0)
                    {
                        taxRule.TaxCodes.Add(_TaxCode);
                        taxRule.Save();
                    }
                    _TaxCode.TaxRules.Add(taxRule);
                }
                else
                {
                    if (taxRule.TaxCodes.IndexOf(_TaxCode) > -1)
                    {
                        taxRule.TaxCodes.Remove(_TaxCode);
                        taxRule.Save();
                    }
                }
            }
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }
    }
}