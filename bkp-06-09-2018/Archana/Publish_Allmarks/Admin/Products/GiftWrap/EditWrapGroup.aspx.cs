namespace AbleCommerce.Admin.Products.GiftWrap
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class EditWrapGroup : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private WrapGroup _WrapGroup;

        protected void Page_Load(object sender, EventArgs e)
        {
            int wrapGroupId = AlwaysConvert.ToInt(Request.QueryString["WrapGroupId"]);
            _WrapGroup = WrapGroupDataSource.Load(wrapGroupId);
            if (_WrapGroup == null) Response.Redirect("Default.aspx");
            _WrapGroup.WrapStyles.Sort("OrderBy");
            if (!Page.IsPostBack)
            {
                Name.Text = _WrapGroup.Name;
                ViewState["Caption"] = Caption.Text;
                Caption.Text = string.Format(Caption.Text, _WrapGroup.Name);
                //INITIALIZE THE ADD WRAP GROUP DIALOG
                AddWrapStyleDialog addDialog = AbleCommerce.Code.PageHelper.RecursiveFindControl(this, "AddWrapStyleDialog1") as AddWrapStyleDialog;
                if (addDialog != null) addDialog.WrapGroupId = wrapGroupId;
            }
        }

        protected void WrapStylesGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int wrapStyleId = (int)WrapStylesGrid.DataKeys[e.NewEditIndex].Value;
            WrapStyle style = WrapStyleDataSource.Load(wrapStyleId);
            if (style != null)
            {
                AddPanel.Visible = false;
                EditPanel.Visible = true;
                EditCaption.Text = string.Format(EditCaption.Text, style.Name);
                EditWrapStyleDialog editDialog = EditPanel.FindControl("EditWrapStyleDialog1") as EditWrapStyleDialog;
                if (editDialog != null) editDialog.WrapStyleId = wrapStyleId;
            }
        }

        protected void WrapStylesGrid_RowCancelingEdit(object sender, EventArgs e)
        {
            AddPanel.Visible = true;
            EditPanel.Visible = false;
        }

        protected void WrapStylesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "MoveUp")
            {
                IList<WrapStyle> wrapStyles = _WrapGroup.WrapStyles;
                int itemIndex = AlwaysConvert.ToInt(e.CommandArgument);
                if ((itemIndex < 1) || (itemIndex > wrapStyles.Count - 1)) return;
                WrapStyle selectedItem = wrapStyles[itemIndex];
                WrapStyle swapItem = wrapStyles[itemIndex - 1];
                wrapStyles.RemoveAt(itemIndex - 1);
                wrapStyles.Insert(itemIndex, swapItem);
                for (int i = 0; i < wrapStyles.Count; i++)
                {
                    wrapStyles[i].OrderBy = (short)i;
                }
                wrapStyles.Save();
            }
            else if (e.CommandName == "MoveDown")
            {
                IList<WrapStyle> wrapStyles = _WrapGroup.WrapStyles;
                int itemIndex = AlwaysConvert.ToInt(e.CommandArgument);
                if ((itemIndex > wrapStyles.Count - 2) || (itemIndex < 0)) return;
                WrapStyle selectedItem = wrapStyles[itemIndex];
                WrapStyle swapItem = wrapStyles[itemIndex + 1];
                wrapStyles.RemoveAt(itemIndex + 1);
                wrapStyles.Insert(itemIndex, swapItem);
                for (int i = 0; i < wrapStyles.Count; i++)
                {
                    wrapStyles[i].OrderBy = (short)i;
                }
                wrapStyles.Save();
            }
            WrapStylesGrid.DataBind();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveWrapGroup();
                Caption.Text = string.Format((string)ViewState["Caption"], _WrapGroup.Name);
                SavedMessage.Visible = true;
            }
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save the product
                SaveWrapGroup();

                // redirect away
                Response.Redirect("Default.aspx");
            }
        }

        private void SaveWrapGroup()
        {
            _WrapGroup.Name = Name.Text;
            _WrapGroup.Save();
        }

        protected void BackButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        protected bool ShowThumbnail(object dataItem)
        {
            return (!string.IsNullOrEmpty(((WrapStyle)dataItem).ThumbnailUrl));
        }
    }
}