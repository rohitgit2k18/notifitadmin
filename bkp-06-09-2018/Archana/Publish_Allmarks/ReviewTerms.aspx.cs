using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;

namespace AbleCommerce
{
    public partial class ReviewTerms : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TermsAndConditions.Text = AbleContext.Current.Store.Settings.ProductReviewTermsAndConditions;
        }
    }
}