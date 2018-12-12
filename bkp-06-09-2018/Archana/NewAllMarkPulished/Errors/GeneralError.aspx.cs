using System;
using System.Web;
using CommerceBuilder.Common;

	/// <summary>
	/// Summary description for GeneralError.
	/// </summary>
	namespace AbleCommerce.Errors
{
public partial class GeneralError : System.Web.UI.Page
	{
		private void Page_Load(object sender, System.EventArgs e)
		{
        
		}

        public string GetContact() 
        {
            if (AbleContext.Current.Store != null && !String.IsNullOrEmpty(AbleContext.Current.Store.DefaultWarehouse.Email))
                return AbleContext.Current.Store.DefaultWarehouse.Email;
            return "us";
        }
	}
}
