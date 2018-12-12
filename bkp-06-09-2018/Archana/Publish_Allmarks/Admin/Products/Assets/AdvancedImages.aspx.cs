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
using System.Text.RegularExpressions;
using CommerceBuilder.Common;
using CommerceBuilder.Catalog;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Reporting;
using System.Collections.Generic;

namespace AbleCommerce.Admin.Products.Assets
{
public partial class AdvancedImages : CommerceBuilder.UI.AbleCommerceAdminPage
{

    private int _ProductId;
    private Product _Product;

    protected void Page_Init(object sender, EventArgs e)
    {
        AbleCommerce.Code.PageHelper.SetPickImageButton(IconImageUrl, BrowseIconUrl);
        AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailImageUrl, BrowseThumbnailUrl);
        AbleCommerce.Code.PageHelper.SetPickImageButton(StandardImageUrl, BrowseStandardUrl);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
        _Product = ProductDataSource.Load(_ProductId);
        if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
        CancelButton.NavigateUrl += _ProductId;
        BindImages();
    }

    public void BindImages()
    {
        Caption.Text = string.Format(Caption.Text, _Product.Name);
        if (!Page.IsPostBack)
        {
            IconImageUrl.Text = _Product.IconUrl;
            IconImageAltText.Text = _Product.IconAltText;
            ThumbnailImageUrl.Text = _Product.ThumbnailUrl;
            ThumbnailImageAltText.Text = _Product.ThumbnailAltText;
            StandardImageUrl.Text = _Product.ImageUrl;
            StandardImageAltText.Text = _Product.ImageAltText;
        }
        if (_Product.Images.Count > 0)
        {
            AdditionalImagesRepeater.Visible = true;
            AdditionalImagesRepeater.DataSource = _Product.Images;
            AdditionalImagesRepeater.DataBind();
        }
        else AdditionalImagesRepeater.Visible = false;
    }

    private void SaveImages()
    {
        _Product.IconUrl = IconImageUrl.Text;
        _Product.IconAltText = IconImageAltText.Text;
        _Product.ThumbnailUrl = ThumbnailImageUrl.Text;
        _Product.ThumbnailAltText = ThumbnailImageAltText.Text;
        _Product.ImageUrl = StandardImageUrl.Text;
        _Product.ImageAltText = StandardImageAltText.Text;
        int index = 0;
        foreach (RepeaterItem item in AdditionalImagesRepeater.Items)
        {
            ProductImage image = _Product.Images[index];
            TextBox imageUrl = item.FindControl("ImageUrl") as TextBox;
            if (imageUrl != null) image.ImageUrl = imageUrl.Text;
            TextBox altText = item.FindControl("AltText") as TextBox;
            if (altText != null) image.ImageAltText = altText.Text;
            TextBox moniker = item.FindControl("Moniker") as TextBox;
            if (altText != null) image.Moniker = moniker.Text.Trim();

            index++;
        }
        _Product.Save();
    }

    protected void AdditionalImagesRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            ImageButton browse = e.Item.FindControl("Browse") as ImageButton;
            TextBox url = e.Item.FindControl("ImageUrl") as TextBox;
            if (browse != null && url != null)
            {
                browse.OnClientClick = "return PickImage('" + url.ClientID + "')";
            }
        }
    }

    protected void AdditionalImagesRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            int productImageId = AlwaysConvert.ToInt(e.CommandArgument);
            int index = _Product.Images.IndexOf(productImageId);
            if (index > -1) _Product.Images.DeleteAt(index);
            BindImages();
        }
    }

    protected void AddImageButton_Click(object sender, EventArgs e)
    {
        SaveImages();
        ProductImage image = new ProductImage();
        image.ProductId = _ProductId;
        image.ImageUrl = string.Empty;
        image.Save();
        _Product.Images.Add(image);
        BindImages();
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        SaveImages();
        BindImages();
        SavedMessage.Visible = true;
        SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
    }

    public void SaveAndCloseButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            // save 
            SaveImages();

            // redirect away
            Response.Redirect(CancelButton.NavigateUrl);
        }
    }

    protected void BasicImages_Click(object sender, EventArgs e)
    {
        SaveImages();
        Response.Redirect("Images.aspx?ProductId=" + _ProductId);
    }

    protected void AdditionalImages_Click(object sender, EventArgs e)
    {
        SaveImages();
        Response.Redirect("AdditionalImages.aspx?ProductId=" + _ProductId);
    }
    

}
}
