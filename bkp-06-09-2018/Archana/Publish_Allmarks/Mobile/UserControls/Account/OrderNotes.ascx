<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderNotes.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Account.OrderNotes" %>
<%--
<UserControls>
<summary>Displays order notes for an order.</summary>
</UserControls>
--%>
<asp:Panel ID="OrderNotesPanel" runat="server" CssClass="widget orderNotesWidget">
    <div class="header">
        <h2><asp:Localize ID="OrderNotesCaption" runat="server" Text="Order Notes"></asp:Localize></h2>
    </div>
	<div class="content">
        <asp:UpdatePanel ID="OrderNotesAjax" runat="server">
            <ContentTemplate>
                <asp:Repeater ID="OrderNotesGrid" runat="server">
                    <ItemTemplate>
                        <div class="note <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                             <div class="info">
                                Posted at 
                                <%# Eval("CreatedDate") %> by 
                                <%# GetNoteAuthor(Container.DataItem) %>
                             </div>
                             <div class="content">
                                <%# Eval("Comment") %>
                             </div>
                         </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="AddNoteForm" runat="server" CssClass="addNoteForm">
                    <div class="inputForm">
                        <div class="field">
                          <span class="fieldValue">
                            <asp:TextBox ID="NewOrderNote" runat="server" TextMode="multiline" Height="80px"></asp:TextBox>
                          </span>
                        </div>
                        <div class="buttons">
                           <asp:LinkButton ID="NewOrderNoteButton" runat="server" Text="Submit my Note" CssClass="button linkButton" OnClick="NewOrderNoteButton_Click"></asp:LinkButton>
                        </div>
                        </tr>
                    </div>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
	</div>
</asp:Panel>