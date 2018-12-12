namespace AbleCommerce.Admin.Products.Variants
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class EditChoices : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        Option _Option;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            int optionId = AlwaysConvert.ToInt(Request.QueryString["OptionId"]);
            bool showthumbnail = Convert.ToBoolean(Request.QueryString["ShowThumbnail"]);
            _Option = OptionDataSource.Load(optionId);
            if (_Option == null) Response.Redirect("Options.aspx?ProductId=" + AbleCommerce.Code.PageHelper.GetProductId());

            if (!Page.IsPostBack)
            {
                BindChoicesGrid();
            }

            if (showthumbnail)
            {
                AddChoiceThumbnailRequried.Enabled = showthumbnail;
            }

            Caption.Text = string.Format(Caption.Text, _Option.Name);
            AbleCommerce.Code.PageHelper.SetPickImageButton(AddChoiceThumbnail, BrowseThumbnail);
            AbleCommerce.Code.PageHelper.SetPickImageButton(AddChoiceImage, BrowseImage);
        }

        protected bool HasChoices()
        {
            return _Option != null && _Option.Choices.Count > 0;
        }

        protected void BindChoicesGrid()
        {
            OptionChoicesGrid.DataSource = _Option.Choices;
            OptionChoicesGrid.DataBind();
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("Options.aspx?ProductId=" + AbleCommerce.Code.PageHelper.GetProductId());
        }

        private string GetControlValue(GridViewRow row, string controlId)
        {
            TextBox tb = row.FindControl(controlId) as TextBox;
            if (tb != null) return tb.Text;
            return String.Empty;
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            // DETERMINE START INDEX
            OptionChoice opt;
            foreach (GridViewRow row in OptionChoicesGrid.Rows)
            {
                // LOCATE THE SKU, PRICE, WEIGHT, COST
                // GET VARIANT AT THIS INDEX
                opt = _Option.Choices[row.DataItemIndex];
                string name = GetControlValue(row, "Name").Trim();
                if (!string.IsNullOrEmpty(name)) opt.Name = name;
                opt.ThumbnailUrl = GetControlValue(row, "ThumbnailUrl").Trim();
                opt.ImageUrl = GetControlValue(row, "ImageUrl").Trim();
                opt.PriceModifier = AlwaysConvert.ToDecimal(GetControlValue(row, "PriceMod"));
                opt.MsrpModifier = AlwaysConvert.ToDecimal(GetControlValue(row, "RetailMod"));
                opt.WeightModifier = AlwaysConvert.ToDecimal(GetControlValue(row, "WeightMod"));
                opt.SkuModifier = GetControlValue(row, "SkuMod").Trim();

                CheckBox selected = row.FindControl("Selected") as CheckBox;
                if (selected != null)
                {
                    opt.Selected = selected.Checked;
                }

                opt.Save();
                UpdateMessage.Visible = true;
                UpdateMessage.Text = string.Format(UpdateMessage.Text, LocaleHelper.LocalNow);
            }

            //Rebind choices
            BindChoicesGrid();
        }

        protected void SaveCloseButton_Click(object sender, System.EventArgs e)
        {
            SaveButton_Click(sender, e);
            CancelButton_Click(sender, e);
        }

        protected void OptionChoicesGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //HOOK UP BROWSE THUMBNAIL
                TextBox ThumbnailUrl = e.Row.FindControl("ThumbnailUrl") as TextBox;
                ImageButton BrowseButton = e.Row.FindControl("BrowseThumbnailUrl") as ImageButton;
                if ((ThumbnailUrl != null) && (BrowseButton != null))
                {
                    AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailUrl, BrowseButton);
                }
                //HOOK UP BROWSE IMAGE
                TextBox ImageUrl = e.Row.FindControl("ImageUrl") as TextBox;
                ImageButton BrowseImageButton = e.Row.FindControl("BrowseImageUrl") as ImageButton;
                if ((ImageUrl != null) && (BrowseImageButton != null))
                {
                    AbleCommerce.Code.PageHelper.SetPickImageButton(ImageUrl, BrowseImageButton);
                }
            }
        }

        protected void OptionChoicesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            IList<OptionChoice> options = _Option.Choices;
            int itemIndex = AlwaysConvert.ToInt(e.CommandArgument);
            OptionChoice selectedOption;
            switch (e.CommandName)
            {
                case "MoveUp":
                    if ((itemIndex < 1) || (itemIndex > (options.Count - 1))) return;
                    selectedOption = options[itemIndex];
                    options[itemIndex] = options[(itemIndex - 1)];
                    options[(itemIndex - 1)] = selectedOption;
                    break;
                case "MoveDown":
                    if ((itemIndex > (options.Count - 2)) || (itemIndex < 0)) return;
                    selectedOption = options[itemIndex];
                    options[itemIndex] = options[(itemIndex + 1)];
                    options[(itemIndex + 1)] = selectedOption;
                    break;
                default:
                    return;
            }
            ResetOrderBy();
            options.Save();
            BindChoicesGrid();
        }

        protected void OptionChoicesGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int optionId = (int)OptionChoicesGrid.DataKeys[e.RowIndex].Value;
            //FIND THE OPTION
            IList<OptionChoice> options = _Option.Choices;
            int index = -1;
            int i = 0;
            while ((i < options.Count) && (index < 0))
            {
                if (options[i].Id == optionId) index = i;
                i++;
            }
            if (index >= 0)
            {
                options.DeleteAt(index);
                //REBUILD VARIANT GRID FOR THIS PRODUCT
                int productId = AbleCommerce.Code.PageHelper.GetProductId();
                if (productId > 0) ProductVariantManager.ScrubVariantGrid(productId, optionId);
                BindChoicesGrid();
            }
        }

        protected void ResetOrderBy()
        {
            IList<OptionChoice> options = _Option.Choices;
            for (short i = 0; i < options.Count; i++)
            {
                options[i].OrderBy = i;
            }
        }

        protected string ZeroAsEmpty(object dataItem)
        {
            if (dataItem == null) return string.Empty;
            string result = dataItem.ToString();
            if (result == "0") return string.Empty;
            return result;
        }

        protected void AddChoiceButton_Click(object sender, EventArgs e)
        {
            OptionChoice choice = new OptionChoice();
            choice.Option = _Option;
            choice.Name = AddChoiceName.Text;
            choice.ThumbnailUrl = AddChoiceThumbnail.Text;
            choice.ImageUrl = AddChoiceImage.Text;
            choice.PriceModifier = AlwaysConvert.ToDecimal(AddChoicePriceMod.Text);
            choice.MsrpModifier = AlwaysConvert.ToDecimal(AddChoiceRetialMod.Text);
            choice.WeightModifier = AlwaysConvert.ToDecimal(AddChoiceWeightMod.Text);
            choice.SkuModifier = AddChoiceSkuMod.Text.Trim();
            choice.OrderBy = -1;            
            choice.Selected = Selected.Checked;
                        
            // MAKE SURE ONLY ONE CHOICE IS SELECTED            
            if (Selected.Checked)
            {
                foreach (OptionChoice existingChoice in _Option.Choices)
                {
                    if(existingChoice.Selected) existingChoice.Selected = false;
                }
            }           

            _Option.Choices.Add(choice);
            _Option.Save();

            BindChoicesGrid();
            AddChoiceName.Text = string.Empty;
            AddChoiceThumbnail.Text = string.Empty;
            AddChoiceImage.Text = string.Empty;
            AddChoicePriceMod.Text = string.Empty;
            AddChoiceRetialMod.Text = string.Empty;
            AddChoiceWeightMod.Text = string.Empty;
            AddChoiceSkuMod.Text = string.Empty;
            SavedMessage.Visible = true;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // REGISTER WARNING SCRIPTS IF THE PRODUCT HAS CUSTOMIZED VARIANTS
            string warnScript;
            int productId = AbleCommerce.Code.PageHelper.GetProductId();
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                bool hasDigitalGoods = ProductVariantManager.HasDigitalGoodData(productId);
                if (hasDigitalGoods || product.KitStatus == KitStatus.Member)
                {
                    String delMesssage = String.Empty;
                    if (hasDigitalGoods)
                    {
                        delMesssage += "WARNING: If there are digital goods linked to variants with this choice, deleting the choice will unlink these digital goods.\\n\\n";
                    }
                    if (product.KitStatus == KitStatus.Member)
                    {
                        delMesssage += "WARNING: This product is part of one or more kit products.  Deleting this choice will remove any variants with this choice from those kit products.\\n\\n";
                    }

                    warnScript = "function confirmDel(){return confirm('" + delMesssage + "Are you sure you want to delete this choice?');}";
                }
                else
                {
                    warnScript = "function confirmDel(){return confirm('Are you sure you want to delete this choice?');}";
                }
                this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "checkVariant", warnScript, true);
            }
        }
    }
}