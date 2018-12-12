using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AbleCommerce.Code;
using CommerceBuilder.Utility;
using CommerceBuilder.Localization;

namespace AbleCommerce.Admin.Localization
{
    public partial class EditLanguageDialog : System.Web.UI.UserControl
    {
        public event PersistentItemEventHandler ItemUpdated;

        public int LanguageId
        {
            get { return AlwaysConvert.ToInt(ViewState["LanguageId"]); }
            set { ViewState["LanguageId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void UpdateLanguage()
        {
            if (Page.IsValid)
            {
                Language language = LanguageDataSource.Load(this.LanguageId);
                language.Name = Name.Text.Trim();
                language.Culture = CultureList.SelectedValue;

                language.Save();
                SavedMessage.Text = string.Format(SavedMessage.Text, language.Name);
                SavedMessage.Visible = true;
                if (ItemUpdated != null) ItemUpdated(this, new PersistentItemEventArgs(this.LanguageId, language.Name));
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                UpdateLanguage();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            Language language = LanguageDataSource.Load(this.LanguageId);
            if (language != null)
            {
                Name.Text = language.Name;
                CultureList.SelectedIndex = -1;

                ListItem item = CultureList.Items.FindByValue(language.Culture);
                if (item != null) item.Selected = true;
            }
            else
            {
                this.Controls.Clear();
            }
        }
    }
}