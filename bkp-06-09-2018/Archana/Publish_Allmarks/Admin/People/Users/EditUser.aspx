<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.People.Users.EditUser" Title="Edit User" EnableViewState="false" CodeFile="EditUser.aspx.cs" %>
<%@ Register Src="AccountTabPage.ascx" TagName="AccountTabPage" TagPrefix="uc" %>
<%@ Register Src="AddressBook.ascx" TagName="AddressBook" TagPrefix="uc" %>
<%@ Register Src="CurrentBasketDialog.ascx" TagName="CurrentBasketDialog" TagPrefix="uc" %>
<%@ Register Src="OrderHistoryDialog.ascx" TagName="OrderHistoryDialog" TagPrefix="uc" %>
<%@ Register Src="ViewHistoryDialog.ascx" TagName="ViewHistoryDialog" TagPrefix="uc" %>
<%@ Register Src="PurchaseHistoryDialog.ascx" TagName="PurchaseHistoryDialog" TagPrefix="uc" %>
<%@ Register Src="SearchHistoryDialog.ascx" TagName="SearchHistoryDialog" TagPrefix="uc" %>
<%@ Register Src="PaymentProfilesDialog.ascx" TagName="PaymentProfilesDialog" TagPrefix="uc" %>
<%@ Register Src="ShippingAddresses.ascx" TagName="ShippingAddresses" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <ajaxToolkit:TabContainer ID="Tabs" runat="server" 
            Width="100%"
            ActiveTabIndex="0"        
            OnDemand="true"        
            AutoPostBack="false"
            TabStripPlacement="Top"
            ScrollBars="None">
        <ajaxToolkit:TabPanel ID="AccountTab" runat="server" 
            HeaderText="Account"
            Enabled="true"
            ScrollBars="Auto"        
            OnDemandMode="None">
            <ContentTemplate>
                <div class="pageHeader">
    	            <div class="caption">
    		            <h1><asp:Localize ID="Caption1" runat="server" Text="Account for {0}"></asp:Localize></h1>
    	            </div>
                </div>
                <uc:AccountTabPage ID="AccountTabPage" runat="server" />
            </ContentTemplate>
        </ajaxToolkit:TabPanel>
        <ajaxToolkit:TabPanel ID="AddressTab" runat="server" 
            HeaderText="Addresses"
            Enabled="true"
            ScrollBars="Auto"        
            OnDemandMode="None">
            <ContentTemplate>
                <div class="pageHeader">
    	            <div class="caption">
    		            <h1><asp:Localize ID="Caption2" runat="server" Text="Billing Address for {0}"></asp:Localize></h1>
    	            </div>
                </div>
                <uc:AddressBook ID="AddressBook" runat="server" />
                <div class="pageHeader">
    	            <div class="caption">
    		            <h1><asp:Localize ID="ShippingAddressesCaption" runat="server" Text="Shipping Addresses"></asp:Localize></h1>
    	            </div>
                </div>
                <uc:ShippingAddresses ID="ShippingAddresses1" runat="server" />
            </ContentTemplate>
        </ajaxToolkit:TabPanel>
        <ajaxToolkit:TabPanel ID="PurchaseHistoryTab" runat="server" 
            HeaderText="Purchase History"
            Enabled="true"
            ScrollBars="Auto"        
            OnDemandMode="None">
            <ContentTemplate>
                <div class="pageHeader">
    	            <div class="caption">
    		            <h1><asp:Localize ID="Caption3" runat="server" Text="Purchase History for {0}"></asp:Localize></h1>
    	            </div>
                </div>
                <uc:PurchaseHistoryDialog ID="PurchaseHistoryDialog1" runat="server" />
            </ContentTemplate>
        </ajaxToolkit:TabPanel>
        <ajaxToolkit:TabPanel ID="OrderHistoryTab" runat="server" 
            HeaderText="Orders"
            Enabled="true"
            ScrollBars="Auto"        
            OnDemandMode="None">
            <ContentTemplate>
                <div class="pageHeader">
    	            <div class="caption">
    		            <h1><asp:Localize ID="Caption4" runat="server" Text="Orders for {0}"></asp:Localize></h1>
    	            </div>
                </div>
                <uc:OrderHistoryDialog ID="OrderHistoryDialog1" runat="server" />
                <uc:CurrentBasketDialog ID="CurrentBasketDialog1" runat="server" />
            </ContentTemplate>
        </ajaxToolkit:TabPanel>
        <ajaxToolkit:TabPanel ID="PageViewTab" runat="server" 
            HeaderText="Page Views"
            Enabled="true"
            ScrollBars="Auto"        
            OnDemandMode="None">
            <ContentTemplate>
                <div class="pageHeader">
    	            <div class="caption">
    		            <h1><asp:Localize ID="Caption5" runat="server" Text="Page Views for {0}"></asp:Localize></h1>
    	            </div>
                </div>
                <uc:ViewHistoryDialog id="ViewHistoryDialog1" runat="server" />                    
            </ContentTemplate>
        </ajaxToolkit:TabPanel>
        <ajaxToolkit:TabPanel ID="SearchHistoryTab" runat="server" 
            HeaderText="Search History"
            Enabled="true"
            ScrollBars="Auto"        
            OnDemandMode="None">
            <ContentTemplate>
                <div class="pageHeader">
    	            <div class="caption">
    		            <h1><asp:Localize ID="Caption6" runat="server" Text="Search History for {0}"></asp:Localize></h1>
    	            </div>
                </div>
                <uc:SearchHistoryDialog id="SearchHistoryDialog1" runat="server" />                    
            </ContentTemplate>
        </ajaxToolkit:TabPanel>
        <ajaxToolkit:TabPanel ID="PaymentProfilesTab" runat="server" 
            HeaderText="Payment Profiles"
            Enabled="true"
            ScrollBars="Auto"        
            OnDemandMode="None">
            <ContentTemplate>
                <div class="pageHeader">
    	            <div class="caption">
    		            <h1><asp:Localize ID="Caption7" runat="server" Text="Payment Profiles for {0}"></asp:Localize></h1>
    	            </div>
                </div>
                <uc:PaymentProfilesDialog id="PaymentProfilesDialog1" runat="server" />                    
            </ContentTemplate>
        </ajaxToolkit:TabPanel>
    </ajaxToolkit:TabContainer>
</asp:Content>