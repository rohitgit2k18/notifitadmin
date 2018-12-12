<%@ Page Title="Right Column Summary Grid" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="RightColumnSummaryGrid.aspx.cs" Inherits="AbleCommerce.Admin.Skinning.RightColumnSummaryGrid" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Right Column Summary Grid"></asp:Localize></h1>
        </div>
    </div>
    <div class="grid_9 alpha">
        <div class="mainColumn">
            <div class="content">
                <p>Summary information about the grid.</p>
                [grid here]
            </div>
        </div>
    </div>
    <div class="grid_3 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    Add Record
                </div>
                <div class="content">
                    [add form]
                </div>
            </div>
        </div>
    </div>
</asp:Content>