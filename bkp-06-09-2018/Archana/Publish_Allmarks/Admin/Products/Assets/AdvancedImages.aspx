<%@ Page Language="C#" MasterPageFile="../Product.master" Inherits="AbleCommerce.Admin.Products.Assets.AdvancedImages" Title="Advanced Image Options"  EnableViewState="false" CodeFile="AdvancedImages.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Advanced Image Settings for {0}"></asp:Localize></h1>
        </div>
    </div>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="content">
                <cb:Notification ID="SavedMessage" runat="server" Text="Images saved at {0:t}" SkinID="GoodCondition" EnableViewState="False" Visible="false"></cb:Notification>
                <table cellspacing="0" class="inputForm" width="100%">
                    <tr class="sectionHeader">
                        <td colspan="2">
                            <asp:Localize ID="BasicImagesCaption" runat="server" Text="Standard Images"></asp:Localize>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="IconImageUrlLabel" runat="server" Text="Icon:" AssociatedControlId="IconImageUrl" ToolTip="Specifies the icon image that may be associated with this product, such as in the mini basket."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="IconImageUrl" runat="server" width="400px" MaxLength="250"></asp:TextBox>
                            <asp:ImageButton ID="BrowseIconUrl" runat="server" SkinID="FindIcon" AlternateText="Browse" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="IconImageAltTextLabel" runat="server" Text="Alternate Text:" AssociatedControlId="IconImageAltText" ToolTip="Specifies the alternate text that should be set on the icon image."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="IconImageAltText" runat="server" width="400px" MaxLength="100"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ThumbnailImageUrlLabel" runat="server" Text="Thumbnail:" AssociatedControlId="ThumbnailImageUrl" ToolTip="Specifies the thumbnail image that may be used with this item on some display pages."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="ThumbnailImageUrl" runat="server" width="400px" MaxLength="250"></asp:TextBox>
                            <asp:ImageButton ID="BrowseThumbnailUrl" runat="server" SkinID="FindIcon" AlternateText="Browse" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ThumbnailImageAltTextLabel" runat="server" Text="Alternate Text:" AssociatedControlId="ThumbnailImageAltText" ToolTip="Specifies the alternate text that should be set on the thumbnail image.  Leave blank to use the item name."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="ThumbnailImageAltText" runat="server" width="400px" MaxLength="100"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="StandardImageUrlLabel" runat="server" Text="Standard Image:" AssociatedControlId="StandardImageUrl" ToolTip="Specifies the standard sized image that may be used with this item on some display pages, such as the product detail page."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="StandardImageUrl" runat="server" width="400px" MaxLength="250"></asp:TextBox>
                            <asp:ImageButton ID="BrowseStandardUrl" runat="server" SkinID="FindIcon" AlternateText="Browse" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="StandardImageAltTextLabel" runat="server" Text="Alternate Text:" AssociatedControlId="StandardImageAltText" ToolTip="Specifies the alternate text that should be set on the standard image.  Leave blank to use the item name."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="StandardImageAltText" runat="server" width="400px" MaxLength="100"></asp:TextBox>
                        </td>
                    </tr>
                    <asp:Repeater ID="AdditionalImagesRepeater" runat="server" OnItemDataBound="AdditionalImagesRepeater_ItemDataBound" OnItemCommand="AdditionalImagesRepeater_ItemCommand">
                        <HeaderTemplate>
                            <tr class="sectionHeader">
                                <td colspan="2">
                                    <asp:Localize ID="AdditionalImagesCaption" runat="server" Text="Gallery Images"></asp:Localize>
                                </td>
                            </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <th>
                                    <cb:ToolTipLabel ID="ImageUrlLabel" runat="server" Text="Additional Image:" AssociatedControlId="ImageUrlLabel" ToolTip="Specifies the URL of an additional image text that should be associated with the product."></cb:ToolTipLabel>
                                </th>
                                <td>
                                    <asp:TextBox ID="ImageUrl" runat="server" width="400px" MaxLength="250" Text='<%# Eval("ImageUrl") %>'></asp:TextBox>
                                    <asp:ImageButton ID="Browse" runat="server" SkinID="FindIcon" AlternateText="Browse" />
                                    &nbsp;<asp:ImageButton ID="Delete" runat="server" CommandArgument='<%#Eval("ProductImageId")%>' CommandName="Delete" SkinID="DeleteIcon" AlternateText="Delete" ToolTip="Delete" OnClientClick="return confirm('Are you sure you want to remove this image from the list?')" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <cb:ToolTipLabel ID="AltTextLabel" runat="server" Text="Alternate Text:" AssociatedControlId="AltText" ToolTip="Specifies the alternate text that is associated with the additional image."></cb:ToolTipLabel>
                                </th>
                                <td>
                                    <asp:TextBox ID="AltText" runat="server" width="400px" MaxLength="100" Text='<%# Eval("ImageAltText") %>'></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <cb:ToolTipLabel ID="MonikerLabel" runat="server" Text="Moniker:" ToolTip="Moniker is a tag or label that can be used to identify this image." />
                                </th>
                                <td>
                                    <asp:TextBox ID="Moniker" runat="server" width="400px" MaxLength="255" Text='<%# Eval("Moniker") %>'></asp:TextBox>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="AddImageButton" runat="server" Text="Add Gallery Image" SkinID="AddButton" OnClick="AddImageButton_Click" />
                            <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click"></asp:Button>
                            <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
                            <asp:HyperLink ID="CancelButton" runat="server" Text="Cancel" NavigateUrl="Images.aspx?ProductId=" SkinID="CancelButton" EnableViewState="false" />
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>