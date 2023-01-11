using CBKLMS.Biz;
using CBKLMS.Biz.UI_Register;
using CBKLMS.Biz.UI_Report;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Popup_MailSend : BasePage
{
    DataSet commonds = new DataSet();
    public string return_url { get; set; }
    public string return_nm { get; set; }
    public string return_newYn { get; set; }
    public string return_fileList { get; set; }

    Common_Biz common_biz = new Common_Biz();

    string page = "";
    string key = "";
    List<string> listKey = new List<string>();

    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        page = Request.QueryString["page"];
        key = Request.QueryString["key"];

        listKey = key.ToString().Split(',').ToList();

        if (!Page.IsPostBack)
        {
            GetDefaultEmailData();
        }
        else
        {
            this.btnSend.Enabled = false;
        }
    }

    /// <summary>
    /// 초반 이메일 정보를 가져온다.
    /// </summary>
    private void GetDefaultEmailData()
    {
        try
        {
            #region 화면 별 저장 경로 설정
            switch (page)
            {
                case "Mail_Test":
                    this.hidfrom.Value = "donghwan.gu@intertek.com";
                    break;
                case "Mail_Quotation":
                    Init_Mail_Quotation();
                    break;
                case "Mail_Register_IN":
                    Init_Mail_Register_IN();
                    break;
                case "Mail_ReportClose":
                    Init_Mail_ReportClose();
                    break;
                default:
                    break;
            }
            #endregion
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

    /// <summary>
    /// 메일 테스트
    /// </summary>
    private void Mail_Test()
    {
        throw new NotImplementedException();
    }

    /// <summary>
    /// 메일전송
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnSend_Click(object sender, EventArgs e)
    {
        try
        {
            IntertekResult result = new IntertekResult();

            #region 화면 별
            switch (page)
            {
                case "Mail_Test":
                    result = SendMail_Test(ref result);
                    break;
                case "Mail_Quotation":
                    result = SendMail_Mail_Quotation(ref result);
                    break;
                case "Mail_Register_IN":
                    result = SendMail_Mail_Register_IN(ref result);
                    break;
                case "Mail_ReportClose":
                    result = SendMail_Mail_ReportClose(ref result);
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
                ShowMessage.AlertMessage("file Upload Error : " + result.OV_RTN_MSG);
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

    #region 메일 테스트
    private IntertekResult SendMail_Test(ref IntertekResult result)
    {
        string mail_subject = txtsubject.Text;//MailReplace(dr["MAIL_SUBJECT"].ToString(), dr, "");
        string mail_body = hidsummernote.Value;//MailReplace(dr["MAIL_BODY"].ToString(), dr, dicParam["IV_REMARK"].ToString());
        Attachment[] oAttachments = null;
        // 첨부파일 가져오기.
        oAttachments = GetUploadFileInfoList("Test");

        // 메일 보내기 / 로그
        result = IntertekFunction.SendMail_AttachFile(hidfrom.Value.ToString()
                                                    , txtemail_to.Text
                                                    , txtemail_cc.Text
                                                    , ""
                                                    , mail_subject
                                                    , mail_body
                                                    , oAttachments);

        if (result.OV_RTN_CODE.Equals(-1)) return result;

        return result;
    }
    #endregion

    #region Quotation
    /// <summary>
    /// Quotation : 메일 가져오기.
    /// </summary>
    private void Init_Mail_Quotation()
    {
        // 최초 정보조회
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam.Add("IV_REQ_NUM", listKey[0]);
        dicParam.Add("IV_USER_ID", listKey[1]);

        using (Quotation_Biz biz = new Quotation_Biz())
        {
            commonds = biz.Init_Mail_Quotation(dicParam);
        }

        if (commonds != null && commonds.Tables.Count > 0 && commonds.Tables[0].Rows.Count > 0)
        {
            DataTable commondt = commonds.Tables[0];
            string strTo = "";
            for (int i = 0; i < commondt.Rows.Count; i++)
            {
                strTo += commondt.Rows[i]["RECEIVE_MAIL"].ToString() + "; ";
            }
            this.hidfrom.Value = commondt.Rows[0]["SEND_MAIL"].ToString();
            this.txtemail_cc.Text = commondt.Rows[0]["SEND_MAIL"].ToString();
            this.hidsummernote.Value = Quotation_MailReplace(commondt.Rows[0]["MAIL_BODY"].ToString(), commondt.Rows[0]);
            this.txtemail_to.Text = strTo;
            this.txtsubject.Text = Quotation_MailReplace(commondt.Rows[0]["MAIL_SUBJECT"].ToString(), commondt.Rows[0]);
            this.ctlattach_list.Items.Clear();

            var fileDt = commonds.Tables[1];
            for (int j = 0; j < fileDt.Rows.Count; j++)
            {
                this.ctlattach_list.Items.Add(new ListItem(fileDt.Rows[j]["FILE_NM"].ToString(), fileDt.Rows[j]["FILE_URL"].ToString()));
            }
        }
    }

    /// <summary>
    ///  메일내용 변경하기.
    /// </summary>
    /// <param name="p"></param>
    /// <param name="dr"></param>
    /// <returns></returns>
    private string Quotation_MailReplace(string desc, DataRow dr)
    {
        // '[샘플접수/Sample reception][의뢰업체명]_[샘플명]_[접수번호]'
        desc = desc.Replace("[의뢰업체명]", dr["CUST_NM"].ToString());
        desc = desc.Replace("[샘플명]", dr["SAMPLE_NM"].ToString());
        desc = desc.Replace("[접수번호]", dr["REQ_CODE"].ToString());
        // </ 제목>

        // <바디>
        desc = desc.Replace("[업체정보]", dr["CUST_NM"].ToString());
        desc = desc.Replace("[시료명]", dr["SAMPLE_NM"].ToString());
        desc = desc.Replace("[시료정보]", dr["SAMPLE_GET_PLACE"].ToString());
        desc = desc.Replace("[접수일자]", dr["REGISTER_DT_NM"].ToString());
        desc = desc.Replace("[예정일자]", dr["REPORT_DUE_DT_NM"].ToString());
        // </바디>

        //desc = desc.Replace("[보내는사람직함]", dr["SEND_DUTY_CD_KOR"].ToString());
        //desc = desc.Replace("[받는사람]", dr["RECEIVE_USER_NM"].ToString());
        //desc = desc.Replace("[받는사람직함]", dr["RECEIVE_DUTY_CD_KOR"].ToString());
        ////desc = desc.Replace("[결제자코멘트]", dr["REMARK"].ToString());
        //desc = desc.Replace("[링크]", "<a href='" + IntertekConfig.GetERPLinkPath() + "'> 여기 </a>");

        return desc;
    }


    /// <summary>
    /// 견적서 : 발주 메일 전송
    /// </summary>
    private IntertekResult SendMail_Mail_Quotation(ref IntertekResult result)
    {

        string mail_subject = txtsubject.Text;//MailReplace(dr["MAIL_SUBJECT"].ToString(), dr, "");
        string mail_body = hidsummernote.Value;//MailReplace(dr["MAIL_BODY"].ToString(), dr, dicParam["IV_REMARK"].ToString());
        Attachment[] oAttachments = null;
        // 첨부파일 가져오기.
        oAttachments = GetUploadFileInfoList("Quotation_Mail");

        // 메일 보내기 / 로그
        result = IntertekFunction.SendMail_AttachFile(hidfrom.Value.ToString()
                                                    , txtemail_to.Text
                                                    , txtemail_cc.Text
                                                    , ""
                                                    , mail_subject
                                                    , mail_body
                                                    , oAttachments);

        if (result.OV_RTN_CODE.Equals(-1)) return result;

        // 최초 정보조회
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam.Add("IV_REQ_NUM", listKey[0]);
        dicParam.Add("IV_USER_ID", listKey[1]);
        // 최초 정보조회
        using (Quotation_Biz biz = new Quotation_Biz())
        {
            commonds = biz.Init_Mail_Quotation(dicParam);
        }
        var commondt = commonds.Tables[0];
        //// 메일 로그 남기기 
        using (Common_Biz biz = new Common_Biz())
        {
            Dictionary<string, object> mailDic = new Dictionary<string, object>();
            mailDic.Add("IV_MAIL_GB", "01");
            mailDic.Add("IV_MAIL_CD", "A1");
            mailDic.Add("IV_SEND_USER_ID", commondt.Rows[0]["SEND_USER_ID"].ToString());
            mailDic.Add("IV_SEND_NM", commondt.Rows[0]["SEND_USER_NM"].ToString());
            mailDic.Add("IV_SEND_EMAIL", hidfrom.Value.ToString());
            mailDic.Add("IV_RECEIVE_USER_ID", commondt.Rows[0]["RECEIVE_USER_ID"].ToString());
            mailDic.Add("IV_RECEIVE_NM", commondt.Rows[0]["RECEIVE_USER_NM"].ToString());
            mailDic.Add("IV_RECEIVE_EMAIL", txtemail_to.Text);
            mailDic.Add("IV_TITLE", mail_subject);
            mailDic.Add("IV_CONTENTS", mail_body);
            mailDic.Add("IV_MAIL_KEYS", listKey[0]);
            mailDic.Add("IV_RETURN_CODE", result.OV_RTN_CODE);
            mailDic.Add("IV_RETURN_MSG", result.OV_RTN_MSG);

            result = biz.SendMailLog(ref result, mailDic);
        }

        using (Quotation_Biz biz = new Quotation_Biz())
        {
            result = biz.SendMail_Mail_Quotation(ref result, dicParam);
            if (result.OV_RTN_CODE.Equals(-1)) return result;
        }

        return result;
    }

    #endregion


    #region ReportClose
    /// <summary>
    /// Quotation : 메일 가져오기.
    /// </summary>
    private void Init_Mail_ReportClose()
    {
        // 최초 정보조회
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam.Add("IV_REQ_NUM", listKey[0]);
        dicParam.Add("IV_USER_ID", listKey[1]);

        using (ReportClose_Biz biz = new ReportClose_Biz())
        {
            commonds = biz.Init_Mail_ReportClose(dicParam);
        }

        if (commonds != null && commonds.Tables.Count > 0 && commonds.Tables[0].Rows.Count > 0)
        {
            DataTable commondt = commonds.Tables[0];
            string strTo = "";
            for (int i = 0; i < commondt.Rows.Count; i++)
            {
                strTo += commondt.Rows[i]["RECEIVE_MAIL"].ToString() + "; ";
            }
            this.hidfrom.Value = commondt.Rows[0]["SEND_MAIL"].ToString();
            this.txtemail_cc.Text = commondt.Rows[0]["SEND_MAIL"].ToString();
            this.hidsummernote.Value = ReportClose_MailReplace(commondt.Rows[0]["MAIL_BODY"].ToString(), commondt.Rows[0]);
            this.txtemail_to.Text = strTo;
            this.txtsubject.Text = ReportClose_MailReplace(commondt.Rows[0]["MAIL_SUBJECT"].ToString(), commondt.Rows[0]);
            this.ctlattach_list.Items.Clear();

            var fileDt = commonds.Tables[1];
            for (int j = 0; j < fileDt.Rows.Count; j++)
            {
                this.ctlattach_list.Items.Add(new ListItem(fileDt.Rows[j]["FILE_NM"].ToString(), fileDt.Rows[j]["FILE_URL"].ToString()));
            }
        }
    }

    /// <summary>
    ///  메일내용 변경하기.
    /// </summary>
    /// <param name="p"></param>
    /// <param name="dr"></param>
    /// <returns></returns>
    private string ReportClose_MailReplace(string desc, DataRow dr)
    {
        // '[샘플접수/Sample reception][의뢰업체명]_[샘플명]_[접수번호]'
        desc = desc.Replace("[의뢰업체명]", dr["CUST_NM"].ToString());
        desc = desc.Replace("[샘플명]", dr["SAMPLE_NM"].ToString());
        desc = desc.Replace("[접수번호]", dr["REQ_CODE"].ToString());
        // </ 제목>

        // <바디>
        desc = desc.Replace("[업체정보]", dr["CUST_NM"].ToString());
        desc = desc.Replace("[시료명]", dr["SAMPLE_NM"].ToString());
        desc = desc.Replace("[시료정보]", dr["SAMPLE_GET_PLACE"].ToString());
        desc = desc.Replace("[접수일자]", dr["REGISTER_DT_NM"].ToString());
        desc = desc.Replace("[성적서번호]", dr["REPORT_NO"].ToString());
        // </바디>

        //desc = desc.Replace("[보내는사람직함]", dr["SEND_DUTY_CD_KOR"].ToString());
        //desc = desc.Replace("[받는사람]", dr["RECEIVE_USER_NM"].ToString());
        //desc = desc.Replace("[받는사람직함]", dr["RECEIVE_DUTY_CD_KOR"].ToString());
        ////desc = desc.Replace("[결제자코멘트]", dr["REMARK"].ToString());
        //desc = desc.Replace("[링크]", "<a href='" + IntertekConfig.GetERPLinkPath() + "'> 여기 </a>");

        return desc;
    }


    /// <summary>
    /// 견적서 : 발주 메일 전송
    /// </summary>
    private IntertekResult SendMail_Mail_ReportClose(ref IntertekResult result)
    {

        string mail_subject = txtsubject.Text;//MailReplace(dr["MAIL_SUBJECT"].ToString(), dr, "");
        string mail_body = hidsummernote.Value;//MailReplace(dr["MAIL_BODY"].ToString(), dr, dicParam["IV_REMARK"].ToString());
        Attachment[] oAttachments = null;
        // 첨부파일 가져오기.
        oAttachments = GetUploadFileInfoList("ReportClose_Mail");

        // 메일 보내기 / 로그
        result = IntertekFunction.SendMail_AttachFile(hidfrom.Value.ToString()
                                                    , txtemail_to.Text
                                                    , txtemail_cc.Text
                                                    , ""
                                                    , mail_subject
                                                    , mail_body
                                                    , oAttachments);

        if (result.OV_RTN_CODE.Equals(-1)) return result;

        // 최초 정보조회
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam.Add("IV_REQ_NUM", listKey[0]);
        dicParam.Add("IV_USER_ID", listKey[1]);
        // 최초 정보조회
        using (ReportClose_Biz biz = new ReportClose_Biz())
        {
            commonds = biz.Init_Mail_ReportClose(dicParam);
        }
        var commondt = commonds.Tables[0];
        //// 메일 로그 남기기 
        using (Common_Biz biz = new Common_Biz())
        {
            Dictionary<string, object> mailDic = new Dictionary<string, object>();
            mailDic.Add("IV_MAIL_GB", "02");
            mailDic.Add("IV_MAIL_CD", "A1");
            mailDic.Add("IV_SEND_USER_ID", commondt.Rows[0]["SEND_USER_ID"].ToString());
            mailDic.Add("IV_SEND_NM", commondt.Rows[0]["SEND_USER_NM"].ToString());
            mailDic.Add("IV_SEND_EMAIL", hidfrom.Value.ToString());
            mailDic.Add("IV_RECEIVE_USER_ID", commondt.Rows[0]["RECEIVE_USER_ID"].ToString());
            mailDic.Add("IV_RECEIVE_NM", commondt.Rows[0]["RECEIVE_USER_NM"].ToString());
            mailDic.Add("IV_RECEIVE_EMAIL", txtemail_to.Text);
            mailDic.Add("IV_TITLE", mail_subject);
            mailDic.Add("IV_CONTENTS", mail_body);
            mailDic.Add("IV_MAIL_KEYS", listKey[0]);
            mailDic.Add("IV_RETURN_CODE", result.OV_RTN_CODE);
            mailDic.Add("IV_RETURN_MSG", result.OV_RTN_MSG);

            result = biz.SendMailLog(ref result, mailDic);
        }

        using (ReportClose_Biz biz = new ReportClose_Biz())
        {
            result = biz.SendMail_Mail_ReportClose(ref result, dicParam);
            if (result.OV_RTN_CODE.Equals(-1)) return result;
        }

        return result;
    }

    #endregion

    #region Register_IN
    /// <summary>
    /// Quotation : 메일 가져오기.
    /// </summary>
    private void Init_Mail_Register_IN()
    {
        // 최초 정보조회
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam.Add("IV_REQ_NUM", listKey[0]);
        dicParam.Add("IV_USER_ID", listKey[1]);

        using (Register_IN_Biz biz = new Register_IN_Biz())
        {
            commonds = biz.Init_Mail_Register_IN(dicParam);
        }

        if (commonds != null && commonds.Tables.Count > 0 && commonds.Tables[0].Rows.Count > 0)
        {
            DataTable commondt = commonds.Tables[0];
            string strTo = "";
            for (int i = 0; i < commondt.Rows.Count; i++)
            {
                strTo += commondt.Rows[i]["RECEIVE_MAIL"].ToString() + "; ";
            }
            this.hidfrom.Value = commondt.Rows[0]["SEND_MAIL"].ToString();
            this.txtemail_cc.Text = commondt.Rows[0]["SEND_MAIL"].ToString();
            this.hidsummernote.Value = Register_IN_MailReplace(commondt.Rows[0]["MAIL_BODY"].ToString(), commondt.Rows[0]);
            this.txtemail_to.Text = strTo;
            this.txtsubject.Text = Register_IN_MailReplace(commondt.Rows[0]["MAIL_SUBJECT"].ToString(), commondt.Rows[0]);
            this.ctlattach_list.Items.Clear();

            //var fileDt = commonds.Tables[1];
            //for (int j = 0; j < fileDt.Rows.Count; j++)
            //{
            //    this.ctlattach_list.Items.Add(new ListItem(fileDt.Rows[j]["FILE_NM"].ToString(), fileDt.Rows[j]["FILE_URL"].ToString()));
            //}
        }
    }

    /// <summary>
    ///  메일내용 변경하기.
    /// </summary>
    /// <param name="p"></param>
    /// <param name="dr"></param>
    /// <returns></returns>
    private string Register_IN_MailReplace(string desc, DataRow dr)
    {
        // '[샘플접수/Sample reception][의뢰업체명]_[샘플명]_[접수번호]'
        desc = desc.Replace("[의뢰업체명]", dr["CUST_NM"].ToString());
        desc = desc.Replace("[샘플명]", dr["SAMPLE_NM"].ToString());
        desc = desc.Replace("[접수번호]", dr["REQ_CODE"].ToString());
        // </ 제목>

        // <바디>
        desc = desc.Replace("[업체정보]", dr["CUST_NM"].ToString());
        desc = desc.Replace("[시료명]", dr["SAMPLE_NM"].ToString());
        desc = desc.Replace("[시료정보]", dr["SAMPLE_GET_PLACE"].ToString());
        desc = desc.Replace("[접수일자]", dr["REGISTER_DT_NM"].ToString());
        desc = desc.Replace("[예정일자]", dr["REPORT_DUE_DT_NM"].ToString());
        // </바디>

        //desc = desc.Replace("[보내는사람직함]", dr["SEND_DUTY_CD_KOR"].ToString());
        //desc = desc.Replace("[받는사람]", dr["RECEIVE_USER_NM"].ToString());
        //desc = desc.Replace("[받는사람직함]", dr["RECEIVE_DUTY_CD_KOR"].ToString());
        ////desc = desc.Replace("[결제자코멘트]", dr["REMARK"].ToString());
        //desc = desc.Replace("[링크]", "<a href='" + IntertekConfig.GetERPLinkPath() + "'> 여기 </a>");

        return desc;
    }


    /// <summary>
    /// 견적서 : 발주 메일 전송
    /// </summary>
    private IntertekResult SendMail_Mail_Register_IN(ref IntertekResult result)
    {

        string mail_subject = txtsubject.Text;//MailReplace(dr["MAIL_SUBJECT"].ToString(), dr, "");
        string mail_body = hidsummernote.Value;//MailReplace(dr["MAIL_BODY"].ToString(), dr, dicParam["IV_REMARK"].ToString());
        Attachment[] oAttachments = null;
        // 첨부파일 가져오기.
        oAttachments = GetUploadFileInfoList("Register_IN_Mail");

        // 메일 보내기 / 로그
        result = IntertekFunction.SendMail_AttachFile(hidfrom.Value.ToString()
                                                    , txtemail_to.Text
                                                    , txtemail_cc.Text
                                                    , ""
                                                    , mail_subject
                                                    , mail_body
                                                    , oAttachments);

        if (result.OV_RTN_CODE.Equals(-1)) return result;

        // 최초 정보조회
        Dictionary<string, object> dicParam = new Dictionary<string, object>();
        dicParam.Add("IV_REQ_NUM", listKey[0]);
        dicParam.Add("IV_USER_ID", listKey[1]);
        // 최초 정보조회
        using (Register_IN_Biz biz = new Register_IN_Biz())
        {
            commonds = biz.Init_Mail_Register_IN(dicParam);
        }
        var commondt = commonds.Tables[0];
        //// 메일 로그 남기기 
        using (Common_Biz biz = new Common_Biz())
        {
            Dictionary<string, object> mailDic = new Dictionary<string, object>();
            mailDic.Add("IV_MAIL_GB", "03");
            mailDic.Add("IV_MAIL_CD", "A1");
            mailDic.Add("IV_SEND_USER_ID", commondt.Rows[0]["SEND_USER_ID"].ToString());
            mailDic.Add("IV_SEND_NM", commondt.Rows[0]["SEND_USER_NM"].ToString());
            mailDic.Add("IV_SEND_EMAIL", hidfrom.Value.ToString());
            mailDic.Add("IV_RECEIVE_USER_ID", commondt.Rows[0]["RECEIVE_USER_ID"].ToString());
            mailDic.Add("IV_RECEIVE_NM", commondt.Rows[0]["RECEIVE_USER_NM"].ToString());
            mailDic.Add("IV_RECEIVE_EMAIL", txtemail_to.Text);
            mailDic.Add("IV_TITLE", mail_subject);
            mailDic.Add("IV_CONTENTS", mail_body);
            mailDic.Add("IV_MAIL_KEYS", listKey[0]);
            mailDic.Add("IV_RETURN_CODE", result.OV_RTN_CODE);
            mailDic.Add("IV_RETURN_MSG", result.OV_RTN_MSG);

            result = biz.SendMailLog(ref result, mailDic);
        }
        return result;
    }

    #endregion


    #region 공통 업로드 파일 취합
    /// <summary>
    /// [ 공통 ]업로드 파일정보 가져오기.
    /// </summary>
    /// <returns></returns>
    private Attachment[] GetUploadFileInfoList(string savePage)
    {
        List<Attachment> oAttachments = new List<Attachment>();

        for (int i = 0; i < ctlattach_list.Items.Count; i++)
        {
            //IntertekConfig.Local_Path;
            string sFilePath = ctlattach_list.Items[i].Value.ToString()
                .Replace(IntertekConfig.Server_Path_Test.ToString(), IntertekConfig.Local_Path().ToString())
                .Replace(IntertekConfig.Server_Path_Real.ToString(), IntertekConfig.Local_Path().ToString()).Replace("/", @"\");
            FileInfo fFile = new FileInfo(sFilePath);

            if (fFile.Exists)
            {
                string strFullfileName = sFilePath;
                string strFileName = Path.GetFileName(sFilePath);
                oAttachments.Add(new Attachment(strFullfileName) { Name = strFileName });
            }
        }

        if (ctlupload_list.HasFile)
        {
            for (int i = 0; i < ctlupload_list.PostedFiles.Count; i++)
            {
                string org_file_name = ctlupload_list.PostedFiles[i].FileName;
                string org_file_size = ctlupload_list.PostedFiles[i].ContentLength.ToString();
                string org_file_type = ctlupload_list.PostedFiles[i].ContentType;

                string ext = org_file_name.Substring(org_file_name.LastIndexOf('.'));
                string newID = CkUserId + DateTime.Now.ToString("yyyyMMddHHmmssfff") + i.ToString() + ext;
                string fillPath = IntertekConfig.UploadLocal_MonthPath(savePage) + newID;
                ctlupload_list.PostedFiles[i].SaveAs(fillPath);

                // fullfileName : 첨부파일의 전체 경로
                oAttachments.Add(new Attachment(fillPath) { Name = org_file_name });
            }
        }

        return oAttachments.ToArray();
    }
    #endregion
}