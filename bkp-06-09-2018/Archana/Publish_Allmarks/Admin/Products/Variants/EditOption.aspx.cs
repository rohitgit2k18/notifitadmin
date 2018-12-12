namespace AbleCommerce.Admin.Products.Variants
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class EditOption : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        Option _Option;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            int optionId = AlwaysConvert.ToInt(Request.QueryString["OptionId"]);
            _Option = OptionDataSource.Load(optionId);
            if (_Option == null) Response.Redirect("Options.aspx?ProductId=" + AbleCommerce.Code.PageHelper.GetProductId());
            if (!Page.IsPostBack)
            {
                // initialize the form on first visit
                OptionName.Text = _Option.Name;
                HeaderText.Text = _Option.HeaderText;
                ShowThumbnails.Checked = _Option.ShowThumbnails;
                ThumbnailWidth.Text = _Option.ThumbnailWidth > 0 ? _Option.ThumbnailWidth.ToString() : string.Empty;
                ThumbnailHeight.Text = _Option.ThumbnailHeight > 0 ? _Option.ThumbnailHeight.ToString() : string.Empty;
                ThumbnailColumns.Text = _Option.ThumbnailColumns > 0 ? _Option.ThumbnailColumns.ToString() : string.Empty;
            }
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            //Save the option itself
            _Option.Name = OptionName.Text;
            _Option.HeaderText = HeaderText.Text;
            _Option.ShowThumbnails = ShowThumbnails.Checked;
            _Option.ThumbnailColumns = AlwaysConvert.ToByte(ThumbnailColumns.Text);
            _Option.ThumbnailHeight = AlwaysConvert.ToInt16(ThumbnailHeight.Text);
            _Option.ThumbnailWidth = AlwaysConvert.ToInt16(ThumbnailWidth.Text);
            _Option.Save();
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            SavedMessage.Visible = true;
        }

        protected void SaveCloseButton_Click(object sender, System.EventArgs e)
        {
            SaveButton_Click(sender, e);
            CancelButton_Click(sender, e);
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("Options.aspx?ProductId=" + AbleCommerce.Code.PageHelper.GetProductId());
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            Caption.Text = string.Format(Caption.Text, _Option.Name);
        }
    }
}