using CBKLMS.Dac.UI_WorkSheet;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace CBKLMS.Biz.UI_WorkSheet
{
    public class WorkSheet_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// 마스터 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetWorkSheetList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (WorkSheet_Dac dac = new WorkSheet_Dac())
            {
                ds = dac.GetWorkSheetList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 마스터 상세 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet SetWorkSheetDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (WorkSheet_Dac dac = new WorkSheet_Dac())
            {
                ds = dac.SetWorkSheetDetail(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 시험원 리스트 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetContactList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (WorkSheet_Dac dac = new WorkSheet_Dac())
            {
                ds = dac.GetContactList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// 담당자 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveWorkSheet(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam, List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                // 승인자 저장
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (WorkSheet_Dac dac = new WorkSheet_Dac())
                    {
                        result = dac.SaveWorkSheet(ref result, listDic[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                if (dicParam["IV_BTN_GB"].ToString().Equals("StatusSave"))
                {
                    using (WorkSheet_Dac dac = new WorkSheet_Dac())
                    {
                        result = dac.SaveWorkSheet_Status(ref result, dicParam);
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
