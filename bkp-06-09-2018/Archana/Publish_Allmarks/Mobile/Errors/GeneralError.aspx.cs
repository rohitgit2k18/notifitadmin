using System;
using System.Web;
using CommerceBuilder.Common;

	/// <summary>
	/// Summary description for GeneralError.
	/// </summary>
	namespace AbleCommerce.Mobile.Errors
{
public partial class GeneralError : CommerceBuilder.UI.AbleCommercePage
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
