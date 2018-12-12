using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AbleCommerce.Admin.Website.Themes
{
    public partial class CSSBorder : System.Web.UI.UserControl
    {
        public string Value 
        {
            get 
            {
                return string.Format("{0} {1} #{2}", BorderWidth_Style.Text, BorderStyle_Style.SelectedValue, BorderColor_Style.Text).Trim();
            }

            set 
            {
                string[] tokens = value.Split(' ');
                if (tokens != null)
                {
                    if (tokens.Length > 0)
                        BorderWidth_Style.Text = tokens[0];
                    
                    if (tokens.Length > 1)
                    {
                        ListItem item = BorderStyle_Style.Items.FindByValue(tokens[1]);
                        if (item != null)
                            item.Selected = true;
                    }

                    if (tokens.Length > 2)
                        BorderColor_Style.Text = tokens[2].Replace("#", string.Empty);
                }
            }
        }

        public void ClearAttributesUI() 
        {
            BorderWidth_Style.Text = string.Empty;
            BorderStyle_Style.ClearSelection();
            BorderColor_Style.Text = string.Empty;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}