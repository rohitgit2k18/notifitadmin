using FriendFitAdmin.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FriendFitAdmin.Repository
{
    public class RememberMeModel
    {
        private FriendFitDBEntities db = new FriendFitDBEntities();

        public bool Login(string Username, string Password)
        {
            var Yes = db.UserProfiles.Where(m => m.Email == Username && m.Password == Password).FirstOrDefault();
            if (Yes!=null)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}