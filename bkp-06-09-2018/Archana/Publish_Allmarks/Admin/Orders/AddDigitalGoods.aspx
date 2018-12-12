<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.AddDigitalGoods" Title="Add Digital Goods" CodeFile="AddDigitalGoods.aspx.cs" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Order #{0} - Add Digital Good"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript">
        function toggleSelected(checkState)
        {
            // Toggles through all of the checkboxes defined in the CheckBoxIDs array
            // and updates their value to the checkState input parameter            
            for(i = 0; i< document.forms[0].elements.length; i++){
                var e = document.forms[0].elements[i];
                var name = e.name;
                if ((e.type == 'checkbox') && (name.indexOf('SelectCheckbox') != -1) && !e.disabled)
                {
                    e.checked = checkState.checked;
                }
            }            
        }
    </script>
    <asp:UpdatePanel ID="SearchAjax" runat="server">
        <ContentTemplate>
            <div class="searchPanel">
                <p><asp:Label ID="InstructionText" runat="server" Text="Enter all or part of a digital good name.  You can also leave the name field empty to show all."></asp:Label></p>
                <asp:Panel ID="SearchPanel" runat="server" DefaultButton="SearchButton">
                    <table class="inputForm compact" border="0">
                        <tr>
                            <th>
                                <asp:Label ID="SearchNameLabel" runat="server" Text="Name Filter:" />
                            </th>
                            <td>
                                <asp:TextBox ID="SearchName" runat="server" Text=""></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="SearchButton_Click" />
                                <asp:HyperLink ID="CancelLink" runat="server" SkinID="CancelButton" Text="Cancel" NavigateUrl="ViewDigitalGoods.aspx?OrderNumber={0}"/>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>
            <div class="content">
                <cb:SortedGridView ID="SearchResultsGrid" runat="server" AutoGenerateColumns="false" 
                    ShowHeader="true" ShowFooter="true" DataKeyNames="Id" SkinID="PagedList"
                    DataSourceID="DigitalGoodDs" Visible="false"  Width="100%" 
                    AllowSorting="true" DefaultSortExpression="Name" AllowPaging="true" PageSize="20">
                    <Columns>
                        <asp:TemplateField HeaderText="Select">
                            <HeaderTemplate>
                                <input type="checkbox" onclick="toggleSelected(this)" />
                            </HeaderTemplate>
                            <ItemStyle HorizontalAlign="Center" Width="40px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="SelectCheckbox" runat="server"/>
                            </ItemTemplate>
                            <FooterStyle HorizontalAlign="Center" />
                            <FooterTemplate>
                                <asp:Button ID="OkButton" runat="server" Text="Add Selected" OnClick="OkButton_Click" />
                            </FooterTemplate>
                        </asp:TemplateField>      
                        <asp:TemplateField HeaderText="Digital Good Name" SortExpression="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:HyperLink ID="Name" runat="server" NavigateUrl='<%# string.Format("../DigitalGoods/EditDigitalGood.aspx?DigitalGoodId={0}", Eval("Id")) %>' Text='<%#Eval("Name")%>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="FileName" HeaderText="File Name" SortExpression="FileName">
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:BoundField>                                
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyMessage" runat="server" Text="There are no digital goods that match the search text."></asp:Label>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="DigitalGoodDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="FindByName" SortParameterName="sortExpression" TypeName="CommerceBuilder.DigitalDelivery.DigitalGoodDataSource">
        <SelectParameters>
            <asp:ControlParameter Name="nameToMatch" ControlID="SearchName" PropertyName="Text" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>