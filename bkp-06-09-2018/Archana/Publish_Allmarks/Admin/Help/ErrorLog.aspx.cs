namespace AbleCommerce.Admin.Help
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Utility;

    public partial class ErrorLog : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected string WrapDebugData(object dataItem)
        {
            ErrorMessage message = (ErrorMessage)dataItem;
            return message.DebugData.Replace(".", ".<wbr />");
        }

        protected void ErrorMessageGrid_DataBound(object sender, EventArgs e)
        {
            foreach (GridViewRow gvr in ErrorMessageGrid.Rows)
            {
                CheckBox cb = (CheckBox)gvr.FindControl("Selected");
                ScriptManager.RegisterArrayDeclaration(ErrorMessageGrid, "CheckBoxIDs", String.Concat("'", cb.ClientID, "'"));
            }
        }

        private List<int> GetSelectedErrorMessageIds()
        {
            List<int> selectedErrorMessages = new List<int>();
            foreach (GridViewRow row in ErrorMessageGrid.Rows)
            {
                CheckBox selected = (CheckBox)AbleCommerce.Code.PageHelper.RecursiveFindControl(row, "Selected");
                if ((selected != null) && selected.Checked)
                {
                    selectedErrorMessages.Add((int)ErrorMessageGrid.DataKeys[row.DataItemIndex].Values[0]);
                }
            }
            return selectedErrorMessages;
        }

        protected void DeleteSelectedButton_Click(object sender, EventArgs e)
        {
            List<int> errorMessageIds = GetSelectedErrorMessageIds();
            foreach (int id in errorMessageIds)
            {
                ErrorMessageDataSource.Delete(id);
                ErrorMessageGrid.DataBind();
            }
        }

        protected void DeleteAllButton_Click(object sender, EventArgs e)
        {
            ErrorMessageDataSource.DeleteForStore();
            ErrorMessageGrid.DataBind();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (ErrorMessageGrid.Rows.Count > 0)
            {
                ButtonsPlaceHolder.Visible = true;
            }
            else
            {
                ButtonsPlaceHolder.Visible = false;
            }
        }
    }
}