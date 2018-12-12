using System;
using System.Collections.Generic;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using CommerceBuilder.DigitalDelivery;
using CommerceBuilder.Orders;
using CommerceBuilder.Utility;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile.UserControls.Account
{
    public partial class OrderDigitalGoods : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                IList<OrderItemDigitalGood> digitalGoodsCollection = GetDigitalGoods(this.Order);
                if (digitalGoodsCollection.Count > 0)
                {
                    DigitalGoodsPanel.Visible = true;
                    DigitalGoodsGrid.DataSource = digitalGoodsCollection;
                    DigitalGoodsGrid.DataBind();
                }
            }
        }

        protected bool DGFileExists(object dataItem)
        {
            DigitalGood dg = dataItem as DigitalGood;
            if (dg != null) return System.IO.File.Exists(dg.AbsoluteFilePath);
            else return false;
        }

        private IList<OrderItemDigitalGood> GetDigitalGoods(Order order)
        {
            IList<OrderItemDigitalGood> oidgList = new List<OrderItemDigitalGood>();
            foreach (OrderItem orderItem in order.Items)
            {
                foreach (OrderItemDigitalGood oidg in orderItem.DigitalGoods)
                {
                    oidgList.Add(oidg);
                }
            }
            return oidgList;
        }

        protected string GetDownloadUrl(object dataItem)
        {
            if (!this.Order.OrderStatus.IsValid) return "#";
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            DigitalGood dg = oidg.DigitalGood;
            if ((oidg.DownloadStatus == DownloadStatus.Valid) && (dg != null))
            {
                string downloadUrl = this.Page.ResolveUrl(NavigationHelper.GetMobileStoreUrl("~/Members/Download.ashx?id=" + oidg.Id.ToString()));
                if ((dg.LicenseAgreementMode & LicenseAgreementMode.OnDownload) == LicenseAgreementMode.OnDownload)
                {
                    if (dg.LicenseAgreement != null)
                    {
                        string acceptUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(downloadUrl));
                        string declineUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("javascript:window.close()"));
                        string agreeUrl = this.Page.ResolveUrl(NavigationHelper.GetMobileStoreUrl("~/ViewLicenseAgreement.aspx")) + "?id=" + dg.LicenseAgreement.Id + "&AcceptUrl=" + acceptUrl + "&DeclineUrl=" + declineUrl;
                        return agreeUrl + "\" onclick=\"" + AbleCommerce.Code.PageHelper.GetPopUpScript(agreeUrl, "license", 640, 480, "resizable=1,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no") + ";return false";
                    }
                }
                return downloadUrl;
            }
            return string.Empty;
        }

        protected string GetMaxDownloads(object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            if (oidg.DigitalGood == null) return string.Empty;
            if (oidg.DigitalGood.MaxDownloads == 0) return "n/a";
            int remDownloads = AlwaysConvert.ToInt(oidg.DigitalGood.MaxDownloads) - oidg.RelevantDownloads;
            return remDownloads.ToString();
        }

        protected bool ShowSerialKey(object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            if (!string.IsNullOrEmpty(oidg.SerialKeyData) && oidg.SerialKeyData.Length <= 100)
            {
                return true;
            }
            return false;
        }

        protected string GetPopUpScript(object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            string url = NavigationHelper.GetMobileStoreUrl(string.Format("~/Members/MySerialKey.aspx?OrderItemDigitalGoodId={0}", oidg.Id));
            url = this.ResolveUrl(url);
            //string clientScript = AbleCommerce.Code.PageHelper.GetPopUpScript(url, "Serial Key", 20, 20);
            string clientScript = string.Format("window.open('{0}'); return false;", url);
            clientScript = "javascript:" + clientScript;
            return clientScript;
        }

        protected bool ShowSerialKeyLink(object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            if (!string.IsNullOrEmpty(oidg.SerialKeyData) && oidg.SerialKeyData.Length > 100)
            {
                return true;
            }
            return false;
        }

        public bool ShowMediakey(Object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            if (oidg.DigitalGood == null) return false;
            bool showMediaKey = (oidg.DownloadStatus == DownloadStatus.Valid || oidg.DownloadStatus == DownloadStatus.Expired);
            if (showMediaKey)
                showMediaKey = !String.IsNullOrEmpty(oidg.DigitalGood.MediaKey);
            return showMediaKey;
        }

        protected void DigitalGoodsGrid_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item)
            {
                OrderItemDigitalGood oidg = (OrderItemDigitalGood)e.Item.DataItem;
                if (oidg != null)
                {
                    DigitalGood dg = oidg.DigitalGood;
                    if (dg != null)
                    {
                        if ((dg.LicenseAgreement != null) || (dg.Readme != null))
                        {
                            PlaceHolder phAssets = (PlaceHolder)e.Item.FindControl("phAssets");
                            if (phAssets != null)
                            {
                                phAssets.Visible = true;
                                string encodedUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("javascript:window.close()"));
                                string agreeUrl = this.Page.ResolveUrl(NavigationHelper.GetMobileStoreUrl("~/ViewLicenseAgreement.aspx") + "?id={0}&ReturnUrl=" + encodedUrl);
                                string agreeClickScript = AbleCommerce.Code.PageHelper.GetPopUpScript(agreeUrl, "license", 640, 480, "resizable=1,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no") + ";return false";
                                string readmeUrl = this.Page.ResolveUrl(NavigationHelper.GetMobileStoreUrl("~/ViewReadme.aspx")) + "?ReadmeId={0}&ReturnUrl=" + encodedUrl;
                                string readmeClickScript = AbleCommerce.Code.PageHelper.GetPopUpScript(readmeUrl, "readme", 640, 480, "resizable=1,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no") + ";return false";
                                if (dg.Readme != null)
                                {
                                    readmeClickScript = string.Format(readmeClickScript, dg.ReadmeId);

                                    HtmlControl ReadMeItem = (HtmlControl)phAssets.FindControl("ReadMeItem");
                                    HtmlControl ReadMeLink = (HtmlControl)ReadMeItem.FindControl("ReadMeLink");
                                    ReadMeItem.Visible = true;
                                    ReadMeLink.Attributes["onclick"] = readmeClickScript;
                                }
                                if (dg.LicenseAgreement != null)
                                {
                                    agreeClickScript = string.Format(agreeClickScript, dg.LicenseAgreementId);

                                    HtmlControl AgreementItem = (HtmlControl)phAssets.FindControl("AgreementItem");
                                    HtmlControl AgreementLink = (HtmlControl)AgreementItem.FindControl("AgreementLink");
                                    AgreementItem.Visible = true;
                                    AgreementLink.Attributes["href"] = string.Format(agreeUrl, dg.LicenseAgreementId);
                                    AgreementLink.Attributes["onclick"] = agreeClickScript;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}