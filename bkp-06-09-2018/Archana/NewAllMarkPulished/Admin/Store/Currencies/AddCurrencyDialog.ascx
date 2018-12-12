<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin._Store.Currencies.AddCurrencyDialog" EnableViewState="true" CodeFile="AddCurrencyDialog.ascx.cs" %>
<%@ Register assembly="wwhoverpanel" Namespace="Westwind.Web.Controls" TagPrefix="wwh" %>
<asp:UpdatePanel ID="AddCurrencyAjax" runat="server" UpdateMode="Conditional" >
    <ContentTemplate>
        <asp:Button ID="AddLink" runat="server" Text="Add Currency" EnableViewState="false" />
        <asp:Panel ID="AddDialog" runat="server" Style="display:none;width:450px" CssClass="modalPopup">
            <asp:Panel ID="AddDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                <div class="addcurrency"><asp:Localize ID="AddCaption" runat="server" Text="Add Currency" /></div>
            </asp:Panel>
            <div style="padding-top:5px;">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="AddCurrency" />
                <table cellspacing="0" class="inputForm" width="100%">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" AssociatedControlID="Name" ToolTip="Name of the currency."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="Name" runat="server" MaxLength="50" Width="180px"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="NameValidator" runat="server" ControlToValidate="Name"
                                Display="Static" ErrorMessage="Name is required." ValidationGroup="AddCurrency" Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ISOCodeLabel" runat="server" Text="ISO Code:" AssociatedControlID="ISOCode" ToolTip="3 letter ISO 4127 code for this currency, such as USD, CAD, etc." />
                        </th>
                        <td>
                            <asp:TextBox ID="ISOCode" runat="server" MaxLength="3" Width="60px" ></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="ISOCodeValidator" runat="server" ControlToValidate="ISOCode"
                                Display="Static" ErrorMessage="ISO code is required." ValidationGroup="AddCurrency" Text="*"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="ISOCodeValidator2" runat="server" ControlToValidate="ISOCode"
                                Display="Static" ErrorMessage="ISO code must be three letters." ValidationGroup="AddCurrency" Text="*"
                                ValidationExpression="^[A-Z]{3}$">
						        </asp:RegularExpressionValidator>
						        <a name="ISOCodes" href="#ISOCodes" onmouseover="IsoCodePanel.startCallback(event, null)" onmouseout="IsoCodePanel.hide();">Common ISO Codes</a>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="CurrencySymbolLabel" runat="server" Text="Symbol:" AssociatedControlID="CurrencySymbol" ToolTip=""></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="CurrencySymbol" runat="server" MaxLength="40" Width="40px" Text="$"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="CurrencySymbolValidator" runat="server" ControlToValidate="CurrencySymbol"
                                Display="Static" ErrorMessage="Currency symbol is required." ValidationGroup="AddCurrency" Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <asp:RadioButton ID="AutoUpdate" runat="server" Checked="true" GroupName="radExchange" />
                        </td>
                        <td>
                            <cb:ToolTipLabel ID="AutoUpdateLabel" runat="server" Text="Automatic Exchange Rate" AssociatedControlID="AutoUpdate" ToolTip="When automatic rates are enabled, updates will be attempted once per day using the configured rate provider.  You must make sure to provide the correct ISO code for automatic rates to be effective.  Supported currencies vary for the exchange rate providers." SkinID="FieldHeader"></cb:ToolTipLabel>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" valign="top">
                            <asp:RadioButton ID="ManualUpdate" runat="server" GroupName="radExchange" />
                        </td>
                        <td valign="top">
                            <cb:ToolTipLabel ID="ManualUpdateLabel" runat="server" Text="Manual Exchange Rate:" AssociatedControlID="ManualUpdate" ToolTip="When manual rates are enabled, you control the exchange rate and it only changes when you update it." SkinID="FieldHeader"></cb:ToolTipLabel>
                            <div style="padding-top:10px">
                                <asp:Localize ID="ExchangeRateHelpText" runat="server" Text="1 {0} = " EnableViewState="false"></asp:Localize>
                                <asp:TextBox ID="ExchangeRate" runat="server" MaxLength="10" Width="60px" Text="1"></asp:TextBox>
                                <asp:Localize ID="ExchangeRateHelpText2" runat="server" Text=" of this currency"></asp:Localize>
                            </div>
                        </td>
                    </tr>                    
                    <tr>
                        <td colspan="2" class="sectionHeader">
                            <asp:ImageButton ID="ShowDisplayOptions" runat="server" SkinID="PlusIcon" OnClick="ShowDisplayOptions_Click" />
                            <asp:ImageButton ID="HideDisplayOptions" runat="server" SkinID="MinusIcon" Visible="false" OnClick="HideDisplayOptions_Click" />
                            <asp:Localize ID="DisplayOptionsCaption" runat="server" Text="Advanced Display Options"></asp:Localize>
                        </td>
                    </tr>
                    <tr id="trDisplayOptions1a" runat="server" visible="false">
                        <th>
                            <cb:ToolTipLabel ID="PositivePatternLabel" runat="server" Text="Display Format:" AssociatedControlID="PositivePattern" ToolTip="Determines the format of positive amounts; $ represents the currency symbol; n represents the amount."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="PositivePattern" runat="server">
                                <asp:ListItem Value="0" Text="$n"></asp:ListItem>    
                                <asp:ListItem Value="1" Text="n$"></asp:ListItem>    
                                <asp:ListItem Value="2" Text="$ n"></asp:ListItem>    
                                <asp:ListItem Value="3" Text="n $"></asp:ListItem>    
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="trDisplayOptions1b" runat="server" visible="false">
                        <th>
                            <cb:ToolTipLabel ID="NegativePatternLabel" runat="server" Text="Negative Format:" AssociatedControlID="NegativePattern" ToolTip="Determines the format of negative amounts; $ represents the currency symbol; - represents the negative sign; n represents the amount."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="NegativePattern" runat="server">
                                <asp:ListItem Value="0" Text="($n)"></asp:ListItem>
                                <asp:ListItem Value="1" Text="-$n" Selected="true"></asp:ListItem>    
                                <asp:ListItem Value="2" Text="$-n"></asp:ListItem>    
                                <asp:ListItem Value="3" Text="$n-"></asp:ListItem>    
                                <asp:ListItem Value="4" Text="(n$)"></asp:ListItem>    
                                <asp:ListItem Value="5" Text="-n$"></asp:ListItem>    
                                <asp:ListItem Value="6" Text="n-$"></asp:ListItem>    
                                <asp:ListItem Value="7" Text="n$-"></asp:ListItem>    
                                <asp:ListItem Value="8" Text="-n $"></asp:ListItem>    
                                <asp:ListItem Value="9" Text="-$ n"></asp:ListItem>    
                                <asp:ListItem Value="10" Text="n $-"></asp:ListItem>    
                                <asp:ListItem Value="11" Text="$ n-"></asp:ListItem>    
                                <asp:ListItem Value="12" Text="$ -n"></asp:ListItem>    
                                <asp:ListItem Value="13" Text="n- $"></asp:ListItem>    
                                <asp:ListItem Value="14" Text="($ n)"></asp:ListItem>    
                                <asp:ListItem Value="15" Text="(n $)"></asp:ListItem>    
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="trDisplayOptions2" runat="server" visible="false">
                        <th>
                            <cb:ToolTipLabel ID="ISOCodePatternLabel" runat="server" Text="Show ISO Code:" AssociatedControlID="ISOCodePattern" ToolTip="Indicate whether the ISO code should be included as part of the formatted currency." />
                        </th>
                        <td>
                            <asp:DropDownList ID="ISOCodePattern" runat="server">
                                <asp:ListItem Value="0" Text="do not show"></asp:ListItem>    
                                <asp:ListItem Value="1" Text="show after formatted currency"></asp:ListItem>    
                                <asp:ListItem Value="2" Text="show before formatted currency"></asp:ListItem>    
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="trDisplayOptions3a" runat="server" visible="false">
                        <th>
                            <cb:ToolTipLabel ID="NegativeSignLabel" runat="server" Text="Negative Sign:" AssociatedControlID="NegativeSign" ToolTip="The symbol used to represent a negative amount."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="NegativeSign" runat="server" MaxLength="4" Width="40px" Text="-"></asp:TextBox>
                        </td>
                    </tr>
                    <tr id="trDisplayOptions3b" runat="server" visible="false">
                        <th>
                            <cb:ToolTipLabel ID="DecimalSeparatorLabel" runat="server" Text="Decimal Separator:" AssociatedControlID="DecimalSeparator" ToolTip="The string that separates the whole and fractional part of an amount."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="DecimalSeparator" runat="server" MaxLength="4" Width="40px" Text="."></asp:TextBox>
                        </td>
                    </tr>
                    <tr id="trDisplayOptions4a" runat="server" visible="false">
                        <th>
                            <cb:ToolTipLabel ID="DecimalDigitsLabel" runat="server" Text="Decimal Digits:" AssociatedControlID="DecimalDigits" ToolTip="The number of digits shown to the right of the decimal place."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="DecimalDigits" runat="server" MaxLength="1" Width="40px" Text="2"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="DecimalDigitsValidator" runat="server" ControlToValidate="DecimalDigits"
                                Display="Static" ErrorMessage="Deicmal digits is required." ValidationGroup="AddCurrency" Text="*"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="DecimalDigitsValidator2" runat="server" ControlToValidate="DecimalDigits"
                                Display="Static" ErrorMessage="Decimal digits must be a number between 0 and 9." ValidationGroup="AddCurrency" Text="*"
                                MinimumValue="0" MaximumValue="9" Type="Integer"></asp:RangeValidator>
                        </td>
                    </tr>
                    <tr id="trDisplayOptions4b" runat="server" visible="false">
                        <th>
                            <cb:ToolTipLabel ID="GroupSeparatorLabel" runat="server" Text="Group Separator:" AssociatedControlID="GroupSeparator" ToolTip="The string that separates groups of integers to the left of the decimal separator."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="GroupSeparator" runat="server" MaxLength="4" Width="40px" Text=","></asp:TextBox>
                        </td>
                    </tr>
                    <tr id="trDisplayOptions5" runat="server" visible="false">
                        <th>
                            <cb:ToolTipLabel ID="GroupSizesLabel" runat="server" Text="Group Size:" AssociatedControlID="GroupSizes" ToolTip="An integer that indicates the number of digits in a group to the left of the decimal; use 0 to indicate no grouping."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="GroupSizes" runat="server" MaxLength="8" Width="40px" Text="3"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="GroupSizesValidator" runat="server" ControlToValidate="GroupSizes"
                                Display="Static" ErrorMessage="Group size is required." ValidationGroup="AddCurrency" Text="*"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="GroupSizesValidator2" runat="server" ControlToValidate="GroupSizes"
                                Display="Static" ErrorMessage="Group size can only be a comma delimited list of integers in the format of #(,#)" ValidationGroup="AddCurrency" Text="*"
                                 ValidationExpression="^\d(,\d)?(,\d)?(,\d)?$"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr >
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" ValidationGroup="AddCurrency" />
                            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton"  CausesValidation="false"/>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
       <wwh:wwHoverPanel ID="IsoCodePanel"
            runat="server" 
            serverurl="~/Admin/Store/Currencies/ISOCodes.htm"
            Navigatedelay="250"     
            scriptlocation="WebResource"
            style="display: none; background: white;z-index:200000 !important;" 
            panelopacity="0.89" 
            shadowoffset="8"
            shadowopacity="0.18"
            PostBackMode="None"
            AdjustWindowPosition="true"
			HoverOffsetBottom="-5"
			HoverOffsetRight="-5">
        </wwh:wwHoverPanel>
        <ajaxToolkit:ModalPopupExtender ID="AddPopup" runat="server" 
                TargetControlID="AddLink"
                PopupControlID="AddDialog" 
                BackgroundCssClass="modalBackground"
                CancelControlID="CancelButton"
                DropShadow="false"                
                PopupDragHandleControlID="AddDialogHeader" />
   </ContentTemplate>
</asp:UpdatePanel>
