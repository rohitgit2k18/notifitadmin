<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Languages.aspx.cs" Inherits="AbleCommerce.Admin.Localization.Languages" %>
<%@ Register Src="AddLanguageDialog.ascx" TagName="AddLanguageDialog" TagPrefix="uc1" %>
<%@ Register Src="EditLanguageDialog.ascx" TagName="EditLanguageDialog" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:UpdatePanel ID="LanguagesAjax" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <div class="pageHeader">
            <div class="caption">
            	<h1><asp:Localize ID="Caption" runat="server" Text="Languages"></asp:Localize></h1>
                <div class="links">
                    <asp:HyperLink ID="SettingsLink" runat="server" Text="Store" SkinID="Button" NavigateUrl="~/Admin/Store/StoreSettings.aspx"></asp:HyperLink>
                    <asp:HyperLink ID="CurrencyLink" runat="server" Text="Currency" SkinID="Button" NavigateUrl="~/Admin/Store/Currencies/Default.aspx"></asp:HyperLink>
                    <asp:HyperLink ID="MaintLink" runat="server" Text="Maintenance" SkinID="Button" NavigateUrl="~/Admin/Store/Maintenance.aspx"></asp:HyperLink>
                    <asp:HyperLink ID="ImageLink" runat="server" Text="Images" SkinID="Button" NavigateUrl="~/Admin/Store/Images.aspx"></asp:HyperLink>
                    <asp:HyperLink ID="TrackingLink" runat="server" Text="Tracking" SkinID="Button" NavigateUrl="~/Admin/Store/PageTracking/Default.aspx"></asp:HyperLink>
                    <asp:HyperLink ID="ReviewsLink" runat="server" Text="Reviews" SkinID="Button" NavigateUrl="~/Admin/Store/ProductReviewSettings.aspx"></asp:HyperLink>
                    <asp:HyperLink ID="OrderStatusLink" runat="server" Text="Order Status" SkinID="Button" NavigateUrl="~/Admin/Store/OrderStatuses/Default.aspx"></asp:HyperLink>
                </div>
            </div>
        </div>
        <table cellpadding="2" cellspacing="0" class="innerLayout">
            <tr>
                <td class="itemlist" style="width:70%" valign="top">                       
                    <asp:GridView ID="LanguagesGrid" runat="server" AutoGenerateColumns="False" DataSourceID="LanguagesDs" 
                        DataKeyNames="Id" SkinID="PagedList" Width="100%" OnRowCancelingEdit="LanguagesGrid_RowCancelingEdit" OnRowEditing="LanguagesGrid_RowEditing">
                        <Columns>
                            <asp:TemplateField HeaderText="Name" ItemStyle-HorizontalAlign="Left">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <asp:Label ID="Name" runat="server" Text='<%#Eval("Name")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Culture">
                                <ItemStyle HorizontalAlign="Center" Width="60" />
                                <ItemTemplate>
                                    <asp:Label ID="Culture" runat="server" Text='<%#Eval("Culture")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemStyle HorizontalAlign="Center" Width="60px" Wrap="false" />
                                <EditItemTemplate>
                                    <asp:ImageButton ID="CancelButton" runat="server" SkinID="CancelIcon" CommandName="Cancel" CausesValidation="false" AlternateText="Cancel"/>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:HyperLink ID="EditStrings" runat="server" NavigateUrl='<%#string.Format("~/Admin/Localization/Resources.aspx?LanguageId={0}", Eval("Id"))%>' Text="Edit Resources"></asp:HyperLink>
                                    <asp:ImageButton ID="EditButton" runat="server" SkinID="EditIcon" CommandName="Edit" AlternateText="Edit"/>
                                    <asp:ImageButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" SkinID="DeleteIcon" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="emptyData">
                                <asp:Label ID="EmptyText" runat="server" Text="There are no languages defined for your store."></asp:Label><br /><br />
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </td>
                <td valign="top">
                     <asp:UpdatePanel ID="ActiveLanguagePanel" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="section">
                                <asp:Panel ID="Panel1" runat="server">
                                    <div class="header">
                                        <h2><asp:Localize ID="ActiveLanguagCaption" runat="server" Text="Active Language" /></h2>
                                    </div>
                                    <div class="content">
                                        <table class="inputForm">
                                            <tr>
                                                <th>
                                                    <cb:ToolTipLabel ID="ActiveLanguageLabel" runat="server" Text="Select Active Language:" ToolTip="The active language for store, only one language can be active at one time."></cb:ToolTipLabel>
                                                </th>
                                                <td>
                                                    <asp:DropDownList ID="ActiveLanguage" runat="server" DataTextField="Name" DataValueField="Id" AutoPostBack="true" OnSelectedIndexChanged="ActiveLanguage_SelectedIndexChanged" AppendDataBoundItems="true">
                                                        <asp:ListItem Text="" Value=""></asp:ListItem>
                                                    </asp:DropDownList>
                                                 </td>
                                            </tr>
                                        </table>
                                    </div>
                                </asp:Panel>
                                 </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:UpdatePanel ID="AddEditAjax" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="section">
                                <asp:Panel ID="AddPanel" runat="server">
                                    <div class="header">
                                        <h2><asp:Localize ID="AddCaption" runat="server" Text="Add Language" /></h2>
                                    </div>
                                    <div class="content">
                                        <uc1:AddLanguageDialog ID="AddLanguageDialog1" runat="server"></uc1:AddLanguageDialog>
                                    </div>
                                </asp:Panel>
                                <asp:Panel ID="EditPanel" runat="server" Visible="false">
                                    <div class="header">
                                        <h2 ><asp:Localize ID="EditCaption" runat="server" Text="Edit {0}" /></h2>
                                    </div>
                                    <div class="content">
                                        <uc1:EditLanguageDialog ID="EditLanguageDialog1" runat="server"></uc1:EditLanguageDialog>
                                    </div>
                                </asp:Panel>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:ObjectDataSource ID="LanguagesDs" runat="server" OldValuesParameterFormatString="original_{0}"
    SelectMethod="LoadAll" TypeName="CommerceBuilder.Localization.LanguageDataSource" SelectCountMethod="CountAll" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Localization.Language" DeleteMethod="Delete" >
</asp:ObjectDataSource>
</asp:Content>