using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace FriendFitAdmin.Models
{
    [MetadataType(typeof(Ilogo))]
    public partial class UserProfile : IUserProfile
    {
        // [DataType(DataType.Upload)]
        // [Attachment("JPG,JPEG,PNG", 2)]
        //public HttpPostedFileBase ImagePath { get; set; }
    }

    public interface IUserProfile
    {

        //[Required(ErrorMessage = "Please Select file.")]
        //string ImagePath { get; set; }

    }
}