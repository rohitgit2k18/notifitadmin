namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    [Description("Display a list of custom fields of a product.")]
    public partial class ProductCustomFieldsDialog : System.Web.UI.UserControl
    {
        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                int _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
                Product _Product = ProductDataSource.Load(_ProductId);
                if (_Product != null)
                {
                    List<ProductTemplateField> templateFields = (from tf in _Product.TemplateFields
                                                                 where !string.IsNullOrEmpty(tf.InputValue) && tf.InputField.IsMerchantField
                                                                 select tf).OrderBy(x => x.InputField.OrderBy).ToList();

                    ProductTemplateFieldsList.DataSource = templateFields;
                    ProductTemplateFieldsList.DataBind();

                    //List<ProductCustomField> customFields = (from cf in _Product.CustomFields
                    //                                         where !string.IsNullOrEmpty(cf.FieldValue)
                    //                                         select cf).ToList();

                    //ProductCustomFieldsList.DataSource = customFields;
                    //ProductCustomFieldsList.DataBind();

                    this.Visible = (templateFields.Count > 0 /*|| customFields.Count > 0*/);
                }
            }
        }
    }
}