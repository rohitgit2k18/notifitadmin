using System;
using System.Web;


	/// <summary>
	/// Summary description for PageNotFound.
	/// </summary>
    namespace AbleCommerce.Errors
{
public partial class PageNotFound : System.Web.UI.Page
	{
        protected override void Render(System.Web.UI.HtmlTextWriter writer)
        {
            base.Render(writer);
            Response.Status = "404 Not Found";
        }
	}

}
