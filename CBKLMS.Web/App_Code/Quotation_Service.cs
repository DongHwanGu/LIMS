using CBKLMS.Biz.UI_Register;
using IntertekBase;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for Quotation_Service
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Quotation_Service : System.Web.Services.WebService {

    Quotation_Biz quotation_biz = new Quotation_Biz();

    public Quotation_Service () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    /// <summary>
    /// 마스터 조회
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetRegisterList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = quotation_biz.GetRegisterList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }

    /// <summary>
    /// Save 승인요청
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveRegisterFirstApproval(object[] pm_req_quotation_approval)
    {
        IntertekResult result = new IntertekResult();

        List<Dictionary<string, object>> listAppr = new List<Dictionary<string, object>>();

        try
        {
            for (int i = 0; i < pm_req_quotation_approval.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)pm_req_quotation_approval[i];
                listAppr.Add(dicAdd);
            }

            result = quotation_biz.SaveRegisterFirstApproval(ref result, listAppr);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// Approval
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveQuotationAprooval(object Gparam)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            result = quotation_biz.SaveQuotationAprooval(ref result, dicParam);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// 리셋
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveQuotationReset(object Gparam)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            result = quotation_biz.SaveQuotationReset(ref result, dicParam);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// 취소
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveQuotationClosed(object Gparam)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            result = quotation_biz.SaveQuotationClosed(ref result, dicParam);
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
    public IntertekResult SaveQuotationCreate(object Gparam)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            string ReportPath = "";

            switch (dicParam["IV_QUOTATION_TYPE"].ToString())
            {
                case "01":// 국문, 원화
                    if (dicParam["IV_TAX_TYPE"].ToString().Equals("01"))
                    {
                        // 과세
                        ReportPath = "ReportFiles/UI_Register/Quotation_Kr_WON_Report.rdlc";
                    }
                    else
                    {
                        // 비과세
                        ReportPath = "ReportFiles/UI_Register/Quotation_Kr_WON_NOTAX_Report.rdlc";
                    }
                    break;
                case "02":// 영문, 달러
                    ReportPath = "ReportFiles/UI_Register/Quotation_En_USD_Report.rdlc";
                    break;
                case "03":// 영문, 원화
                    if (dicParam["IV_TAX_TYPE"].ToString().Equals("01"))
                    {
                        // 과세
                        ReportPath = "ReportFiles/UI_Register/Quotation_En_WON_Report.rdlc";
                    }
                    else
                    {
                        // 비과세
                        ReportPath = "ReportFiles/UI_Register/Quotation_En_WON_NOTAX_Report.rdlc";
                    }
                    break;
                ////////////////////// 단가 기재 ////////////////////////////////////////////////////
                case "04":// 국문, 원화
                    if (dicParam["IV_TAX_TYPE"].ToString().Equals("01"))
                    {
                        // 과세
                        ReportPath = "ReportFiles/UI_Register/UP_Quotation_Kr_WON_Report.rdlc";
                    }
                    else
                    {
                        // 비과세
                        ReportPath = "ReportFiles/UI_Register/UP_Quotation_Kr_WON_NOTAX_Report.rdlc";
                    }
                    break;
                case "05":// 영문, 달러
                    ReportPath = "ReportFiles/UI_Register/UP_Quotation_En_USD_Report.rdlc";
                    break;
                case "06":// 영문, 원화
                    if (dicParam["IV_TAX_TYPE"].ToString().Equals("01"))
                    {
                        // 과세
                        ReportPath = "ReportFiles/UI_Register/UP_Quotation_En_WON_Report.rdlc";
                    }
                    else
                    {
                        // 비과세
                        ReportPath = "ReportFiles/UI_Register/UP_Quotation_En_WON_NOTAX_Report.rdlc";
                    }
                    break;
                default:
                    ReportPath = "";
                    break;
            }


            // 파일 생성
            ReportViewer Rv = new ReportViewer();
            Rv.LocalReport.EnableExternalImages = true;
            Rv.LocalReport.ReportPath = ReportPath;

            result = quotation_biz.SaveQuotationCreate(ref result, dicParam, Rv);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }

    /// <summary>
    /// 발행목록 조회
    /// </summary>
    /// <param name="Gparam"></param>
    /// <returns></returns>
    [WebMethod]
    public string GetQuotationFileList(object Gparam)
    {
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam = (Dictionary<string, object>)Gparam;

        var dt = quotation_biz.GetQuotationFileList(dicParam).Tables[0];

        return JSONHelper.GetJSONString(dt, "result");
    }


    /// <summary>
    /// 견적서 삭제유무
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

            result = quotation_biz.fn_btn_use_click(ref result, dicParam);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }


    /// <summary>
    /// 견적 접수
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public IntertekResult SaveQuotationGoToRegister(object Gparam, object[] arrGparam)
    {
        IntertekResult result = new IntertekResult();

        try
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam = (Dictionary<string, object>)Gparam;

            List<Dictionary<string, object>> listSample = new List<Dictionary<string, object>>();
            for (int i = 0; i < arrGparam.Count(); i++)
            {
                Dictionary<string, object> dicAdd = new Dictionary<string, object>();
                dicAdd = (Dictionary<string, object>)arrGparam[i];
                listSample.Add(dicAdd);
            }

            result = quotation_biz.SaveQuotationGoToRegister(ref result, dicParam, listSample);
        }
        catch (Exception ex)
        {
            result.OV_RTN_CODE = -1;
            result.OV_RTN_MSG = ex.Message;
        }

        return result;
    }
}
