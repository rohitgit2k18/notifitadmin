<%@ Page Language="C#" MasterPageFile="../Product.master" Inherits="AbleCommerce.Admin.Products.Kits.SortComponents" Title="Sort Components"  EnableViewState="false" CodeFile="SortComponents.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Sort Components in {0}" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="content">
                <p><asp:Label ID="InstructionText" runat="server" Text="To arrange the components in the correct order, click an item in the list and use the buttons to move it up or down.  You can also use the quick sort to reorder the list by name.  When you have finished updating the order of the components, click Save."></asp:Label></p>
                <table class="inputForm compact">
                    <tr>
                        <td valign="top">
                            <asp:ListBox ID="KitComponentList" runat="server" DataTextField="Name" DataValueField="KitComponentId" Rows="10" CssClass="sort">
                            </asp:ListBox>
                        </td>
                        <td valign="middle" align="center">
				            <asp:Button ID="FirstButton" runat="server" Text="FIRST" Width="60px" OnClientClick="return first()" /><br />
				            <asp:Button ID="UpButton" runat="server" Text="/\" Width="60px" OnClientClick="return up()" /><br />
				            <asp:Button ID="DownButton" runat="server" Text="\/" Width="60px" OnClientClick="return dn()" /><br />
				            <asp:Button ID="LastButton" runat="server" Text="LAST" Width="60px" OnClientClick="return last()" /><br />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Button ID="SaveButton" runat="server" Text="Save" Width="60px" OnClientClick="return SubmitMe()" OnClick="SaveButton_Click" />
                            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" Width="60px" OnClick="CancelButton_Click" />
                            <asp:HiddenField ID="SortOrder" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="QuickSortLabel" runat="server" Text="Quick Sort:" SkinID="FieldHeader" AssociatedControlId="QuickSort">
                            </asp:Label>
                            <asp:DropDownList ID="QuickSort" runat="server" AutoPostBack="true" OnSelectedIndexChanged="QuickSort_SelectedIndexChanged">
                                <asp:ListItem Text=""></asp:ListItem>
                                <asp:ListItem Text="Name (A -> Z)"></asp:ListItem>
                                <asp:ListItem Text="Name (Z -> A)"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript">
        function first()
        {
            var list = $get("<%= KitComponentList.ClientID %>");
            if (list.length < 2) return false;
            var index = list.selectedIndex;
            if (index == null || index < 1) return false;
            var moveItem = list.options[index];
            list.options.remove(index);
            list.options.add(moveItem, 0);
            return false;
        }

        function up()
        {
            var list = $get("<%= KitComponentList.ClientID %>");
            if (list.length < 2) return false;
            var index = list.selectedIndex;
            if (index == null || index < 1) return false;
            var moveItem = list.options[index];
            list.options.remove(index);
            list.options.add(moveItem, index - 1);
            return false;
        }

        function dn()
        {
            var list = $get("<%= KitComponentList.ClientID %>");
            if (list.length < 2) return false;
            var index = list.selectedIndex;
            if (index == null || index == list.length - 1) return false;
            var moveItem = list.options[index];
            list.options.remove(index);
            list.options.add(moveItem, index + 1);
            return false;
        }

        function last()
        {
            var list = $get("<%= KitComponentList.ClientID %>");
            if (list.length < 2) return false;
            var index = list.selectedIndex;
            if (index == null || index == list.length - 1) return false;
            var moveItem = list.options[index];
            list.options.remove(index);
            list.options.add(moveItem);
            return false;
        }
    	
	    function SubmitMe() {
            var sel = document.forms[0].<%= KitComponentList.ClientID %>;
            var sortOrder = document.forms[0].<%= SortOrder.ClientID %>;
		    for (i=0; i<sel.length; i++) {
			    sortOrder.value = sortOrder.value + sel[i].value;
			    if (i < (sel.length - 1)) sortOrder.value = sortOrder.value + ",";
		    }
		    return true;
	    }
	</script>
</asp:Content>