using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_CM
{
    public class Program_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 프로그램 리스트
        /// </summary>
        /// <returns></returns>
        public DataSet GetProgramList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_PROGRAM_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(null, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 프로그램 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveProgramData(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_CM_PROGRAM_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 상위 프로그램 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet InitControls_UpProgram(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_PROGRAM_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(null, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
    }
}
