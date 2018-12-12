using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Taxes;
using CommerceBuilder.Utility;
using Redi.Utility;
using System.Collections.Generic;
using CommerceBuilder.Stores;
using System.Data.Common;
using System.Configuration;
using System.Runtime.Serialization;

/// <summary>
/// Summary description for CrmHelper
/// </summary>
public static class CrmHelper
{
    private const string createdBy = "System";
    public const string crmConnectionStringName  = "crm";
    public static Boolean SaveEnquiry(Order order, string comment, List<FileAttachment> files, Store store)
    {
        Int32 jobId;
        string wkRef = NextNumber.GetNextID("QuoteRef", 7);
        DateTime created = GetCurrentStandardTime();
        Boolean filesAttached = false;
        Int32? companyId = null;
        Int32? clientId = null;
        string wkShortDesc = "";

        if (order.Items != null && order.Items.Count > 0)
        {
            int wkCount = 0;
            foreach (OrderItem it in order.Items)
            {
                wkCount++;
                if (!string.IsNullOrEmpty(wkShortDesc))
                {
                    wkShortDesc = wkShortDesc + ", ";
                }
                wkShortDesc = wkShortDesc + it.Product.Name;

                if (wkCount > 2)
                {
                    if (order.Items.Count > wkCount)
                        wkShortDesc = wkShortDesc + ", ...";
                    break;
                }
            }
        }
        else
        {
            wkShortDesc = "Website Enquiry";
        }

        GetCompanyAndClient(order, out companyId, out clientId);

        if (files != null && files != null && files.Count > 0)
            filesAttached = true;

        // Insert the Job record.
        using (Redi.Utility.SqlText insert = new Redi.Utility.SqlText(
                    "Insert Into ALL_Job (ReferenceNo, ClientId, CompanyId, CreatedOn, CreatedByName, CreatedFromWebsite, NewEnquiry, ShortDescription, QuoteAvailable) " +
                    "Values (@ReferenceNo, @ClientId, @CompanyId, @CreatedOn, @CreatedByName, @CreatedFromWebsite, @NewEnquiry, @ShortDescription, 0) " +
                    "SELECT SCOPE_IDENTITY(); ", crmConnectionStringName))
        {
            insert.AddParameter("@ReferenceNo", wkRef);
            insert.AddParameter("@ClientId", clientId);
            if (companyId != null)
                insert.AddParameter("@CompanyId", companyId);
            else
                insert.AddParameter("@CompanyId", System.Data.SqlTypes.SqlInt32.Null);
            insert.AddParameter("@CreatedOn", created);
            insert.AddParameter("@CreatedByName", createdBy);
            insert.AddParameter("@CreatedFromWebsite", true);
            insert.AddParameter("@NewEnquiry", true);
            insert.AddParameter("@ShortDescription", wkShortDesc);
            jobId = Convert.ToInt32(insert.ExecuteScalar());
        }

        // Insert the Enquiry record.
        using (Redi.Utility.SqlText insert = new Redi.Utility.SqlText(
                    "Insert Into ALL_Enquiry (JobId, Comment, CreatedOn, CreatedByName, ShoppingCartOrderId, ShoppingCartUserId, FilesAttached ) " +
                    "Values (@JobId, @Comment, @CreatedOn, @CreatedByName, @ShoppingCartOrderId, @ShoppingCartUserId, @FilesAttached); ", crmConnectionStringName))
        {
            insert.AddParameter("@JobId", jobId);
            insert.AddParameter("@Comment", comment);
            insert.AddParameter("@CreatedOn", created);
            insert.AddParameter("@CreatedByName", createdBy);
            if (order.OrderId != null)
                insert.AddParameter("@ShoppingCartOrderId", order.OrderId);
            else
                insert.AddParameter("@ShoppingCartOrderId", System.Data.SqlTypes.SqlInt32.Null);
            if (order.UserId != null)
                insert.AddParameter("@ShoppingCartUserId", order.UserId);
            else
                insert.AddParameter("@ShoppingCartUserId", System.Data.SqlTypes.SqlInt32.Null);
            insert.AddParameter("@FilesAttached", filesAttached);
            insert.ExecuteScalar();
        }

        if (order.Items != null && order.Items.Count > 0)
        {
            SaveEnquiryItems(order, jobId, store);
        }

        if (files != null && files != null && files.Count > 0)
        {
            SaveFiles(jobId, files);
        }

        try
        {
            SubmitJobStatusChangeRequest(jobId, "WebsiteEnquiry", null, null, null, null, null);
        }
        catch (Exception ex)
        {
            // Ignore any errors trying to do the background process trigger for confirmation emails.
        }

        return true;
    }


    private static void SaveEnquiryItems(Order order, Int32 jobId, Store store)
    {
        // Insert each Order Item
        using (SqlText insertItem = new SqlText(
            "Insert Into [ALL_EnquiryItems] " +
            "(JobId, ProductId, ProductCode, ProductLink, ProductSupplierName, ProductSupplierPublicUrl, Quantity ) " +
            "Values (@JobId, @ProductId, @ProductCode, @ProductLink, @ProductSupplierName, @ProductSupplierPublicUrl, @Quantity )", crmConnectionStringName))
        {
            Int16 itemCount = 0;
            // Database connection is held open whilst each item is inserted
            foreach (OrderItem item in order.Items)
            {
                string prodCode = "";
                if (!string.IsNullOrEmpty(item.Sku))
                {
                    prodCode = item.Sku;
                }
                else
                {
                    prodCode = item.Product.ModelNumber;
                }

                string supplierLink = "";
                if (item.Product.CustomFields != null && item.Product.CustomFields.Count > 0)
                {
                    foreach (ProductCustomField fld in item.Product.CustomFields)
                    {
                        if (fld.FieldName == "SupplierPublicURL")
                        {
                            supplierLink = fld.FieldValue;
                        }
                    }
                }

                insertItem.AddParameter("@JobId", jobId);
                insertItem.AddParameter("@ProductId", item.ProductId);
                insertItem.AddParameter("@ProductCode", prodCode);
                insertItem.AddParameter("@ProductLink", store.StoreUrl.Trim() + item.Product.NavigateUrl.Substring(2));
                if (item.Product.Manufacturer != null && item.Product.Manufacturer.Name != null)
                    insertItem.AddParameter("@ProductSupplierName", item.Product.Manufacturer.Name);
                else
                    insertItem.AddParameter("@ProductSupplierName", System.Data.SqlTypes.SqlString.Null);
                insertItem.AddParameter("@ProductSupplierPublicUrl", supplierLink);
                insertItem.AddParameter("@Quantity", item.Quantity);

                int x = insertItem.ExecuteNonQuery();
                insertItem.ClearParameters();

            } // end foreach
        }
    }

    private static void GetCompanyAndClient(Order order, out Int32? companyId, out Int32? clientId)
    {
        companyId = null;
        clientId = null;

        // See if the client exists
        using (SqlText select = new SqlText(
            "Select ClientId, FullName, FirstName, LastName, EmailAddress, [ALL_Company].CompanyId, [ALL_Company].CompanyName " +
            "From [ALL_Client] " +
            "Left Outer Join [ALL_Company] ON [ALL_Company].CompanyId = [ALL_Client].CompanyId " +
            "Where EmailAddress = @EmailAddress AND [ALL_Client].Deleted=0 ", crmConnectionStringName))
        {
            select.AddParameter("@EmailAddress", order.BillToEmail.Trim());
            DbDataReader myReader = select.ExecuteReader();
            while (myReader.Read())
            {
                Int32 wkClientId = myReader.GetInt32(0);
                string wkName = myReader.GetString(1);
                //string wkFirstName = myReader.GetString(2);
                //string wkLastname = myReader.GetString(3);
                string wkEmail = myReader.GetString(4);
                Int32? wkCompanyId = null;
                if (!myReader.IsDBNull(5))
                    wkCompanyId = myReader.GetInt32(5);
                string wkCompanyName = "";
                if (!myReader.IsDBNull(6))
                    wkCompanyName = myReader.GetString(6);

                clientId = wkClientId;
                companyId = wkCompanyId;
            }

        }

        if (clientId != null)
        {
            // Found a record so exit.
            return;
        }

        if (!string.IsNullOrEmpty(order.BillToCompany) && companyId == null && clientId == null)
        {
            // See if the company exists
            using (SqlText select = new SqlText(
                "Select CompanyId, CompanyName " +
                "From [ALL_Company] " +
                "Where CompanyName = @CompanyName AND Deleted=0 AND DepartmentName is null ", crmConnectionStringName))
            {
                select.AddParameter("@CompanyName", order.BillToCompany.Trim());
                DbDataReader myReader = select.ExecuteReader();
                while (myReader.Read())
                {
                    companyId = myReader.GetInt32(0);
                }

            }

            if (companyId == null)
            {
                // Not found so create a new company record.
                using (Redi.Utility.SqlText insert = new Redi.Utility.SqlText(
                    "Insert Into ALL_Company (CompanyName, CreatedOn, CreatedByName) " +
                    "Values (@CompanyName, @CreatedOn, @CreatedByName) " +
                    "SELECT SCOPE_IDENTITY(); ", crmConnectionStringName))
                {
                    insert.AddParameter("@CompanyName", order.BillToCompany.Trim());
                    insert.AddParameter("@CreatedOn", GetCurrentStandardTime());
                    insert.AddParameter("@CreatedByName", createdBy);

                    companyId = Convert.ToInt32(insert.ExecuteScalar());
                }
            }

        }

        string wkMobile = "";
        string wkPhone = "";
        string wkFax = "";
        string wkFullName = "";
        if (!string.IsNullOrEmpty(order.BillToFirstName))
            wkFullName = order.BillToFirstName.Trim() + ' ';
        if (!string.IsNullOrEmpty(order.BillToLastName))
            wkFullName = wkFullName + order.BillToLastName.Trim();

        if (!string.IsNullOrEmpty(order.BillToPhone))
        {
            if (order.BillToPhone.Length > 2 && order.BillToPhone.Substring(0, 2) == "04")
            {
                wkMobile = order.BillToPhone;
            }
            else
            {
                wkPhone = order.BillToPhone;
            }
        }

        if (!string.IsNullOrEmpty(order.BillToFax))
        {
            wkFax = order.BillToFax;
        }

        // Not an existing client so create a new record.
        using (Redi.Utility.SqlText insert = new Redi.Utility.SqlText(
                    "Insert Into ALL_Client (FullName, FirstName, LastName, Phone, Fax, MobilePhone, CreatedOn, CreatedByName, EmailAddress, CompanyId ) " +
                    "Values (@FullName, @FirstName, @LastName, @Phone, @Fax, @MobilePhone, @CreatedOn, @CreatedByName, @EmailAddress, @CompanyId) " +
                    "SELECT SCOPE_IDENTITY(); ", crmConnectionStringName))
        {
            insert.AddParameter("@FullName", wkFullName);
            insert.AddParameter("@FirstName", order.BillToFirstName);
            insert.AddParameter("@LastName", order.BillToLastName);
            insert.AddParameter("@Phone", wkPhone);
            insert.AddParameter("@Fax", wkFax);
            insert.AddParameter("@MobilePhone", wkMobile);
            if (companyId != null)
                insert.AddParameter("@CompanyId", companyId);
            else
                insert.AddParameter("@CompanyId", System.Data.SqlTypes.SqlInt32.Null);
            insert.AddParameter("@CreatedOn", GetCurrentStandardTime());
            insert.AddParameter("@CreatedByName", createdBy);
            insert.AddParameter("@EmailAddress", order.BillToEmail);

            clientId = Convert.ToInt32(insert.ExecuteScalar());
        }

    }

    private static void SaveFiles(Int32 jobId, List<FileAttachment> files)
    {
        foreach (FileAttachment item in files)
        {
            if (item.name != "DELETE")
            {
                using (Redi.Utility.SqlText insert = new Redi.Utility.SqlText(
                            "Insert Into ALL_JobFile (JobFileFileName, JobFileLength, JobFileContentType, JobFileCategoryCode, JobId, CreatedOn, CreatedByName, DisplayName, FileSystem, FolderName, VersionNo ) " +
                            "Values (@JobFileFileName, @JobFileLength, @JobFileContentType, @JobFileCategoryCode, @JobId, @CreatedOn, @CreatedByName, @DisplayName, @FileSystem, @FolderName, @VersionNo) ", crmConnectionStringName))
                {
                    string wkContentType = Redi.Utility.MapFileContentType.Do(item.name);
                    if (string.IsNullOrEmpty(wkContentType))
                        wkContentType = ".";
                    insert.AddParameter("@JobFileFileName", item.target_name);
                    insert.AddParameter("@JobFileLength", item.size);
                    insert.AddParameter("@JobFileContentType", wkContentType);
                    insert.AddParameter("@JobFileCategoryCode", "Invoice");
                    insert.AddParameter("@JobId", jobId);
                    insert.AddParameter("@CreatedOn", DateTime.Now);
                    insert.AddParameter("@CreatedByName", createdBy);
                    insert.AddParameter("@DisplayName", item.name);
                    insert.AddParameter("@FileSystem", "LOCAL"); // Local to be moved to Amazon
                    insert.AddParameter("@FolderName", "ClientUploadedFiles");
                    insert.AddParameter("@VersionNo", 1);
                    insert.ExecuteNonQuery();
                }
            }
        }

        // Kick off the process that moves files to S3.
        RequestBackgroundProcess("ABLELocalFileToS3", "");

    }

    private static Boolean RequestBackgroundProcess(string requestName, string requestData)
    {
        using (SqlText insert = new SqlText(
            "Insert Into ALL_BatchJobQueue (RequestName, RequestedDateTimeUtc, Submitted, RequestData ) " +
            "Values (@RequestName, @RequestedDateTimeUtc, @Submitted, @RequestData ) ", crmConnectionStringName))
        {
            insert.AddParameter("@RequestName", requestName);
            insert.AddParameter("@RequestedDateTimeUtc", DateTime.UtcNow);
            insert.AddParameter("@Submitted", 0);
            insert.AddParameter("@RequestData", requestData.TrimStart('?'));

            Int32 wkCount = insert.ExecuteNonQuery();
            if (wkCount == 1)
                return true;
            else
                return false;
        }
    }

    private static void SubmitJobStatusChangeRequest(Int32 jobId, string statusCode, int? requestedByEmployeeId, string text, int? approvalId, int? workQueueItemId, string fixedDestEmailAddress)
    {
        JobStatusChangeRequestData data = new JobStatusChangeRequestData();
        data.JobId = jobId;
        data.StatusCode = statusCode;
        data.EmployeeId = requestedByEmployeeId;
        data.text = text;
        data.ApprovalId = approvalId;
        data.WorkQueueItemId = workQueueItemId;
        data.FixedDestEmailAddress = fixedDestEmailAddress;

        string wkRequestData = Redi.Utility.Serialise.SerializeObject(data, typeof(JobStatusChangeRequestData));
        RequestBackgroundProcess("JobStatusChange", wkRequestData);

    }

    private static TimeZoneInfo _standardUserTimeZone;
    public static TimeZoneInfo StandardUserTimeZone
    {
        get
        {
            if (_standardUserTimeZone != null)
                return _standardUserTimeZone;

            var timeZoneString = "W. Australia Standard Time";
            _standardUserTimeZone = TimeZoneInfo.FindSystemTimeZoneById(timeZoneString);

            return _standardUserTimeZone;
        }
    }

    public static DateTime GetCurrentStandardTime()
    {
        try
        {
            return TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, StandardUserTimeZone);
        }
        catch (Exception)
        {
            return DateTime.UtcNow;
        }
    }
}

[Serializable]
public struct JobStatusChangeRequestData
{
    public Int32 JobId { get; set; }
    public string StatusCode { get; set; }
    public int? EmployeeId { get; set; }
    public string text { get; set; }
    public int? ApprovalId { get; set; }
    public int? WorkQueueItemId { get; set; }
    public string FixedDestEmailAddress { get; set; }
}


public class FileAttachment
{
    public string name { get; set; }

    public int size { get; set; }

    public string target_name { get; set; }
    public string path { get; set; }
}