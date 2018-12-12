<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.People.Manufacturers._Default" Title="Manufacturers"  CodeFile="Default.aspx.cs" AutoEventWireup="True" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Manufacturers"></asp:Localize></h1>
            	<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="people" />
    	</div>
    </div>
    <div class="grid_8 alpha">
        <div class="mainColumn">
            <asp:Button runat="server" ID="HiddenTargetControlForModalPopup" style="display:none" />
            <asp:Panel ID="EditManufacturerDialog" runat="server" Style="display: none" CssClass="modalPopup" Width="450px">
            <asp:Panel ID="EditManufacturerDialogHeader" runat="server" CssClass="modalPopupHeader">
                Edit Manufacturer
            </asp:Panel>
            <div class="content">
            <asp:UpdatePanel ID="EditAjax" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <cb:Notification ID="SavedMessage" runat="server" Text="Manufacturer saved at {0:t}." Visible="false" SkinID="GoodCondition" EnableViewState="False"></cb:Notification>
                    <asp:ValidationSummary ID="ValidationSummary2" ValidationGroup="EditManufacturer" runat="server" />
                    <table class="inputForm">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" AssociatedControlID="Name" ToolTip="Name of manufacturer" SkinId="FieldHeader" />
                            </th>
                            <td>
                                <asp:TextBox ID="Name" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="NameRequired" runat="server" ValidationGroup="EditManufacturer" ControlToValidate="Name" Display="Static" ErrorMessage="Manufacturer name is required.">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:HiddenField ID="HiddenManufacturerId" runat="server" />
                                <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" ValidationGroup="EditManufacturer" OnClick="SaveButton_Click" />
				                <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" OnClick="CancelButton_Click" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        </asp:Panel>
            <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender" runat="server" 
                            TargetControlID="HiddenTargetControlForModalPopup"
                            PopupControlID="EditManufacturerDialog" 
                            BackgroundCssClass="modalBackground" 
                            CancelControlID="CancelButton" 
                            DropShadow="true"
                            PopupDragHandleControlID="EditManufacturerDialogHeader" />
            <asp:UpdatePanel ID="SearchAjax" runat="server" UpdateMode="Conditional" >                    
                <ContentTemplate>
                    <div class="searchPanel">
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <asp:Label ID="SearchByLabel" runat="server" Text="Search by Name:" SkinID="FieldHeader" ToolTip="Specify search pattern"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SearchText" runat="server" Width="200px"></asp:TextBox>&nbsp;
                                        <asp:Button ID="SearchButton" CausesValidation="false" runat="server" Text="Search" SkinID="Button" OnClick="SearchButton_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="AlphabetRepeaterLabel" AssociatedControlID="AlphabetRepeater" runat="server" Text="Quick Search:" SkinID="FieldHeader"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:Repeater runat="server" ID="AlphabetRepeater" OnItemCommand="AlphabetRepeater_ItemCommand">
                                            <ItemTemplate>
                                            <asp:LinkButton CausesValidation="false" runat="server" ID="LinkButton1" CommandName="Display" CommandArgument="<%#Container.DataItem%>" Text="<%#Container.DataItem%>" />
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="content">
                            <cb:SortedGridView ID="ManufacturerGrid" runat="server" AllowPaging="true" AllowSorting="true" PageSize="20"
                                AutoGenerateColumns="False" DataKeyNames="ManufacturerId" DataSourceID="ManufacturerDs" 
                                ShowFooter="False" OnRowCommand="ManufacturerGrid_RowCommand" DefaultSortExpression="Name" SkinID="PagedList" Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemTemplate>
                                            <asp:HyperLink ID="NameLink" runat="server" NavigateUrl='<%#Eval("ManufacturerId", "EditManufacturer.aspx?ManufacturerId={0}")%>' Text='<%# Eval("Name") %>'></asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Products">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:HyperLink ID="ProductsLabel" runat="server" Text='<%#GetProductCount(Container.DataItem)%>' NavigateUrl='<%#Eval("ManufacturerId", "EditManufacturer.aspx?ManufacturerId={0}")%>'></asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:LinkButton ID="EditLink" runat="server" OnClientClick="ShowModalPopup()" CommandName="EditManufacturer" CommandArgument='<%#String.Format("{0}", Eval("ManufacturerId"))%>' CausesValidation="false"><asp:Image ID="EditIcon" SkinID="Editicon" runat="server" /></asp:LinkButton>                                            <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick='<%# Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\");") %>' Visible='<%# !HasProducts(Container.DataItem) %>'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" AlternateText="Delete" /></asp:LinkButton>
                                            <asp:HyperLink ID="DeleteLink" runat="server" CausesValidation="False" NavigateUrl='<%# Eval("ManufacturerId", "DeleteManufacturer.aspx?ManufacturerId={0}")%>' Visible='<%# HasProducts(Container.DataItem) %>'><asp:Image ID="DeleteIcon2" runat="server" SkinID="DeleteIcon" AlternateText="Delete" /></asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <asp:Label ID="EmptyDataText" runat="server" Text="No manufacturers are defined for your store."></asp:Label>
                                </EmptyDataTemplate>
                            </cb:SortedGridView>
                            <p><asp:Localize ID="InstructionText" runat="server" Text="Products assigned to a Manufacturer have additional display and search options."></asp:Localize></p>
                        </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div class="grid_4 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    <h2 class="addmanufacturer"><asp:Localize ID="AddCaption" runat="server" Text="Add Manufacturer" /></h2>
                </div>
                <div class="content">
                    <asp:UpdatePanel ID="AddAjax" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:ValidationSummary ID="ValidationSummary1" ValidationGroup="AddVendor" runat="server" />
                            <asp:Label ID="AddedMessage" runat="server" Text="{0} added.<br />" SkinID="GoodCondition" Visible="false"></asp:Label>
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <asp:Label ID="AddManufacturerNameLabel" runat="server" Text="Name:" AssociatedControlID="AddManufacturerName" ToolTip="Name of manufacturer"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="AddManufacturerName" ValidationGroup="AddVendor" runat="server" Width="150px" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="AddManufacturerNameRequired" runat="server" ControlToValidate="AddManufacturerName"
                                            Display="Static" ErrorMessage="Manufacturer name is required." Text="*"></asp:RequiredFieldValidator>
                                        <asp:Button ID="AddManufacturerButton" ValidationGroup="AddVendor" runat="server" Text="Add" OnClick="AddManufacturerButton_Click" />
                                    </td>
                                </tr>
                            </table>
                            <asp:ObjectDataSource ID="ManufacturerDs" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="FindManufacturersByName" TypeName="CommerceBuilder.Products.ManufacturerDataSource"
                                EnablePaging="True" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Products.Manufacturer"
                                DeleteMethod="Delete">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="SearchText" Name="searchPattern" PropertyName="Text"
                                        Type="String" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
<script type="text/javascript">
    var ModalPopup = '<%= ModalPopupExtender.ClientID %>';

    function ShowModalPopup() {
        //  show the Popup     
        $find(ModalPopup).show();
    }
</script>
</asp:Content>