<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Marketing.Feeds._GoogleFeed" Title="Google Feed" CodeFile="GoogleFeed.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Google Feed"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="marketing" />
        </div>
    </div>
    <asp:UpdatePanel ID="FeedInputPanel" runat="server">
        <ContentTemplate>
            <cb:Notification ID="FeedMessage" runat="server" Text="Google feed generation has been initiated." Visible="false" SkinID="GoodCondition"></cb:Notification>
            <div class="section">
                <div class="header">
                    <h2>Configuration</h2>
                </div>
                <div class="content">
                    <table class="inputForm">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="EnableFeedLabel" runat="server" Text="Enable Automatic Feed:" ToolTip="Use this to toggle automatic feed generation on or off.  If you use Google Feed the recommended setting is on." AssociatedControlID="EnableFeed"></cb:ToolTipLabel>
                            </th>
                            <td valign="top">
                                <asp:CheckBox ID="EnableFeed" runat="server" />
                            </td>
                        </tr>
                        <tr id="trTimeInterval" runat="server">
                            <th>
                                <cb:ToolTipLabel ID="TimeIntervalLabel" runat="server" Text="Time Interval:" ToolTip="Indicate how frequently the feed should be automatically generated."></cb:ToolTipLabel>
                            </th>
                            <td valign="top">
                                <asp:TextBox ID="TimeInterval" runat="server" Text="" Width="40px"></asp:TextBox>
                                <span>Minutes</span>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="ProductInclusionLabel" runat="server" Text="Product Inclusion:" ToolTip="Which products to Include in the feed?"></cb:ToolTipLabel>
                            </th>
                            <td valign="top">
                                <asp:RadioButton ID="MarkedProducts" runat="Server" GroupName="ProductInclusion" />
                                <asp:Label ID="Label4" runat="server" Text="Do not include products marked for feed exclusion"></asp:Label>
                                <br />
                                <asp:RadioButton ID="AllProducts" runat="Server" GroupName="ProductInclusion" />
                                <asp:Label ID="Label3" runat="server" Text="All Products (Ignore product feed setting)"></asp:Label>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="DefaultBrandLabel" runat="server" Text="Default Brand:" ToolTip="Specify the default brand, which will be used in feed, when product doesn't have a brand specified."></cb:ToolTipLabel>
                            </th>
                            <td valign="top">
                                <asp:TextBox ID="DefaultBrand" runat="server" Text="" Width="200px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="DefaultCategoryLabel" runat="server" Text="Default Category:" ToolTip="Specify the default Google category for your products, which will be used in feed, when product doesn't have a category specified."></cb:ToolTipLabel>
                            </th>
                            <td valign="top">
                                <asp:TextBox ID="DefaultCategory" runat="server" Text="" Width="200px"></asp:TextBox>
                                <asp:HyperLink ID="GoogleTaxonomy" runat="server" Text="product taxonomy" Target="_blank" NavigateUrl="http://support.google.com/merchants/bin/answer.py?hl=en&answer=1705911"></asp:HyperLink>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="BtnSaveSettings" runat="server" Text="Save Settings" SkinID="SaveButton" OnClick="BtnSaveSettings_Click" />
                                <cb:Notification ID="SavedMessage" runat="server" Text="Data updated at {0}." SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
                                <asp:ValidationSummary ID="AddThemeValidationSummary" runat="server" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="section">
        <div class="header">
            <h2>Setup and Feed Location</h2>
        </div>
        <div class="content">
            <p>The Google feed for your store will be available at the following URL-</p>
            <p><asp:HyperLink ID="FeedURL" runat="server" NavigateUrl="~/Feeds/GoogleFeedData.txt" Target="_blank"></asp:HyperLink></p>
            <p>To complete the setup you will need to have this feed URL set up in your <a href="http://www.google.com/merchants" target="_blank">Google Merchant Center</a> account.</p>
            
        </div>
    </div>
    <div class="section">
        <div class="header"><h2>Generating Feed for Product Variants</h2></div>              
        <div class="content" style="padding-top:10px;">
        <p>As per <a href="https://support.google.com/merchants/answer/188494" target="_blank">Google Feed Specifications</a>, variants are a group of identical products that only differ by the options &#8216;<b>color</b>&#8217;, &#8216;<b>material</b>&#8217;, &#8216;<b>pattern</b>&#8217;, or &#8216;<b>size</b>&#8217;. 
            Variant-level information is required only for products in the &quot;<b>Apparel & Accessories</b>&quot; category, and all related subcategories. By submitting variant products, you will help shoppers find what they are looking for more easily by either enabling them to navigate between the different product variations on a details page or helping them discover additional colors, sizes, patterns etc. for a given product.</p>
        <p>To submit variants for your &quot;<b>Apparel & Accessories</b>&quot; products in Google feed:</p>
        <ol>
            <li>Set the product's Google category to &quot;<b>Apparel &amp; Accessories</b>&quot; or a subcateogry.</li>
            <li>Mark the product to publish it as variants by checking the checkbox &quot;<b>Publish Feed as Variants</b>&quot; at product edit page.</li>
            <li>Create options with names &quot;<b>Color</b>&quot;, &quot;<b>Size</b>&quot;, &quot;<b>Material</b>&quot; or &quot;<b>Pattern</b>&quot; to match 
                the respective Google attributes as required.</li>
            <li>Google feed requires you to submit specific images corresponding to each of variant that differ in &#8216;color&#8217;, &#8216;pattern&#8217;, or &#8216;material&#8217;. 
            You can specify image url's from manage variants page.</li>
            <li>You can also specify other details like availability, price, weight, inventory details and <b>GTIN</b> for each variant from manage variants page.</li>
        </ol>
        <p>Please check the <a href="https://support.google.com/merchants/answer/188494" target="_blank">Google Feed Specifications</a> for more details.</p>
        </div>
    </div>
    <div class="section">
        <div class="header">
            <h2>Manual Feed Generation</h2>
        </div>
        <div class="content">
            <p>You can start the feed generation manually by clicking the button below.</p>
            <asp:Button ID="GenerateFeedButton" runat="server" Text="Generate Feed" onclick="GenerateFeedButton_Click" />
        </div>
    </div>
</asp:Content>