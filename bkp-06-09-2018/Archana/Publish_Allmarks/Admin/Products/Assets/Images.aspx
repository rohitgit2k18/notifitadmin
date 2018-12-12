<%@ Page Language="C#" MasterPageFile="../Product.master" Inherits="AbleCommerce.Admin.Products.Assets.Images" Title="Basic Images"  EnableViewState="false" CodeFile="Images.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="pageHeader">
	<div class="caption">
		<h1><asp:Localize ID="Caption" runat="server" Text="Images for {0}"></asp:Localize></h1>
        <div class="links">
            <asp:HyperLink ID="AdvancedButton" runat="server" Text="Advanced Settings" NavigateUrl="AdvancedImages.aspx?ProductId=" SkinID="Button" />
            <asp:HyperLink ID="AdditionalButton" runat="server" Text="Image Gallery" NavigateUrl="AdditionalImages.aspx?ProductId=" SkinID="Button" />
        </div>
	</div>
</div>
<div class="content">
    <asp:HyperLink ID="UploadImageButton" runat="server" Text="Upload Image" NavigateUrl="UploadImage.aspx?ProductId=" SkinID="AddButton" />
    <asp:HyperLink ID="AddExistingImageButton" runat="server" Text="Add Existing Image" NavigateUrl="AdvancedImages.aspx?ProductId=" SkinID="AddButton" />
    <p><asp:Localize ID="InstructionText" runat="server" Text="Upload an image with the automatic resize feature, or use Advanced Settings to edit individual images.  Create a gallery with additional images."></asp:Localize></p>
    <table class="inputForm">
        <tr>
            <th>
                <asp:Label ID="IconPreviewLabel" runat="server" Text="Icon:" AssociatedControlID="IconPreview"></asp:Label>
            </th>
            <td>
                <asp:Image ID="IconPreview" runat="server"/>
                <asp:Literal ID="IconPreviewNoImage" runat="server" Text="No Image Specified" Visible="false"/>
            </td>
        </tr>
        <tr>
            <th>
                <asp:Label ID="ThumbnailPreviewLabel" runat="server" Text="Thumbnail:" AssociatedControlID="ThumbnailPreview"></asp:Label>
            </th>
            <td>
                <asp:Image ID="ThumbnailPreview" runat="server" />
                <asp:Literal ID="ThumbnailPreviewNoImage" runat="server" Text="No Image Specified" Visible="false"/>
            </td>
        </tr>
        <tr>
            <th>
                <asp:Label ID="ImagePreviewLabel" runat="server" Text="Image:" AssociatedControlID="ImagePreview"></asp:Label>
            </th>
            <td>
                <asp:Image ID="ImagePreview" runat="server" />
                <asp:Literal ID="ImagePreviewNoImage" runat="server" Text="No Image Specified" Visible="false"/>
            </td>
        </tr>
    </table>
</div>
</asp:Content>