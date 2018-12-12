using System;
using System.Collections.Generic;
using System.Web.Security;
using System.Web.UI;
using CommerceBuilder.Common;
using CommerceBuilder.Users;
using CommerceBuilder.Marketing;
using System.Web.UI.WebControls;
using CommerceBuilder.UI;
using CommerceBuilder.Utility;

namespace AbleCommerce.Mobile.Members
{
    public partial class EmailPreferences : AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                dlEmailLists.DataSource = GetPublicEmailLists();
                dlEmailLists.DataBind();
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // DETERMINE SELECTED LISTS
                List<int> offList = new List<int>();
                List<int> onList = new List<int>();
                int index = 0;
                foreach (RepeaterItem item in dlEmailLists.Items)
                {
                    int tempListId = AlwaysConvert.ToInt(((HiddenField)item.FindControl("EmailListId")).Value);
                    CheckBox selected = (CheckBox)item.FindControl("Selected");
                    if ((selected != null) && (selected.Checked))
                    {
                        onList.Add(tempListId);
                    }
                    else
                    {
                        offList.Add(tempListId);
                    }
                    index++;
                }
                string email = AbleContext.Current.User.Email;

                // PROCESS LISTS THAT SHOULD NOT BE SUBSCRIBED
                foreach (int emailListId in offList)
                {
                    EmailListUser elu = EmailListUserDataSource.Load(emailListId, email);
                    if (elu != null) elu.Delete();
                }

                // PROCESS LISTS THAT SHOULD BE SUBSCRIBED
                foreach (int emailListId in onList)
                {
                    EmailListUser elu = EmailListUserDataSource.Load(emailListId, email);
                    if (elu == null)
                    {
                        EmailList list = EmailListDataSource.Load(emailListId);
                        if (list != null) list.ProcessSignupRequest(email);
                    }
                }

                // DISPLAY RESULT
                ConfirmationMsg.Visible = true;
            }
        }

        private IList<EmailList> GetPublicEmailLists()
        {
            IList<EmailList> publicLists = new List<EmailList>();
            IList<EmailList> allLists = EmailListDataSource.LoadAll();
            foreach (EmailList list in allLists)
            {
                if (list.IsPublic) publicLists.Add(list);
            }
            return publicLists;
        }

        protected bool IsInList(object dataItem)
        {
            EmailList list = (EmailList)dataItem;
            return list.IsMember(AbleContext.Current.User.Email);
        }
    }
}