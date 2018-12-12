namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public partial class OrderHistory : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _OrderId = 0;
        private Order _Order;

        protected void Page_Load(object sender, EventArgs e)
        {
            _Order = AbleCommerce.Code.OrderHelper.GetOrderFromContext();
            if (_Order != null)
            {
                _OrderId = AbleCommerce.Code.PageHelper.GetOrderId();
                if (!Page.IsPostBack)
                {
                    BindOrderNotes();
                    AddIsPrivate.Checked = true;
                }
            }
            AddDialogCaption.Text = string.Format(AddDialogCaption.Text, _Order.OrderNumber);
            EditDialogCaption.Text = string.Format(EditDialogCaption.Text, _Order.OrderNumber);
        }

        protected string GetAuthor(object dataItem)
        {
            OrderNote note = (OrderNote)dataItem;
            if (note.User != null) return note.User.GetBestEmailAddress();
            return string.Empty;
        }

        protected void BindOrderNotes()
        {
            IList<OrderNote> notes = _Order.Notes;
            notes.Sort(new PropertyComparer("CreatedDate", CommerceBuilder.Common.SortDirection.DESC));
            OrderNotesGrid.DataSource = notes;
            OrderNotesGrid.DataBind();
        }

        protected void ShowAddDialog_Click(object sender, EventArgs e)
        {
            AddPopup.Show();
            AddComment.Focus();
        }

        protected void MarkAllReadButton_Click(object sender, EventArgs e)
        {
            foreach (OrderNote note in _Order.Notes)
            {
                note.IsRead = true;
            }
            _Order.Save(false, false);
            BindOrderNotes();
        }

        protected void AddButton_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(AddComment.Text))
            {
                AbleContext.Current.Database.BeginTransaction();
                _Order.Notes.Add(new OrderNote(_Order, AbleContext.Current.User, LocaleHelper.LocalNow, AddComment.Text, AddIsPrivate.Checked ? NoteType.Private : NoteType.Public));


                if (MarkAllRead.Checked)
                {
                    foreach (OrderNote note in _Order.Notes)
                    {
                        note.IsRead = true;
                    }
                }
                _Order.Save(false, false);
                AbleContext.Current.Database.CommitTransaction();

                BindOrderNotes();
                AddComment.Text = string.Empty;
                MarkAllRead.Checked = true;
            }
            AddIsPrivate.Checked = true;
        }

        protected void EditButton_Click(object sender, EventArgs e)
        {
            int orderNoteId = AlwaysConvert.ToInt(EditId.Value);
            OrderNote n = OrderNoteDataSource.Load(orderNoteId);
            if (n != null && !string.IsNullOrEmpty(EditComment.Text))
            {
                n.Comment = EditComment.Text;
                n.NoteType = EditIsPrivate.Checked ? NoteType.Private : NoteType.Public;
                n.IsRead = EditIsRead.Checked;
                n.Save();
                BindOrderNotes();
            }
        }

        protected void OrderNotesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int orderNoteId = AlwaysConvert.ToInt(e.CommandArgument);
            if (e.CommandName == "EditNote")
            {
                OrderNote n = OrderNoteDataSource.Load(orderNoteId);
                EditComment.Text = n.Comment;
                EditIsPrivate.Checked = n.IsPrivate;
                EditIsRead.Checked = n.IsRead;
                EditId.Value = orderNoteId.ToString();
                EditPopup.Show();
            }
            else if (e.CommandName == "DeleteNote")
            {
                int index = _Order.Notes.IndexOf(orderNoteId);
                if (index > -1) _Order.Notes.DeleteAt(index);
                BindOrderNotes();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            int unreadCount = 0;
            foreach (OrderNote note in _Order.Notes)
            {
                if (!note.IsRead) unreadCount++;
            }
            MarkAllReadButton.Visible = (unreadCount > 0);
        }
    }
}