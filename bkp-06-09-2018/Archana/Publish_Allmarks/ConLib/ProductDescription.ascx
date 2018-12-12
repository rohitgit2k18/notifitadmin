<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.ProductDescription" CodeFile="ProductDescription.ascx.cs" %>
<%--
<conlib>
<summary>A control to display product descriptions.</summary>
<param name="DescriptionCaption" default="Description">Caption for description</param>
<param name="MoreDetailCaption" default="More Details">Caption for detailed description</param>
<param name="ShowCustomFields" default="True">If true custom fields will be shown</param>
</conlib>
--%>
<asp:UpdatePanel ID="DescriptionAjax" runat="server">
    <ContentTemplate>
	    <div class="widget productDescription">
            <div class="innerSection">
                <div class="header">
                    <h2>
                        <asp:Literal ID="phCaption" runat="server" Text="Description" EnableViewState="false"></asp:Literal>&nbsp;
                        <asp:LinkButton ID="More" runat="server" Text="more details" OnClick="More_Click" EnableViewState="false"></asp:LinkButton>
                        <asp:LinkButton ID="Less" runat="server" Text="description" OnClick="Less_Click" EnableViewState="false"></asp:LinkButton>
                    </h2>
                </div>
                <div class="content">
				    <div class="descriptionWrapper" itemprop="description">
                        <asp:Literal ID="phDescription" runat="server" EnableViewState="false"></asp:Literal>
                    </div>
                </div>
            </div>
	    </div>
    </ContentTemplate>
</asp:UpdatePanel>
