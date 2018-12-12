namespace AbleCommerce.Admin.Products.GiftWrap
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;
    using AbleCommerce.Code;

    public partial class ViewProducts : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        WrapGroup _WrapGroup;
        private string _IconPath = string.Empty;

        protected void Page_Init(object sender, EventArgs e)
        {
            int wrapGroupId = AlwaysConvert.ToInt(Request.QueryString["WrapGroupId"]);
            _WrapGroup = WrapGroupDataSource.Load(wrapGroupId);
            if (_WrapGroup == null) Response.Redirect("Default.aspx");
            Caption.Text = string.Format(Caption.Text, _WrapGroup.Name);
            _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);
            FindAssignProducts1.AssignmentValue = _WrapGroup.Id;
            FindAssignProducts1.OnAssignProduct += new AssignProductEventHandler(FindAssignProducts1_AssignProduct);
            FindAssignProducts1.OnLinkCheck += new AssignProductEventHandler(FindAssignProducts1_LinkCheck);
            FindAssignProducts1.OnCancel += new EventHandler(FindAssignProducts1_CancelButton);
        }

        protected void FindAssignProducts1_AssignProduct(object sender, FindAssignProductEventArgs e)
        {
            SetWrapGroup(e.ProductId, e.Link);
        }

        protected void FindAssignProducts1_LinkCheck(object sender, FindAssignProductEventArgs e)
        {
            e.Link = IsProductLinked(e.Product);
        }

        protected void FindAssignProducts1_CancelButton(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        private void SetWrapGroup(int relatedProductId, bool linked)
        {
            Product product = ProductDataSource.Load(relatedProductId);
            if (product != null)
            {
                if (linked) product.WrapGroupId = _WrapGroup.Id;
                else product.WrapGroupId = 0;
                product.Save();
            }
        }

        protected bool IsProductLinked(Product product)
        {
            if (product != null)
            {
                return (product.WrapGroupId == _WrapGroup.Id);
            }
            return false;
        }
    }
}