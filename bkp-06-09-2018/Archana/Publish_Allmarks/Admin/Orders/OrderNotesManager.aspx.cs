namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Search;
    using CommerceBuilder.Utility;

    public partial class OrderNotesManager : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            InitDateQuickPick();
        }

        private void InitDateQuickPick()
        {
            DateQuickPick.Items.Clear();
            DateQuickPick.Items.Add("-- Date Quick Pick --");

            StringBuilder js = new StringBuilder();
            js.AppendLine("function dateQP(selectDom) {");
            js.AppendLine("var startPicker = " + StartDate.PickerClientId);
            js.AppendLine("var endPicker = " + EndDate.PickerClientId);
            js.AppendLine("switch(selectDom.selectedIndex){");
            string setStart = "startPicker.value = '{0}'));";
            string setEnd = "endPicker.value = '{0}';";
            string clearStart = "startPicker.value = ''";
            string clearEnd = "endPicker.value = '';";
            int startIndex = 1;

            DateQuickPick.Items.Add(new ListItem("Today"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 7 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-7).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 14 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-14).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 30 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-30).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 60 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-60).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 90 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-90).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 120 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-120).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("This Week"));
            DateTime startDate = LocaleHelper.LocalNow.AddDays(-1 * (int)LocaleHelper.LocalNow.DayOfWeek);
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, startDate.ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last Week"));
            startDate = LocaleHelper.LocalNow.AddDays((-1 * (int)LocaleHelper.LocalNow.DayOfWeek) - 7);
            DateTime endDate = startDate.AddDays(6);
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, startDate.ToString("d")));
            js.Append(string.Format(setEnd, endDate.ToString("d")));
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("This Month"));
            startDate = new DateTime(LocaleHelper.LocalNow.Year, LocaleHelper.LocalNow.Month, 1);
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, startDate.ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last Month"));
            DateTime lastMonth = LocaleHelper.LocalNow.AddMonths(-1);
            startDate = new DateTime(lastMonth.Year, lastMonth.Month, 1);
            endDate = new DateTime(startDate.Year, startDate.Month, DateTime.DaysInMonth(lastMonth.Year, lastMonth.Month));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, startDate.ToString("d")));
            js.Append(string.Format(setEnd, endDate.ToString("d")));
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("This Year"));
            startDate = new DateTime(LocaleHelper.LocalNow.Year, 1, 1);
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, startDate.ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("All Dates"));
            startDate = new DateTime(LocaleHelper.LocalNow.Year, 1, 1);
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(clearStart);
            js.Append(clearEnd);
            js.AppendLine("break;");

            // close switch
            js.Append("}");

            // reset quick picker
            js.AppendLine("selectDom.selectedIndex = 0;");
            js.Append("}");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "dateQP", js.ToString(), true);
            DateQuickPick.Attributes.Add("onChange", "dateQP(this)");
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            OrderNotesGrid.DataBind();
            SearchResultAjax.Update();
        }

        protected void OrderNotesDs_Selecting(object sender, System.Web.UI.WebControls.ObjectDataSourceSelectingEventArgs e)
        {
            // ADD IN THE SEARCH CRITERIA
            e.InputParameters["filter"] = GetOrderNotesFilter();
            OrderNotesGrid.Columns[5].Visible = (SearchScope.SelectedIndex > 1);
        }

        protected OrderNoteFilter GetOrderNotesFilter()
        {
            // CREATE CRITERIA INSTANCE
            OrderNoteFilter criteria = new OrderNoteFilter();
            if (StartDate.SelectedStartDate > DateTime.MinValue)
                criteria.DateStart = StartDate.SelectedStartDate;
            if (EndDate.SelectedEndDate > DateTime.MinValue && EndDate.SelectedEndDate < DateTime.MaxValue)
                criteria.DateEnd = EndDate.SelectedEndDate;
            criteria.Email = EmailSearch.Text.Trim();
            criteria.Keyword = KeywordSearchText.Text.Trim();
            criteria.IncludeUnreadNotes = true;
            criteria.IncludeReadNotes = (SearchScope.SelectedIndex > 0);
            criteria.IncludeCustomerNotes = (SearchScope.SelectedIndex != 2);
            criteria.IncludeMerchantNotes = (SearchScope.SelectedIndex > 1);
            criteria.IncludePublicNotes = true;
            criteria.IncludePrivateNotes = criteria.IncludeMerchantNotes;
            return criteria;
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            int orderId = AlwaysConvert.ToInt(HiddenOrderId.Value);
            Order order = OrderDataSource.Load(orderId);
            if (MarkReadOnReply.Checked)
            {
                foreach (OrderNote note in order.Notes)
                {
                    note.IsRead = true;
                }
            }

            AbleContext.Current.Database.BeginTransaction();
            OrderNote newNote = new OrderNote(orderId, AbleContext.Current.UserId, LocaleHelper.LocalNow, NoteText.Text, (PrivateNote.Checked ? NoteType.Private : NoteType.Public));
            order.Notes.Add(newNote);
            order.Save(false, false);
            AbleContext.Current.Database.CommitTransaction();

            NoteText.Text = String.Empty;
            AddPopup.Hide();

            OrderNotesGrid.DataBind();
            SearchResultAjax.Update();
        }

        protected void OrderNotesGrid_DataBound(object sender, EventArgs e)
        {
            int unreadCount = 0;
            foreach (GridViewRow gvr in OrderNotesGrid.Rows)
            {
                CheckBox cb = (CheckBox)gvr.FindControl("SelectNoteCheckBox");
                if (cb != null && cb.Visible)
                {
                    ScriptManager.RegisterArrayDeclaration(OrderNotesGrid, "CheckBoxIDs", String.Concat("'", cb.ClientID, "'"));
                    unreadCount++;
                }
            }
            MarkAsReadButton.Visible = unreadCount > 0;
            if (unreadCount == 0)
            {
                PlaceHolder cbpanel = AbleCommerce.Code.PageHelper.RecursiveFindControl(OrderNotesGrid, "SelectAllCheckboxPanel") as PlaceHolder;
                if (cbpanel != null)
                {
                    cbpanel.Controls.Clear();
                    cbpanel.Controls.Add(new LiteralControl("Status"));
                }
            }
        }

        protected void OrderNotesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("AddNote"))
            {
                string[] data = ((string)e.CommandArgument).Split(':');
                int orderId = AlwaysConvert.ToInt(data[0]);
                HiddenOrderId.Value = orderId.ToString();
                AddDialogCaption.Text = String.Format(AddDialogCaption.Text, data[1]);
                List<string> history = new List<string>();
                Order order = EntityLoader.Load<Order>(orderId);
                if (order != null)
                {
                    IList<OrderNote> notes = order.Notes;
                    notes.Sort(new PropertyComparer("CreatedDate", CommerceBuilder.Common.SortDirection.DESC));
                    foreach (OrderNote note in notes)
                    {
                        if (note.NoteType != NoteType.SystemPrivate && note.NoteType != NoteType.SystemPublic)
                        {
                            StringBuilder historyEntry = new StringBuilder();
                            historyEntry.Append("<i>On " + note.CreatedDate.ToString("g") + ", ");
                            historyEntry.Append(note.User.PrimaryAddress.FullName);
                            historyEntry.Append(note.NoteType == NoteType.Public ? " wrote" : " whispered");
                            historyEntry.Append(":</i><br />");
                            historyEntry.Append(note.Comment);
                            history.Add(historyEntry.ToString());
                        }
                    }
                }
                NoteHistory.Text = string.Join("<hr>", history.ToArray());
                AddPopup.Show();
                NoteText.Focus();
            }
        }

        protected void MarkAsReadButton_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow row in OrderNotesGrid.Rows)
            {
                CheckBox checkbox = (CheckBox)row.FindControl("SelectNoteCheckBox");
                if ((checkbox != null) && (checkbox.Checked))
                {
                    int orderNoteId = Convert.ToInt32(OrderNotesGrid.DataKeys[row.RowIndex].Value);
                    OrderNote note = OrderNoteDataSource.Load(orderNoteId);
                    Order order = note.Order;
                    if (order != null)
                    {
                        int index = order.Notes.IndexOf(orderNoteId);
                        if (index >= 0)
                            order.Notes[index].IsRead = true;
                        order.Save(false, false);
                    }
                }
            }

            OrderNotesGrid.DataBind();
            SearchResultAjax.Update();
        }
    }
}