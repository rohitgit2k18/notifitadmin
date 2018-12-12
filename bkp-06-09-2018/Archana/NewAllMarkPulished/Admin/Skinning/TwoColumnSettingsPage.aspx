<%@ Page Title="Two Column Settings Page" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="TwoColumnSettingsPage.aspx.cs" Inherits="AbleCommerce.Admin.Skinning.TwoColumnSettingsPage" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Two Column Settings Page"></asp:Localize></h1>
        </div>
    </div>
    <div class="grid_6 alpha">
        <div class="leftColumn">
            <div class="section">
                <div class="header">
                    Header
                </div>
                <div class="content">
                    Content
                </div>
            </div>
        </div>
    </div>
    <div class="grid_6 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    Header
                </div>
                <div class="content">
                    Content
                </div>
            </div>
        </div>
    </div>
</asp:Content>