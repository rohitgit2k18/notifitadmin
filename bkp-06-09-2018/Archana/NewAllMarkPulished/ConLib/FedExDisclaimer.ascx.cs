namespace AbleCommerce.ConLib
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.ComponentModel;

    [Description("Control to display FedEx disclaimer")]
    public partial class FedExDisclaimer : System.Web.UI.UserControl
    {
        protected void Page_PreRender(object sender, EventArgs e)
        {
            D.Visible = FindFedEx(this.Page.Controls);
        }

        private bool FindFedEx(ControlCollection controls)
        {
            foreach (Control c in controls)
            {
                if (c.GetType().Equals(typeof(Label)))
                {
                    if (((Label)c).Text.Contains("FedEx ")) return true;
                }
                else if (c.GetType().Equals(typeof(DropDownList)))
                {
                    foreach (ListItem item in ((DropDownList)c).Items)
                    {
                        if (item.Text.Contains("FedEx ")) return true;
                    }
                }

                if (c.HasControls())
                {
                    if (FindFedEx(c.Controls)) return true;
                }
            }
            return false;
        }
    }
}