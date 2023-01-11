using CBKLMS.Biz;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for SiteMaster_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SiteMaster_Service : System.Web.Services.WebService {

    SiteMaster_Biz sitemaster_biz = new SiteMaster_Biz();

    public SiteMaster_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    #region 마스터 메뉴 조회
    /// <summary>
    /// 메인 메뉴 정보를 조회합니다.
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public string GetMainMenuList(object Gparam)
    {
        DataTable dt = new DataTable();
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        DataTable programDt = sitemaster_biz.GetMainMenuList(dicParam).Tables[0];

        if (programDt != null && programDt.Rows.Count > 0)
        {
            dt = IntertekFunction.ProgramListSort(programDt);
        }

        return JSONHelper.GetJSONString(dt, "result");
    }
    #endregion

    #region 페이지 명 가져오기
    [WebMethod]
    public string fn_SetProgramLink(string pageName)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam.Add("IV_PAGE_NAME", pageName);

        DataTable dt = sitemaster_biz.fn_SetProgramLink(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }
    #endregion


    #region 사이트 메인 데이터 조회
    [WebMethod]
    public string GetMainPageData(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var ds = sitemaster_biz.GetMainPageData(dicParam);

        string[] tableNames = { "MAINCOUNT_LIST", "WORKER_LIST", "NOTICE_LIST" };
        return JSONHelper.GetJSONString(ds, tableNames);
    }
    #endregion
    
}
