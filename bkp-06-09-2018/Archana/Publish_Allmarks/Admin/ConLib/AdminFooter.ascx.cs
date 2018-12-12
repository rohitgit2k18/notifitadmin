using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.ConLib
{
    public partial class AdminFooter : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime dt = DateTime.Now;
            ProductVersion.Text = "AbleCommerce " + AbleContext.Current.ReleaseLabel + " (build " + AbleContext.Current.Version.Revision.ToString() + ")";
            copyright.Text = dt.Year.ToString();
        }
    }
}