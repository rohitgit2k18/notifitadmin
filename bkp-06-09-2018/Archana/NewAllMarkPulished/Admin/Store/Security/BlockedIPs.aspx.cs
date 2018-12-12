using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text.RegularExpressions;
using CommerceBuilder.Common;
using CommerceBuilder.Catalog;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Reporting;
using System.Collections.Generic;

namespace AbleCommerce.Admin._Store.Security
{
public partial class BlockedIPs : CommerceBuilder.UI.AbleCommerceAdminPage
{


    protected void AddButton_Click(object sender, EventArgs e)
    {
        //validate start range
        string startIP = AddIPRangeStart.Text;
        if (!Regex.IsMatch(startIP, "^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$"))
        {
            CustomValidator invalidIP = new CustomValidator();
            invalidIP.IsValid = false;
            invalidIP.Text = "*";
            invalidIP.ErrorMessage = "Start IP is not valid.";
            AddIPRangeStart.Parent.Controls.Add(invalidIP);
            return;
        }
        
        //validate end range
        string endIP = AddIPRangeEnd.Text;
        if (string.IsNullOrEmpty(endIP)) endIP = startIP;
        if (!Regex.IsMatch(endIP, "^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$"))
        {
            CustomValidator invalidIP = new CustomValidator();
            invalidIP.IsValid = false;
            invalidIP.Text = "*";
            invalidIP.ErrorMessage = "EndIP is not valid.";
            AddIPRangeEnd.Parent.Controls.Add(invalidIP);
            return;
        }
        
        BannedIP block = new BannedIP();
        block.IPRangeStart = BannedIP.ConvertToNumber(startIP);
        block.IPRangeEnd = BannedIP.ConvertToNumber(endIP);
        //VALIDATE NUMBERS ARE IN CORRECT ORDER, SWAP IF NEEDED
        if (block.IPRangeStart > block.IPRangeEnd)
        {
            long temp = block.IPRangeStart;
            block.IPRangeStart = block.IPRangeEnd;
            block.IPRangeEnd = temp;
        }
        //VALIDATE MY IP ISNT IN RANGE
        if (block.IsInRange(Request.UserHostAddress)) {
            CustomValidator invalidIP = new CustomValidator();
            invalidIP.IsValid = false;
            invalidIP.Text = "*";
            invalidIP.ErrorMessage = "You cannot block a range that includes your own IP!";
            AddIPRangeStart.Parent.Controls.Add(invalidIP);
            return;
        }
        
        //SAVE RANGE
        block.Comment = AddComment.Text;
        block.Save();

        //RESET FORM
        AddedMessage.Visible = true;
        AddIPRangeStart.Text = string.Empty;
        AddIPRangeEnd.Text = string.Empty;
        AddComment.Text = string.Empty;

        //REBIND GRID
        BannedIPGrid.DataBind();
        GridAjax.Update();
    }

}
}
