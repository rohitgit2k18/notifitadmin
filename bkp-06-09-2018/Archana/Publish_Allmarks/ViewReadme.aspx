<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewReadme.aspx.cs" Inherits="AbleCommerce.ViewReadme" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Readme</title>
</head>
<body>
<div id="OuterPageContainer" class="contentOnlyLayout"> 
   <div id="InnerPageContainer" class="contentOnlyLayout"> 
      <div id="mainColumn" class="contentOnlyLayout"> 
        <div class="Zone"> 
          <div id="viewReadme" class="mainContentWrapper">
		   <div class="section">
			 <div class="content">			
               <form id="form1" runat="server">
				<asp:Panel ID="ReadmeTextPanel" runat="server" CssClass="agreementView">
					<div class="textContent">
						<asp:Literal ID="ReadmeText" runat="server"></asp:Literal>
					</div>
					<div class="actions">
						<p align="center">
						<asp:HyperLink ID="OkButton" runat="server" Text="Close" CssClass="button hyperLinkButton" />
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
