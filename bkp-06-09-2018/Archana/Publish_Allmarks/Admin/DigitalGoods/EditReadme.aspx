<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.DigitalGoods.EditReadme" Title="Edit Readme" CodeFile="EditReadme.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Edit {0}" EnableViewState="false"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="EditAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <cb:Notification ID="SavedMessage" runat="server" Text="Saved at {0:t}" Visible="false" SkinID="GoodCondition" EnableViewState="False"></cb:Notification>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <table class="inputForm" align="center">
                    <tr>
                        <th>
                            <asp:Label ID="DisplayNameLabel" runat="server" Text="Name:" AssociatedControlID="DisplayName" ToolTip="Name of readme that is displayed in the link text" SkinID="FieldHeader"></asp:Label>&nbsp;
                        </th>
                        <td colspan="2">
                            <asp:TextBox ID="DisplayName" runat="server" MaxLength="100" Width="240px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="NameRequired" runat="server" ControlToValidate="DisplayName"
                                    Display="Static" ErrorMessage="Readme name is required.">*</asp:RequiredFieldValidator>
                            &nbsp;&nbsp;&nbsp;
                            <asp:CheckBox ID="IsHtml" runat="server" Text="Check here if the content is HTML code" />
                        </td>
                    </tr>
                    <tr>
                        <th valign="top">
                            <asp:ImageButton ID="HtmlButton" runat="server" SkinID="HtmlIcon" AlternateText="Edit HTML" />&nbsp;
                            <asp:Label ID="ReadmeTextLabel" runat="server" Text="Content:" AssociatedControlID="ReadmeText" ToolTip="Content of readme displayed when it is viewed" SkinID="FieldHeader"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="ReadmeText" runat="server" Width="600px" Height="400px" TextMode="multiLine"  EnableViewState="false" />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                            <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" OnClick="SaveAndCloseButton_Click" />
						    <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinId="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="section">
        <div class="header">
            <h2>Associated Digital Goods</h2>
        </div>
        <div class="content">
            <asp:GridView ID="DigitalGoodsGrid" runat="server" AutoGenerateColumns="false" ShowHeader="true"
                ShowFooter="false" DataKeyNames="Id" SkinID="PagedList" Width="100%" 
                AllowSorting="false" AllowPaging="false" EnableViewState="false">
                <Columns>
                    <asp:TemplateField HeaderText="Name" SortExpression="DisplayName">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:HyperLink ID="DisplayName" runat="server" NavigateUrl='<%# string.Format("EditDigitalGood.aspx?DigitalGoodId={0}", Eval("DigitalGoodId")) %>' Text='<%#Eval("Name")%>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="FileName" HeaderText="File" SortExpression="FileName">
                        <HeaderStyle HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Attached To">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:Repeater ID="ProductRepeater" runat="server" DataSource='<%#Eval("ProductDigitalGoods")%>'>
                                <ItemTemplate>
                                    <asp:Label ID="ProductName" runat="server" Text='<%#Eval("Product.Name")%>' />                                        
                                </ItemTemplate>
                                <SeparatorTemplate>, </SeparatorTemplate>
                            </asp:Repeater>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Size">
                        <ItemStyle HorizontalAlign="center" />
                        <ItemTemplate>
                            <asp:Label ID="Size" runat="server" Text='<%# Eval("FormattedFileSize") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemStyle HorizontalAlign="center" />
                        <ItemTemplate>
                            <asp:HyperLink ID="DownloadDigitalGood" runat="server" NavigateUrl='<%# Eval("DigitalGoodId", "Download.ashx?DigitalGoodId={0}") %>'><asp:Image ID="DownloadIcon" runat="server" SkinID="DownloadIcon" /></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Label ID="EmptyMessage" runat="server" Text="There are no products with digital goods that are associated with this readme."></asp:Label>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>