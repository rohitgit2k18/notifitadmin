<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderDigitalGoods.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Account.OrderDigitalGoods" %>
<%--
<UserControls>
<summary>Displays digital goods information for an order.</summary>
</UserControls>
--%>
<asp:Panel ID="DigitalGoodsPanel" runat="server" CssClass="widget orderDigitalGoodsWidget" Visible="false">
    <div class="header">
        <h2><asp:Localize ID="DigitalGoodsCaption" runat="server" Text="Digital Goods"></asp:Localize></h2>
    </div>
    <div class="content">
        <asp:Repeater ID="DigitalGoodsGrid" runat="server" OnItemDataBound="DigitalGoodsGrid_ItemDataBound">
            <ItemTemplate>
                <div class="digitalGood <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                    <div class="inputForm">
                        <div class="inlineField">
                            <span class="fieldHeader">Name:</span>
                            <span class="fieldValue">
                                <%#Eval("Name")%>
                                <asp:PlaceHolder ID="phAssets" runat="server" Visible="false">
                                    <div id="ReadMeItem" runat="server" visible="false">
                                        <a id="ReadMeLink" runat="server" href="#">Readme</a>
                                    </div>
                                    <div id="AgreementItem" runat="server" visible="false">
                                        <a id="AgreementLink" runat="server" href="#">License agreement</a>
                                    </div>
                                </asp:PlaceHolder> 
                            </span>
                        </div>
                        <div class="inlineField">
                            <span class="fieldHeader">Download:</span>
                            <span class="fieldValue">
                                <asp:PlaceHolder ID="phDownloadIcon" runat="server" Visible='<%# (((DownloadStatus)Eval("DownloadStatus")) == DownloadStatus.Valid && DGFileExists(Eval("DigitalGood")))%>'>
                                    <a href="<%#GetDownloadUrl(Container.DataItem)%>"><asp:Image ID="DI" runat="server" SkinID="DownloadIcon" AlternateText="Download" /></a>
                                </asp:PlaceHolder>
                                <asp:Literal ID="DownloadStatus" runat="server" Text='<%# Eval("DownloadStatus") %>' Visible='<%# ((DownloadStatus)Eval("DownloadStatus")) != DownloadStatus.Valid %>'></asp:Literal>
                                <asp:Literal ID="MissingDownloadText" runat="server" Text="unavailable" Visible='<%#( !DGFileExists(Eval("DigitalGood")) && ((DownloadStatus)Eval("DownloadStatus")) == DownloadStatus.Valid)%>'/>
                            </span>
                        </div>
                        <div class="inlineField">
                            <span class="fieldHeader">Remaining:</span>
                            <span class="fieldValue">
                                <%#GetMaxDownloads(Container.DataItem)%>
                            </span>
                        </div>
                        
                        <asp:PlaceHolder ID="phSerialKey" runat="server"  Visible='<%#!string.IsNullOrEmpty(Eval("SerialKeyData").ToString())%>'>
                            <div class="inlineField">
                                <span class="fieldHeader">Serial Key: </span>
                                <span class="fieldValue">
                                    <%#Eval("SerialKeyData")%>
                                    <asp:LinkButton runat="server" ID="SerialKeyLink" Text="view" OnClientClick="<%#GetPopUpScript(Container.DataItem)%>" Visible='<%#ShowSerialKeyLink(Container.DataItem)%>' CssClass="button linkButton"></asp:LinkButton>
                                </span>
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phMediaKey" runat="server"  Visible='<%#ShowMediakey(Container.DataItem)%>'>
                            <div class="inlineField">
                                <span class="fieldHeader" title="This key will be required to open the download.">Media Key: </span>
                                <span class="fieldValue" title="This key will be required to open the download."><%#Eval("DigitalGood.MediaKey")%></span>
                            </div>
                        </asp:PlaceHolder>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
	</div>
</asp:Panel>