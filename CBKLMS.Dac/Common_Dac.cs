using DataAccess;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac
{
    public class Common_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        #region 공통코드
        /// <summary>
        /// 공통 코드 가져오기
        /// </summary>
        /// <param name="cd_major"></param>
        /// <returns></returns>
        public DataSet GetCMCODE(string cd_major)
        {
            DataSet ds = null;
            string sql = "USP_UTIL_GET_CM_CODE";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect_Code(cd_major, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 공통코드 가져오기 레벨 별로
        /// </summary>
        /// <param name="cd_major"></param>
        /// <returns></returns>
        public DataSet GetCMCODE_Level(string cd_major, string cd_level)
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam.Add("IV_CD_MAJOR", cd_major);
            dicParam.Add("IV_CD_LEVEL", cd_level);

            DataSet ds = null;
            string sql = "USP_UTIL_GET_CM_CODE_LEVEL";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 공통코드 가져오기 FR_MINOR
        /// </summary>
        /// <param name="cd_major"></param>
        /// <returns></returns>
        public DataSet GetCMCODE_Sub(string cd_major, string cd_fr_minor)
        {
            Dictionary<string, object> dicParam = new Dictionary<string, object>();
            dicParam.Add("IV_CD_MAJOR", cd_major);
            dicParam.Add("IV_CD_FR_MINOR", cd_fr_minor);

            DataSet ds = null;
            string sql = "USP_UTIL_GET_CM_CODE_FR_MINOR";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
        #endregion

        #region 메일 발송 로그
        /// <summary>
        /// 메일 발송 로그
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekResult SendMailLog(ref IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_UTIL_SEND_MAIL_LOG";

            try
            {
                using (MSsqlAccess db = new MSsqlAccess())
                {
                    result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
                }
            }
            catch (Exception)
            {
            }

            return result;
        }
        #endregion

        /// <summary>
        /// 접수 : Test Method 가져오기
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetTestMethodComboList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_UTIL_GET_TEST_METHOD_COMBOLIST";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
        /// <summary>
        /// 접수 : Test Unit 가져오기
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetTestUnitComboList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_UTIL_GET_TEST_UNIT_COMBOLIST";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
        /// <summary>
        /// Method Changed
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetSelectMethodChanged(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_UTIL_GET_TEST_METHOD_INFO";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
    }
}
