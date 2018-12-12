using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AbleCommerce.Code;
using CommerceBuilder.Localization;

namespace AbleCommerce.Admin.Localization
{
    public partial class AddLanguageDialog : System.Web.UI.UserControl
    {
        public event PersistentItemEventHandler ItemAdded;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Language language = new Language();
                language.Name = Name.Text.Trim();
                language.Culture = CultureList.SelectedValue;

                language.Save();

                AddedMessage.Text = string.Format(AddedMessage.Text, language.Name);
                AddedMessage.Visible = true;
                Name.Text = String.Empty;
                Name.Focus();
                if (ItemAdded != null) ItemAdded(this, new PersistentItemEventArgs(language.Id, language.Name));
            }
        }
    }
}