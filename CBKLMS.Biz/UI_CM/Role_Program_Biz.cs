using CBKLMS.Dac.UI_CM;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace CBKLMS.Biz.UI_CM
{
    public class Role_Program_Biz : IDisposable
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
            using (Role_Program_Dac dac = new Role_Program_Dac())
            {
                ds = dac.GerRoleList(dicParam);
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
            using (Role_Program_Dac dac = new Role_Program_Dac())
            {
                ds = dac.GetRoleProgramList(dicParam);
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
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                using (Role_Program_Dac dac = new Role_Program_Dac())
                {
                    result = dac.SaveRoleData(ref result, dicParam);
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
        /// Modal Program 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalProgramList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Role_Program_Dac dac = new Role_Program_Dac())
            {
                ds = dac.GetModalProgramList(dicParam);
            }
            return ds;
        }


        /// <summary>
        /// 권한에 따른 프로그램 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekResult SaveModalProgramList(ref IntertekResult result, List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (Role_Program_Dac dac = new Role_Program_Dac())
                    {
                        result = dac.SaveModalProgramList(ref result, listDic[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
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
        /// 권한에 따른 프로그램 삭제
        /// </summary>
        /// <param name="result"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekResult DeleteModalProgramList(ref IntertekResult result, List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (Role_Program_Dac dac = new Role_Program_Dac())
                    {
                        result = dac.DeleteModalProgramList(ref result, listDic[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
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
