using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;

namespace IntertekBase
{
    public class CookieRoaster
    {
        public CookieRoaster() { }

        public static void SetCookie(string cookieName, Dictionary<string, string> dictionaries)
        {
            HttpContext context = HttpContext.Current;
            Page currentPage = (Page)context.Handler;
            HttpCookie cookies = null;

            if (currentPage.Request.Cookies[cookieName] == null)
            {
                cookies = new HttpCookie(cookieName);
            }
            else
            {
                cookies = context.Request.Cookies[cookieName];
            }

            foreach (KeyValuePair<string, string> pair in dictionaries)
            {
                cookies[pair.Key] = HttpUtility.UrlEncode(pair.Value);

                cookies.Expires = DateTime.Now.AddYears(1);
                context.Response.Cookies.Add(cookies);
            }

        }

        public static void SetCookie(string cookieName, string childName, string value)
        {
            HttpContext context = HttpContext.Current;
            Page currentPage = (Page)context.Handler;

            if (currentPage.Request.Cookies[cookieName][childName] == null)
            {
                HttpCookie cookie = currentPage.Request.Cookies[cookieName];
                cookie[childName] = HttpUtility.UrlEncode(value);

                cookie.Expires = DateTime.Now.AddYears(1);
                context.Response.Cookies.Add(cookie);
            }
        }

        public static void SetCookie(string cookieName, string value)
        {
            HttpContext context = HttpContext.Current;
            Page currentPage = (Page)context.Handler;

            if (currentPage.Request.Cookies[cookieName] == null)
            {
                HttpCookie cookie = new HttpCookie(cookieName, value);

                cookie.Expires = DateTime.Now.AddYears(1);
                context.Response.Cookies.Add(cookie);
            }
        }

        public static void RemoveCookie(string cookieName)
        {
            HttpContext context = HttpContext.Current;
            Page currentPage = (Page)context.Handler;

            if (currentPage.Request.Cookies[cookieName] != null)
            {
                HttpCookie cookies = currentPage.Request.Cookies[cookieName];
                cookies.Expires = DateTime.Today.AddDays(-100);
                cookies.Value = null;
                currentPage.Response.Cookies.Add(cookies);
            }
        }

        public static HttpCookie GetCookie(string cookieName)
        {
            HttpContext context = HttpContext.Current;
            Page currentPage = (Page)context.Handler;

            HttpCookie cookie = null;
            if (context.Request.Cookies[cookieName] != null)
            {
                cookie = context.Request.Cookies[cookieName];
            }
            return cookie;
        }

        public static string GetCookie(string cookieName, string childName)
        {
            HttpContext context = HttpContext.Current;
            Page currentPage = (Page)context.Handler;

            string childCookie = string.Empty;
            if (currentPage.Request.Cookies[cookieName] != null)
            {
                HttpCookie cookie = currentPage.Request.Cookies[cookieName];
                if (cookie.Values[childName] != null)
                {
                    childCookie = cookie.Values[childName];
                }
            }
            return HttpUtility.UrlDecode(childCookie);
        }
    }
}
