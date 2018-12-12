using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace FriendFitAdmin.Models
{
    [MetadataType(typeof(IUserFrofile))]
    public partial class UserProfile : IUserFrofile
    {

    }
    public interface IUserFrofile
    {
        string FirstName { get; set; }
        string MiddleName { get; set; }
        string LastName { get; set; }
        string Email { get; set; }
        string Password { get; set; }
        string MobileNumber { get; set; }
    }
}