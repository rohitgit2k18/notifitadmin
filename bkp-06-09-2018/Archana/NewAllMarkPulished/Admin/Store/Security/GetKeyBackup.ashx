<%@ WebHandler Language="C#" Class="AbleCommerce.Admin._Store.Security.Download" %>

namespace AbleCommerce.Admin._Store.Security
{
    using System.Web;
    using CommerceBuilder.Configuration;

    public class Download : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            SendKeyDataToClient("key.bin", EncryptionKeyManager.Instance.GetKeyBackup());
        }

        private void SendKeyDataToClient(string fileName, byte[] keyData)
        {
            HttpResponse Response = HttpContext.Current.Response;
            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Length", keyData.Length.ToString());
            Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
            Response.OutputStream.Write(keyData, 0, keyData.Length);
            Response.Flush();
            Response.Close();
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