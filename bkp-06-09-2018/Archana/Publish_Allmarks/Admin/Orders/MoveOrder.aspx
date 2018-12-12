<%@ Page Title="Move Order" Language="C#" MasterPageFile="~/Admin/Orders/Order.master" AutoEventWireup="true" CodeFile="MoveOrder.aspx.cs" Inherits="AbleCommerce.Admin.Orders.MoveOrder" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Change User '{0}' for Order # {1}" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="content">
        <asp:UpdatePanel ID="PageAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <cb:Notification ID="Message" runat="server" Text="Move order request is successfully processed." Visible="false" SkinID="GoodCondition" EnableViewState="false"></cb:Notification>
                <asp:ValidationSummary ID="ValidationSummary" runat="server" />
                <div class="searchPanel">
                    <table class="inputForm">
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
                            <td>&nbsp;</td>
                            <td colspan="4">
                                <asp:Button ID="SearchButton" runat="server" Text="Search" SkinID="Button" OnClick="SearchButton_Click" CausesValidation="false"/>
                                <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" NavigateUrl="ViewOrder.aspx?OrderNumber=" SkinID="CancelButton" EnableViewState="false" />
                            </td>
                        </tr>
                    </table>
                </div>
            <div class="content">
                <cb:AbleGridView ID="UserGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="UserId" 
                    DataSourceId="UserDs" AllowPaging="true" PageSize="20" PagerSettings-Position="TopAndBottom" 
                    TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching users" 
                    AllowSorting="true" SkinID="PagedList" Width="100%" OnRowCommand="UserGrid_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="User Name" SortExpression="UserName">
                            <HeaderStyle horizontalalign="Left" />
                            <ItemStyle horizontalalign="Left" Width="250px" />
                            <ItemTemplate>
                                <asp:Label ID="UserNameLabel" runat="server" Text='<%#Eval("UserName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Email" SortExpression="LoweredEmail">
                            <HeaderStyle horizontalalign="Left" />
                            <ItemStyle horizontalalign="Left" Width="250px" />
                            <ItemTemplate>
                                <asp:Label ID="EmailLabel" runat="server" Text='<%#Eval("LoweredEmail")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" SortExpression="A.LastName">
                            <HeaderStyle horizontalalign="Left" />
                            <ItemStyle horizontalalign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="FullNameLabel" runat="server" Text='<%#GetFullName(Container.DataItem)%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle horizontalalign="Right" Width="80" Wrap="False" />
                            <ItemTemplate>
                                <asp:Button ID="MoveButton" runat="server" CommandName="Select" CommandArgument='<%#Eval("UserId")%>' Text="Select" ToolTip="Select this User to move the order"  />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div align="center">
                            <asp:Label runat="server" ID="noUsersFound" enableViewState="false" Text="No users match the search criteria."/>
                        </div>
                    </EmptyDataTemplate>
                </cb:AbleGridView>
                <asp:ObjectDataSource ID="UserDs" runat="server" SelectMethod="Search" TypeName="CommerceBuilder.Users.UserDataSource"
                    SelectCountMethod="SearchCount" EnablePaging="True" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Users.User" 
                    OnSelecting="UserDs_Selecting">
                    <SelectParameters>
                        <asp:Parameter Type="object" Name="criteria" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <asp:Panel ID="MoveDialog" runat="server" Style="display:none;width:460px" CssClass="modalPopup">
                    <asp:Panel ID="DialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                        <asp:Localize ID="DialogCaption" runat="server" Text="Order # {0}: Transfer to {1}" EnableViewState="false"></asp:Localize>
                    </asp:Panel>
                    <div style="padding-top:5px;">
                        <table class="inputForm">
                            <tr>
                                <td colspan="2">
                                    <asp:Localize ID="DialogInstructionText" runat="server" Text="This will transfer/move the order from current user {0} to new user {1} you have selected. You can optionally update other details of the order by checking the appropriate boxes below:"></asp:Localize>
                                    <asp:Label ID="UpdatedMessage" runat="server" SkinID="GoodCondition" EnableViewState="false" Visible="false"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Checkbox ID="UpdateEmail" runat="server" Text="Update order email address." Checked="true" ></asp:Checkbox>
                                </th>
                                <th>
                                    <asp:Checkbox ID="UpdateBilling" runat="server" Text="Update order billing information." ></asp:Checkbox>
                                </th>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Localize ID="OrderNoteDescription" runat="server" Text="Type a brief explanation for the order transfer. This is for internal reference only." EnableViewState="false" />
                                </td>
                            </tr>
                            <tr> 
                                <td colspan="2">
                                    <asp:TextBox ID="TransferNote" runat="server" Columns="80" Rows="5" TextMode="MultiLine"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:Button ID="MoveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="MoveButton_Click" CausesValidation="false"/>
                                    <asp:Button ID="CancelMoveButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    </asp:Panel>
                    <asp:HiddenField ID="NewUserId" runat="server" />
                    <ajaxToolkit:ModalPopupExtender ID="TransferPopup" runat="server" 
                    TargetControlID="NewUserId"
                    PopupControlID="MoveDialog" 
                    BackgroundCssClass="modalBackground"                         
                    CancelControlID="CancelMoveButton" 
                    DropShadow="false"
                    PopupDragHandleControlID="DialogHeader" />
            </ContentTemplate>
        </asp:UpdatePanel>    
    </div>
</asp:Content>
