<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewLicenseAgreement.aspx.cs" Inherits="AbleCommerce.ViewLicenseAgreement" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Agreement</title>
</head>
<body>

<div id="OuterPageContainer" class="contentOnlyLayout"> 
   <div id="InnerPageContainer" class="contentOnlyLayout"> 
      <div id="mainColumn" class="contentOnlyLayout"> 
        <div class="Zone"> 
          <div id="licenseAgreement" class="mainContentWrapper">
		   <div class="section">
		   <div class="content">
            <form id="form1" runat="server">            
				<asp:Panel ID="AgreementTextPanel" runat="server" CssClass="innerSection agreementView">
					<div class="content">
						<asp:Literal ID="AgreementText" runat="server"></asp:Literal>
					</div>
					<div class="actions">
						<p align="center">
						<asp:HyperLink ID="OKLink" runat="server" Text="Close" CssClass="button hyperLinkButton" />
						<asp:HyperLink ID="AcceptLink" runat="server" Text="Accept" CssClass="button hyperLinkButton" />&nbsp;&nbsp;&nbsp;
						<asp:HyperLink ID="DeclineLink" runat="server" Text="Decline" CssClass="button hyperLinkButton" />
						</p>
					</div>
				</asp:Panel>
            </form>
		   </div>
		   </div>
          </div> 
        </div> 
      </div> 
    </div> 
</div> 
</body>
</html>
