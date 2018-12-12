<%@ Page Language="C#" MasterPageFile="../Product.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.Kits.EditKit" Title="Edit Kit" CodeFile="EditKit.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Kitting for {0}" EnableViewState="false"></asp:Localize></h1>
                </div>
            </div>
            <div class="content">
                <asp:Button ID="AddComponentButton2" runat="server" SkinID="AddButton" Text="Add New Component" OnClick="AddComponentButton_Click" />
                <asp:HyperLink ID="AddExistingComponentButton" runat="server" SkinID="AddButton" Text="Add Existing Component" />                
                <asp:PlaceHolder ID="NewKitPanel" runat="server" Visible="false" EnableViewState="false">
                    <p><asp:Localize ID="NewKitMessage" runat="server">
                        In order to create a kit from this product, you must add at least one component. 
                    </asp:Localize></p>
                </asp:PlaceHolder>
            </div>
            <asp:PlaceHolder ID="ExistingKitPanel" runat="server" EnableViewState="false">
            <div class="section">
                <div class="header"><h2>Kit Configuration</h2></div>
                <div class="content">
                    <table class="summary">
                        <tr>
                            <th>
                                <asp:Label ID="PriceRangeLabel" runat="server" Text="Price Range:"></asp:Label>
                            </th>
                            <td>
                                <asp:Label ID="PriceRange" runat="server" Text=""></asp:Label>
                            </td>
                            <th>
                                <asp:Label ID="DefaultPriceLabel" runat="server" Text="Default:"></asp:Label>
                            </th>
                            <td>
                                <asp:Label ID="DefaultPrice" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <asp:Label ID="WeightRangeLabel" runat="server" Text="Weight Range:"></asp:Label>
                            </th>
                            <td>
                                <asp:Label ID="WeightRange" runat="server" Text=""></asp:Label>
                            </td>
                            <th>
                                <asp:Label ID="DefaultWeightLabel" runat="server" Text="Default:"></asp:Label>
                            </th>
                            <td>
                                <asp:Label ID="DefaultWeight" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <asp:Localize ID="ItemizedDisplayLabel" runat="server" Text="Invoice Style:"></asp:Localize>
                            </th>
                            <td>
                                <asp:LinkButton ID="ItemizedDisplay" runat="server" Text="Bundled"></asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                    <asp:HyperLink ID="SortComponents" runat="server" Text="Sort Components" NavigateUrl="SortComponents.aspx" SkinID="Button" EnableViewState="false" />
                </div>
                </div>
                <asp:Repeater ID="ComponentList" runat="server" OnItemCommand="ComponentList_ItemCommand" EnableViewState="false">
                    <ItemTemplate>
                        <div class="section componentList">
                            <div class="sectionHeader">
                                <h2><asp:Localize ID="ComponentName" runat="server" Text='<%#Eval("Name")%>'></asp:Localize>
                                &nbsp;(<asp:Localize ID="ComponentType" runat="server" Text='<%#FixInputTypeName(Eval("InputType").ToString())%>'></asp:Localize>)</h2>
                                <div class="options">
                                    <asp:HyperLink ID="EditComponent" runat="server" NavigateUrl='<%#string.Format("EditComponent.aspx?CategoryId={0}&ProductId={1}&KitComponentId={2}", _CategoryId, _ProductId, Eval("KitComponentId"))%>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" ToolTip="Edit" /></asp:HyperLink>
                                    <asp:ImageButton ID="DeleteComponent" runat="server" visible='<%#(int)Eval("ProductKitComponents.Count") < 2%>' OnClientClick='<%# Eval("Name", "return confirm(\"Are you sure you want to delete the component {0}?\");") %>' CommandArgument='<%#Eval("Id")%>' CommandName="Delete" SkinID="DeleteIcon" ToolTip="Delete" />
                                    <asp:HyperLink ID="DeleteSharedComponent" runat="server" Visible='<%#(int)Eval("ProductKitComponents.Count") > 1%>' NavigateUrl="<%#GetDeleteSharedComponentLink(Container.DataItem)%>"><asp:Image ID="Image1" runat="server" SkinID="DeleteIcon" AlternateText="Delete" ToolTip="Delete" /></asp:HyperLink>
                                </div>
                            </div>
                            <div class="content">
                                <asp:PlaceHolder id="SharedRow" runat="server" Visible='<%#(int)Eval("ProductKitComponents.Count") > 1%>'>
                                    <p><asp:Label ID="SharedLabel" runat="server" Text="This component is shared by more than one kit."></asp:Label>
                                    &nbsp;<asp:HyperLink ID="SharedDetails" runat="server" Text="details" NavigateUrl='<%#string.Format("ViewComponent.aspx?CategoryId={0}&ProductId={1}&KitComponentId={2}", _CategoryId, _ProductId, Eval("KitComponentId"))%>'></asp:HyperLink>
                                    &nbsp;<asp:LinkButton ID="BranchComponent" runat="server" Text="branch" CommandName="Branch" CommandArgument='<%#Eval("Id")%>'></asp:LinkButton></p>
                                </asp:PlaceHolder>
                                <asp:GridView ID="KitProductList" runat="server" DataSource='<%#Eval("KitProducts")%>' OnRowCommand="KitProductList_RowCommand" 
                                    AutoGenerateColumns="false" GridLines="None" ShowHeader="true" SkinID="PagedList" EnableViewState="true" Width="100%">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Item">
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemTemplate>
                                                <asp:HyperLink ID="NameLink" runat="Server" Text='<%#Server.HtmlEncode(Eval("DisplayName").ToString())%>' NavigateUrl='<%#GetEditKitProductLink(Container.DataItem)%>'></asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Qty">
                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                            <ItemTemplate>
                                                <asp:Label ID="Quantity" runat="Server" Text='<%#Eval("Quantity")%>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Price">
                                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                                            <ItemTemplate>
                                                <asp:Label ID="Price" runat="Server" Text='<%#((decimal)Eval("CalculatedPrice")).LSCurrencyFormat("lc")%>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Weight">
                                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                                            <ItemTemplate>
                                                <asp:Label ID="Weight" runat="Server" Text='<%# Eval("CalculatedWeight", "{0:0.##}")%>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Selected" >
                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                            <ItemTemplate>
                                                <asp:Label ID="IsSelected" runat="Server" Text="X" Visible='<%#((bool)Eval("IsSelected"))%>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                                            <ItemTemplate>
                                                <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%#GetEditKitProductLink(Container.DataItem)%>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" ToolTip="Edit" /></asp:HyperLink>
                                                <asp:ImageButton ID="DeleteButton" runat="server" SkinID="DeleteIcon" CommandName="DoDelete" CommandArgument='<%#Eval("KitProductId")%>' OnClientClick="javascript: return confirm('Are you sure you wish to remove this product from the kit?');" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <asp:HyperLink ID="AddProduct" runat="server" NavigateUrl='<%# string.Format("AddKitProducts.aspx?CategoryId={0}&ProductId={1}&KitComponentId={2}", AbleCommerce.Code.PageHelper.GetCategoryId(), _ProductId, Eval("KitComponentId"))%>' Text="Add Products" SkinID="AddButton"></asp:HyperLink>
                                <asp:HyperLink ID="SortProducts" runat="server" NavigateUrl='<%# string.Format("SortKitProducts.aspx?ProductId={0}&KitComponentId={1}", _ProductId, Eval("KitComponentId"))%>' Visible='<%# (((KitComponent)Container.DataItem).KitProducts.Count > 1) %>' Text="Sort Products" SkinID="Button"></asp:HyperLink>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:PlaceHolder>
            <asp:Panel ID="ItemizedDisplayDialog" runat="server" Style="display:none;width:550px" CssClass="modalPopup">
                <asp:Panel ID="ItemizedDisplayHeader" runat="server" CssClass="modalPopupHeader">
                    <asp:Localize ID="ItemizedDisplayCaption" runat="server" Text="Invoice Display Style"></asp:Localize>
                </asp:Panel>
                <div style="padding:10px;">
                    <p><asp:Localize ID="ItemizedDisplayHelpText" runat="server">
                        You can choose to show this kit as a single line item in the basket and invoice pages (bundle) or you can choose to itemize the contents.  Regardless of your choice, "included hidden" items are never displayed in itemized fashion.
                    </asp:Localize></p>
                    <asp:RadioButtonList ID="ItemizedDisplayOption" runat="server">
                        <asp:ListItem Text="Bundle" Value="0"></asp:ListItem>
                        <asp:ListItem Text="Itemized" Value="1"></asp:ListItem>
                    </asp:RadioButtonList>
                    <asp:Button ID="ItemizedDisplayOkButton" runat="server" Text="OK" OnClick="ItemizedDisplayOkButton_Click" />
                </div>
            </asp:Panel>
            <asp:Panel ID="AddComponentDialog" runat="server" Style="display:none;width:550px" CssClass="modalPopup" DefaultButton="AddComponentSaveButton">
                <asp:Panel ID="AddComponentDialogHeader" runat="server" CssClass="modalPopupHeader">
                    Add Kit Component
                </asp:Panel>
                <div style="padding-top:5px;">
                    <table class="inputForm" cellpadding="3">
                        <tr>
                            <td colspan="2">
                                A kit must contain at least one component which can contain one or more products.  If you have already defined components for other kits you can <asp:HyperLink ID="AttachLink" runat="server" Text="attach or copy" NavigateUrl="AttachComponent.aspx" EnableViewState="false"></asp:HyperLink> one of these instead.
                                <asp:ValidationSummary ID="AddComponentValidationSummary" runat="server" ValidationGroup="AddComponent" />
                            </td>
                        </tr>
                        <tr>   
                            <th>
                                <cb:ToolTipLabel ID="AddComponentNameLabel" runat="server" Text="Name:" CssClass="toolTip" ToolTip="Name of the component."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="AddComponentName" runat="server" Text="" Width="300px" MaxLength="255"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="AddComponentNameValidator" runat="server" Text="*" Display="Dynamic" ErrorMessage="Name is required." ControlToValidate="AddComponentName" ValidationGroup="AddComponent"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AddComponentInputTypeLabel" runat="server" Text="Input Type:" ToolTip="Determines the type of input control that will be used for the products in this component." AssociatedControlID="AddComponentInputTypeId"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:DropDownList ID="AddComponentInputTypeId" runat="server">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="AddComponentSaveButton" runat="server" Text="Next" SkinID="SaveButton" OnClick="AddComponentSaveButton_Click" ValidationGroup="AddComponent" Width="60px" />
                                <asp:Button ID="AddComponentCancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="AddComponentCancelButton_Click" CausesValidation="false" Width="60px" /><br />
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
            <asp:HiddenField ID="FakeAddComponentSaveButton" runat="server" EnableViewState="false" />
            <asp:HiddenField ID="FakeAddComponentCancelButton" runat="server" EnableViewState="false" />
            <ajaxToolkit:ModalPopupExtender ID="AddComponentPopup" runat="server" 
                TargetControlID="FakeAddComponentSaveButton"
                PopupControlID="AddComponentDialog" 
                BackgroundCssClass="modalBackground"                         
                CancelControlID="FakeAddComponentCancelButton" 
                DropShadow="true"
                PopupDragHandleControlID="AddComponentDialogHeader" />
            <ajaxToolkit:ModalPopupExtender ID="ItemizedDisplayPopUp" runat="server" 
                TargetControlID="ItemizedDisplay"
                PopupControlID="ItemizedDisplayDialog" 
                BackgroundCssClass="modalBackground"                         
                DropShadow="true"
                PopupDragHandleControlID="ItemizedDisplayDialogHeader" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>