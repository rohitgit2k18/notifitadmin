<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Marketing.Email.ManageList" Title="Manage List" CodeFile="ManageList.aspx.cs" %>
<%@ Register Src="EditEmailListDialog.ascx" TagName="EditEmailListDialog" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="MainContentAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
            	<div class="caption">
            		<h1><asp:Localize ID="Caption" runat="server" Text="Edit List '{0}'"></asp:Localize></h1>
            	</div>
            </div>
            <div class="grid_6">
                <div class="leftColumn">
                    <div class="statusMessage">
                        <cb:Notification ID="UpdatedMessage" runat="server" Text="List updated at {0:T}" SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                    </div>
                    <div class="section">
                        <div class="header">
                            <h2 class="maillist"><asp:Localize ID="AddCaption" runat="server" Text="Edit List Details" /></h2>
                        </div>
                        <div class="content">
                            <uc:EditEmailListDialog id="EditEmailListDialog1" runat="server"></uc:EditEmailListDialog>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_6">
                <div class="mainColumn">
                    <div class="section">
                        <div class="header">
                            <h2><asp:Localize ID="Localize1" runat="server" Text="List Management" /></h2>
                        </div>
                        <div class="content">
                            <asp:Label ID="MembersLabel" runat="server" Text="Members:" SkinID="FieldHeader"></asp:Label>
                            <asp:Label ID="Members" runat="server"></asp:Label><br />
                            <asp:Label ID="LastSendDateLabel" runat="server" Text="Last Sent:" SkinID="FieldHeader"></asp:Label>
                            <asp:Label ID="LastSendDate" runat="server" Text="{0:f}" Visible=></asp:Label><br /><br />
                            <asp:HyperLink ID="ManageMembersLink" runat="server" Text="Manage Users" NavigateUrl="ManageUsers.aspx" SkinId="Button"></asp:HyperLink>
                            <asp:HyperLink ID="ExportUsersLink" runat="server" Text="Export Users" NavigateUrl="ExportList.ashx" SkinId="Button"></asp:HyperLink>
                            <asp:HyperLink ID="ExportEmailLink" runat="server" Text="Export Email" NavigateUrl="ExportEmail.ashx" SkinId="Button"></asp:HyperLink>
                            <asp:HyperLink ID="SendMessageLink" runat="server" Text="Send Message" NavigateUrl="SendMail.aspx" SkinID="Button" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="EmailListDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Marketing.EmailListDataSource" 
        SelectCountMethod="CountForStore" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Marketing.EmailList" 
        DeleteMethod="Delete" UpdateMethod="Update">
    </asp:ObjectDataSource>
</asp:Content>