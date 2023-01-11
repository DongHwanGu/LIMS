using CBKLMS.Dac.UI_Data;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace CBKLMS.Biz.UI_Data
{
    public class DataConfirm_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 마스터 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetDataConfirmList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (DataConfirm_Dac dac = new DataConfirm_Dac())
            {
                ds = dac.GetDataConfirmList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 마스터 상세 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet SetDataConfirmDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (DataConfirm_Dac dac = new DataConfirm_Dac())
            {
                ds = dac.SetDataConfirmDetail(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 결과검토 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveDataConfirm(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam, List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                // 데이터 저장.
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (DataConfirm_Dac dac = new DataConfirm_Dac())
                    {
                        result = dac.SaveDataConfirm(ref result, listDic[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }
                if (dicParam["IV_BTN_GB"].ToString().Equals("Review"))
                {
                    System.Threading.Thread.Sleep(1000); // 중복방지

                    using (DataConfirm_Dac dac = new DataConfirm_Dac())
                    {
                        result = dac.SaveDataConfirm_Review(ref result, dicParam);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }
                if (dicParam["IV_BTN_GB"].ToString().Equals("Approval"))
                {
                    System.Threading.Thread.Sleep(1000); // 중복방지

                    using (DataConfirm_Dac dac = new DataConfirm_Dac())
                    {
                        result = dac.SaveDataConfirm_Approval(ref result, dicParam);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }
                

                // Note - Commit
                scope.Complete();
                // 트랜젝션을 끊어준다.
                if (scope != null) scope.Dispose();
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
        /// 결과검토 반려
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveDataConfirmReject(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam, List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                // 데이터 저장.
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (DataConfirm_Dac dac = new DataConfirm_Dac())
                    {
                        result = dac.SaveDataConfirmReject(ref result, listDic[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }
                if (dicParam["IV_BTN_GB"].ToString().Equals("Review"))
                {
                    System.Threading.Thread.Sleep(1000); // 중복방지

                    using (DataConfirm_Dac dac = new DataConfirm_Dac())
                    {
                        result = dac.SaveDataConfirmReject_Review(ref result, dicParam);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }
                if (dicParam["IV_BTN_GB"].ToString().Equals("Approval"))
                {
                    System.Threading.Thread.Sleep(1000); // 중복방지

                    using (DataConfirm_Dac dac = new DataConfirm_Dac())
                    {
                        result = dac.SaveDataConfirmReject_Approval(ref result, dicParam);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }
                

                // Note - Commit
                scope.Complete();
                // 트랜젝션을 끊어준다.
                if (scope != null) scope.Dispose();
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
