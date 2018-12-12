<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Marketing.Affiliates._Default" Title="Affiliates" CodeFile="Default.aspx.cs" %>
<%@ Register Namespace="Westwind.Web.Controls" assembly="wwhoverpanel" TagPrefix="wwh" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Affiliates"></asp:Localize></h1>
            	<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="people" />
    	</div>
    </div>
    <div class="grid_8 alpha">
        <div class="mainColumn">
            <div class="content">
                <asp:UpdatePanel ID="GridAjax" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <cb:SortedGridView ID="AffiliateGrid" runat="server" AllowPaging="true" AllowSorting="true" PageSize="20"
                            AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="AffiliateDs" 
                            ShowFooter="False" DefaultSortExpression="Name" SkinID="PagedList" Width="100%">
                            <Columns>
                                <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="NameLink" runat="server" NavigateUrl='<%#Eval("Id", "EditAffiliate.aspx?AffiliateId={0}")%>' Text='<%#Eval("Name")%>' SkinId="Link"></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Commission">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <%# GetCommissionRate(Container.DataItem) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Orders" ItemStyle-HorizontalAlign="Center">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="OrdersLink" runat="server" text='<%#GetOrderCount(Container.DataItem)%>' NavigateUrl='<%#Eval("Id", "../../Reports/SalesByAffiliateDetail.aspx?AffiliateId={0}") %>'></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Customers" ItemStyle-HorizontalAlign="Center">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <%#GetUserCount(Container.DataItem)%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ShowHeader="False">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%#Eval("Id", "EditAffiliate.aspx?AffiliateId={0}")%>'><asp:Image ID="EditIcon" SkinID="EditIcon" runat="server" AlternateText="Edit" /></asp:HyperLink>
                                        <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick='<%# Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\");") %>'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon"  AlternateText="Delete" /></asp:LinkButton>
                                    </ItemTemplate>
                                    <ItemStyle Wrap="false" />
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Label ID="EmptyDataText" runat="server" Text="No Affiliates are defined for your store."></asp:Label>
                            </EmptyDataTemplate>
                        </cb:SortedGridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <div class="grid_4 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="AddCaption" runat="server" Text="Add Affiliate" /></h2>
                </div>
                <div class="content">
                    <asp:UpdatePanel ID="AddAjax" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Label ID="AddAffiliateNameLabel" runat="server" Text="Name:" SkinID="FieldHeader"></asp:Label>&nbsp;
                            <asp:TextBox ID="AddAffiliateName" runat="server" MaxLength="100"></asp:TextBox>&nbsp;
                            <asp:Button ID="AddAffiliateButton" runat="server" Text="Add" SkinID="Button" OnClick="AddAffiliateButton_Click" ValidationGroup="Add" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:RequiredFieldValidator ID="AddAffiliateNameRequired" runat="server" ControlToValidate="AddAffiliateName"
                        Display="Dynamic" Text="Name is required." ValidationGroup="Add"></asp:RequiredFieldValidator>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
    <div class="section">
        <div class="header">
            <h2><asp:Localize ID="SettingsCaption" runat="server" Text="Affiliate Settings" /></h2>
        </div>
        <div class="content">
            <asp:UpdatePanel id="SettingsAjax" runat="server" >                    
                <contenttemplate>
                    <cb:Notification ID="AffiliateSettingsMessage" runat="server" Text="Affiliate settings saved at {0}." SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
                    <asp:ValidationSummary ID="SettingsValidationSummary" runat="server" ValidationGroup="Settings" />
                    <table class="inputForm compact">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AffiliateParameterLabel" runat="server" Text="Parameter Name:" ToolTip="Specify that parameter name that should be used in the query string to identify the referring affiliate.  For instance if you use 'afid' then external links will need to have ?afid=# (where # is the affiliate ID) appended to them to identify the affiliate.  WARNING: This setting is used for all affiliates.  If you have already created affiliates and they have posted links to your site, those links will need to be updated if you change this value." />
                            </th>
                            <td>
                                <asp:TextBox ID="AffiliateParameter" runat="server" ValidationGroup="Settings"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="AffiliateParameterRequired" runat="server" ControlToValidate="AffiliateParameter" ValidationGroup="Settings" Text="*" ErrorMessage="The affiliate parameter name is required."></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr id="trSelfSignup" runat="server">
                            <th>
                                <cb:ToolTipLabel ID="SelfSignupLabel" runat="server" Text="Enable Self Signup:" AssociatedControlID="SelfSignup" ToolTip="You can enable your customers to sign themselves up as affiliates to your store.  Enable this option and then configure the commission rates you will pay to your new affiliates.  This information will be displayed for the customer when they sign up." />
                            </th>
                            <td>
                                <asp:CheckBox ID="SelfSignup" runat="server" Checked="false" oncheckedchanged="SelfSignup_CheckedChanged" AutoPostBack="true" />
                            </td>
                        </tr>
                        <tr id="trPersistence" runat="server" visible="false">
                            <th>
                                <cb:ToolTipLabel ID="PersistenceLabel" runat="server" Text="Persistence:" ToolTip="Indicate how long orders will count for commissions after an affiliate refers a customer." />
                            </th>
                            <td colspan="2">
                                <asp:DropDownList ID="AffiliatePersistence" runat="server" 
                                    onselectedindexchanged="AffiliatePersistence_SelectedIndexChanged" AutoPostBack="true">
                                    <asp:ListItem Text="Persistent" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="First Order" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="First X Days" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="First Order Within X Days" Value="2"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr id="trReferralPeriod" runat="server" visible="false">
                            <th>
                                <cb:ToolTipLabel ID="AffiliateReferralPeriodLabel" runat="server" Text="Referral Period:" ToolTip="The number days for referrals sent by an affiliate."></cb:ToolTipLabel>
                            </th>
                            <td colspan="2">
                                <asp:TextBox ID="ReferralPeriod" runat="server" Columns="4" MaxLength="4"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="ReferralPeriodRequiredValidator" runat="server" ControlToValidate="ReferralPeriod" Text="*" ErrorMessage="You must specify number of days for referral." ValidationGroup="Settings"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="ReferralPeriodValidator" runat="server" Type="Integer" MinimumValue="1"  MaximumValue="9999" ControlToValidate="ReferralPeriod" ErrorMessage="Referral period must be a numeric value." Text="*" ValidationGroup="Settings"></asp:RangeValidator>
                            </td>
                        </tr>
                        <tr id="trCommissionRate" runat="server" visible="false">
                            <th>
                                <cb:ToolTipLabel ID="AffiliateCommissionRateLabel" runat="server" Text="Commission Rate" ToolTip="Indicate the amount paid for affiliate orders.  A fixed amount will be calculated per order and a percentage will be calculated on the total value of products in referred orders."></cb:ToolTipLabel><br />                                        </th>
                            <td colspan="2">
                                <asp:TextBox ID="CommissionRate" runat="server" Columns="4" MaxLength="8"></asp:TextBox>
                                <asp:DropDownList ID="CommissionType" runat="server" >
                                    <asp:ListItem Text="Flat rate"></asp:ListItem>
                                    <asp:ListItem Text="% of product subtotal"></asp:ListItem>
                                    <asp:ListItem Text="% of order total"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RangeValidator ID="CommissionRateValidator" runat="server" Type="Double" MinimumValue="0" MaximumValue="999999999" ControlToValidate="CommissionRate" ErrorMessage="Commission rate must be a numeric value greater than 0." Text="*" ValidationGroup="Settings"></asp:RangeValidator>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AffiliateReferralRuleLabel" runat="server" Text="Affiliate Referral Rule" ToolTip="Indicate if only New signups or existing users can be counted for affiliates, and affiliate value can be overridden or not at a later date by another referral."></cb:ToolTipLabel><br /></th>
                            <td colspan="2">                                
                                <asp:DropDownList ID="AffiliateReferralRule" runat="server">
                                    <asp:ListItem Text="New Signups Only" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="New Signups Or Existing Users No Override" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="New Signups Or Existing Users Override Affiliate" Value="2"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td colspan="2">
                                <asp:Button id="SaveButton" onclick="SaveButton_Click" runat="server" Text="Save" ValidationGroup="Settings"></asp:Button>
                            </td>
                        </tr>
                    </table>
                </contenttemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div class="section">
        <div class="header">
            <h2><asp:Localize ID="Localize1" runat="server" Text="Third-Party Tracking" /></h2>
        </div>
        <div class="content">
            <table class="inputForm compact">
                <tr>
                    <td colspan="2">   
                        <asp:Localize ID="TrackerHelpText" runat="server" Text="If you are using a third party tracker such as AffiliateWiz, you can provide the tracking URL here."></asp:Localize>
                        <a onmouseover="TrackerHelpHover.startCallback(event, null)" class="link" onmouseout="TrackerHelpHover.hide();" href="#">More Help</a>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="TrackerUrlCaption" runat="server" Text="Tracking Url: " SkinID="FieldHeader"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox id="TrackerUrl" runat="server" Width="400px" MaxLength="200"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <asp:ObjectDataSource ID="AffiliateDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Marketing.AffiliateDataSource" 
        SelectCountMethod="CountForStore" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Marketing.Affiliate" 
        DeleteMethod="Delete" UpdateMethod="Update">
    </asp:ObjectDataSource>
    <wwh:wwHoverPanel ID="TrackerHelpHover"
        runat="server" 
        serverurl="~/Admin/Marketing/Affiliates/TrackerHelp.htm"
        Navigatedelay="250"              
        scriptlocation="WebResource"
        style="display: none; background: white;" 
        panelopacity="0.89" 
        shadowoffset="8"
        shadowopacity="0.18"
        PostBackMode="None"
        AdjustWindowPosition="true">
    </wwh:wwHoverPanel>
</asp:Content>