namespace AbleCommerce.Admin.Marketing.Email
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Messaging;
    using CommerceBuilder.Utility;

    public partial class EditEmailListDialog : System.Web.UI.UserControl
    {
        private int _EmailListId;
        private EmailList _EmailList;
        protected void Page_Load(object sender, EventArgs e)
        {
            _EmailListId = AlwaysConvert.ToInt(Request.QueryString["EmailListId"]);
            _EmailList = EmailListDataSource.Load(_EmailListId);
            if (_EmailList != null)
            {
                AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
                if (!Page.IsPostBack)
                {
                    Name.Text = _EmailList.Name;
                    IsPublic.Checked = _EmailList.IsPublic;
                    Description.Text = _EmailList.Description;
                    ListItem item = SignupRule.Items.FindByValue(_EmailList.SignupRule.ToString());
                    if (item != null)
                    {
                        SignupRule.SelectedIndex = SignupRule.Items.IndexOf(item);
                    }

                    IList<EmailTemplate> emailTemplates = EmailTemplateDataSource.LoadAll();
                    foreach (EmailTemplate template in emailTemplates)
                    {
                        ListItem li = new ListItem(template.Name, template.Id.ToString());
                        SignupEmailTemplate.Items.Add(li);
                    }

                    item = SignupEmailTemplate.Items.FindByValue(_EmailList.SignupEmailTemplateId.ToString());
                    if (item != null)
                    {
                        SignupEmailTemplate.SelectedIndex = SignupEmailTemplate.Items.IndexOf(item);
                    }
                }
            }
            else
            {
                this.Controls.Clear();
            }
        }

        //DEFINE AN EVENT TO TRIGGER WHEN AN ITEM IS ADDED 
        public event PersistentItemEventHandler ItemUpdated;


        protected void CloseButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/Marketing/Email/Default.aspx");
        }
        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveEmailList();
            }
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save the emaillist
                SaveEmailList();

                // redirect away
                Response.Redirect("~/Admin/Marketing/Email/Default.aspx");
            }
        }

        private void SaveEmailList()
        {
            _EmailList.Name = Name.Text;
            _EmailList.IsPublic = IsPublic.Checked;
            _EmailList.Description = StringHelper.Truncate(Description.Text, 250);
            _EmailList.SignupRule = (EmailListSignupRule)Enum.Parse(typeof(EmailListSignupRule), SignupRule.SelectedValue);
            _EmailList.SignupEmailTemplateId = AlwaysConvert.ToInt(SignupEmailTemplate.SelectedValue);
            _EmailList.Save();
            if (ItemUpdated != null) ItemUpdated(this, new PersistentItemEventArgs(_EmailList.Id, _EmailList.Name));
        }
    }
}
