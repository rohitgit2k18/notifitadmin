<%@ Page Language="C#" MasterPageFile="../Order.master" Inherits="AbleCommerce.Admin.Orders.Payments._Default" Title="View Payments" CodeFile="Default.aspx.cs" %>
<%@ Register Src="../../UserControls/AccountDataViewport.ascx" TagName="AccountDataViewport" TagPrefix="uc" %>
<%@ Register assembly="wwhoverpanel" Namespace="Westwind.Web.Controls" TagPrefix="wwh" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Payments - Order #{0}" EnableViewState="false"></asp:Localize></h1>
            <div class="links">
            <asp:HyperLink ID="AddPaymentLink" runat="server" Text="Add New Payment" NavigateUrl="AddPayment.aspx" SkinID="AddButton"></asp:HyperLink>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:Repeater ID="PaymentRepeater" runat="server" OnItemDataBound="PaymentRepeater_ItemDataBound" 
        OnItemCommand="PaymentRepeater_ItemCommand">
        <ItemTemplate>
            <div class="section">
                <div class="header">
                    <h2>
                        <asp:Localize ID="PaymentNumber" runat="server" Text='<%#string.Format("Payment #{0}: ", (Container.ItemIndex + 1))%>'></asp:Localize>
                        <asp:Localize ID="PaymentReference" runat="server" Text='<%#string.Format("{0} {1}", Eval("PaymentMethodName"), Eval("ReferenceNumber"))%>'></asp:Localize>
                    </h2>
                </div>
                <div class="content">
                    <table class="summary" border="0">
                        <tr>
                            <th>
                                <asp:Label ID="AmountLabel" runat="server" Text="Amount:"></asp:Label>
                            </th>
                            <td>
                                <asp:Label ID="Amount" runat="server" Text='<%#((decimal)Eval("Amount")).LSCurrencyFormat("lc") %>'></asp:Label> <asp:Label ID="Currency" runat="server" Text='<%# Eval("CurrencyCode") %>'></asp:Label>
                            </td>
                            <th>
                                <asp:Label ID="PaymentDateLabel" runat="server" Text="Date:"></asp:Label>
                            </th>
                            <td colspan="3">
                                <asp:Label ID="PaymentDate" runat="server" Text='<%# Eval("PaymentDate", "{0:g}") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <asp:Label ID="PaymentStatusLabel" runat="server" Text="Status:"></asp:Label>
                            </th>
                            <td>
                                <asp:Label ID="CurrentPaymentStatus" runat="server" Text='<%#StringHelper.SpaceName(Eval("PaymentStatus").ToString()).ToUpperInvariant()%>' CssClass='<%#AbleCommerce.Code.CssHelper.GetPaymentStatusCssClass(Container.DataItem)%>'></asp:Label>
                            </td>
                            <th>
                                <asp:Label ID="PaymentStatusReasonLabel" runat="server" Text="Status Note:" EnableViewState="false"></asp:Label>
                            </th>
                            <td colspan="3">
                                <asp:Label ID="PaymentStatusReason" runat="server" Text='<%# Eval("PaymentStatusReason") %>' EnableViewState="false"></asp:Label>
                            </td>                        
                        </tr>
                        <tr>
                            <th valign="top">
                                <asp:Label ID="AccountDetailsLabel" runat="server" Text="Account Details:" AssociatedControlID="AccountDataViewport" EnableViewState="false"></asp:Label>
                            </th>
                            <td colspan="5">
                                <uc:AccountDataViewport ID="AccountDataViewport" runat="server" PaymentId='<%# Eval("PaymentId") %>' UnavailableText="n/a"></uc:AccountDataViewport>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td colspan="3">
                                <asp:Panel ID="RetryPanel" runat="server" visible="false">
                                    <asp:Label ID="RetryHelpText" runat="server" Text="Provide the card security code if available:"></asp:Label><br />
                                    <asp:Label ID="RetrySecurityCodeLabel" runat="server" Text="Security Code:" SkinID="fieldheader"></asp:Label>
                                    <asp:TextBox ID="RetrySecurityCode" runat="server" Columns="4"></asp:TextBox><br /><br />
                                    <asp:Button ID="SubmitRetryButton" runat="server" CommandName="Do_SubmitRetry" CommandArgument='<%#Eval("PaymentId")%>' Text="Retry"></asp:Button>
                                    <asp:Button ID="CancelRetryButton" runat="server" CommandName="Do_CancelRetry" CommandArgument='<%#Eval("PaymentId")%>' Text="Cancel"></asp:Button>
                                </asp:Panel>
                                <asp:PlaceHolder ID="phPaymentAction" runat="server">
                                    <asp:Button ID="EditPaymentButton" runat="server" Text="Edit"></asp:Button>                                    
                                    <asp:Button ID="DeletePaymentButton" runat="server" Text="Delete"></asp:Button>
                                </asp:PlaceHolder>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="header">
                    <h2><asp:Label ID="TransactionHistoryCaption" runat="server" Text="Transaction History"></asp:Label></h2>
                </div>
                <div class="content">
                    <asp:GridView ID="TransactionGrid" runat="server" DataSource='<%#Eval("Transactions")%>' 
                        AutoGenerateColumns="false" Width="100%" SkinID="PagedList">
                        <Columns>
                            <asp:TemplateField HeaderText="Date">
                                <ItemStyle VerticalAlign="Top" Wrap="false" />
                                <ItemTemplate>
                                    <%# Eval("TransactionDate", "{0:g}") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Gateway">
                                <ItemStyle VerticalAlign="Top" />
                                <ItemTemplate>
                                    <%#Eval("PaymentGateway.Name")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Type">
                                <ItemStyle VerticalAlign="Top" />
                                <ItemTemplate>
                                    <%#StringHelper.SpaceName(Eval("TransactionType").ToString())%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Amount">
                                <ItemStyle VerticalAlign="Top" />
                                <ItemTemplate>
                                    <%#((decimal)Eval("Amount")).LSCurrencyFormat("lc")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Result">
                                <ItemStyle VerticalAlign="Top" />
                                <ItemTemplate>
                                    <asp:Label ID="SuccessLabel" runat="server" Text="SUCCESS" SkinID="GoodCondition" Visible='<%#(isSuccessfulTransaction(Eval("TransactionStatus")))%>' EnableViewState="false"></asp:Label>
                                    <asp:Label ID="FailedLabel" runat="server" Text="FAILED" SkinID="ErrorCondition" Visible='<%#(isFailedTransaction(Eval("TransactionStatus")))%>' EnableViewState="false"></asp:Label>
									<asp:Label ID="PendingLabel" runat="server" Text="PENDING" SkinID="GoodCondition" Visible='<%#(isPendingTransaction(Eval("TransactionStatus")))%>' EnableViewState="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Notes">
                                <ItemTemplate>
                                    <asp:PlaceHolder ID="ResponseMessagePanel" runat="server" Visible='<%#!String.IsNullOrEmpty((string)Eval("ResponseMessage"))%>' EnableViewState="false">
                                        <%#Eval("ResponseMessage")%>
                                        <asp:Literal ID="ResponseCode" runat="server" Text='<%#Eval("ResponseCode", "&nbsp;({0})")%>' Visible='<%#!String.IsNullOrEmpty((string)Eval("ResponseCode"))%>' EnableViewState="false"></asp:Literal>
                                        <br />
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder ID="ProviderTransactionIdPanel" runat="server" Visible='<%#!String.IsNullOrEmpty((string)Eval("ProviderTransactionId"))%>' EnableViewState="false">
                                        <asp:Label ID="ProviderTransactionIdLabel" runat="server" Text="Transaction ID:" SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                                        <%#Eval("ProviderTransactionId")%><br />
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder ID="AuthorizationCodePanel" runat="server" Visible='<%#!String.IsNullOrEmpty((string)Eval("AuthorizationCode"))%>' EnableViewState="false">
                                        <asp:Label ID="AuthorizationCodeLabel" runat="server" Text="Authorization:" SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                                        <%#Eval("AuthorizationCode")%><br />
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder ID="AvsCvsResultPanel" runat="server" Visible='<%# ShowTransactionElement("AVSCVV", Container.DataItem) %>' EnableViewState="false">
                                        <asp:Label ID="AvsCodeLabel" runat="server" Text="AVS:" SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                                        <%# GetAvs(Container.DataItem) %>
                                        &nbsp;<a name="AvsCodes" href="AVSCodes.htm" target="_blank" onmouseover='AVSCodesHoverLookupPanel.startCallback(event, "avs", null, null);' onmouseout='AVSCodesHoverLookupPanel.hide();'>Common AVS Codes</a>
                                        <br />
                                        <asp:Label ID="CvvCodeLabel" runat="server" Text="CVV:" SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                                        <%# GetCvv(Container.DataItem) %>
                                        &nbsp;<a name="CvvCodes" href="CVVCodes.htm" target="_blank" onmouseover='CVVCodesHoverLookupPanel.startCallback(event, "cvv", null, null);' onmouseout='CVVCodesHoverLookupPanel.hide();'>Common CVV Codes</a>
                                        <br />
                                    </asp:PlaceHolder>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="EmptyMessage" runat="server" Text="No transactions are associated with this payment."></asp:Label>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
    <wwh:wwHoverPanel ID="CVVCodesHoverLookupPanel"
        runat="server" 
        serverurl="~/Admin/Orders/Payments/CVVCodes.htm"
        Navigatedelay="1000"              
        scriptlocation="WebResource"
        style="display: none; background: white;" 
        panelopacity="0.89" 
        shadowoffset="8"
        shadowopacity="0.18"
        PostBackMode="None"
        AdjustWindowPosition="true">
    </wwh:wwHoverPanel>
    <wwh:wwHoverPanel ID="AVSCodesHoverLookupPanel"
        runat="server" 
        serverurl="~/Admin/Orders/Payments/AVSCodes.htm"
        Navigatedelay="1000"              
        scriptlocation="WebResource"
        style="display: none; background: white;" 
        panelopacity="0.89" 
        shadowoffset="8"
        shadowopacity="0.18"
        PostBackMode="None"
        AdjustWindowPosition="true">
    </wwh:wwHoverPanel>
</asp:Content>