//-----------------------------------------------------------------------
// <copyright file="Indexing.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Admin._Store
{
    using System;
    using CommerceBuilder.Common;
    using CommerceBuilder.Services;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Configuration;
    using CommerceBuilder.Search;

    public partial class Indexing : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool luceneEnabled = ApplicationSettings.Instance.SearchProvider == "LuceneSearchProvider";
            bool sqlFtsEnabled = ApplicationSettings.Instance.SearchProvider == "SqlFtsSearchProvider";
            if (luceneEnabled)
            {
                // EVICT THE STORE FROM THE SESSION CACHE AND RELOAD
                // THIS IS DUE TO 2ND LEVEL CACHING NOT BEING UPDATED BY THE ASYNC PROCESS
                Store store = AbleContext.Current.Store;
                AbleContext.Current.Database.GetSession().Evict(store);
                AbleContext.Current.DatabaseFactory.SessionFactory.Evict(store.GetType(), store);
                AbleContext.Current.Store = StoreDataSource.Load(store.Id);
                ToggleProgress(false);
                NoFTSPanel.Visible = false;
                FTSPanel.Visible = true;
            }
            else
            if(sqlFtsEnabled)
            {
                ToggleProgressSQLFts(false);
                SQLFtsPanel.Visible = true;
                NoFTSPanel.Visible = false;
                FTSPanel.Visible = false;
            }
            else
            {
                NoFTSPanel.Visible = true;
                FTSPanel.Visible = false;
            }
        }

        protected void RebuildIndexButton_Click(object sender, EventArgs e)
        {
            AbleContext.Resolve<IFullTextSearchService>().AsyncReindex();
            ToggleProgress(true);
        }

        protected void RebuildSQLIndexButton_Click(object sender, EventArgs e)
        {
            AbleContext.Resolve<ISQLFullTextSearchService>().AsyncReindexSQLFts();
            KeywordSearchHelper.RebuildCatalog();
            ToggleProgressSQLFts(true);
        }

        private void ToggleProgress(bool forceProgressDisplay)
        {
            IFullTextSearchService searchService = AbleContext.Resolve<IFullTextSearchService>();
            if (searchService.LastReindexDate != null && !searchService.IsReindexing && !forceProgressDisplay)
            {
                LastRebuildDate.Text = string.Format(LastRebuildDate.Text, searchService.LastReindexDate.Value);
                LastRebuildPanel.Visible = true;
            }
            else
            {
                LastRebuildPanel.Visible = false;
            }
            
            if (searchService.IsReindexing || forceProgressDisplay)
            {
                int seconds = 1;
                if (searchService.IsReindexing)
                {
                    seconds = (int)Math.Ceiling(LocaleHelper.LocalNow.Subtract(searchService.ReindexStartDate.Value).TotalSeconds);
                }
                int minutes = seconds / 60;
                seconds = seconds - (60 * minutes);
                ProgressLabel.Text = string.Format(ProgressLabel.Text, minutes, seconds);
                ProgressPanel.Visible = true;
                RebuildIndexButton.Visible = false;
                Timer1.Enabled = true;
            }
            else
            {
                ProgressPanel.Visible = false;
                RebuildIndexButton.Visible = true;
            }
        }

        private void ToggleProgressSQLFts(bool forceProgressDisplaySQLFts)
        {
            ISQLFullTextSearchService searchService = AbleContext.Resolve<ISQLFullTextSearchService>();
            if (searchService.LastReindexDateSQLFts != null && !searchService.IsReindexingSQLFts && !forceProgressDisplaySQLFts)
            {
                LastRebuildDateSQLFts.Text = string.Format(LastRebuildDateSQLFts.Text, searchService.LastReindexDateSQLFts.Value);
                LastRebuildPanelSQLFts.Visible = true;
            }
            else
            {
                LastRebuildPanelSQLFts.Visible = false;
            }

            if (searchService.IsReindexingSQLFts || forceProgressDisplaySQLFts)
            {
                int seconds = 1;
                if (searchService.IsReindexingSQLFts)
                {
                    seconds = (int)Math.Ceiling(LocaleHelper.LocalNow.Subtract(searchService.ReindexStartDateSQLFts.Value).TotalSeconds);
                }
                int minutes = seconds / 60;
                seconds = seconds - (60 * minutes);
                ProgressLabelSQLFts.Text = string.Format(ProgressLabelSQLFts.Text, minutes, seconds);
                ProgressPanelSQLFts.Visible = true;
                RebuildSQLIndexButton.Visible = false;
                Timer2.Enabled = true;
            }
            else
            {
                ProgressPanelSQLFts.Visible = false;
                RebuildSQLIndexButton.Visible = true;
            }
        }

        protected void ResetLink_Click(object sender, EventArgs e)
        {
            AbleContext.Resolve<IFullTextSearchService>().CancelReindex();
            ToggleProgress(false);
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            // DISABLE THE TIMER IF INDEX CREATION IS COMPLETE
            if (!AbleContext.Resolve<IFullTextSearchService>().IsReindexing)
            {
                Timer1.Enabled = false;
                RebuildIndexButton.Visible = true;
            }
        }

        protected void ResetLinkSQLFts_Click(object sender, EventArgs e)
        {
            AbleContext.Resolve<ISQLFullTextSearchService>().CancelReindexSQLFts();
            ToggleProgressSQLFts(false);
        }

        protected void Timer2_Tick(object sender, EventArgs e)
        {
            // DISABLE THE TIMER IF INDEX CREATION IS COMPLETE
            if (!AbleContext.Resolve<ISQLFullTextSearchService>().IsReindexingSQLFts)
            {
                Timer2.Enabled = false;
                RebuildSQLIndexButton.Visible = true;
            }
        }
    }
}