using CBKLMS.Dac.UI_MA;
using IntertekBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace CBKLMS.Biz.UI_MA
{
    public class CustomerContact_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// Customer List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetCustomerContactList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (CustomerContact_Dac dac = new CustomerContact_Dac())
            {
                ds = dac.GetCustomerContactList(dicParam);
            }
            return ds;
        }


        /// <summary>
        /// Customer List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetCustContactDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (CustomerContact_Dac dac = new CustomerContact_Dac())
            {
                ds = dac.GetCustContactDetail(dicParam);
            }
            return ds;
        }


        /// <summary>
        /// Customer List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalCustList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (CustomerContact_Dac dac = new CustomerContact_Dac())
            {
                ds = dac.GetModalCustList(dicParam);
            }
            return ds;
        }

        /// <summary>
        /// Package Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <param name="listDic"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveContactData(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam, List<Dictionary<string, object>> listDic)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                string contact_id = "";
                // 마스터 저장
                using (CustomerContact_Dac dac = new CustomerContact_Dac())
                {
                    result = dac.SaveContactData_master(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;

                    contact_id = result.OV_RTN_MSG;
                }

                // 승인자 저장
                for (int i = 0; i < listDic.Count; i++)
                {
                    using (CustomerContact_Dac dac = new CustomerContact_Dac())
                    {
                        listDic[i]["IV_CONTACT_ID"] = contact_id;

                        result = dac.SaveContactData_cust(ref result, listDic[i]);
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
