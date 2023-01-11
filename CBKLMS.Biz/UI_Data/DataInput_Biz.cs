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
    public class DataInput_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 마스터 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetDataInputList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (DataInput_Dac dac = new DataInput_Dac())
            {
                ds = dac.GetDataInputList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 마스터 상세 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet SetDataInputDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (DataInput_Dac dac = new DataInput_Dac())
            {
                ds = dac.SetDataInputDetail(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 결과입력 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveDataInput(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam, List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                // 승인자 저장
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (DataInput_Dac dac = new DataInput_Dac())
                    {
                        result = dac.SaveDataInput(ref result, listDic[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                if (dicParam["IV_BTN_GB"].ToString().Equals("StatusSave"))
                {
                    System.Threading.Thread.Sleep(1000); // 중복방지

                    using (DataInput_Dac dac = new DataInput_Dac())
                    {
                        result = dac.SaveDataInput_Status(ref result, dicParam);
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
        /// 결과 입력 반려
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveDataInputReject(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam, List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                // 승인자 저장
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (DataInput_Dac dac = new DataInput_Dac())
                    {
                        result = dac.SaveDataInputReject(ref result, listDic[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                System.Threading.Thread.Sleep(1000); // 중복방지

                using (DataInput_Dac dac = new DataInput_Dac())
                {
                    result = dac.SaveDataInputReject_Status(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;
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
        /// 시험별 파일업로드.
        /// </summary>
        /// <param name="result"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekResult SaveDataInput_Test_File(ref IntertekResult result, List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (DataInput_Dac dac = new DataInput_Dac())
                    {
                        result = dac.SaveDataInput_Test_File(ref result, listDic[i]);
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
