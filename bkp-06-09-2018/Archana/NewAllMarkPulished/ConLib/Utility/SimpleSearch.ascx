<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Utility.SimpleSearch" EnableViewState="false" CodeFile="SimpleSearch.ascx.cs" %>
<%--
<conlib>
<summary>Displays a simple search box</summary>
</conlib>
--%>
<script type="text/javascript">
    $(function () {
        $(".searchPhrase").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: "Search.aspx/Suggest",
                    data: "{ 'term': '" + request.term + "' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function (data) { return data; },
                    success: function (data) {
                        response($.map(data.d, function (item) {
                            return {
                                value: item
                            }
                        }))
                    }
                });
            },
            minLength: 2
        });
    });
</script>

<div class="simpleSearchPanel">
    <asp:Panel ID="SearchPanel" runat="server" CssClass="innerSection">
        <div style="display:none"><asp:ValidationSummary ID="SearchValidation" runat="server" ShowMessageBox="true" ValidationGroup="Search"/></div>
		<% if (IsBootstrap) {  %>
            <div class="input-group">
        <% } %>
        <asp:TextBox ID="SearchPhrase" runat="server" CssClass="searchPhrase form-control" MaxLength="60" placeholder="Search Our Products"></asp:TextBox>
        <asp:Button ID="SearchButton" runat="server" Text="Search"
			 OnClick="SearchButton_Click" CausesValidation="true" ValidationGroup="Search" />
        <% if (IsBootstrap) {  %>
        <span class="input-group-btn">
        <asp:LinkButton ID="SearchLink" runat="server" Text="Search"
			    OnClick="SearchButton_Click" CausesValidation="true" ValidationGroup="Search" CssClass="btn btn-success">
            <i class="glyphicon glyphicon-search"></i>
        </asp:LinkButton>
        </span></div>
        <% } %>
<%--		<cb:SearchKeywordValidator ID="SearchPhraseValidator" runat="server" ControlToValidate="SearchPhrase" 
			ErrorMessage="Search keyword must be at least {0} characters in length excluding spaces and wildcards."
			Text="*" ValidationGroup="Search" Display="None" KeywordRequired="true"></cb:SearchKeywordValidator>--%>
    </asp:Panel>
</div>