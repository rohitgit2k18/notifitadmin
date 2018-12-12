<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin._Store.Security._Default" Title="System Settings" CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <script language="javascript" type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(pageLoaded);
        function pageLoaded() {
            $('#<%=SecureAllPages.ClientID%>').change(function () {
                var a = document.createElement('a');
                a.href = $('#<%=StoreUrl.ClientID%>').val();
                if ($(this).is(':checked')) {
                    a.protocol = "https:";
                }
                else {
                    a.protocol = "http:";
                }
                $('#<%=StoreUrl.ClientID%>').val(a.href);
            });

            $('#<%=SSLEnabled.ClientID%>').change(function () {
                var a = document.createElement('a');
                a.href = $('#<%=StoreUrl.ClientID%>').val();
                if ($(this).is(':checked')) {
                    if ($('#<%=SecureAllPages.ClientID%>').prop("checked")) {
                        a.protocol = "https:";
                    }
                }
                else {
                    a.protocol = "http:";
                }
                $('#<%=StoreUrl.ClientID%>').val(a.href);
            });
        }
    </script>
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="System Settings"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/security" />
                </div>
            </div>
            <div class="content aboveGrid">
                <asp:Button ID="SaveButton" runat="server" Text="Save Settings" SkinID="SaveButton" OnClick="SaveButton_Click" OnClientClick="if(Page_ClientValidate()){this.value='Saving...';this.enabled=false;}" />
                <asp:ValidationSummary ID="ValidationSummary1" runat="Server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="System settings saved at {0}" Visible="false" EnableViewState="false" SkinId="GoodCondition"></cb:Notification>
            </div>
            <div class="grid_6 alpha">
                <div class="leftColumn">
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="UrlCaption" runat="server" Text="Store URL Settings"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Localize ID="StoreUrlHelpText" runat="server" EnableViewState="false">
                                Enter the URL to your store home page.  This should use your licensed domain and may be used in areas where relative links are not acceptable, such as customer email notifications.  SSL must be enabled to securely collect customer and payment details over the Internet.<br /><br />
                            </asp:Localize>
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="StoreUrlLabel" runat="Server" Text="Store URL:" AssociatedControlID="StoreUrl" ToolTip="The URL to your store home page." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="StoreUrl" runat="server" Width="250px" MaxLength="250"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="StoreUrlRequired" runat="server" ControlToValidate="StoreUrl"
                                            Display="Dynamic" ErrorMessage="Store URL is required." Text="*"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="StoreUrlFormat" runat="server" ControlToValidate="StoreUrl"
                                            Display="Dynamic" ErrorMessage="Store URL should be in the format of http://domain/directory/.  It should not include a page name and should end with the / slash." Text="*"
                                            ValidationExpression="^https?://([^/]+?/)+$"></asp:RegularExpressionValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="SSLEnabledLabel" runat="server" Text="SSL Enabled:" ToolTip="SSL is used to create a secure connection between your website and the customer.  Running a live/production site without SSL is not recommended and not supported." />
                                    </th>
                                    <td>
                                        <table cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width:40px;">
                                                    <asp:CheckBox ID="SSLEnabled" runat="server" AutoPostBack="true" />
                                                </td>
                                                <th>
                                                    <asp:HyperLink ID="SecureAllPagesLabel" runat="server" title="Use this option to apply SSL over entire store. Specific directories/pages can be excluded using SSL configuration file." NavigateUrl="#" CssClass="toolTip"><span>Secure All Pages:</span></asp:HyperLink>
                                                </th>
                                                <td>
                                                    <asp:CheckBox ID="SecureAllPages" runat="server" />
                                                </td>
                                            </tr>
                                        </table>
                                        
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asp:Localize ID="SSLDomainHelpText" runat="server">
                                            <br /><b>NOTE:</b> Do not enter the SSL Domain unless it is different from your store domain.  If you provide this value, you must have a license key installed that 
                                            includes the alternate domain.
                                        </asp:Localize>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="SSLDomainLabel" runat="server" Text="SSL Domain:" ToolTip="If your SSL domain is different from your regular domain, provide it here.  For example: secure.yoursite.com" />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SSLDomain" runat="Server" Text="" width="250px"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="SSLDomainFormat" runat="server" ControlToValidate="SSLDomain"
                                            Display="Dynamic" ErrorMessage="SSL Domain should be in the format of yourdomain.tld and should not include elements like http:// or a page name." Text="*"
                                            ValidationExpression="^(?:[A-Za-z0-9][A-Za-z0-9\-]*\.)+[A-Za-z0-9][A-Za-z0-9\-]+$"></asp:RegularExpressionValidator>
                                        <asp:PlaceHolder ID="phSslDomain" runat="server"></asp:PlaceHolder><br />
                                        example: secure.mydomain.tld
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asp:Localize ID="MobileDomainHelpText" runat="server">
                                            Normally the mobile version of your store is accessed through the /mobile directory.  If desired you can use a subdomain (like m.ablecommerce.com) for mobile access instead.  Any subdomains supported by your store license will appear in the drop down below:
                                        </asp:Localize>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="MobileDomainLabel" runat="Server" Text="Mobile Domain:" AssociatedControlID="MobileDomain" ToolTip="The domain you want to use for your mobile store." />
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="MobileDomain" runat="server" AppendDataBoundItems="true">
                                            <asp:ListItem Text="Use /mobile directory" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="FileExtCaption" runat="server" Text="File Upload Filters"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Localize ID="FileExtHelpText" runat="server" EnableViewState="false">
                                You can specify the file types that will be accepted for upload through the AbleCommerce web interface.  List the allowed file extensions for each interface.  If the value is unspecified, all file types are accepted for upload.  For best security, it is recommended that you only list the minimum extensions required.<br /><br />
                                To specify file types, enter the extensions in a comma delimited list.<br />For example: <b>gif, jpg</b><br /><br />
                            </asp:Localize>
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="FileExtAssetsLabel" runat="server" Text="Assets:" ToolTip="File types that can be uploaded to the product assets manager." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="FileExtAssets" runat="server" Text="" MaxLength="200" Width="300px" EnableViewState="false"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="FileExtThemesLabel" runat="server" Text="Themes:" ToolTip="File types that can be uploaded to the themes manager." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="FileExtThemes" runat="server" Text="" MaxLength="200" Width="300px" EnableViewState="false"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="FileExtDigitalGoodsLabel" runat="server" Text="Digital Goods:" ToolTip="File types that can be uploaded from digital goods management." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="FileExtDigitalGoods" runat="server" Text="" MaxLength="200" Width="300px" EnableViewState="false"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear"></div>
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="PaymentSecurityCaption" runat="server" Text="Credit Card Data Storage"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:UpdatePanel ID="CCAjax" runat="server">
                    <ContentTemplate>
                        <table class="inputForm">
                            <tr>
                                <th>
                                    <asp:Label ID="EnableCreditCardStorageLabel" runat="Server" Text="Enable Payment Data Storage:" AssociatedControlID="EnableCreditCardStorage" ToolTip=""></asp:Label>
                                </th>
                                <td>
                                    <asp:CheckBox ID="EnableCreditCardStorage" runat="server" AutoPostBack="true" />
                                </td>
                                <td>
                                    <asp:Label ID="EnableCreditCardStorageHelpText" runat="server" Text="When credit card storage is enabled, encrypted card data is saved in the database for payment processing according to setting above.  If you choose not to enable storage of account data, credit card numbers will never be saved to the database under any circumstance."></asp:Label>
                                </td>
                            </tr>
                            <tr>
                            
                                <th>
                                    <asp:Label ID="PaymentSecurityLabel" runat="Server" SkinID="FieldHeader" Text="Days to Save: "></asp:Label>
                                </th>
                                <td>
                                    <asp:DropDownList ID="PaymentLifespan" runat="server">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:Localize ID="PaymentSecurityHelpText" runat="server">
                                    After a payment is successfuly processed, how many days would you like to retain associated account numbers and payment details?  The most secure option is to not save by setting to 0, but you may need to retain the details for post order processing.
                                    </asp:Localize>
                                </td>
                            </tr>
                        </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <asp:HiddenField ID="DummyTarget" runat="server" />
            <asp:Panel ID="ChangeSslDialog" runat="server" Style="display:none;width:450px" CssClass="modalPopup">
                <asp:Panel ID="ChangeSslHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                    <asp:Localize ID="ChangeSslCaption" runat="server" Text="URL/SSL Modification Detected" EnableViewState="false"></asp:Localize>
                </asp:Panel>
                <div style="padding-top:5px;">
                    <p><asp:Localize ID="ChangeSslInstructionText" runat="server" Text="You have made a change that impacts the address used to access the store via SSL.  Making this change incorrectly can lock you out of the admin, so please take a moment to click the link below and confirm the page loads properly.<br /><br />This link will open in a new window."></asp:Localize></p>
                    <p><asp:HyperLink ID="TestSslUrl" runat="server" Target="_blank"></asp:HyperLink></p>
                    <asp:Button ID="ConfirmChangeSslButton" runat="server" Text="Confirm Change" OnClick="ConfirmChangeSslButton_Click" />
                    &nbsp;<asp:Button ID="CancelChangeSslButton" runat="server" Text="Cancel" />
                </div>
            </asp:Panel>
            <ajaxToolkit:ModalPopupExtender ID="ChangeSslPopup" runat="server" 
                TargetControlID="DummyTarget"
                PopupControlID="ChangeSslDialog" 
                BackgroundCssClass="modalBackground"                         
                CancelControlID="CancelChangeSslButton" 
                DropShadow="false"
                PopupDragHandleControlID="ChangeSslDialogHeader" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>