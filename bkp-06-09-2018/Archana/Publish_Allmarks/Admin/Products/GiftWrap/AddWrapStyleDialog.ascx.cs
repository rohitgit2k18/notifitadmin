namespace AbleCommerce.Admin.Products.GiftWrap
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class AddWrapStyleDialog : System.Web.UI.UserControl
    {
        public int WrapGroupId
        {
            get { return AlwaysConvert.ToInt(ViewState["WrapGroupId"]); }
            set { ViewState["WrapGroupId"] = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailUrl, BrowseThumbnailUrl);
            AbleCommerce.Code.PageHelper.SetPickImageButton(ImageUrl, BrowseImageUrl);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            AddButton.Visible = (WrapGroupId != 0);
        }

        protected void AddButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                WrapStyle style = new WrapStyle();
                style.WrapGroupId = WrapGroupId;
                style.Name = Name.Text;
                style.ThumbnailUrl = ThumbnailUrl.Text;
                style.ImageUrl = ImageUrl.Text;
                style.Price = AlwaysConvert.ToDecimal(Price.Text);
                style.TaxCodeId = AlwaysConvert.ToInt(TaxCode.SelectedValue);
                style.Save();
                Name.Text = string.Empty;
                ThumbnailUrl.Text = string.Empty;
                ImageUrl.Text = string.Empty;
                Price.Text = string.Empty;
                TaxCode.SelectedIndex = -1;
                AddedMessage.Text = string.Format(AddedMessage.Text, style.Name);
                AddedMessage.Visible = true;
                UpdatePanel panel = AbleCommerce.Code.PageHelper.RecursiveFindControl(this.Page, "WrapStylesAjax") as UpdatePanel;
                if (panel != null)
                {
                    GridView wrapStyleGrid = AbleCommerce.Code.PageHelper.RecursiveFindControl(panel, "WrapStylesGrid") as GridView;
                    if (wrapStyleGrid != null)
                    {
                        wrapStyleGrid.DataBind();
                        panel.Update();
                    }
                }
            }
        }
    }
}