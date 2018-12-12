using FriendFitAdmin.Models;
using SAGEBhashaAdmin.Filter;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace FriendFitAdmin.Controllers
{
    [MyAuthenticationFilter]
    public class ManageUserController : Controller
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
        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(HttpPostedFileBase file)
        {
            try
            {
                if (file != null && file.ContentLength > 0)
                {
                    string extension = System.IO.Path.GetExtension(file.FileName);
                    long fileSize = file.ContentLength;
                    if (extension == ".png" || extension == ".jpg" || extension == ".jpeg" || extension == ".PNG" || extension == ".JPG" || extension == ".JPEG")
                    {
                        if (fileSize < 3145728)
                        {
                            string ImageName = System.IO.Path.GetFileName(file.FileName);
                            string physicalPath = Server.MapPath("~/images/" + ImageName);
                            file.SaveAs(physicalPath);
                            Logo newRecord = new Logo();
                            newRecord.ImagePath = ImageName;
                            newRecord.Status = true;
                            newRecord.Createdate = DateTime.Now;
                            db.Logoes.Add(newRecord);
                            db.SaveChanges();
                            TempData["Mgs"] = "Logo added Successfully";
                        }
                        else
                        {
                            TempData["Mgs"] = "Logo file size is greater than 3MB.";
                        }
                    }
                    else
                    {
                        TempData["Mgs"] = "Logo extension is wrong. We accept only PNG and JPG file.";
                    }
                }
                else
                {
                    TempData["Mgs"] = "Please select logo file.";
                }
            }
            catch (Exception ex)
            {
                TempData["Mgs"] = Convert.ToString(ex);
            }
            return View();
        }

        [MyAuthenticationFilter]
        public ActionResult display()
        {
            var regUser = db.Logoes.ToList();
            return View(regUser.ToList());
        }
        public ActionResult Delete(int id)
        {
            Logo homebanner = db.Logoes.Find(id);
            db.Logoes.Remove(homebanner);
            db.SaveChanges();
            TempData["Mgs"] = "Logo Delete Successfully";
            return RedirectToAction("display", "ManageUser");
        }
        public ActionResult DeleteUser(int id)
        {
            UserProfile userP = db.UserProfiles.Find(id);
            //db.UserProfiles.Remove(userP);
            //db.SaveChanges();

            int update = db.Database.ExecuteSqlCommand("update UserProfile set IsDeleted='" + 0 + "' where id='" + id + "'");
            if (update > 0)
            {
                TempData["Mgs"] = "User Deleted Successfully";
            }
            return RedirectToAction("Index", "ManageUser");
        }
        // GET: /Author/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            UserProfile authormaster = db.UserProfiles.Find(id);
            if (authormaster == null)
            {
                return HttpNotFound();
            }
            if (authormaster.IsActive == false)
                authormaster.IsActive = true;
            else
                authormaster.IsActive = false;
            return View(authormaster);
        }

        public ActionResult Updateuser(UserProfile up)
        {
            int update = db.Database.ExecuteSqlCommand("update UserProfile set Email='" + up.Email + "', MobileNumber='" + up.MobileNumber + "', FirstName='" + up.FirstName + "', LastName='" + up.LastName + "' where id='" + up.Id + "'");
            if (update > 0)
            {
                TempData["Mgs"] = "User Updated Successfully";
                return RedirectToAction("Index", "ManageUser");
            }
            return View();
        }
    }
}