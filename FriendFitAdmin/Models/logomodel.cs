using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FriendFitAdmin.Models
{
    [MetadataType(typeof(Ilogo))]
    public partial class Logo:Ilogo
    {
       // [DataType(DataType.Upload)]
       // [Attachment("JPG,JPEG,PNG", 2)]
        //public HttpPostedFileBase ImagePath { get; set; }
    }

    public interface Ilogo
    {

        //[Required(ErrorMessage = "Please Select file.")]
        //string ImagePath { get; set; }

    }
}
