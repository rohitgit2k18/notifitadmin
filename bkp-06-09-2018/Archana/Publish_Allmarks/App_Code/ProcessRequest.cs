using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Redi.Utility;
using CommerceBuilder.Utility;


/// <summary>
/// Run the requested background process.
/// </summary>
public class ProcessRequest
{
    public enum BackgroundRequestName
    {
        SendJobEmail,
        LocalFileToS3
    }
    /// <summary>
    /// Send a request to be processed in the background.
    /// </summary>
    /// <param name="requestName"></param>
    /// <param name="requestData"></param>
    /// <returns></returns>
    public static Boolean RequestBackgroundProcess(BackgroundRequestName requestName, string requestData)
    {
        using (Redi.Utility.SqlText insert = new SqlText(
            "Insert Into ALL_BatchJobQueue (RequestName, RequestedDateTimeUtc, Submitted, RequestData ) " +
            "Values (@RequestName, @RequestedDateTimeUtc, @Submitted, @RequestData ) "))
        {
            insert.AddParameter("@RequestName", requestName.ToString("G"));
            insert.AddParameter("@RequestedDateTimeUtc", DateTime.UtcNow);
            insert.AddParameter("@Submitted", 0);
            insert.AddParameter("@RequestData", requestData.TrimStart('?'));

            Int32 wkCount = insert.ExecuteNonQuery();
            if (wkCount == 1)
                return true;
            else
                return false;
        }
    }

    /// <summary>
    /// This method should only be called by the BackgroundProcessor to actually execute the background process.
    /// </summary>
    /// <param name="requestName"></param>
    /// <param name="requestData"></param>
    /// <returns></returns>
    public Boolean RunManualStep(string requestName, string requestData)
    {
        Logger.Info("Running background process: " + requestName + " with keys: " + requestData);

        switch (requestName)
        {

            case "ABLELocalFileToS3":
                MoveFileToS3.Do(requestData);
                break;
            default:
                Logger.Info("Unknown background process Request Name: " + requestName);
                break;
        }

        return true;
    }

}

