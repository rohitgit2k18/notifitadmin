namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Common;

    [Description("Displays a register button for anonymous users during checkout process.")]
    public partial class CheckoutRegisterButtonDialog : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            InstructionText.Text = string.Format(InstructionText.Text, AbleContext.Current.Store.Name);
        }

        protected void RegisterButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("CreateProfile.aspx");
        }
    }
}