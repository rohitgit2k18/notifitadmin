//-----------------------------------------------------------------------
// <copyright file="ChartImageHandler.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Code
{   
    using System;
    using System.Web;
    using CommerceBuilder.Common;

    public class ChartImageHandler : IHttpHandler
    {        
        public void ProcessRequest(HttpContext context)
        {
            string FileName = context.Server.MapPath(context.Request.FilePath);

            // ONLY SERVE IMAGE REQUESTS IF ITS AN ADMIN USER
            if (!AbleContext.Current.User.IsAdmin)
            {
                context.Response.Clear();
                context.Response.StatusCode = 401;
                context.Response.Write("Access Denied.");
                context.Response.End();
            }

           context.Response.ContentType = "image/png";
           context.Response.WriteFile(FileName);
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