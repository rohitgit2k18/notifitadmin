<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.People.Groups._Default" Title="Groups"  CodeFile="Default.aspx.cs" AutoEventWireup="True" %>
<%@ Register Src="AddGroupDialog.ascx" TagName="AddGroupDialog" TagPrefix="uc1" %>
<%@ Register Src="EditGroupDialog.ascx" TagName="EditGroupDialog" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Groups"></asp:Localize></h1>
            	<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="people" />
    	</div>
    </div>
     <asp:UpdatePanel ID="GroupAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="grid_8 alpha">
                <div class="mainColumn">
                    <div class="content">
                        <cb:SortedGridView ID="GroupGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="GroupDs" 
                            width="100%" SkinID="PagedList" AllowSorting="True" DefaultSortExpression="Name" DefaultSortDirection="Ascending" 
                            ShowWhenEmpty="False" OnRowCancelingEdit="GroupGrid_RowCancelingEdit" OnRowEditing="GroupGrid_RowEditing">
                            <Columns>
                                <asp:TemplateField HeaderText="Group" SortExpression="Name">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemTemplate>
                                        <%#Eval("Name")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Permissions">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemTemplate>
                                        <asp:Label ID="Roles" runat="server" Text='<%# GetRoles(Container.DataItem) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>                                
                                <asp:TemplateField HeaderText="Users">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="UserCount" runat="server" Text='<%# CountUsers(Container.DataItem) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>                                
                                <asp:TemplateField>
                                    <EditItemTemplate>                                    
                                        <asp:ImageButton ID="CancelButton" runat="server" SkinID="CancelIcon" CommandName="Cancel" CausesValidation="false" />
                                    </EditItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" Width="81px" Wrap="false" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="UsersLink" runat="server" NavigateUrl='<%# Eval("GroupId", "ManageUsers.aspx?GroupId={0}") %>' Visible='<%# IsManagableGroup(Container.DataItem) %>'><asp:Image ID="UsersIcon" runat="server" SkinID="GroupIcon" AlternateText="Manage Users" /></asp:HyperLink>
                                        <asp:ImageButton ID="EditButton" runat="server" SkinID="EditIcon" CommandName="Edit" AlternateText="Edit" Visible='<%#IsEditableGroup(Container.DataItem)%>' />
                                        <asp:ImageButton ID="DeleteButton" runat="server" SkinID="DeleteIcon" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' Visible='<%#ShowDeleteButton(Container.DataItem)%>' AlternateText="Delete" />
                                        <asp:HyperLink ID="DeleteLink" runat="server" NavigateUrl='<%# Eval("GroupId", "DeleteGroup.aspx?GroupId={0}")%>' Visible='<%# ShowDeleteLink(Container.DataItem) %>'><asp:Image ID="DeleteIcon2" runat="server" SkinID="DeleteIcon" AlternateText="Delete" /></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </cb:SortedGridView>                                                    
                        <asp:ObjectDataSource ID="GroupDs" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="LoadAll" TypeName="CommerceBuilder.Users.GroupDataSource" DataObjectTypeName="CommerceBuilder.Users.Group"
                            DeleteMethod="Delete" SortParameterName="sortExpression">
                        </asp:ObjectDataSource>
                        <p><asp:Localize ID="InstructionText" runat="server" Text="Use Groups to provide access to certain features and create member discounts."></asp:Localize></p>
                    </div>
                </div>
            </div>
            <div class="grid_4 omega">
                <div class="rightColumn">
                    <asp:UpdatePanel ID="AddEditAjax" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="section">
                                <asp:Panel ID="AddPanel" runat="server">
                                    <div class="header">
                                        <h2 class="addgroup"><asp:Localize ID="AddCaption" runat="server" Text="Add Group" /></h2>
                                    </div>
                                    <div class="content">
                                        <uc1:AddGroupDialog ID="AddGroupDialog1" runat="server"></uc1:AddGroupDialog>
                                    </div>
                                </asp:Panel>
                                <asp:Panel ID="EditPanel" runat="server" Visible="false">
                                    <div class="header">
                                        <h2 class="addgroup"><asp:Localize ID="EditCaption" runat="server" Text="Edit {0}" /></h2>
                                    </div>
                                    <div class="content">
                                        <uc1:EditGroupDialog ID="EditGroupDialog1" runat="server"></uc1:EditGroupDialog>
                                    </div>
                                </asp:Panel>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>