<%@ WebHandler Language="C#" Class="AbleCommerce.Admin.Catalog.Download" %>

using System;
using System.Web;
using CommerceBuilder.DigitalDelivery;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Catalog
{
    public class Download : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            int digitalGoodId = AlwaysConvert.ToInt(context.Request.QueryString["DigitalGoodId"]);
            DigitalGood dg = DigitalGoodDataSource.Load(digitalGoodId);
            if (dg != null) AbleCommerce.Code.PageHelper.SendFileDataToClient(dg);
        }

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }

    }
}