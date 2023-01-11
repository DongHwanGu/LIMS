using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_Report
{
    public class ReportClose_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 마스터 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetReportCloseList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REPORTCLOSE_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 마스터 상세 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet SetReportCloseDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REPORTCLOSE_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
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
            string sql = "USP_REPORTCLOSE_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 마스터 상세 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet SaveReportCreate_ReportData(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REPORTCLOSE_REPORT_01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 성적서 발행
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveReportCreate(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REPORTCLOSE_U02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 성적서 발행 Sample
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveReportCreate_Sample(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REPORTCLOSE_U03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 리포트 파일 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetReportFileList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REPORTCLOSE_R03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 발행목록 사용유무
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult fn_btn_use_click(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REPORTCLOSE_U04";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 성적서 메일 양식 가져오기.
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet Init_Mail_ReportClose(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REPORTCLOSE_R04";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// 성적서 메일 발송 상태 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SendMail_Mail_ReportClose(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REPORTCLOSE_U05";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
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
            string sql = "USP_REPORTCLOSE_U06";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

    }
}
