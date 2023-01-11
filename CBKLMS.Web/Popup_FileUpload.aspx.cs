using CBKLMS.Biz.UI_Data;
using IntertekBase;
using Microsoft.Office.Interop.Word;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Popup_FileUpload : BasePage
{
    DataInput_Biz datainput_biz = new DataInput_Biz();

    public string return_url { get; set; }
    public string return_nm { get; set; }
    public string return_newYn { get; set; }
    public string return_fileList { get; set; }

    string page = "";
    string key = "";
    List<string> listKey = new List<string>();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack)
        {
            this.btnSend.Enabled = false;
        }

        page = Request.QueryString["page"];
        key = Request.QueryString["key"];

        listKey = key.ToString().Split(',').ToList();
    }

    /// <summary>
    /// 파일 전송
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnSend_Click(object sender, EventArgs e)
    {
        try
        {
            if (file_list.HasFile)
            {
                IntertekResult result = new IntertekResult();

                #region 화면 별 저장 경로 설정
                switch (page)
                {
                    case "Register_IN":
                        result = SaveRegister_IN(ref result);
                        break;
                    case "Register_IN_Sample":
                        result = SaveRegister_IN(ref result);
                        break;
                    case "DataInput_Test":
                        result = SaveDataInput(ref result);
                        break;
                    case "ReportClose":
                        result = SaveReportClose(ref result);
                        break;
                    case "Announcement":
                        result = SaveAnnouncement(ref result);
                        break;
                    case "Invoice":
                        result = SaveInvoice(ref result);
                        break;
                    default:
                        break;
                }
                #endregion

                if (result.OV_RTN_CODE == 0)
                {
                    this.Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "callme_callback();", true);
                }
                else
                {
                    ShowMessage.AlertMessage("file Upload DataBase Error : " + result.OV_RTN_MSG);
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage.AlertMessage(ex.Message);
        }
        finally
        {
            this.btnSend.Enabled = true;
        }
    }

    #region 공지사항
    private IntertekResult SaveAnnouncement(ref IntertekResult result)
    {
        System.Data.DataTable dt = new System.Data.DataTable();
        dt.Columns.Add("id");
        dt.Columns.Add("FILE_SEQ");
        dt.Columns.Add("FILE_NM");
        dt.Columns.Add("FILE_URL");

        for (int i = 0; i < file_list.PostedFiles.Count; i++)
        {
            string org_file_name = file_list.PostedFiles[i].FileName;
            string org_file_size = file_list.PostedFiles[i].ContentLength.ToString();
            string org_file_type = file_list.PostedFiles[i].ContentType;

            string ext = org_file_name.Substring(org_file_name.LastIndexOf('.'));
            string newID = CkUserId + "_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + i.ToString() + ext;

            file_list.PostedFiles[i].SaveAs(IntertekConfig.UploadLocal_MonthPath(page) + newID);

            DataRow dr = dt.NewRow();
            dr["id"] = newID;
            dr["FILE_SEQ"] = "New";
            dr["FILE_NM"] = org_file_name;
            dr["FILE_URL"] = IntertekConfig.UploadServer_MonthPath(page) + newID;
            dt.Rows.Add(dr);

            return_nm = dr["FILE_NM"].ToString();
            return_url = dr["FILE_URL"].ToString();
        }

        result.OV_RTN_CODE = 0;
        result.OV_RTN_MSG = "성공";
        return_fileList = JSONHelper.GetJSONString(dt, "result");

        return result;
    }
    #endregion

    #region Register IN
    private IntertekResult SaveRegister_IN(ref IntertekResult result)
    {
        System.Data.DataTable dt = new System.Data.DataTable();
        dt.Columns.Add("id");
        dt.Columns.Add("FILE_SEQ");
        dt.Columns.Add("FILE_NM");
        dt.Columns.Add("FILE_URL");

        for (int i = 0; i < file_list.PostedFiles.Count; i++)
        {
            string org_file_name = file_list.PostedFiles[i].FileName;
            string org_file_size = file_list.PostedFiles[i].ContentLength.ToString();
            string org_file_type = file_list.PostedFiles[i].ContentType;

            string ext = org_file_name.Substring(org_file_name.LastIndexOf('.'));
            string newID = CkUserId + "_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + i.ToString() + ext;

            file_list.PostedFiles[i].SaveAs(IntertekConfig.UploadLocal_MonthPath(page) + newID);

            DataRow dr = dt.NewRow();
            dr["id"] = newID;
            dr["FILE_SEQ"] = "New";
            dr["FILE_NM"] = org_file_name;
            dr["FILE_URL"] = IntertekConfig.UploadServer_MonthPath(page) + newID;
            dt.Rows.Add(dr);

            return_nm = dr["FILE_NM"].ToString();
            return_url = dr["FILE_URL"].ToString();
        }

        result.OV_RTN_CODE = 0;
        result.OV_RTN_MSG = "성공";
        return_fileList = JSONHelper.GetJSONString(dt, "result");

        return result;
    }
    #endregion

    #region DataInput
    private IntertekResult SaveDataInput(ref IntertekResult result)
    {
        List<Dictionary<string, object>> listDic = new List<Dictionary<string, object>>();

        System.Data.DataTable dt = new System.Data.DataTable();
        dt.Columns.Add("id");
        dt.Columns.Add("FILE_SEQ");
        dt.Columns.Add("FILE_NM");
        dt.Columns.Add("FILE_URL");

        for (int i = 0; i < file_list.PostedFiles.Count; i++)
        {
            string org_file_name = file_list.PostedFiles[i].FileName;
            string org_file_size = file_list.PostedFiles[i].ContentLength.ToString();
            string org_file_type = file_list.PostedFiles[i].ContentType;

            string ext = org_file_name.Substring(org_file_name.LastIndexOf('.'));
            string newID = CkUserId + "_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + i.ToString() + ext;

            file_list.PostedFiles[i].SaveAs(IntertekConfig.UploadLocal_MonthPath(page) + newID);

            DataRow dr = dt.NewRow();
            dr["id"] = newID;
            dr["FILE_SEQ"] = "New";
            dr["FILE_NM"] = org_file_name;
            dr["FILE_URL"] = IntertekConfig.UploadServer_MonthPath(page) + newID;
            dt.Rows.Add(dr);

            return_nm = dr["FILE_NM"].ToString();
            return_url = dr["FILE_URL"].ToString();

            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("IV_REQ_NUM", listKey[0]);
            dic.Add("IV_SAMPLE_ID", listKey[1]);
            dic.Add("IV_TEST_SEQ", listKey[2]);
            dic.Add("IV_FILE_NM", dr["FILE_NM"].ToString());
            dic.Add("IV_FILE_URL", dr["FILE_URL"].ToString());
            dic.Add("IV_USER_ID", listKey[3]);
            listDic.Add(dic);
        }

        result = datainput_biz.SaveDataInput_Test_File(ref result, listDic);

        return result;
    } 
    #endregion

    #region ReportClose
    private IntertekResult SaveReportClose(ref IntertekResult result)
    {
        for (int i = 0; i < file_list.PostedFiles.Count; i++)
        {
            // "http://172.17.92.18:7070/Upload/ReportClose/2020/02/WORD/CBKU20020004_01.doc"
            var file_word_url = listKey[2];
            // "ReportClose/2020/02/WORD/CBKU20020004_01.doc"
            var file_fullurl = file_word_url.Replace(IntertekConfig.Server_Path_Test, "").Replace(IntertekConfig.Server_Path_Real, "");
            // "ReportClose\2020\02\WORD\CBKU20020004_01.doc"
            file_fullurl = file_fullurl.Replace("/", @"\");
            // "local" + "ReportClose\2020\02\WORD\CBKU20020004_01.doc"
            file_fullurl = IntertekConfig.Local_Path() + file_fullurl.Replace("/", @"\");

            file_list.PostedFiles[i].SaveAs(file_fullurl);

            // PDF 생성
            string localWordFullPath = file_fullurl;
            string localPdfFullPath = file_fullurl.Replace("WORD", "PDF").Replace(".doc", ".pdf");
            ExportPdf(localWordFullPath, localPdfFullPath);
        }

        result.OV_RTN_CODE = 0;
        result.OV_RTN_MSG = "성공";

        return result;
    }

    /// <summary>
    /// 파일 PDF 저장
    /// </summary>
    /// <param name="localWordFullPath"></param>
    /// <param name="localPdfFullPath"></param>
    private void ExportPdf(string localWordFullPath, string localPdfFullPath)
    {
        Microsoft.Office.Interop.Word.Application word = new Microsoft.Office.Interop.Word.Application();
        Microsoft.Office.Interop.Word.Document wordDoc = new Microsoft.Office.Interop.Word.Document();
        Object oMissing = System.Reflection.Missing.Value;
        object SaveChanges = WdSaveOptions.wdDoNotSaveChanges;

        try
        {
            wordDoc = word.Documents.Add(ref oMissing, ref oMissing, ref oMissing, ref oMissing);
            word.Visible = false;

            object filepath = localWordFullPath;

            Object confirmconversion = System.Reflection.Missing.Value;
            Object readOnly = false;
            Object oallowsubstitution = System.Reflection.Missing.Value;

            wordDoc = word.Documents.Open(ref filepath, ref confirmconversion, ref readOnly, ref oMissing,
            ref oMissing, ref oMissing, ref oMissing, ref oMissing,
            ref oMissing, ref oMissing, ref oMissing, ref oMissing,
            ref oMissing, ref oMissing, ref oMissing, ref oMissing);

            word.Visible = false;

            object fileFormat = WdSaveFormat.wdFormatPDF;

            Object saveto = localPdfFullPath;    // Local 에 임시 생성.

            wordDoc.SaveAs(ref saveto, ref fileFormat, ref oMissing, ref oMissing, ref oMissing,
            ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing,
            ref oMissing, ref oMissing, ref oMissing, ref oallowsubstitution, ref oMissing,
            ref oMissing);
        }
        catch (Exception)
        {
            throw;
        }
        finally
        {
            ((_Application)word).Quit(ref SaveChanges, ref oMissing, ref oMissing);
        }
    }
    #endregion

    #region Invoice
    private IntertekResult SaveInvoice(ref IntertekResult result)
    {
        System.Data.DataTable dt = new System.Data.DataTable();
        dt.Columns.Add("id");
        dt.Columns.Add("FILE_SEQ");
        dt.Columns.Add("FILE_NM");
        dt.Columns.Add("FILE_URL");

        for (int i = 0; i < file_list.PostedFiles.Count; i++)
        {
            string org_file_name = file_list.PostedFiles[i].FileName;
            string org_file_size = file_list.PostedFiles[i].ContentLength.ToString();
            string org_file_type = file_list.PostedFiles[i].ContentType;

            string ext = org_file_name.Substring(org_file_name.LastIndexOf('.'));
            string newID = CkUserId + "_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + i.ToString() + ext;

            file_list.PostedFiles[i].SaveAs(IntertekConfig.UploadLocal_MonthPath(page) + newID);

            DataRow dr = dt.NewRow();
            dr["id"] = newID;
            dr["FILE_SEQ"] = "New";
            dr["FILE_NM"] = org_file_name;
            dr["FILE_URL"] = IntertekConfig.UploadServer_MonthPath(page) + newID;
            dt.Rows.Add(dr);

            return_nm = dr["FILE_NM"].ToString();
            return_url = dr["FILE_URL"].ToString();
        }

        result.OV_RTN_CODE = 0;
        result.OV_RTN_MSG = "성공";
        return_fileList = JSONHelper.GetJSONString(dt, "result");

        return result;
    }
    #endregion
}