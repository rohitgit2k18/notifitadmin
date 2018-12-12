<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.Security.BlockedIPs" Title="Blocked IPs"  CodeFile="BlockedIPs.aspx.cs" AutoEventWireup="True" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Blocked IPs"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/security" />
        </div>
    </div>
    <div class="grid_6 alpha">
        <div class="leftColumn">
            <asp:UpdatePanel ID="GridAjax" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:GridView ID="BannedIPGrid" runat="server" AllowPaging="true" AllowSorting="false" PageSize="20"
                        AutoGenerateColumns="False" DataKeyNames="BannedIPId" DataSourceID="BannedIPDs" 
                        ShowFooter="False" SkinID="PagedList" Width="100%">
                        <Columns>
                            <asp:TemplateField HeaderText="Range Start">
                                <ItemStyle HorizontalAlign="Center" />
                                <ItemTemplate>
                                    <asp:Label ID="IPRangeStart" runat="server" Text='<%# Eval("DottedIPRangeStart") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Range End">
                                <ItemStyle HorizontalAlign="Center" />
                                <ItemTemplate>
                                    <asp:Label ID="IPRangeEnd" runat="server" Text='<%# Eval("DottedIPRangeEnd") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Comment">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <asp:Label ID="Comment" runat="server" Text='<%# Eval("Comment") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ShowHeader="False">
                                <ItemStyle Wrap="false" HorizontalAlign="center" />
                                <ItemTemplate>
                                    <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick="return confirm('Are you sure you want to delete this range?')"><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" /></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="EmptyDataText" runat="server" Text="You can use IP blocking to help prevent fraud or to stop unwanted search engines from visiting your store."></asp:Label>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div class="grid_6 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="AddCaption" runat="server" Text="Block IP Range" /></h2>
                </div>
                <div class="content">
                    <p><asp:Label ID="AddHelpText" runat="server" Text="Enter addresses in dotted notation like <b>127.0.0.1</b>.  To block a single address, leave the end field blank."></asp:Label></p>
                    <p><asp:Label ID="HelpText" runat="server" Text="<b>NOTE:</b> Any changes may take up to 30 minutes to take effect."></asp:Label></p>
                    <asp:UpdatePanel ID="AddAjax" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                            <cb:Notification ID="AddedMessage" runat="server" Text="New block added." SkinID="GoodCondition" Visible="false"></cb:Notification>
                            <table class="inputForm" cellpadding="4" cellspacing="0">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="AddIPRangeStartLabel" runat="server" Text="Start:" ToolTip="The first IP in the range to block." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="AddIPRangeStart" runat="server" TabIndex="1"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="AddBannedIPNameRequired" runat="server" ControlToValidate="AddIPRangeStart"
                                            Display="Static" ErrorMessage="You must enter an address in the start field." Text="*"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="AddIPRangeEndLabel" runat="server" Text="End:" ToolTip="The last IP in the range to block; leave blank to only block the IP listed in the start field." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="AddIPRangeEnd" runat="server" TabIndex="2"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="AddCommentLabel" runat="server" Text="Comment:" ToolTip="Optional comment to attach to the banned IP range." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="AddComment" runat="server" TabIndex="3" MaxLength="100"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td><asp:Button ID="AddButton" runat="server" Text="Add" TabIndex="4" OnClick="AddButton_Click" /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
    <asp:ObjectDataSource ID="BannedIPDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Stores.BannedIPDataSource" 
        SelectCountMethod="CountForStore" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Stores.BannedIP" 
        DeleteMethod="Delete" UpdateMethod="Update">
    </asp:ObjectDataSource>
</asp:Content>

