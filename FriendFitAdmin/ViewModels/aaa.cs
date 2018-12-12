using FriendFitAdmin.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace FriendFitAdmin.ViewModels
{
    public class aaa
    {
        public RememberMe RememberMe {
            get;
            set;
        }

        [Display(Name ="Remember Me?")]
        public bool Remember
        {
            get;
            set;
        }
    }
}