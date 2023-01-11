using DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CBKLMS.Dac.UI_Register
{
    public class Register_IN_Dac : IDisposable
    {
        public void Dispose()
        {
        }
        
        /// <summary>
        /// 마스터 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetRegisterList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 마스터 상세 조회
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetRegisterDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// 모달 : 업체리스트
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetModalCustomerList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 모달 : 담당자 리스트
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetModalContactList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R04";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 모달 : 패키지 테스트 리스트
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetModalPackageTestList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R05";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 모달 : 패키지 및 테스트 저장시 디테일 가져오기.
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet SaveModalPackageTestList_GetDetail(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R06";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 모달 : 패키지 및 테스트 저장시 디테일 가져오기.
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetModalUserList(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R07";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 시험방법 금액가져오기
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet SetTestPackageGrid_MethodAmt(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R08";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// 환율가져오기
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet GetCurrency_Amt(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R09";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 샘플 바코드 가져오기
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet SetRegister_IN_Sample_Barcode(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R10";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }


        /// <summary>
        /// 마스터 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveStepOne_master(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U01";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 고객 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveStepOne_customer(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U02";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 담당자 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveStepOne_contact(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U03";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 마스터 파일 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveStepOne_file(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U04";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        // <summary>
        /// Two 삭제 후 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveStepTwo_Delete(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U05";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 샘플 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveStepTwo_Sample(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U06";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 샘플 파일 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveStepTwo_file(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U07";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 시험 항목 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveStepTwo_Test(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U08";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 시료별 시험항목 저장
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveStepTwo_SampleTest(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U09";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }


        /// <summary>
        /// 접수완료 진행
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveRegisterFinish_Set(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U10";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 접수 완료 후 메일 전송
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet SaveRegisterFinish_Get(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R10";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }

        /// <summary>
        /// 접수완료 진행
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveSampleFileList_master(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U11";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }

        /// <summary>
        /// 접수완료 진행
        /// </summary>
        /// <param name="result"></param>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public IntertekBase.IntertekResult SaveSampleFileList_file(ref IntertekBase.IntertekResult result, Dictionary<string, object> dicParam)
        {
            string sql = "USP_REGISTER_IN_U07";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                result = db.DB_ExcuteQuery(dicParam, sql, CommandType.StoredProcedure);
            }

            return result;
        }


        /// <summary>
        /// 접수메일 가져오기
        /// </summary>
        /// <param name="dicParam"></param>
        /// <returns></returns>
        public System.Data.DataSet Init_Mail_Register_IN(Dictionary<string, object> dicParam)
        {
            DataSet ds = null;
            string sql = "USP_REGISTER_IN_R11";

            using (MSsqlAccess db = new MSsqlAccess())
            {
                ds = db.DB_ExcuteSelect(dicParam, sql, CommandType.StoredProcedure);
            }
            return ds;
        }



    }
}
