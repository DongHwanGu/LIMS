using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_MA
{
    public class Package_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// Package List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetPackageList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_PACKAGE_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// Test Modal List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalTestList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_PACKAGE_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// Package Master Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SavePackageDetail_master(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_PACKAGE_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// Package Test Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SavePackageDetail_Test(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_PACKAGE_U02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }


        /// <summary>
        /// Test Dtl List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetPackageDataDtl_Test(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_PACKAGE_R03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }
    }
}
