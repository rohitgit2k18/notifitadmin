<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdminMenu.ascx.cs" Inherits="AbleCommerce.Admin.ConLib.AdminMenu" EnableViewState="false" %>
<asp:Literal ID="Menu" runat="server"></asp:Literal>
<script>
    $(document).ready(function () {
        $('#adminMenu').superfish({
            delay: 0,
            speed: 'fast'
        });
    });
</script>