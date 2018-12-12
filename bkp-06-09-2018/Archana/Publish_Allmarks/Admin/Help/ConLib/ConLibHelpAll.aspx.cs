namespace AbleCommerce.Admin.Help.Conlib
{
    using System;
    using CommerceBuilder.UI;
    
    public partial class ConLibHelpAll : AbleCommerceAdminPage
    {
        private ConLibControlCollection _ConLibControls;
        public ConLibControlCollection ConLibControls
        {
            get
            {
                if (_ConLibControls == null)
                {
                    if (Page.IsPostBack)
                    {
                        _ConLibControls = (ConLibControlCollection)Session["ConLibControls"];
                    }
                    if (_ConLibControls == null)
                    {
                        _ConLibControls = ConLibDataSource.Load();
                        Session["ConLibControls"] = _ConLibControls;
                    }
                }
                return _ConLibControls;
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            ConLibList.DataSource = ConLibControls;
            ConLibList.DataBind();
        }
    }
}