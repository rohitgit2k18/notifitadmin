<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._AustraliaPost.Register" Title="AustraliaPost Activation" CodeFile="Register.aspx.cs" EnableViewState="false" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
	<div class="pageHeader">
		<div class="caption">
			<h1><asp:Localize ID="Caption" runat="server" Text="Australia Post Activation"></asp:Localize></h1>
		</div>
	</div>
    <div class="grid_3">
        <div class="content" style="text-align:center">
            <asp:Image ID="Logo" runat="server" AlternateText="Australia Post Logo" />
        </div>
    </div>
    <div class="grid_9">
        <div class="content">
            <p>With Australia Post, customers can get shipping rate estimates based on their shipping addresses and order weights.</p>
            <p><b>Australia Post Terms of Use require that the following notice be included in checkout terms and conditions of your store.</b></p>
		    <blockquote>
            <asp:Localize ID="ConditionText" runat="server" Text="{0} accepts responsibility for any loss of, damage to, late delivery or non-delivery of goods ordered from our web site. To the maximum extent permitted by law, you agree to release our carriers from any liability relating to loss of, damage to, late delivery or non-delivery of any goods you order from this web site and to assign all rights to claim compensation or insurance against our carriers to us and expressly and irrevocably do so by submitting your order."></asp:Localize>
		    </blockquote>
		    <p>When you click Next this text will be added to your checkout terms and conditions if it is not already present.</p>
            <asp:Button ID="RegisterButton" runat="server" Text="Next" OnClick="RegisterButton_Click" />
		    <asp:Button ID="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" CausesValidation="false"/>
        </div>
    </div>
</asp:Content>