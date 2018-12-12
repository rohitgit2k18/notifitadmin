<%@ Page Title="Three Column Browser" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="ThreeColumnBrowser.aspx.cs" Inherits="AbleCommerce.Admin.Skinning.ThreeColumnBrowser" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Three Column Browser"></asp:Localize></h1>
        </div>
    </div>
    <div class="grid_3 alpha">
        <div class="leftColumn">
            <div class="section">
                <div class="header">
                    Navigation
                </div>
                <div class="content">
                    [tree]
                </div>
            </div>
        </div>
    </div>
    <div class="grid_6">
        <div class="mainColumn">
            <div class="content">
                [main output here]
            </div>
        </div>
    </div>
    <div class="grid_3 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    Action Panel
                </div>
                <div class="content">
                    [form]
                </div>
            </div>
        </div>
    </div>
</asp:Content>