<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.SEO.DynamicRedirects" Title="Dynamic Redirects" CodeFile="DynamicRedirects.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Dynamic Redirects"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/seo" />
        </div>
    </div>
    <asp:UpdatePanel ID="RedirectAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="content">
                <p>Use this screen to view and manage dynamic redirects for your store.  Dynamic redirects are those that use regular expression syntax and pattern matching to redirect multiple URLs.  If you only need to redirect one page to another, use <a href="fixedredirects.aspx">fixed redirects</a> instead.</p>
                <asp:PlaceHolder ID="IISVersionWarning" runat="server">
                    <p><asp:Localize ID="IISVersionWarningText" runat="server" Text="NOTE: IIS6 or below is detected.  The request path must be an aspx page unless you have modified the IIS configuration." EnableViewState="false"></asp:Localize></p>
                </asp:PlaceHolder>
                <asp:GridView ID="RedirectsGrid" runat="server" 
                    AutoGenerateColumns="False" 
                    AllowSorting="False"
                    AllowPaging="False" 
                    SkinID="PagedList" 
                    DataSourceID="RedirectDs" 
                    DataKeyNames="RedirectId" 
                    width="100%"
                    OnRowCommand="RedirectsGrid_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="Order">
                            <HeaderStyle HorizontalAlign="center" Width="10%" />
                            <ItemStyle Width="78px" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:ImageButton ID="MU" runat="server" CommandName="Do_Up" ToolTip="Move Up" CommandArgument='<%#Eval("RedirectId")%>' SkinId="UpIcon"></asp:ImageButton>
                                <asp:ImageButton ID="MD" runat="server" CommandName="Do_Down" ToolTip="Move Down" CommandArgument='<%#Eval("RedirectId")%>' SkinId="DownIcon"></asp:ImageButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Request Path" SortExpression="SourceUrl">
                            <HeaderStyle horizontalalign="Left" />
                            <ItemStyle horizontalalign="Left" width="40%" />
                            <ItemTemplate>
                                <%#Eval("SourceUrl")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Redirect To" SortExpression="TargetUrl">
                            <HeaderStyle horizontalalign="Left" />
                            <ItemStyle horizontalalign="Left" width="40%" />
                            <ItemTemplate>
                                <%#Eval("TargetUrl")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created" SortExpression="CreatedDate">
                            <HeaderStyle horizontalalign="Center" />
                            <ItemStyle horizontalalign="Center" width="10%" />
                            <ItemTemplate>
                                <asp:Literal ID="CreatedDate" runat="server" Text='<%#Eval("CreatedDate", "{0:d}")%>' Visible='<%# ShowDate(Eval("CreatedDate")) %>'></asp:Literal>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Last&nbsp;Visited" SortExpression="LastVisitedDate">
                            <HeaderStyle horizontalalign="Center" />
                            <ItemStyle horizontalalign="Center" width="10%" />
                            <ItemTemplate>
                                <asp:Literal ID="LastVisited" runat="server" Text='<%#Eval("LastVisitedDate", "{0:d}")%>' Visible='<%# ShowDate(Eval("LastVisitedDate")) %>'></asp:Literal>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Visits" SortExpression="VisitCount">
                            <HeaderStyle horizontalalign="Center" />
                            <ItemStyle horizontalalign="Center"  />
                            <ItemTemplate>
                                <%#Eval("VisitCount")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remove">
                            <HeaderStyle horizontalalign="Center" />
                            <ItemStyle horizontalalign="Center" Width="10%" />
                            <ItemTemplate>
                                <asp:ImageButton ID="RemoveButton" runat="Server" CommandName="Delete" SkinId="DeleteIcon" OnClientClick="return confirm('Are you sure you want to delete this redirect?')"></asp:ImageButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="AddCaption" runat="server" Text="Add Redirect" /></h2>
                </div>
                <asp:Panel ID="AddPanel" runat="server" DefaultButton="SaveButton" CssClass="content">
                    <asp:ValidationSummary ID="AddValidationSummary" runat="server" ValidationGroup="AddRedirect" />
                    <table class="inputForm">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="SourcePathLabel" runat="server" Text="Request Path:" AssociatedControlID="SourcePath" ToolTip="The URL of the page that is requested by the browser.  This must be a relative URL."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="SourcePath" runat="server" MaxLength="250" Width="250px" AutoComplete="off"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="SourcePathRequired" runat="server" ControlToValidate="SourcePath" ErrorMessage="Source path is required." Text="*" ValidationGroup="AddRedirect" Display="Dynamic"></asp:RequiredFieldValidator><br />
                                <asp:CustomValidator ID="UniqueSourcePathValidator" runat="server" ControlToValidate="SourcePath" ErrorMessage="Either a fixed or dynamic redirect is already defined for this request path. Request path must be unique." Text="*" Display="Dynamic" ValidationGroup="AddRedirect" ></asp:CustomValidator>
                            </td>
                            <th>
                                <cb:ToolTipLabel ID="TargetPathLabel" runat="server" Text="Redirect To:" AssociatedControlID="TargetPath" ToolTip="This is the page that the browser is redirected to.  This can be relative or absolute, in other words you coul redirect the browser to another domain like http://someotherdomain/someotherpage.htm."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="TargetPath" runat="server" MaxLength="250" Width="250px" AutoComplete="off"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="TargetPathRequired" runat="server" ControlToValidate="TargetPath"
                                    ErrorMessage="Target path is required." Text="*" ValidationGroup="AddRedirect" Display="Dynamic"></asp:RequiredFieldValidator><br />
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td><asp:Label ID="SourcePathExample" runat="server" Text="Images/(.*)" CssClass="helpText"></asp:Label></td>
                            <td>&nbsp;</td>
                            <td><asp:Label ID="TargetPathExample" runat="server" Text="Assets/ProductImages/$1" CssClass="helpText"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="SaveButton" runat="server" Text="Save" ValidationGroup="AddRedirect" OnClick="SaveButton_Click" />
                            </td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="RedirectDs" runat="server" 
        OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadDynamicRedirects" 
        SelectCountMethod="CountDynamicRedirects" 
        TypeName="CommerceBuilder.SEO.RedirectDataSource" 
        EnablePaging="false" 
        SortParameterName="sortExpression" 
        DataObjectTypeName="CommerceBuilder.SEO.Redirect"
        DeleteMethod="Delete">
    </asp:ObjectDataSource>
</asp:Content>
