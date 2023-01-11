using CBKLMS.Biz.UI_Report;
using IntertekBase;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for ReportClose_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ReportClose_Service : System.Web.Services.WebService {

    ReportClose_Biz reportclose_biz = new ReportClose_Biz();

    public ReportClose_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// 마스터 조회
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetReportCloseList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = reportclose_biz.GetReportCloseList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 마스터 상세 조회
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string SetReportCloseDetail(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var ds = reportclose_biz.SetReportCloseDetail(dicParam);

        string[] tableNames = { "SAMPLE_LIST", "TEST_REPORT_LIST", "TEST_LIST" };

        return JSONHelper.GetJSONString(ds, tableNames);
    }

    /// <summary>
    /// 성적서 발행 완료 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveReportClose(object Gparam)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            result = reportclose_biz.SaveReportClose(ref result, dicParam);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// 증명서 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveReportCreate(object Gparam, object[] selectGrdArr)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            // 시료
            List<Dictionary<string, object>> listSample = new List<Dictionary<string, object>>();
            for (int i = 0; i < selectGrdArr.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)selectGrdArr[i];
                listSample.Add(dicAdd);
            }

            string ReportPath = "";

            // Default
            if (listSample.Count.Equals(1))
            {
                switch (dicParam["IV_REPORT_TYPE"].ToString())
                {
                    case "01":// 비공인, 영문
                        ReportPath = "ReportFiles/UI_Report/Default/RDLC_NonKolas_En_Report.rdlc";
                        break;
                    case "02":// 비공인, 국문
                        ReportPath = "ReportFiles/UI_Report/Default/RDLC_NonKolas_En_Report.rdlc";
                        break;
                    case "03":// 공인, 영문
                        ReportPath = "ReportFiles/UI_Report/Default/RDLC_NonKolas_En_Report.rdlc";
                        break;
                    case "04":// 공인, 국문
                        ReportPath = "ReportFiles/UI_Report/Default/RDLC_NonKolas_En_Report.rdlc";
                        break;
                    case "05":// 공인, ILAC, 영문
                        ReportPath = "ReportFiles/UI_Report/Default/RDLC_NonKolas_En_Report.rdlc";
                        break;
                    default:
                        ReportPath = "";
                        break;
                }   
            }
            else // Multiple
            {
                
            }
            

            // 파일 생성
            ReportViewer Rv = new ReportViewer();
            Rv.LocalReport.EnableExternalImages = true;
            Rv.LocalReport.ReportPath = ReportPath;

            result = reportclose_biz.SaveReportCreate(ref result, dicParam, listSample, Rv);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// 리포트 파일 조회
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetReportFileList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = reportclose_biz.GetReportFileList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// 성적서 발행 완료 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult fn_btn_use_click(object Gparam)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            result = reportclose_biz.fn_btn_use_click(ref result, dicParam);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }


    /// <summary>
    /// 성적서 발행 완료 저장
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveInvoice(object Gparam)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            result = reportclose_biz.SaveInvoice(ref result, dicParam);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

}
