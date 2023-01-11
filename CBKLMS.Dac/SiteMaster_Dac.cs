using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac
{
    public class SiteMaster_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 프로그램 리스트 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetMainMenuList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_SITE_MASTER_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        #region 페이지명 가져오기
        /// <summary>
        /// 페이지명 가져오기
        /// </summary>
        /// <param name="cd_major"></param>
        /// <returns></returns>
        public DataSet fn_SetProgramLink(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_SITE_MASTER_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
        #endregion

        /// <summary>
        /// 메인페이지 데이터
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetMainPageData(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_SITE_MASTER_R03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
    }
}
