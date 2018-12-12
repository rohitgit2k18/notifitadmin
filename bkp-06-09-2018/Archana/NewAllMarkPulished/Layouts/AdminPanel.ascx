<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Layouts.AdminPanel" CodeFile="AdminPanel.ascx.cs" %>
<div id="adminPanel" class="noPrint">
    <asp:Panel ID="EditItemPanel" runat="server" CssClass="editItemPanel">
        <asp:Label ID="EditLabel" runat="server" Text="Edit:" CssClass="rowHeader"></asp:Label>
        <asp:HyperLink ID="EditItemLink" runat="server" Text="Edit Page"></asp:HyperLink>
    </asp:Panel>
    <asp:Panel ID="DisplayPagePanel" runat="server" CssClass="displayPagePanel">
        <asp:Label ID="DisplayPageLabel" runat="server" Text="Display Page:" AssociatedControlID="DisplayPage" EnableViewState="false" CssClass="rowHeader"></asp:Label>
        <asp:DropDownList ID="DisplayPage" runat="server" DataSourceID="DisplayPageDs" DataTextField="Name" 
            DataValueField="Id" AppendDataBoundItems="true">
            <asp:ListItem Text="Use store default" Value="0"></asp:ListItem>
        </asp:DropDownList>
        <asp:ObjectDataSource ID="DisplayPageDs" runat="server" OldValuesParameterFormatString="original_{0}"
            SelectMethod="LoadForWebpageType" 
            TypeName="CommerceBuilder.Catalog.WebpageDataSource" 
            onselecting="DisplayPageDs_Selecting">
            <SelectParameters>
                <asp:Parameter DefaultValue="ProductDisplay" Name="webpageType" Type="Object" />
                <asp:Parameter DefaultValue="Name" Name="sortExpression" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:Button ID="UpdateButton" runat="server" Text="Update" 
            onclick="UpdateButton_Click" />
        <asp:HyperLink ID="MangeDisplayPagesLink" runat="server" Text="Manage Display Pages" CssClass="button"></asp:HyperLink>
    </asp:Panel>
</div>