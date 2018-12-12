<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin._Payment.GiftCertificates" Title="Gift Certificates" CodeFile="GiftCertificates.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar2" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript">
        function toggleSelected(checkState)
        {
            // Toggles through all of the checkboxes defined in the CheckBoxIDs array
            // and updates their value to the checkState input parameter            
            for(i = 0; i< document.forms[0].elements.length; i++){
                var e = document.forms[0].elements[i];
                var name = e.name;
                if ((e.type == 'checkbox') && (name.indexOf('DeleteCheckbox') != -1) && !e.disabled)
                {
                    e.checked = checkState.checked;
                }
            }            
        }
    </script>
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Gift Certificates"></asp:Localize></h1>
            <div class="links">
                <cb:NavigationLink ID="GCSettingsLink" runat="server" Text="Configure Gift Certificates..." SkinID="Button" NavigateUrl="~/Admin/Store/Maintenance.aspx"></cb:NavigationLink>
            </div>
    	</div>
    </div>
     <asp:UpdatePanel ID="GiftCertificatesGridAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="content">
                <p><asp:Localize ID="InstructionText" runat="server" Text="You can add a Gift Certificate here, or you can create products with the Gift Certificate option checked."></asp:Localize></p>
            </div>
            <div class="searchPanel">
                <table class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="SerialNumberLabel" runat="server" Text="Serial Number:" AssociatedControlID="SerialNumber"
                                ToolTip="Filter results by the gift certificate serial number." EnableViewState="false" />
                        </th>
                        <td>
                            <asp:TextBox ID="SerialNumber" runat="server" Width="220px"></asp:TextBox>
                        </td>
                            <th>
                            <cb:ToolTipLabel ID="ExpirationStartLabel" runat="server" Text="Expiration:" AssociatedControlID="ExpirationStart"
                                ToolTip="Find gift certificates that will expire within a given date range." EnableViewState="false"/>
                        </th>
                        <td colspan="3">
                            <uc1:PickerAndCalendar2 ID="ExpirationStart" runat="server" /> 
                            &nbsp;<asp:Label ID="ExpirationEndLabel" runat="server" Text="to" SkinID="fieldHeader"></asp:Label>&nbsp; 
                            <uc1:PickerAndCalendar2 ID="ExpirationEnd" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="EmailLabel" runat="server" Text="Email:" AssociatedControlID="Email"
                                ToolTip="You can enter email to filter the list." />
                        </th>
                        <td>
                            <asp:TextBox ID="Email" runat="server" Text="" Width="220px"></asp:TextBox>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="LastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="LastName"
                                ToolTip="Filter the list by part of a customer last name." />
                        </th>
                        <td>
                            <asp:TextBox ID="LastName" runat="server" Text=""></asp:TextBox>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="FirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="FirstName"
                                ToolTip="Filter the list by part of a customer first name." />
                        </th>
                        <td>
                            <asp:TextBox ID="FirstName" runat="server" Text=""></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="OrderNumberLabel" runat="server" Text="Order Number(s):" AssociatedControlID="OrderNumber"
                                ToolTip="You can enter order number(s) to filter the list.  Separate multiple orders with a comma.  You can also enter ranges like 4-10 for all orders numbered 4 through 10." />
                        </th>
                        <td>
                            <asp:TextBox ID="OrderNumber" runat="server" Text=""></asp:TextBox>
                            <cb:IdRangeValidator ID="OrderNumberValidator" runat="server" Required="false"
                                ControlToValidate="OrderNumber" Text="*" 
                                ErrorMessage="The range is invalid.  Enter a specific order number or a range of numbers like 4-10.  You can also include mulitple values separated by a comma."></cb:IdRangeValidator>                
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="StatusListLabel" runat="server" AssociatedControlID="StatusList" EnableViewState="false" Text="Status:" ToolTip="Filter by active/inactive status." />
                        </th>
                        <td colspan="3">
                            <asp:DropDownList ID="StatusList" runat="Server" >
                                <asp:ListItem Text="Active Certificates" Value="0" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Inactive Certificates" Value="1"></asp:ListItem>
                                <asp:ListItem Text="All" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" align="center">
                            <asp:Button ID="SearchButton" runat="server" Text="Search" />
                            <asp:HyperLink ID="ResetSearchButton" runat="server" Text="Reset" SkinID="CancelButton" NavigateUrl="GiftCertificates.aspx"></asp:HyperLink>
                            <asp:HyperLink ID="AddGiftCertificate" runat="server" Text="Add Gift Certificate" NavigateUrl="AddGiftCertificate.aspx" SkinID="AddButton" ToolTip="You can add a Gift Certificate here, or you can create products with the Gift Certificate option checked."></asp:HyperLink>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="content">
                <cb:AbleGridView ID="GiftCertificatesGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
                    DataSourceID="GiftCertificateDs" OnRowCommand="GiftCertificatesGrid_RowCommand" AllowSorting="True" 
                    SkinID="PagedList" AllowPaging="true" PageSize="20" Width="100%">
                    <Columns>    
                        <asp:TemplateField HeaderText="Select">
                            <HeaderTemplate>
                                <input type="checkbox" onclick="toggleSelected(this)" />
                            </HeaderTemplate>
                            <ItemStyle HorizontalAlign="Center" Width="40px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="DeleteCheckbox" runat="server" Enabled ='<%#IsDeleteable((int)Eval("GiftCertificateId")) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>                
                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>
								<asp:HyperLink ID="GiftCertTransactionsLink" runat="server" Text='<%# Eval("Name") %>' NavigateUrl='<%#Eval("Id", "../Reports/GiftCertTransactions.aspx?GiftCertificateId={0}")%>'>
								</asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>                                                
                        <asp:TemplateField HeaderText="Order#">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                            	<asp:HyperLink ID="GiftCertOrderIdLink" runat="server" Text='<%# Eval("OrderItem.Order.OrderNumber") %>' NavigateUrl='<%#string.Format("../Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderItem.Order.OrderNumber"))%>'>
								</asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>                        
						<asp:TemplateField HeaderText="Created" SortExpression="CreateDate" >                            
                            <ItemTemplate>
                                <asp:Label ID="CreateDate" runat="server" Text='<%#Eval("CreateDate", "{0:d}")%>' Visible='<%#(DateTime)Eval("CreateDate") != System.DateTime.MinValue%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
						<asp:TemplateField HeaderText="Expires" SortExpression="ExpirationDate">                            
                            <ItemTemplate>
                                <asp:Label ID="ExpirationDate" runat="server" Text='<%#Eval("ExpirationDate", "{0:d}")%>' Visible='<%#((DateTime?)Eval("ExpirationDate")).HasValue && ((DateTime?)Eval("ExpirationDate")) != DateTime.MinValue%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
						<asp:TemplateField HeaderText="Balance" SortExpression="Balance" >   
						    <ItemStyle HorizontalAlign="right" />                         
                            <ItemTemplate>
                                <asp:Label ID="Balance" runat="server" Text='<%#Eval("Balance", "{0:F2}")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Serial Number">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="SerialNumber" runat="server" Text='<%#Eval("SerialNumber")%>'></asp:Label>
								<asp:Button ID="Generate" runat="Server" Text="Generate" CommandName="Generate" CommandArgument='<%#Eval("GiftCertificateId")%>' Visible='<%#!HasSerialNumber(Container.DataItem)%>' OnClientClick='return confirm("Generating a Serial Number will Activate this Gift Certificate. Continue?")' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Right"  />
                            <ItemTemplate>
								<asp:Button ID="DeactivateButton" runat="server" CausesValidation="False" CommandName="Deactivate"  CommandArgument='<%#Eval("GiftCertificateId")%>' AlternateText="Deactivate" Text="Deactivate" Visible='<%#HasSerialNumber(Container.DataItem)%>' OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to deactivate {0}?\")") %>'/>
                                <asp:HyperLink ID="ViewHistory" runat="Server" SkinID="button"   Text="View Transactions"   EnableViewState="false" NavigateUrl='<%#Eval("GiftCertificateId","~/Admin/Reports/GiftCertTransactions.aspx?GiftCertificateId={0}") %>'  />
                                <asp:HyperLink ID="EditButton" runat="server" NavigateUrl='<%#Eval("GiftCertificateId", "EditGiftCertificate.aspx?GiftCertificateId={0}") %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" /></asp:HyperLink>
                                <asp:ImageButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" SkinID="DeleteIcon" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' AlternateText="Delete" Visible='<%#IsDeleteable((int)Eval("GiftCertificateId")) %>' />
                                
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyMessage" runat="server" Text="No Gift Certificates found."></asp:Label>
                    </EmptyDataTemplate>
                </cb:AbleGridView>
                <asp:Button ID="MultipleRowDelete" runat="server" Text="Delete Selected" OnClick="MultipleRowDelete_Click" OnClientClick="return confirm('Are you sure you want to delete the selected gift certificate(s)?')"  />
                <asp:ObjectDataSource ID="GiftCertificateDs" runat="server" DeleteMethod="Delete"
                    OldValuesParameterFormatString="{0}" SelectMethod="Search" 
                    TypeName="CommerceBuilder.Payments.GiftCertificateDataSource" SortParameterName="sortExpression" SelectCountMethod="SearchCount">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="SerialNumber" Name="serialNumber" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="FirstName" Name="firstName" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="LastName" Name="lastName" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="Email" Name="email" PropertyName="Text" Type="String" />
                        <asp:ControlParameter Name="expirationStart" ControlID="ExpirationStart" PropertyName="SelectedStartDate" />
                        <asp:ControlParameter Name="expirationEnd" ControlID="ExpirationEnd" PropertyName="SelectedEndDate" />
                        <asp:ControlParameter Name="orderRange" ControlID="OrderNumber" PropertyName="Text" />
                        <asp:ControlParameter ControlID="StatusList" Name="status" PropertyName="SelectedValue" Type="Object" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </div> 
         </ContentTemplate>
    </asp:UpdatePanel>
    
</asp:Content>