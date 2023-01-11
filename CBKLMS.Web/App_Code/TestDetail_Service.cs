using CBKLMS.Biz.UI_MA;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for TestDetail_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class TestDetail_Service : System.Web.Services.WebService {

    TestDetail_Biz testdetail_biz = new TestDetail_Biz();

    public TestDetail_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// Test List
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetTestList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = testdetail_biz.GetTestList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Test Unit
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string InitControls_Unit(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = testdetail_biz.InitControls_Unit(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Test Method Modal
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetModalTestMethodList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = testdetail_biz.GetModalTestMethodList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Test 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveTestDetail(object Gparam, object[] TestUnit, object[] TestMethod)
    {
        IntertekResult result = new IntertekResult();

        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        List<Dictionary<string, object>> listDic = new List<Dictionary<string, object>>();
        List<Dictionary<string, object>> listUnit = new List<Dictionary<string, object>>();

        try
        {
            for (int i = 0; i < TestUnit.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)TestUnit[i];
                listUnit.Add(dicAdd);
            }

            for (int i = 0; i < TestMethod.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)TestMethod[i];
                listDic.Add(dicAdd);
            }

            result = testdetail_biz.SaveTestDetail(ref result, dicParam, listUnit, listDic);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// Test 상세 Method
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetTestDataDtl_Method(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var ds = testdetail_biz.GetTestDataDtl_Method(dicParam);

        string[] tableNames = { "UNIT_LIST", "TESTMETHOD_LIST" };
        return JSONHelper.GetJSONString(ds, tableNames);
    }

    /// <summary>
    /// Unit Modal
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetModalUnitList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = testdetail_biz.GetModalUnitList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
}
