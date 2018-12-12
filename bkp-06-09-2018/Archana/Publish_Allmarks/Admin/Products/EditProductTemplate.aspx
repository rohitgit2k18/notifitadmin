<%@ Page Language="C#" MasterPageFile="~/Admin/Products/Product.master" Inherits="AbleCommerce.Admin.Products.EditProductTemplate" Title="Edit Product Template" EnableViewState="false" CodeFile="EditProductTemplate.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript">
        function saveSelections() {
            var result = true;
            var newTemplateList = getOptions($get('<%=SelectedTemplates.ClientID %>'));
            $.ajax({
                type: "POST",
                url: "EditProductTemplate.aspx/ValidateTemplates?ProductId=<%=ProductId %>&Templates=" + newTemplateList,
                data: {},
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (msg) {
                    if ($(msg).length) {
                        var templates = "";
                        $.each(msg, function () {
                            $.each(this, function (k, v) {
                                templates += "'" + v + "', ";
                            });
                        });

                        if (templates != "") {
                            result = confirm("You are removing template(s) " + templates.slice(0, -2) + " from this product. If you proceed, any values you have assigned to the fields associated with these templates will also be cleared. Are you sure you want to save these changes? ");
                        }
                    }
                }
            });

            if (result) {
                changeTemplateList();
            }

            return result;
        }
    </script>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Templates for {0}"></asp:Localize></h1>
                </div>
            </div>
            <div class="content">
                <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" OnClientClick="this.value = 'Saving...'; this.enabled= false;" />
                <p>You can assign templates to a product to display, or collect, custom data for the merchant and/or customer.  Templates can be shared between products.</p>
                <asp:UpdatePanel ID="TemplateAjax" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table class="inputForm compact">
                            <tr>
                                <th>
                                    <asp:Label ID="TemplateListLabel" runat="server" Text="Assigned Templates:"></asp:Label>
                                </th>
                                <td>
                                    <asp:Label ID="TemplateList" runat="server" Text=""></asp:Label>
                                    <asp:HiddenField ID="TemplateListChanged" runat="server" />
                                    <asp:HiddenField ID="HiddenSelectedTemplates" runat="server" />
                                    <asp:LinkButton SkinID="Button" ID="ChangeTemplateListButton" runat="server" Text="Change" />
                                </td>
                            </tr>
                        </table>
                        <asp:Panel ID="ChangeTemplateListDialog" runat="server" Style="display: none" CssClass="modalPopup" Width="600px">
                            <asp:Panel ID="ChangeTemplateListDialogHeader" runat="server" CssClass="modalPopupHeader">
                                Change Assigned Templates
                            </asp:Panel>
                            <div align="center">
                                <br />
                                Hold CTRL to select multiple Templates.  Double click to move a Template to the other list.
                                <br /><br />
                                <table cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td valign="top" width="42%">
                                            <b>Available Templates</b><br />
                                            <asp:ListBox ID="AvailableTemplates" runat="server" Rows="12" SelectionMode="multiple" Width="220"></asp:ListBox>
                                        </td>
                                        <td valign="middle" width="6%">
                                            <asp:Button ID="SelectAllTemplates" runat="server" Text=" >> " /><br />
                                            <asp:Button ID="SelectTemplate" runat="server" Text=" > " /><br />
                                            <asp:Button ID="UnselectTemplate" runat="server" Text=" < " /><br />
                                            <asp:Button ID="UnselectAllTemplates" runat="server" Text=" << " /><br />
                                        </td>
                                        <td valign="top" width="42%">
                                            <b>Selected Templates</b><br />
                                            <asp:ListBox ID="SelectedTemplates" runat="server" Rows="12" SelectionMode="multiple" Width="220"></asp:ListBox>
                                        </td>
                                    </tr>
                                </table><br />
                                <asp:Button ID="ChangeTemplateListOKButton" runat="server" Text="OK" SkinID="SaveButton" OnClientClick="return saveSelections();" OnClick="SaveButton_Click" />
                                <asp:Button ID="ChangeTemplateListCancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="ChangeTemplateListCancelButton_Click" />
                                <asp:HiddenField ID="HiddenTarget" runat="server" />
                                <br /><br />
                            </div>
                        </asp:Panel>
                        <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender" runat="server" 
                            TargetControlID="ChangeTemplateListButton"
                            PopupControlID="ChangeTemplateListDialog" 
                            BackgroundCssClass="modalBackground" 
                            CancelControlID="HiddenTarget" 
                            DropShadow="true"
                            PopupDragHandleControlID="ChangeTemplateListDialogHeader" />
                        <asp:PlaceHolder ID="phCustomFields" runat="server"></asp:PlaceHolder>
                        <cb:Notification ID="SavedMessage" runat="server" Text="Template fields updated at {0:t}." SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>