<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StoreClosed.aspx.cs" Inherits="AbleCommerce.StoreClosed" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Store Is Closed</title>
</head>
<body>
    <div id="outerPageContainer" class="contentOnlyLayout"> 
       <div id="innerPageContainer" class="contentOnlyLayout"> 
          <div id="mainColumn" class="contentOnlyLayout"> 
            <div class="zone"> 
              <div id="storeClosed" class="mainContentWrapper">
				<form id="form1" runat="server">
				  <div class="section">
                    <div class="pageHeader">
                        <h1>Store Is Closed</h1>
                    </div>
                    <div class="content">
                        <asp:PlaceHolder ID="PHContent" runat="server"></asp:PlaceHolder>
                    </div>				   
				  </div>
				</form>
              </div> 
            </div> 
          </div> 
        </div> 
    </div> 
</body>
</html>
