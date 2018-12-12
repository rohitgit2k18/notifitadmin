using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.DomainModel;
using CommerceBuilder.Utility;
using NHibernate;

namespace AbleCommerce.Admin.Reports
{

    public partial class DBConnections : System.Web.UI.Page
    {

        public class RptData
        {
            public string Spid { get; set; }
            public string Status { get; set; }
            public string Login { get; set; }
            public string HostName { get; set; }
            public string BlkBy { get; set; }
            public string DbName { get; set; }
            public string Command { get; set; }
            public string CPUTime { get; set; }
            public string DiskIO { get; set; }
            public string LastBatch { get; set; }
            public string ProgramName { get; set; }
            public string SPID2 { get; set; }
            public string Request { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        private void BindData()
        {
            // get database name
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["AbleCommerce"].ConnectionString);
            string dbName = con.Database;

            // build query
            StringBuilder queryStr = new StringBuilder();
            queryStr.Append("DECLARE @SPWHO2 TABLE (SPID VARCHAR(1000), [Status] VARCHAR(1000) NULL, [Login] VARCHAR(1000) NULL");
            queryStr.Append(", HostName VARCHAR(1000) NULL, BlkBy VARCHAR(1000) NULL, DBName VARCHAR(1000) NULL, Command VARCHAR(1000) NULL");
            queryStr.Append(", CPUTime VARCHAR(1000) NULL, DiskIO VARCHAR(1000) NULL, LastBatch VARCHAR(1000) NULL, ProgramName VARCHAR(1000) NULL");
            queryStr.Append(", SPID2 VARCHAR(1000) NULL, Request VARCHAR(1000) NULL) ");
            queryStr.Append("INSERT INTO @SPWHO2 EXEC sp_who2");
            if (ActiveOnly.Checked)
            {
                queryStr.Append(" 'Active' ");
            }

            queryStr.Append(" SELECT * FROM @SPWHO2 WHERE DBName = :dbName");

            var nhQuery = NHibernateHelper.CreateSQLQuery(queryStr.ToString())
                .SetString("dbName", dbName);

            // execute query
            var results = nhQuery.List();

            // parse results
            IList<RptData> finalData = new List<RptData>();
            foreach (object[] resultRow in results)
            {
                RptData row = new RptData();
                row.Spid = (string)resultRow[0];
                row.Status = (string)resultRow[1];
                row.Login = (string)resultRow[2];
                row.HostName = (string)resultRow[3];
                row.BlkBy = (string)resultRow[4];
                row.DbName = (string)resultRow[5];
                row.Command = (string)resultRow[6];
                row.CPUTime = (string)resultRow[7];
                row.DiskIO = (string)resultRow[8];
                row.LastBatch = (string)resultRow[9];
                row.ProgramName = (string)resultRow[10];
                row.SPID2 = (string)resultRow[11];
                row.Request = (string)resultRow[12];
                finalData.Add(row);
            }

            ConnectionsGrid.DataSource = finalData;
            ConnectionsGrid.DataBind();

            // summarize data
            ConnectionsCount.Text = finalData.Count.ToString();

            if (Session["LastCount"] != null)
            {
                int lastCount = AlwaysConvert.ToInt(Session["LastCount"], 0);
                int diff = finalData.Count - lastCount;
                Changed.Text = diff.ToString();
            }
            else
                Changed.Text = "n/a";

            Session["LastCount"] = finalData.Count.ToString();

        }


        protected void CheckConnections_OnClick(object sender, EventArgs e)
        {
            BindData();
        }

        protected void ConnectionsGrid_OnSorting(object sender, GridViewSortEventArgs e)
        {
            if (e.SortExpression != ConnectionsGrid.SortExpression) e.SortDirection = System.Web.UI.WebControls.SortDirection.Descending;
        }
    }
}