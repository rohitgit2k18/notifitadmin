using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using CommerceBuilder.Messaging;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin._Store.EmailTemplates
{
public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
{
    protected string GetMailFormat(object dataItem)
    {
        EmailTemplate emailTemplate = (EmailTemplate)dataItem;
        if (emailTemplate.IsHTML) return "HTML";
        else return "Text";
    }

    protected string GetTriggers(object dataItem)
    {
        EmailTemplate emailTemplate = (EmailTemplate)dataItem;
        if (emailTemplate.Triggers.Count == 0) return string.Empty;
        List<string> triggers = new List<string>();
        foreach (EmailTemplateTrigger trigger in emailTemplate.Triggers)
        {
            triggers.Add("<span style=\"white-space:nowrap\">" + AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(trigger.StoreEvent) + "</span>");
        }
        return string.Join("<br />", triggers.ToArray());
    }
}}
