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
    
    public partial class ScheduleActualFreeTextExercise
    {
        public long Id { get; set; }
        public string Text { get; set; }
        public long ExerciseId { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<bool> IsActive { get; set; }
        public Nullable<bool> RowStatus { get; set; }
    }
}
