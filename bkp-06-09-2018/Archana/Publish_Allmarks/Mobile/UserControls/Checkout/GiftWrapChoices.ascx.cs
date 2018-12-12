namespace AbleCommerce.Mobile.UserControls.Checkout
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Products;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Taxes;
    using AbleCommerce.Code;
    using CommerceBuilder.Stores;
    using System.Text;
    using CommerceBuilder.Users;

    public partial class GiftWrapChoices : System.Web.UI.UserControl
    {
        // these hold the initial values from the calling parent control
        private string _GiftMessage;
        private int _WrapStyleId = 0;
        private IList<WrapStyle> _wrapStyles;
        public int BasketItemId { get; set; }
        
        public int WrapStyleId
        {
            get
            {
                return AlwaysConvert.ToInt(Request.Form[this.UniqueID + "_Wrap" + this.BasketItemId.ToString()]);
            }
            set 
            {
                _WrapStyleId = value; 
            }
        }

        public string GiftMessage
        {
            get { return Request.Form[InnerGiftMessage.UniqueID]; }
            set { _GiftMessage = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            BasketItem item = BasketItemDataSource.Load(BasketItemId);
            WrapGroup wrapGroup = item.Product.WrapGroup;
            if (wrapGroup != null)
                _wrapStyles = wrapGroup.WrapStyles;
            
            BuildWrapStyleList();

            if (!Page.IsPostBack)
            {
                // load initial values from calling parent control
                this.InnerGiftMessage.Text = _GiftMessage;
            }
        }

        protected void BuildWrapStyleList()
        {
            StoreSettingsManager settings =  AbleContext.Current.Store.Settings;
            int thumbnailHeight = settings.ThumbnailImageHeight;
            int thumbnailWidth = settings.ThumbnailImageWidth;
            if (phWrapStyle != null)
            {
                StringBuilder table = new StringBuilder();
                string selected = (_WrapStyleId == 0) ? " checked" : string.Empty;
                string radioButton = string.Format("<input type=\"radio\" name=\"{0}_Wrap{1}\" value=\"{2}\"{3}>&nbsp;", this.UniqueID, this.BasketItemId, 0, selected);
                table.Append("<br /><div class='wrapStyle' style=\"padding:2px 4px;\">");
                table.Append("<table cellpadding='0' cellspacing='0'>");
                table.Append("<tr>");
                table.Append("<td>");
                table.Append(radioButton + "None");
                table.Append("</td>");
                table.Append("</tr>");
                table.Append("</table></div>");
                
                //GET WRAP STYLE
                for (int i = 0; i < _wrapStyles.Count; i++)
                {
                    WrapStyle style = _wrapStyles[i];
                    table.Append("<div class='wrapStyle' style=\"padding:2px 4px;\">");
                    //ADD RADIO BUTTON
                    selected = (_WrapStyleId == style.Id) ? " checked" : string.Empty;
                    radioButton = string.Format("<input type=\"radio\" name=\"{0}_Wrap{1}\" value=\"{2}\"{3}>&nbsp;", this.UniqueID, this.BasketItemId, style.Id, selected);
                    table.Append("<table cellpadding='0' cellspacing='0'>");
                    table.Append("<tr>");
                    table.Append("<td>");
                    table.Append(radioButton);
                    //ADD NAME
                    if (style.Price > 0)
                    {
                        //NAME WITH PRICE
                        table.Append(string.Format("<span>{0}({1})</span>", style.Name, style.Price.LSCurrencyFormat("ulc")));
                    }
                    else
                    {
                        //JUST NAME
                        table.Append(string.Format("<span>{0}</span>", style.Name));
                    }
                    table.Append("</td>");
                    if (!string.IsNullOrEmpty(style.ThumbnailUrl))
                    {
                        table.Append("<td>");
                        //ADD CLICKABLE IMAGE
                        string thumbnailUrl = string.IsNullOrEmpty(style.ThumbnailUrl) ? "" : style.ThumbnailUrl;
                        string image = string.Format("<img src=\"{0}\" border=\"0\" vspace=\"2\" height=\"" + thumbnailHeight + "\" width=\"" + thumbnailWidth + "\" alt=\"" + Server.HtmlEncode(style.Name) + "\" />", this.Page.ResolveUrl(thumbnailUrl));
                        if (!string.IsNullOrEmpty(style.ImageUrl))
                        {
                            //CLICKABLE THUMBNAIL
                            string link = "<a href=\"#\" onclick=\"{0}\">{1}</a>";
                            string popup = PageHelper.GetPopUpScript(this.Page.ResolveUrl(style.ImageUrl), "giftwrapimage", 300, 300);
                            table.Append(string.Format(link, popup, image));
                        }
                        else
                        {
                            //STATIC THUMBNAIL ONLY
                            table.Append(image);
                        }
                        table.Append("</td>");
                    }
                    table.Append("</tr>");
                    table.Append("</table>");
                    table.Append("</div>");
                }
                phWrapStyle.Controls.Add(new LiteralControl(table.ToString()));
            }
        }
    }
}