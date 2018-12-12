<%@ Page Language="C#" MasterPageFile="Order.master" Inherits="AbleCommerce.Admin.Orders.OrderHistory" Title="Order History and Notes"  CodeFile="OrderHistory.aspx.cs" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" Runat="Server">
    <asp:UpdatePanel ID="HeaderAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Order History and Notes"></asp:Localize></h1>
                    <div class="links">
                        <asp:Button ID="ShowAddDialog" runat="server" Text="Add Comment" SkinID="AddButton" OnClick="ShowAddDialog_Click" />
                        <asp:Button ID="MarkAllReadButton" runat="server" Text="Mark All Read" OnClick="MarkAllReadButton_Click" OnClientClick="this.value='Updating...'" />                
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="content">
                <asp:GridView ID="OrderNotesGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" 
                    OnRowCommand="OrderNotesGrid_RowCommand" CellSpacing="0" CellPadding="4" Width="100%" SkinID="PagedList">
                    <Columns>
                        <asp:TemplateField HeaderText="Date">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Top" Wrap="false" />
                            <ItemTemplate>
                                <%#Eval("CreatedDate")%><br />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Author">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Top" Wrap="false" />
                            <ItemTemplate>
                                <%#GetAuthor(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Comment">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" VerticalAlign="Top" />
                            <ItemTemplate>
                                <asp:Label ID="Comment" runat="server" Text='<%# Eval("Comment") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="EditComment" runat="server" Text='<%# Eval("Comment") %>' TextMode="MultiLine" Rows="4" Columns="40"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Private">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:CheckBox ID="IsPrivate" runat="server" Enabled="false" Checked='<%# Eval("IsPrivate") %>'></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Read">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:CheckBox ID="IsRead" runat="server" Enabled="false" Checked='<%# Eval("IsRead") %>'></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False">
                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="EditLink" runat="Server" CommandName="EditNote" CommandArgument='<%#Eval("OrderNoteId")%>' Text="Edit" Visible='<%#(bool)Eval("IsPrivate") && !(bool)Eval("IsSystem")%>' SkinID="EditIcon" ToolTip="Edit"></asp:ImageButton>
                                <asp:ImageButton ID="DeleteLink" runat="Server" CommandName="DeleteNote" CommandArgument='<%#Eval("OrderNoteId")%>' Text="Delete" Visible='<%#!(bool)Eval("IsSystem")%>' OnClientClick="return confirm('Are you sure you want to delete this note?')" SkinID="DeleteIcon" ToolTip="Delete"></asp:ImageButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <asp:HiddenField ID="DummyAddTarget" runat="server" />
            <asp:HiddenField ID="DummyEditTarget" runat="server" />
            <asp:Panel ID="AddDialog" runat="server" Style="display:none;width:400px" CssClass="modalPopup">
                <asp:Panel ID="AddDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                    <asp:Localize ID="AddDialogCaption" runat="server" Text="Add Note for Order #{0}"></asp:Localize>
                </asp:Panel>
                <div style="padding-top:5px;">
                    <asp:TextBox ID="AddComment" runat="server" TextMode="MultiLine" Rows="5" Columns="60" style="width:390px"></asp:TextBox>
                    <asp:CheckBox ID="AddIsPrivate" runat="server" Text="This is a private note (hide from customer)" /><br />
                    <asp:CheckBox ID="MarkAllRead" runat="server" Text="Mark all notes for this order as read" Checked="true" /><br /><br />
                    <asp:Button ID="AddButton" runat="server" Text="Add Note" OnClick="AddButton_Click" ValidationGroup="AddNote" />
                    &nbsp;<asp:Button ID="CancelAddButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                </div>
            </asp:Panel>
            <asp:Panel ID="EditDialog" runat="server" Style="display:none;width:400px" CssClass="modalPopup">
                <asp:Panel ID="EditDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                    <asp:Localize ID="EditDialogCaption" runat="server" Text="Edit Note for Order #{0}"></asp:Localize>
                </asp:Panel>
                <div style="padding-top:5px;">
                    <asp:TextBox ID="EditComment" runat="server" TextMode="MultiLine" Rows="5" Columns="60" style="width:390px"></asp:TextBox>
                    <asp:CheckBox ID="EditIsPrivate" runat="server" Text="This is a private note (hide from customer)" /><br />
                    <asp:CheckBox ID="EditIsRead" runat="server" Text="This note has been read" /><br /><br />
                    <asp:HiddenField ID="EditId" runat="server" />
                    <asp:Button ID="EditButton" runat="server" Text="Save" OnClick="EditButton_Click" ValidationGroup="EditNote" />
                    &nbsp;<asp:Button ID="CancelEditButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                </div>
            </asp:Panel>
            <ajaxToolkit:ModalPopupExtender ID="AddPopup" runat="server" 
                TargetControlID="DummyAddTarget"
                PopupControlID="AddDialog" 
                BackgroundCssClass="modalBackground"                         
                CancelControlID="CancelAddButton" 
                DropShadow="false"
                PopupDragHandleControlID="AddDialogHeader" />
            <ajaxToolkit:ModalPopupExtender ID="EditPopup" runat="server" 
                TargetControlID="DummyEditTarget"
                PopupControlID="EditDialog" 
                BackgroundCssClass="modalBackground"                         
                CancelControlID="CancelEditButton" 
                DropShadow="false"
                PopupDragHandleControlID="EditDialogHeader" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>