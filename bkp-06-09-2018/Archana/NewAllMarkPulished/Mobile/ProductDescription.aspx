<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="ProductDescription.aspx.cs" Inherits="AbleCommerce.Mobile.ProductDescription" %>
<%@ Register Src="~/Mobile/UserControls/ProductCustomFieldsDialog.ascx" TagName="CustomFields" TagPrefix="uc" %>
<%@ Register src="~/Mobile/UserControls/NavBar.ascx" tagname="NavBar" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageContent" runat="server">
<uc1:NavBar ID="NavBar" runat="server" />
<div id="productDescriptionPage" class="mainContentWrapper">    
    <div class="section">
        <div class="pageHeader">
            <h1><asp:Label ID="ProductName" runat="server" EnableViewState="false"></asp:Label></h1>
        </div>
        <asp:PlaceHolder ID="MainDescription" runat="server">
        <div class="header" id="descHeader" runat="server">
            <h2>
                <asp:Literal ID="phCaption" runat="server" Text="Product Description" EnableViewState="false"></asp:Literal>&nbsp;
            </h2>
        </div>        
		<div class="content">
			<asp:Literal ID="phDescription" runat="server" EnableViewState="false"></asp:Literal>
        </div>        
        </asp:PlaceHolder>
        
        <asp:PlaceHolder ID="DetailedDescription" runat="server">
        <div class="header" id="detailHeader" runat="server">
            <h2>
                <asp:Literal ID="phDetailCaption" runat="server" Text="Product Details" EnableViewState="false"></asp:Literal>&nbsp;
            </h2>
        </div>
        <div class="content">
            <asp:Literal ID="extDescription" runat="server" EnableViewState="false"></asp:Literal>
        </div>
        </asp:PlaceHolder>

        <uc:CustomFields ID="CustomFields" runat="server" />

    </div>
</div>
</asp:Content>
<asp:Content ID="Content2" runat="server" contentplaceholderid="PageFooter"></asp:Content>
<asp:Content ID="Content3" runat="server" contentplaceholderid="PageHeader"></asp:Content>
