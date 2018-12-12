using FriendFitAdmin.Models;
using FriendFitAdmin.Repository;
using FriendFitService;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Helpers;
using System.Web.Mvc;
using System.Web.Security;

namespace FriendFitAdmin.Controllers
{
    public class LoginController : Controller
    {
        private FriendFitDBEntities db = new FriendFitDBEntities();
        // GET: Login
        public ActionResult Index()
        {            
            if (Request.Cookies["myCookie"] != null)
            {
                HttpCookie _cookie = Request.Cookies["myCookie"];
                ViewBag.username = _cookie["email"];
                ViewBag._password = _cookie["password"];
            }
            return View();               
        }
        [HttpPost]
        public ActionResult Login(string email, string password, UserProfile Model)
        {
            try
            {
                UserProfile objlogin = new UserProfile();
                string cookies_password = password;
                password = Crypto.Hash(password);               
                objlogin = db.UserProfiles.Where(m => m.Email == email && m.Password == password && m.IsActive==true && m.IsDeleted == false).FirstOrDefault();
                if (objlogin != null)
                {
                    Session["emailid"] = email;
                    Session["UserId"] = objlogin.Id;
                    Session["UserName"] = objlogin.FirstName;
                    if (objlogin.ProfilePic!=null)
                    {
                        Session["ProfileImage"] = objlogin.ProfilePic;
                    }
                    else
                    {
                        Session["ProfileImage"] = "/Content/Images/image.png";
                    }
                    if (Model.Remember == true)
                    {                
                        //create a cookie
                        HttpCookie myCookie = new HttpCookie("myCookie");

                        //Add key-values in the cookie
                        myCookie.Values.Add("email", email.ToString());
                        myCookie.Values.Add("password", cookies_password.ToString());

                        //set cookie expiry date-time. Made it to last for next 12 hours.
                        myCookie.Expires = DateTime.Now.AddDays(15);

                        //Most important, write the cookie to client.
                        Response.Cookies.Add(myCookie);
                    }
                    return RedirectToAction("Index", "Home");
                }
                else
                {
                    ModelState.AddModelError("Error", "Sorry You have enter incorrect User name or Password or Please contact to your Admin");
                }
            }

            catch (Exception ex)
            {
                ModelState.AddModelError("Error", ex.Message);
            }

            return View("index");
        }

        public RememberMe CheckCookie()
        {
            RememberMe obj_RememberMe = null;
            string username = string.Empty, password = string.Empty;
            if (Response.Cookies["username"] != null)
                username = Response.Cookies["username"].Value;
            if (Response.Cookies["password"] != null)
                password = Response.Cookies["password"].Value;
            if (!String.IsNullOrEmpty(username) && !String.IsNullOrEmpty(password))
                obj_RememberMe = new RememberMe { Username = username, Password = password };
            return obj_RememberMe;
        }
        [HttpPost]
        public ActionResult Logout()
        {
            Session.Abandon();
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1));
            Response.Cache.SetNoStore();
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", "Login");
        }

        [HttpPost]
        public ActionResult ForgetPassword(string emailId)
        {
            mailservice obj = new mailservice();
            UserProfile Model = new UserProfile();
            var result = db.UserProfiles.Where(x => x.Email == emailId).ToList();
            if (result.Count == 0)
            {
                Model = db.UserProfiles.Where(x => x.Email == emailId).FirstOrDefault();
                return View();
            }
            else
            {
                obj.SendMailForgot(emailId);
                return RedirectToAction("Index", "Login");
            }
        }

        [HttpPost]
        public JsonResult SetNewPassword(string email, string setnewpass)
        {
            mailservice obj = new mailservice();
            UserProfile Model = new UserProfile();
            var result = db.UserProfiles.Where(x => x.Email == email).ToList();
            if (result.Count > 0)
            {
                int update = db.Database.ExecuteSqlCommand("update UserProfile set Password='" + setnewpass + "' where Email='" + email + "'");
                if (update > 0)
                {
                    TempData["Mgs"] = "Your Password have been change sucessfully";
                }
            }
            else
            {
                TempData["Mgs"] = "Your Password Not Change";
            }
            return Json(TempData["Mgs"], JsonRequestBehavior.AllowGet);
        }

        public ActionResult Forget(string Email)
        {
            return View();
        }

        public ActionResult ResetPassword()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ResetPassword(ResetPassword account)
        {
            UserProfile objuser = new UserProfile();
            try
            {
                if (account.NewPassword != account.ConfirmPassword)
                {
                    return View(account);
                }
                else
                {
                    account.ConfirmPassword = Crypto.Hash(account.ConfirmPassword);
                    account.OldPassword = Crypto.Hash(account.OldPassword);
                    
                    objuser.Id = Convert.ToInt32(Session["UserId"]);

                    if (objuser.Id > 0)
                    {
                        var OldPwdExist = db.UserProfiles.Where(m => m.Id == objuser.Id && m.Password == account.OldPassword).FirstOrDefault();
                        if (OldPwdExist != null)
                        {
                            int update = db.Database.ExecuteSqlCommand("update UserProfile set Password='" + account.ConfirmPassword + "' where Email='" + OldPwdExist.Email + "'");
                            if (update > 0)
                            {
                                TempData["Mgs"] = "Success";
                            }
                        }
                        else
                        {
                            TempData["Mgs"] = "Failed";
                        }
                    }
                    else
                    {
                        return RedirectToAction("Index", "Home");
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["Mgs"] = Convert.ToString(ex);
            }
            return View();
        }
    }
}