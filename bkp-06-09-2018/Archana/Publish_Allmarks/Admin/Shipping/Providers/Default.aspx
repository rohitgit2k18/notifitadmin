<%@ Page Language="C#" MasterPageFile="../../Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._Default" Title="Shipping Gateways"  CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Integrated Carriers"></asp:Localize></h1>
            	<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/shipping" />
    	</div>
    </div>
    <div class="content">
        <asp:HyperLink ID="AddGatewayButton" runat="server" Text="Add Shipping Carrier" NavigateUrl="AddGateway.aspx" SkinId="AddButton"></asp:HyperLink>
        <p><asp:Localize ID="InstructionText" runat="server" Text="An integrated shipping carrier is required to provide real-time shipping rates.  Most carriers support shipment tracking."></asp:Localize></p>
        <asp:GridView ID="GatewayGrid" runat="server" DataKeyNames="ShipGatewayId" DataSourceID="ShipGatewayDs" 
            AutoGenerateColumns="false" Width="100%" SkinID="PagedList">
            <Columns>                        
                <asp:TemplateField HeaderText="Carrier">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:HyperLink ID="LogoLink" runat="server" NavigateUrl='<%#GetConfigUrl(Container.DataItem)%>'>
                            <asp:Image ID="Logo" runat="server" AlternateText='<%=Eval("Name")%>' ImageUrl='<%#GetLogoUrl(Container.DataItem)%>' />
                        </asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Shipping Methods">
                    <ItemStyle HorizontalAlign="Left" Width="65%" />
                    <ItemTemplate>
                        <asp:BulletedList ID="ShipMethodList" runat="server" DataSource='<%#GetShipMethodList(Container.DataItem)%>'> </asp:BulletedList>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemStyle HorizontalAlign="Center" Width="10%" />
                    <ItemTemplate>
                        <asp:HyperLink ID="EditButton" runat="server" NavigateUrl='<%#GetConfigUrl(Container.DataItem) %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" /></asp:HyperLink>
                        <asp:ImageButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" SkinID="DeleteIcon" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' AlternateText="Delete" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyMessage" runat="server" Text="No integrated shipping carriers have been configured for your store.  To get started, click the 'Add Shipping Carrier' button."></asp:Label>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
    <asp:ObjectDataSource ID="ShipGatewayDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Shipping.ShipGatewayDataSource" SelectCountMethod="CountForStore" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Shipping.ShipGateway" DeleteMethod="Delete">
    </asp:ObjectDataSource>
</asp:Content>