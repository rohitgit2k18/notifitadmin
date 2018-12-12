using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Services.Scheduler;
using CommerceBuilder.Services;

namespace AbleCommerce.Install
{
    public partial class InvokeServices : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void InvokeRecurringOrderServiceButton_Click(object sender, EventArgs e)
        {
            AbleContext.Container.Resolve<IRecurringOrdersService>()
                .ProcessRecurringOrders();
            MeesageLabel.Text = string.Format("'RecurringOrderService' Invoked At {0}", DateTime.Now);
        }

        protected void MaintenanceServiceButton_Click(object sender, EventArgs e)
        {
            AbleContext.Container.Resolve<IMaintenanceWorker>()
                .RunMaintenance();
            MeesageLabel.Text = string.Format("'MaintenanceWorker' Invoked At {0}", DateTime.Now);
        }

        protected void ReviewReminderServiceButton_Click(object sender, EventArgs e)
        {
            AbleContext.Container.Resolve<IReviewReminderService>()
                .Work();
            MeesageLabel.Text = string.Format("'ReviewReminderService' Invoked At {0}", DateTime.Now);
        }
    }
}