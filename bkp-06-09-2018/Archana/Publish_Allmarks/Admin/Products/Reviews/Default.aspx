<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Products.Reviews._Default" Title="Manage Reviews"  EnableViewState="false" CodeFile="Default.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
	    <div class="caption">
		    <h1>
                <asp:Localize ID="Caption" runat="server" Text="Product Reviews"></asp:Localize>
                <asp:Localize ID="ProductCaption" runat="server" Text=" for {0}"></asp:Localize>
            </h1>
            <div class="links">
                <cb:NavigationLink ID="ReviewSettingsLink" runat="server" Text="Configure Reviews..." SkinID="Button" NavigateUrl="~/Admin/Store/ProductReviewSettings.aspx" EnableViewState="false"></cb:NavigationLink>
            </div>
	    </div>
    </div>
    <asp:UpdatePanel ID="ReviewAjax" runat="server">
        <ContentTemplate>
            <div class="searchPanel">
                <table class="inputForm compact">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ShowApprovedLabel" runat="server" Text="Approval Status:" AssociatedControlId="ShowApproved" ToolTip="Indicate whether the result should include reviews that are approved, unapproved or both." />
                        </th>
                        <td>
                            <asp:DropDownList ID="ShowApproved" runat="server">
                                <asp:ListItem Value="Any" Text="Any"></asp:ListItem>
                                <asp:ListItem Value="True" Text="Approved"></asp:ListItem>
                                <asp:ListItem Value="False" Text="Unapproved" Selected="true"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Button ID="SearchButton" runat="server" Text="Search" />
                            <asp:HyperLink ID="ResetSearchButton" runat="server" Text="Reset" SkinID="CancelButton" NavigateUrl="Default.aspx"></asp:HyperLink>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:Panel ID="ReviewActionPanel" runat="server">
                    <table class="inputForm compact">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="ReviewActionLabel" runat="server" Text="Select one or more Reviews:" AssociatedControlId="ReviewAction" ToolTip="Select an action to take with the selected reviews." />
                            </th>
                            <td>
                                <asp:DropDownList ID="ReviewAction" runat="server">
                                    <asp:ListItem Text=""></asp:ListItem>
                                    <asp:ListItem Text="Approve"></asp:ListItem>
                                    <asp:ListItem Text="Disapprove"></asp:ListItem>
                                    <asp:ListItem Text="Delete"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:Button ID="GoButton" runat="server" Text="Update" OnClick="GoButton_Click" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            <div class="content">
                <cb:AbleGridView ID="ReviewGrid" runat="server" AllowPaging="true" AllowSorting="true" PageSize="20"
                    AutoGenerateColumns="False" DataKeyNames="ProductReviewId" DataSourceID="ProductReviewDs" 
                    ShowFooter="False" DefaultSortExpression="ReviewDate DESC" SkinID="PagedList" Width="100%" OnDataBound="ReviewGrid_DataBound">
                    <Columns>
                        <asp:TemplateField HeaderText="Select">
                            <HeaderStyle Width="40px" />
                            <HeaderTemplate>
                                <input type="checkbox" onclick="toggleSelected(this)" />
                            </HeaderTemplate>
                            <ItemStyle HorizontalAlign="center" VerticalAlign="Top" Width="40px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="Selected" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Approved" SortExpression="IsApproved">
                            <HeaderStyle Wrap="False" />
                            <ItemStyle HorizontalAlign="center" VerticalAlign="Top" />
                            <ItemTemplate>
                                <asp:Label ID="Approved" runat="server" Text='<%# ((bool)Eval("IsApproved") ? "X" : "") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date" SortExpression="ReviewDate">
                            <HeaderStyle HorizontalAlign="Left" Wrap="false" />
                            <ItemStyle VerticalAlign="Top" />
                            <ItemTemplate>
                                <asp:Label ID="ReviewDate" runat="server" Text='<%# Eval("ReviewDate", "{0:d}") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Product" SortExpression="P.Name">
                            <HeaderStyle HorizontalAlign="Left" Wrap="false" />
                            <ItemStyle VerticalAlign="Top" />
                            <ItemTemplate>
                                <asp:HyperLink ID="Product" runat="server" NavigateUrl='<%# Eval("ProductId", "../EditProduct.aspx?ProductId={0}") %>' Text='<%#Eval("Product.Name")%>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reviewer" SortExpression="RP.DisplayName">
                            <HeaderStyle HorizontalAlign="Left" Wrap="false" />
                            <ItemStyle VerticalAlign="Top" />
                            <ItemTemplate>
                                <asp:Label ID="ReviewerEmail" runat="server" Text='<%# Eval("ReviewerProfile.Email") %>'></asp:Label>
                                <asp:Label ID="ReviewerEmailVerified" runat="server" Visible='<%# Eval("ReviewerProfile.EmailVerified") %>' Text=" (verified)"></asp:Label><br />
                                <asp:Label ID="ReviewerName" runat="server" Text='<%# Eval("ReviewerProfile.DisplayName", "{0}") %>'></asp:Label>
                                <asp:Label ID="ReviewerLocation" runat="server" Visible='<%# !string.IsNullOrEmpty(Eval("ReviewerProfile.Location").ToString()) %>' Text='<%# Eval("ReviewerProfile.Location", " from {0}") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Rating" SortExpression="Rating">
                            <HeaderStyle HorizontalAlign="Center" Wrap="false" />
                            <ItemStyle VerticalAlign="Top" />
                            <ItemTemplate>
                                <%# string.Format("{0:00}/10", Eval("Rating")) %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Review" SortExpression="ReviewTitle">
                            <HeaderStyle HorizontalAlign="Left" Wrap="false" />
                            <ItemStyle VerticalAlign="Top" width="300px" />
                            <ItemTemplate>
                                <div style="max-height:300px;overflow:auto;"><b><asp:Label ID="ReviewTitle" runat="server" Text='<%# Eval("ReviewTitle") %>'></asp:Label></b><br />
                                <asp:Label ID="ReviewBody" runat="server" Text='<%#"<pre class=Reviews>" +  Eval("ReviewBody")+ "</pre>" %>'></asp:Label></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="center" VerticalAlign="Top" width="60px" />
                            <ItemTemplate>
                                <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%# Eval("ProductReviewId", "EditReview.aspx?ReviewId={0}") %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit"></asp:Image></asp:HyperLink>
                                <asp:ImageButton ID="DeleteButton" runat="server" SkinID="DeleteIcon" AlternateText="Delete" CommandName="Delete" OnClientClick="return confirm('Are you sure you want to delete this review?')" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyDataText" runat="server" Text="No matching reviews found."></asp:Label>
                    </EmptyDataTemplate>
                </cb:AbleGridView>
                <asp:HiddenField ID="HiddenProductId" runat="server" />
                <asp:ObjectDataSource ID="ProductReviewDs" runat="server" OldValuesParameterFormatString="original_{0}"
                    SelectMethod="Search" TypeName="CommerceBuilder.Products.ProductReviewDataSource" 
                    SelectCountMethod="SearchCount" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Products.ProductReview" 
                    DeleteMethod="Delete" EnablePaging="true">
                    <SelectParameters>
                        <asp:ControlParameter Name="productId" ControlID="HiddenProductId" PropertyName="Value" Type="Int32" />
                        <asp:ControlParameter Name="approved" ControlID="ShowApproved" PropertyName="SelectedValue" Type="Object" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript">
        function ShowHoverPanel(event, Id) { OrderHoverLookupPanel.startCallback(event, "OrderId=" + Id.toString(), null, OnError); }
        function HideHoverPanel() { OrderHoverLookupPanel.hide(); }
        function OnError(e) { alert("***Error:\r\n\r\n" + e.message); }
        function toggleCheckBoxState(id, checkState) { var cb = document.getElementById(id); if (cb != null) cb.checked = checkState; }
        function toggleSelected(checkState) { if (CheckBoxIDs != null) { for (var i = 0; i < CheckBoxIDs.length; i++) toggleCheckBoxState(CheckBoxIDs[i], checkState.checked); } }
    </script>
</asp:Content>