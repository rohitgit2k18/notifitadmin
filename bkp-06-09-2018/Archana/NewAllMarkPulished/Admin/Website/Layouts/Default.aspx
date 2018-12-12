<%@ Page Title="Manage Layouts" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="AbleCommerce.Admin.Website.Layouts.Default" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Manage Layouts"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="website" />
        </div>
    </div>
    <div class="content">
        <asp:HyperLink ID="AddButton" runat="server" Text="Add Layout" SkinID="AddButton" NavigateUrl="~/Admin/Website/Layouts/AddLayout.aspx"></asp:HyperLink>
        <asp:Button ID="ChangeDefaultButton" runat="server" Text="Change Default" />
        <p><asp:Localize ID="DefaultThemesHelpText" runat="server" Text="You can set the default layout for each of Webpages, Categories and Products. For items that do not have a specific layout set, the default layout will be used."></asp:Localize></p>
        <cb:AbleGridView ID="LayoutsGrid" runat="server" DataSourceID="LayoutsDS"
            AutoGenerateColumns="False" 
            AllowSorting="true"
            AllowPaging="true"            
            TotalMatchedFormatString=" {0} layouts matched"
            SkinID="PagedList" PagerSettings-Position="TopAndBottom" DefaultSortDirection="Ascending"
            DefaultSortExpression="" FirstButtonSkinID="FirstIcon" LastButtonSkinID="LastIcon"
            NextButtonSkinID="NextIcon" PageNumberCssClass="pageNumber" PageNumberSkinID="PageNumber"
            PagerMode="Custom" PageSizeCssClass="pageSize" PageSizeOptions="Show All:0|5:5|10:10|20:20|50:50|100:100"
            PreviousButtonSkinID="PreviousIcon" ShowWhenEmpty="False"            
            OnRowCommand="LayoutsGrid_RowCommand"
            Width="100%">
            <Columns>
                <asp:TemplateField HeaderText="Default">
                    <ItemStyle HorizontalAlign="Center" Width="100" />
                    <ItemTemplate>
                        <%#GetDefaults(Container.DataItem) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Name" >
                    <HeaderStyle HorizontalAlign="Left" Width="150" />
                    <ItemTemplate>
                        <asp:HyperLink ID="NameLink" runat="server" Text='<%#Eval("DisplayName")%>' NavigateUrl='<%#string.Format("EditLayout.aspx?name={0}", Eval("FilePath")) %>' Visible='<%#Eval("IsGeneratedLayout")%>'></asp:HyperLink>
                        <asp:Label ID="NameLable" runat="server" Text='<%#Eval("DisplayName")%>' Visible='<%#!((bool)Eval("IsGeneratedLayout"))%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Description">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <%#Eval("Description")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action">
                    <ItemStyle HorizontalAlign="Right" Width="100" />
                    <ItemTemplate>
                        <asp:HyperLink ID="EditLink" runat="server" ToolTip='<%#Eval("DisplayName")%>' NavigateUrl='<%#string.Format("EditLayout.aspx?name={0}", Eval("FilePath")) %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" Visible='<%#Eval("IsGeneratedLayout")%>' /></asp:HyperLink>
                        <asp:ImageButton ID="DeleteButton" runat="server" ToolTip="Delete" CommandName="Do_Delete" CommandArgument='<%#Eval("FilePath")%>' SkinID="DeleteIcon" OnClientClick='<%# Eval("DisplayName", "return confirm(\"Are you sure you want to delete {0}?\")") %>'></asp:ImageButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </cb:AbleGridView>
        <asp:ObjectDataSource ID="LayoutsDS" runat="server" SelectMethod="LoadAll" TypeName="CommerceBuilder.UI.LayoutDataSource">
       </asp:ObjectDataSource>
        <ajaxToolkit:ModalPopupExtender ID="ChangeDefaultPopup" runat="server" TargetControlID="ChangeDefaultButton"
                    PopupControlID="ChangeDefaultDialog" BackgroundCssClass="modalBackground" CancelControlID="ChangeDefaultsCancel"
                    DropShadow="true" PopupDragHandleControlID="ChangeDefaultHeader" />
        <asp:Panel ID="ChangeDefaultDialog" runat="server" Style="display: none; width: 650px"
            CssClass="modalPopup">
            <asp:Panel ID="ChangeDefaultHeader" runat="server" CssClass="modalPopupHeader">
                <h2>
                    <asp:Localize ID="DefaultThemesCaption" runat="server" Text="Change Default"></asp:Localize></h2>
            </asp:Panel>
            <div class="content">
                <table class="inputForm">
                    <tr>
                        <th>
                            <asp:Label ID="WebpagesLabel" runat="server" Text="Webpages:" AssociatedControlID="WebpagesDefault" />
                        </th>
                        <td>
                            <asp:DropDownList ID="WebpagesDefault" runat="server" DataTextField="DisplayName"
                                DataValueField="FilePath">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="CategoriesLabel" runat="server" Text="Categories:" AssociatedControlID="CategoriesDefault" />
                        </th>
                        <td>
                            <asp:DropDownList ID="CategoriesDefault" runat="server" DataTextField="DisplayName"
                                DataValueField="FilePath">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="ProductsLabel" runat="server" Text="Products:" AssociatedControlID="ProductsDefault" />
                        </th>
                        <td>
                            <asp:DropDownList ID="ProductsDefault" runat="server" DataTextField="DisplayName"
                                DataValueField="FilePath">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <asp:Button ID="UpdateDefaultsButton" runat="server" Text="Save" OnClick="UpdateDefaultsButton_Click" />
                            <asp:Button ID="ChangeDefaultsCancel" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
    </div>
</asp:Content>