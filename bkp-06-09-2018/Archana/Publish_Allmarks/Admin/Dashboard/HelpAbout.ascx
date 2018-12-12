<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HelpAbout.ascx.cs" Inherits="AbleCommerce.Admin.Dashboard.HelpAbout" %>
<div class="section">
    <div class="header">
    	<h2><asp:Localize ID="Caption" runat="server" Text="About AbleCommerce {0}"></asp:Localize></h2>
    </div>
    <div class="content">
        <asp:TextBox ID="DllVersions" runat="server" Width="400px" Height="200px" TextMode="multiLine"></asp:TextBox><br />
        <p class="small">This product includes software developed by the Apache Software Foundation (http://www.apache.org/).  It also includes some third party components that are licensed under the terms of LGPL, among others.  Please review the App_Data/Licenses folder of your installation for complete details.</p>
    </div>
</div>