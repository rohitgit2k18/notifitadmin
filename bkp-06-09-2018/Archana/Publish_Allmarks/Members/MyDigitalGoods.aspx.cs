using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.UI;
using CommerceBuilder.Common;
using CommerceBuilder.DigitalDelivery;
using CommerceBuilder.Orders;
using CommerceBuilder.Utility;

namespace AbleCommerce.Members
{
    public partial class MyDigitalGoods : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                BindDigitalGoods();
                BindSubscriptionDigitalGoods();
            }
        }

        private void BindDigitalGoods()
        {
            IList<OrderItemDigitalGood> digitalGoodsCollection = GetDigitalGoods();
            if (digitalGoodsCollection.Count > 0)
            {
                DigitalGoodsGrid.DataSource = GetDigitalGoods();
                DigitalGoodsGrid.DataBind();
            }
        }

        private IList<OrderItemDigitalGood> GetDigitalGoods()
        {
            return OrderItemDigitalGoodDataSource.LoadForUser(AbleContext.Current.UserId);
        }

        protected string GetMaxDownloads(object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            if (oidg.DigitalGood == null) return string.Empty;
            if (oidg.DigitalGood.MaxDownloads == 0) return "n/a";
            int remDownloads = AlwaysConvert.ToInt(oidg.DigitalGood.MaxDownloads) - oidg.RelevantDownloads;
            return remDownloads.ToString();
        }

        protected string GetDownloadUrl(object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            if (oidg.DownloadStatus == DownloadStatus.Valid)
            {
                return Page.ResolveUrl("~/Members/Download.ashx?id=" + oidg.Id.ToString());
            }

            return string.Empty;
        }

        protected bool GetVisible(object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            return oidg.DownloadStatus == DownloadStatus.Valid;
        }

        protected bool ShowSerialKey(object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            if (oidg.DownloadStatus == DownloadStatus.Valid)
            {
                if (string.IsNullOrEmpty(oidg.SerialKeyData) || oidg.SerialKeyData.Length <= 100)
                {
                    return true;
                }
            }
            return false;
        }

        protected bool ShowSerialKeyLink(object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            if (oidg.DownloadStatus == DownloadStatus.Valid)
            {
                if (!string.IsNullOrEmpty(oidg.SerialKeyData) && oidg.SerialKeyData.Length > 100)
                {
                    return true;
                }
            }
            return false;
        }

        protected string GetPopUpScript(object dataItem)
        {
            OrderItemDigitalGood oidg = (OrderItemDigitalGood)dataItem;
            string url = string.Format("~/Members/MySerialKey.aspx?OrderItemDigitalGoodId={0}", oidg.Id);
            url = this.ResolveUrl(url);
            string clientScript = string.Format("window.open('{0}'); return false;", url);
            clientScript = "javascript:" + clientScript;
            return clientScript;
        }

        #region subscription Digital goods
        private void BindSubscriptionDigitalGoods()
        {
            IList<DigitalGood> digitalGoodsCollection = GetSubscriptionDigitalGoods();
            if (digitalGoodsCollection.Count > 0)
            {
                DownloadsGrid.DataSource = digitalGoodsCollection;
                DownloadsGrid.DataBind();
                SubscriptionDownloads.Visible = true;
            }
            else
            {
                SubscriptionDownloads.Visible = false;
            }
        }

        private IList<DigitalGood> GetSubscriptionDigitalGoods()
        {
            return DigitalGoodDataSource.FindByUserGroups(AbleContext.Current.UserId);
        }

        protected string GetSubscriptionDGDownloadUrl(object dataItem)
        {
            DigitalGood dg = (DigitalGood)dataItem;
            return Page.ResolveUrl("~/Members/Download.ashx?dgid=" + dg.Id.ToString());
        }

        protected bool GetReadMeVisible(object dataItem)
        {
            DigitalGood dg = (DigitalGood)dataItem;
            return dg.Readme != null;
        }

        protected string GetReadMeUrl(object dataItem)
        {
            DigitalGood dg = (DigitalGood)dataItem;

            string encodedUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("javascript:window.close()"));
            string readmeUrl = this.Page.ResolveUrl("~/ViewReadme.aspx") + "?ReadmeId={0}&ReturnUrl=" + encodedUrl;
            string readmeClickScript = AbleCommerce.Code.PageHelper.GetPopUpScript(readmeUrl, "readme", 640, 480, "resizable=1,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no") + ";";
            if (dg.Readme != null)
            {
                readmeClickScript = string.Format(readmeClickScript, dg.ReadmeId);
                return readmeClickScript;
            }

            return string.Empty;
        }
        #endregion
    }
}