using System;
using System.Text;
using System.Web.UI;
using CommerceBuilder.Common;
using CommerceBuilder.Messaging;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;

namespace AbleCommerce.Members
{
    public partial class SendMyWishlist : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // CHECK IF WISHLISTS ARE ENABLED
            if (!AbleContext.Current.Store.Settings.WishlistsEnabled) Response.Redirect("MyAccount.aspx");

            if (!Page.IsPostBack)
                InitSendWishlistForm();
        }

        private void InitSendWishlistForm()
        {
            User user = AbleContext.Current.User;
            FromAddress.Text = user.Email;
            Message.Text = GetMessage();
        }

        private String GetMessage()
        {
            Wishlist wishlist = AbleContext.Current.User.PrimaryWishlist;
            string wishlistUrl = AbleContext.Current.Store.StoreUrl + "ViewWishlist.aspx?ViewCode=" + wishlist.ViewCode;
            String wishlistLink = "<a href=\"" + wishlistUrl + "\">" + wishlistUrl + "</a>";
            StringBuilder messageFormat = new StringBuilder();
            messageFormat.Append("Dear Friend,\n\n");
            messageFormat.Append("I created a WishList at " + AbleContext.Current.Store.Name + ".\n\n");
            if (wishlist.ViewPassword.Length > 0)
            {
                messageFormat.Append("The password for my WishList is " + wishlist.ViewPassword + ".\n\n");
            }
            messageFormat.Append("Please visit the link below to view the list.\n");
            messageFormat.Append(wishlistUrl);
            messageFormat.Append("\n\nThank you!");
            return messageFormat.ToString();
        }

        protected void BackButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Members/MyWishlist.aspx");
        }

        protected void SendButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                System.Net.Mail.MailMessage mailMessage = new System.Net.Mail.MailMessage();
                mailMessage.From = new System.Net.Mail.MailAddress(FromAddress.Text);
                mailMessage.To.Add(SendTo.Text);
                mailMessage.Subject = StringHelper.StripHtml(Subject.Text);
                mailMessage.Body = StringHelper.StripHtml(Message.Text);
                mailMessage.IsBodyHtml = false;
                EmailClient.Send(mailMessage);
                SentMessage.Text = String.Format(SentMessage.Text, SendTo.Text);
                SentMessage.Visible = true;
                SendTo.Text = string.Empty;
            }
        }
    }
}