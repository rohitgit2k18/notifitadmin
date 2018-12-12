using FriendFitAdmin.Models;
using SAGEBhashaAdmin.Filter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FriendFitAdmin.Controllers
{
    public class EditPriceController : Controller
    {
        private FriendFitDBEntities db = new FriendFitDBEntities();
        // GET: Home
        [MyAuthenticationFilter]
        public ActionResult Index()
        {
            var price = db.tblPrices.ToList().OrderBy(x=>x.IsSMS);
            return View(price.ToList());
        }
    }
}