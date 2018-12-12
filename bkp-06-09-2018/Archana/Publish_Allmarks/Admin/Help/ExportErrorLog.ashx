<%@ WebHandler Language="C#" Class="AbleCommerce.Admin.Help.ExportErrorLog" %>

namespace AbleCommerce.Admin.Help
{
    using System.Collections.Generic;
    using System.Text;
    using System.Web;
    using CommerceBuilder.Utility;

    /// <summary>
    /// Exports the error log to a file suitable for delivery to tech support.
    /// </summary>
    public class ExportErrorLog : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            IList<ErrorMessage> errorMessages = ErrorMessageDataSource.LoadAll();
            if (errorMessages.Count > 0)
            {
                StringBuilder errorData = new StringBuilder();
                foreach (ErrorMessage message in errorMessages)
                {
                    errorData.AppendLine("Date: " + message.EntryDate);
                    errorData.AppendLine("Severity: " + message.MessageSeverity.ToString());
                    errorData.AppendLine("Message: " + message.Text);
                    if (!string.IsNullOrEmpty(message.DebugData))
                        errorData.AppendLine(message.DebugData);
                    errorData.AppendLine();
                }
                string outFileName = "ErrorLog.log";
                AbleCommerce.Code.PageHelper.SendFileDataToClient(errorData.ToString(), outFileName);
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
