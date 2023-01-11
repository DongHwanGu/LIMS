using System;
using System.Web;
using System.Web.UI;
using System.Text;
using System.Collections;
using System.IO;
using System.Data;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using System.Runtime.InteropServices;
using Excel = Microsoft.Office.Interop.Excel;
using System.Drawing;

namespace Framework.Web
{
    /// <summary>
    /// 웹에서 지정한 데이타로 엑셀을 만들어 다운로드 합니다.<para></para>
    /// - 작  성  자 : (totoropia@gmail.com) <para></para>
    /// - 최초작성일 : 2010년 04월 13일<para></para>
    /// - 최초수정자 : <para></para>
    /// - 최초수정일 : <para></para>
    /// - 주요변경로그 <para></para>
    /// </summary>
    public class ExcelDownload
    {
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
        public struct NETRESOURCE
        {
            public uint dwScope;
            public uint dwType;
            public uint dwDisplayType;
            public uint dwUsage;
            public string lpLocalName;
            public string lpRemoteName;
            public string lpComment;
            public string lpProvider;
        }

        [DllImport("mpr.dll", CharSet = CharSet.Auto)]
        public static extern int WNetUseConnection(
                    IntPtr hwndOwner,
                    [MarshalAs(UnmanagedType.Struct)] ref NETRESOURCE lpNetResource,
                    string lpPassword,
                    string lpUserID,
                    uint dwFlags,
                    StringBuilder lpAccessName,
                    ref int lpBufferSize,
                    out uint lpResult);
        /// <summary>
        /// 웹에서 지정한 데이타로 엑셀을 만들어 다운로드 합니다.<para></para>
        /// </summary>
        public ExcelDownload() { }

        #region == Html To Excel ==


        /// <summary>
        /// HtmlTable을 기반으로 Html 파일을 만들어 Client로 내려보낸다. <para></para>
        /// - 작  성  자 : (kys@.co.kr) <para></para>
        /// - 최초작성일 : 2010년 04월 13일<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// </summary>
        /// <param name="page"></param>
        /// <param name="htmlTable"></param>
        public static void HtmlTableToHtml(Page page, System.Web.UI.HtmlControls.HtmlGenericControl htmlTable)
        {
            ExcelDownload.HtmlTableToExcel(page, htmlTable, string.Empty);
        }

        /// <summary>
        /// HtmlTable을 기반으로 Excel 파일을 만들어 Client로 내려보낸다. <para></para>
        /// - 작  성  자 : (kys@.co.kr) <para></para>
        /// - 최초작성일 : 2010년 04월 13일<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// </summary>
        /// <param name="page"></param>
        /// <param name="htmlTable"></param>
        /// <param name="addHtml"></param>
        public static void HtmlTableToExcel(Page page, System.Web.UI.HtmlControls.HtmlGenericControl htmlTable, string addHtml)
        {
            string fileName = DateTime.Now.ToString("yyyyMMddHHmmss") + ".xls";

            page.Response.ContentType = "application/vnd.ms-excel";
            page.Response.AddHeader("Content-Disposition", "attachment;fileName=" + fileName);
            //page.Response.Charset = "ks_c_5601-1987";
            //page.Response.ContentEncoding = System.Text.Encoding.UTF8;
            //윈도우 서버의 언어가 한글이 기본인 경우 엑셀파일 깨짐구분을 아래로 변경
            page.Response.Charset = "euc-kr";
            page.Response.ContentEncoding = System.Text.Encoding.GetEncoding("euc-kr"); 

            if (addHtml != "") page.Response.Write(addHtml);

            System.IO.StringWriter tw = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter hw = new System.Web.UI.HtmlTextWriter(tw);

            htmlTable.RenderControl(hw);
            page.Response.Write(tw.ToString());
            page.Response.End();
        }

        /// <summary>
        /// Html테그로 만들어진 문자열을 엑셀로 내보낸다.<para></para>
        /// * 파일명은 이름만지정합니다. 확장자는 붙이지 마십시오.<para></para>
        /// </summary>
        /// <param name="page"></param>
        /// <param name="filename"></param>
        /// <param name="htmlString"></param>
        public static void HtmlStringToExcel(Page page, string filename, string htmlString)
        {
            string strAddHtml = string.Empty;
            string strFileName = string.Empty;
            StringBuilder strExcel = new StringBuilder();

            // 별도로 입력한 파일명이 없다면 날자로 파일명칭을 만들어준다.
            if (strFileName.Length == 0)
                strFileName = DateTime.Now.ToString("yyyy-MM-dd_HHmmss") + ".xls";
            else
                strFileName = strFileName + ".xls";

            page.Response.AddHeader("content-disposition", "attachment; filename=" + HttpUtility.UrlPathEncode(strFileName));
            page.Response.ContentType = "application/vnd.ms-excel";
            page.Response.CacheControl = "private";
            //page.Response.Charset = "ks_c_5601-1987";
            //page.Response.ContentEncoding = System.Text.Encoding.Default;
            //윈도우 서버의 언어가 한글이 기본인 경우 엑셀파일 깨짐구분을 아래로 변경
            page.Response.Charset = "euc-kr";
            page.Response.ContentEncoding = System.Text.Encoding.GetEncoding("euc-kr"); 

            strExcel.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'");
            strExcel.Append("xmlns:x='urn:schemas-microsoft-com:office:excel'");
            strExcel.Append("xmlns='http://www.w3.org/TR/REC-html40'>");
            strExcel.Append("<head>");
            //strExcel.Append("<meta http-equiv=Content-Type content='text/html; charset=ks_c_5601-1987'>");
            strExcel.Append("<meta http-equiv=Content-Type content='text/html; charset=euc-kr'>");
            strExcel.Append("</head>");

            // 코드내용을 입력한다.
            strExcel.Append(htmlString);

            strExcel.Append("</html>");

            string convStr = strExcel.ToString();
            convStr = System.Text.RegularExpressions.Regex.Replace(convStr, "&nbsp;", " ");

            page.Response.Write(convStr);
            page.Response.End();
        }

        #endregion == Html To Excel ==

        #region == DataTable To Excel ==

        /// <summary>
        /// DataTable을 기반으로 Excel을 만들어 Client로 내려보낸다. <para></para>
        /// - 작  성  자 : (kys@.co.kr) <para></para>
        /// - 최초작성일 : 2010년 04월 13일<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// </summary>
        /// <param name="page"></param>
        /// <param name="dataTable"></param>
        /// <param name="addHtml"></param>
        /// <returns></returns>
        public static string DataTableToExcel(Page page, DataTable dataTable, string addHtml)
        {
            return ExcelDownload.DataTableToExcel(page, dataTable, addHtml, string.Empty, "");
        }

        //file Path 추가
        public static string DataTableToExcel(Page page, DataTable dataTable, string addHtml, string filePath)
        {
            return ExcelDownload.DataTableToExcel(page, dataTable, addHtml, string.Empty, filePath);
        }

        /// <summary>
        /// DataTable을 기반으로 Excel을 만들어 Client로 내려보낸다. <para></para>
        /// - 작  성  자 : (kys@.co.kr) <para></para>
        /// - 최초작성일 : 2010년 04월 13일<para></para>
        /// - 최초수정자 : <para></para>
        /// - 최초수정일 : <para></para>
        /// - 주요변경로그 <para></para>
        /// </summary>
        /// <param name="page"></param>
        /// <param name="dataTable"></param>
        /// <param name="addHtml"></param>
        /// <param name="fileName">파일명 확장자명은 빼고 이름만..</param>
        /// <param name="filePath">파일 저장 경로</param>
        /// <returns></returns>
        public static string DataTableToExcel(Page page, DataTable dataTable, string addHtml, string fileName, string filePath)
        {
            StringBuilder sbExcel = new StringBuilder();

            //for Excel
            if (fileName.Length == 0)
                fileName = DateTime.Now.ToString("yyyyMMddHHmmss") + ".xls";
            else
                fileName = fileName + ".xls";

            page.Response.AddHeader("content-disposition", "attachment; filename=" + HttpUtility.UrlPathEncode(fileName));
            //page.Response.ContentType = "application/vnd.ms-excel";
            page.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            page.Response.CacheControl = "private";
            //page.Response.Charset = "ks_c_5601-1987";
            //page.Response.ContentEncoding = System.Text.Encoding.Default;
            //윈도우 서버의 언어가 한글이 기본인 경우 엑셀파일 깨짐구분을 아래로 변경
            page.Response.Charset = "euc-kr";
            page.Response.ContentEncoding = System.Text.Encoding.GetEncoding("euc-kr"); 

            sbExcel.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'");
            sbExcel.Append("xmlns:x='urn:schemas-microsoft-com:office:excel'");
            sbExcel.Append("xmlns='http://www.w3.org/TR/REC-html40'>");
            sbExcel.Append("<head>");
            sbExcel.Append("<meta http-equiv=Content-Type content='text/html; charset=euc-kr'>");
            sbExcel.Append("</head>");

            if (addHtml != "") sbExcel.Append(addHtml);
            sbExcel.Append(@"<table x:str border=1 cellpadding='0' cellspacing='0'>
                                        <tr>");

            for (int i = 0; i < dataTable.Columns.Count; i++)
            {
                sbExcel.Append("<th>");
                sbExcel.Append(dataTable.Columns[i].ColumnName);
                sbExcel.Append("</th>");
            }

            sbExcel.Append("</tr>");
            for (int i = 0; i < dataTable.Rows.Count; i++)
            {
                sbExcel.Append("<tr>");
                for (int j = 0; j < dataTable.Columns.Count; j++)
                {
                    sbExcel.Append("<td>");
                    sbExcel.Append(dataTable.Rows[i][j].ToString());
                    sbExcel.Append("</td>");
                }
                sbExcel.Append("</tr>");
            }
            sbExcel.Append("</table>");
            sbExcel.Append("</html>");

            string convStr = sbExcel.ToString();
            convStr = System.Text.RegularExpressions.Regex.Replace(convStr, "&nbsp;", " ");

            //저장 경로 지정
            if (filePath != "" && filePath != null)
            {

                if (!System.IO.Directory.Exists(filePath))
                    System.IO.Directory.CreateDirectory(filePath);
                File.WriteAllText(filePath + fileName, convStr, UnicodeEncoding.UTF8);
            }

            page.Response.Write(convStr);
            //page.Response.End();

            return convStr;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="page"></param>
        /// <param name="dataTable"></param>
        /// <param name="excelHeadInfo"></param>
        /// <param name="addHtml"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static string DataTableToExcel(Page page, DataTable dataTable, string[,] excelHeadInfo, string addHtml, string fileName)
        {
            StringBuilder sbExcel = new StringBuilder();

            //for Excel
            if (fileName.Length == 0)
                fileName = DateTime.Now.ToString("yyyyMMddHHmmss") + ".xls";
            else
                fileName = fileName + ".xls";

            page.Response.AddHeader("content-disposition", "attachment;filename=" + page.Server.UrlPathEncode(fileName));
            page.Response.AddHeader("Charset", "UTF-8");
            page.Response.Cache.SetCacheability(System.Web.HttpCacheability.Public);
            page.Response.ContentType = "application/vnd.xls";
            page.Response.Write("<meta http-equiv='Content-Type' value='application/vnd.ms-excel; charset=UTF-8'>");

            Label lbl = new Label();

            if (addHtml != "") sbExcel.Append(addHtml);
            sbExcel.Append(@"<table x:str border=1 cellpadding='0' cellspacing='0'>
                                        <tr>");

            // 헤더 텍스트 입력
            for (int i = 0; i < excelHeadInfo.GetLength(1); i++)
            {
                sbExcel.Append("<th>");
                sbExcel.Append(excelHeadInfo[0, i].ToString());
                sbExcel.Append("</th>");
            }

            //for (int i = 0; i < dataTable.Columns.Count; i++)
            //{
            //    sbExcel.Append("<th>");
            //    sbExcel.Append(dataTable.Columns[i].ColumnName);
            //    sbExcel.Append("</th>");
            //}
            sbExcel.Append("</tr>");


            // 본문 데이터 추가
            for (int i = 0; i < dataTable.Rows.Count; i++)
            {
                sbExcel.Append("<tr>");
                for (int j = 0; j < excelHeadInfo.GetLength(1); j++)
                {
                    sbExcel.Append("<td>");
                    sbExcel.Append(dataTable.Rows[i][excelHeadInfo[1, j].ToString()].ToString());
                    sbExcel.Append("</td>");
                }
                sbExcel.Append("</tr>");
            }

            //for (int i = 0; i < dataTable.Rows.Count; i++)
            //{
            //    sbExcel.Append("<tr>");
            //    for (int j = 0; j < dataTable.Columns.Count; j++)
            //    {
            //        sbExcel.Append("<td>");
            //        sbExcel.Append(dataTable.Rows[i][j].ToString());
            //        sbExcel.Append("</td>");
            //    }
            //    sbExcel.Append("</tr>");
            //}


            sbExcel.Append("</table>");

            string convStr = sbExcel.ToString();
            convStr = System.Text.RegularExpressions.Regex.Replace(convStr, "&nbsp;", " ");

            lbl.Text = convStr.ToString();

            // Create stringWriter
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();

            // Create HtmlTextWriter
            HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);

            // Call gridview's renderControl
            lbl.RenderControl(htmlWrite);

            // Write Response to browser
            page.Response.Write(stringWrite.ToString());
            page.Response.End();

            return convStr;
        }


        #endregion == DataTable To Excel ==


        #region == GridView To Excel ==


        /// <summary>
        /// GridView를 통해서 엑셀내보내기<para></para>
        /// * 파일명은 이름만지정합니다. 확장자는 붙이지 마십시오.<para></para>
        /// * aspx.cs 페이지에 다음의 이벤트 헨들러를 추가한다.<para></para> 
        ///   public override void VerifyRenderingInServerForm(Control control) { } <para></para>
        /// </summary>
        /// <param name="page"></param>
        /// <param name="grdView">그리드뷰 객체</param>
        /// <param name="filename">저장할 파일명 확장자는 붙이지 마십시오.</param>
        /// <param name="addHtml">추가할 헤더내용이 있으면 이곳에 만들어 넣는다.</param>
        public static void GridViewToExcel(Page page, GridView grdView, string filename, string addHtml)
        {
            if (grdView.Rows.Count != 0)
            {
                // Clear response content & headers
                page.Response.ClearContent();
                page.Response.ClearHeaders();

                // 별도로 입력한 파일명이 없다면 날자로 파일명칭을 만들어준다.
                if (filename.Length == 0)
                    filename = DateTime.Now.ToString("yyyy-MM-dd_HHmmss") + ".xls";
                else
                    filename = filename + ".xls";

                // Add header
                page.Response.AddHeader("content-disposition", "attachment;filename=" + page.Server.UrlPathEncode(filename));
                page.Response.AddHeader("Charset", "UTF-8");

                //Response.Charset = string.Empty;
                page.Response.Cache.SetCacheability(System.Web.HttpCacheability.Public);
                page.Response.ContentType = "application/vnd.xls";

                page.Response.Write("<meta http-equiv='Content-Type' value='application/vnd.ms-excel; charset=UTF-8'>");

                // 해더Html이 있다면 붙여줍니다.
                if (!string.IsNullOrEmpty(addHtml)) page.Response.Write(addHtml);

                // Create stringWriter
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();

                // Create HtmlTextWriter
                HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);

                // Call gridview's renderControl
                grdView.RenderControl(htmlWrite);

                // Write Response to browser
                page.Response.Write(stringWrite.ToString());

                page.Response.End();
            }
        }


        #endregion == GridView To Excel ==


        #region Interop Excel - Download
        /// <summary>
        /// Microsoft Excel Interop 사용 Excel Download - Dasom Jeong 2014-05-21
        /// </summary>
        /// <param name="table">DataTable</param>
        /// <param name="sPath">경로(파일명제외)</param>
        /// <param name="sExcelName">파일명(확장자 제외)</param>
        public static void ExportDataSetToExcel(DataTable table, string sPath, string sTempPath, string sExcelName, string sType)
        {

            /*NetWork Drive 설정*/
            NETRESOURCE ns = new NETRESOURCE();

            ns.dwType = 1;           // 공유 디스크
            ns.lpLocalName = null;   // 로컬 드라이브 지정하지 않음
            //ns.lpRemoteName = ConfigurationManager.AppSettings["File:WordReportSaveLocation"].ToString(); //@"\\" + strTargetPath + @"\VIDEO";
            //ns.lpRemoteName = @"\\192.168.1.48\d$";
            ns.lpRemoteName = @"\\172.17.92.12\";

            ns.lpProvider = null;

            int capacity = 64;
            uint resultFlags = 0;
            uint flags = 0;
            System.Text.StringBuilder sb = new System.Text.StringBuilder(capacity);

            int result = WNetUseConnection(IntPtr.Zero, ref ns, "P@ssw0rd", "WebAdmin", flags, sb, ref capacity, out resultFlags);




            Object filepath = sTempPath + sExcelName + ".xlsx";
            Object missing = System.Reflection.Missing.Value;
            //Creae an Excel application instance
            Excel.Application excelApp = new Excel.Application();

            //Create an Excel workbook instance and open it from the predefined location
            Excel.Workbook excelWorkBook = excelApp.Workbooks.Add(Microsoft.Office.Interop.Excel.XlWBATemplate.xlWBATWorksheet);
            try
            {
                //foreach (DataTable table in dt) //DataTable아닌 DataSet 이면 dt별로 sheet 생성로직
                //{
                //Add a new worksheet to workbook with the Datatable name
                Excel.Worksheet excelWorkSheet = (Excel.Worksheet)excelWorkBook.Sheets.Add();
                excelWorkSheet.Name = sExcelName;

                for (int i = 1; i < table.Columns.Count + 1; i++)
                {
                    excelWorkSheet.Cells[1, i] = table.Columns[i - 1].ColumnName;
                }

                for (int j = 0; j < table.Rows.Count; j++)
                {
                    for (int k = 0; k < table.Columns.Count; k++)
                    {
                        excelWorkSheet.Cells[j + 2, k + 1] = table.Rows[j].ItemArray[k].ToString();


                        //if (k == 14) //하이퍼링크
                        //{
                        //    Microsoft.Office.Interop.Excel.Range excelCell = (Microsoft.Office.Interop.Excel.Range)excelWorkSheet.get_Range(excelWorkSheet.Cells[j + 2, k + 1], excelWorkSheet.Cells[j + 2, k + 1]);
                        //    excelWorkSheet.Hyperlinks.Add(excelCell, table.Rows[j].ItemArray[k].ToString(), Type.Missing, table.Rows[j]["ATTACH_FILENAME"].ToString(), table.Rows[j]["ATTACH_FILENAME"].ToString());
                        //}
                    }
                }
                if (sType == "d")
                {
                    //Detail Excel 일 경우 - Style 추가
                    Excel.Range range = (Excel.Range)excelWorkSheet.get_Range("a1:n1", System.Reflection.Missing.Value);
                    Excel.Style style = excelWorkBook.Styles.Add("newstyle", System.Reflection.Missing.Value);

                    range.Borders.LineStyle = BorderStyle.Solid;

                    style.Interior.Color = System.Drawing.ColorTranslator.FromHtml("#95B3D7");
                    style.Interior.Pattern = Excel.XlPattern.xlPatternSolid;
                    style.Interior.PatternColorIndex = Excel.XlBackground.xlBackgroundAutomatic;
                    range.Style = style;

                    System.Runtime.InteropServices.Marshal.ReleaseComObject(range);
                }

                //필요없는 컬럼 삭제
                //Excel.Range range = (Excel.Range)excelWorkSheet.get_Range("W1", Missing.Value);
                //range.EntireColumn.Delete(Missing.Value);
                //System.Runtime.InteropServices.Marshal.ReleaseComObject(range); 

                //} //foreach end
                //excelWorkBook.SaveAs(filepath, missing, missing, missing, missing, missing, Excel.XlSaveAsAccessMode.xlExclusive, missing, missing, missing, missing, missing);

                if (!System.IO.Directory.Exists(sTempPath))
                    System.IO.Directory.CreateDirectory(sTempPath);
                excelApp.DisplayAlerts = false;
                excelWorkBook.SaveAs(filepath, Excel.XlFileFormat.xlWorkbookDefault,
                     Type.Missing, Type.Missing, true, false,
                     Excel.XlSaveAsAccessMode.xlExclusive, Excel.XlSaveConflictResolution.xlLocalSessionChanges, Type.Missing, Type.Missing);
                excelApp.DisplayAlerts = true;
                excelWorkBook.Close();
            }
            catch (System.Runtime.InteropServices.COMException ex)
            {
                Console.Write("ERROR: " + ex.Message);
            }
            finally
            {
                excelApp.Quit();

                System.Runtime.InteropServices.Marshal.ReleaseComObject(excelApp);
                excelWorkBook = null;

                excelApp = null;

                if (!System.IO.Directory.Exists(sPath))
                    System.IO.Directory.CreateDirectory(sPath);
                // Excel 생성이 완료된 후 File Copy : Copy & Delete
                FileInfo objExcelFile = new FileInfo(sTempPath + sExcelName + ".xlsx");
                if (objExcelFile.Exists)
                {
                    try
                    {
                        // 생성된 파일을 서버로 복사
                        objExcelFile.CopyTo(sPath + sExcelName + ".xlsx", true);
                    }
                    finally
                    {
                        // 복사 완료 후 파일 삭제
                        objExcelFile.Delete();
                    }
                }


            }//End Try
        }
        #endregion
    }
}