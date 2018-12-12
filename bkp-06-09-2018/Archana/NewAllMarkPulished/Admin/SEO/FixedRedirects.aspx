<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.SEO.FixedRedirects" Title="Fixed Redirects" CodeFile="FixedRedirects.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Fixed Redirects"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/seo" />
        </div>
    </div>
    <asp:UpdatePanel ID="RedirectPanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="content">
                <p>Use this screen to view and manage fixed redirects for your store.  Fixed redirects are those where the request page and and the redirect URL are specific resources.  One and only one page is directly replaced by another.  If you need to configure redirects that cover many pages or even whole directories using pattern matching (regular expressions), you need to use <a href="dynamicredirects.aspx">dynamic redirects</a> instead.</p>
                <asp:PlaceHolder ID="IISVersionWarning" runat="server">
                    <p><asp:Localize ID="Localize1" runat="server" Text="NOTE: IIS6 or below is detected.  The request path must be an aspx page unless you have modified the IIS configuration." EnableViewState="false"></asp:Localize></p>
                </asp:PlaceHolder>
                <cb:SortedGridView ID="RedirectsGrid" runat="server" 
                    AutoGenerateColumns="False" 
                    AllowSorting="true"
                    DefaultSortExpression="SourceUrl" 
                    DefaultSortDirection="Ascending" 
                    AllowPaging="True" 
                    PagerStyle-CssClass="paging" 
                    PageSize="20" 
                    PagerSettings-Position="Bottom" 
                    SkinID="PagedList" 
                    DataSourceID="RedirectDs" 
                    DataKeyNames="RedirectId" 
                    ShowWhenEmpty="False"
                    width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="Request Page" SortExpression="SourceUrl">
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
                    <PagerStyle CssClass="paging" />
                </cb:SortedGridView>
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
                                <cb:ToolTipLabel ID="SourcePathLabel" runat="server" Text="Request Page:" AssociatedControlID="SourcePath" ToolTip="The URL of the page that is requested by the browser.  This must be a relative URL."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="SourcePath" runat="server" MaxLength="250" Width="250px" AutoComplete="off"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="SourcePathRequired" runat="server" ControlToValidate="SourcePath" ErrorMessage="Source page is required." Text="*" ValidationGroup="AddRedirect" Display="Dynamic"></asp:RequiredFieldValidator><br />
                                <asp:CustomValidator ID="UniqueSourcePathValidator" runat="server" ControlToValidate="SourcePath" ErrorMessage="Either a fixed or dynamic redirect is already defined for this request page. Request page must be unique." Text="*" Display="Dynamic" ValidationGroup="AddRedirect" ></asp:CustomValidator>
                                <asp:RegularExpressionValidator ID="FormattedSourcePathValidator" runat="server" ErrorMessage="Source page has an invalid format." Text="*" ValidationExpression="^([A-Za-z0-9\-\s_\\-\\.\\+%]+)(/[A-Za-z0-9\-\s_\\-\\.\\+%]+)*/?$" ControlToValidate="SourcePath" Display="Dynamic" ValidationGroup="AddRedirect"></asp:RegularExpressionValidator>
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
                            <td><asp:Label ID="SourcePathExample" runat="server" Text="page-to-be-redirected.aspx" CssClass="helpText"></asp:Label></td>
                            <td>&nbsp;</td>
                            <td><asp:Label ID="TargetPathExample" runat="server" Text="replacement-page.aspx" CssClass="helpText"></asp:Label></td>
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
        SelectMethod="LoadFixedRedirects" 
        SelectCountMethod="CountFixedRedirects" 
        TypeName="CommerceBuilder.SEO.RedirectDataSource" 
        EnablePaging="true" 
        SortParameterName="sortExpression" 
        DataObjectTypeName="CommerceBuilder.SEO.Redirect"
        DeleteMethod="Delete">
    </asp:ObjectDataSource>
</asp:Content>
