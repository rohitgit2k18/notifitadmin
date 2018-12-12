using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Payments;
using CommerceBuilder.Payments.Providers.PayPal;
using CommerceBuilder.Orders;
using CommerceBuilder.Shipping;
using CommerceBuilder.Utility;
using PayPal.PayPalAPIInterfaceService.Model;

namespace AbleCommerce
{
public partial class PayPalExpressCheckout : CommerceBuilder.UI.AbleCommercePage
{
    protected void Page_Load(object sender, System.EventArgs e)
    {
        string action = AlwaysConvert.ToString(Request.QueryString["Action"]).Trim().ToUpperInvariant();
        switch (action)
        {
            case "GET":
                GetExpressCheckout();
                break;
            case "RETRY":
            case "SET":
                ExpressCheckoutSession.Delete(CommerceBuilder.Common.AbleContext.Current.User);
                SetExpressCheckout(false);
                break;
            case "SETBML":
                ExpressCheckoutSession.Delete(CommerceBuilder.Common.AbleContext.Current.User);
                SetExpressCheckout(true);
                break;
            case "DO":
                DoExpressCheckout();
                break;
            case "CANCEL":
                CancelExpressCheckout();
                break;
            case "ERROR":
                DisplayExpressCheckoutErrors();
                break;
            default:
                RedirectWithDefaultError();
                break;
        }
    }

    private void CancelExpressCheckout()
    {
        ExpressCheckoutSession.Delete(CommerceBuilder.Common.AbleContext.Current.User);
        string sReturnURL = Request.QueryString["ReturnURL"];
        if (!string.IsNullOrEmpty(sReturnURL))
        {
            switch (sReturnURL)
            {
                case "REF":
                    Response.Redirect(Request.UrlReferrer.ToString());
                    break;
                case "PAY":
                    Response.Redirect(AbleCommerce.Code.NavigationHelper.GetPaymentUrl());
                    break;
                case "SHIP":
                    Response.Redirect(AbleCommerce.Code.NavigationHelper.GetShipMethodUrl());
                    break;
            }
        }
        Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
    }

    private void SetExpressCheckout(bool isBmlRequest)
    {
        PayPalProvider client = AbleCommerce.Code.StoreDataHelper.GetPayPalProvider();
        PayPalProvider.ExpressCheckoutResult result = client.SetExpressCheckout(isBmlRequest);

        // IF ERRORS ARE PRESENT, REDIRECT TO DISPLAY THEM
        if (result.Errors != null) RedirectWithErrors(result.Errors);

        // NO ERRORS FOUND, SEND TO SPECIFIED REDIRECT URL
        Response.Redirect(result.RedirectUrl);
    }

    private void GetExpressCheckout()
    {
        PayPalProvider client = AbleCommerce.Code.StoreDataHelper.GetPayPalProvider();
        GetExpressCheckoutResult result = client.GetExpressCheckout();

        // IF ERRORS ARE PRESENT, REDIRECT TO DISPLAY THEM
        if (result.Errors != null) RedirectWithErrors(result.Errors);

        // NO ERRORS FOUND, IF THERE ARE SHIPPABLE ITEMS REDIRECT TO SELECTSHIPPING METHOD
        Basket paypalBasket = result.PayPalUser.Basket;
        if (paypalBasket.Items.HasShippableProducts()) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetShipMethodUrl());

        // NO SHIPPABLE ITEMS, SHOW THE PAYMENT / CONFIRMATION PAGE
        Response.Redirect(AbleCommerce.Code.NavigationHelper.GetPaymentUrl());
    }

    private void DoExpressCheckout()
    {
        PayPalProvider client = AbleCommerce.Code.StoreDataHelper.GetPayPalProvider();
        PayPalProvider.ExpressCheckoutResult result = client.DoExpressCheckout();

        // LOOK FOR AN ORDERID TO INDICATE THE CHECKOUT SUCCEEDED
        if (result.OrderId != 0)
        {
            // ORDER ID LOCATED, SEND TO THE RECEIPT PAGE
            Order order = OrderDataSource.Load(result.OrderId);
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetReceiptUrl(order.OrderNumber));
        }

        // THE CHECKOUT FAILED, SEE IF WE HAVE ERRORS AVAIALBLE
        if (result.Errors != null && result.Errors.Count > 0)
            RedirectWithErrors(result.Errors);

        // NO ERRORS AVAILABLE, USE DEFAULT
        RedirectWithDefaultError();
    }

    /// <summary>
    /// Redirects to error page to prevent refresh from causing a retry attempt
    /// </summary>
    /// <param name="errors">The error(s) that occurred during the operation.</param>
    private void RedirectWithErrors(IList<ErrorType> errors)
    {
        List<string> errorsList = new List<string>();
        foreach (ErrorType error in errors)
        {
            byte[] data = XmlUtility.Serialize(error);
            string xml = XmlUtility.Utf8BytesToString(data);
            errorsList.Add(xml);
        }
        string[] checkoutErrors = errorsList.ToArray();
        Session["PayPalExpressCheckoutErrors"] = checkoutErrors;
        Response.Redirect("PayPalExpressCheckout.aspx?Action=ERROR");
    }

    /// <summary>
    /// Redirects to error page with a default error message
    /// </summary>
    private void RedirectWithDefaultError()
    {
        // CHECKOUT FAILED AND NO ERROR MESSAGE IS INDICATED
        // SET A DEFAULT MESSAGE AND REDIRECT
        ErrorType defaultError = new ErrorType();
        defaultError.ErrorCode = "ORDER";
        defaultError.SeverityCode = SeverityCodeType.ERROR;
        defaultError.ShortMessage = "The checkout could not be completed and your payment was not processed.";
        defaultError.LongMessage = "The checkout could not be completed and your payment was not processed.";
        ErrorType[] errors = { defaultError };
        RedirectWithErrors(errors);
    }

    private void DisplayExpressCheckoutErrors()
    {
        string[] checkoutErrors = Session["PayPalExpressCheckoutErrors"] as string[];
        List<ErrorType> errorTypeList = new List<ErrorType>();
        if (checkoutErrors != null)
        {
            foreach (string xml in checkoutErrors)
            {
                ErrorType errorType = (ErrorType)XmlUtility.Deserialize(xml, typeof(ErrorType));
                errorTypeList.Add(errorType);
            }
        }

        // LOOK FOR ERRORS IN SESSION TO DISPLAY
        ErrorType[] errors = errorTypeList.ToArray();

        // TRACK WHETHER WE HAVE AN ORDER ERROR - ORDER ERRORS SHOULD NOT PROVIDE A RETRY OPTION
        bool orderErrorFound = false;

        // DISPLAY ADDITIONAL ERROR MESSAGES (IF AVAILABLE)
        if (errors != null && errors.Length > 0)
        {
            foreach (ErrorType error in errors)
            {
                if (error.ErrorCode == "ORDER") orderErrorFound = true;
                ErrorList.Items.Add(error.LongMessage);
            }
        }

        // UPDATE VISIBLE BUTTONS BASED ON PRESENCE OF ORDER ERROR
        BasketLink.Visible = orderErrorFound;
        RetryLink.Visible = !orderErrorFound;
        CancelLink.Visible = !orderErrorFound;
    }
}}
