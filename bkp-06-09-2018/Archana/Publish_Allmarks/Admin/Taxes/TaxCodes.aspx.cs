using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Taxes;
using CommerceBuilder.Services.Taxes.AbleCommerce;
using CommerceBuilder.Utility;
using System.Collections.Generic;
using NHibernate;
using CommerceBuilder.DomainModel;
using NHibernate.Criterion;

namespace AbleCommerce.Admin.Taxes
{
    public partial class TaxCodes : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void AddButton_Click(object sender, EventArgs e)
        {
            // DUPLICATE TAX CODE NAMES SHOULD NOT BE ALLOWED                        
            ICriteria criteria = NHibernateHelper.CreateCriteria<TaxCode>()
                .Add(Restrictions.Like("Name", StringHelper.SafeSqlString(AddTaxCodeName.Text)));
            IList<TaxCode> tempCollection = TaxCodeDataSource.LoadForCriteria(criteria);
            if (tempCollection.Count > 0)
            {   
                // TAX RULE(S) WITH SAME NAME ALREADY EXIST
                CustomValidator customNameValidator = new CustomValidator();
                customNameValidator.ValidationGroup = "Add";
                customNameValidator.ControlToValidate = "AddTaxCodeName";
                customNameValidator.Text = "*";
                customNameValidator.ErrorMessage = "A Tax Code with the same name <strong>" + AddTaxCodeName.Text + "</strong> already exists.";
                customNameValidator.IsValid = false;
                phNameValidator.Controls.Add(customNameValidator);

                return;
            }


            TaxCode t = new TaxCode();
            t.Name = AddTaxCodeName.Text;
            t.Save();
            TaxCodeGrid.DataBind();
            AddTaxCodeName.Text = string.Empty;
        }

        protected void TaxCodeGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int taxCodeId = AlwaysConvert.ToInt(TaxCodeGrid.DataKeys[e.RowIndex].Value);
            TaxCode t = TaxCodeDataSource.Load(taxCodeId);
            TextBox Name = (TextBox)TaxCodeGrid.Rows[e.RowIndex].FindControl("Name");
            if (t != null && Name != null)
            {

                // IF NAME IS CHANGED DUPLICATE TAX CODE NAMES SHOULD NOT BE ALLOWED                        
                if (t.Name != Name.Text)
                {
                    ICriteria criteria = NHibernateHelper.CreateCriteria<TaxCode>()
                        .Add(Restrictions.Like("Name", StringHelper.SafeSqlString(AddTaxCodeName.Text)));
                    IList<TaxCode> tempCollection = TaxCodeDataSource.LoadForCriteria(criteria);
                    if (tempCollection.Count > 0)
                    {
                        PlaceHolder phGridNameValidator = (PlaceHolder)TaxCodeGrid.Rows[e.RowIndex].FindControl("phGridNameValidator");
                        // TAX RULE(S) WITH SAME NAME ALREADY EXIST
                        CustomValidator customNameValidator = new CustomValidator();
                        customNameValidator.ValidationGroup = "EditTaxRule";
                        customNameValidator.ControlToValidate = "Name";
                        customNameValidator.Text = "A Tax Code with the same name already exists.";
                        customNameValidator.ErrorMessage = "A Tax Code with the same name already exists.";
                        customNameValidator.IsValid = false;
                        phGridNameValidator.Controls.Add(customNameValidator);

                        e.Cancel = true;
                        return;
                    }
                }

                t.Name = Name.Text;
                t.Save();
            }
            e.Cancel = true;
            TaxCodeGrid.EditIndex = -1;
            TaxCodeGrid.DataBind();
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            AbleCommerce.Code.PageHelper.SetDefaultButton(AddTaxCodeName, AddButton.ClientID);
	    }
    }
}
