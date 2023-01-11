using CBKLMS.Biz.UI_Data;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for DataConfirm_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DataConfirm_Service : System.Web.Services.WebService {

    DataConfirm_Biz dataconfirm_biz = new DataConfirm_Biz();

    public DataConfirm_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// 마스터 조회
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetDataConfirmList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = dataconfirm_biz.GetDataConfirmList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }


    /// <summary>
    /// 마스터 상세 조회
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string SetDataConfirmDetail(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = dataconfirm_biz.SetDataConfirmDetail(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 결과검토 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveDataConfirm(object Gparam, object[] arrGparam)
    {
        IntertekResult result = new IntertekResult();

        List<Dictionary<string, object>> listDic = new List<Dictionary<string, object>>();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            for (int i = 0; i < arrGparam.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)arrGparam[i];
                listDic.Add(dicAdd);
            }

            result = dataconfirm_biz.SaveDataConfirm(ref result, dicParam, listDic);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// 결과검토 반려
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveDataConfirmReject(object Gparam, object[] arrGparam)
    {
        IntertekResult result = new IntertekResult();

        List<Dictionary<string, object>> listDic = new List<Dictionary<string, object>>();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            for (int i = 0; i < arrGparam.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)arrGparam[i];
                listDic.Add(dicAdd);
            }

            result = dataconfirm_biz.SaveDataConfirmReject(ref result, dicParam, listDic);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }
}
