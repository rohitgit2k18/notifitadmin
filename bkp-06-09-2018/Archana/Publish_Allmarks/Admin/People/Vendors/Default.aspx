<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.People.Vendors._Default" Title="Vendors"  CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
  <div class="pageHeader">
  	<div class="caption">
  		<h1><asp:Localize ID="Caption" runat="server" Text="Vendors"></asp:Localize></h1>
        	<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="people" />
  	</div>
  </div>
    <div class="grid_8 alpha">
        <div class="mainColumn">
            <div class="content">
            <asp:Button runat="server" ID="HiddenTargetControlForModalPopup" style="display:none"/>
            <asp:Panel ID="EditVendorDialog" runat="server" Style="display: none" CssClass="modalPopup" Width="500px">
            <asp:Panel ID="EditVendorDialogHeader" runat="server" CssClass="modalPopupHeader">
                Edit Vendor
            </asp:Panel>
            <asp:UpdatePanel ID="EditAjax" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                <cb:Notification ID="SavedMessage" runat="server" Text="Vendor saved at {0:t}" SkinID="GoodCondition" Visible="false"></cb:Notification>
                    <asp:ValidationSummary ID="ValidationSummary2" ValidationGroup="EditVendor" runat="server" />
                    <table class="inputForm">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" AssociatedControlID="VendorName" ToolTip="The name of the vendor." />
                            </th>
                            <td>
                                <asp:TextBox ID="VendorName" runat="server" ValidationGroup="EditVendor" Width="200px" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="NameRequired" ValidationGroup="EditVendor" runat="server" ControlToValidate="VendorName"
                                        Display="Dynamic" ErrorMessage="Vendor name is required.">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="EmailLabel" runat="server" Text="Email Address:" AssociatedControlID="Email" ToolTip="Email address of the vendor. You can add multiple email addresses separated by a comma." />
                            </th>
                            <td>
                                <asp:TextBox ID="Email" runat="server" Width="200px" MaxLength="255"></asp:TextBox>
                                <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" AllowMultpleAddresses="true" ControlToValidate="Email" Required="false" ErrorMessage="Email address should be in the format of name@domain.tld, you can also add comma delimited multiple email addresses." Text="*" EnableViewState="False"></cb:EmailAddressValidator>                
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:HiddenField ID="HiddenVendorId" runat="server" />
				                <asp:Button ID="SaveButton" runat="server" ValidationGroup="EditVendor" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
                                <asp:Button ID="CancelButton" runat="server" Text="Cancel"  SkinID="CancelButton" CausesValidation="false" OnClick="CancelButton_Click" />                
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
            </asp:Panel>
            <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender" runat="server" 
                            TargetControlID="HiddenTargetControlForModalPopup"
                            PopupControlID="EditVendorDialog" 
                            BackgroundCssClass="modalBackground" 
                            CancelControlID="CancelButton" 
                            DropShadow="true"
                            PopupDragHandleControlID="EditVendorDialogHeader" />
                <asp:UpdatePanel ID="GridAjax" runat="server">
                    <ContentTemplate>
                        <cb:SortedGridView ID="VendorGrid" runat="server" AllowPaging="True" PageSize="20" AllowSorting="True"
                            AutoGenerateColumns="False" DataKeyNames="VendorId" DataSourceID="VendorDs" 
                            SkinID="PagedList" ShowFooter="False" Width="100%" BorderWidth="0" OnRowCommand="VendorGrid_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="NameLink" runat="server" Text='<%# Eval("Name") %>' NavigateUrl='<%#Eval("VendorId", "EditVendor.aspx?VendorId={0}")%>'></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Email" HeaderText="Email" HeaderStyle-HorizontalAlign="Left" />
                                <asp:TemplateField HeaderText="Products">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="ProductsLabel" runat="server" Text='<%#GetProductCount(Container.DataItem)%>' NavigateUrl='<%#Eval("VendorId", "EditVendor.aspx?VendorId={0}")%>'></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ShowHeader="False" >
                                    <ItemStyle Wrap="false" HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditLink"  runat="server" OnClientClick="ShowModalPopup()" CommandName="EditVendor" CommandArgument='<%#String.Format("{0}", Eval("VendorId"))%>' CausesValidation="false"><asp:Image ID="EditIcon" SkinID="Editicon" runat="server" /></asp:LinkButton>
                                        <asp:ImageButton ID="DeleteButton" runat="server" CausesValidation="False" SkinID="DeleteIcon" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' Visible='<%#ShowDeleteButton(Container.DataItem)%>' AlternateText="Delete" />
                                        <asp:HyperLink ID="DeleteLink" runat="server" NavigateUrl='<%# Eval("VendorId", "DeleteVendor.aspx?VendorId={0}")%>' Visible='<%# ShowDeleteLink(Container.DataItem) %>'><asp:Image ID="DeleteIcon2" runat="server" SkinID="DeleteIcon" AlternateText="Delete" /></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>                   
                                <asp:Label ID="EmptyMessage" runat="server" Text="There are no vendors defined for your store."></asp:Label>              
                            </EmptyDataTemplate>
                        </cb:SortedGridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <p><asp:Localize ID="InstructionText" runat="server" Text="Vendors are notified by email when their products are sold."></asp:Localize></p>
            </div>
        </div>
    </div>
    <div class="grid_4 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="AddVendorCaption" runat="server" Text="Add Vendor" /></h2>
                </div>
                <div class="content">    
                    <asp:ValidationSummary ID="ValidationSummary1" ValidationGroup="AddVendor" runat="server" />
                    <asp:Label ID="AddVendorNameLabel" runat="server" Text="Name: " SkinID="FieldHeader"></asp:Label>
                    <asp:TextBox ID="AddVendorName" ValidationGroup="AddVendor" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="AddVendorNameRequired" runat="server" ControlToValidate="AddVendorName"
                        Display="Dynamic" ErrorMessage="Vendor name is required." Text="*"></asp:RequiredFieldValidator>
                    <asp:Button ID="AddVendorButton" ValidationGroup="AddVendor" runat="server" Text="Add" SkinID="AddButton" OnClick="AddVendorButton_Click" />
                    <asp:ObjectDataSource ID="VendorDs" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="LoadAll" TypeName="CommerceBuilder.Products.VendorDataSource" SelectCountMethod="CountForStore" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Products.Vendor" DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
                        </asp:ObjectDataSource>
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
