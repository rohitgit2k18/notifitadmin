namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Users;

    public partial class MoveOrder : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _OrderId = 0;
        private Order _Order = null;

        protected void Page_Init(object sender, EventArgs e)
        {
            _OrderId = PageHelper.GetOrderId();
            _Order = OrderDataSource.Load(_OrderId);
            if (_Order == null) Response.Redirect("Default.aspx");
            string oldUserName = _Order.User == null ? _Order.BillToEmail + "(user deleted)" : _Order.User.UserName;
            Caption.Text = string.Format(Caption.Text, oldUserName, _Order.OrderNumber);
            CancelLink.NavigateUrl += _Order.OrderNumber;
        }

        protected void UserGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                NewUserId.Value = AlwaysConvert.ToInt(e.CommandArgument).ToString();
                User newUser = UserDataSource.Load(AlwaysConvert.ToInt(NewUserId.Value));
                if(newUser != null)
                {
                    string oldUserName = _Order.User == null ? _Order.BillToEmail + "(user deleted)" : _Order.User.UserName;
                    DialogCaption.Text = string.Format(DialogCaption.Text, _Order.OrderNumber.ToString(), newUser.UserName);
                    DialogInstructionText.Text = string.Format(DialogInstructionText.Text, _Order.BillToEmail, newUser.UserName);
                    TransferPopup.Show();
                }
            }
        }

        protected void MoveButton_Click(object sender, EventArgs e)
        {
            int oldUserId = _Order.UserId;
            int newUserId = AlwaysConvert.ToInt(NewUserId.Value);
            if (newUserId > 0)
            {
                // MOVE ORDER TO NEW USER
                OrderDataSource.UpdateUser(_OrderId, oldUserId, newUserId, StringHelper.StripHtml(TransferNote.Text.Trim()), UpdateEmail.Checked, UpdateBilling.Checked);

                Message.Visible = true;
                TransferPopup.Hide();
                Response.Redirect("ViewOrder.aspx?OrderNumber=" + _Order.OrderNumber);
            }
        }
        

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            UserGrid.PageIndex = 0;
            UserGrid.DataBind();
        }

        protected string GetFullName(object dataItem)
        {
            User user = (User)dataItem;
            Address address = user.PrimaryAddress;
            if (address != null)
            {
                if (!string.IsNullOrEmpty(address.FirstName) && !string.IsNullOrEmpty(address.LastName)) return ((string)(address.LastName + ", " + address.FirstName)).Trim();
                return ((string)(address.LastName + address.FirstName)).Trim();
            }
            return string.Empty;
        }

        private UserSearchCriteria GetSearchCriteria()
        {
            // BUILD THE SEARCH CRITERIA
            UserSearchCriteria criteria = new UserSearchCriteria();
            criteria.UserName = StringHelper.StripHtml(SearchUserName.Text.Trim());
            criteria.Email = StringHelper.StripHtml(SearchEmail.Text.Trim());
            criteria.FirstName = StringHelper.StripHtml(SearchFirstName.Text.Trim());
            criteria.LastName = StringHelper.StripHtml(SearchLastName.Text.Trim());
            criteria.Company = StringHelper.StripHtml(SearchCompany.Text.Trim());
            criteria.Phone = StringHelper.StripHtml(SearchPhone.Text.Trim());
            criteria.GroupId = 0;
            criteria.IncludeAnonymous = false;
            return criteria;
        }

        protected void UserDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            UserSearchCriteria criteria = GetSearchCriteria();
            e.InputParameters["criteria"] = criteria;
        }
    }
}