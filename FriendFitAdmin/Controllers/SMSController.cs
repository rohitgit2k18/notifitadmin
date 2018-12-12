using FriendFitAdmin.Models;
using SAGEBhashaAdmin.Filter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FriendFitAdmin.Controllers
{
    [MyAuthenticationFilter]
    public class SMSController : Controller
    {
        // GET: SMS
        private FriendFitDBEntities db = new FriendFitDBEntities();
        [MyAuthenticationFilter]
        public ActionResult Index()
        {
            var sms = db.FriendsInvitations.OrderBy(m => m.Id).ToList();
            TempData.Keep("Success");
            return View(sms.ToList());
        }
        [HttpPost]
        public ActionResult UserStatus(string uid, string ustatus)
        {
            if (ustatus == "True")
            {
                ustatus = "False";
            }
            else
            {
                ustatus = "True";
            }
            int update = db.Database.ExecuteSqlCommand("update FriendsInvitation set IsActive='" + ustatus + "' where Id='" + uid + "'");
            return RedirectToAction("Index", "SMS");
        }

    }
}