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
    public class TransactionController : Controller
    {
        // GET: Transaction
        private FriendFitDBEntities db = new FriendFitDBEntities();
        // GET: Home
        [MyAuthenticationFilter]
        public ActionResult Index()
        {
           var transDtl = db.GetTransaction().ToList();         
            TempData.Keep("Success");
            ViewBag.Title = "Transaction";
            return View(transDtl.ToList());
        }

        [MyAuthenticationFilter]
        public ActionResult ForUser()
        {
            var transDtl = db.GetTransactionForUser11().ToList();
            TempData.Keep("Success");
            ViewBag.Title = "Transaction";
            return View(transDtl.ToList());
        }


        [MyAuthenticationFilter]
        public ActionResult ForFriend()
        {
            var transDtl = db.GetTransactionForFriend().ToList();
            TempData.Keep("Success");
            ViewBag.Title = "Transaction";
            return View(transDtl.ToList());
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
            int update = db.Database.ExecuteSqlCommand("update Transactions set isactive='" + ustatus + "' where transid='" + uid + "'");
            return RedirectToAction("Index", "Transaction");
        }
    }
}