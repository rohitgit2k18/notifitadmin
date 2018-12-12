<%@ Control Language="C#" Inherits="AbleCommerce.ConLib.CommunicationPreferencesSection" CodeFile="CommunicationPreferencesSection.ascx.cs" %>
<%--
<conlib>
<summary>A control to display communication preferences, i.e. subscription options to email lists etc.</summary>
</conlib>
--%>
<asp:UpdatePanel ID="EmailUpdatePanel" runat="server" UpdateMode="conditional">
    <ContentTemplate>		
        <asp:Panel ID="EmailListPanel" runat="server" CssClass="widget communicationPreferences">
			<div class="innerSection">
				<div class="pageHeader">
					<h1 class="preference"><asp:Localize ID="EmailListCaption" runat="server" Text="Communication Preferences"></asp:Localize></h1>
				</div>
				<div class="content">
					<asp:DataList ID="dlEmailLists" runat="server" DataKeyField="EmailListId">
						<ItemTemplate>
							<asp:CheckBox ID="Selected" runat="server" Checked='<%#IsInList(Container.DataItem)%>' />
							<asp:Label ID="Name" runat="server" Text='<%#Eval("Name")%>' CssClass="fieldHeader"></asp:Label><br />
							<asp:Label ID="Description" runat="server" Text='<%#Eval("Description")%>'></asp:Label>
						</ItemTemplate>
					</asp:DataList><br />
					<asp:Label ID="UpdatedMessage" runat="server" Text="Your communication preferences have been updated.<br /><br />" Visible="false" CssClass="goodCondition"></asp:Label>
					<asp:LinkButton ID="UpdateButton" runat="server" Text="Update Communication Preferences" CssClass="button linkButton" OnClick="UpdateButton_Click" />
				</div>
			</div>
        </asp:Panel>		
    </ContentTemplate>
</asp:UpdatePanel>
