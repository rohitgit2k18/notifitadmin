<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Marketing.Email.ManageUsers" Title="Manage Email List Members" CodeFile="ManageUsers.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <div class="pageHeader">
        	<div class="caption">
        		<h1><asp:Localize ID="Caption" runat="server" Text="Manage Users in {0}"></asp:Localize></h1>
        	</div>
        </div>
        <div class="searchPanel">
            <table class="inputForm">
                <tr>
                    <th>
                        <asp:Label ID="AlphabetRepeaterLabel" AssociatedControlID="AlphabetRepeater" runat="server" Text="Quick Search:" SkinID="FieldHeader"></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:Repeater runat="server" id="AlphabetRepeater" OnItemCommand="AlphabetRepeater_ItemCommand">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" ID="LinkButton1" CommandName="Display" CommandArgument="<%#Container.DataItem%>" Text="<%#Container.DataItem%>" ValidationGroup="Search" />
                        </ItemTemplate>                                    
                    </asp:Repeater>
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
                        <asp:Localize ID="SearchGroupLabel" runat="server" Text="Group:" EnableViewState="false"></asp:Localize>
                    </th>
                    <td>
                        <asp:DropDownList ID="SearchGroup" runat="server" Width="200px" AppendDataBoundItems="true">
                            <asp:ListItem Text=""></asp:ListItem>
                        </asp:DropDownList>
                    </td>                                   
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td colspan="5">
                        <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="SearchButton_Click" CausesValidation="false" />
                        <asp:HyperLink ID="FinishLink" runat="server" Text="Finish" NavigateUrl="Default.aspx" SkinID="Button"></asp:HyperLink>
                    </td>
                </tr>
            </table>
        </div>
        <div class="content">
            <cb:SortedGridView ID="SearchUsersGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="Email" 
                DefaultSortDirection="Ascending" DefaultSortExpression="U.UserName"
                AllowPaging="true" PageSize="20" AllowSorting="true" Width="100%" SkinID="PagedList">
                <Columns>
                    <asp:TemplateField HeaderText="In List">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:CheckBox ID="IsInEmailList2" runat="server" checked='<%#IsInEmailList(Container.DataItem)%>' OnCheckedChanged="IsInEmailList_CheckedChanged" AutoPostBack="true" ></asp:CheckBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="User Name" SortExpression="U.UserName">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:HyperLink ID="EditLink1" runat="server" Text='<%# Eval("UserName") %>' NavigateUrl='<%#GetEditUserUrl(Container.DataItem)%>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Email" SortExpression="U.Email">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:HyperLink ID="EditLink2" runat="server" Text='<%# Eval("Email") %>' NavigateUrl='<%#GetEditUserUrl(Container.DataItem)%>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Name" SortExpression="A.LastName">
                        <HeaderStyle horizontalalign="Left" />
                        <ItemStyle horizontalalign="Left" Width="200px"/>
                        <ItemTemplate>
                            <asp:Label ID="FullNameLabel2" runat="server" Text='<%#GetFullName(Container.DataItem)%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Groups">
                        <HeaderStyle horizontalalign="Left" />
                        <ItemStyle horizontalalign="Left" Width="200px" />
                        <ItemTemplate>
                            <asp:Label ID="GroupsLabel" runat="server" Text='<%#GetUserGroups(Container.DataItem)%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div align="center">
                        <asp:Label runat="server" ID="noUsersFound" enableViewState="false" Text="No matching users found."/>
                    </div>
                </EmptyDataTemplate>
            </cb:SortedGridView>
            <asp:ObjectDataSource ID="UserDs" runat="server" SelectMethod="Search" TypeName="CommerceBuilder.Users.UserDataSource"
                SelectCountMethod="SearchCount" EnablePaging="True" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Users.User" 
                DeleteMethod="Delete" OnSelecting="UserDs_Selecting">
                <SelectParameters>
                    <asp:Parameter Type="object" Name="criteria" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </div>
        <div class="section">
            <div class="header">
                <h2 class="customers"><asp:Localize ID="EmailListUsersCaption" runat="server" Text="Current Members of {0}" /></h2>
            </div>
            <div class="content">
                <cb:SortedGridView ID="UsersInEmailListGrid" runat="server" AllowPaging="True" PageSize="20" AllowSorting="True" AutoGenerateColumns="False"
                    DataKeyNames="Email" Width="100%" SkinID="PagedList" DataSourceID="EmailListUsersDs"
                    DefaultSortExpression="Email" DefaultSortDirection="Ascending" ShowWhenEmpty="False">
                    <Columns>
                        <asp:TemplateField HeaderText="In List">
                            <ItemStyle HorizontalAlign="Center" Width="80" />
                            <ItemTemplate>
                                <asp:CheckBox ID="IsInEmailList" runat="server" checked="true" OnCheckedChanged="IsInEmailList_CheckedChanged" AutoPostBack="true"></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Email" SortExpression="Email">
                            <ItemStyle HorizontalAlign="Left" Width="300" />
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:HyperLink ID="NameLink" runat="server" Text='<%# Eval("Email") %>' NavigateUrl='<%# GetEditUserUrl(Container.DataItem) %>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemStyle horizontalalign="Left" />
                            <HeaderStyle horizontalalign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="FullNameLabel" runat="server" Text='<%# GetFullName(Container.DataItem) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle HorizontalAlign="Center" />
                </cb:SortedGridView>
                <asp:ObjectDataSource ID="EmailListUsersDs" runat="server" EnablePaging="True" OldValuesParameterFormatString="original_{0}"
                    SelectCountMethod="CountForEmailList" SelectMethod="LoadForEmailList" SortParameterName="sortExpression"
                    TypeName="CommerceBuilder.Marketing.EmailListUserDataSource">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="emailListId" QueryStringField="EmailListId" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </div>
        </div>            
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>