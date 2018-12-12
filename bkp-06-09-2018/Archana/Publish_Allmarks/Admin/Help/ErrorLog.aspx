<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Help.ErrorLog" Title="View Error Log"  CodeFile="ErrorLog.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="View Error Log"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="ErrorMessageAjax" runat="server">
            <ContentTemplate>
                <cb:SortedGridView ID="ErrorMessageGrid" runat="server" AllowPaging="True" AutoGenerateColumns="False" 
                    DataKeyNames="Id" DataSourceID="ErrorMessageDs" PageSize="20" DefaultSortExpression="EntryDate" 
                    SkinID="PagedList" AllowSorting="True" DefaultSortDirection="Descending" ShowWhenEmpty="False" 
                    EnableViewState="false" OnDataBound="ErrorMessageGrid_DataBound" Width="100%">
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <input type="checkbox" onclick="toggleSelected(this)" />
                            </HeaderTemplate>
                            <ItemStyle HorizontalAlign="center" Width="40px" VerticalAlign="Top" />
                            <ItemTemplate>
                                <asp:CheckBox ID="Selected" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="EntryDate" HeaderText="Date" SortExpression="EntryDate">
                            <ItemStyle HorizontalAlign="Center" Width="90px" VerticalAlign="Top" />
                        </asp:BoundField>
                        <asp:BoundField DataField="MessageSeverity" HeaderText="Severity" SortExpression="MessageSeverityId" >
                            <ItemStyle HorizontalAlign="Center" Width="70px" VerticalAlign="Top" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Message" SortExpression="Text">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle VerticalAlign="Top" />
                            <ItemTemplate>
                                <div style="max-height:150px;overflow-y:auto">
                                    <%# Eval("Text")%>
                                    <br />
                                    <%# WrapDebugData(Container.DataItem) %>
                                </div>
                                
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    
                    <EmptyDataTemplate>
                        <asp:Localize ID="EmptyMessage" runat="server" Text="There are no entries in the error log."></asp:Localize>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
                <asp:ObjectDataSource ID="ErrorMessageDs" runat="server" 
                    OldValuesParameterFormatString="original_{0}" SelectMethod="LoadAll" 
                    TypeName="CommerceBuilder.Utility.ErrorMessageDataSource" SortParameterName="sortExpression"
                    EnablePaging="True" DataObjectTypeName="CommerceBuilder.Utility.ErrorMessage" DeleteMethod="Delete"></asp:ObjectDataSource>
				<asp:PlaceHolder ID="ButtonsPlaceHolder" runat="server">
					<asp:Button ID="DeleteSelectedButton" runat="server" Text="Delete Selected" OnClick="DeleteSelectedButton_Click" OnClientClick="return confirm('Are you sure you want to delete the selected log entries?')" />
					<asp:Button ID="DeleteAllButton" runat="server" Text="Delete All" OnClick="DeleteAllButton_Click" OnClientClick="return confirm('Are you sure you want to delete all log entries?')" />
					<asp:HyperLink ID="ExportErrorLogLink" runat="server" Text="Export" NavigateUrl="ExportErrorLog.ashx" SkinId="Button"></asp:HyperLink>
				</asp:PlaceHolder>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <script type="text/javascript">
        function toggleCheckBoxState(id, checkState) {
            var cb = document.getElementById(id);
            if (cb != null)
                cb.checked = checkState;
        }

        function toggleSelected(checkState) {
            // Toggles through all of the checkboxes defined in the CheckBoxIDs array
            // and updates their value to the checkState input parameter
            if (CheckBoxIDs != null) {
                for (var i = 0; i < CheckBoxIDs.length; i++)
                    toggleCheckBoxState(CheckBoxIDs[i], checkState.checked);
            }
        }
    </script>
</asp:Content>