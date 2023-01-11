using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Script.Serialization;

namespace IntertekBase
{
    public class JSONHelper
    {
        public static object RowsToDictionary(DataTable table)
        {
            var columns = table.Columns.Cast<DataColumn>().ToArray();
            return table.Rows.Cast<DataRow>().Select(r => columns.ToDictionary(c => c.ColumnName, c => r[c]));
        }

        public static Dictionary<string, object> ToDictionary(DataTable table, string JSONName)
        {
            return new Dictionary<string, object>{
                {JSONName,RowsToDictionary(table)}
            };
        }

        /// <summary>
        /// DataTable --> Json
        /// </summary>
        /// <param name="table">결과 DataTable</param>
        /// <param name="JSONName">테이블명</param>
        /// <returns></returns>
        public static string GetJSONString(DataTable table, string JSONName)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = int.MaxValue;
            return serializer.Serialize(ToDictionary(table, JSONName));
        }


        /// <summary>
        /// DataSet --> Json
        /// </summary>
        /// <param name="ds">결과 DataSet</param>
        /// <param name="arrJSONName">DataTable을 구분할 테이블명 배열</param>
        /// <returns></returns>
        public static string GetJSONString(DataSet ds, string[] arrJSONName)
        {
            StringBuilder sbJson = new StringBuilder();
            string strJsonTable = string.Empty;

            #region JSON 열기
            sbJson.Append("{");
            #endregion

            #region Table --> Json 문자열을 할당한다.
            for (int intIndex = 0; intIndex < ds.Tables.Count; intIndex++)
            {
                strJsonTable = string.Empty;
                strJsonTable = GetJSONString(ds.Tables[intIndex], arrJSONName[intIndex]);
                strJsonTable = strJsonTable.Substring(1, strJsonTable.Length - 2);

                // Note - 테이블에 해당하는 Json데이터
                sbJson.Append(strJsonTable);

                // Note - 마지막에는 콤마 구분자를 추가하지 않는다.
                if (intIndex < (ds.Tables.Count - 1))
                    sbJson.Append(",");
            }
            #endregion

            #region JSON 닫기
            sbJson.Append("}");
            #endregion

            return sbJson.ToString();
        }
    }
}
