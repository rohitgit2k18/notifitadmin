namespace AbleCommerce.Code
{
    using System;
    using System.Web;
    using CommerceBuilder.Common;
    using CommerceBuilder.DigitalDelivery;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public class DownloadHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Server.ScriptTimeout = 14400;
            HttpResponse Response = context.Response;
            
            // LOAD REQUESTED ORDER ITEM DIGITAL GOOD
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
            {
                int orderItemDigitalGoodId = AlwaysConvert.ToInt(context.Request.QueryString["id"]);
                HandleOrderItemDigitalGood(context, Response, orderItemDigitalGoodId);
            }

            // HANDLE DIGITAL GOOD DOWNLOAD REQUEST
            else if (!string.IsNullOrEmpty(context.Request.QueryString["dgid"]))
            {
                int digitalGoodId = AlwaysConvert.ToInt(context.Request.QueryString["dgid"]);
                DigitalGood digitalGood = DigitalGoodDataSource.Load(digitalGoodId);

                // VERIFY DIGITAL GOOD IS VALID
                if (digitalGood != null)
                {
                    bool hasAccess = false;
                    foreach (DigitalGoodGroup dgg in digitalGood.DigitalGoodGroups)
                    {
                        if (AbleContext.Current.User.IsInGroup(dgg.GroupId))
                        {
                            hasAccess = true;
                            break;
                        }
                    }

                    if (hasAccess)
                    {
                        DownloadHelper.SendFileDataToClient(context, digitalGood);
                    }
                    else Response.Write("You are not authorized to download the requested file.");
                }
                else Response.Write("The requested file could not be located.");
            }
        }

        private static void HandleOrderItemDigitalGood(HttpContext context, HttpResponse Response, int orderItemDigitalGoodId)
        {
            OrderItemDigitalGood oidg = OrderItemDigitalGoodDataSource.Load(orderItemDigitalGoodId);

            // VERIFY DIGITAL GOOD IS VALID
            if (oidg != null)
            {
                // VERIFY REQUESTING USER PLACED THE ORDER
                OrderItem orderItem = oidg.OrderItem;
                if (orderItem != null)
                {
                    Order order = orderItem.Order;
                    if (order != null)
                    {
                        if (AbleContext.Current.UserId == order.User.Id)
                        {
                            // VERIFY THE DOWNLOAD IS VALID
                            if (oidg.DownloadStatus == DownloadStatus.Valid)
                            {
                                DigitalGood digitalGood = oidg.DigitalGood;
                                if (digitalGood != null)
                                {
                                    // RECORD THE DOWNLOAD
                                    Uri referrer = context.Request.UrlReferrer;
                                    string referrerUrl = (referrer != null) ? referrer.ToString() : string.Empty;
                                    oidg.RecordDownload(context.Request.UserHostAddress, context.Request.UserAgent, referrerUrl);
                                    DownloadHelper.SendFileDataToClient(context, digitalGood);
                                }
                                else
                                {
                                    Response.Write("The requested file could not be located.");
                                }
                            }
                            else
                            {
                                Response.Write("This download is expired or invalid.");
                            }
                        }
                        else
                        {
                            Response.Write("You are not authorized to download the requested file.");
                        }
                    }
                    else
                    {
                        Response.Write("The order could not be loaded.");
                    }
                }
                else
                {
                    Response.Write("The order item could not be loaded.");
                }
            }
            else
            {
                Response.Write("The requested item does not exist.");
            }
        }

        public bool IsReusable
        {
            get { return true; }
        }
    }
}