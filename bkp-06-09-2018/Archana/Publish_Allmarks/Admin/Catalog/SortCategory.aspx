<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Catalog.SortCategory" Title="Sort Category" CodeFile="SortCategory.aspx.cs" %> 
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="javascript" type="text/javascript">
        function UP(nLevels) {
            var sel = document.forms[0].<%= CatalogNodeList.ClientID %>;
	        if (sel.selectedIndex == null || sel.selectedIndex == -1)
		        //nothing to move
		        return false;
	        if (sel.length == 1)
		        //not long enough
		        return false
	        if (sel.selectedIndex == 0)
		        //already first
		        return false;			
	        if ((sel.selectedIndex - nLevels) < 0)
		        //can't move that high up
		        nLevels = sel.selectedIndex;

	        tempIndex = sel.selectedIndex
	        newIndex = tempIndex - nLevels    
	        for(;tempIndex>newIndex;tempIndex--)
	        {
	            nextIndex = tempIndex-1; 
	            tempVal = sel[tempIndex].value;
	            tempText = sel[tempIndex].text;
	            sel[tempIndex].text = sel[nextIndex].text;
	            sel[tempIndex].value = sel[nextIndex].value;
	            sel[nextIndex].text = tempText;
	            sel[nextIndex].value = tempVal;
	            sel.selectedIndex = newIndex
	        }
	        return false;
        }

        function DN(nLevels) {
            var sel = document.forms[0].<%= CatalogNodeList.ClientID %>;
            if (sel.selectedIndex == null || sel.selectedIndex == -1)
		        //nothing to move
		        return false;
	        if (sel.length == 1)
		        //not long enough
		        return false
	        if (sel.selectedIndex == (sel.length - 1))
		        //already last
		        return false;			
	        if ((sel.selectedIndex + nLevels) > sel.length - 1)
		        //can't move that far
		        nLevels = sel.length - 1 - sel.selectedIndex ;

	        tempIndex = sel.selectedIndex
	        newIndex = tempIndex + nLevels
		    for(;tempIndex<newIndex;tempIndex++)
	        {
	            nextIndex = tempIndex+1;
	            tempVal= sel[tempIndex].value;
	            tempText = sel[tempIndex].text;
	            sel[tempIndex].text = sel[nextIndex].text;
	            sel[tempIndex].value = sel[nextIndex].value;
	            sel[nextIndex].text = tempText;
	            sel[nextIndex].value = tempVal;
	            sel.selectedIndex = newIndex
	        }
	        return false;
        }
	
        function SubmitMe(button) {
            var sel = document.forms[0].<%= CatalogNodeList.ClientID %>;
            var sortOrder = document.forms[0].<%= SortOrder.ClientID %>;
	        for (i=0; i<sel.length; i++) {
		        sortOrder.value = sortOrder.value + sel[i].value;
		        if (i < (sel.length - 1)) sortOrder.value = sortOrder.value + ",";
	        }

            button.value = 'Saving...'; 
            button.enabled= false;
	        return true;
        }
    </script>
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Catalog:" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <p><asp:Localize ID="InstructionText" runat="server" Text="To arrange the Catalog Items in the correct order, click an item in the list and use the buttons to move it up or down.  You can also use the quick sort to reorder the list by name.  When you have finished updating the order of the Catalog Items, click Save."></asp:Localize></p>
        <asp:UpdatePanel ID="SortPanel" runat="server">
            <ContentTemplate>
                <table style="margin:auto">
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="QuickSortLabel" runat="server" Text="Quick Sort:" SkinID="FieldHeader" AssociatedControlId="QuickSort"></asp:Label>
                            <asp:DropDownList ID="QuickSort" runat="server" AutoPostBack="true" OnSelectedIndexChanged="QuickSort_SelectedIndexChanged">
                                <asp:ListItem Text=""></asp:ListItem>
                                <asp:ListItem Text="Name (A -> Z)"></asp:ListItem>
                                <asp:ListItem Text="Name (Z -> A)"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <asp:ListBox ID="CatalogNodeList" runat="server" DataTextField="Name" DataValueField="CatalogNodeId" Rows="20">
                            </asp:ListBox>
                        </td>
                        <td valign="middle" align="left">
				            <asp:Button ID="UP100" runat="server" Text="FIRST" Width="60px" OnClientClick="return UP(1000)" /><br />
				            <asp:Button ID="UP1" runat="server" Text="UP by 1" Width="65px" SkinID="SortButton" OnClientClick="return UP(1)" /><br />
                            <asp:Button ID="UP5" runat="server" Text="UP by 5" Width="65px" SkinID="SortButton" OnClientClick="return UP(5)" /><br />
                            <asp:Button ID="UP10" runat="server" Text="UP by 10" Width="65px" SkinID="SortButton" OnClientClick="return UP(10)" /><br />
                            <hr class="hrSort" />
				            <asp:Button ID="DN1" runat="server" Text="Down by 1" Width="80px" SkinID="SortButton" OnClientClick="return DN(1)" /><br />
                            <asp:Button ID="DN5" runat="server" Text="Down by 5" Width="80px" SkinID="SortButton" OnClientClick="return DN(5)" /><br />
                            <asp:Button ID="DN10" runat="server" Text="Down by 10" Width="80px" SkinID="SortButton" OnClientClick="return DN(10)" /><br />
				            <asp:Button ID="DN100" runat="server" Text="LAST" Width="60px" OnClientClick="return DN(1000)"  /><br />
                            <hr class="hrSort" />
                            <asp:HiddenField ID="SortOrder" runat="server" />
                            <asp:Button ID="SaveButton" runat="server" Text="Save" Width="60px" OnClientClick="return SubmitMe(this)" OnClick="SaveButton_Click" />
                            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" Width="60px" OnClick="CancelButton_Click" />
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
