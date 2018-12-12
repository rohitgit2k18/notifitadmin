<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.PaymentManager" Title="Payment Manager" CodeFile="PaymentManager.aspx.cs" %>
<%@ Register Src="../UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="../UserControls/AccountDataViewport.ascx" TagName="AccountDataViewport" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<script type="text/javascript">
    function toggleCheckBoxState(id, checkState)
    {
        var cb = document.getElementById(id);
        if (cb != null)
            cb.checked = checkState;
    }

    function toggleSelected(checkState)
    {
        // Toggles through all of the checkboxes defined in the CheckBoxIDs array
        // and updates their value to the checkState input parameter
        if (CheckBoxIDs != null)
        {
            for (var i = 0; i < CheckBoxIDs.length; i++)
                toggleCheckBoxState(CheckBoxIDs[i], checkState.checked);
        }
        UpdatePaymentDisplay();
    }
    
    function PaymentsSelected()
    {
        var count = 0;
        for(i = 0; i< document.forms[0].elements.length; i++){
            var e = document.forms[0].elements[i];
            var name = e.name;
            if ((e.type == 'checkbox') && (name.endsWith('SelectPaymentCheckBox')) && (e.checked))
            {
                count ++;
            }
        }
        return (count > 0);
    }
    
    function GetPaymentTotal()
    {
        var total = 0;
        for(i = 0; i< document.forms[0].elements.length; i++){
            var e = document.forms[0].elements[i];
            var name = e.name;
            if ((e.type == 'checkbox') && (name.endsWith('SelectPaymentCheckBox')) && (e.checked))
            {
                var amountFieldName = name.replace('SelectPaymentCheckBox', 'HiddenAmount');
                var amountFieldId = replaceAll(amountFieldName, '$', '_');
                total += parseFloat(document.getElementById(amountFieldId).value);
            }
        }
        
        return total;
    }
    
    function replaceAll(text, strA, strB)
    {
        while ( text.indexOf(strA) != -1)
        {
            text = text.replace(strA,strB);
        }
        return text;
    }
    
    function UpdatePaymentDisplay()
    {
        // check if the batch panel is visible
        if (!document.getElementById('<%=BatchPanel.ClientID %>')) return;
        var total = GetPaymentTotal();
        if (total > 0) {
            document.getElementById('<%=NoPaymentMessage.ClientID %>').style.display = "none";
            document.getElementById('<%=PaymentMessage.ClientID %>').style.display = "block";
            document.getElementById('<%=CaptureAllButton.ClientID %>').style.display = "block";
            document.getElementById('<%=PaymentTotal.ClientID %>').style.display = "block";
            document.getElementById('<%=PaymentTotal.ClientID %>').innerHTML = "<strong><%=AbleContext.Current.Store.BaseCurrency.CurrencySymbol %> " + total.toString() + "</strong>";
        }
        else {
            document.getElementById('<%=NoPaymentMessage.ClientID %>').style.display = "block";
            document.getElementById('<%=PaymentMessage.ClientID %>').style.display = "none";
            document.getElementById('<%=CaptureAllButton.ClientID %>').style.display = "none";
            document.getElementById('<%=PaymentTotal.ClientID %>').style.display = "none";
            document.getElementById('<%=PaymentTotal.ClientID %>').innerHTML = "";
        }
    }
</script>
<div class="pageHeader">
    <div class="caption">
        <h1><asp:Localize ID="Caption" runat="server" Text="Payment Manager"></asp:Localize></h1>
        <div class="links">
            <cb:NavigationLink ID="OrderManagerLink" runat="server" Text="Order Manager" SkinID="Button" NavigateUrl="Default.aspx"></cb:NavigationLink>
            <cb:NavigationLink ID="PayManagerLink" runat="server" Text="Payments" SkinID="ActiveButton" NavigateUrl="#"></cb:NavigationLink>
            <cb:NavigationLink ID="NotesLink" runat="server" Text="Order Notes" SkinID="Button" NavigateUrl="OrderNotesManager.aspx"></cb:NavigationLink>
        </div>
    </div>
</div>
<asp:UpdatePanel ID="SearchFormAjax" runat="server">
    <ContentTemplate>
        <div class="searchPanel">
            <table cellspacing="0" class="inputForm">
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="DateFilterLabel" runat="server" Text="Date Range:" ToolTip="Filter payments that were placed within the start and end dates." />
                    </th>
                    <td colspan="3" nowrap>
                        <uc1:PickerAndCalendar ID="StartDate" runat="server" />
                        to <uc1:PickerAndCalendar ID="EndDate" runat="server" />
                        &nbsp;&nbsp;
                        <asp:DropDownList ID="DateQuickPick" runat="server" onchange="alert(this.selectedIndex);">
                            <asp:ListItem Value="-- Date Quick Pick --"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th style="width:200px">
                        <cb:ToolTipLabel ID="PaymentStatusFilterLabel" runat="server" Text="Payment Status:" AssociatedControlID="PaymentStatusFilter" ToolTip="Filter payments by status." />
                    </th>
                    <td style="width:200px">
                        <asp:DropDownList ID="PaymentStatusFilter" runat="server" AppendDataBoundItems="true">
                            <asp:ListItem Text="All" Value="-1"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <th rowspan="3" valign="top" style="width:200px">
                        <cb:ToolTipLabel ID="PaymentMethodLabel" runat="server" Text="Payment Method:" AssociatedControlID="PaymentMethodFilter" ToolTip="Filter payments by payment method." />
                    </th>
                    <td rowspan="3" valign="top">
                        <asp:ListBox ID="PaymentMethodFilter" runat="server" SelectionMode="Multiple" Height="90" AppendDataBoundItems="true" DataTextField="Name" DataValueField="Id" DataSourceID="PaymentMethodDs"/>
                    </td>
                </tr>
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="TransactionIdFilterLabel" runat="server" Text="Transaction ID:" AssociatedControlID="TransactionIdFilter"
                            ToolTip="Enter all or part of a transaction id or authorization code to search for." />
                    </th>
                    <td>
                        <asp:TextBox ID="TransactionIdFilter" runat="server" Text="" Width="200px" AutoComplete="off"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="OrderNumberFilterLabel" runat="server" Text="Order Number(s):" AssociatedControlID="OrderNumberFilter"
                            ToolTip="You can enter order number(s) to filter the list.  Separate multiple orders with a comma.  You can also enter ranges like 4-10 for all orders numbered 4 through 10." />
                    </th>
                    <td>
                        <asp:TextBox ID="OrderNumberFilter" runat="server" Text="" Width="200px" AutoComplete="off"></asp:TextBox>
                        <cb:IdRangeValidator ID="OrderNumberFilterValidator" runat="server" Required="false"
                            ControlToValidate="OrderNumberFilter" Text="*" ValidationGroup="PaymentManager"
                            ErrorMessage="The range is invalid.  Enter a specific order number or a range of numbers like 4-10.  You can also include mulitple values separated by a comma."></cb:IdRangeValidator>                
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td colspan="3">
                        <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="SearchButton_Click" CausesValidation="false"/>
                        <asp:HyperLink ID="ResetSearchButton" runat="server" Text="Reset" SkinID="CancelButton" NavigateUrl="PaymentManager.aspx"></asp:HyperLink>
                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="BatchPanel" runat="server" class="content">
            <table cellspacing="0" class="inputForm">
                <tr>
                    <th>
                        <asp:Label ID="PaymentBatchCaption" runat="server" EnableViewState="false" Text="Batch Processing:"></asp:Label>
                    </th>
                    <td>
                        <asp:Label ID="NoPaymentMessage" runat="server" Text="No payments are selected." EnableViewState="false" style="display:block;"></asp:Label>
                        <asp:Label ID="PaymentMessage" runat="server" Text="Total Amount of payment(s) to process for your selection(s):" EnableViewState="false" style="display:none;"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="PaymentTotal" runat="server" Text="" style="display:none;"></asp:Label>
                    </td>
                    <td>
                        <asp:Button ID="CaptureAllButton" runat="server" Text="Capture All" OnClick="CaptureAllButton_Click"
                            ValidationGroup="BatchCapture" OnClientClick="if(!PaymentsSelected()){alert('No pament(s) selected. Please select at least one payment.'); return false;}" style="display:none;" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:UpdatePanel ID="SearchResultAjax" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <div class="content">
            <cb:AbleGridView ID="PaymentGrid" runat="server" SkinID="PagedList" Width="100%" AllowPaging="True" PageSize="20" 
                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="PaymentsDs"
                OnRowCommand="PaymentGrid_RowCommand" OnDataBound="PaymentGrid_DataBound" DefaultSortExpression="O.Id" DefaultSortDirection="Descending" 
                ShowWhenEmpty="False" >
                <Columns>
                    <asp:TemplateField HeaderText="Select">
                        <HeaderTemplate>
                            <input type="checkbox" onclick="toggleSelected(this)" />
                        </HeaderTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="40px" />
                        <HeaderStyle Width="40px" />
                        <ItemTemplate>
                            <asp:CheckBox ID="SelectPaymentCheckBox" runat="server" Visible='<%# ((PaymentStatus)Eval("PaymentStatus")) == PaymentStatus.Authorized %>' Value='<%# Eval("Amount") %>' onClick="UpdatePaymentDisplay();" />
                            <asp:Literal ID="DummyText" runat="server" Text="X" Visible='<%# ((PaymentStatus)Eval("PaymentStatus")) != PaymentStatus.Authorized %>' ></asp:Literal>
                            <asp:HiddenField ID="HiddenAmount" runat="server" Value='<%# Eval("Amount") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Order #" SortExpression="O.OrderNumber">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("Order.OrderNumber") %>' SkinID="Link" NavigateUrl='<%#String.Format("ViewOrder.aspx?OrderNumber={0}", Eval("Order.OrderNumber"))%>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Customer">
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <%#Eval("Order.BillToFirstName")%> <%#Eval("Order.BillToLastName")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date" SortExpression="P.PaymentDate">
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:Label ID="PaymentDate" runat="server" Text='<%# Eval("PaymentDate", "{0:G}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Order Balance">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                           <%# GetOrderBalance(Container.DataItem)%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Payment Amount" SortExpression="Amount">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                           <%# ((decimal)Eval("Amount")).LSCurrencyFormat("lc") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Payment Status" SortExpression="P.PaymentStatusId">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:PlaceHolder ID="phPaymentStatus" runat="server"></asp:PlaceHolder>
                            <asp:Label ID="PaymentStatus" runat="server" Text='<%# ((PaymentStatus)Eval("PaymentStatus")).ToString() %>'></asp:Label>
                            <br />
                            <%#string.Format("{0} {1}", Eval("PaymentMethodName"), Eval("ReferenceNumber"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Last Transaction">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <p class="small"><%#GetTransactionData(Container.DataItem)%></p>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-HorizontalAlign="Right">
                    <ItemStyle Width="60px" />
                        <ItemTemplate>
                            <asp:ImageButton ID="CaptureButton" runat="server" SkinId="UpdateRate" CommandName="Capture" CommandArgument='<%#Eval("PaymentId")%>' Visible='<%# ((PaymentStatus)Eval("PaymentStatus")) == PaymentStatus.Authorized %>' AlternateText="Capture" ToolTip="Capture" />
                            <asp:HyperLink ID="ViewOrder" runat="server" NavigateUrl='<%# string.Format("Payments/Default.aspx?OrderNumber={0}", Eval("Order.OrderNumber")) %>'><asp:Image ID="PreviewIcon" runat="server" SkinID="PreviewIcon" AlternateText="View Order" ToolTip="View Order" /></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    </Columns>
                <EmptyDataTemplate>
                    <asp:Label ID="EmptyMessage" runat="server" Text="No payments match criteria."></asp:Label>
                </EmptyDataTemplate>
            </cb:AbleGridView>
        </div>
        <asp:HiddenField ID="DummyTarget" runat="server" />
        <asp:Panel ID="CaptureDialog" runat="server" Style="display:none;width:550px" CssClass="modalPopup">
            <asp:Panel ID="CaptureDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                <asp:Localize ID="CaptureDialogCaption" runat="server" Text="Capture Funds for Payment #{0}: {1}"></asp:Localize>
            </asp:Panel>
            <div style="padding-top:5px;">
                <table class="inputForm" cellpadding="4" cellspacing="0">
                    <tr>
                        <th>
                            <asp:Label ID="PaymentDateLabel" runat="server" Text="Date:"></asp:Label>
                        </th>
                        <td>
                            <asp:Label ID="PaymentDate" runat="server" Text=""></asp:Label>
                        </td>
                        <th>
                            <asp:Label ID="AmountLabel" runat="server" Text="Amount:"></asp:Label>
                        </th>
                        <td>
                            <asp:Label ID="Amount" runat="server" Text=""></asp:Label>
                        </td>
                        <th>
                            <asp:Label ID="PaymentStatusLabel" runat="server" Text="Status:"></asp:Label>
                        </th>
                        <td>
                            <asp:Label ID="CurrentPaymentStatus" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th valign="top">
                            <asp:Label ID="AccountDataLabel" runat="server" Text="Method:"></asp:Label>
                        </th>
                        <td colspan="5">
                            <asp:Label ID="PaymentMethod" runat="server"></asp:Label><br />
                            <asp:Label ID="AccountReference" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th valign="top">
                            <asp:Label ID="AccountDetailsLabel" runat="server" Text="Account Details:" AssociatedControlID="AccountDataViewport" EnableViewState="false"></asp:Label>
                        </th>
                        <td colspan="5">
                            <uc:AccountDataViewport ID="AccountDataViewport" runat="server"></uc:AccountDataViewport>
                        </td>
                    </tr>
                    <tr>
                        <th class="sectionHeader" colspan="6" style="text-align:left">
                            <h2><asp:Localize ID="CaptureCaption" runat="server" Text="Capture Options"></asp:Localize></h2>
                        </th>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <table cellpadding="0" cellspacing="5">
                                <tr>
                                    <td>
                                        <asp:Label ID="OriginalAuthorizationLabel" runat="server" Text="Original Authorization:" SkinID="FieldHeader"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="OriginalAuthorization" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr runat="server" id="trRemainingAuthorization">
                                    <td>
                                        <asp:Label ID="RemainingAuthorizationLabel" runat="server" Text="Remaining Authorization:" SkinID="FieldHeader"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="RemainingAuthorization" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="OrderBalanceLabel" runat="server" Text="Order Balance:" SkinID="FieldHeader"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="OrderBalance" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="CaptureAmountLabel" runat="server" Text="Capture Amount:" SkinID="FieldHeader"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="CaptureAmount" runat="server" Columns="6"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr id="trAdditionalCapture" runat="server">
                                    <td>
                                        <asp:Label ID="AdditionalCaptureLabel" runat="server" Text="Additional Capture Possible:" SkinID="FieldHeader"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:RadioButton ID="AdditionalCapture" runat="server" GroupName="AdditionalCapture" Text="Yes" />(option to capture additional funds on this authorization if needed)<br />
                                        <asp:RadioButton ID="NoAdditionalCapture" runat="server" GroupName="AdditionalCapture" Text="No" Checked="true" /> (no additional capture needed; close authorization after this capture)<br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="CustomerNoteLabel" runat="server" Text="Note to Customer:" SkinID="FieldHeader"></asp:Label><br />
                                        (Optional)
                                    </td>
                                    <td>
                                        <asp:TextBox ID="CustomerNote" runat="server" TextMode="MultiLine" Rows="6" Columns="50"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="center">
                                        <asp:HiddenField ID="HiddenPaymentId" runat="server" />
                                        <asp:Button ID="SubmitCaptureButton" runat="server" Text="Capture" OnClick="SubmitCaptureButton_Click"></asp:Button>
                                        <asp:Button ID="CancelCaptureButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false"></asp:Button>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <ajaxToolkit:ModalPopupExtender ID="CapturePopup" runat="server" 
            TargetControlID="DummyTarget"
            PopupControlID="CaptureDialog" 
            BackgroundCssClass="modalBackground"                         
            CancelControlID="CancelCaptureButton" 
            DropShadow="false"
            PopupDragHandleControlID="CaptureDialogHeader" />
    </ContentTemplate>
</asp:UpdatePanel>            
<asp:ObjectDataSource ID="PaymentsDs" runat="server" OldValuesParameterFormatString="original_{0}"
    SelectMethod="Load" SelectCountMethod="Count" SortParameterName="sortExpression" TypeName="CommerceBuilder.Search.PaymentFilterDataSource"
    OnSelecting="PaymentsDs_Selecting" EnablePaging="true">
    <SelectParameters>
        <asp:Parameter Name="filter" Type="Object" />
    </SelectParameters>
</asp:ObjectDataSource>
<asp:ObjectDataSource ID="PaymentMethodDs" runat="server" OldValuesParameterFormatString="original_{0}"
    SelectMethod="LoadAll" SelectCountMethod="CountAll" SortParameterName="sortExpression" TypeName="CommerceBuilder.Payments.PaymentMethodDataSource">
</asp:ObjectDataSource>
</asp:Content>