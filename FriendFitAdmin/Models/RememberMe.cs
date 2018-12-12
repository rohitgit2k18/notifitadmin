using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace FriendFitAdmin.Models
{
    public class RememberMe
    {
        [Display(Name = "User Name")]
        public string Username
        {
            get;
            set;
        }

        [Display(Name = "Password")]
        public string Password
        {
            get;
            set;
        }
    }
}