using CBKLMS.Dac.UI_Report;
using IntertekBase;
using Microsoft.Office.Interop.Word;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace CBKLMS.Biz.UI_Report
{
    public class ReportClose_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 마스터 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetReportCloseList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (ReportClose_Dac dac = new ReportClose_Dac())
            {
                ds = dac.GetReportCloseList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 마스터 상세 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet SetReportCloseDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (ReportClose_Dac dac = new ReportClose_Dac())
            {
                ds = dac.SetReportCloseDetail(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 성적서 발행 완료 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveReportClose(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                using (ReportClose_Dac dac = new ReportClose_Dac())
                {
                    result = dac.SaveReportClose(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;
                }

                // Note - Commit
                scope.Complete();
            }
            catch (Exception ex)
            {
                result.OV_RTN_CODE = -1;
                result.OV_RTN_MSG = ex.Message;
            }
            finally
            {
                // Note - 트렌젝션을 닫는다.
                if (scope != null) scope.Dispose();
            }

            return result;
        }

        /// <summary>
        /// 리포트 파일 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetReportFileList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (ReportClose_Dac dac = new ReportClose_Dac())
            {
                ds = dac.GetReportFileList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 성적서 발행 완료 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult fn_btn_use_click(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                using (ReportClose_Dac dac = new ReportClose_Dac())
                {
                    result = dac.fn_btn_use_click(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;
                }

                // Note - Commit
                scope.Complete();
            }
            catch (Exception ex)
            {
                result.OV_RTN_CODE = -1;
                result.OV_RTN_MSG = ex.Message;
            }
            finally
            {
                // Note - 트렌젝션을 닫는다.
                if (scope != null) scope.Dispose();
            }

            return result;
        }


        /// <summary>
        /// 성적서 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekResult SaveReportCreate(ref IntertekResult result, Dictionary<string, object> dicParam, List<Dictionary<string, object>> listSample, ReportViewer Rv)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();
            string strServerPath = IntertekConfig.UploadServer_MonthPath("ReportClose");
            string strLocalPath = IntertekConfig.UploadLocal_MonthPath(@"ReportClose\");

            DirectoryInfo di = new DirectoryInfo(string.Format(@"{0}WORD\", strLocalPath));
            if (di.Exists == false)
            {
                di.Create();
            }
            DirectoryInfo di2 = new DirectoryInfo(string.Format(@"{0}PDF\", strLocalPath));
            if (di2.Exists == false)
            {
                di2.Create();
            }
            
            try
            {
                using (ReportClose_Dac dac = new ReportClose_Dac())
                {
                    string strFileName = dicParam["IV_REQ_CODE"].ToString() + "_" + dicParam["IV_REPORT_TYPE"].ToString();

                    string strWordFilePath = string.Format("{0}WORD/", strServerPath);
                    string strPdfFilePath = string.Format("{0}PDF/", strServerPath);
                    string str2DPdfFilePath = string.Format("{0}PDF/", strServerPath);

                    dicParam["IV_FILE_NM"] = strFileName;
                    dicParam["IV_FILE_WORD_URL"] = strWordFilePath + strFileName + ".doc";
                    dicParam["IV_FILE_PDF_URL"] = strPdfFilePath + strFileName + ".pdf";
                    dicParam["IV_FILE_2D_PDF_URL"] = str2DPdfFilePath + strFileName + ".pdf";

                    // [1] 파일 경로 저장
                    result = dac.SaveReportCreate(ref result, dicParam);
                    //// 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;

                    Dictionary<string, object> dicReport = new Dictionary<string, object>();

                    // [2] 샘플 저장
                    for (int i = 0; i < listSample.Count; i++)
                    {
                        dicReport.Add("IV_REQ_NUM", dicParam["IV_REQ_NUM"]);
                        dicReport.Add("IV_REPORT_ID", result.OV_RTN_MSG);
                        dicReport.Add("IV_SAMPLE_ID", listSample[i]["SAMPLE_ID"]);
                        dicReport.Add("IV_USER_ID", dicParam["IV_USER_ID"]);

                        result = dac.SaveReportCreate_Sample(ref result, dicReport);
                        //// 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }

                    // [3] 파일 생성
                    DataSet ds = new DataSet();
                    // Default
                    if (listSample.Count.Equals(1))
	                {
                        ds = dac.SaveReportCreate_ReportData(dicReport);
	                }
                    else // Multiple
	                {
                        
	                }
                    

                    ReportDataSource RDS1 = new ReportDataSource("DataSet1", ds.Tables[0]);
                    ReportDataSource RDS2 = new ReportDataSource("DataSet2", ds.Tables[1]);

                    Rv.LocalReport.DataSources.Clear();
                    //Rv.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(subreport);
                    Rv.LocalReport.DataSources.Add(RDS1);
                    Rv.LocalReport.DataSources.Add(RDS2);
                    Rv.LocalReport.Refresh();

                    ds.Dispose();

                    // 워드생성
                    string localWordPath = string.Format(@"{0}WORD\", strLocalPath);

                    string fileName = strFileName;
                    ExportDoc("Word", localWordPath, fileName, Rv);

                    // PDF 생성
                    string localWordFullPath = localWordPath + fileName + ".doc";
                    string localPdfFullPath = string.Format(@"{0}PDF\", strLocalPath) + fileName + ".pdf";
                    ExportPdf(localWordFullPath, localPdfFullPath);
                }

                // Note - Commit
                scope.Complete();
                // 트랜젝션을 끊어준다.
                if (scope != null) scope.Dispose();

                //#region 메일 전송
                //// 메일 전송 진행
                //using (HR_CertificateMgmt_Dac dac = new HR_CertificateMgmt_Dac())
                //{
                //    Dictionary<string, object> dicMail = new Dictionary<string, object>();
                //    dicMail.Add("IV_CERTI_ID", dicParam["IV_CERTI_ID"].ToString());
                //    dicMail.Add("IV_CERTI_USER_ID", dicParam["IV_CERTI_USER_ID"].ToString());
                //    dicMail.Add("IV_USER_ID", dicParam["IV_USER_ID"].ToString());

                //    var mailDt = dac.SaveCertiData_MailData(dicMail).Tables[0];

                //    if (mailDt != null && mailDt.Rows.Count > 0)
                //    {
                //        // 메일 보내기 / 로그
                //        DataRow dr = mailDt.Rows[0];
                //        string mail_subject = MailReplace(dr["MAIL_SUBJECT"].ToString(), dr, "");
                //        string mail_body = MailReplace(dr["MAIL_BODY"].ToString(), dr, dicParam["IV_REMARK"].ToString());

                //        var mailResult = IntertekFunction.SendMail(dr["SEND_MAIL"].ToString()
                //                                                 , dr["RECEIVE_MAIL"].ToString()
                //                                                 , ""
                //                                                 , ""
                //                                                 , mail_subject
                //                                                 , mail_body
                //                                                 , "");
                //        // 메일 로그 남기기 
                //        using (Common_Dac comdac = new Common_Dac())
                //        {
                //            Dictionary<string, object> mailDic = new Dictionary<string, object>();
                //            mailDic.Add("IV_MAIL_GB", "02");
                //            mailDic.Add("IV_MAIL_CD", "A1");
                //            mailDic.Add("IV_SEND_USER_ID", dr["SEND_USER_ID"].ToString());
                //            mailDic.Add("IV_SEND_NM", dr["SEND_USER_NM"].ToString());
                //            mailDic.Add("IV_SEND_EMAIL", dr["SEND_MAIL"].ToString());
                //            mailDic.Add("IV_RECEIVE_USER_ID", dr["RECEIVE_USER_ID"].ToString());
                //            mailDic.Add("IV_RECEIVE_NM", dr["RECEIVE_USER_NM"].ToString());
                //            mailDic.Add("IV_RECEIVE_EMAIL", dr["RECEIVE_MAIL"].ToString());
                //            mailDic.Add("IV_TITLE", mail_subject);
                //            mailDic.Add("IV_CONTENTS", mail_body);
                //            mailDic.Add("IV_MAIL_KEYS", dicParam["IV_CERTI_ID"].ToString() + "," + dicParam["IV_CERTI_USER_ID"].ToString());
                //            mailDic.Add("IV_RETURN_CODE", mailResult.OV_RTN_CODE);
                //            mailDic.Add("IV_RETURN_MSG", mailResult.OV_RTN_MSG);

                //            comdac.SendMailLog(ref mailResult, mailDic);
                //        }
                //    }
                //}
                //#endregion

            }
            catch (Exception ex)
            {
                result.OV_RTN_CODE = -1;
                result.OV_RTN_MSG = ex.Message;
            }
            finally
            {
                // Note - 트렌젝션을 닫는다.
                if (scope != null) scope.Dispose();
            }

            return result;
        }
        public void subreport(object sender, SubreportProcessingEventArgs e)
        {
            if (e.ReportPath.IndexOf("Certificate_Report_KR_Sub") > -1)
            {
                using (ReportClose_Dac dac = new ReportClose_Dac())
                {
                    DataSet ds = new DataSet();
                    //var ds = dac.SaveCertiData_ReportData(dicReport);
                    e.DataSources.Add(new ReportDataSource("DataSet1", ds.Tables[1]));    //Table[2] : 시험요약결과
                    ds.Dispose();
                }
            }
            //else if (e.ReportPath.IndexOf("시험성적서_부래당_결과판정") > -1)
            //{
            //    DataSet DS6 = sAdb.Get일반성적서_시료별결과(DownPR_REQ_NUM);
            //    //e.DataSources.Clear();
            //    e.DataSources.Add(new ReportDataSource("DataSet66", DS6.Tables[0]));    //Table[2] : 시험요약결과
            //    DS6.Dispose();
            //}
            //else if (e.ReportPath.IndexOf("시험성적서_일반_시험항목별결과") > -1 || e.ReportPath.IndexOf("시험성적서_영문_시험항목별결과") > -1)
            //{
            //    //var TestCode = int.Parse(e.Parameters["TestCode"].Values.First());
            //    var TestCode = int.Parse(e.Parameters["TestCode"].Values[0].ToString());

            //    DataSet DS11 = sAdb.Get일반성적서_시험항목별결과(DownPR_REQ_NUM, TestCode);
            //    //e.DataSources.Clear();
            //    e.DataSources.Add(new ReportDataSource("DataSet2", DS11.Tables[0]));

            //    DS11.Dispose();
            //}
        }

        /// <summary>
        ///  메일내용 변경하기.
        /// </summary>
        /// <param name="p"></param>
        /// <param name="dr"></param>
        /// <returns></returns>
        private string MailReplace(string desc, DataRow dr, string hr_remark)
        {
            desc = desc.Replace("[증명서타입]", dr["CERTI_GB_NM"].ToString());
            desc = desc.Replace("[받는사람]", dr["RECEIVE_USER_NM"].ToString());
            desc = desc.Replace("[받는사람직함]", dr["RECEIVE_DUTY_CD_KOR"].ToString());
            desc = desc.Replace("[보내는사람]", dr["SEND_USER_NM"].ToString());
            desc = desc.Replace("[보내는사람직함]", dr["SEND_DUTY_CD_KOR"].ToString());
            desc = desc.Replace("[HR코멘트]", hr_remark);
            desc = desc.Replace("[링크]", "<a href='" + IntertekConfig.GetERPLinkPath() + "'> 여기 </a>");
            desc = desc.Replace("[상태]", dr["STATUS_CD_NM"].ToString());

            return desc;
        }


        /// <summary>
        ///  파일 워드 저장
        /// </summary>
        /// <param name="p"></param>
        /// <param name="localWordSavePath"></param>
        /// <param name="Rv"></param>
        private void ExportDoc(string export_type, string filePath, string fileName, ReportViewer Rv)
        {
            string mimeType;
            string encoding;
            string fileNameExtension;
            Warning[] warnings;
            string[] streamids;

            byte[] exportBytes = Rv.LocalReport.Render(export_type, null, out mimeType, out encoding, out fileNameExtension, out streamids, out warnings);

            string fileFullName = fileName + "." + fileNameExtension;

            FileStream fs = new FileStream(filePath + fileName + "." + fileNameExtension, FileMode.Create);
            fs.Write(exportBytes, 0, exportBytes.Length);
            fs.Close();
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


        /// <summary>
        /// 성적서 메일 양식 가져오기.
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet Init_Mail_ReportClose(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (ReportClose_Dac dac = new ReportClose_Dac())
            {
                ds = dac.Init_Mail_ReportClose(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 성적서 메일발송 상태 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SendMail_Mail_ReportClose(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                using (ReportClose_Dac dac = new ReportClose_Dac())
                {
                    result = dac.SendMail_Mail_ReportClose(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;
                }

                // Note - Commit
                scope.Complete();
            }
            catch (Exception ex)
            {
                result.OV_RTN_CODE = -1;
                result.OV_RTN_MSG = ex.Message;
            }
            finally
            {
                // Note - 트렌젝션을 닫는다.
                if (scope != null) scope.Dispose();
            }

            return result;
        }


        /// <summary>
        /// 인보이스 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveInvoice(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                using (ReportClose_Dac dac = new ReportClose_Dac())
                {
                    result = dac.SaveInvoice(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;
                }

                // Note - Commit
                scope.Complete();
            }
            catch (Exception ex)
            {
                result.OV_RTN_CODE = -1;
                result.OV_RTN_MSG = ex.Message;
            }
            finally
            {
                // Note - 트렌젝션을 닫는다.
                if (scope != null) scope.Dispose();
            }

            return result;
        }


    }
}
