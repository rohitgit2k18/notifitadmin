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
    
    public partial class ScheduleExercise
    {
        public long Id { get; set; }
        public Nullable<long> UserId { get; set; }
        public Nullable<long> WorkOutScheduleId { get; set; }
        public string ExerciseName { get; set; }
        public Nullable<long> ExerciseTypeId { get; set; }
        public Nullable<System.DateTime> Createdate { get; set; }
        public Nullable<long> CreatedBy { get; set; }
        public Nullable<System.DateTime> Updatedate { get; set; }
        public Nullable<long> UpdatedBy { get; set; }
        public Nullable<bool> IsActive { get; set; }
        public Nullable<bool> RowStatus { get; set; }
    }
}
