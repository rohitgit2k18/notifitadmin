<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Create.CreateOrder1" Title="Place Order" CodeFile="CreateOrder1.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="Create Order: Identify User (Step 1 of 4)"></asp:Localize>
            </h1>
        </div>
    </div>
    <asp:UpdatePanel ID="BasketAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="grid_4 alpha">
                <div class="leftColumn">
                    <div class="section">
                        <asp:Panel id="SearchPanel" runat="server" DefaultButton="HiddenSearchButton" CssClass="content">                        
                            <table class="inputForm">
                                <tr>
                                    <td colspan="2">
                                        Locate the customer that the order will be placed for.  If the customer is unregistered click 'New Customer' to skip this step.
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Localize ID="SearchEmailLabel" runat="server" Text="Email:" EnableViewState="false"></asp:Localize>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SearchEmail" runat="server" Width="130px" MaxLength="200"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Localize ID="SearchFirstNameLabel" runat="server" Text="First Name:" EnableViewState="false"></asp:Localize>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SearchFirstName" runat="server" Width="130px" MaxLength="40"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Localize ID="SearchLastNameLabel" runat="server" Text="Last Name:" EnableViewState="false"></asp:Localize>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SearchLastName" runat="server" Width="130px" MaxLength="40"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:Button ID="HiddenSearchButton" runat="server" style="display:none" OnClick="SearchButton_Click" />
                                        <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="SearchButton_Click" />
                                        <asp:Button ID="NewUserButton" runat="server" Text="New Customer" OnClick="NewUserButton_Click" />
                                    </td>
                                </tr>
                            </table>                        
                        </asp:Panel>
                    </div>
                </div>
            </div>
            <div class="grid_8 omega">
                <div class="mainColumn">
                    <div class="content">
                        <cb:SortedGridView ID="UserGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" 
                            DataSourceId="UserDs" DefaultSortDirection="Ascending" DefaultSortExpression="LoweredUserName" 
                            AllowPaging="true" PagerStyle-CssClass="paging" PageSize="20" PagerSettings-Position="Bottom" 
                            AllowSorting="true" SkinID="PagedList" Width="100%" Visible="false">
                            <Columns>
                                <asp:TemplateField HeaderText="Select" >
                                    <HeaderStyle horizontalalign="Center" />
                                    <ItemStyle horizontalalign="Center" Width="50px" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="SelectUserLink" runat="server" NavigateUrl='<%# Eval("UserId", "CreateOrder2.aspx?UID={0}") %>'><asp:Image ID="LoginIcon" runat="server" SkinID="NewOrderIcon" AlternateText="Place Order for User" ToolTip="Place Order for User" /></asp:HyperLink>
                                   </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="User Name" SortExpression="LoweredUserName">
                                    <HeaderStyle horizontalalign="Left" />
                                    <ItemStyle horizontalalign="Left" Width="250px" />
                                    <ItemTemplate>
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%#Eval("UserName")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Name" SortExpression="A.LastName">
                                    <HeaderStyle horizontalalign="Left" />
                                    <ItemStyle horizontalalign="Left" />
                                    <ItemTemplate>
                                        <asp:Label ID="FullNameLabel" runat="server" Text='<%#GetFullName(Container.DataItem)%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Created" SortExpression="CreateDate">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <%# Eval("CreateDate", "{0:d}")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Last Active" SortExpression="LastActivityDate">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <%# Eval("LastActivityDate", "{0:d}")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div align="center">
                                    <asp:Label runat="server" ID="noUsersFound" enableViewState="false" Text="No users match the search criteria."/>
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
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>