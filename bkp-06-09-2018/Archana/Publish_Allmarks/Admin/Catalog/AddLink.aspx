<%@ Page Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Catalog.AddLink" MasterPageFile="~/Admin/Admin.master" Title="Add Link" CodeFile="AddLink.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
    	    <h1><asp:Localize ID="Caption" runat="server" Text="Add Link to {0}"></asp:Localize></h1>
            <div class="links">
                <asp:Button ID="FinishButton" runat="server" Text="Finish" SkinID="SaveButton"  OnClick="FinishButton_Click" />
			    <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="False" OnClick="CancelButton_Click" />
            </div>
        </div>
    </div>
    <div class="content">
	    <asp:ValidationSummary ID="ErrorSummary" runat="server" />
        <table class="inputForm">
            <tr>
                <th>
                    <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" AssociatedControlId="Name" ToolTip="Name of the item."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="Name" runat="server" Text="" MaxLength="100" width="300px"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="NameRequiredValidator" runat="server" Text="*" Display="Dynamic" ErrorMessage="Name is required." ControlToValidate="Name"></asp:RequiredFieldValidator>
                </td>
                <th>
                    <cb:ToolTipLabel ID="VisibilityLabel" runat="server" Text="Visibility:" AssociatedControlID="Visibility" ToolTip="Public items are accessible and display in navigation and search results.  Hidden items are accessible only by direct link, and do not appear in navigation or search results.  Private items may not be accessed from the retail store."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:DropDownList ID="Visibility" runat="server" width="300px">
                        <asp:ListItem Value="0" Text="Public"></asp:ListItem>
                        <asp:ListItem Value="1" Text="Hidden"></asp:ListItem>
                        <asp:ListItem Value="2" Text="Private"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="TargetUrlLabel" runat="server" Text="Link Url:" AssociatedControlID="TargetUrl" ToolTip="The url that is associated with this link."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="TargetUrl" runat="server" Text="" MaxLength="250" width="300px"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="TargetUrlRequiredValidator" runat="server" Text="*" Display="Dynamic" ErrorMessage="Link URL is required." ControlToValidate="TargetUrl"></asp:RequiredFieldValidator>
                </td>
                <th>
                    <cb:ToolTipLabel ID="TargetLabel" runat="server" Text="TargetWindow:" AssociatedControlID="TargetWindow" ToolTip="The target window for the link when it is opened."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:DropDownList ID="TargetWindow" runat="server" width="300px">
                        <asp:ListItem Value="" Text="Unspecified"></asp:ListItem>
                        <asp:ListItem Value="_self" Text="Current Frame (_self)"></asp:ListItem>
                        <asp:ListItem Value="_blank" Text="New Window (_blank)"></asp:ListItem>
                        <asp:ListItem Value="_top" Text="Top Window (_top)"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="ThumbnailUrlLabel" runat="server" Text="Thumbnail:" AssociatedControlId="ThumbnailUrl" ToolTip="Specifies the thumbnail image that may be used with this item on some display pages."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="ThumbnailUrl" runat="server" MaxLength="250" width="250px"></asp:TextBox>&nbsp;
                    <asp:ImageButton ID="BrowseThumbnailUrl" runat="server" SkinID="FindIcon" AlternateText="Browse" />
                </td>
                <th>
                    <cb:ToolTipLabel ID="ThumbnailAltTextLabel" runat="server" Text="Alt Text:" AssociatedControlId="ThumbnailAltText" ToolTip="Specifies the alternate text that should be set on the thumbnail image.  Leave blank to use the item name."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="ThumbnailAltText" runat="server" MaxLength="250"></asp:TextBox>&nbsp;
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="SummaryLabel" runat="server" Text="Summary:" AssociatedControlId="Summary" ToolTip="Description of the item that may be shown on some display pages."></cb:ToolTipLabel>
                </th>
                <td colspan="3">
                    <asp:TextBox ID="Summary" runat="server" Text="" TextMode="multiLine" Rows="5" MaxLength="1000" Width="90%"></asp:TextBox><br />
                    <asp:Label ID="SummaryCharCount" runat="server" Text="1000"></asp:Label>
                    <asp:Label ID="SummaryCharCountLabel" runat="server" Text="characters remaining"></asp:Label>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="DescriptionLabel" runat="server" Text="Description:" ToolTip="This is used by some display pages to show a detailed description or HTML content."></cb:ToolTipLabel><br />
                    <asp:ImageButton ID="LinkDescriptionHtml" runat="server" SkinID="HtmlIcon" />
                </th>
                <td colspan="3">
                    <cb:HtmlEditor ID="Description" runat="server" Width="100%" Height="200px" ToolbarSet="Inline" MaxLength="1000" />
                </td>
            </tr>
            <tr>
                <th valign="top" width="118px">
                    <cb:ToolTipLabel ID="MetaDescriptionLabel" runat="server" Text="Meta Description:" ToolTip="Enter the meta description for webpage."></cb:ToolTipLabel>
                </th>
                <td colspan="3">
                    <asp:TextBox ID="MetaDescriptionValue" runat="server" Text="" TextMode="multiLine" Rows="5" Width="100%" MaxLength="300"></asp:TextBox><br />
                    <asp:Label ID="MetaDescriptionCharCount" runat="server" Text="300"></asp:Label>
                    <asp:Label ID="MetaDescriptionCharCountLabel" runat="server" Text="characters remaining"></asp:Label>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="MetaKeywordsLabel" runat="server" Text="Meta Keywords:" ToolTip="Enter the meta keywords for webpage."></cb:ToolTipLabel>
                </th>
                <td colspan="3">
                    <asp:TextBox ID="MetaKeywordsValue" runat="server" Text="" TextMode="multiLine" Rows="5" Width="100%" MaxLength="1000"></asp:TextBox><br />
                    <asp:Label ID="MetaKeywordsCharCount" runat="server" Text="1000"></asp:Label>
                    <asp:Label ID="MetaKeywordsCharCountLabel" runat="server" Text="characters remaining"></asp:Label>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="HtmlHeadLabel" runat="server" Text="HTML Head:" ToolTip="Use this field for entring your custom data for HTML HEAD portion."></cb:ToolTipLabel>
                </th>
                <td colspan="3">
                    <asp:TextBox ID="HtmlHead" runat="server" Text="" TextMode="multiLine" Rows="5" Width="100%"></asp:TextBox><br />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="DisplayPageLabel" runat="server" Text="Display Page:" AssociatedControlId="DisplayPage" ToolTip="Specifies the script that will handle the display of this item."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:UpdatePanel ID="DisplayPageAjax" runat="server" UpdateMode="always">
                        <ContentTemplate>
                            <asp:DropDownList ID="DisplayPage" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DisplayPage_SelectedIndexChanged" width="300px">
                                <asp:ListItem Text="None (Use Direct Link)" Value=""></asp:ListItem>
                            </asp:DropDownList><br /><br />
                            <asp:Label ID="DisplayPageDescription" runat="Server" Text=""></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <th valign="top">
                    <cb:ToolTipLabel ID="LocalThemeLabel" runat="server" Text="Theme:" AssociatedControlId="LocalTheme" ToolTip="Specifies the theme that will be used to display this item.  This is only applicable if a display page is used.  For direct links, this value is ignored."></cb:ToolTipLabel>
                </th>
                <td valign="top">
                    <asp:DropDownList ID="LocalTheme" runat="server" AppendDataBoundItems="true" DataTextField="DisplayName" DataValueField="Name" width="300px">
                        <asp:ListItem Text="Use store default" Value=""></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
        </table>
        <br />
        <div class="links">
            <asp:Button ID="FinishButton2" runat="server" Text="Finish"  OnClick="FinishButton_Click" />
		    <asp:Button ID="CancelButton2" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="False" OnClick="CancelButton_Click" />
        </div>
    </div>
</asp:Content>