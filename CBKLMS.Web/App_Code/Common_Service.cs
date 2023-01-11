using CBKLMS.Biz;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for Common_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Common_Service : System.Web.Services.WebService {

    Common_Biz common_biz = new Common_Biz();

    public Common_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    #region 공통 코드 가져오기
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetCMCODE(string cd_major)
    {
        DataTable dt = common_biz.GetCMCODE(cd_major).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetCMCODE_Level(string cd_major, string cd_level)
    {
        DataTable dt = common_biz.GetCMCODE_Level(cd_major, cd_level).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetCMCODE_Sub(string cd_major, string cd_fr_minor)
    {
        DataTable dt = common_biz.GetCMCODE_Sub(cd_major, cd_fr_minor).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
    #endregion

    /// <summary>
    /// 접수 : Test Method 가져오기
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetTestMethodComboList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = common_biz.GetTestMethodComboList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
    /// <summary>
    /// 접수 : Test Unit 가져오기
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetTestUnitComboList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = common_biz.GetTestUnitComboList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Method Changed
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetSelectMethodChanged(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = common_biz.GetSelectMethodChanged(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
    
}
