using FriendFitAdmin.Models;
using SAGEBhashaAdmin.Filter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FriendFitAdmin.Controllers
{
    public class LinkController : Controller
    {
        private FriendFitDBEntities db = new FriendFitDBEntities();
        [MyAuthenticationFilter]
        public ActionResult Index()
        {
            var link = db.Links.ToList();
            return View(link.ToList());
        }
    }
}