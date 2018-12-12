<%@ Page Language="C#" MasterPageFile="../../Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers.AddGateway" Title="Add Gateway"  CodeFile="AddGateway.aspx.cs" EnableViewState="false" %>
<asp:Content ID="Content" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Add Integrated Carrier"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
        <asp:GridView ID="ProviderGrid" runat="server" AutoGenerateColumns="False" 
            CellSpacing="0" CellPadding="4" GridLines="None" Width="100%" ShowHeader="false">
            <Columns>
                <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="top">
                    <ItemTemplate>
                        <asp:HyperLink ID="ProviderLink" runat="server" NavigateUrl="<%#GetConfigUrl(Container.DataItem)%>">
                            <asp:Image ID="ProviderLogo" runat="server" ImageUrl='<%#GetLogoUrl(Container.DataItem)%>' />
                        </asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-HorizontalAlign="Left">
                    <ItemTemplate>
                        <asp:HyperLink ID="ProviderNameLink" runat="server" NavigateUrl="<%#GetConfigUrl(Container.DataItem)%>">
                            <%#Eval("Name")%>
                        </asp:HyperLink><br />
                        <%#Eval("Description")%>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>