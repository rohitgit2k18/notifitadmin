<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Marketing.Feeds.ShoppingCom" Title="Shopping.com Feed" CodeFile="Shopping.com.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
	    <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Shopping.com Feed"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="marketing" />
	    </div>
    </div>
    <div class="section">
        <div class="header">
            <h2>Configuration</h2>
        </div>
        <div class="content">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" >
                <ContentTemplate>
                    <asp:Panel ID="FeedCreationProgressPanel" runat="server" Width="100%" Visible="False" >            
                        <asp:Literal ID="WaitMessage" runat="server" Text="Please wait, this may take a few minutes. 0peration in progress..."></asp:Literal>
                        <cb:ProgressBar ID="ProgressBar1" Width="500px" Value="0" runat="server"></cb:ProgressBar>
                        <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="1000" OnTick="Timer1_Tick">
                        </asp:Timer>
                    </asp:Panel>
                    <asp:Panel ID="MessagePanel" runat="server" CssClass="contentPanel">
                        <div class="contentPanelBody">
                            <asp:Label ID="SuccessMessageHeader" runat="server" Text="SUCCESS"></asp:Label>
                            <asp:Label ID="FailureMessageHeader" runat="server" Text="FAILED"></asp:Label>
                            <asp:BulletedList ID="Messages" runat="server"></asp:BulletedList>
                        </div>
                        <asp:Button ID="ContinueButton" runat="server" Text="Continue" OnClick="ContinueButton_Click" />
                    </asp:Panel>
                    <asp:PlaceHolder ID="FeedInputPanel" runat="server">
                        <table class="inputForm">
                            <tr> 
                                <th> 
		                            <asp:Label ID="FeedFileNameLabel" runat="server" Text="Feed File Name:"></asp:Label><br /> 
		                            <span class="helpText">Name of the feed file</span>		
                                </th>
                                <td valign="top">
                                    <asp:TextBox ID="FeedFileName" runat="server" Text="" Width="200px"></asp:TextBox> 
                                </td>
                            </tr>
                            <tr> 
                                <th> 
		                            <asp:Label ID="AllowOverwriteLabel" runat="server" Text="Overwrite Existing Feed File"></asp:Label>
		                            <br /> <span class="helpText">Overwrite existing feed when a new one is created?</span>
                                </th>
                                <td valign="top"> <asp:RadioButtonList ID="AllowOverwrite" runat="server" RepeatDirection="Vertical"> 
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr> 
                                <th> 
		                            <asp:Label ID="Label1" runat="server" Text="Product Inclusion"></asp:Label>
		                            <br /> <span class="helpText">Which Products to Include in the feed?</span>
                                </th>
                                <td valign="top"> 
	                                <asp:RadioButton ID="MarkedProducts" runat="Server" GroupName="ProductInclusion" /> 
                                    <asp:Label ID="Label4" runat="server" Text="Do not include products marked for feed exclusion"></asp:Label>
                                    <br />
	                                <asp:RadioButton ID="AllProducts" runat="Server" GroupName="ProductInclusion" /> 
                                    <asp:Label ID="Label3" runat="server" Text="All Products (Ignore product feed setting)"></asp:Label>
                                    <br /> 
	                            </td>
                            </tr>
                            <tr> 
                                <th> 
		                            <asp:Label ID="Label9" runat="server" Text="Compressed Feed File Name"></asp:Label>
		                            <br /> <span class="helpText">Name of the compressed feed file</span>
                                </th>
                                <td valign="top">
                                    <asp:TextBox ID="CompressedFeedFileName" runat="server" Text="" Width="200px"></asp:TextBox> 
                                </td>
                            </tr>
                            <tr> 
                                <th> 
		                            <asp:Label ID="AllowOverwriteCompressedLabel" runat="server" Text="Overwrite Existing Compressed Feed"></asp:Label>
		                            <br /> <span class="helpText">Overwrite existing feed when creating a new one?</span>
                                </th>
                                <td valign="top"> <asp:RadioButtonList ID="AllowOverwriteCompressed" runat="server" RepeatDirection="Vertical"> 
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr> 
                                <th> 
		                            <asp:Label ID="FtpHostLabel" runat="server" Text="FTP Host"></asp:Label>
		                            <br /> <span class="helpText">FTP Host Name or IP address</span>
                                </th>
                                <td valign="top">
                                    <asp:TextBox ID="FtpHost" runat="server" Text=""></asp:TextBox> 
                                </td>
                            </tr>
                            <tr> 
                                <th> 
		                            <asp:Label ID="Label20" runat="server" Text="FTP User Name"></asp:Label>
                                    <br /> <span class="helpText">FTP User Name</span>
                                </th>
                                <td valign="top">
                                    <asp:TextBox ID="FtpUser" runat="server" Text=""></asp:TextBox> 
                                </td>
                            </tr>
                            <tr> 
                                <th> 
		                            <asp:Label ID="Label22" runat="server" Text="FTP Password"></asp:Label>
                                    <br /> <span class="helpText">FTP password</span>
                                </th>
                                <td valign="top">
                                    <asp:TextBox ID="FtpPassword" runat="server" Text=""></asp:TextBox> 
                                </td>
                            </tr>
                            <tr> 
                                <th> 
		                            <asp:Label ID="Label5" runat="server" Text="Remote File Name"></asp:Label>
		                            <br /> <span class="helpText">Name of the file to set on remote server</span>
                                </th>
                                <td valign="top">
                                    <asp:TextBox ID="RemoteFileName" runat="server" Width="200px" Text=""></asp:TextBox> 
                                </td>
                            </tr>  
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:Button ID="BtnSaveSettings" runat="server" Text="Save Settings" SkinID="SaveButton" OnClick="BtnSaveSettings_Click" />
                                </td>
                            </tr>
                            <tr class="sectionHeader">
                                <th colspan="2">
                                    Feed Actions
                                </th>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <p>After saving your configuration settings, select an option to publish your feed.</p>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Label ID="FeedActionLabel" runat="server" Text="Choose Task:" AssociatedControlID="FeedAction"></asp:Label>
                                </th>
                                <td>
                                    <asp:DropDownList ID="FeedAction" runat="server">
                                    </asp:DropDownList>
                                    <asp:Button ID="FeedActionButton" runat="server" Text="Go" SkinID="Button" OnClick="FeedActionButton_Click"></asp:Button>
                                </td>
                            </tr>
                        </table>
                    </asp:PlaceHolder>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>