namespace AbleCommerce.Admin.Products.GiftWrap
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Products;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Utility;
    using CommerceBuilder.UI.WebControls;

    public partial class EditWrapStyleDialog : System.Web.UI.UserControl
    {
        public int WrapStyleId
        {
            get { return AlwaysConvert.ToInt(ViewState["WrapStyleId"]); }
            set { ViewState["WrapStyleId"] = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailUrl, BrowseThumbnailUrl);
                AbleCommerce.Code.PageHelper.SetPickImageButton(ImageUrl, BrowseImageUrl);
                //BIND TAXES
                TaxCode.DataSource = TaxCodeDataSource.LoadAll();
                TaxCode.DataBind();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            WrapStyle style = WrapStyleDataSource.Load(WrapStyleId);
            if (style != null)
            {
                Name.Text = style.Name;
                ThumbnailUrl.Text = style.ThumbnailUrl;
                ImageUrl.Text = style.ImageUrl;
                Price.Text = string.Format("{0:F2}", style.Price);
                TaxCode.SelectedIndex = -1;
                ListItem item = TaxCode.Items.FindByValue(style.TaxCodeId.ToString());
                if (item != null) item.Selected = true;
            }
        }

        private void DoneEditing()
        {
            UpdatePanel stylesAjax = AbleCommerce.Code.PageHelper.RecursiveFindControl(this.Page, "WrapStylesAjax") as UpdatePanel;
            if (stylesAjax != null)
            {
                GridView stylesGrid = AbleCommerce.Code.PageHelper.RecursiveFindControl(stylesAjax, "WrapStylesGrid") as GridView;
                if (stylesGrid != null)
                {
                    stylesGrid.EditIndex = -1;
                    stylesGrid.DataBind();
                }
                Panel addPanel = AbleCommerce.Code.PageHelper.RecursiveFindControl(stylesAjax, "AddPanel") as Panel;
                if (addPanel != null) addPanel.Visible = true;
                Panel editPanel = AbleCommerce.Code.PageHelper.RecursiveFindControl(stylesAjax, "EditPanel") as Panel;
                if (editPanel != null) editPanel.Visible = false;
                Notification savedMessage = AbleCommerce.Code.PageHelper.RecursiveFindControl(stylesAjax, "SavedWrapStyleMessage") as Notification;
                if (savedMessage != null)
                {
                    savedMessage.Visible = false;
                    string name = string.Empty;
                    WrapStyle style = WrapStyleDataSource.Load(WrapStyleId);
                    if (style != null) name = style.Name;
                    savedMessage.Text = string.Format(savedMessage.Text, name);
                }
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            DoneEditing();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveWrapStyle();
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                UpdatePanel stylesAjax = AbleCommerce.Code.PageHelper.RecursiveFindControl(this.Page, "WrapStylesAjax") as UpdatePanel;
                if (stylesAjax != null)
                {
                    GridView stylesGrid = AbleCommerce.Code.PageHelper.RecursiveFindControl(stylesAjax, "WrapStylesGrid") as GridView;
                    if (stylesGrid != null)
                    {
                        stylesGrid.DataBind();
                    }
                }
            }
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save the wrapstyle
                SaveWrapStyle();

                // redirect away
                DoneEditing();
            }
        }

        private void SaveWrapStyle()
        {
            WrapStyle style = WrapStyleDataSource.Load(WrapStyleId);
            style.Name = Name.Text;
            style.ThumbnailUrl = ThumbnailUrl.Text;
            style.ImageUrl = ImageUrl.Text;
            style.Price = AlwaysConvert.ToDecimal(Price.Text);
            style.TaxCodeId = AlwaysConvert.ToInt(TaxCode.SelectedValue);
            style.Save();
        }
    }
}