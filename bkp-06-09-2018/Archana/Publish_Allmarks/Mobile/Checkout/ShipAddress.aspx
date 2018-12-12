<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="ShipAddress.aspx.cs" Inherits="AbleCommerce.Mobile.Checkout.ShipAddress" %>
<%@ Register src="~/Mobile/UserControls/CheckoutNavBar.ascx" tagname="CheckoutNavBar" tagprefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="server">
<uc1:CheckoutNavBar ID="CheckoutNavBar" runat="server" />
<div id="checkoutPage"> 
    <div id="checkout_shipAddrPage" class="mainContentWrapper"> 
        <div class="pageHeader">
            <h1><asp:Localize ID="Caption" runat="server" Text="Select Shipping Address"></asp:Localize></h1>
        </div>
        <div class="section">
            <div class="content">
                <asp:Repeater ID="ShipToAddressList" runat="server" OnItemCommand="ShipToAddressList_ItemCommand" >
                    <ItemTemplate>
                        <div class="entry">                            
                            <div class="address">
                                <asp:Literal ID="Address" runat="server" Text='<%#Container.DataItem.ToString()%>'></asp:Literal>
                            </div>
                            <div class="buttons">
                                <asp:LinkButton ID="PickAddressButton" runat="server" SkinID="Button" Text="Use this address" CommandName="Pick" CommandArgument='<%#Eval("AddressId")%>' CssClass="button"></asp:LinkButton>
                                <asp:LinkButton ID="EditAddressButton" runat="server" CommandArgument='<%#Eval("AddressId")%>' CommandName="Edit" Text="Edit" CssClass="button"></asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <hr />
                <span class="smallBlock">
                 <asp:HyperLink ID="AddNewAddressLink" runat="server" Text="Enter a new Shipping Address" CssClass="button" NavigateUrl="#" />
                </span>
            </div>
        </div>
    </div>
</div>
</asp:Content>