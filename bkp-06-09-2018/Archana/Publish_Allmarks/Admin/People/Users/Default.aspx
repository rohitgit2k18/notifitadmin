<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.People.Users._Default" Title="Users" CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript" language="javascript">
        function UsersSelected()
        {
            var count = 0;
            for(i = 0; i< document.forms[0].elements.length; i++){
                var e = document.forms[0].elements[i];
                var name = e.name;
                if ((e.type == 'checkbox') && (name.endsWith('SelectUserCheckBox')) && (e.checked))
                {
                    count ++;
                }
            }
            return (count > 0);
        }
    </script>
    <asp:UpdatePanel ID="SearchAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Users"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="people" />
                </div>
            </div>
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
                        <td>&nbsp;</td>
                        <td colspan="2">&nbsp;</td>
                        <td>
                            <asp:CheckBox ID="ShowDisabledUsers" runat="Server" />
                            <cb:ToolTipLabel ID="ShowDisabledUsersLabel" runat="server" Text="Show Only Disabled Users" AssociatedControlID="ShowDisabledUsers" ToolTip="If checked, only disabled user accounts will be shown in the search results." />
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
                        <td colspan="3">
                            <asp:DropDownList ID="SearchGroup" runat="server" Width="200px" AppendDataBoundItems="true">
                                <asp:ListItem Text=""></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td colspan="4">
                            <asp:Button ID="SearchButton" runat="server" Text="Search" SkinID="Button" OnClick="SearchButton_Click" CausesValidation="false"/>
                            <asp:Button ID="ResetSearchButton" runat="server" Text="Reset" SkinID="CancelButton" Visible="false" OnClick="ResetButton_Click" CausesValidation="false"/>
                            <asp:Button ID="AddUserLink" runat="server" Text="Add User" SkinID="AddButton" EnableViewState="false" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="content">
                <cb:Notification ID="UserAddedMessage" runat="server" Text="User {0} added." SkinID="GoodCondition" Visible="False" EnableViewState="false"></cb:Notification>
                <cb:AbleGridView ID="UserGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="UserId" 
                    DataSourceId="UserDs" AllowPaging="true" PageSize="20" PagerSettings-Position="TopAndBottom" 
                    TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching users" 
                    AllowSorting="true" SkinID="PagedList" Width="100%" OnRowCommand="UserGrid_RowCommand">
                    <Columns>
                        <asp:TemplateField>
                            <HeaderStyle horizontalalign="Center" />
                            <ItemStyle horizontalalign="Center" Width="20px" />
                            <HeaderTemplate>
                                <input id="ALL" type="checkbox" runat="server" class="allRowsSelector" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <input id="SelectUserCheckBox" type="checkbox" runat="server" class="rowSelector" value='<%#Eval("Id")%>' />
                           </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="User Name" SortExpression="UserName">
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
                        <asp:TemplateField HeaderText="Groups">
                            <HeaderStyle horizontalalign="Left" />
                            <ItemStyle horizontalalign="Left" Width="250px" />
                            <ItemTemplate>
                                <asp:Label ID="GroupsLabel" runat="server" Text='<%#GetUserGroups(Container.DataItem)%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle horizontalalign="Right" Width="80" Wrap="False" />
                            <ItemTemplate>
                                <asp:ImageButton ID="LoginUserButton" runat="server" CommandName="Login" OnClientClick='<%# Eval("UserName", "return confirm(\"Are you sure you want to login as {0}?\")") %>' CommandArgument='<%#Eval("UserId")%>' Visible='<%#IsNotMeOrAdmin(Container.DataItem)%>' SkinID="LoginIcon" AlternateText="Login as User" ToolTip="Login As User" />
                                <asp:HyperLink ID="EditUserLink" runat="server" NavigateUrl='<%# Eval("UserId", "EditUser.aspx?UserId={0}") %>' Visible='<%#IsEditable(Container.DataItem)%>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit User" ToolTip="Edit User" /></asp:HyperLink>
                                <asp:ImageButton ID="DeleteUserButton" runat="server" CommandName="Delete" OnClientClick='<%# Eval("UserName", "return confirm(\"Are you sure you want to delete {0}?\")") %>' Visible='<%#IsDeletable(Container.DataItem)%>' SkinID="DeleteIcon" AlternateText="Delete User" ToolTip="Delete User"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div align="center">
                            <asp:Label runat="server" ID="noUsersFound" enableViewState="false" Text="No users match the search criteria."/>
                        </div>
                    </EmptyDataTemplate>
                </cb:AbleGridView>   
                <div id="gridFooter" runat="server" clientidmode="Static">
                    <span id="gridSelectionCount">0</span> Selected Item(s): 
                    <select id="gridAction">
                        <option />
                        <option value="Export">Export</option>
                    </select>
                    <asp:Button ID="BatchButton" runat="server" Text="Go" OnClick="BatchButton_Click" OnClientClick="return gridGo();" />
                    <input type="hidden" id="SelectedUserIds" name="SelectedUserIds" />
                </div>
                <br />
                <asp:Button ID="SendEmailSelected" runat="server" Text="Email Selected Users" SkinID="Button" OnClick="SendEmailSelected_Click" ValidationGroup="UserSelection" OnClientClick="if(!UsersSelected()){alert('No user(s) selected. Please select at least one user.'); return false;}"  />                          
                <asp:Button ID="SendEmailAll" runat="server" Text="Email All Users In Search" SkinID="Button" OnClick="SendEmailAll_Click" ValidationGroup="UserSelection" />                          
                <asp:CustomValidator ID="UserSelectionValidator" runat="server" ValidationGroup="UserSelection"  Text="No users selected." ErrorMessage="No user selected." EnableViewState="false"/>
            </div>
            <asp:ObjectDataSource ID="UserDs" runat="server" SelectMethod="Search" TypeName="CommerceBuilder.Users.UserDataSource"
                SelectCountMethod="SearchCount" EnablePaging="True" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Users.User" 
                DeleteMethod="Delete" OnSelecting="UserDs_Selecting">
                <SelectParameters>
                    <asp:Parameter Type="object" Name="criteria" />
                </SelectParameters>
            </asp:ObjectDataSource>                              
            <div id="selectAllDialog" title="Expand Selection?">
                <p>You have selected only the items on the current page.</p>
                <p><a href="javascript:selectAll()">select results from all pages</a></p>
            </div>
            <asp:Panel ID="AddDialog" runat="server" Style="display:none;width:450px" CssClass="modalPopup">
                <asp:Panel ID="AddDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                    <asp:Localize ID="AddDialogCaption" runat="server" Text="Add User" EnableViewState="false"></asp:Localize>
                </asp:Panel>
                <div style="padding-top:5px;">
                    <table class="inputForm">
                        <tr>
                            <td colspan="2">
                                <asp:Localize ID="AddInstructionText" runat="server" Text="Provide the details for the new user below:"></asp:Localize>
                                <asp:ValidationSummary ID="AddValidationSummary" runat="server" ValidationGroup="AddUser" />
                                <asp:Label ID="ErrorMessage" runat="server" SkinID="ErrorCondition" EnableViewState="false" Visible="false"></asp:Label>
                                <asp:Label ID="AddedMessage" runat="server" SkinID="GoodCondition" EnableViewState="false" Visible="false"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AddEmailLabel" runat="server" Text="Email (User Name):" AssociatedControlID="AddEmail" ToolTip="Email address of the user to add.  This will also be their user name."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="AddEmail" runat="server" MaxLength="200" Width="250px"></asp:TextBox><span class="requiredField">*</span>
                                <asp:PlaceHolder ID="phEmailValidation" runat="server"></asp:PlaceHolder>                                    
                                <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="AddEmail" ValidationGroup="AddUser" Required="true" ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>                                
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AddPasswordLabel" runat="server" Text="Password:" AssociatedControlID="AddPassword" ToolTip="Initial password for the new user."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="AddPassword" runat="server" TextMode="Password" Columns="20"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="AddPasswordRequired" runat="server" ControlToValidate="AddPassword"
                                    ErrorMessage="Password is required." Text="*" ValidationGroup="AddUser" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:PlaceHolder ID="phPasswordValidation" runat="server"></asp:PlaceHolder>                                    
                            </td>
                       </tr>
                       <tr>     
                            <th>
                                <cb:ToolTipLabel ID="AddConfirmPasswordLabel" runat="server" Text="Retype Password:" AssociatedControlID="AddConfirmPassword" ToolTip="Retype the initial password for the new user."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="AddConfirmPassword" runat="server" TextMode="Password" Columns="20"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="AddConfirmPasswordRequired" runat="server" ControlToValidate="AddConfirmPassword"
                                    ErrorMessage="You must retype the password." Text="*" ValidationGroup="AddUser" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="AddPasswordCompare" runat="server" ControlToCompare="AddPassword"
                                    ControlToValidate="AddConfirmPassword" ErrorMessage="You did not retype the password correctly."
                                    Text="*" ValidationGroup="AddUser" Display="Dynamic"></asp:CompareValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:CheckBox ID="ForceExpiration" runat="server" Checked="true" />
                                <asp:Label ID="ForceExpirationLabel" runat="server" AssociatedControlID="ForceExpiration" Text="User must change password at next login"></asp:Label>
                            </td>
                        </tr>
                        <tr id="trAddGroup" runat="server">
                            <th valign="top">
                                <cb:ToolTipLabel ID="AddGroupLabel" runat="server" Text="Group:" AssociatedControlID="AddGroup" ToolTip="If desired select a group that the user should be added to.  If you need to add to multiple groups, edit the user after saving."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:DropDownList ID="AddGroup" runat="server" DataTextField="Name" DataValueField="GroupId" AppendDataBoundItems="true">
                                    <asp:ListItem Text=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="AddButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" ValidationGroup="AddUser" />
                                <asp:Button ID="AddEditButton" runat="server" Text="Save and Edit" SkinID="SaveButton" OnClick="SaveButton_Click" ValidationGroup="AddUser" />
                                <asp:Button ID="CancelAddButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
            <ajaxToolkit:ModalPopupExtender ID="AddPopup" runat="server" 
                TargetControlID="AddUserLink"
                PopupControlID="AddDialog" 
                BackgroundCssClass="modalBackground"                         
                CancelControlID="CancelAddButton" 
                DropShadow="false"
                PopupDragHandleControlID="AddDialogHeader" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <script language="javascript" type="text/javascript">
        var allSelected = false;

        function updateSelectedCount() {
            allSelected = false;
            if ($('#selectAllDialog').dialog("isOpen")) $('#selectAllDialog').dialog("close");
            var selectedRows = $(".rowSelector:checked").length;
            $("#gridSelectionCount").text(selectedRows.toString());
            var totalRows = $(".rowSelector").length;
            var allRowsSelector = $(".allRowsSelector:first");
            allRowsSelector.attr("checked", (totalRows == selectedRows));
            var resultSize = parseInt($('#searchCount').text());
            var pageSize = parseInt($('#<%=UserGrid.ClientID%> select').val());
            if ((totalRows == selectedRows) && (resultSize > pageSize)) {
                var position = allRowsSelector.position();
                var x = position.left + $(allRowsSelector).outerWidth() + 20;
                var y = position.top - $(document).scrollTop();
                $('#selectAllDialog').dialog( "open" );
                $('#selectAllDialog').dialog({ "show": { effect: "slide", duration: 100 }, "hide": { effect: "slide", duration: 100 }, "position": [x, y], resizable: false, height: 120 });
                setTimeout(function () { if ($('#selectAllDialog').dialog("isOpen")) { $('#selectAllDialog').dialog({ hide: { effect: "slide", duration: 500} }).dialog("close"); } }, 4000);
            }
        }

        function selectAll() {
            $('#gridSelectionCount').text($('#searchCount').text());
            if ($('#selectAllDialog').dialog("isOpen")) $('#selectAllDialog').dialog("close");
            allSelected = true;
        }

        function toggleAll(cb) {
            $(".rowSelector").each(function () { this.checked = cb.checked });
            updateSelectedCount();
        }

        function gridGo() {
            // validate our action
            var action = $("#gridAction").val();
            if (action != "Export") {
                alert("You must select an action to perform.");
                return false;
            }

            // validate we have some rows
            var selectedRowCount = $(".rowSelector:checked").length;
            if (selectedRowCount < 1) {
                alert("You must select at least one item.");
                return false;
            }

            // choose the correct the action
            var selectedRows = new Array();
            $(".rowSelector:checked").each(function () { selectedRows.push(this.value); });            
            if (action == "Export") {
            // redirect to export
            if (allSelected) window.location.href = "../../DataExchange/UsersExport.aspx?type=filter&filter=" + encodeURIComponent(JSON.stringify(searchQuery));
            else 
            {
                $("#SelectedUserIds").val(selectedRows.join(","));
                return true;
            }
            }
            return false;
        }

        function bindEvents() {
            $(".rowSelector").click(updateSelectedCount);
            $(".allRowsSelector").click(function () { toggleAll(this) });
            $('#selectAllDialog').dialog({ autoOpen: false });
        }

        $(document).ready(function () {
            bindEvents();
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () { bindEvents() });
        });

    </script>
</asp:Content>