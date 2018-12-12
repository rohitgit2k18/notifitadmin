<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Checkout.TaxCloudTaxExemptionCert" CodeFile="TaxCloudTaxExemptionCert.ascx.cs" EnableViewState="false" %>
<%--
<conlib>
<summary>The TaxCloud Tax exemption certificates Link.</summary>
</conlib>
--%>

<script>
        $(function () {
            $("#iframe").fancybox({
                'width': '75%',
                'height': '75%',
                'autoScale': false,
                'transitionIn': 'none',
                'transitionOut': 'none',
                'type': 'iframe',
                afterClose: function () {
                    location.reload();
                    return;
                }
            });
        });
</script>

<a id="iframe" href='<%=Page.ResolveUrl("~/TaxCloudExemption.aspx") %>'>Are you tax exempt? </a>    