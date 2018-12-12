using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Services;
using CommerceBuilder.Search;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using NHibernate;
using CommerceBuilder.DomainModel;
using NHibernate.Criterion;

namespace AbleCommerce.Admin._Store
{
public partial class Maintenance : CommerceBuilder.UI.AbleCommerceAdminPage
{
    protected void Page_Init(object sender, EventArgs e)
    {
        // INCREASE TIMEOUT FOR PAGE PROCESSING
        Server.ScriptTimeout = 7200;
        AbleCommerce.Code.PageHelper.SetHtmlEditor(StoreClosedMessage, StoreClosedMessageHtml);
    }

    protected void Page_Load(object sender, System.EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;
                    
            StoreClosedOptions.DataSource = EnumToDictionary(typeof(StoreClosureType));
            StoreClosedOptions.DataTextField = "Key";
            StoreClosedOptions.DataValueField = "Value";
            StoreClosedOptions.DataBind();
            ListItem option = StoreClosedOptions.Items.FindByValue(((int)settings.StoreFrontClosed).ToString());
            if (option != null) option.Selected = true;
            
            StoreClosedMessage.Text = settings.StoreFrontClosedMessage;
                       
            //USER MAINTENANCE
            if (settings.AnonymousUserLifespan > 0) AnonymousLifespan.Text = settings.AnonymousUserLifespan.ToString();
            if (settings.AnonymousAffiliateUserLifespan > 0) AnonymousAffiliateLifespan.Text = settings.AnonymousAffiliateUserLifespan.ToString();

			//GIFT CERTIFICATE EXPIRY
            GiftCertExpireDays.Text = settings.GiftCertificateDaysToExpire.ToString();

            // SEACH TERMS HISTORY
            SearchHistoryDays.Text = settings.UserSearchHistoryTrackingDays.ToString();

            // DATA EXCHANGE
            MaxNumOfExportFiles.Text = settings.MaxNumOfExportFiles.ToString();
            MaxAgeOfExportFiles.Text = settings.MaxAgeOfExportFiles.ToString();
            MaxSizeOfExportFolder.Text = settings.MaxSizeOfExportFolder.ToString();
            MaxNumOfImportFiles.Text = settings.MaxNumOfImportFiles.ToString();
            MaxAgeOfImportFiles.Text = settings.MaxAgeOfImportFiles.ToString();
            MaxSizeOfImportFolder.Text = settings.MaxSizeOfImportFolder.ToString();

            // maintinance
            RetainExpiredSubscriptionDays.Text = settings.RORetainExpiredSubscriptionDays.ToString();
        }
    }

    private void InitAnonUserStatus()
    {
        // GET COUNT OF ANONYMOUS USERS
        ICriteria criteria = NHibernateHelper.CreateCriteria<User>()
            .Add(Restrictions.Eq("IsAnonymous", true))
            .Add(Restrictions.IsNull("Affiliate"));
        int anonUserCount = UserDataSource.CountForCriteria(criteria);
        AnonymousUserCount.Text = anonUserCount.ToString();

        criteria = NHibernateHelper.CreateCriteria<User>(1, 0, "LastActivityDate")
            .Add(Restrictions.Eq("IsAnonymous", true))
            .Add(Restrictions.IsNull("Affiliate"))
            .Add(Restrictions.IsNotNull("LastActivityDate"));
        IList<User> anonUsers = UserDataSource.LoadForCriteria(criteria);
        if (anonUsers != null && anonUsers.Count > 0)
        {
            OldestAnonUser.Text = GetElapsedDays(anonUsers[0].LastActivityDate.Value).ToString() + " days @ " + anonUsers[0].LastActivityDate.ToString();
        }
        else OldestAnonUser.Text = "n/a";

        criteria = NHibernateHelper.CreateCriteria<User>()
            .Add(Restrictions.Eq("IsAnonymous", true))
            .Add(Restrictions.IsNotNull("Affiliate"));
        int anonAffiliateUserCount = UserDataSource.CountForCriteria(criteria);
        AffiliateAnonymousUserCount.Text = anonAffiliateUserCount.ToString();

        criteria = NHibernateHelper.CreateCriteria<User>(1, 0, "LastActivityDate")
            .Add(Restrictions.Eq("IsAnonymous", true))
            .Add(Restrictions.IsNotNull("Affiliate"))
            .Add(Restrictions.IsNotNull("LastActivityDate"));
        anonUsers = UserDataSource.LoadForCriteria(criteria);
        if (anonUsers != null && anonUsers.Count > 0)
        {
            OldestAffAnonUser.Text = GetElapsedDays(anonUsers[0].LastActivityDate.Value).ToString() + " days @ " + anonUsers[0].LastActivityDate.ToString();
        }
        else OldestAffAnonUser.Text = "n/a";
    }

    private int GetElapsedDays(DateTime pastDate)
    {
        TimeSpan ts = DateTime.UtcNow - pastDate.ToUniversalTime();
        return ts.Days;
    }

    protected Dictionary<string,int> EnumToDictionary(Type enumType)
    {
        // get the names from the enumeration
        string[] names = Enum.GetNames(enumType);
        // get the values from the enumeration
        Array values = Enum.GetValues(enumType);
        // turn it into a dictionary
        Dictionary<string,int> ht = new Dictionary<string,int>();
        for (int i = 0; i < names.Length; i++)
            // note the cast to integer here is important
            // otherwise we'll just get the enum string back again
			ht.Add(StringHelper.SpaceName(names[i]), (int)values.GetValue(i));
        // return the dictionary to be bound to
        return ht;
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("../Default.aspx");
    }

    private void SaveSettings()
    {
        if (Page.IsValid)
        {
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;

            settings.StoreFrontClosed = (StoreClosureType)AlwaysConvert.ToInt(StoreClosedOptions.SelectedValue);
            settings.StoreFrontClosedMessage = StoreClosedMessage.Text;

            //USER MAINTENANCE
            settings.AnonymousUserLifespan = AlwaysConvert.ToInt(AnonymousLifespan.Text);
            settings.AnonymousAffiliateUserLifespan = AlwaysConvert.ToInt(AnonymousAffiliateLifespan.Text);
            settings.GiftCertificateDaysToExpire = AlwaysConvert.ToInt(GiftCertExpireDays.Text);

            // SEACH TERMS HISTORY
            settings.UserSearchHistoryTrackingDays = AlwaysConvert.ToInt(SearchHistoryDays.Text);

            // DATA EXCHANGE
            settings.MaxNumOfExportFiles = AlwaysConvert.ToInt(MaxNumOfExportFiles.Text);
            settings.MaxAgeOfExportFiles = AlwaysConvert.ToInt(MaxAgeOfExportFiles.Text);
            settings.MaxSizeOfExportFolder = AlwaysConvert.ToInt(MaxSizeOfExportFolder.Text);
            settings.MaxNumOfImportFiles = AlwaysConvert.ToInt(MaxNumOfImportFiles.Text);
            settings.MaxAgeOfImportFiles = AlwaysConvert.ToInt(MaxAgeOfImportFiles.Text);
            settings.MaxSizeOfImportFolder = AlwaysConvert.ToInt(MaxSizeOfImportFolder.Text);

            // Subscriptions
            settings.RORetainExpiredSubscriptionDays = AlwaysConvert.ToInt(RetainExpiredSubscriptionDays.Text);

            settings.Save();
        }
    }
    
    protected void SaveButton_Click(object sender, EventArgs e)
    {
        SaveSettings();
        SavedMessage.Visible = true;
    }
    
    protected void SaveAndCloseButton_Click(object sender, EventArgs e) {
        SaveSettings();
        Response.Redirect("../Default.aspx");
    }

    protected void CheckDatabaseButton_Click(object sender, EventArgs e)
    {
        // PRINT ANON USER STATUS
        InitAnonUserStatus();
        InstructionsPanel.Visible = false;
        AnonymousUsersDataPanel.Visible = true;
    }

    protected void ManualCleanupButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            int anonymousUserLifespan = AlwaysConvert.ToInt(ManualCleanupDays1.Text);
            int anonymousAffiliateUserLifespan = AlwaysConvert.ToInt(ManualCleanupDays2.Text);
            IMaintenanceWorker worker = AbleContext.Resolve<IMaintenanceWorker>();
            worker.CleanupAnonymousUsers(anonymousUserLifespan, anonymousAffiliateUserLifespan);

            if (AnonymousUsersDataPanel.Visible)
            {
                // UPDATE ANON USER STATUS
                InitAnonUserStatus();
            }
        }
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        StoreSettingsManager settings = AbleContext.Current.Store.Settings;
        phAnonymousLifespanWarning.Visible = (settings.AnonymousUserLifespan == 0 && settings.AnonymousAffiliateUserLifespan == 0);
    }
}
}
