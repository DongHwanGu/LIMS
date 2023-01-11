using CBKLMS.Biz.UI_MA;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for Customer_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Customer_Service : System.Web.Services.WebService {

    Customer_Biz customer_biz = new Customer_Biz();

    public Customer_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// Customer List
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetCustList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = customer_biz.GetCustList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Customer List
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetCustDetail(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var ds = customer_biz.GetCustDetail(dicParam);

        string[] tableNames = { "CUST_TEAM_LIST", "PACKAGE_LIST", "TEST_LIST", "CONTACT_LIST" };
        return JSONHelper.GetJSONString(ds, tableNames);
    }

    /// <summary>
    /// Customer 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveCustData(object MasterData, object[] MasterData_Team, object[] PackageList, object[] TestList, object[] ContactList)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)MasterData;

            // Team
            List<Dictionary<string, object>> listTeam = new List<Dictionary<string, object>>();
            for (int i = 0; i < MasterData_Team.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)MasterData_Team[i];
                listTeam.Add(dicAdd);
            }

            // Package
            List<Dictionary<string, object>> listPackage = new List<Dictionary<string, object>>();
            for (int i = 0; i < PackageList.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)PackageList[i];
                listPackage.Add(dicAdd);
            }
            // Package
            List<Dictionary<string, object>> listTest = new List<Dictionary<string, object>>();
            for (int i = 0; i < TestList.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)TestList[i];
                listTest.Add(dicAdd);
            }
            // Package
            List<Dictionary<string, object>> listContact = new List<Dictionary<string, object>>();
            for (int i = 0; i < ContactList.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)ContactList[i];
                listContact.Add(dicAdd);
            }

            result = customer_biz.SaveCustData(ref result, dicParam, listTeam, listPackage, listTest, listContact);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// Modal Package List
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetModalPackageList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = customer_biz.GetModalPackageList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Modal Test List
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetModalTestList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = customer_biz.GetModalTestList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }


    /// <summary>
    /// Modal Test List
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetModalContactList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = customer_biz.GetModalContactList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }


    
}
