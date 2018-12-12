using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Web;
using Redi.Utility;
using System.Data.Common;
using CommerceBuilder.Utility;


public class BackgroundProcessor
{
    private static Timer threadingTimer;

    /// <summary>
    /// This method kicks off the separate timer thread that will call ProcessInterval every x minutes.
    /// This should be called by Application_Start within Global.asax for the website.
    /// </summary>
    public static void StartBackgroundProcessTimer()
    {

        if (null == threadingTimer)
        {
            Logger.Info("Starting Background Processor Timer");
            DateTime wkCurrPerth = DateTime.UtcNow.AddHours(8);
            TimeSpan currTS = new TimeSpan(wkCurrPerth.Ticks);
            DateTime wkMidnight = wkCurrPerth.AddDays(1).Date;
            TimeSpan mnTS = new TimeSpan(wkMidnight.Ticks);
            long millisecondsDiff = Convert.ToInt64(mnTS.TotalMilliseconds - currTS.TotalMilliseconds) + 60000; // plus 1 minute

            // runs every 1 minute to look for work.
            threadingTimer = new Timer(new TimerCallback(BackgroundProcessStarter),
                                         HttpContext.Current, 60000 / 2, 1 * 60000);
        }
    }

    private static void BackgroundProcessStarter(object sender)
    {
        DateTime wkCurrPerth = DateTime.UtcNow.AddHours(8);

        try
        {
            // Process any manually submitted jobs (submitted via MSM or other means)
            List<JobRequest> jobs = AnyManualJobsRequired();
            if (jobs != null && jobs.Count > 0)
            {
                foreach (JobRequest job in jobs)
                {
                    ProcessRequest manualProcess = new ProcessRequest();
                    if (CheckRunManualJob(job))
                        manualProcess.RunManualStep(job.Name, job.RequestData);
                }
            }
        }
        catch (Exception ex)
        {
            Logger.Info("Manually submitted jobs terminated abnormally " + ex.Message + ex.StackTrace);
        }

    }

    /// <summary>
    /// Get any manually submitted jobs.  These are on the BatchJobQueue table.
    /// They are deleted from the table once they have been selected for processing.
    /// </summary>
    /// <returns></returns>
    private static List<JobRequest> AnyManualJobsRequired()
    {
        List<JobRequest> jobs = new List<JobRequest>();
        // safely get jobs that have been manually submitted  (exclude jobs prefixed with ABLE these are processed by the ABLE Commerce site.
        using (Redi.Utility.SqlText select = new SqlText(
            "Select DBID, RequestName, RequestedDateTimeUtc, Submitted, RequestData " +
            "From ALL_BatchJobQueue " +
            "Where Submitted = 0 AND DueDateTimeUtc <= @DueDateTimeUtc AND RequestName Like'ABLE%' "))
        {
            select.AddParameter("@DueDateTimeUtc", DateTime.UtcNow);
            DbDataReader myReader = select.ExecuteReader();
            while (myReader.Read())
            {
                JobRequest job = new JobRequest();
                job.RequestDBID = myReader.GetInt64(0);
                job.Name = myReader.GetString(1);
                job.RequestedAt = myReader.GetDateTime(2);
                job.Submitted = myReader.GetBoolean(3);
                job.RequestData = myReader.GetString(4).Trim('?');

                jobs.Add(job);
            }
        }
        return jobs;
    }

    private static Boolean CheckRunManualJob(JobRequest job)
    {

        using (Redi.Utility.SqlText delete = new SqlText(
            "Delete From ALL_BatchJobQueue " +
            "Where DBID = @DBID AND Submitted = 0 "))
        {
            delete.AddParameter("@DBID", job.RequestDBID);
            Int32 wkDelCnt = delete.ExecuteNonQuery();
            if (wkDelCnt == 0)
                return false;  // no row deleted, so don't run job (another server must have run it)
            else
                return true;  // row deleted so run job.
        }
    }
}

public struct JobRequest
{
    public string Name { get; set; }
    public string RequestData { get; set; }
    public Boolean Submitted { get; set; }
    public Int64 RequestDBID { get; set; }
    public DateTime RequestedAt { get; set; }

}

