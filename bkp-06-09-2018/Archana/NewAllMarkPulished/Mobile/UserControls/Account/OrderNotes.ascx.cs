using System;
using System.Collections.Generic;
using System.Linq;
using CommerceBuilder.Common;
using CommerceBuilder.Orders;
using CommerceBuilder.Utility;
using CommerceBuilder.Stores;

namespace AbleCommerce.Mobile.UserControls.Account
{
    public partial class OrderNotes : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                StoreSettingsManager settings = AbleContext.Current.Store.Settings;
                AddNoteForm.Visible = settings.EnableCustomerOrderNotes;
                IList<OrderNote> publicNotes = this.Order.Notes.Where(NoteType => !NoteType.IsPrivate).ToList();
                OrderNotesGrid.DataSource = publicNotes;
                OrderNotesGrid.DataBind();
                OrderNotesPanel.Visible = settings.EnableCustomerOrderNotes || publicNotes.Count > 0;
            }
            else
            {
                OrderNotesPanel.Visible = false;
            }
        }

        protected void NewOrderNoteButton_Click(object sender, EventArgs e)
        {
            string safeNote = StringHelper.StripHtml(NewOrderNote.Text);
            if (!string.IsNullOrEmpty(safeNote))
            {
                this.Order.Notes.Add(new OrderNote(this.Order, AbleContext.Current.User, LocaleHelper.LocalNow, safeNote, NoteType.Public, false));
                this.Order.Notes.Save();
            }
            NewOrderNote.Text = string.Empty;
        }

        protected string GetNoteAuthor(object dataItem)
        {
            OrderNote note = (OrderNote)dataItem;
            return (note.User != null && note.User.Id == AbleContext.Current.UserId) ? "you" : AbleContext.Current.Store.Name;
        }
    }
}