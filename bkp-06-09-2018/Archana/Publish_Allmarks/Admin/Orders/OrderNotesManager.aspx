<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.OrderNotesManager" Title="Order Notes Manager" CodeFile="OrderNotesManager.aspx.cs" %>
<%@ Register Src="../UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<script type="text/javascript">
    function toggleCheckBoxState(id, checkState)
    {
        var cb = document.getElementById(id);
        if (cb != null)
            cb.checked = checkState;
    }

    function toggleSelected(checkState)
    {
        // Toggles through all of the checkboxes defined in the CheckBoxIDs array
        // and updates their value to the checkState input parameter
        if (CheckBoxIDs != null)
        {
            for (var i = 0; i < CheckBoxIDs.length; i++)
                toggleCheckBoxState(CheckBoxIDs[i], checkState.checked);
        }
    }
    
    function NotesSelected()
    {
        var count = 0;
        for(i = 0; i< document.forms[0].elements.length; i++){
            var e = document.forms[0].elements[i];
            var name = e.name;
            if ((e.type == 'checkbox') && (name.endsWith('SelectNoteCheckBox')) && (e.checked))
            {
                count ++;
            }
        }
        return (count > 0);
    }
</script>
<div class="pageHeader">
    <div class="caption">
        <h1><asp:Localize ID="Caption" runat="server" Text="Manage Order Notes"></asp:Localize></h1>
        <div class="links">
            <cb:NavigationLink ID="OrderManagerLink" runat="server" Text="Order Manager" SkinID="Button" NavigateUrl="Default.aspx"></cb:NavigationLink>
            <cb:NavigationLink ID="PayManagerLink" runat="server" Text="Payments" SkinID="Button" NavigateUrl="PaymentManager.aspx"></cb:NavigationLink>
            <cb:NavigationLink ID="NotesLink" runat="server" Text="Order Notes" SkinID="ActiveButton" NavigateUrl="#"></cb:NavigationLink>
        </div>
    </div>
</div>
<asp:UpdatePanel ID="SearchFormAjax" runat="server">
    <ContentTemplate>
        <div class="searchPanel">
            <table cellspacing="0" class="inputForm">
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="DateFilterLabel" runat="server" Text="Date Range:" ToolTip="Filter order notes that were placed within the start and end dates." />
                    </th>
                    <td colspan="3">
                        <uc1:PickerAndCalendar ID="StartDate" runat="server" />
                        to <uc1:PickerAndCalendar ID="EndDate" runat="server" />
                        &nbsp;&nbsp;
                        <asp:DropDownList ID="DateQuickPick" runat="server" onchange="alert(this.selectedIndex);">
                            <asp:ListItem Value="-- Date Quick Pick --"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="KeywordSearchTextLabel" runat="server" Text="Find Keyword:" AssociatedControlID="KeywordSearchText" ToolTip="Enter a keyword to find.  Use of wildcard * allowed."></cb:ToolTipLabel>
                    </th>
                    <td >
                        <asp:TextBox ID="KeywordSearchText" runat="server" Width="250px" MaxLength="100" AutoComplete="off"></asp:TextBox> 
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="EmailSearchLabel" runat="server" Text="Author Email:" AssociatedControlID="EmailSearch" ToolTip="Filter by email of the note author."></cb:ToolTipLabel>
                    </th>
                    <td>
                        <asp:TextBox ID="EmailSearch" runat="server" Width="250px" MaxLength="100" AutoComplete="off"></asp:TextBox> 
                    </td>
                </tr>
                <tr>
                    <th valign="top">
                        <cb:ToolTipLabel ID="SearchScopeLabel" runat="server" Text="Scope:" ToolTip="Indicate what type of notes will be included in your search." />
                    </th>
                    <td colspan="3">
                        <asp:DropDownList ID="SearchScope" runat="server">
                            <asp:ListItem>New unread notes</asp:ListItem>
                            <asp:ListItem>All customer notes</asp:ListItem>
                            <asp:ListItem>All merchant notes</asp:ListItem>
                            <asp:ListItem>All notes</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td colspan="3">
                        <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="SearchButton_Click" CausesValidation="false"/>
                        <asp:HyperLink ID="ResetSearchButton" runat="server" Text="Reset" SkinID="CancelButton" NavigateUrl="OrderNotesManager.aspx"></asp:HyperLink>
                    </td>
                </tr>
            </table>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:UpdatePanel ID="SearchResultAjax" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <div class="content">
            <asp:HiddenField ID="DummyTarget" runat="server" />
            <asp:Button ID="MarkAsReadButton" runat="server" Text="Mark As Read" OnClick="MarkAsReadButton_Click" ValidationGroup="MarkRead" OnClientClick="if(!NotesSelected()){alert('No note(s) selected. Please select at least one note.'); return false;}"  />
            <cb:AbleGridView ID="OrderNotesGrid" runat="server" SkinID="PagedList" Width="100%" AllowPaging="True" PageSize="20" 
                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="OrderNoteId" DataSourceID="OrderNotesDs"
                 DefaultSortExpression="ON.CreatedDate" DefaultSortDirection="Descending" ShowWhenEmpty="False" 
                 OnRowCommand="OrderNotesGrid_RowCommand" OnDataBound="OrderNotesGrid_DataBound" CellPadding="4">
                <Columns>
                    <asp:TemplateField HeaderText="Select">
                        <HeaderStyle HorizontalAlign="Center" />
                        <HeaderTemplate>
                            <asp:PlaceHolder ID="SelectAllCheckboxPanel" runat="server">
                                <input type="checkbox" onclick="toggleSelected(this)" />
                            </asp:PlaceHolder>
                        </HeaderTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="40px" />
                        <ItemTemplate>
                            <asp:CheckBox ID="SelectNoteCheckBox" runat="server" Visible='<%# (bool)Eval("IsRead") == false  %>'/>
                            <asp:Literal ID="ReadLabel" runat="server" Visible='<%# (bool)Eval("IsRead") == true %>' Text="read"></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Order #" SortExpression="OrderNumber">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" Width="60px" />
                        <ItemTemplate>
                            <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' SkinID="Link" NavigateUrl='<%#String.Format("OrderHistory.aspx?OrderNumber={0}", Eval("OrderNumber"))%>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Author" SortExpression="UserName">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" Width="200px" />
                        <ItemTemplate>
                            <%# Eval("User.PrimaryAddress.FullName") %><br />
                            <%# Eval("UserName") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date and Time" SortExpression="ON.CreatedDate">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" Width="140px" />
                        <ItemTemplate>
                            <%# Eval("OrderNoteDate")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Message" >
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <%# Eval("Note") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CheckBoxField HeaderText="Private" DataField="IsPrivateNote" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                        <ItemStyle HorizontalAlign="Center" Width="60px" />
                        <ItemTemplate>
                            <asp:ImageButton ID="AddNoteButton" runat="server" CommandName="AddNote" CommandArgument='<%#String.Format("{0}:{1}", Eval("OrderId"), Eval("OrderNumber"))%>' SkinID="ReplyIcon" AlternateText="Reply" ToolTip="Reply" />
                            <asp:HyperLink ID="ViewOrder" runat="server" NavigateUrl='<%#String.Format("OrderHistory.aspx?OrderNumber={0}", Eval("OrderNumber"))%>'><asp:Image ID="PreviewIcon" runat="server" SkinID="PreviewIcon" AlternateText="View Order" ToolTip="View Order" /></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Label ID="EmptyMessage" runat="server" Text="No order notes match criteria."></asp:Label>
                </EmptyDataTemplate>
            </cb:AbleGridView>
        </div>
        <asp:Panel ID="AddDialog" runat="server" Style="display:none;width:400px" CssClass="modalPopup">
            <asp:Panel ID="AddDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                <asp:Localize ID="AddDialogCaption" runat="server" Text="Add Note for Order #{0}" EnableViewState="false"></asp:Localize>
            </asp:Panel>
            <div style="padding-top:5px;">
                <asp:TextBox ID="NoteText" runat="server" TextMode="MultiLine" Rows="5" Columns="60" style="width:390px"></asp:TextBox>
                <asp:CheckBox ID="PrivateNote" runat="server" Text="This is a private note (hide from customer)" /><br />
                <asp:CheckBox ID="MarkReadOnReply" runat="server" Text="Mark all notes for this order as read" Checked="true" /><br /><br />
                <asp:HiddenField ID="HiddenOrderId" runat="server" />
                <asp:Button ID="AddButton" runat="server" Text="Add Note" OnClick="SaveButton_Click" ValidationGroup="AddNote" />
                &nbsp;<asp:Button ID="CancelAddButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
            </div>
            <div style="margin-top:5px;overflow:auto;width:400px;max-height:200px;">
                <h2 class="sectionHeader" style="padding:4px;">Note History (most recent first)</h2>
                <asp:Literal ID="NoteHistory" runat="server"></asp:Literal>
            </div>
        </asp:Panel>
        <ajaxToolkit:ModalPopupExtender ID="AddPopup" runat="server" 
            TargetControlID="DummyTarget"
            PopupControlID="AddDialog" 
            BackgroundCssClass="modalBackground"                         
            CancelControlID="CancelAddButton" 
            DropShadow="false"
            PopupDragHandleControlID="AddDialogHeader" />
    </ContentTemplate>
</asp:UpdatePanel>
<asp:HiddenField ID="HiddenStartDate" runat="server" />
<asp:HiddenField ID="HiddenEndDate" runat="server" />
<asp:ObjectDataSource ID="OrderNotesDs" runat="server" OldValuesParameterFormatString="original_{0}"
    SelectMethod="Load" SelectCountMethod="Count" SortParameterName="sortExpression" TypeName="CommerceBuilder.Search.OrderNoteFilterDataSource"
    OnSelecting="OrderNotesDs_Selecting" EnablePaging="true">
    <SelectParameters>
        <asp:Parameter Name="filter" Type="Object" />
    </SelectParameters>
</asp:ObjectDataSource>
</asp:Content>