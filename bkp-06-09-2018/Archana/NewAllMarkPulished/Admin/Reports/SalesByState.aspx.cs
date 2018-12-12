using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.DataVisualization.Charting;
using System.Web.UI.WebControls;
using CommerceBuilder.Utility;
using CommerceBuilder.Common;
using CommerceBuilder.DomainModel;
using CommerceBuilder.Orders;
using CommerceBuilder.Reporting;
using CommerceBuilder.Shipping;
using NHibernate;
using NHibernate.Criterion;
using NHibernate.Transform;

namespace AbleCommerce.Admin.Reports
{
    public partial class SalesByStateReport : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // set default start/end date range
                // use query parameters if found, otherwise default to start beginning of current month ending current day
                DateTime localNow = LocaleHelper.LocalNow;
                StartDate.SelectedDate = AlwaysConvert.ToDateTime(Request.QueryString["SDate"], new DateTime(localNow.Year, localNow.Month, 1));
                EndDate.SelectedDate = AlwaysConvert.ToDateTime(Request.QueryString["EDate"], new DateTime(localNow.Year, localNow.Month, DateTime.DaysInMonth(localNow.Year, localNow.Month)));

                // set up country list
                list_Country.DataSource = CountryDataSource.LoadAll();
                list_Country.DataTextField = "Name";
                list_Country.DataValueField = "CountryCode";
                list_Country.DataBind();

                // set country to default to primary warehouse country
                string defCountry = Request.QueryString["CountryCode"];
                if (string.IsNullOrEmpty(defCountry))
                {
                    defCountry = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                }
                ListItem findItem = list_Country.Items.FindByValue(defCountry);
                if (findItem != null)
                {
                    list_Country.SelectedIndex = list_Country.Items.IndexOf(findItem);
                }

                // fire immediate report
                ProcessButton_Click(null, null);
            }
        }

        protected void ProcessButton_Click(object sender, EventArgs e)
        {
            // build data
            int maxItems = AlwaysConvert.ToInt(list_TopCount.SelectedValue, 10);
            IList<SalesByProvinceSummary> rptData = ReportDataSource.GetSalesByState(list_Country.SelectedValue, StartDate.SelectedDate, EndDate.SelectedDate, maxItems, 0, "TotalSales DESC");

            Chart1.Visible = rptData.Count > 0;
            BuildCharts(rptData);
        }

        private void BuildCharts(IList<SalesByProvinceSummary> data)
        {
            // reset chart points
            Chart1.Series["Default"].Points.Clear();

            // populate data points
            foreach (SalesByProvinceSummary summary in data)
            {
                // set point label
                string summaryLabel = summary.Province != null ? summary.Province.Name : summary.BillToProvince;

                // set count chart value
                Chart1.Series["Default"].Points.AddXY(summaryLabel, summary.TotalSales);
            }

            // set chart 1 settings
            Chart1.Series["Default"].ChartType = SeriesChartType.Pie;
            Chart1.Series["Default"].Label = "#VALX";
            //Chart1.Series["Default"].LegendText = "#VALX";

            Chart1.Series["Default"]["PieLabelStyle"] = "Outside";
            
            Chart1.ChartAreas["ChartArea1"].Area3DStyle.Enable3D = true;

            // bind datagrid
            grd_Sales.DataSource = data;
            grd_Sales.DataBind();
        }

        protected string GetProvinceName(object dataItem)
        {
            // bind object
            SalesByProvinceSummary summary = (SalesByProvinceSummary) dataItem;
            return summary.Province != null ? summary.Province.Name : summary.BillToProvince;
        }
    }
}