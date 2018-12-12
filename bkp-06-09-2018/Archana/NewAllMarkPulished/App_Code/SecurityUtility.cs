// -----------------------------------------------------------------------
// <copyright file="SecurityUtility.cs" company="Able Solutions Corporation">
// Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
// -----------------------------------------------------------------------

namespace AbleCommerce.Code
{
    using System;
    using System.Collections.Generic;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;
    using System.Linq;

    /// <summary>
    /// Provides methods to assist with securing web access
    /// </summary>
    public static class SecurityUtility
    {
        /// <summary>
        /// Determines whether a user can view a category
        /// </summary>
        /// <param name="user">The user</param>
        /// <param name="category">The category</param>
        /// <returns>True if the category is visible to the user, false otherwise.</returns>
        public static bool CanViewCategory(User user, Category category)
        {
            if (user == null) throw new ArgumentNullException("user");
            if (category == null) throw new ArgumentNullException("category");

            // check if the category is marked as private
            if (category.Visibility == CatalogVisibility.Private)
            {
                // if private only an admin has the ability to see it
                if (!user.IsInRole(Role.CatalogAdminRoles))
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// Gets the collection of groups accessible to the current user for management tasks such as editing or assignment.
        /// </summary>
        /// <returns>The collection of groups accessible to the current user for management tasks such as editing or assignment.</returns>
        public static IList<Group> GetManagableGroups()
        {
            List<Group> availableGroups = new List<Group>();
            foreach (Group group in AbleContext.Current.Store.Groups)
            {
                if (group.IsInRole(Role.AllAdminRoles))
                {
                    if (group.IsInRole("System"))
                    {
                        if (AbleContext.Current.User.IsSystemAdmin)
                        {
                            availableGroups.Add(group);
                        }
                    }
                    else if (AbleContext.Current.User.IsSecurityAdmin)
                    {
                        availableGroups.Add(group);
                    }
                }
                else
                {
                    availableGroups.Add(group);
                }
            }
            return availableGroups;
        }

        /// <summary>
        /// Gets the collection of roles accessible to the current user for assignment.
        /// </summary>
        /// <returns>The collection of roles accessible to the current user for assignment.</returns>
        public static IList<Role> GetManagableRoles()
        {
            User user = AbleContext.Current.User;
            List<Role> managableRoles = new List<Role>();

            // GET LIST OF ROLSE
            IList<Role> roles = RoleDataSource.LoadAll("Name");

            // IF USER IS IN JR ADMIN ROLES
            if (user != null && user.IsInRole(Role.JrAdminRoles))
            {
                foreach (Role role in roles)
                {
                    // IF ROLE IS AN ADMIN ROLE
                    if (Role.AllAdminRoles.Any(r => r == role.Name))
                    {
                        // ONLY SECURITY ADMIN CAN MANAGE ADMIN ROLES
                        if (user.IsSecurityAdmin)
                        {
                            if (Role.SystemAdminRoles.Any(r => r == role.Name))
                            {
                                // ONLY SYSTEM ADMIN CAN MANAGE SYSTEM ROLE
                                if (user.IsSystemAdmin)
                                    managableRoles.Add(role);
                            }
                            else
                            {
                                managableRoles.Add(role);
                            }
                        }
                    }
                    else
                    {
                        managableRoles.Add(role);
                    }
                }
            }

            return managableRoles;
        }
    }
}