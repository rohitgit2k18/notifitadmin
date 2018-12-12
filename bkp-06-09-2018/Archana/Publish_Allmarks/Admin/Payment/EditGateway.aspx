<%@ Page Language="C#" MasterPageFile="../Admin.master" Inherits="AbleCommerce.Admin._Payment.EditGateway" Title="Edit Gateway"  CodeFile="EditGateway.aspx.cs" %>
<asp:Content ID="Content" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Edit {0}" EnableViewState="false"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
    <cb:Notification ID="SavedMessage" runat="server" Text="Gateway saved at {0:t}" SkinID="GoodCondition" Visible="false"></cb:Notification>
        <asp:PlaceHolder ID="phInputForm" runat="server"></asp:PlaceHolder>
        <table class="inputForm">
            <tr id="trPaymentMethods" runat="server">
                <th valign="top" style="width:150px">
                    <cb:ToolTipLabel ID="PaymentMethodListLabel" runat="server" Text="Payment Methods:" ToolTip="Select the payment methods that are associated with this gateway." />
                </th>
                <td>
                    <asp:DataList ID="PaymentMethodList" runat="server" DataKeyField="PaymentMethodId" RepeatLayout="Flow">
                        <ItemTemplate>
                            <asp:CheckBox ID="Method" runat="server" Text='<%#Eval("Name")%>' Checked='<%#IsMethodAssigned(Container.DataItem)%>' />
                        </ItemTemplate>
                    </asp:DataList>
                </td>
            </tr>
            <tr>
                <td style="width:150px">&nbsp;</td>
                <td>
                    <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
                    <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
                    <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false"/>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>