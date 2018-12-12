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
    public class HomeController : Controller
    {
        
        private FriendFitDBEntities db = new FriendFitDBEntities();
        // GET: Home
        [MyAuthenticationFilter]
        public ActionResult Index()
        {
            var regUser = db.UserProfiles.OrderBy(m => m.Id).ToList();
            TempData.Keep("Success");
            return View(regUser.ToList());
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
            int update = db.Database.ExecuteSqlCommand("update UserProfile set IsActive='" + ustatus + "' where id='" + uid + "'");
            if (update > 0)
            {
                TempData["Mgs"] = "User Status Updated Successfully";
            }
            return RedirectToAction("Index", "ManageUser");
        }


    }
}