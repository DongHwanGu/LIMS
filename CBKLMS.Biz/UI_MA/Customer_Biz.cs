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
    public class Customer_Biz : IDisposable
    {
        public void Dispose()
        {
        }

        /// <summary>
        /// Customer List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetCustList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Customer_Dac dac = new Customer_Dac())
            {
                ds = dac.GetCustList(dicParam);
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
            using (Customer_Dac dac = new Customer_Dac())
            {
                ds = dac.GetCustDetail(dicParam);
            }
            return ds;
        }


        /// <summary>
        /// Customer Save
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveCustData(ref IntertekBase.IntertekResult result
                                                      , Dictionary<string, object> dicParam
                                                      , List<Dictionary<string, object>> listTeam
                                                      , List<Dictionary<string, object>> listPackage
                                                      , List<Dictionary<string, object>> listTest
                                                      , List<Dictionary<string, object>> listContact)
        {
            // Note - Tansaction 개체를 생성한다. 
            TransactionScope scope = SQLTransaction.GetTransaction();

            try
            {
                string cust_id = "";
                // 마스터 저장
                using (Customer_Dac dac = new Customer_Dac())
                {
                    result = dac.SaveCustData_master(ref result, dicParam);
                    // 하나의 트렌젝션으로 묶기 위함
                    if (result.OV_RTN_CODE.Equals(-1)) return result;

                    cust_id = result.OV_RTN_MSG;
                }

                // Team
                for (int i = 0; i < listTeam.Count; i++)
                {
                    using (Customer_Dac dac = new Customer_Dac())
                    {
                        listTeam[i]["IV_CUST_ID"] = cust_id;

                        result = dac.SaveCustData_team(ref result, listTeam[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }


                // Package
                for (int i = 0; i < listPackage.Count; i++)
                {
                    using (Customer_Dac dac = new Customer_Dac())
                    {
                        listPackage[i]["IV_CUST_ID"] = cust_id;

                        result = dac.SaveModalPackageList_DB(ref result, listPackage[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // Test
                for (int i = 0; i < listTest.Count; i++)
                {
                    using (Customer_Dac dac = new Customer_Dac())
                    {
                        listTest[i]["IV_CUST_ID"] = cust_id;

                        result = dac.SaveModalTestList_DB(ref result, listTest[i]);
                        // 하나의 트렌젝션으로 묶기 위함
                        if (result.OV_RTN_CODE.Equals(-1)) return result;
                    }
                }

                // Contact
                for (int i = 0; i < listContact.Count; i++)
                {
                    using (Customer_Dac dac = new Customer_Dac())
                    {
                        listContact[i]["IV_CUST_ID"] = cust_id;

                        result = dac.SaveModalContactData_DB(ref result, listContact[i]);
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
        /// Modal Package List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalPackageList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Customer_Dac dac = new Customer_Dac())
            {
                ds = dac.GetModalPackageList(dicParam);
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
            using (Customer_Dac dac = new Customer_Dac())
            {
                ds = dac.GetModalTestList(dicParam);
            }
            return ds;
        }


        /// <summary>
        /// Modal Contact List
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public DataSet GetModalContactList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            using (Customer_Dac dac = new Customer_Dac())
            {
                ds = dac.GetModalContactList(dicParam);
            }
            return ds;
        }

        
    }
}
