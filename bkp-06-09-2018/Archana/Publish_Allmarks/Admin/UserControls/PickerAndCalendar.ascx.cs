namespace AbleCommerce.Admin.UserControls
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Utility;

    public partial class PickerAndCalendar : System.Web.UI.UserControl
    {
        public string PickerClientId
        {
            get
            {
                return Picker1.ClientID;
            }
        }

        public DateTime SelectedDate
        {
            get
            {
                return AlwaysConvert.ToDateTime(Picker1.Text, DateTime.MinValue);
            }
            set
            {
                if (value == null || value == DateTime.MinValue || value == DateTime.MaxValue)
                {
                    Picker1.Text = string.Empty;
                }
                else
                {
                    Picker1.Text = string.Format("{0:d}", value);
                }
            }
        }

        public DateTime? NullableSelectedDate
        {
            get
            {
                DateTime retval = this.SelectedDate;
                if (retval == DateTime.MinValue) return null;
                return new DateTime(retval.Year, retval.Month, retval.Day, retval.Hour, retval.Second, retval.Millisecond);
            }
            set
            {
                DateTime dateTime = value ?? DateTime.MinValue;
                this.SelectedDate = dateTime;
            }
        }

        /// <summary>
        /// Returns the selected date with the time set to the end of the day.
        /// </summary>
        public DateTime SelectedEndDate
        {
            get
            {
                DateTime retval = this.SelectedDate;
                if (retval == DateTime.MinValue) return retval;
                return new DateTime(retval.Year, retval.Month, retval.Day, 23, 59, 59, DateTimeKind.Local);
            }
        }

        /// <summary>
        /// Returns the selected date with the time set to the beginning of the day.
        /// </summary>
        public DateTime SelectedStartDate
        {
            get
            {
                DateTime retval = this.SelectedDate;
                if (retval == DateTime.MinValue) return retval;
                return new DateTime(retval.Year, retval.Month, retval.Day, 0, 0, 0, DateTimeKind.Local);
            }
        }

        /// <summary>
        /// Returns the nullable selected date with the time set to the end of the day.
        /// </summary>
        public DateTime? NullableSelectedEndDate
        {
            get
            {
                DateTime retval = this.SelectedDate;
                if (retval == DateTime.MinValue) return null;
                return new DateTime(retval.Year, retval.Month, retval.Day, 23, 59, 59, DateTimeKind.Local);
            }
        }

        /// <summary>
        /// Returns the nullable selected date with the time set to the beginning of the day.
        /// </summary>
        public DateTime? NullableSelectedStartDate
        {
            get
            {
                DateTime retval = this.SelectedDate;
                if (retval == DateTime.MinValue) return null;
                return new DateTime(retval.Year, retval.Month, retval.Day, 0, 0, 0, DateTimeKind.Local);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.ClientScript.IsStartupScriptRegistered("PICKER_AND_CALENDAR_INIT"))
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "PICKER_AND_CALENDAR_INIT", "<script>Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function(evt, args){$.datepicker.setDefaults($.datepicker.regional['" + (System.Threading.Thread.CurrentThread.CurrentCulture.Name == "en-US" ? "" : System.Threading.Thread.CurrentThread.CurrentCulture.Name) + "']); $(\".pickerAndCalendar\").datepicker();});</script>");
            }
        }
    }
}