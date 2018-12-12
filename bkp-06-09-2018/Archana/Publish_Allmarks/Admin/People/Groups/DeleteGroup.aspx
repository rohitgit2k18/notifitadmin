<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.People.Groups.DeleteGroup" Title="Delete Group"  CodeFile="DeleteGroup.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Delete {0}" EnableViewState="false"></asp:Localize></h1>
    	</div>
    </div>
    <div class="grid_6 alpha">
        <div class="mainColumn">
            <div class="content">
                <p><asp:Label ID="InstructionText" runat="server" Text="This group has one or more associated users.  Indicate what group these users should be changed to when {0} is deleted." EnableViewState="false"></asp:Label></p>
                <table class="inputForm">
                    <tr>
                        <th>
                            <asp:Label ID="NameLabel" runat="server" Text="Move to Group:" AssociatedControlID="GroupList" ToolTip="New group for associated users"></asp:Label><br />
                        </th>
                        <td>
                            <asp:DropDownList ID="GroupList" runat="server" DataTextField="Name" DataValueField="GroupId" AppendDataBoundItems="True">
                                <asp:ListItem Value="" Text="-- none --"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>                                    
                            <asp:Button ID="DeleteButton" runat="server" Text="Delete" SkinID="Button" OnClick="DeleteButton_Click" CausesValidation="false"/>
							<asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="grid_6 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="UsersCaption" runat="server" Text="Assigned Users"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:UpdatePanel ID="PagingAjax" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <cb:SortedGridView ID="UsersGrid" runat="server" DataSourceID="UsersDs" AllowPaging="True" 
                                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" PageSize="20" 
                                SkinID="PagedList" DefaultSortExpression="UserName" Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="User" SortExpression="UserName">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemTemplate>
                                            <asp:HyperLink ID="UserName" runat="server" Text='<%# Eval("UserName") %>' NavigateUrl='<%#Eval("Id", "~/Admin/People/Users/EditUser.aspx?UserId={0}") %>'></asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <asp:Label ID="EmptyMessage" runat="server" Text="There are no users associated with this group."></asp:Label>
                                </EmptyDataTemplate>
                            </cb:SortedGridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <asp:ObjectDataSource ID="UsersDs" runat="server" EnablePaging="True" OldValuesParameterFormatString="original_{0}" 
                SelectCountMethod="CountForGroup" SelectMethod="LoadForGroup" 
                SortParameterName="sortExpression" TypeName="CommerceBuilder.Users.UserDataSource">
                <SelectParameters>
                    <asp:QueryStringParameter Name="groupId" QueryStringField="GroupId"
                        Type="Object" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </div>
    </div>
</asp:Content>