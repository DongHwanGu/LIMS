using CBKLMS.Dac;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace CBKLMS.Biz
{
    public class Common_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        #region 공통코드 가져오기
        /// <summary>
        /// 공통코드 가져오기aa
        /// </summary>
        /// <param name="cd_major"></param>
        /// <returns></returns>
        public DataSet GetCMCODE(string cd_major)
        {
            DataSet ds = null;

            using (Common_Dac dac = new Common_Dac())
            {
                ds = dac.GetCMCODE(cd_major);
            }

            return ds;
        }

        /// <summary>
        /// 공통코드 가져오기 레벨 별로
        /// </summary>
        /// <param name="cd_major"></param>
        /// <param name="cd_level"></param>
        /// <returns></returns>
        public DataSet GetCMCODE_Level(string cd_major, string cd_level)
        {
            DataSet ds = null;

            using (Common_Dac dac = new Common_Dac())
            {
                ds = dac.GetCMCODE_Level(cd_major, cd_level);
            }

            return ds;
        }

        /// <summary>
        /// 공통코드 가져오기 FR MINOR
        /// </summary>
        /// <param name="cd_major"></param>
        /// <param name="cd_level"></param>
        /// <returns></returns>
        public DataSet GetCMCODE_Sub(string cd_major, string cd_fr_minor)
        {
            DataSet ds = null;

            using (Common_Dac dac = new Common_Dac())
            {
                ds = dac.GetCMCODE_Sub(cd_major, cd_fr_minor);
            }

            return ds;
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

            using (Common_Dac dac = new Common_Dac())
            {
                ds = dac.GetTestMethodComboList(dicParam);
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

            using (Common_Dac dac = new Common_Dac())
            {
                ds = dac.GetTestUnitComboList(dicParam);
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

            using (Common_Dac dac = new Common_Dac())
            {
                ds = dac.GetSelectMethodChanged(dicParam);
            }

            return ds;
        }

        #region 메일 발송 로그
        /// <summary>
        /// Notice
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekResult SendMailLog(ref IntertekResult result, Dictionary<string, object> dicParam)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                using (Common_Dac dac = new Common_Dac())
                {
                    result = dac.SendMailLog(ref result, dicParam);
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
        #endregion
    }
}
