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
    
    public partial class LevelExercise
    {
        public long Id { get; set; }
        public decimal TotalWeight { get; set; }
        public long TotalRaps { get; set; }
        public Nullable<System.DateTime> Createdate { get; set; }
        public Nullable<bool> IsActive { get; set; }
        public Nullable<bool> RowStatus { get; set; }
        public Nullable<long> ExerciseSetId { get; set; }
        public string ImperialType { get; set; }
    }
}
