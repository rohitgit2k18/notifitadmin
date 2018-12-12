using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using CommerceBuilder.Common;
using CommerceBuilder.DigitalDelivery;
using CommerceBuilder.Products;
using CommerceBuilder.Utility;
using System.Collections.Generic;

namespace AbleCommerce.Admin.DigitalGoods
{
    public partial class ViewProducts : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _DigitalGoodId;
        private DigitalGood _DigitalGood;
        
        protected void Page_InIt(object sender, EventArgs e)
        {
            _DigitalGoodId = AlwaysConvert.ToInt(Request.QueryString["DigitalGoodId"]);
            _DigitalGood = DigitalGoodDataSource.Load(_DigitalGoodId);
            if (_DigitalGood == null) Response.Redirect("Default.aspx");
            Caption.Text = string.Format(Caption.Text, _DigitalGood.Name);
            FindAssignProducts1.AssignmentValue = _DigitalGoodId;
            FindAssignProducts1.OnAssignProduct += new AssignProductEventHandler(FindAssignProducts1_AssignProduct);
            FindAssignProducts1.OnLinkCheck += new AssignProductEventHandler(FindAssignProducts1_LinkCheck);
            FindAssignProducts1.OnCancel += new EventHandler(FindAssignProducts1_CancelButton);
        }

        protected void FindAssignProducts1_AssignProduct(object sender, FindAssignProductEventArgs e)
        {
            if (e.Link)
                AssociateProduct(e.ProductId);
            else
                ReleaseProduct(e.ProductId);
        }

        protected void FindAssignProducts1_LinkCheck(object sender, FindAssignProductEventArgs e)
        {
            e.Link = IsProductAssciated(e.Product);
        }

        protected void FindAssignProducts1_CancelButton(object sender, EventArgs e)
        {
            Response.Redirect("DigitalGoods.aspx");
        }

        private void AssociateProduct(int relatedProductId)
        {
            Product product = ProductDataSource.Load(relatedProductId);
            if (product != null)
            {
                if (!IsProductAssciated(product))
                {
                    ProductDigitalGood pgd = new ProductDigitalGood();
                    pgd.ProductId = product.Id;
                    pgd.DigitalGoodId = _DigitalGoodId;
                    pgd.Save();
                    _DigitalGood.ProductDigitalGoods.Add(pgd);
                    product.DigitalGoods.Add(pgd);
                }
            }
        }

        private void ReleaseProduct(int relatedProductId)
        {
            Product product = ProductDataSource.Load(relatedProductId);
            if (product != null)
            {
                int index = -1;
                for (int i = 0; i < _DigitalGood.ProductDigitalGoods.Count; i++)
                {
                    ProductDigitalGood pgd = _DigitalGood.ProductDigitalGoods[i];
                    if (pgd.DigitalGoodId == _DigitalGoodId && pgd.ProductId == relatedProductId)
                    {
                        index = i;
                        break;
                    }
                }
                if (index > -1)
                {
                    _DigitalGood.ProductDigitalGoods.DeleteAt(index);
                    _DigitalGood.ProductDigitalGoods.Save();
                }
            }
        }

        protected bool IsProductAssciated(Product product)
        {
            if (product != null)
            {
                foreach (ProductDigitalGood pgd in product.DigitalGoods)
                {
                    if (pgd.DigitalGoodId == _DigitalGoodId) return true;
                }
            }
            return false;
        }
    }
}
