//-----------------------------------------------------------------------
// <copyright file="PageVisit.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Code
{
    using System;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;

    /// <summary>
    /// Class holds the data related to a user visit to a Catalog page
    /// </summary>
    [Serializable]
    public class PageVisit : IComparable
    {
        /// <summary>
        /// Gets or sets the type of catalog node associated with this PageView object.
        /// </summary>
        public virtual CatalogNodeType CatalogNodeType
        {
            get
            {
                return (CatalogNodeType)this.CatalogNodeTypeId;
            }
            set
            {
                this.CatalogNodeTypeId = (byte)value;
            }
        }

        /// <summary>
        /// Gets the CagalogNode object associated with this PageView object
        /// </summary>
        public virtual ICatalogable CatalogNode
        {
            get
            {
                return AbleContext.Resolve<ICatalogRepository>().Load(this.CatalogNodeId.Value, this.CatalogNodeType);
            }
        }

        /// <summary>
        /// Gets or sets the ActivityDate
        /// </summary>
        public virtual DateTime ActivityDate { get; set; }

        /// <summary>
        /// Gets or sets the UriStem
        /// </summary>
        public virtual string UriStem { get; set; }

        /// <summary>
        /// Gets or sets the UriQuery
        /// </summary>
        public virtual string UriQuery { get; set; }

        /// <summary>
        /// Gets or sets the PageTitle
        /// </summary>
        public virtual string PageTitle { get; set; }

        /// <summary>
        /// Gets or sets the CatalogNodeId
        /// </summary>
        public virtual int? CatalogNodeId { get; set; }

        /// <summary>
        /// Gets or sets the CatalogNodeTypeId
        /// </summary>
        public virtual byte? CatalogNodeTypeId { get; set; }

        /// <summary>
        /// Gets or sets the VisitCount for this catalog page by the user
        /// </summary>
        public virtual int VisitCount { get; set; }

        /// <inheritdoc/>
        public int CompareTo(object obj)
        {
            PageVisit other = obj as PageVisit;
            if (this.UriStem.Equals(other.UriStem, StringComparison.InvariantCultureIgnoreCase) && this.UriQuery.Equals(other.UriQuery, StringComparison.InvariantCultureIgnoreCase)) return 0;

            return other.ActivityDate.CompareTo(this.ActivityDate);
        }
    }
}
