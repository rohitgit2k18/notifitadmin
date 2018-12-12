<%@ Page Language="C#" MasterPageFile="../Product.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.Assets.AdditionalImages" Title="Image Gallery" CodeFile="AdditionalImages.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
	    <div class="caption">
		    <h1><asp:Localize ID="Caption" runat="server" Text="Image Gallery for {0}"></asp:Localize></h1>
	    </div>
    </div>
    <div class="content">
        <asp:PlaceHolder ID="NoImagesPanel" runat="server">
            <p><asp:Localize ID="NoImagesMessage" runat="server" Text="There are no additional images attached to this product.  Upload images to create an image gallery."></asp:Localize></p>
            <asp:Button ID="UploadButton2" runat="server" Text="Upload Image" SkinID="AddButton" OnClick="UploadButton_Click" />
            <asp:HyperLink ID="CancelButton2" runat="server" Text="Cancel" NavigateUrl="Images.aspx?ProductId=" SkinID="CancelButton" EnableViewState="false" />
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="ImagesPanel" runat="server">
            <table class="inputForm">
                <asp:Repeater ID="AdditionalImagesRepeater" runat="server" OnItemCommand="AdditionalImagesRepeater_ItemCommand">
                    <ItemTemplate>
                        <tr>
                            <td valign="top">
                                <asp:Label ID="ImageUrlLabel" runat="server" Text="Additional Image:" AssociatedControlId="ImageUrlLabel" CssClass="fieldHeader"></asp:Label>
                                <asp:Button ID="DeleteImageButton" runat="server" CommandArgument='<%#Eval("ProductImageId")%>' CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure you want to remove this image from the list?')" />
                            </td>
                            <td>
            	                <div style="overflow:auto; max-height:300px; max-width:750px; padding:0px;" class="contentSection">
                                    <asp:Image ID="ImageUrl" runat="server" ImageUrl='<%# GetImageUrl(Container.DataItem) %>' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="ToolTipLabel1" runat="server" Text="Moniker:" AssociatedControlId="Moniker" ToolTip="Moniker is a tag or label that can be used to identify this image." />
                            </th>
                            <td>
                                <asp:Label ID="Moniker" runat="server" Text='<%#Eval("Moniker")%>'></asp:Label>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:Button ID="UploadButton" runat="server" Text="Upload Image" SkinID="AddButton" OnClick="UploadButton_Click" />
                        <asp:HyperLink ID="CancelButton" runat="server" Text="Cancel" NavigateUrl="Images.aspx?ProductId=" SkinID="CancelButton" EnableViewState="false" />
                    </td>
                </tr>
            </table>
        </asp:PlaceHolder>
    </div>
</asp:Content>