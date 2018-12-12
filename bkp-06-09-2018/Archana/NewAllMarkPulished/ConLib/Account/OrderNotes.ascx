<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderNotes.ascx.cs" Inherits="AbleCommerce.ConLib.Account.OrderNotes" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays order notes for an order</summary>
</conlib>
--%>
<asp:Panel ID="OrderNotesPanel" runat="server" CssClass="widget orderNotesWidget">
    <div class="header">
        <h2><asp:Localize ID="OrderNotesCaption" runat="server" Text="Order Notes"></asp:Localize></h2>
    </div>
	<div class="content">
        <asp:UpdatePanel ID="OrderNotesAjax" runat="server">
            <ContentTemplate>
                <cb:ExGridView ID="OrderNotesGrid" runat="server" Width="100%" AutoGenerateColumns="false" 
                    SkinID="ItemList">
                    <Columns>
                        <asp:TemplateField HeaderText="Date">
                            <HeaderStyle CssClass="noteDate" />
                            <ItemStyle CssClass="noteDate" />
                            <ItemTemplate>
                                <%# Eval("CreatedDate") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="From">
                            <HeaderStyle CssClass="noteAuthor" />
                            <ItemStyle CssClass="noteAuthor" />
                            <ItemTemplate>
                                <%# GetNoteAuthor(Container.DataItem) %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Comment">
                            <HeaderStyle CssClass="noteText" />
                            <ItemStyle CssClass="noteText" />
                            <ItemTemplate>
                                <%# Eval("Comment") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <span>There are no notes for this order.</span>
                    </EmptyDataTemplate>
                </cb:ExGridView>
                <asp:Panel ID="AddNoteForm" runat="server" CssClass="addNoteForm">
                    <table class="inputForm">
                        <tr>
                            <td>
                                <asp:TextBox ID="NewOrderNote" runat="server" TextMode="multiline" Width="400" Height="80px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:LinkButton ID="NewOrderNoteButton" runat="server" Text="Submit my Note" CssClass="button linkButton" OnClick="NewOrderNoteButton_Click"></asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
	</div>
</asp:Panel>