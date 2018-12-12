namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;

    [Description("A control to display communication preferences, i.e. subscription options to email lists etc.")]
    public partial class CommunicationPreferencesSection : System.Web.UI.UserControl
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                IList<EmailList> publicLists = GetPublicEmailLists();
                if (publicLists.Count > 0)
                {
                    dlEmailLists.DataSource = publicLists;
                    dlEmailLists.DataBind();
                }
                else
                {
                    EmailListPanel.Visible = false;
                }
            }
        }

        protected bool IsInList(object dataItem)
        {
            EmailList list = (EmailList)dataItem;
            return list.IsMember(AbleContext.Current.User.Email);
        }

        protected IList<EmailList> GetPublicEmailLists()
        {
            IList<EmailList> publicLists = new List<EmailList>();
            IList<EmailList> allLists = EmailListDataSource.LoadAll();
            foreach (EmailList list in allLists)
            {
                if (list.IsPublic) publicLists.Add(list);
            }
            return publicLists;
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {

            List<int> offList = new List<int>();
            List<int> onList = new List<int>();
            //LOOP THROUGH SIGNUP LIST
            int index = 0;
            foreach (DataListItem item in dlEmailLists.Items)
            {
                int tempListId = (int)dlEmailLists.DataKeys[index];
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
            //PROCESS LISTS THAT SHOULD NOT BE SUBSCRIBED
            foreach (int emailListId in offList)
            {
                EmailListUser elu = EmailListUserDataSource.Load(emailListId, email);
                if (elu != null) elu.Delete();
            }
            //PROCESS LISTS THAT SHOULD BE SUBSCRIBED
            IDatabaseSessionManager database = AbleContext.Current.Database;
            database.BeginTransaction(); 
            foreach (int emailListId in onList)
            {
                EmailListUser elu = EmailListUserDataSource.Load(emailListId, email);
                if (elu == null)
                {
                    EmailList list = EmailListDataSource.Load(emailListId);
                    if (list != null) list.ProcessSignupRequest(email);
                }
            }
            //DISPLAY CONFIRMATION
            UpdatedMessage.Visible = true;
            database.CommitTransaction();
        }
    }
}