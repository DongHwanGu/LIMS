using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_MA
{
    public class Customer_Dac : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// Customer List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetCustList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_CUSTOMER_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// Customer List Sub
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetCustDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_CUSTOMER_R04";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// Customer master Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveCustData_master(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_CUSTOMER_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }


        /// <summary>
        /// Modal package List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalPackageList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_CUSTOMER_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// Modal Test List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalTestList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_CUSTOMER_R03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// Modal Test List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalContactList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_MA_CUSTOMER_R05";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// Customer Package Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dictionary"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveModalPackageList_DB(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_CUSTOMER_U02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// Customer Test Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dictionary"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveModalTestList_DB(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_CUSTOMER_U03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// Contact Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dictionary"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveModalContactData_DB(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_CUSTOMER_U04";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// Contact Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dictionary"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveCustData_team(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_MA_CUSTOMER_U05";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        
    }
}
