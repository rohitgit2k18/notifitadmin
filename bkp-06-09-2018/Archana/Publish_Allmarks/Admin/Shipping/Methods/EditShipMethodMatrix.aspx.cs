namespace AbleCommerce.Admin.Shipping.Methods
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class EditShipMethodMatrix : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        int _ShipMethodId;
        ShipMethod _ShipMethod;

        protected void Page_Init(object sender, System.EventArgs e)
        {
            _ShipMethodId = AlwaysConvert.ToInt(Request.QueryString["ShipMethodId"]);
            _ShipMethod = ShipMethodDataSource.Load(_ShipMethodId);
            if (_ShipMethod == null) RedirectMe();
            //BIND TAX CODES
            IList<TaxCode> taxCodes = AbleContext.Current.Store.TaxCodes;
            TaxCode.DataSource = taxCodes;
            TaxCode.DataBind();
            ListItem item = TaxCode.Items.FindByValue(_ShipMethod.TaxCodeId.ToString());
            if (item != null) TaxCode.SelectedIndex = TaxCode.Items.IndexOf(item);

            SurchargeTaxCode.DataSource = taxCodes;
            SurchargeTaxCode.DataBind();
            item = SurchargeTaxCode.Items.FindByValue(_ShipMethod.SurchargeTaxCodeId.ToString());
            if (item != null) SurchargeTaxCode.SelectedIndex = SurchargeTaxCode.Items.IndexOf(item);
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            Caption.Text = string.Format(Caption.Text, _ShipMethod.Name);
            RateMatrixHelpText.Text = string.Format(RateMatrixHelpText.Text, GetMatrixType());
            if (!Page.IsPostBack)
            {
                Name.Text = _ShipMethod.Name;
                ShipMethodType.Text = AbleCommerce.Code.StoreDataHelper.GetFriendlyShipMethodType(_ShipMethod);
                BindShipRateMatrix();
                if (_ShipMethod.Surcharge > 0) Surcharge.Text = string.Format("{0:F2}", _ShipMethod.Surcharge);
                SurchargeMode.SelectedIndex = _ShipMethod.SurchargeModeId;
                SurchargeIsVisible.SelectedIndex = AlwaysConvert.ToBool(_ShipMethod.SurchargeIsVisible == true) ? 1 : 0;
                UseWarehouseRestriction.SelectedIndex = (_ShipMethod.Warehouses.Count == 0) ? 0 : 1;
                BindWarehouses();
                UseZoneRestriction.SelectedIndex = (_ShipMethod.ShipZones.Count == 0) ? 0 : 1;
                BindZones();
                UseGroupRestriction.SelectedIndex = (_ShipMethod.Groups.Count == 0) ? 0 : 1;
                BindGroups();
                if (_ShipMethod.MinPurchase > 0) MinPurchase.Text = string.Format("{0:F2}", _ShipMethod.MinPurchase);
                if (_ShipMethod.MaxPurchase > 0) MaxPurchase.Text = string.Format("{0:F2}", _ShipMethod.MaxPurchase);
            }
            trSurchargeTaxCode.Visible = _ShipMethod.SurchargeIsVisible;
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(Surcharge);
        }

        protected void RedirectMe()
        {
            Response.Redirect("Default.aspx");
        }

        protected void UseWarehouseRestriction_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindWarehouses();
        }

        protected void BindWarehouses()
        {
            WarehouseListPanel.Visible = (UseWarehouseRestriction.SelectedIndex > 0);
            if (WarehouseListPanel.Visible)
            {
                WarehouseList.DataSource = WarehouseDataSource.LoadAll("Name");
                WarehouseList.DataBind();
                if (WarehouseList.Items.Count > 4) WarehouseList.Rows = 8;
                foreach (Warehouse item in _ShipMethod.Warehouses)
                {
                    ListItem listItem = WarehouseList.Items.FindByValue(item.Id.ToString());
                    if (listItem != null) listItem.Selected = true;
                }
            }
        }

        protected void UseZoneRestriction_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindZones();
        }

        protected void BindZones()
        {
            ZoneListPanel.Visible = (UseZoneRestriction.SelectedIndex > 0);
            if (ZoneListPanel.Visible)
            {
                ZoneList.DataSource = ShipZoneDataSource.LoadAll("Name");
                ZoneList.DataBind();
                if (ZoneList.Items.Count > 4) ZoneList.Rows = 8;
                foreach (ShipZone item in _ShipMethod.ShipZones)
                {
                    ListItem listItem = ZoneList.Items.FindByValue(item.Id.ToString());
                    if (listItem != null) listItem.Selected = true;
                }
            }
        }

        protected void UseGroupRestriction_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindGroups();
        }

        protected void BindGroups()
        {
            GroupListPanel.Visible = (UseGroupRestriction.SelectedIndex > 0);
            if (GroupListPanel.Visible)
            {
                GroupList.DataSource = GroupDataSource.LoadAll("Name");
                GroupList.DataBind();
                foreach (CommerceBuilder.Users.Group item in _ShipMethod.Groups)
                {
                    ListItem listItem = GroupList.Items.FindByValue(item.Id.ToString());
                    if (listItem != null) listItem.Selected = true;
                }
            }
        }

        protected void BindShipRateMatrix()
        {
            List<ShipRateMatrix> rows = new List<ShipRateMatrix>();
            if (_ShipMethod.ShipRateMatrices.Count == 0)
            {
                //ADD A DEFAULT ROW
                ShipRateMatrix item = new ShipRateMatrix();
                item.ShipMethod = _ShipMethod;
                _ShipMethod.ShipRateMatrices.Add(item);
                _ShipMethod.Save();
            }
            foreach (ShipRateMatrix item in _ShipMethod.ShipRateMatrices)
            {
                rows.Add(item);
            }
            rows.Sort(CompareShipRateMatrix);
            RateMatrixGrid.DataSource = rows;
            RateMatrixGrid.DataBind();
        }

        private string GetTextBoxValue(GridViewRow row, string controlId)
        {
            TextBox tb = row.FindControl(controlId) as TextBox;
            if (tb != null) return tb.Text.Trim();
            return string.Empty;
        }

        private bool GetCheckBoxValue(GridViewRow row, string controlId)
        {
            CheckBox cb = row.FindControl(controlId) as CheckBox;
            if (cb != null) return cb.Checked;
            return false;
        }

        protected void UpdateRanges()
        {
            //PROCESS MATRIX UPDATES
            int index = 0;
            foreach (GridViewRow row in RateMatrixGrid.Rows)
            {
                ShipRateMatrix matrixItem = _ShipMethod.ShipRateMatrices[index];
                string rangeStartValue = GetTextBoxValue(row, "RangeStart");
                if (!string.IsNullOrEmpty(rangeStartValue))
                {
                    matrixItem.RangeStart = AlwaysConvert.ToDecimal(rangeStartValue);
                }
                else
                {
                    matrixItem.RangeStart = null;
                }
                string rangeEndValue = GetTextBoxValue(row, "RangeEnd");
                if (!string.IsNullOrEmpty(rangeEndValue))
                {
                    matrixItem.RangeEnd = AlwaysConvert.ToDecimal(rangeEndValue);
                } 
                else
                {
                    matrixItem.RangeEnd = null;
                }
                matrixItem.Rate = AlwaysConvert.ToDecimal(GetTextBoxValue(row, "Rate"));
                matrixItem.IsPercent = GetCheckBoxValue(row, "IsPercent");
                index++;
            }
        }

        protected string GetMatrixType()
        {
            string matrixType = _ShipMethod.ShipMethodType.ToString();
            return matrixType.Replace("Based", "").Replace("([A-Z])", " $1").Trim();
        }

        protected int CompareShipRateMatrix(ShipRateMatrix x, ShipRateMatrix y)
        {
            if (!x.RangeStart.HasValue && !x.RangeEnd.HasValue && x.Rate.Equals(0)) return 1;
            if (!y.RangeStart.HasValue && !y.RangeEnd.HasValue && y.Rate.Equals(0)) return -1;

            // ASSUME NULL VALUE AS ZERO
            decimal xStart = x.RangeStart.HasValue ? x.RangeStart.Value : 0;
            decimal xEnd = x.RangeEnd.HasValue ? x.RangeEnd.Value : 0;
            decimal yStart = y.RangeStart.HasValue ? y.RangeStart.Value : 0;
            decimal yEnd = y.RangeEnd.HasValue ? y.RangeEnd.Value : 0;

            if (!xStart.Equals(yStart)) return xStart.CompareTo(yStart);
            if (!xEnd.Equals(yEnd))
            {
                //NEED SPECIAL HANDLING, 0 AS RANGEEND INDICATES NO MAXIMUM
                if (xEnd == 0) return 1;
                if (yEnd == 0) return -1;
                return xEnd.CompareTo(yEnd);
            }
            if (!x.Rate.Equals(y.Rate)) return x.Rate.CompareTo(y.Rate);
            return 0;
        }

        protected void AddRowButton_Click(object sender, EventArgs e)
        {
            UpdateRanges();
            ShipRateMatrix item = new ShipRateMatrix();
            item.ShipMethod = _ShipMethod;
            _ShipMethod.ShipRateMatrices.Add(item);
            _ShipMethod.ShipRateMatrices.Save();
            BindShipRateMatrix();
            RateMatrixAjax.Update();
        }

        protected int GetIndex(int shipRateMatrixId)
        {
            int index = 0;
            foreach (ShipRateMatrix item in _ShipMethod.ShipRateMatrices)
            {
                if (item.Id.Equals(shipRateMatrixId)) return index;
                index++;
            }
            return -1;
        }

        protected void RateMatrixGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int shipRateMatrixId = (int)RateMatrixGrid.DataKeys[e.RowIndex].Value;
            int index = GetIndex(shipRateMatrixId);
            if (index > -1) _ShipMethod.ShipRateMatrices.DeleteAt(index);
            BindShipRateMatrix();
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            RedirectMe();
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveShipMethodMatrix();
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            }
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveShipMethodMatrix();
                RedirectMe();
            }
        }

        private void SaveShipMethodMatrix()
        {
            //UPDATE NAME
                _ShipMethod.Name = Name.Text;
                //UPDATE SHIP RATE
                UpdateRanges();
                //UPDATE SURCHARGE
                _ShipMethod.Surcharge = AlwaysConvert.ToDecimal(Surcharge.Text);
                if (_ShipMethod.Surcharge < 0) _ShipMethod.Surcharge = 0;
                if (_ShipMethod.Surcharge > 0)
                {
                    _ShipMethod.SurchargeMode = (SurchargeMode)AlwaysConvert.ToByte(SurchargeMode.SelectedValue);
                    _ShipMethod.SurchargeIsVisible = (SurchargeIsVisible.SelectedIndex > 0);
                }
                else
                {
                    _ShipMethod.SurchargeMode = 0;
                    _ShipMethod.SurchargeIsVisible = false;
                }

                if (_ShipMethod.SurchargeIsVisible)
                {
                    _ShipMethod.SurchargeTaxCodeId = AlwaysConvert.ToInt(SurchargeTaxCode.SelectedValue);
                }
                else _ShipMethod.SurchargeTaxCodeId = 0;
                //UPDATE WAREHOUSES
                _ShipMethod.Warehouses.Clear();
                _ShipMethod.Save();
                if (UseWarehouseRestriction.SelectedIndex > 0)
                {
                    foreach (ListItem item in WarehouseList.Items)
                    {
                        Warehouse warehouse = WarehouseDataSource.Load(AlwaysConvert.ToInt(item.Value));
                        if (item.Selected) _ShipMethod.Warehouses.Add(warehouse);
                    }
                }
                //UPDATE ZONES
                _ShipMethod.ShipZones.Clear();
                _ShipMethod.Save();
                if (UseZoneRestriction.SelectedIndex > 0)
                {
                    foreach (ListItem item in ZoneList.Items)
                    {
                        ShipZone shipZone = ShipZoneDataSource.Load(AlwaysConvert.ToInt(item.Value));
                        if (item.Selected) _ShipMethod.ShipZones.Add(shipZone);
                    }
                }
                //UPDATE ROLES
                _ShipMethod.Groups.Clear();
                _ShipMethod.Save();
                if (UseGroupRestriction.SelectedIndex > 0)
                {
                    foreach (ListItem item in GroupList.Items)
                    {
                        CommerceBuilder.Users.Group group = GroupDataSource.Load(AlwaysConvert.ToInt(item.Value));
                        if (item.Selected) _ShipMethod.Groups.Add(group);
                    }
                }
                //UPDATE MIN PURCHASE
                _ShipMethod.MinPurchase = AlwaysConvert.ToDecimal(MinPurchase.Text);
                //UPDATE MAX PURCHASE
                _ShipMethod.MaxPurchase = AlwaysConvert.ToDecimal(MaxPurchase.Text);
                //UPDATE TAX CODES
                _ShipMethod.TaxCode = TaxCodeDataSource.Load(AlwaysConvert.ToInt(TaxCode.SelectedValue));
                //SAVE METHOD AND REDIRECT TO LIST
                _ShipMethod.Save();
         }

        protected void SurchargeIsVisible_SelectedIndexChanged(object sender, EventArgs e)
        {
            trSurchargeTaxCode.Visible = SurchargeIsVisible.SelectedIndex == 1;
        }
    }
}