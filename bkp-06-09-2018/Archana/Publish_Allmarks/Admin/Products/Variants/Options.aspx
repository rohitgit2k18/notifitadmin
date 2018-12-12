<%@ Page Language="C#" MasterPageFile="~/Admin/Products/Product.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.Variants.Options" Title="Manage Options" CodeFile="Options.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Options for '{0}'"></asp:Localize></h1>
        </div>
    </div>
    <asp:UpdatePanel ID="OptionsPanel" runat="server">
        <ContentTemplate>
            <div class="content">
            <asp:HyperLink ID="VariantLink" runat="server" SkinID="Button" Text="Manage Variants" NavigateUrl="Variants.aspx"></asp:HyperLink>
                <p><asp:Localize ID="InstructionText" runat="server" Text="A product variant is a unique combination of options chosen when a customer purchases this product.  Use the controls below to define the options this product and the available choices for each.  Once you have defined all of the options and choices for a product, you can manage variants if you need to specify additional properties for each unique combination."></asp:Localize></p>
                <cb:SortedGridView ID="OptionsGrid" runat="server" AutoGenerateColumns="False"
                    ShowFooter="False" OnDataBound="OptionsGrid_DataBound" OnRowCommand="OptionsGrid_RowCommand" 
                    SkinID="PagedList" Width="100%" EnableViewState="false">
                    <Columns>
                        <asp:TemplateField HeaderText="Order" ItemStyle-Width="56px">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:ImageButton ID="UpButton" runat="server" SkinID="UpIcon" CommandName="MoveUp" CommandArgument='<%#Eval("OptionId")%>' CausesValidation="false" />
                                <asp:ImageButton ID="DownButton" runat="server" SkinID="DownIcon" CommandName="MoveDown" CommandArgument='<%#Eval("OptionId")%>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Option">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>                                
                                <%# Eval("Name") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Header">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>                                
                                <%# Eval("HeaderText") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Choices">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>                                
                                <%# GetOptionNames(Container.DataItem) %> 
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Thumbnails">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:CheckBox ID="ShowThumbnails" runat="server" Enabled="false" Checked='<%#Eval("ShowThumbnails")%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False">
                            <ItemStyle VerticalAlign="Top" HorizontalAlign="Center" Wrap="false" Width="56px" />
                            <ItemTemplate>
                                <a href="<%#GetEditOptionUrl(Container.DataItem)%>"><asp:Image ID="EditOptionIcon" runat="server" SkinId="EditIcon" ToolTip="Edit Option" ></asp:Image></a>
                                <a href="<%#GetEditChoicesUrl(Container.DataItem)%>"><asp:Image ID="EditOptionChoiceIcon" runat="server" SkinId="OptionsIcon" ToolTip="Edit Choices" ></asp:Image></a>
                                <asp:ImageButton ID="DeleteButton" runat="server" ToolTip="Delete Option" SkinID="DeleteIcon" CommandName="DoDelete" CommandArgument='<%#Eval("OptionId")%>' OnClientClick="javascript:return confirmDel()" CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </cb:SortedGridView>
            </div>
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="AddOptionCaption" runat="server" Text="Add Option"></asp:Localize></h2>
                </div>
                <div class="content">
                    <p><asp:Localize ID="AddOptionHelpText" runat="server" Text="Enter the name of the new option and the names of the available choices.  Separate choice names with a comma.  You can always change the choices later, but you must provide at least one choice name to add the option."></asp:Localize></p>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                    <table cellspacing="0" class="inputForm compact">
                        <tr>
                            <th valign="top">
                                <asp:Label ID="AddOptionNameLabel" runat="server" Text="Option:"></asp:Label>
                            </th>
                            <td>
                                <asp:TextBox ID="AddOptionName" runat="server" MaxLength="50"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="NameRequired" runat="server" ErrorMessage="Attribute name is required." Text="*" Display="Dynamic" ControlToValidate="AddOptionName"></asp:RequiredFieldValidator>
                                <br />
                                <asp:Localize ID="NameHelpText" runat="server" SkinID="HelpText" Text="(e.g. Color)"></asp:Localize>
                            </td>
                            <th valign="top">
                                <asp:Label ID="AddOptionChoicesLabel" runat="server" Text="Choices:"></asp:Label>
                            </th>
                            <td>
                                <asp:TextBox ID="AddOptionChoices" runat="server" Columns="40"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="OptionsRequired" runat="server" ErrorMessage="At least one choice must be specified." Text="*" Display="Dynamic" ControlToValidate="AddOptionChoices"></asp:RequiredFieldValidator>
                                <asp:Button ID="AddButton" runat="server" Text="Add" SkinID="AddButton" OnClick="AddButton_Click" OnClientClick="return confirmAdd();" />
                                <br />
                                <asp:Localize ID="OptionsHelpText" runat="server" SkinID="HelpText" Text="(e.g. Red, Blue, Green)"></asp:Localize>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>            
            <div class="section" id="phGoogleFeedHelp" runat="server">
              <div class="header"><h2>Google Feed Options</h2></div>              
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
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>