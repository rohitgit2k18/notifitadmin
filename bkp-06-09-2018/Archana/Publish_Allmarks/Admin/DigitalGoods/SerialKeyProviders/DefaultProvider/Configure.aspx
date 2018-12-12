<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.DigitalGoods.SerialKeyProviders.DefaultProvider.Configure" Title="Configure Serial Keys"  CodeFile="Configure.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Serial Keys For '{0}'"></asp:Localize></h1>
                    <div class="links">
                        <asp:Button ID="AddButton" runat="server" Text="Add" OnClick="AddButton_Click" />
                        <asp:Button ID="BackButton" runat="server" Text="Close" OnClick="BackButton_Click" />
                    </div>
                </div>
            </div>
            <div class="content">
                <asp:GridView ID="SerialKeysGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="SerialKeyId"
                    SkinID="PagedList" AllowPaging="False" AllowSorting="false" OnRowDeleting="SerialKeysGrid_RowDeleting"
                    width="100%">
                    <Columns>
                        <asp:BoundField DataField="SerialKeyData" HeaderText="Serial Key Data" ItemStyle-HorizontalAlign="Center" />
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>                    
                                <asp:HyperLink ID="Edit" runat="server" NavigateUrl='<%# string.Format("EditSerialKey.aspx?DigitalGoodId={0}&SerialKeyId={1}", Eval("DigitalGoodId"), Eval("Id")) %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" ToolTip="Edit" /></asp:HyperLink>
                                <asp:ImageButton ID="Delete" runat="server" CommandName="Delete" AlternateText="Delete" ToolTip="Delete" SkinID="DeleteIcon" OnClientClick='<%# Eval("SerialKeyData", "return confirm(\"Are you sure you want to delete serial key {0}?\")") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyMessage" runat="server" Text="There are no serial keys attached to this digital good."></asp:Label>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>