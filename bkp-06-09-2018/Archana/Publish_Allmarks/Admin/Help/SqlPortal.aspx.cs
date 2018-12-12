namespace AbleCommerce.Admin.Help
{
    using System;
    using System.Collections;
    using System.Text;
    using System.Web.UI;
    using CommerceBuilder.DomainModel;

    public partial class SqlPortal : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        // TO DISABLE THE SCRIPT, SET THE PortalEnabled VARIABLE TO false
        // e.g. private static bool PortalEnabled = false;
        // TO ENABLE THE SCRIPT, SET THE PortalEnabled VARIABLE TO true
        // e.g. private static bool PortalEnabled = true;
        private static bool PortalEnabled = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!PortalEnabled)
            {
                SqlQuery.Visible = false;
                ExecuteButton.Visible = false;
                SqlQueryLabel.Text = "The sql portal must be enabled by making a modification to the script file.";
            }
        }

        protected void ExecuteButton_Click(object sender, EventArgs e)
        {
            if (PortalEnabled)
            {
                DateTime beginTime = DateTime.Now;
                StringBuilder dataTable = new StringBuilder();
                try
                {
                    IList result = NHibernateHelper.CreateSQLQuery(SqlQuery.Text).List();
                    dataTable.Append("<div style=\"overflow:auto\"><table border=\"1\">");
                    foreach (object[] dataRow in result)
                    {
                        int columnCount = dataRow.Length;
                        dataTable.Append("<tr>");
                        for (int i = 0; i < columnCount; i++)
                        {
                            dataTable.Append("<td>" + dataRow[i].ToString() + "</td>");
                        }
                        dataTable.Append("</tr>");
                    }
                    dataTable.Append("</table></div><br />");
                }
                catch { }
                DateTime endTime = DateTime.Now;
                phQueryResult.Controls.Add(new LiteralControl(dataTable.ToString()));
                TimeSpan ts = endTime - beginTime;
                phQueryResult.Controls.Add(new LiteralControl("Query executed in " + Math.Round(ts.TotalMilliseconds, 0) + "ms"));
            }
        }
    }
}