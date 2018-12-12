using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.UI;
using CommerceBuilder.Products;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;

namespace AbleCommerce.Mobile
{
    public partial class ProductDescription : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_PreRender(object sender, EventArgs e)
        {
            int _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            Product _Product = ProductDataSource.Load(_ProductId);
            if (_Product != null)
            {
                ProductName.Text = _Product.Name;
                if (AbleContext.Current.Store.Settings.MobileStoreProductUseSummary)
                {
                    phDescription.Text = _Product.Description;
                }
                else
                {
                    MainDescription.Visible = false;
                }

                if (string.IsNullOrEmpty(_Product.ExtendedDescription))
                {
                    DetailedDescription.Visible = false;
                }
                else 
                {
                    DetailedDescription.Visible = true;
                    extDescription.Text = _Product.ExtendedDescription;
                }
            }
        }
    }
}