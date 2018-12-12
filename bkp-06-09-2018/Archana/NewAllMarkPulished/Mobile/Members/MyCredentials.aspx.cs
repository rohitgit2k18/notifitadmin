using System;
using System.Collections.Generic;
using System.Web.Security;
using System.Web.UI;
using CommerceBuilder.Common;
using CommerceBuilder.Users;
using CommerceBuilder.Marketing;
using System.Web.UI.WebControls;
using CommerceBuilder.UI;

namespace AbleCommerce.Mobile.Members
{
    public partial class MyCredentials : AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            if (!user.IsAnonymousOrGuest)
            {
                // handling for registered users
                NewAccountText.Visible = false;
                UpdateAccountText.Visible = true;
                if (!Page.IsPostBack)
                {
                    UserName.Text = user.UserName;
                    Email.Text = user.Email;
                }
            }
            else
            {
                // handling for guest users
                if (!Page.IsPostBack)
                {
                    // TRY TO DEFAULT THE EMAIL ADDRESS TO LAST ORDER EMAIL
                    int orderCount = user.Orders.Count;
                    if (orderCount > 0)
                    {
                        UserName.Text = user.Orders[orderCount - 1].BillToEmail;
                        Email.Text = UserName.Text;
                    }
                }

                // CONFIGURE SCREEN FOR NEW ACCOUNT CREATION
                trCurrentPassword.Visible = false;
                NewAccountText.Visible = true;
                UpdateAccountText.Visible = false;
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                User user = AbleContext.Current.User;
                string currentUserName = user.UserName;

                bool validPassword;
                if (!user.IsAnonymousOrGuest)
                {
                    validPassword = Membership.ValidateUser(currentUserName, CurrentPassword.Text);
                    if (!validPassword)
                    {
                        InvalidPassword.IsValid = false;
                        return;
                    }
                }
                else validPassword = true;

                // IF USERNAME IS CHANGED, VALIDATE THE NEW NAME IS AVAILABLE
                string newUserName = UserName.Text.Trim();
                bool userNameChanged = (currentUserName != newUserName);
                if (userNameChanged)
                {
                    // CHECK IF THERE IS ALREADY A USER WITH DESIRED USERNAME
                    if (UserDataSource.GetUserIdByUserName(newUserName) > 0)
                    {
                        // A USER ALREADY EXISTS WITH THAT NAME
                        phUserNameUnavailable.Visible = true;
                        return;
                    }
                }

                // UPDATE THE USER RECORD WITH NEW VALUES
                user.Email = Email.Text.Trim();
                user.PrimaryAddress.Email = user.Email;
                user.UserName = newUserName;
                user.Save();

                // RESET AUTH COOKIE WITH NEW USERNAME IF NEEDED
                if (userNameChanged) FormsAuthentication.SetAuthCookie(newUserName, false);

                // DISPLAY RESULT
                ConfirmationMsg.Visible = true;
            }
        }
    }
}