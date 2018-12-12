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

    public partial class AddEmailListDialog : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
            if (!Page.IsPostBack)
            {
                //SignupEmailTemplate
                IList<EmailTemplate> emailTemplates = EmailTemplateDataSource.LoadAll();
                foreach (EmailTemplate template in emailTemplates)
                {
                    ListItem li = new ListItem(template.Name, template.Id.ToString());
                    SignupEmailTemplate.Items.Add(li);
                }
            }
        }

        private void ResetForm()
        {
            Name.Text = string.Empty;
            IsPublic.Checked = true;
            Description.Text = string.Empty;
            SignupRule.SelectedIndex = 0;
            SignupEmailTemplate.SelectedIndex = 0;
        }

        //DEFINE AN EVENT TO TRIGGER WHEN AN ITEM IS ADDED 
        public event PersistentItemEventHandler ItemAdded;

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                EmailList list = new EmailList();
                list.Name = Name.Text;
                list.IsPublic = IsPublic.Checked;
                list.Description = StringHelper.Truncate(Description.Text, 250);
                list.SignupRule = (EmailListSignupRule)Enum.Parse(typeof(EmailListSignupRule), SignupRule.SelectedValue);
                list.SignupEmailTemplateId = AlwaysConvert.ToInt(SignupEmailTemplate.SelectedValue);
                list.Save();
                if (ItemAdded != null) ItemAdded(this, new PersistentItemEventArgs(list.Id, list.Name));
                AddedMessage.Visible = true;
                AddedMessage.Text = string.Format(AddedMessage.Text, list.Name);
                ResetForm();
            }
        }
    }
}