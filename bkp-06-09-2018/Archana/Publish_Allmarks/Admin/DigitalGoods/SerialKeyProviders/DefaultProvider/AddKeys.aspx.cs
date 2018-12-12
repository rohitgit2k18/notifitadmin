namespace AbleCommerce.Admin.DigitalGoods.SerialKeyProviders.DefaultProvider
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.DigitalDelivery;
    using CommerceBuilder.Utility;

    public partial class AddKeys : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private DigitalGood _DigitalGood;
        private string _SerialKeyProviderId;

        protected void Page_Load(object sender, EventArgs e)
        {
            int digitalGoodId = AlwaysConvert.ToInt(Request.QueryString["DigitalGoodId"]);
            _DigitalGood = DigitalGoodDataSource.Load(digitalGoodId);
            if (_DigitalGood == null) Response.Redirect("~/Admin/DigitalGoods/DigitalGoods.aspx");
            _SerialKeyProviderId = Misc.GetClassId(typeof(DefaultSerialKeyProvider));
            Caption.Text = string.Format(Caption.Text, _DigitalGood.Name);
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Configure.aspx?DigitalGoodId=" + _DigitalGood.Id.ToString());
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            ErrorMessagePanel.Visible = false;
            if (Page.IsValid)
            {
                string inputData = SerialKeyData.Text;
                string delimiter;
                switch (KeyDelimiter.SelectedIndex)
                {
                    case 2: delimiter = ","; break;
                    case 1: delimiter = "\r\n\r\n"; break;
                    default: delimiter = "\r\n"; break;
                }
                string[] delimiterArray = { delimiter };
                string[] keys = inputData.Split(delimiterArray, StringSplitOptions.RemoveEmptyEntries);

                List<string> duplicateKeys = new List<string>();
                string key;
                bool added = false;
                foreach (string tkey in keys)
                {
                    key = tkey.Trim();
                    if (_DigitalGood.HasSerialKey(key))
                    {
                        duplicateKeys.Add(key);
                    }
                    else
                    {
                        SerialKey skey = new SerialKey();
                        skey.SerialKeyData = key;
                        skey.DigitalGoodId = _DigitalGood.Id;
                        _DigitalGood.SerialKeys.Add(skey);
                        added = true;
                    }
                }
                if (added)
                {
                    _DigitalGood.SerialKeys.Save();
                }
                if (duplicateKeys.Count == 0)
                {
                    // redirect to configure page
                    CancelButton_Click(sender, e);
                }
                else
                {
                    //show error messages regarding duplicate keys
                    ErrorMessageList.Items.Clear();
                    ErrorMessagePanel.Visible = true;
                    foreach (string skey in duplicateKeys)
                    {
                        ListItem item = new ListItem(skey);
                        ErrorMessageList.Items.Add(item);
                    }
                }
            }
        }
    }
}