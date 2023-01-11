using DataAccess;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_CM
{
    public class Role_Program_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 권한 리스트
        /// </summary>
        /// <returns></returns>
        public DataSet GerRoleList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_ROLE_PROGRAM_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(null, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 권한 리스트
        /// </summary>
        /// <returns></returns>
        public DataSet GetRoleProgramList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_ROLE_PROGRAM_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 권한 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekResult SaveRoleData(ref IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_CM_ROLE_PROGRAM_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// Modal Program 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalProgramList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_CM_ROLE_PROGRAM_R03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 권한에 따른 프로그램 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dictionary"></param>
        /// <returns></returns>
        public IntertekResult SaveModalProgramList(ref IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_CM_ROLE_PROGRAM_U02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 권한에 따른 프로그램 삭제
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dictionary"></param>
        /// <returns></returns>
        public IntertekResult DeleteModalProgramList(ref IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_CM_ROLE_PROGRAM_U03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }
    }
}
