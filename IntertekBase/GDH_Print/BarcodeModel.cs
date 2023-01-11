using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IntertekBase.GDH_Print
{
    public class BarcodeModel
    {
         /// <summary>
        /// 렉넘버
        /// </summary>
        public string RackNumber { get; set; }
        /// <summary>
        /// 거점
        /// </summary>
        public string Base_Vender { get; set; }
        /// <summary>
        /// 바코드 번호 *빼고
        /// </summary>
        public string BarCodeNumber { get; set; }
        /// <summary>
        /// 국적
        /// </summary>
        public string Cust_Contry { get; set; }
        /// <summary>
        /// 이름
        /// </summary>
        public string CustENM { get; set; }
        /// <summary>
        /// 지니아이디
        /// </summary>
        public string GZID { get; set; }
        /// <summary>
        /// 입고일자
        /// </summary>
        public string EnterDT { get; set; }
        /// <summary>
        /// 바코드 *포함
        /// </summary>
        public string BarCode { get; set; }

        /// <summary>
        /// 상품이름
        /// </summary>
        public string ItemNM { get; set; }

        /// <summary>
        /// 상품색상
        /// </summary>
        public string ItemOption1 { get; set; }

        /// <summary>
        /// 사이즈
        /// </summary>
        public string ItemOption2 { get; set; }

        /// <summary>
        /// 메모
        /// </summary>
        public string Memo { get; set; }

        /// <summary>
        /// 메모에입력할 Order ID
        /// </summary>
        public string Order_ID { get; set; }

        /// <summary>
        /// 작업자 메모
        /// </summary>
        public string WorkerMemo { get; set; }

        /// <summary>
        /// 계측 건수
        /// </summary>
        public int Count { get; set; }


        string _cancel_cd;
        /// <summary>
        /// 오류입고사유
        /// </summary>
        public string Cancle_CD
        {
            get { return _cancel_cd; }
            set
            {
                if (value == "기타")
                {
                    _cancel_cd = "ETC";
                }
                else
                {
                    _cancel_cd = value;

                }
                if (!string.IsNullOrEmpty(_cancel_cd))
                {
                    _cancel_cd = "E/I " + _cancel_cd;
                }
            }
        }


        /// <summary>
        /// 오류입고매모
        /// </summary>
        public string Cancel_cd_Memo { get; set; }

        /// <summary>
        /// 무적번호
        /// </summary>
        public string Deposit_id { get; set; }

        /// <summary>
        /// 무적 상품명
        /// </summary>
        public string Assort_nm { get; set; }
    }
}
