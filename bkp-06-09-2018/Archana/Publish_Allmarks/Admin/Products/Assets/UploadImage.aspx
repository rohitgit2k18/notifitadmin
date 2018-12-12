<%@ Page Language="C#" MasterPageFile="../Product.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.Assets.UploadImage" Title="Upload Image" EnableViewState="False" CodeFile="UploadImage.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<script type="text/javascript">
    var lastName = "";
    function setName()
    {
        var filePath = document.getElementById("<%= UploadedFile.ClientID %>").value;
        if (filePath.length > 0) {
	        var fileName;
	        var charIndex = filePath.lastIndexOf("\\");
	        if (charIndex < 0) {
		        charIndex = filePath.lastIndexOf("/");
		        if (charIndex < 0) {
			        fileName = filePath;
		        } else {
			        fileName = filePath.substring(charIndex+1);
		        }
	        } else {
		        fileName = filePath.substring(charIndex+1);
	        }
	        //SET DISPLAY NAME
	        var ctlName = document.getElementById("<%= BaseFileName.ClientID %>");
	        if ((ctlName.value.length == 0) || (ctlName.value == lastName)) {
	            fileName = fileName.replace(/ /g, "_");
    	        ctlName.value = fileName;
    	        lastName = fileName;
    	    }
        }
    }
</script>
<div class="pageHeader">
	<div class="caption">
		<h1><asp:Localize ID="Caption" runat="server" Text="Upload Image for {0}"></asp:Localize></h1>
	</div>
</div>
<div class="content">
    <table class="inputForm">
        <tr>
            <th nowrap>
                <asp:Label ID="ProductNameLabel" runat="server" Text="Product:"></asp:Label>
            </th>
            <td>
                <asp:Label ID="ProductName" runat="server"></asp:Label>
            </td>
        </tr>
        <tr id="trSku" runat="server">
            <th nowrap>
                <asp:Label ID="SkuLabel" runat="server" Text="Sku:"></asp:Label>
            </th>
            <td>
                <asp:Label ID="Sku" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <th nowrap>
                <asp:Label ID="ImagePreviewLabel" runat="server" Text="Current Image:" AssociatedControlID="ImagePreview"></asp:Label>                        
            </th>
            <td>
                <asp:Image ID="ImagePreview" runat="server" />
                <asp:Literal ID="ImagePreviewNoImage" runat="server" Text="No Image Specified" Visible="false"/>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <br />
                <asp:Localize ID="UploadHelpText" runat="server" Text="Upload your new photo for this product and select the options if you want to resize your main image and generate the thumbnail & icon images. For best results, your uploaded image should be at least {0}w X {0}h."></asp:Localize>
            </td>
        </tr>
        <tr>
            <th nowrap>
                <asp:Localize ID="ValidFilesLabel" runat="server" Text="Valid Files:" EnableViewState="false"></asp:Localize>
            </th>
            <td>
                <asp:Literal ID="ValidFiles" runat="server" EnableViewState="false"></asp:Literal>
                <asp:PlaceHolder ID="phValidFiles" runat="server"></asp:PlaceHolder>
            </td>
        </tr>
        <tr>
            <th nowrap>
                <asp:Label ID="UploadedFileLabel" runat="server" Text="New Image:" AssociatedControlID="UploadedFile"></asp:Label>
            </th>
            <td>
                <asp:FileUpload ID="UploadedFile" runat="server" CssClass="fileUpload" Size="50" OnBlur="setName()" />&nbsp;
                <asp:Localize ID="FileDataMaxSize" runat="server" Text="({0}KB max)" EnableViewState="false"></asp:Localize>
                <asp:RequiredFieldValidator ID="UploadedFileRequired" runat="server" ControlToValidate="UploadedFile"
                    Text="*" ErrorMessage="You must specify the photo to upload."></asp:RequiredFieldValidator>
                <asp:PlaceHolder ID="phInvalidFile" runat="server"></asp:PlaceHolder>
            </td>
        </tr>
        <tr>
            <th nowrap>
                <asp:Label ID="BaseFileNameLabel" runat="server" Text="Save as:"></asp:Label>
            </th>
            <td>
                <asp:TextBox ID="BaseFileName" runat="server" Width="200px"></asp:TextBox><span class="requiredField">*</span>
                <asp:RequiredFieldValidator ID="BaseFileNameValidator" runat="server" ControlToValidate="BaseFileName"
                    Text="*" ErrorMessage="You must enter the name to save the file as."></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="FileNameValidator" runat="server" ControlToValidate="BaseFileName"
                    ErrorMessage="Invalid save as name. A valid name can only contain Uppercase (A - Z), Lowercase (a - z), Numbers (0 - 9), and Symbols (underscore, minus). It may not contain path information." ValidationExpression="^[A-Za-z0-9_\- ]+(\.[A-Za-z0-9_]+)*$">*</asp:RegularExpressionValidator>
                <asp:PlaceHolder ID="phInvalidFileName" runat="server"></asp:PlaceHolder>
            </td>
        </tr>
        <tr>
            <th nowrap valign="top">
                <asp:Label ID="OptionsLabel" runat="server" Text="Options:"></asp:Label>
            </th>
            <td>
                <asp:CheckBox ID="GenerateThumbsCheck" runat="server" Text="Generate thumbnail & icon images" Checked="true" /><br />
                <asp:UpdatePanel ID="ResizeAjax" runat="server">
                    <ContentTemplate>
                        <asp:CheckBox ID="ResizeCheck" runat="server" Text="Re-size main image to standard {0}w X {0}h." Checked="true" AutoPostBack="true" /><br />
                        <asp:PlaceHolder ID="phQuality" runat="server">
                            <asp:Label ID="QualityLabel" runat="server" Text="Quality:" AssociatedControlID="Quality"></asp:Label>
                            <asp:TextBox ID="Quality" runat="server" MaxLength="3" Width="40px" Text="100"></asp:TextBox>%
                            <asp:RangeValidator ID="QualityValidator" runat="server" ControlToValidate="Quality"
                                Text="*" ErrorMessage="Quality must be a number between 1 and 100." 
                                MinimumValue="1" MaximumValue="100" Type="Integer"></asp:RangeValidator>
                            <asp:Localize ID="QualityHelpText" runat="server" Text="(applies to JPG only)"></asp:Localize>
                        </asp:PlaceHolder>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <br />
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <asp:Button ID="UploadButton" runat="server" Text="Upload" SkinID="SaveButton" OnClick="UploadButton_Click" />
                <asp:HyperLink ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="Images.aspx?ProductId="/>
            </td>
        </tr>
    </table>
</div>
</asp:Content>