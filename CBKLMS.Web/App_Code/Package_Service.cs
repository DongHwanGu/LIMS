using CBKLMS.Biz.UI_MA;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for Package_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Package_Service : System.Web.Services.WebService {

    Package_Biz package_biz = new Package_Biz();

    public Package_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// Package List
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetPackageList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = package_biz.GetPackageList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Test Modal List.
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetModalTestList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = package_biz.GetModalTestList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Test 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SavePackageDetail(object Gparam, object[] TestList)
    {
        IntertekResult result = new IntertekResult();

        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        List<Dictionary<string, object>> listDic = new List<Dictionary<string, object>>();

        try
        {
            for (int i = 0; i < TestList.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)TestList[i];
                listDic.Add(dicAdd);
            }

            result = package_biz.SavePackageDetail(ref result, dicParam, listDic);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// Test Dtl List.
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetPackageDataDtl_Test(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = package_biz.GetPackageDataDtl_Test(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
}
