<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Website.ContentPages.ProductPages._Default" Title="Manage Product Pages" CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:UpdatePanel ID="ContentAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Manage Product Pages"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="website" />
                </div>
            </div>
            <div class="content">
                <asp:Button ID="NewPageButton" runat="server" Text="Add Product Page" OnClick="NewPageButton_Click" SkinID="AddButton" />
                <asp:Button ID="ChangeDefaultButton" runat="server" Text="Change Default" OnClick="ChangeDefaultButton_Click"  />
                <p><asp:Localize ID="DefaultThemesHelpText" runat="server" Text="You can set the store level default product page. For items that do not have a specific product display page selected, the default product display page will be used."></asp:Localize></p>
                <cb:AbleGridView ID="WebpagesGrid" runat="server" 
                    AutoGenerateColumns="False" 
                    DataKeyNames="WebpageId"
                    DataSourceID="WebpagesDs"
                    AllowPaging="true" 
                    AllowSorting="True"
                    PageSize="20" 
                    TotalMatchedFormatString=" {0} pages matched" 
                    SkinID="PagedList" 
                    Width="100%"
                    PagerSettings-Position="Top"
                    OnRowCommand="WebpagesGrid_RowCommand"
                    >
                    <Columns>
						<asp:TemplateField HeaderText="Default">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" Width="50px" />
                            <ItemTemplate>
							<asp:Image ID="DefaultLabel" runat="server" SkinID="AcceptIcon" Visible='<%#IsDefault(Container.DataItem) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                            <HeaderStyle HorizontalAlign="Left" Width="180" />
                            <ItemTemplate>
                                <a href="<%# string.Format("EditProductPage.aspx?WebpageId={0}", Eval("WebpageId")) %>"><%# Eval("Name") %></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Description" SortExpression="Summary">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%# Eval("Summary") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Layout">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                            <ItemTemplate>
                                <%#GetLayout(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Products">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" Width="50px" />
                            <ItemTemplate>
                                <a href="ProductPageUsage.aspx?WebpageId=<%#Eval("Id")%>">
                                <%#GetProductCount(Container.DataItem)%>
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Theme">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                            <ItemTemplate>
                                <%#GetTheme(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemStyle HorizontalAlign="Right" Width="100px" Wrap="false" />
                            <ItemTemplate>
                                <asp:ImageButton ID="CopyButton" runat="server" SkinID="CopyIcon" CommandName="DoCopy"
                                    CommandArgument='<%#Eval("WebpageId")%>' AlternateText="Copy" />
                                <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%# string.Format("EditProductPage.aspx?WebpageId={0}", Eval("WebpageId")) %>'>
                                    <asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" /></asp:HyperLink>
                                <asp:ImageButton ID="DeleteButton" runat="server" SkinID="DeleteIcon" CommandName="DoDelete"
                                    CommandArgument='<%#Eval("WebpageId")%>' OnClientClick='return confirm("Are you sure you want to delete")' AlternateText="Delete" Visible='<%#!IsDefault(Container.DataItem)%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        There are no product pages to list.
                    </EmptyDataTemplate>
                </cb:AbleGridView>     
                <asp:ObjectDataSource ID="WebpagesDs" runat="server" 
                    SelectMethod="LoadForWebpageType"
                    SelectCountMethod="CountForWebpageType"
                    TypeName="CommerceBuilder.Catalog.WebpageDataSource" 
                    SortParameterName="sortExpression" onselecting="WebpagesDs_Selecting">
                    <SelectParameters>
                        <asp:Parameter Name="webpageType" Type="Object"/>
                    </SelectParameters>
                </asp:ObjectDataSource>

                <asp:HiddenField ID="HDNTarget" runat="server" />
                <ajaxToolkit:ModalPopupExtender ID="ChangeDefaultPopup" runat="server" TargetControlID="HDNTarget"
                    PopupControlID="ChangeDefaultDialog" BackgroundCssClass="modalBackground" CancelControlID="ChangeDefaultsCancel"
                    DropShadow="true" PopupDragHandleControlID="ChangeDefaultHeader" />
        <asp:Panel ID="ChangeDefaultDialog" runat="server" Style="display: none; width: 650px"
            CssClass="modalPopup">
            <asp:Panel ID="ChangeDefaultHeader" runat="server" CssClass="modalPopupHeader">
                <h2>
                    <asp:Localize ID="DefaultThemesCaption" runat="server" Text="Change Default Product Display page"></asp:Localize></h2>
            </asp:Panel>
            <div class="content">
                <table class="inputForm">
                    <tr>
                        <th>
                            <asp:Label ID="ProductsLabel" runat="server" Text="Product Display Page:" AssociatedControlID="ProductsDefault" />
                        </th>
                        <td>
                            <asp:DropDownList ID="ProductsDefault" runat="server" DataTextField="Name"
                                DataValueField="Id">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <asp:Button ID="UpdateDefaultsButton" runat="server" Text="Save" OnClick="UpdateDefaultsButton_Click"  />
                            <asp:Button ID="ChangeDefaultsCancel" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>