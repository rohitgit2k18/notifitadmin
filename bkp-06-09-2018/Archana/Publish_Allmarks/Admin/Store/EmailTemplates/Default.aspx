<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin._Store.EmailTemplates._Default" Title="Email Templates" CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Email Templates"></asp:Localize></h1>
		<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/email" />
    	</div>
    </div>
    <div class="content">
        <asp:HyperLink ID="AddLink" runat="server" NavigateUrl="AddTemplate.aspx" Text="Add Email Template" SkinID="AddButton"></asp:HyperLink>
        <p><asp:Label ID="InstructionText" runat="server" Text="The email templates for your store are displayed below.  Templates are used to generate email messages which can be sent automatically when certain events occur.  You can also use these templates to generate emails manually from various places within the admin interface."></asp:Label></p>
        <asp:UpdatePanel ID="ContentAjax" runat="server" UpdateMode="conditional">
            <ContentTemplate>
                <cb:SortedGridView ID="EmailTemplateGrid" runat="server" AllowPaging="False" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyNames="EmailTemplateId" DataSourceID="EmailTemplateDs" 
                    ShowFooter="False" SkinID="PagedList" CellPadding="4" Width="100%"
                    DefaultSortExpression="Name" DefaultSortDirection="Ascending">
                    <Columns>
                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%# Eval("Name") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--
                        <asp:BoundField DataField="Subject" HeaderText="Subject">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle VerticalAlign="Top" />
                        </asp:BoundField>
                        --%>
                        <asp:TemplateField HeaderText="Triggers">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%#GetTriggers(Container.DataItem)%><br />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Format" SortExpression="IsHTML">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%# GetMailFormat(Container.DataItem) %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False" >
                            <ItemStyle HorizontalAlign="Center" Width="81px" Wrap="false" />
                            <ItemTemplate>                                        
                                <asp:HyperLink ID="CopyButton" runat="server" NavigateUrl='<%# Eval("EmailTemplateId", "AddTemplate.aspx?EmailTemplateId={0}") %>'><asp:Image ID="CopyIcon" SkinID="CopyIcon" runat="server" AlternateText="Copy" /></asp:HyperLink>
                                <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%# Eval("EmailTemplateId", "EditTemplate.aspx?EmailTemplateId={0}") %>'><asp:Image ID="EditIcon" SkinID="Editicon" runat="server" AlternateText="Edit" /></asp:HyperLink>
                                <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" AlternateText="Delete" /></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyDataText" runat="server" Text="No email templates are defined for your store."></asp:Label>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <asp:ObjectDataSource ID="EmailTemplateDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Messaging.EmailTemplateDataSource" SelectCountMethod="CountForStore" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Messaging.EmailTemplate" DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
    </asp:ObjectDataSource>
</asp:Content>