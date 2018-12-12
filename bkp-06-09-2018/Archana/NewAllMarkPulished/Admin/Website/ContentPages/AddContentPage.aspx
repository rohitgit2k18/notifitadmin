<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Website.ContentPages.AddContentPage" Title="Add Web Page" CodeFile="AddContentPage.aspx.cs" %>
<%@ Register src="~/Admin/ConLib/CategoryTree.ascx" tagname="CategoryTree" tagprefix="uc" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript" language="javascript">
        function generateUrl() {
            var nameTextBox = document.getElementById('<%=Name.ClientID%>');
            var customUrlTextBox = document.getElementById('<%=CustomUrl.ClientID%>');
            name = nameTextBox.value;
            oldUrl = customUrlTextBox.value;
            if (oldUrl.length == 0) {
                newUrl = name.split(' ').join('-');
                if (newUrl != "") {
                    newUrl += ".aspx";
                    customUrlTextBox.value = newUrl;
                }
            }
        }
    </script>
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Add Web Page"></asp:Localize></h1>
            <div class="links">
                <asp:Button ID="FinishButton" runat="server" Text="Save and Edit" SkinID="SaveButton" OnClick="FinishButton_Click" />
                <asp:HyperLink ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="Default.aspx" />
            </div>
        </div>
    </div>
    <div class="content">
        <asp:ValidationSummary ID="ErrorSummary" runat="server" />
        <div class="sectionHeader">
            <h2>General</h2>
        </div>
        <table class="inputForm">
            <tr>
                <th>
                    <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Title:" ToolTip="The title of the page.">
                    </cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="Name" runat="server" Text="" Width="300" MaxLength="100" onblur="generateUrl();"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="NameValidator" runat="server" Text="*" Display="Dynamic"
                        ErrorMessage="Title is required." ControlToValidate="Name"></asp:RequiredFieldValidator>
                </td>
                    <th >
                    <cb:ToolTipLabel ID="CustomUrlLabel" runat="server" Text="URL:" ToolTip="You need to provide URL to access your webpage. The value provided should be a URL relative to the store directory. Absolute URLs are not supported. Examples: Sample/Page/Url.aspx or SamplePageUrl.aspx">
                    </cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="CustomUrl" runat="server" Width="300" MaxLength="150"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="CustomUrlRequired" runat="server" ControlToValidate="CustomUrl"
                        Text="*" ErrorMessage="Url is required." Display="Dynamic" />
                    <cb:CustomUrlValidator ID="CustomUrlValidator" runat="server" ControlToValidate="CustomUrl"
                        Text="*" FormatErrorMessage="The url has an invalid format." DuplicateErrorMessage="This url is already used, please choose a unique value."
                        Display="Dynamic"></cb:CustomUrlValidator>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="LocalThemeLabel" runat="server" Text="Theme:" AssociatedControlId="LocalTheme" ToolTip="Specifies the theme that will be used to display this item."></cb:ToolTipLabel>
                </th>
                <td valign="top">
                    <asp:DropDownList ID="LocalTheme" runat="server" AppendDataBoundItems="true" DataTextField="DisplayName" DataValueField="Name">
                        <asp:ListItem Text="Use store default" Value="" ></asp:ListItem>
                    </asp:DropDownList>
                </td>
                <th >
                    <cb:ToolTipLabel ID="DisplayPageLabel" runat="server" Text="Layout:" AssociatedControlID="LayoutList"
                        ToolTip="Specifies the script that will handle the display of this item."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:DropDownList ID="LayoutList" runat="server" DataSourceID="LayoutDS" DataTextField="DisplayName"
                        DataValueField="FilePath" AppendDataBoundItems="true" Width="300">
                        <asp:ListItem Text="Use store default" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:ObjectDataSource ID="LayoutDS" runat="server" SelectMethod="LoadAll" TypeName="CommerceBuilder.UI.LayoutDataSource">
                    </asp:ObjectDataSource>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="TitleLabel" runat="server" Text="Page Title:" CssClass="toolTip" ToolTip="Page title of the webpage. If not provided title will be used as page title."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="PageTitle" runat="server" Text="" Columns="40" MaxLength="100"></asp:TextBox>
                </td>
                <th>
                    <cb:ToolTipLabel ID="VisibilityLabel" runat="server" Text="Visibility:" AssociatedControlID="Visibility" ToolTip="Visibility setting indicates how this page is viewed. public pages can be viewed by everyone.  A page that is not public can only be viewed by admin users."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:DropDownList ID="Visibility" runat="server">
                        <asp:ListItem Value="0" Text="Public"></asp:ListItem>
                        <asp:ListItem Value="1" Text="Hidden"></asp:ListItem>
                        <asp:ListItem Value="2" Text="Private"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="PublishDateLabel" runat="server" Text="Publish Date:" CssClass="toolTip" ToolTip="The publish date."></cb:ToolTipLabel>
                </th>
                <td>
                    <uc:PickerAndCalendar ID="PublishDate" runat="server" />
                </td>
                <th>
                    <cb:ToolTipLabel ID="PublishedByLabel" runat="server" Text="Published By:" CssClass="toolTip" ToolTip="Name of the content publisher."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="PublishedBy" runat="server" Text="" Columns="40" MaxLength="150"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="MetaDescriptionLabel" runat="server" Text="Meta Description:" ToolTip="Enter a description for this page for the META tag.  Some search engines will use this as the summary for your page. You do not need to enter any HTML meta tags - only enter the content you want to set in them.">
                    </cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="MetaDescriptionValue" runat="server" Text="" TextMode="multiLine"
                        Rows="3" Columns="50" Width="300" MaxLength="300"></asp:TextBox><br />
                    <asp:Label ID="MetaDescriptionCharCount" runat="server" Text="300"></asp:Label>
                    <asp:Label ID="MetaDescriptionCharCountLabel" runat="server" Text="characters remaining"></asp:Label>
                </td>
                <th valign="top">
                    <cb:ToolTipLabel ID="MetaKeywordsLabel" runat="server" Text="Meta Keywords:" ToolTip="Enter the keywords that describe your page for the META tag.  Enter single words separated by a comma, with a maxium of 1000 characters. You do not need to enter any HTML meta tags - only enter the content you want to set in them.">
                    </cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="MetaKeywordsValue" runat="server" Text="" TextMode="multiLine" Rows="3"
                        Columns="50" Width="300" MaxLength="1000"></asp:TextBox><br />
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
        </table>
        <div class="sectionHeader">
            <h2>Content</h2>
        </div>
        <asp:ImageButton ID="HtmlButton" runat="server" SkinID="HtmlIcon" AlternateText="Edit HTML" />
        <cb:HtmlEditor ID="WebpageContent" runat="server" Width="100%" Height="200px"></cb:HtmlEditor>
        <div class="sectionHeader">
            <h2>Catalog Settings</h2>
        </div>
        <table class="inputForm">
            <tr>
                <td colspan="2">
                    <p class="text">Including a webpage in your product catalog is optional.  If desired, indicate the categories where this page will be included. You may also need to provide a thumbnail image and alt text if you are using a grid based category display.</p>
                </td>
            </tr>
            <tr>
                <th valign="top" width="100px">
                    <cb:ToolTipLabel ID="CategoryTreeLabel" runat="server" Text="Category:" AssociatedControlId="CategoryTree" ToolTip="Specifies the category or categories that will include this webpage."></cb:ToolTipLabel>
                </th>
                <td>
                    <uc:CategoryTree ID="CategoryTree" runat="server"></uc:CategoryTree>
                </td>
            </tr>
            <tr>
                <th >
                    <cb:ToolTipLabel ID="ThumbnailUrlLabel" runat="server" Text="Thumbnail:" AssociatedControlId="ThumbnailUrl" ToolTip="Specifies the thumbnail image that may be used with this item on some display pages."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="ThumbnailUrl" runat="server" MaxLength="250" width="250px"></asp:TextBox>&nbsp;
                    <asp:ImageButton ID="BrowseThumbnailUrl" runat="server" SkinID="FindIcon" AlternateText="Browse" />
                </td>
            </tr>
            <tr>
                <th >
                    <cb:ToolTipLabel ID="ThumbnailAltTextLabel" runat="server" Text="Alt Text:" AssociatedControlId="ThumbnailAltText" ToolTip="Specifies the alternate text that should be set on the thumbnail image.  Leave blank to use the item name."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="ThumbnailAltText" runat="server" MaxLength="250"></asp:TextBox>&nbsp;
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="SummaryLabel" runat="server" Text="Summary:" ToolTip="Enter a summary for this page that will be used on some catalog display pages."></cb:ToolTipLabel>
                </th>
                <td>
                    <cb:HtmlEditor ID="Summary" runat="server" Width="100%" Height="200px" ToolbarSet="Inline" MaxLength="1000" />
                </td>
            </tr>
        </table>
      <div class="links">
         <asp:Button ID="FinishButton2" runat="server" Text="Save and Edit" SkinID="SaveButton" OnClick="FinishButton_Click" />
         <asp:HyperLink ID="CancelButton2" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="Default.aspx" />
     </div>
    </div> 
</asp:Content>