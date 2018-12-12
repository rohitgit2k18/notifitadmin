using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Redi.Utility
{
    public class MapFileContentType
    {
        public static string Do (string fileName)
        {
            string wkExt = "";
            string contentType = "";

            int i = fileName.LastIndexOf('.');

            if (i <= 0 || i == wkExt.Length - 1)
            {
                return "";
            }

            wkExt = fileName.Substring(i + 1);

            switch (wkExt)
            {
                case "ps" :
                    contentType = "application/postscript";
                    break;
                case "xps":
                    contentType = "application/vnd.ms-xpsdocument";
                    break;
                case "gz":
                    contentType = "application/x-gzip";
                    break;
                case "zip":
                case "zipx":
                    contentType = "application/x-zip-compressed";
                    break;
                case "xml":
                    contentType = "application/xml";
                    break;
                case "bmp":
                    contentType = "image/bmp";
                    break;
                case "gif":
                    contentType = "image/gif";
                    break;
                case "jpg":
                case "jpeg":
                    contentType = "image/jpeg";
                    break;
                case "png":
                    contentType = "image/png";
                    break;
                case "tiff":
                case "tif":
                    contentType = "image/tiff";
                    break;
                case "ico":
                    contentType = "image/x-icon";
                    break;
                case "dwfx":
                    contentType = "model/vnd.dwfx+xps";
                    break;
                case "ai":
                    contentType = "application/postscript";
                    break;
                case "pdf":
                    contentType = "application/pdf";
                    break;
                case "xls":
                case "xlsx":
                    contentType = "application/excel";
                    break;
                case "txt":
                    contentType = "text/plain";
                    break;
                case "dxf":
                    contentType = "application/dxf";
                    break;
                case "eps":
                    contentType = "application/postscript";
                    break;
                case "pptx":
                case "ppt":
                    contentType = "application/powerpoint";
                    break;
                case "pps":
                    contentType = "application/mspowerpoint";
                    break;
                case "psd":
                    contentType = "application/octet-stream";
                    break;
                case "doc":
                    contentType = "application/msword";
                    break;
                case "tga":
                    contentType = "";
                    break;
                default :
                    break;
            }

            return contentType;

        }
    }
}
