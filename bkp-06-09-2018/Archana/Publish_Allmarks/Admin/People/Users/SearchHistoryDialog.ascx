<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.People.Users.SearchHistoryDialog" CodeFile="SearchHistoryDialog.ascx.cs" %>
<div class="content"> 
    <asp:GridView ID="SearchHistoryGrid" runat="server" SkinID="PagedList" AutoGenerateColumns="false" Width="100%" PageSize="20" DataSourceID="SearchHistoryDs">
        <Columns>
            <asp:TemplateField HeaderText="Search Term" SortExpression="SearchTerm">
                <ItemStyle Width="150" />
                <HeaderStyle HorizontalAlign="Left" />
                <ItemTemplate>
                    <%#Eval("SearchTerm")%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Date" SortExpression="SearchDate">
                <ItemStyle Width="150" />
                <HeaderStyle HorizontalAlign="Left" />
                <ItemTemplate>
                    <%#Eval("SearchDate")%>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <asp:Label ID="NoRecordedTermsMessage" runat="server" Text="No recorded search terms."></asp:Label>
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:ObjectDataSource ID="SearchHistoryDs" runat="server" OldValuesParameterFormatString="original_{0}"
            SelectMethod="LoadForUser" TypeName="CommerceBuilder.Search.SearchHistoryDataSource"
            EnablePaging="true" 
            EnableViewState="false" 
            SortParameterName="sortExpression">
            <SelectParameters>
                <asp:QueryStringParameter Name="userId" DbType="Int32" QueryStringField="UserId" DefaultValue="0" />
            </SelectParameters>
    </asp:ObjectDataSource> 
</div>