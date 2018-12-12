namespace AbleCommerce.Admin.DigitalGoods.SerialKeyProviders.DefaultProvider
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.DigitalDelivery;
    using CommerceBuilder.Utility;

    public partial class Configure : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected DigitalGood _DigitalGood;
        protected string _SerialKeyProviderId;

        protected void Page_Load(object sender, EventArgs e)
        {
            int digitalGoodId = AlwaysConvert.ToInt(Request.QueryString["DigitalGoodId"]);
            _DigitalGood = DigitalGoodDataSource.Load(digitalGoodId);
            if (_DigitalGood == null) Response.Redirect("~/Admin/DigitalGoods/DigitalGoods.aspx");
            _SerialKeyProviderId = Misc.GetClassId(typeof(DefaultSerialKeyProvider));
            Caption.Text = string.Format(Caption.Text, _DigitalGood.Name);
            if (!Page.IsPostBack) BindSerialKeysGrid();
        }

        protected void BindSerialKeysGrid()
        {
            SerialKeysGrid.Columns[0].Visible = true;
            SerialKeysGrid.DataSource = _DigitalGood.SerialKeys;
            SerialKeysGrid.DataBind();
        }

        protected void AddButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddKeys.aspx?DigitalGoodId=" + _DigitalGood.Id.ToString());
        }

        protected void BackButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/DigitalGoods/EditDigitalGood.aspx?DigitalGoodId=" + _DigitalGood.Id.ToString());
        }

        protected void SerialKeysGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            _DigitalGood.SerialKeys.DeleteAt(e.RowIndex);
            BindSerialKeysGrid();
            e.Cancel = true;
        }
    }
}