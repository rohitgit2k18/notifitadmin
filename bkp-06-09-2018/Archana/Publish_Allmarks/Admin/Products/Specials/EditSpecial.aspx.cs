namespace AbleCommerce.Admin.Products.Specials
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Products;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class EditSpecial : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _CategoryId;
        private Special _Special;

        protected void Page_Load(object sender, EventArgs e)
        {
            _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            int specialId = AlwaysConvert.ToInt(Request.QueryString["SpecialId"]);
            _Special = SpecialDataSource.Load(specialId);
            if (_Special == null) Response.Redirect("../../Catalog/Browse.aspx?CategoryId=" + _CategoryId);
            if (!Page.IsPostBack)
            {
                Caption.Text = string.Format(Caption.Text, _Special.Product.Name);
                BasePriceMessage.Text = string.Format(BasePriceMessage.Text, _Special.Product.Price.LSCurrencyFormat("lc"));
                BindSpecial();
            }
            Groups.Attributes.Add("onclick", SelectedGroups.ClientID + ".checked = true");
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx?CategoryId=" + _CategoryId + "&ProductId=" + _Special.ProductId);
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveSpecial();
                if (((Button)sender).ID == "SaveAndCloseButton")
                {
                    CancelButton_Click(sender, e);
                }
                else
                {
                    SavedMessage.Visible = true;
                    SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                }
            }
        }

        protected void BindSpecial()
        {
            Price.Text = string.Format("{0:F2}", _Special.Price);
            StartDate.SelectedDate = _Special.StartDate.HasValue ? _Special.StartDate.Value : DateTime.MinValue;
            EndDate.SelectedDate = _Special.EndDate.HasValue ? _Special.EndDate.Value : DateTime.MinValue;
            if (_Special.Groups != null && _Special.Groups.Count > 0)
            {
                SelectedGroups.Checked = true;
                Groups.DataBind();
                foreach (CommerceBuilder.Users.Group group in _Special.Groups)
                {
                    ListItem listItem = Groups.Items.FindByValue(group.Id.ToString());
                    if (listItem != null) listItem.Selected = true;
                }
            }
        }

        protected void SaveSpecial()
        {
            _Special.Price = AlwaysConvert.ToDecimal(Price.Text);
            _Special.StartDate = StartDate.SelectedDate;
            _Special.EndDate = EndDate.SelectedEndDate;
            _Special.Groups.Clear();
            _Special.Save();
            if (SelectedGroups.Checked)
            {
                foreach (ListItem item in Groups.Items)
                {
                    CommerceBuilder.Users.Group group = GroupDataSource.Load(AlwaysConvert.ToInt(item.Value));
                    if (item.Selected) _Special.Groups.Add(group);
                }
                if (_Special.Groups.Count == 0)
                {
                    SelectedGroups.Checked = false;
                    AllGroups.Checked = true;
                }
            }
            _Special.Save();
        }
    }
}