using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AbleCommerce.Code;
using CommerceBuilder.Localization;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Localization
{
    public partial class Languages : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            AddLanguageDialog1.ItemAdded += new PersistentItemEventHandler(AddLanguageDialog1_ItemAdded);
            EditLanguageDialog1.ItemUpdated += new PersistentItemEventHandler(EditLanguageDialog1_ItemUpdated);

            BindActiveLanguage();
        }

        private void AddLanguageDialog1_ItemAdded(object sender, PersistentItemEventArgs e)
        {
            LanguagesGrid.DataBind();
            LanguagesAjax.Update();
        }

        private void EditLanguageDialog1_ItemUpdated(object sender, PersistentItemEventArgs e)
        {
            LanguagesGrid.EditIndex = -1;
            LanguagesGrid.DataBind();
            AddPanel.Visible = true;
            EditPanel.Visible = false;
            AddEditAjax.Update();
            LanguagesAjax.Update();
        }

        

        private void BindActiveLanguage()
        {
            ActiveLanguage.DataSource = LanguageDataSource.LoadAll();
            ActiveLanguage.DataBind();

            // select the active
            Language activeLanguage = LanguageDataSource.GetActiveLanguage();
            if (activeLanguage != null)
            {
                ListItem item = ActiveLanguage.Items.FindByValue(activeLanguage.Id.ToString());
                if (item != null) item.Selected = true;
            }
        }

        protected void ActiveLanguage_SelectedIndexChanged(object sender, EventArgs e)
        {
            Language lang = LanguageDataSource.Load(AlwaysConvert.ToInt(ActiveLanguage.SelectedValue));
            if (lang != null)
            {
                LanguageDataSource.SetActiveLanguage(lang);
            }
        }

        protected void LanguagesGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int languageId = (int)LanguagesGrid.DataKeys[e.NewEditIndex].Value;
            Language language = LanguageDataSource.Load(languageId);
            if (language != null)
            {
                AddPanel.Visible = false;
                EditPanel.Visible = true;
                EditCaption.Text = string.Format(EditCaption.Text, language.Name);
                EditLanguageDialog editDialog = EditPanel.FindControl("EditLanguageDialog1") as EditLanguageDialog;
                if (editDialog != null) editDialog.LanguageId = languageId;
                AddEditAjax.Update();
            }
        }

        protected void LanguagesGrid_RowCancelingEdit(object sender, EventArgs e)
        {
            AddPanel.Visible = true;
            EditPanel.Visible = false;
            AddEditAjax.Update();
        }
    }
}