<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.Master" AutoEventWireup="true" CodeFile="StoreClosed.aspx.cs" Inherits="AbleCommerce.Mobile.StoreClosed" %>
<asp:Content ID="Contents" ContentPlaceHolderID="PageContent" runat="server">
    <div id="storeClosedPage" class="mainContentWrapper">
        <div class="section">
            <div class="header">
                <h2>Store Is Closed</h2>
            </div>
                 <div class="content descSummary">
                    <span class="summary">
                        <asp:PlaceHolder ID="PHContent" runat="server"></asp:PlaceHolder>
                    </span>
                 </div>
            </div>
      </div>
</asp:Content>
<asp:Content ID="Content2" runat="server" contentplaceholderid="PageFooter"></asp:Content>