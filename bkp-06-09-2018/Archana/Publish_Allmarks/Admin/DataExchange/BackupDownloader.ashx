<%@ WebHandler Language="C#" Class="AbleCommerce.Admin.DataExchange.BackupDownloader" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CommerceBuilder.Utility;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;

namespace AbleCommerce.Admin.DataExchange
{
    /// <summary>
    /// BackupDownloader helps backup file downloads
    /// </summary>
    public class BackupDownloader : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Server.ScriptTimeout = 14400;
            HttpResponse Response = context.Response;
            
            //LOAD REQUESTED ATTACHMENT
            string fileName = context.Request.QueryString["File"];
            string source = context.Server.MapPath(string.Format("~/App_Data/{0}", fileName));
            if (File.Exists(source))
            {
                DownloadHelper.SendFileDataToClient(context, source, Path.GetFileName(source));
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
