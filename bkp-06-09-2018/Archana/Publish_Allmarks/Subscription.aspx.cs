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
using CommerceBuilder.Marketing;
using CommerceBuilder.Utility;
using CommerceBuilder.Common;

namespace AbleCommerce
{
public partial class _Subscription : CommerceBuilder.UI.AbleCommercePage
{
    private string _SubscribedMessage = "Your subscription to the list {0} has been activated.";
    public string SubscribedMessage
    {
        get { return _SubscribedMessage; }
        set { _SubscribedMessage = value; }
    }

    private string _DeletedMessage = "Your address has been removed from the list {0}.";
    public string DeletedMessage
    {
        get { return _DeletedMessage; }
        set { _DeletedMessage = value; }
    }

    private string _InvalidMessage = "The subscription request was not understood or the provided parameters are incorrect.";
    public string InvalidMessage
    {
        get { return _InvalidMessage; }
        set { _InvalidMessage = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string action = Request.QueryString["action"];
        if (!string.IsNullOrEmpty(action))
        {
            //DETERMINE THE ACTION
            action = action.ToLowerInvariant();
            if (action == "remove")
            {
                //delete user from the list
                int emailListId = AlwaysConvert.ToInt(Request.QueryString["list"]);
                string email = Request.QueryString["email"];
                string key = Request.QueryString["key"];
                AbleContext.Current.Database.BeginTransaction();
                EmailList list = EmailListDataSource.Load(emailListId);
                if ((list != null) && (email != null))
                {
                    string eluKey = string.Empty;
                    EmailListUser elu = EmailListUserDataSource.Load(emailListId, email);
                    if (elu != null) eluKey = elu.SignupDate.ToString("MMddyyhhmmss");
                    if (key == eluKey)
                    {
                        list.RemoveMember(email);
                        phMessage.Controls.Add(new LiteralControl(string.Format(this.DeletedMessage, list.Name)));
                    }
                }
                AbleContext.Current.Database.CommitTransaction();
            }
            else if (action == "confirm")
            {
                //ADD USER TO LIST
                int emailListId = AlwaysConvert.ToInt(Request.QueryString["list"]);
                string email = Request.QueryString["email"];
                string key = Request.QueryString["key"];
                AbleContext.Current.Database.BeginTransaction();
                EmailList list = EmailListDataSource.Load(emailListId);
                if ((list == null) || !ValidationHelper.IsValidEmail(email)) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetHomeUrl());
                EmailListSignup signup = EmailListSignupDataSource.Load(emailListId, email);
                if (signup != null)
                {
                    if (key == signup.SignupKey)
                    {
                        signup.Activate();

                        //confirm user subscription
                        phMessage.Controls.Add(new LiteralControl(string.Format(this.SubscribedMessage, list.Name)));
                    }
                }
                else if (EmailListUserDataSource.Load(emailListId, email) != null)
                {
                    //CHECK IF USER HAS ALREADY ACTIVATED
                    //confirm user subscription
                    phMessage.Controls.Add(new LiteralControl(string.Format(this.SubscribedMessage, list.Name)));
                }
                AbleContext.Current.Database.CommitTransaction();
            }
            else if (action == "unsubrr")
            {
                int userId = AlwaysConvert.ToInt(Request.QueryString["uid"]);
                string email = Request.QueryString["email"];
                if (string.IsNullOrEmpty(email)) return;

                CommerceBuilder.Users.User user = CommerceBuilder.Users.UserDataSource.Load(userId);
                if (user != null && email.ToLowerInvariant() == user.Email.ToLowerInvariant())
                {
                    user.Settings.OptOutReviewReminders = true;
                    user.Save();
                    string message = "You have successfully unsubscribed from all future product review invitations. If you are a registered user, you may join again by logging into your account and updating your profile.";
                    phMessage.Controls.Add(new LiteralControl(message));
                }
            }
        }

        //IF RESPONSE IS EMPTY, REQUEST IS INVALID
        if (phMessage.Controls.Count == 0)
            phMessage.Controls.Add(new LiteralControl(this.InvalidMessage));
    }
}
}
