<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TaxCloudExemption.aspx.cs" Inherits="AbleCommerce.TaxCloudExemption" Theme="" %>
<html>
    <head runat="server">
        <title> Are you tax exempt?</title>
        <style>
            body 
            { 
	            background-color:#FFFFFF; 
	            font-family: Arial, Verdana, Helvetica, sans-serif; 
	            font-size: 14px;
                color:#414141;
            }
            .orderNumber {
                padding:3px;
                background-color:#f6f2c9;
                border:1px;
                border-radius:4px;
                font-size:16px;
            }

            .numValue {
                padding:0 10px;
                background-color:#FFF;
            }
            .numLabel {
                padding:3px 10px;
                font-weight:bold;
            }
            .tax {
                font-size:16px;
                font-weight:bold;
            }
        </style>
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
        <script type="text/javascript">
            var certLink = 'xmptlink';
            var ajaxLoad = true;
            var reloadWithSave = true;
            var certSelectUrl = "TaxCloudSelectCert.aspx"; //A certificate is selected
            var merchantNameForCert = '<%= AbleContext.Current.Store.Name %>';
            //NOTE these could/should all be the same URL, but not necessary.
            var saveCertUrl = 'TaxCloudSaveCert.aspx'; //Save a new exemption cert
            var certListUrl = 'TaxCloudCertsList.ashx'; //list existing exemption certs for customer
            var certRemoveUrl = 'TaxCloudRemoveCert.aspx'; //Note: this will be called asynchronosly (no page refresh);
            //reload the cart/checkout page after selecting a certificate (will force a new sales tax lookup with the exemption cert applied so rate will return zero)
            //if set to false, the script will not ask the customer to reload.
            var withConfirm = true;
            //use this to pass the certificate id to the server for any reason
            var hiddenCertificateField = 'taxcloud_exemption_certificate';
            //Please do not edit the following line.
            var clearUrl = '?time=' + new Date().getTime().toString(); // prevent caching
            (function () {
            var tcJsHost = (('https:' == document.location.protocol) ? 'https:' : 'http:')
            var ts = document.createElement('script')
            ts.type = 'text/javascript';
            ts.async = true;
            ts.src = tcJsHost + '//taxcloud.net/imgs/cert.min.js' + clearUrl;
            var t = document.getElementsByTagName('script')[0];
            t.parentNode.insertBefore(ts, t);
            })();
        </script>
    </head>
    <body>
        <div class="widget">
            <div class="content">
                <div style="height:600px;">
                    <asp:Label ID="Cert" runat="server"></asp:Label>
                    <p>
                    Total tax for this order is <asp:Label ID="TaxAmount" runat="server" CssClass="tax"></asp:Label>. You can use <span class="orderNumber"><span class="numLabel">Order#</span><span class="numValue"><asp:Localize ID="BasketId" runat="server" EnableViewState="false"></asp:Localize></span></span> for Single purchase certificate. Please <span id="xmptlink" class="navlink">click here</span> to manage/apply exemption certificates.
                    </p>
                    <input type="hidden" id="taxcloud_exemption_certificate" />
                </div>
            </div>
        </div>
    </body>
</html>