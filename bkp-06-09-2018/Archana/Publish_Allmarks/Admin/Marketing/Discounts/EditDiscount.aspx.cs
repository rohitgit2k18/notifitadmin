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
using CommerceBuilder.UI;
using CommerceBuilder.Marketing;
using CommerceBuilder.Utility;
using CommerceBuilder.Users;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Marketing.Discounts
{
public partial class EditDiscount : AbleCommerceAdminPage
{
    private VolumeDiscount _VolumeDiscount;
    private int _VolumeDiscountId = 0;
    private string confirmValue = string.Empty;

    protected bool IsAdd
    {
        get
        {
            return (AlwaysConvert.ToInt(Request.QueryString["IsAdd"]) != 0);
        }
    }

    protected string GetLevelValue(decimal levelValue)
    {
        if (levelValue == 0) return string.Empty;
        return string.Format("{0:0.##}", levelValue);
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        if (this.IsAdd)
        {
            _VolumeDiscount.Delete();
        }
        Response.Redirect("Default.aspx");
    }

    protected void AddRowButton_Click(object sender, EventArgs e)
    {
        SaveDiscount();
        VolumeDiscount discount = _VolumeDiscount;
        VolumeDiscountLevel newDiscountLevel = new VolumeDiscountLevel(discount, 0, 0, 0, true);
        discount.Levels.Add(newDiscountLevel);
        discount.Save();
        DiscountLevelGrid.DataSource = discount.Levels;
        DiscountLevelGrid.DataBind();
    }

    protected void DiscountLevelGrid_PreRender(object sender, EventArgs e)
    {
        VolumeDiscount discount = _VolumeDiscount;
        if (discount != null)
        {
            if (discount.Levels.Count == 0)
            {
                VolumeDiscountLevel newDiscountLevel = new VolumeDiscountLevel();
                discount.Levels.Add(newDiscountLevel);
            }

            DiscountLevelGrid.DataSource = _VolumeDiscount.Levels;
            DiscountLevelGrid.DataBind();
        }
    }

    private void SaveDiscount()
    {
        VolumeDiscount discount = _VolumeDiscount;
        discount.Name = Name.Text;
        discount.IsValueBased = IsValueBased.SelectedIndex == 1 ? true : false;
        //LOOP THROUGH GRID ROWS AND SET MATRIX
        int rowIndex = 0;
        foreach (GridViewRow row in DiscountLevelGrid.Rows)
        {
            if (discount.Levels.Count < (rowIndex + 1))
            {
                // ADD A NEW DISCOUNT LEVEL FOR NEW ROWS
                VolumeDiscountLevel newDiscountLevel = new VolumeDiscountLevel();
                newDiscountLevel.Id = _VolumeDiscountId;
                discount.Levels.Add(newDiscountLevel);
            }
            decimal minValue = AlwaysConvert.ToDecimal(((TextBox)row.FindControl("MinValue")).Text);
            decimal maxValue = AlwaysConvert.ToDecimal(((TextBox)row.FindControl("MaxValue")).Text);
            decimal discountAmount = AlwaysConvert.ToDecimal(((TextBox)row.FindControl("DiscountAmount")).Text);
            bool isPercent = (((DropDownList)row.FindControl("IsPercent")).SelectedIndex == 0);
            VolumeDiscountLevel thisLevel = discount.Levels[rowIndex];
            thisLevel.MinValue = minValue;
            thisLevel.MaxValue = maxValue;
            thisLevel.DiscountAmount = discountAmount;
            thisLevel.IsPercent = isPercent;
            thisLevel.Save();
            rowIndex++;
            
        }
        //SCOPE
        discount.IsGlobal = (UseGlobalScope.SelectedIndex == 0);
        //GROUP RESTRICTION
        if (UseGroupRestriction.SelectedIndex > 0)
        {
            _VolumeDiscount.Groups.Clear();
            _VolumeDiscount.Save();
            foreach (ListItem item in GroupList.Items)
            {
                Group group = GroupDataSource.Load(AlwaysConvert.ToInt(item.Value));
                if (item.Selected) _VolumeDiscount.Groups.Add(group);
            }
        }
        else
        {
            _VolumeDiscount.Groups.Clear();
        }
        discount.Save();
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            RemoveAssociation();
            SaveDiscount();
            if (confirmValue != "No")
            {
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            }
            else
            {
                SavedMessage.Visible = false;
            }
        }
    }

    protected void SaveAndCloseButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            RemoveAssociation();
            SaveDiscount();
            Response.Redirect("Default.aspx");
        }
    }

    protected void EditDiscountScope_Click(object sender, EventArgs e)
    {
        SaveDiscount();
        Response.Redirect("EditDiscountScope.aspx?VolumeDiscountId=" + _VolumeDiscountId.ToString() + "&Edit=1");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        _VolumeDiscountId = AlwaysConvert.ToInt(Request.QueryString["VolumeDiscountId"]);
        _VolumeDiscount = VolumeDiscountDataSource.Load(_VolumeDiscountId);
        if (!Page.IsPostBack)
        {
            AddCaption.Visible = this.IsAdd;
            EditCaption.Visible = !AddCaption.Visible;
            if (EditCaption.Visible) EditCaption.Text = string.Format(EditCaption.Text, _VolumeDiscount.Name);
            Name.Text = _VolumeDiscount.Name;
            IsValueBased.SelectedIndex = (_VolumeDiscount.IsValueBased ? 1 : 0);
            //SCOPE
            UseGlobalScope.SelectedIndex = (_VolumeDiscount.IsGlobal) ? 0 : 1;
            //GROUP RESTRICTION
            UseGroupRestriction.SelectedIndex = (_VolumeDiscount.Groups.Count > 0) ? 1 : 0;
            BindGroups();
        }   
        BindScope();
        hdnScope.Value = Scope.Text;
    }

    private void RemoveAssociation()
    {
        if (UseGlobalScope.SelectedIndex == 0)
        {
            confirmValue = Request.Form["confirmValue"];
            if (!string.IsNullOrEmpty(confirmValue))
            {
                //REMOVE CATEGORY AND PRODUCT ASSOCIATION
                if (confirmValue == "Yes")
                {
                    if (_VolumeDiscount.Categories.Count > 0)
                        _VolumeDiscount.Categories.Clear();

                    if (_VolumeDiscount.Products.Count > 0)
                        _VolumeDiscount.Products.Clear();
                    _VolumeDiscount.Save();
                }
                Scope.Text = string.Format(Scope.Text, _VolumeDiscount.Categories.Count, _VolumeDiscount.Products.Count);
            }
        }
    }

    protected void UseGroupRestriction_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGroups();
    }

    protected void BindGroups()
    {
        GroupListPanel.Visible = (UseGroupRestriction.SelectedIndex > 0);
        if (GroupListPanel.Visible)
        {
            GroupList.DataSource = GroupDataSource.LoadAll("Name");
            GroupList.DataBind();
            foreach (Group group in _VolumeDiscount.Groups)
            {
                ListItem listItem = GroupList.Items.FindByValue(group.Id.ToString());
                if (listItem != null) listItem.Selected = true;
            }
        }
    }

    protected void UseGlobalScope_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindScope();
    }

    protected void BindScope()
    {
        ScopePanel.Visible = (UseGlobalScope.SelectedIndex > 0);
        if (ScopePanel.Visible)
        {
            Scope.Text = string.Format(Scope.Text, _VolumeDiscount.Categories.Count, _VolumeDiscount.Products.Count); 
        }
    }

    protected void DiscountLevelGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DropDownList IsPercent = (DropDownList)e.Row.FindControl("IsPercent");
        if (IsPercent != null)
        {
            IsPercent.SelectedIndex = ((VolumeDiscountLevel)e.Row.DataItem).IsPercent ? 0 : 1;
        }
    }    

    protected void DiscountLevelGrid_OnRowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int index = e.RowIndex;
        SaveDiscount();
        VolumeDiscount discount = _VolumeDiscount;
        if (discount.Levels.Count >= (index + 1))
        {
            discount.Levels.DeleteAt(index);
            discount.Save();
        }
        DiscountLevelGrid.DataSource = discount.Levels;
        DiscountLevelGrid.DataBind();
    }
}
}
