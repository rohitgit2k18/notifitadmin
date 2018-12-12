namespace AbleCommerce.Install
{
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Common;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Web;
    using System.Web.Configuration;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public partial class FixUserConstraints : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void FixButton_Click(object sender, EventArgs e)
        {
            string connectString = WebConfigurationManager.ConnectionStrings["AbleCommerce"].ConnectionString.ToString();
            using (SqlConnection connection = new SqlConnection(connectString))
            {
                connection.Open();
                string sql = @"IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'ac_Orders'
                            AND CONSTRAINT_NAME = 'ac_Users_ac_Orders_FK1')
                            BEGIN
                                ALTER TABLE ac_Orders
                                DROP CONSTRAINT ac_Users_ac_Orders_FK1
                            END;

                                ALTER TABLE ac_Orders ADD CONSTRAINT ac_Users_ac_Orders_FK1
                                FOREIGN KEY (UserId) REFERENCES ac_Users (UserId)
                                ON UPDATE NO ACTION ON DELETE SET NULL";

                using (SqlCommand command = GetCommand(connection, sql))
                {
                    command.ExecuteNonQuery();
                }
                connection.Close();

                FixPanel.Visible = false;
                ResultPanel.Visible = true;
                AdminLink.NavigateUrl = NavigationHelper.GetAdminUrl("Default.aspx");
            }
        }

        private SqlCommand GetCommand(SqlConnection connection, string sql)
        {
            SqlCommand command = new SqlCommand();
            command.Connection = connection;
            command.CommandType = CommandType.Text;
            command.CommandText = sql;
            return command;
        }
    }
}