<%@ Page Title="Product Images" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Images.aspx.cs" Inherits="AbleCommerce.Admin._Store.Images" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>            
            <div class="pageHeader">
    	        <div class="caption">
    		        <h1><asp:Localize ID="Caption" runat="server" Text="Image Settings"></asp:Localize></h1>
			<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/store" />
    	        </div>
            </div>
            <div class="content aboveGrid">
                <asp:Button Id="SaveButton" runat="server" Text="Save Settings" SkinID="SaveButton" OnClick="SaveButton_Click" />
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="Image settings saved at {0:t}<br /><br />" SkinID="GoodCondition" EnableViewState="False" Visible="false"></cb:Notification>
            </div>
            <div class="grid_6 alpha">
                <div class="leftColumn">
			        <div class="section">
                        <div class="header">
                            <h2 class="defaultimagesize"><asp:Localize ID="ImageSizeCaption" runat="server" Text="Default Image Sizes"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p><asp:Literal ID="ImageSizeHelpText" runat="server" Text="When you upload an image, you have the option to automatically generate the icon, thumbnail, and standard image sizes.  Use the fields below to specify the sizes to use for these images in your store.  All image sizes are specified in number of pixels."></asp:Literal></p>
		                    <table class="inputForm">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="IconSizeLabel" runat="server" Text="Icon Image Size:" ToolTip="This image size applies to products only.  The tiny image is used for display of a product icon in the mini basket."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:Label ID="IconWidthLabel" runat="server" AssociatedControlID="IconWidth" Text="width: " SkinID="xFieldHeader"></asp:Label>
                                        <asp:TextBox ID="IconWidth" runat="server" Width="40px" MaxLength="2"></asp:TextBox>
                                        &nbsp;
                                        <asp:Label ID="IconHeightLabel" runat="server" AssociatedControlID="IconHeight" Text="height: " SkinID="xFieldHeader"></asp:Label>
                                        <asp:TextBox ID="IconHeight" runat="server" Width="40px" MaxLength="2"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="ThumbnailSizeLabel" runat="server" Text="Thumbnail Image Size:" ToolTip="This image size applies to all catalog items.  The thumbnail image is generally shown with an item in directory or catalog listing pages."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:Label ID="ThumbnailWidthLabel" runat="server" AssociatedControlID="ThumbnailWidth" Text="width: " SkinID="xFieldHeader"></asp:Label>
                                        <asp:TextBox ID="ThumbnailWidth" runat="server" Width="40px" MaxLength="3"></asp:TextBox>
                                        &nbsp;
                                        <asp:Label ID="ThumbnailHeightLabel" runat="server" AssociatedControlID="ThumbnailHeight" Text="height: " SkinID="xFieldHeader"></asp:Label>
                                        <asp:TextBox ID="ThumbnailHeight" runat="server" Width="40px" MaxLength="3"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="StandardSizeLabel" runat="server" Text="Standard Image Size:" ToolTip="This image size applies to product items only.  The standard image is generally shown on the product detail page, although some other display elements may make use of this image."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:Label ID="StandardWidthLabel" runat="server" AssociatedControlID="StandardWidth" Text="width: " SkinID="xFieldHeader"></asp:Label>
                                        <asp:TextBox ID="StandardWidth" runat="server" Width="40px" MaxLength="4"></asp:TextBox>
                                        &nbsp;
                                        <asp:Label ID="StandardHeightLabel" runat="server" AssociatedControlID="StandardHeight" Text="height: " SkinID="xFieldHeader"></asp:Label>
                                        <asp:TextBox ID="StandardHeight" runat="server" Width="40px" MaxLength="4"></asp:TextBox>
                                    </td>
                                </tr>
		                    </table>
		                </div>
		            </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
			        <div class="section">
                        <div class="header">
                            <h2><asp:Localize ID="SkuImageCaption" runat="server" Text="Product Image Lookup by SKU"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p><asp:Literal ID="SkuImageHelpText" runat="server" Text="When this option is enabled, product image URLs are automatically calculated using the SKU if no image is otherwise specified.  The expected format is ?_i.jpg for icons, ?_t.jpg for thumbnails, and ?.jpg for standard images."></asp:Literal></p>
		                    <table class="inputForm">
                                <tr>
                                    <th width="50%">
                                        <cb:ToolTipLabel ID="ImageSkuLookupEnabledLabel" runat="server" Text="Enable Image Lookup:" AssociatedControlID="ImageSkuLookupEnabled" ToolTip="Check to enable image lookup from product sku."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:CheckBox ID="ImageSkuLookupEnabled" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear"></div>
			<div class="section">
                <div class="header">
                    <h2><asp:Localize ID="OptionThumbnailCaption" runat="server" Text="Defaults for Option Swatches"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:Literal ID="OptionThumbnailHelpText" runat="server" Text="If you define swatches for your product options, you can set default height, width, and columns that will be used when displaying the images.  The default values can be overridden at the attribute level."></asp:Literal>
		            <table cellspacing="0" class="inputForm">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="DefaultThumbnailSizeLabel" runat="server" Text="Default Size:" ToolTip="The default image size for option swatches."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:Label ID="OptionThumbnailWidthLabel" runat="server" AssociatedControlID="OptionThumbnailWidth" Text="width: "></asp:Label>
                                <asp:TextBox ID="OptionThumbnailWidth" runat="server" Width="40px" MaxLength="3"></asp:TextBox>
                                &nbsp;
                                <asp:Label ID="OptionThumbnailHeightLabel" runat="server" AssociatedControlID="OptionThumbnailHeight" Text="height: "></asp:Label>
                                <asp:TextBox ID="OptionThumbnailHeight" runat="server" Width="40px" MaxLength="3"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="OptionThumbnailColumnsLabel" runat="server" Text="Default Columns:" ToolTip="This default number of thumbnail images to display per row." AssociatedControlID="OptionThumbnailColumns"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="OptionThumbnailColumns" runat="server" Width="40px" MaxLength="2"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>