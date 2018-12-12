<%@ WebHandler Language="C#" Class="AbleCommerce.Admin.Website.Themes.ThemeDownloader" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CommerceBuilder.Utility;
using System.IO;

namespace AbleCommerce.Admin.Website.Themes
{
    /// <summary>
    /// ThemeDownloader helps compressed theme downloads
    /// </summary>
    public class ThemeDownloader : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Server.ScriptTimeout = 14400;
            HttpResponse Response = context.Response;
            
            //LOAD REQUESTED ATTACHMENT
            string themeName = context.Request.QueryString["Theme"];
            string source = context.Server.MapPath(string.Format("~/App_Themes/{0}", themeName));
            string destination = context.Server.MapPath(string.Format("~/App_Themes/{0}.zip", themeName));
            CompressionHelper.CompressFolder(source, destination);
            if (File.Exists(destination))
            {
                DownloadHelper.SendFileDataToClient(context, destination, Path.GetFileName(destination));
                File.Delete(destination);
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
