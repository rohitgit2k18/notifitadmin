<%@ WebHandler Language="C#" Class="AbleCommerce.Install.BuildOrders" %>
namespace AbleCommerce.Install
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Products;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using NHibernate;
    using NHibernate.Criterion;

    /// <summary>
    /// Summary description for BuildOrders
    /// </summary>
    public class BuildOrders : IHttpHandler
    {
        private IList<ShipMethod> shipMethods;
        private IList<PaymentMethod> payMethods;
        private int visaIndex = -1;
        private string[] lastNames = { "SMITH", "JOHNSON", "WILLIAMS", "JONES", "BROWN", "DAVIS", "MILLER", "WILSON", "MOORE", "TAYLOR", "ANDERSON", "THOMAS", "JACKSON", "WHITE", "HARRIS", "MARTIN", "THOMPSON", "GARCIA", "MARTINEZ", "ROBINSON", "CLARK", "RODRIGUEZ", "LEWIS", "LEE", "WALKER", "HALL", "ALLEN", "YOUNG", "HERNANDEZ", "KING", "WRIGHT", "LOPEZ", "HILL", "SCOTT", "GREEN", "ADAMS", "BAKER", "GONZALEZ", "NELSON", "CARTER", "MITCHELL", "PEREZ", "ROBERTS", "TURNER", "PHILLIPS", "CAMPBELL", "PARKER", "EVANS", "EDWARDS", "COLLINS", "STEWART", "SANCHEZ", "MORRIS", "ROGERS", "REED", "COOK", "MORGAN", "BELL", "MURPHY", "BAILEY", "RIVERA", "COOPER", "RICHARDSON", "COX", "HOWARD", "WARD", "TORRES", "PETERSON", "GRAY", "RAMIREZ", "JAMES", "WATSON", "BROOKS", "KELLY", "SANDERS", "PRICE", "BENNETT", "WOOD", "BARNES", "ROSS", "HENDERSON", "COLEMAN", "JENKINS", "PERRY", "POWELL", "LONG", "PATTERSON", "HUGHES", "FLORES", "WASHINGTON", "BUTLER", "SIMMONS", "FOSTER", "GONZALES", "BRYANT", "ALEXANDER", "RUSSELL", "GRIFFIN", "DIAZ", "HAYES", "MYERS", "FORD", "HAMILTON", "GRAHAM", "SULLIVAN", "WALLACE", "WOODS", "COLE", "WEST", "JORDAN", "OWENS", "REYNOLDS", "FISHER", "ELLIS", "HARRISON", "GIBSON", "MCDONALD", "CRUZ", "MARSHALL", "ORTIZ", "GOMEZ", "MURRAY", "FREEMAN", "WELLS", "WEBB", "SIMPSON", "STEVENS", "TUCKER", "PORTER", "HUNTER", "HICKS", "CRAWFORD", "HENRY", "BOYD", "MASON", "MORALES", "KENNEDY", "WARREN", "DIXON", "RAMOS", "REYES", "BURNS", "GORDON", "SHAW", "HOLMES" };
        private string[] firstNames = { "JAMES", "JOHN", "ROBERT", "MICHAEL", "WILLIAM", "DAVID", "RICHARD", "CHARLES", "JOSEPH", "THOMAS", "CHRISTOPHER", "DANIEL", "PAUL", "MARK", "DONALD", "GEORGE", "KENNETH", "STEVEN", "EDWARD", "BRIAN", "RONALD", "ANTHONY", "KEVIN", "JASON", "MATTHEW", "GARY", "TIMOTHY", "JOSE", "LARRY", "JEFFREY", "FRANK", "SCOTT", "ERIC", "STEPHEN", "ANDREW", "RAYMOND", "GREGORY", "JOSHUA", "JERRY", "DENNIS", "WALTER", "PATRICK", "PETER", "HAROLD", "DOUGLAS", "HENRY", "CARL", "ARTHUR", "RYAN", "ROGER", "JOE", "JUAN", "JACK", "ALBERT", "MARY", "PATRICIA", "LINDA", "BARBARA", "ELIZABETH", "JENNIFER", "MARIA", "SUSAN", "MARGARET", "DOROTHY", "LISA", "NANCY", "KAREN", "BETTY", "HELEN", "SANDRA", "DONNA", "CAROL", "RUTH", "SHARON", "MICHELLE", "LAURA", "SARAH", "KIMBERLY", "DEBORAH", "JESSICA", "SHIRLEY", "CYNTHIA", "ANGELA", "MELISSA", "BRENDA", "AMY", "ANNA", "REBECCA", "VIRGINIA", "KATHLEEN", "PAMELA", "MARTHA", "DEBRA", "AMANDA", "STEPHANIE", "CAROLYN", "CHRISTINE", "MARIE", "JANET", "CATHERINE", "FRANCES", "ANN", "JOYCE", "DIANE", "ALICE", "JULIE", "HEATHER", "TERESA", "DORIS", "GLORIA", "EVELYN", "JEAN", "CHERYL", "MILDRED", "KATHERINE", "JOAN", "ASHLEY", "JUDITH", "ROSE", "JANICE", "KELLY", "NICOLE", "JUDY", "CHRISTINA" };
        private string[] streetNames = { "Highland", "Forest", "Jefferson", "Hickory", "Wilson", "River", "Meadow", "Valley", "Smith", "East", "Chestnut", "Franklin", "Adams", "Spruce", "Laurel", "Davis", "Birch", "Williams", "Lee", "Dogwood", "Green", "Poplar", "Locust", "Woodland", "Taylor", "Ash", "Madison", "Hillcrest", "Sycamore", "Broadway", "Miller", "Lakeview", "College", "Central", "Park", "Main", "Oak", "Pine", "Maple", "Cedar", "Elm", "View", "Washington", "Lake", "Hill", "Walnut", "Spring", "North", "Ridge", "Lincoln", "Church", "Willow", "Mill", "Sunset", "Railroad", "Jackson", "Cherry", "West", "South", "Center" };
        private string[] streetSuffixes = { "Ave", "St", "Ln", "Rd" };

        public void ProcessRequest(HttpContext context)
        {
            int orders = AlwaysConvert.ToInt(context.Request.QueryString["orders"]);
            if (orders < 1) orders = 1;
            int maxOrderItems = AlwaysConvert.ToInt(context.Request.QueryString["items"]);
            if (maxOrderItems < 1) maxOrderItems = 1;
            string couponCode = context.Request.QueryString["CouponCode"];
            Build(orders, maxOrderItems, couponCode, context.Response);
        }

        private void SetRandomZip(ref Address address)
        {
            int city = (new Random()).Next(1, 10);
            switch (city)
            {
                case 1:
                    address.City = "New York";
                    address.Province = "NY";
                    address.PostalCode = "10101";
                    break;
                case 2:
                    address.City = "Los Angeles";
                    address.Province = "CA";
                    address.PostalCode = "90001";
                    break;
                case 3:
                    address.City = "Chicago";
                    address.Province = "IL";
                    address.PostalCode = "60601";
                    break;
                case 4:
                    address.City = "Houston";
                    address.Province = "TX";
                    address.PostalCode = "77002";
                    break;
                case 5:
                    address.City = "Philadelphia";
                    address.Province = "PA";
                    address.PostalCode = "19103";
                    break;
                case 6:
                    address.City = "Phoenix";
                    address.Province = "AZ";
                    address.PostalCode = "85008";
                    break;
                case 7:
                    address.City = "San Antonio";
                    address.Province = "TX";
                    address.PostalCode = "78205";
                    break;
                case 8:
                    address.City = "San Diego";
                    address.Province = "CA";
                    address.PostalCode = "92103";
                    break;
                case 9:
                    address.City = "Dallas";
                    address.Province = "TX";
                    address.PostalCode = "75201";
                    break;
                default:
                    address.City = "San Jose";
                    address.Province = "CA";
                    address.PostalCode = "95101";
                    break;
            }
        }

        private string ToInitialCase(string input)
        {
            return input.Substring(0, 1) + input.Substring(1).ToLowerInvariant();
        }

        private string GetRandomLastName()
        {
            return ToInitialCase(lastNames[(new Random()).Next(lastNames.Length - 1)]);
        }

        private string GetRandomFirstName()
        {
            return ToInitialCase(firstNames[(new Random()).Next(firstNames.Length - 1)]);
        }

        private string GetRandomStreetName()
        {
            string houseNumber = StringHelper.RandomNumber(4);
            string streetName = streetNames[(new Random()).Next(streetNames.Length - 1)];
            string streetSuffix = streetSuffixes[(new Random()).Next(streetSuffixes.Length - 1)];
            return houseNumber + " " + streetName + " " + streetSuffix;
        }

        private string GenerateReferenceNumber(string creditCardNumber)
        {
            if (string.IsNullOrEmpty(creditCardNumber)) return string.Empty;
            int length = creditCardNumber.Length;
            if (length < 5) return creditCardNumber;
            return ("x" + creditCardNumber.Substring((length - 4)));
        }

        private Payment GetPayment(decimal amount)
        {
            PaymentMethod method = payMethods[visaIndex];
            Payment payment = new Payment();
            payment.PaymentMethodId = method.Id;
            payment.Amount = amount;
            payment.CurrencyCode = "USD";
            AccountDataDictionary instrumentBuilder;
            switch (method.PaymentInstrumentType)
            {
                case PaymentInstrumentType.Visa:
                    instrumentBuilder = new AccountDataDictionary();
                    instrumentBuilder["AccountNumber"] = CommerceBuilder.UI.WebControls.CreditCardValidator.GenerateRandomNumber(CommerceBuilder.UI.WebControls.CardType.Visa);
                    instrumentBuilder["ExpirationMonth"] = "12";
                    instrumentBuilder["ExpirationYear"] = "2007";
                    instrumentBuilder["SecurityCode"] = StringHelper.RandomNumber(3);
                    payment.AccountData = instrumentBuilder.ToString();
                    payment.ReferenceNumber = GenerateReferenceNumber(instrumentBuilder["AccountNumber"]);
                    break;
                case PaymentInstrumentType.MasterCard:
                    instrumentBuilder = new AccountDataDictionary();
                    instrumentBuilder["AccountNumber"] = CommerceBuilder.UI.WebControls.CreditCardValidator.GenerateRandomNumber(CommerceBuilder.UI.WebControls.CardType.MasterCard);
                    instrumentBuilder["ExpirationMonth"] = "12";
                    instrumentBuilder["ExpirationYear"] = "2007";
                    instrumentBuilder["SecurityCode"] = "515";
                    payment.AccountData = instrumentBuilder.ToString();
                    payment.ReferenceNumber = GenerateReferenceNumber(instrumentBuilder["AccountNumber"]);
                    break;
            }
            return payment;
        }

        private ShipMethod GetShipMethod()
        {
            Random rand = new Random();
            int index = rand.Next(shipMethods.Count);
            return shipMethods[index];
        }

        private User GetRandomUser()
        {
            string firstName = GetRandomFirstName();
            string lastName = GetRandomLastName();
            string email = firstName + "." + lastName + "@sample.ablecommerce.xyz";
            User tempUser = UserDataSource.LoadForUserName(email, false);
            if (tempUser != null) return tempUser;
            //user not found, create new
            tempUser = UserDataSource.CreateUser(email, StringHelper.RandomString(8));
            Address billto = tempUser.PrimaryAddress;
            billto.FirstName = firstName;
            billto.LastName = lastName;
            billto.Address1 = GetRandomStreetName();
            billto.Email = email;
            SetRandomZip(ref billto);
            billto.CountryCode = "US";
            tempUser.Save();
            return tempUser;
        }

        private void Build(int orders, int maxOrderItems, string couponCode, HttpResponse httpResponse)
        {
            shipMethods = NHibernateHelper.CreateCriteria<ShipMethod>()
                .SetFetchMode("ShipRateMatrices", FetchMode.Eager)
                .List<ShipMethod>();
            payMethods = PaymentMethodDataSource.LoadAll();
            int tempIndex = 0;
            foreach (PaymentMethod method in payMethods)
            {
                if (method.PaymentInstrumentType == PaymentInstrumentType.Visa) visaIndex = tempIndex;
                tempIndex++;
            }

            ICriteria criteria = NHibernateHelper.CreateCriteria<Product>(100, 0, string.Empty);
            criteria.Add(Restrictions.Eq("VisibilityId", (byte)CatalogVisibility.Public));
            criteria.Add(Restrictions.Eq("UseVariablePrice", false));
            IList<int> productIds = ProductDataSource.LoadForCriteria(criteria).Select(product => product.Id).ToList<int>();

            httpResponse.Write("Building " + orders.ToString() + " orders:");
            httpResponse.Flush();

            // generate random list of order dates
            Random rand = new Random();
            List<DateTime> orderDates = new List<DateTime>();
            for (int i = 0; i < orders; i++)
            {
                int daysAgo = rand.Next(0, 90);
                int minutesAgo = rand.Next(0, (24 * 60));
                orderDates.Add(DateTime.UtcNow.AddDays((-1 * daysAgo)).AddMinutes((-1 * minutesAgo)));
            }
            orderDates.Sort();

            // build random orders
            for (int i = 0; i < orders; i++)
            {
                User tempUser = GetRandomUser();
                Basket basket = tempUser.Basket;
                int orderItems = rand.Next(1, maxOrderItems);
                for (int j = 1; j <= orderItems; j++)
                {
                    int prodIndex = rand.Next(productIds.Count - 1);

                    //ONLY USE PRODUCTS THAT ARE NOT KITS AND HAVE LESS THAN 2 OPTIONS
                    Product product = ProductDataSource.Load(productIds[prodIndex]);
                    while ((product.ProductOptions.Count > 1) || (product.KitStatus == KitStatus.Master))
                    {
                        prodIndex = rand.Next(productIds.Count - 1);
                        product = ProductDataSource.Load(productIds[prodIndex]);
                    }
                    string optionList = string.Empty;
                    if (product.ProductOptions.Count == 1)
                    {
                        int randOption = rand.Next(0, product.ProductOptions[0].Option.Choices.Count);
                        optionList = product.ProductOptions[0].Option.Choices[randOption].Id + ",0,0,0,0,0,0,0";
                    }
                    BasketItem basketItem = BasketItemDataSource.CreateForProduct(product.Id, 1, optionList, string.Empty);
                    basket.Items.Add(basketItem);
                }

                // DO NOT SAVE THIS ORDER IF IT HAS NO VALUE
                IBasketService basketService = AbleContext.Resolve<IBasketService>();
                if (basket.Items.TotalPrice() > 0)
                {
                    foreach (BasketItem item in basket.Items)
                    {
                        item.Basket = basket;
                    }
                    
                    // package into shipments
                    basket.Save();
                    basketService.Package(basket);

                    // set shipping charges
                    foreach (BasketShipment shipment in basket.Shipments)
                    {
                        shipment.AddressId = tempUser.PrimaryAddressId;
                        shipment.ShipMethod = GetShipMethod();
                    }
                    basket.Save();
                    if(!string.IsNullOrEmpty(couponCode))
                        basketService.ApplyCoupon(basket, couponCode);    
                    basketService.Recalculate(basket);

                    // execute the checkout
                    ICheckoutService checkoutService = AbleContext.Resolve<ICheckoutService>();
                    CheckoutRequest request = new CheckoutRequest(basket, GetPayment(basket.Items.TotalPrice()));
                    CheckoutResponse checkoutResponse = checkoutService.ExecuteCheckout(request);
                    if (checkoutResponse.Success)
                    {
                        // SET THE ORDERDATE TO A RANDOM PAST VALUE
                        checkoutResponse.Order.OrderDate = orderDates[i];
                        checkoutResponse.Order.Save(false, false);
                    }
                }

                httpResponse.Write(" .");
                if ((i + 1) % 100 == 0)
                {
                    httpResponse.Write(" " + (i + 1).ToString());
                }
                httpResponse.Flush();

                // keep session memory usage under control
                ISession session = AbleContext.Current.Database.GetSession();
                session.Clear();
                AbleContext.Current.ReloadEntities();
            }

            httpResponse.Write(" DONE!");
            httpResponse.Flush();
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}