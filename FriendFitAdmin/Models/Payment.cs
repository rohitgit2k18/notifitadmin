//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace FriendFitAdmin.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Payment
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Payment()
        {
            this.PurchaseProductsLists = new HashSet<PurchaseProductsList>();
        }
    
        public int Id { get; set; }
        public string PaypalId { get; set; }
        public string Intent { get; set; }
        public string Cart { get; set; }
        public string State { get; set; }
        public string Create_time { get; set; }
        public string Update_time { get; set; }
        public string Payer_PaymentMethod { get; set; }
        public string Status { get; set; }
        public string Payer_info_Email { get; set; }
        public string Payer_info_FirstName { get; set; }
        public string Payer_info_LastName { get; set; }
        public string Payer_info_Payer_Id { get; set; }
        public string Payer_info_Country_Code { get; set; }
        public string Shipping_Address_Recipient_Name { get; set; }
        public string Shipping_Address_Line1 { get; set; }
        public string Shipping_Address_Line2 { get; set; }
        public string Shipping_Address_City { get; set; }
        public string Shipping_Address_Country_Code { get; set; }
        public string Shipping_Address_PostedCode { get; set; }
        public string Shipping_Address_State { get; set; }
        public string Transactions_Description { get; set; }
        public string Transactions_InvoiceNum { get; set; }
        public Nullable<System.DateTime> RowInsert { get; set; }
        public Nullable<int> UserId { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PurchaseProductsList> PurchaseProductsLists { get; set; }
    }
}