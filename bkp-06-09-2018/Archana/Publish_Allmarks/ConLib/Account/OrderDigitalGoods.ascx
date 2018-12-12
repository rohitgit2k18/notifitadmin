<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderDigitalGoods.ascx.cs" Inherits="AbleCommerce.ConLib.Account.OrderDigitalGoods" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays digital goods for an order</summary>
</conlib>
--%>
<asp:Panel ID="DigitalGoodsPanel" runat="server" CssClass="widget orderDigitalGoodsWidget" Visible="false">
    <div class="header">
        <h2><asp:Localize ID="DigitalGoodsCaption" runat="server" Text="Digital Goods"></asp:Localize></h2>
    </div>
    <div class="content">
        <cb:ExGridView ID="DigitalGoodsGrid" runat="server" AutoGenerateColumns="false" 
            OnRowDataBound="DigitalGoodsGrid_RowDataBound" Width="100%"
            SkinID="Itemlist">
            <Columns>
                <asp:TemplateField HeaderText="Name">
                    <HeaderStyle CssClass="digitalGood" />
                    <ItemStyle CssClass="digitalGood" />
                    <ItemTemplate>
                        <%#Eval("Name")%>
                        <asp:PlaceHolder ID="phAssets" runat="server" Visible="false">
                            <ul>
                                <li id="ReadMeItem" runat="server" visible="false">
                                    <a id="ReadMeLink" runat="server" href="#">Readme</a>
                                </li>
                                <li id="AgreementItem" runat="server" visible="false">
                                    <a id="AgreementLink" runat="server" href="#">License agreement</a>
                                </li>
                            </ul>
                        </asp:PlaceHolder> 
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Download">
                    <HeaderStyle CssClass="download" />
                    <ItemStyle CssClass="download" />
                    <ItemTemplate>
                        <asp:PlaceHolder ID="phDownloadIcon" runat="server" Visible='<%# (((DownloadStatus)Eval("DownloadStatus")) == DownloadStatus.Valid && DGFileExists(Eval("DigitalGood")))%>'>
                            <a href="<%#GetDownloadUrl(Container.DataItem)%>"><asp:Image ID="DI" runat="server" SkinID="DownloadIcon" AlternateText="Download" /></a>
                        </asp:PlaceHolder>
                        <asp:Literal ID="DownloadStatus" runat="server" Text='<%# Eval("DownloadStatus") %>' Visible='<%# ((DownloadStatus)Eval("DownloadStatus")) != DownloadStatus.Valid %>'></asp:Literal>
                        <asp:Literal ID="MissingDownloadText" runat="server" Text="unavailable" Visible='<%#( !DGFileExists(Eval("DigitalGood")) && ((DownloadStatus)Eval("DownloadStatus")) == DownloadStatus.Valid)%>'/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Remaining">
                    <HeaderStyle CssClass="remainingDownloads" />
                    <ItemStyle CssClass="remainingDownloads" />
                    <ItemTemplate>
                        <%#GetMaxDownloads(Container.DataItem)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderStyle CssClass="serialKey" />
                    <ItemStyle CssClass="serialKey" />
                    <ItemTemplate>
                        <asp:PlaceHolder ID="phSerialKey" runat="server"  Visible='<%#!string.IsNullOrEmpty(Eval("SerialKeyData").ToString())%>'>
                            <div class="keyPair">
                                <span class="label">Serial Key: </span>
                                <span class="value">
                                    <%#Eval("SerialKeyData")%>
                                    <asp:LinkButton runat="server" ID="SerialKeyLink" Text="view" OnClientClick="<%#GetPopUpScript(Container.DataItem)%>" Visible='<%#ShowSerialKeyLink(Container.DataItem)%>' CssClass="button linkButton"></asp:LinkButton>
                                </span>
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phMediaKey" runat="server"  Visible='<%#ShowMediakey(Container.DataItem)%>'>
                            <div class="keyPair">
                                <span class="label" title="This key will be required to open the download.">Media Key: </span>
                                <span class="value" title="This key will be required to open the download."><%#Eval("DigitalGood.MediaKey")%></span>
                            </div>
                        </asp:PlaceHolder>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </cb:ExGridView>
	</div>
</asp:Panel>