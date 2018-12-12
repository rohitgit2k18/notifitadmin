<%@ Control Language="C#" AutoEventWireup="true" CodeFile="NavagationSection.ascx.cs" Inherits="AbleCommerce.Admin.Dashboard.NavagationSection" %>
<div id="MainPanel" runat="server" class="section dashboardNavigation">
    <div class='<%=this.CssClass%>'>
        <div class="header">
            <a href="<%=this.Url%>"><%=this.HeaderText%></a>
        </div>
        <div class="content">
            <div class="details">
                <div id="description" runat="server" class="description"><%=this.Description%></div>
            </div>
            <div class="menu">
                <div class="leftMenu">
                    <div class="icon">
                    </div>
                </div>
                <asp:Repeater ID="MenuItemRepeater" runat="server">
                    <HeaderTemplate>
                        <div class="rightMenu">
                        <ul>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li><a href='<%#Eval("Url") %>' title='<%#Eval("Description") %>' onmouseover="<%#GetScript((string)Eval("Description"))%>"><%#Eval("Title") %></a></li>
                    </ItemTemplate>
                    <FooterTemplate>
                        </ul>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</div>
