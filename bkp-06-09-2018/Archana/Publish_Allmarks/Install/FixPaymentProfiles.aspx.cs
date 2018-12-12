using CommerceBuilder.DomainModel;
using CommerceBuilder.Payments;
using CommerceBuilder.Payments.Providers;
using NHibernate.Criterion;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace AbleCommerce.Install
{
    public partial class FixPaymentProfiles : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void FixProfiles() 
        {
            IList<GatewayPaymentProfile> profiles = NHibernateHelper.CreateCriteria<GatewayPaymentProfile>()
                .Add(new Disjunction().Add(Restrictions.IsNull("PaymentProfileId")).Add(Restrictions.Eq("PaymentProfileId", "")))
                .List<GatewayPaymentProfile>();
            WebClient client = new WebClient();
            StringBuilder log = new StringBuilder();
            log.Append("Total Profiles To Fix: " + profiles.Count + Environment.NewLine);

            foreach(var profile in profiles)
            {
                int gatewayId = PaymentGatewayDataSource.GetPaymentGatewayIdByClassId(profile.GatewayIdentifier);
                PaymentGateway gateway = PaymentGatewayDataSource.Load(gatewayId);
                if (gateway != null)
                {
                    var configData = gateway.ParseConfigData();
                    StringBuilder sb = new StringBuilder();
                    sb.Append("<?xml version='1.0' encoding='utf-8'?>");
                    sb.Append("<getCustomerProfileRequest xmlns='AnetApi/xml/v1/schema/AnetApiSchema.xsd'>");
                    sb.Append("  <merchantAuthentication>");
                    sb.Append(string.Format("    <name>{0}</name>", configData["MerchantLogin"]));
                    sb.Append(string.Format("    <transactionKey>{0}</transactionKey>", configData["TransactionKey"]));
                    sb.Append("  </merchantAuthentication>");
                    sb.Append(string.Format("  <customerProfileId>{0}</customerProfileId>", profile.CustomerProfileId));
                    sb.Append("</getCustomerProfileRequest>");

                    string url = UseSandBox.Checked ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api"; 
                    byte[] data = client.UploadData(url, Encoding.UTF8.GetBytes(sb.ToString()));
                    string response = Encoding.UTF8.GetString(data);
                    string _byteOrderMarkUtf8 = Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble());
                    if (response.StartsWith(_byteOrderMarkUtf8))
                    {
                        response = response.Remove(0, _byteOrderMarkUtf8.Length);
                    }

                    response = response.Replace("xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"", string.Empty);
                    response = response.Replace("xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"", string.Empty);
                    response = response.Replace("xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\"", string.Empty);

                    
                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(response);
                    XmlNodeList xmlProfiles = doc.DocumentElement.SelectNodes("profile/paymentProfiles");
                    if (xmlProfiles != null && xmlProfiles.Count > 0)
                    {
                        foreach(XmlNode xmlProfile in xmlProfiles)
                        {
                            XmlNode firstNameNode = xmlProfile.SelectSingleNode("billTo/firstName");
                            XmlNode lastNameNode = xmlProfile.SelectSingleNode("billTo/lastName");
                            XmlNode paymentProfileNode = xmlProfile.SelectSingleNode("customerPaymentProfileId");
                            XmlNode cardNumberNode = xmlProfile.SelectSingleNode("payment/creditCard/cardNumber");

                            string firstName = firstNameNode != null ? firstNameNode.InnerText.Trim() : string.Empty;
                            string lastName = lastNameNode != null ? lastNameNode.InnerText.Trim() : string.Empty;
                            string cardNumber = cardNumberNode != null ? cardNumberNode.InnerText.Trim() : string.Empty;
                            string paymentProfileId = paymentProfileNode != null ? paymentProfileNode.InnerText.Trim() : string.Empty;

                            if(cardNumber.EndsWith(profile.ReferenceNumber, StringComparison.InvariantCultureIgnoreCase) 
                                && profile.NameOnCard.Equals(string.Format("{0} {1}", firstName, lastName), StringComparison.InvariantCultureIgnoreCase))
                            {
                                if (string.IsNullOrEmpty(profile.PaymentProfileId) && !string.IsNullOrEmpty(paymentProfileId))
                                {
                                    profile.PaymentProfileId = paymentProfileId;
                                    profile.Save();

                                    log.Append(string.Format("{0} - {1} - {2} => [{3}]", profile.CustomerProfileId, profile.NameOnCard, profile.ReferenceNumber, profile.PaymentProfileId));
                                    log.Append(Environment.NewLine);
                                }
                            }
                        }
                    }
                }

                FixLog.Text = log.ToString();
            }
        }

        protected void GoButton_Click(object sender, EventArgs e)
        {
            FixProfiles();
        }
    }
}