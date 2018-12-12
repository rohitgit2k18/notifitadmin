<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.People.Groups.ManageUsers" Title="Manage Users in Group"  CodeFile="ManageUsers.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Manage Users in {0}"></asp:Localize></h1>
    	</div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="searchPanel">
                <table class="inputForm">
                    <tr>
                        <th>
                            <asp:Label ID="AlphabetRepeaterLabel" AssociatedControlID="AlphabetRepeater" runat="server" Text="Quick Search:"></asp:Label>
                        </th>
                        <td colspan="2">
                            <asp:Repeater runat="server" id="AlphabetRepeater" OnItemCommand="AlphabetRepeater_ItemCommand">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ID="LB" CommandName="Display" CommandArgument="<%#Container.DataItem%>" Text="<%#Container.DataItem%>" ValidationGroup="Search" />
                                </ItemTemplate>                                    
                            </asp:Repeater>
                        </td>
                        <td>
                            <asp:CheckBox ID="SearchIncludeAnonymous" runat="Server" />
                            <cb:ToolTipLabel ID="SearchIncludeAnonymousLabel" runat="server" Text="Include Anonymous Users" AssociatedControlID="SearchIncludeAnonymous" ToolTip="If checked, anonymous users will be included in the search results." />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Localize ID="SearchEmailLabel" runat="server" Text="Email:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="SearchEmail" runat="server" Width="200px" MaxLength="200"></asp:TextBox>
                        </td>
                        <th>
                            <asp:Localize ID="SearchUserNameLabel" runat="server" Text="User Name:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="SearchUserName" runat="server" Width="200px" MaxLength="200"></asp:TextBox>
                        </td>
                     </tr>
                     <tr>
                        <th>
                            <asp:Localize ID="SearchFirstNameLabel" runat="server" Text="First Name:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="SearchFirstName" runat="server" Width="200px" MaxLength="40"></asp:TextBox>
                        </td>
                        <th>
                            <asp:Localize ID="SearchLastNameLabel" runat="server" Text="Last Name:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="SearchLastName" runat="server" Width="200px" MaxLength="40"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Localize ID="SearchCompanyLabel" runat="server" Text="Company:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="SearchCompany" runat="server" Width="200px" MaxLength="200"></asp:TextBox>
                        </td>
                        <th>
                            <asp:Localize ID="SearchPhoneLabel" runat="server" Text="Phone:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="SearchPhone" runat="server" Width="200px" MaxLength="200"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Localize ID="SearchGroupLabel" runat="server" Text="Group:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:DropDownList ID="SearchGroup" runat="server" Width="200px" AppendDataBoundItems="true">
                                <asp:ListItem Text=""></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="ShowAssignFilterLabel" runat="server" Text="Show:" EnableViewState="false" ToolTip="Select options to show all users irrespective of group selection or only users assigned to selected group or only users which are not assigned to selected group."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="ShowAssignFilter" runat="server" Width="200px">
                                <asp:ListItem Text="All Users" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Assigned Users Only" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Unassigned Users only" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td colspan="3">
                            <asp:Button ID="Button1" runat="server" Text="Search" SkinID="Button" OnClick="SearchButton_Click" />
                            <asp:Button ID="ResetButton" runat="server" Text="Reset" OnClick="ResetButton_Click" />
                            <asp:HyperLink ID="BackLink" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="Default.aspx"></asp:HyperLink>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="content">
                <cb:AbleGridView ID="SearchUsersGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="UserId" 
                    DefaultSortDirection="Ascending" DefaultSortExpression="UserName" DataSourceID="UserDs"
                    AllowPaging="true" AllowSorting="true" Width="100%" SkinID="PagedList">
                    <Columns>
                        <asp:TemplateField HeaderText="In Group">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:CheckBox ID="IsInGroup2" runat="server" checked='<%#IsInGroup(Container.DataItem)%>' Enabled='<%#EnableChange(Container.DataItem)%>' OnCheckedChanged="IsInGroup_CheckedChanged" AutoPostBack="true" ></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="User Name" SortExpression="UserName">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:HyperLink ID="UserNameLabel" runat="server" NavigateUrl='<%# Eval("UserId", "~/Admin/People/Users/EditUser.aspx?UserId={0}") %>' Text='<%#Eval("UserName")%>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Email" SortExpression="Email">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="EmailLabel" runat="server" Text='<%#Eval("Email")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <HeaderStyle horizontalalign="Left" />
                            <ItemStyle horizontalalign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="FullNameLabel2" runat="server" Text='<%#GetFullName(Container.DataItem)%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label runat="server" ID="noUsersFound" enableViewState="false" Text="No matching users found."/>
                    </EmptyDataTemplate>
                </cb:AbleGridView>
                <asp:ObjectDataSource ID="UserDs" runat="server" SelectMethod="Search" TypeName="CommerceBuilder.Users.UserDataSource"
                    SelectCountMethod="SearchCount" EnablePaging="True" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Users.User" 
                    DeleteMethod="Delete" OnSelecting="UserDs_Selecting">
                    <SelectParameters>
                        <asp:Parameter Type="object" Name="criteria" />
                    </SelectParameters>
            </asp:ObjectDataSource>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>