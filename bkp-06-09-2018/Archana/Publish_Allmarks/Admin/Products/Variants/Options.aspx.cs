namespace AbleCommerce.Admin.Products.Variants
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Configuration;
    using System.Linq;

    public partial class Options : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        int _ProductId = 0;
        Product _Product;
        IList<Option> _Options;

        protected void Page_Init(object sender, System.EventArgs e)
        {
            _ProductId = AbleCommerce.Code.PageHelper.GetProductId();
            _Product = ProductDataSource.Load(_ProductId);
            if (_Product == null) Response.Redirect("~/Admin/Catalog/Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId());
            _Options = _Product.GetOptions();
            Caption.Text = string.Format(Caption.Text, _Product.Name);
            VariantLink.NavigateUrl += "?ProductId=" + _ProductId.ToString();
            BindOptionsGrid();
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(AddOptionName);
            AbleCommerce.Code.PageHelper.SetDefaultButton(AddOptionChoices, AddButton.ClientID);

            phGoogleFeedHelp.Visible = ApplicationSettings.Instance.GoogleFeedInterval > 0;
        }

        protected string GetOptionNames(object dataItem)
        {
            Option option = (Option)dataItem;
            if (option.Choices.Count == 0)
            {
                return "<i>none</i>";
            }
            List<string> names = new List<string>();
            foreach (OptionChoice choice in option.Choices)
            {
                names.Add(choice.Name);
            }
            string retVal = string.Join(", ", names.ToArray());
            if ((retVal.Length > 100))
            {
                retVal = (retVal.Substring(0, 100) + "...");
            }
            return retVal;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            string warnScript;
            bool hasVariantData = ProductVariantManager.HasVariantData(_ProductId);
            bool hasDigitalGoods = ProductVariantManager.HasDigitalGoodData(_ProductId);
            if (hasVariantData || hasDigitalGoods || _Product.KitStatus == KitStatus.Member)
            {
                String delMesssage = String.Empty;
                String addMessage = String.Empty;
                if (hasVariantData)
                {
                    delMesssage += "WARNING: If you have made changes to the variant grid, such as adjusting the variant price or in-stock levels, deleting an option will reset this data.\\n\\n";
                    addMessage += "WARNING: If you have made changes to the variant grid, such as adjusting the variant price or in-stock levels, adding an option will reset this data. \\n\\n";
                }
                if (hasDigitalGoods)
                {
                    delMesssage += "WARNING: There are digital goods attached to one or more variants, deleting this option will remove all associated digital goods.\\n\\n";
                    addMessage += "WARNING: There are digital goods attached to one or more existing variants, adding an option will remove all associated digital goods.\\n\\n";
                }
                if (_Product.KitStatus == KitStatus.Member)
                {
                    addMessage += "WARNING: This product is part of one or more kit products, adding an option will remove this product from those kit products.\\n\\n";
                    delMesssage += "WARNING: This product is part of one or more kit products, deleting an option will remove this product from those kit products.\\n\\n";
                }

                warnScript = "function confirmAdd(){return confirm('" + addMessage + " Are you sure you want to continue?');}\r\n";
                warnScript += "function confirmDel(){return confirm('" + delMesssage + "Are you sure you want to delete this option?');}";
            }
            else
            {
                warnScript = "function confirmAdd(){return true;}";
                warnScript += "function confirmDel(){return confirm('Are you sure you want to delete this option?');}";
            }
            ScriptManager.RegisterStartupScript(OptionsPanel, OptionsPanel.GetType(), "checkVariant", warnScript, true);
        }

        protected void BindOptionsGrid()
        {
            OptionsGrid.DataSource = _Options;
            OptionsGrid.DataBind();
        }

        protected void OptionsGrid_DataBound(object sender, System.EventArgs e)
        {
            VariantLink.Visible = (OptionsGrid.Rows.Count > 0);
        }

        protected void OptionsGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "MoveUp" || e.CommandName == "MoveDown" || e.CommandName == "DoDelete")
            {
                int optionId = AlwaysConvert.ToInt(e.CommandArgument);
                IList<ProductOption> prodOpts = _Product.ProductOptions;
                Option option = OptionDataSource.Load(optionId);
                ProductOption porductOption = ProductOptionDataSource.Load(_Product, option);
                int itemIndex = prodOpts.IndexOf(porductOption);
                ProductOption selectedItem;
                if (e.CommandName == "MoveUp")
                {
                    if ((itemIndex < 1) || (itemIndex > (prodOpts.Count - 1))) return;
                    selectedItem = prodOpts[itemIndex];
                    prodOpts[itemIndex] = prodOpts[(itemIndex - 1)];
                    prodOpts[(itemIndex - 1)] = selectedItem;
                }
                else if (e.CommandName == "MoveDown")
                {
                    if ((itemIndex > (prodOpts.Count - 2)) || (itemIndex < 0)) return;
                    selectedItem = prodOpts[itemIndex];
                    prodOpts[itemIndex] = prodOpts[(itemIndex + 1)];
                    prodOpts[(itemIndex + 1)] = selectedItem;
                }
                else if (e.CommandName == "DoDelete")
                {
                    //DELETE THE PRODUCT - OPTION ASSOCIATION
                    if (itemIndex >= 0) prodOpts.DeleteAt(itemIndex);
                }
                //UPDATE THE DISPLAY ORDER
                for (short i = 0; i < prodOpts.Count; i++)
                {
                    prodOpts[i].OrderBy = i;
                }
                prodOpts.Save();
                _Options = _Product.GetOptions();
                _Product.Save();
                DoAdjustVariants();
                BindOptionsGrid();
            }
        }

        protected void DoAdjustVariants()
        {
            IList<ProductOption> productOptions = ProductOptionDataSource.LoadForProduct(_ProductId);
            List<Option> options = (from o in productOptions orderby o.OrderBy select o.Option).ToList<Option>();
            IList<ProductVariant> variants = ProductVariantDataSource.LoadForProduct(_ProductId);
            foreach (ProductVariant variant in variants)
            {
                Option o1 = FindOptionWithChoice(options, variant.Option1);
                Option o2 = FindOptionWithChoice(options, variant.Option2);
                Option o3 = FindOptionWithChoice(options, variant.Option3);
                Option o4 = FindOptionWithChoice(options, variant.Option4);
                Option o5 = FindOptionWithChoice(options, variant.Option5);
                Option o6 = FindOptionWithChoice(options, variant.Option6);
                Option o7 = FindOptionWithChoice(options, variant.Option7);
                Option o8 = FindOptionWithChoice(options, variant.Option8);

                Dictionary<int, int> map = new Dictionary<int, int>();
                if(o1 != null) map.Add(o1.Id, variant.Option1);
                if (o2 != null) map.Add(o2.Id, variant.Option2);
                if (o3 != null) map.Add(o3.Id, variant.Option3);
                if (o4 != null) map.Add(o4.Id, variant.Option4);
                if (o5 != null) map.Add(o5.Id, variant.Option5);
                if (o6 != null) map.Add(o6.Id, variant.Option6);
                if (o7 != null) map.Add(o7.Id, variant.Option7);
                if (o8 != null) map.Add(o8.Id, variant.Option8);

                if (variant.Option1 > 0) variant.Option1 = map[options[0].Id];
                if (variant.Option2 > 0) variant.Option2 = map[options[1].Id];
                if (variant.Option3 > 0) variant.Option3 = map[options[2].Id];
                if (variant.Option4 > 0) variant.Option4 = map[options[3].Id];
                if (variant.Option5 > 0) variant.Option5 = map[options[4].Id];
                if (variant.Option6 > 0) variant.Option6 = map[options[5].Id];
                if (variant.Option7 > 0) variant.Option7 = map[options[6].Id];
                if (variant.Option8 > 0) variant.Option8 = map[options[7].Id];
                variant.Save();
            }
        }

        protected Option FindOptionWithChoice(List<Option> options, int choiceId)
        {
            return (from o in options where o.Choices.Any(c => c.Id == choiceId) select o).SingleOrDefault();
        }


        protected void AddButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Option option = new Option();
                option.Name = AddOptionName.Text;
                option.CreatedDate = LocaleHelper.LocalNow;

                string[] choices = AddOptionChoices.Text.Split(",".ToCharArray());
                foreach (string item in choices)
                {
                    string choiceName = item.Trim();
                    if (choiceName != String.Empty)
                    {
                        OptionChoice choice = new OptionChoice();
                        choice.Option = option;
                        choice.Name = StringHelper.Truncate(choiceName, 50);
                        choice.OrderBy = -1;
                        option.Choices.Add(choice);
                    }
                }
                option.Save();
                ProductOption productOption = new ProductOption(_Product, option, -1);
                productOption.Save();

                // RESET VARIANT GRID FOR THE ASSOCIATED PRODUCT
                ProductVariantManager.ResetVariantGrid(_Product.Id);
                option.ProductOptions.Add(productOption);
                _Options.Add(option);
                AddOptionName.Text = string.Empty;
                AddOptionChoices.Text = string.Empty;
                BindOptionsGrid();
            }
        }

        protected void OptionsGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int optionId = (int)OptionsGrid.DataKeys[e.RowIndex].Value;
            //FIND THE OPTION
            e.Cancel = true;
        }

        protected string GetEditOptionUrl(object dataItem)
        {
            Option o = (Option)dataItem;
            return Page.ResolveUrl("~/Admin/Products/Variants/EditOption.aspx?ProductId=" + _ProductId.ToString() + "&OptionId=" + o.Id.ToString());
        }

        protected string GetEditChoicesUrl(object dataItem)
        {
            Option o = (Option)dataItem;
            return Page.ResolveUrl("~/Admin/Products/Variants/EditChoices.aspx?ProductId=" + _ProductId.ToString() + "&OptionId=" + o.Id.ToString()+"&ShowThumbnail="+(bool)o.ShowThumbnails);
        }
    }
}