using System;
using System.Data;
using System.Text;
using System.Data.OleDb;

namespace IntertekBase
{
	/// <summary>
    /// StringManager�� ���� ��� �����Դϴ�.
	/// </summary>
	public class StringManager
	{
        /// <summary>
        /// 
        /// </summary>
        public StringManager(){ }

        #region == string, char, byte ��ȣ ��ȯ ==

        /// <summary>
        /// ���ڿ��� ������ �����ڷ� �߶� ���ڹ迭�� ��ȯ�Ѵ�.
        /// </summary>
        /// <param name="data"></param>
        /// <param name="delimiters"></param>
        /// <returns></returns>
		public static string[] Split(string data, string delimiters)
		{
			System.Collections.ArrayList oAL = new System.Collections.ArrayList();
			int iStartIdx = 0;
			int iEndIdx = 0;
			while (true)
			{
				iEndIdx = data.IndexOf(delimiters, iStartIdx);
				if (iEndIdx == -1)
				{
					oAL.Add(data.Substring(iStartIdx, data.Length - iStartIdx));
					break;
				}
				else
					oAL.Add(data.Substring(iStartIdx, iEndIdx - iStartIdx));
				iStartIdx = iEndIdx + delimiters.Length;
			} 

			return (string[])oAL.ToArray(System.Type.GetType("System.String"));
		}

        /// <summary>
        /// ������ ���̳ʸ� �������� �о� �鿩�� byte�� ��ȯ�Ѵ�.
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
		public static byte[] ReadBinaryFile(string filePath)
		{
			int buffersize = 1024;
			
			System.IO.FileStream stream = new System.IO.FileStream(filePath, System.IO.FileMode.Open, System.IO.FileAccess.Read);
			System.IO.BinaryReader reader = new System.IO.BinaryReader(stream);

			long length = stream.Length;
			
			if (length == 0) return null;
			if (length > int.MaxValue) 
				throw new System.Exception(int.MaxValue.ToString() + " Byte �̻��� ������ �� ����� ������ ����ϴ�.|^|");
			
			int step = Convert.ToInt32(length / buffersize);
			int mod = Convert.ToInt32(length % buffersize);
			long offset = 0;
			byte[] binary = new byte[length];
			int i = 0;
			byte[] buffer = new byte[buffersize];
			while(i++ < step)
			{	
				reader.Read(buffer, 0, buffersize);
				buffer.CopyTo(binary, offset);
				offset += buffersize;
			}
			buffer = null;
			buffer = new byte[mod];
			reader.Read(buffer, 0, mod);
			buffer.CopyTo(binary, offset);

			reader.Close();
			stream.Close();
		
			return binary;
		}

        /// <summary>
        /// �̹��� ��ü�� Byte��ü�� �о� �鿩 byte�� ��ȯ�Ѵ�.
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
		public static byte[] ReadImageFile(string filePath)
		{

			long imgLength = 0;
			int iBytesRead = 0;
			byte[] imgArr = null;
			System.IO.FileStream fs = null;
			System.IO.FileInfo fiImage = null;
			try
			{
				fiImage = new System.IO.FileInfo(filePath);
				imgLength = fiImage.Length;
				fs = new System.IO.FileStream(filePath, System.IO.FileMode.Open , System.IO.FileAccess.Read, System.IO.FileShare.Read);
				imgArr = new byte[Convert.ToInt32(imgLength)];
				iBytesRead = fs.Read(imgArr, 0 , Convert.ToInt32(imgLength));
			}
			finally
			{
				fs.Close();
			}
			return imgArr;
		}

        /// <summary>
        /// ���̳ʸ�(Byte)�����͸� �о�鿩 ĳ����(char)�迭�� ��ȯ�Ѵ�.
        /// </summary>
        /// <param name="binaryData"></param>
        /// <returns></returns>
		public static char[] ByteArrayToCharArray(byte[] binaryData)
		{
			// Convert the binary input into Base64 UUEncoded output.
			// Each 3 byte sequence in the source data becomes a 4 byte
			// sequence in the character array. 
			long arrayLength = (long) ((4.0d/3.0d) * binaryData.Length);
			// If array length is not divisible by 4, go up to the next
			// multiple of 4.
			if (arrayLength % 4 != 0) 
			{
				arrayLength += 4 - arrayLength % 4;
			}
			char[] base64CharArray = new char[arrayLength];
			try 
			{
				System.Convert.ToBase64CharArray(binaryData, 
					0,
					binaryData.Length,
					base64CharArray,
					0);
			}
			catch (System.ArgumentNullException) 
			{
				throw new ArgumentNullException("Binary data array is null.");
			}
			catch (System.ArgumentOutOfRangeException) 
			{
				throw new ArgumentNullException("Char Array is not large enough.");
			}
			return base64CharArray;
		}

        /// <summary>
        /// Base64���ڹ迭�� �о�鿩 byte�� ��ȯ�Ѵ�.
        /// </summary>
        /// <param name="base64CharArray"></param>
        /// <returns></returns>
		public static byte[] CharArrayToByteArray(char[] base64CharArray)
		{
			byte[] binaryData;
			try 
			{
				binaryData = 
					System.Convert.FromBase64CharArray(base64CharArray,
					0,
					base64CharArray.Length);
			}
			catch (System.ArgumentNullException) 
			{
				throw new ArgumentNullException("Base 64 character array is null.");
			}
			catch (System.FormatException) 
			{
				throw new FormatException("Base 64 Char Array length is not 4 or is not an even multiple of 4.");
			}

			return binaryData;
		}

        /// <summary>
        /// �Ϲݹ��ڿ��� Hash Byte[]�� ��ȯ�Ѵ�.
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
		public static byte[] Str2Hash(string data)
		{
			System.Text.UTF8Encoding oEncoding = new System.Text.UTF8Encoding();
			byte[] ba = oEncoding.GetBytes(data);
 
			System.Security.Cryptography.SHA1 sha = new System.Security.Cryptography.SHA1CryptoServiceProvider(); 
			byte[] baHash = sha.ComputeHash(ba);
			sha.Clear();

			return baHash;
		}

        /// <summary>
        /// �Ϲݹ��ڿ��� ��ȣȭ ���ڿ��� ����� �� �ִ� 16Byte�� ��ȯ�Ͽ� ��ȯ�Ѵ�.
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
		public static byte[] Str2Key(string data)
		{
			System.Text.UTF8Encoding oEncoding = new System.Text.UTF8Encoding();
			byte[] ba = oEncoding.GetBytes(data);
 
			System.Security.Cryptography.SHA1 sha = new System.Security.Cryptography.SHA1CryptoServiceProvider(); 
			byte[] baHash = sha.ComputeHash(ba);
			sha.Clear();

			byte[] baReturn = new byte[16];
			for (int i=0; i<16; i++) baReturn[i] = baHash[i + 2];

			return baReturn;
        }

        #endregion == string char, byte ��ȣ��ȯ

        #region == Excel �Ǵ� Text���� -> DataSet���� ==

        /// <summary>
        /// �������̷� ������ �ؽ�Ʈ������ �о�鿩 DataSet���� ��ȯ�Ͽ� �ݴϴ�.<para></para>
        /// ù°���� DataSet Table�� �÷������� ������ �� �ִ�.<para></para>
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="columnLengths"></param>
        /// <param name="headerVisible"></param>
        /// <returns></returns>
        public static DataSet TextFile2DataSet(string filePath, int[] columnLengths, bool headerVisible)
		{				
								
			System.IO.StreamReader sr = null;
			DataSet ds = new DataSet();
			DataTable dt = new DataTable();
			DataColumn col = null;
			DataRow oRow = null;

			
			try
			{
							
				sr = new System.IO.StreamReader( System.IO.File.OpenRead(filePath),System.Text.Encoding.GetEncoding(949));

				string line = string.Empty;
				Encoding en = Encoding.GetEncoding(949);
			
				int itotlen = 0;
				for(int i=0;i<columnLengths.Length;i++)
				{
					col = new DataColumn();
					dt.Columns.Add(col);
					itotlen += columnLengths[i];
				}

				byte[] ByteArray = null;
				int itag=0;
				int irowcount =1;
				string strMessage = string.Empty;
				while((line = sr.ReadLine()) != null)
				{
					ByteArray = new Byte[itotlen];
					
					//					if(ByteArray.Length < en.GetBytes()
					//					{
					//					}
					
					if(ByteArray.Length > en.GetByteCount(line))
					{
						strMessage = string.Format(
							"�����͸� �ؽ�Ʈ�� ��ȯ���� ���߽��ϴ�. \r\n{0} ��° �����Ϳ��� ���̰� �־��� ��ü ���̺��� �۽��ϴ�.|^|"
							,irowcount.ToString());
						throw new System.Exception(strMessage);
	
					}
					else if(ByteArray.Length < en.GetByteCount(line))
					{
						strMessage = string.Format(
							"�����͸� �ؽ�Ʈ�� ��ȯ���� ���߽��ϴ�. \r\n{0} ��° �����Ϳ��� ���̰� �־��� ��ü ���̺��� Ů�ϴ�. |^|"
							,irowcount.ToString());
						throw new System.Exception(strMessage);

					}

					en.GetBytes(line,0,line.Length, ByteArray,0);
					
					// ���� �߰�
					oRow = dt.NewRow();
					for(int j=0;j<columnLengths.Length;j++)
					{	
						if((ByteArray.Length - itag)<columnLengths[j])
						{
							strMessage = string.Format(
								"�����͸� �ؽ�Ʈ�� ��ȯ���� ���߽��ϴ�. \r\n{0} ��° �����Ϳ��� {1} ��° Data�� ������ �÷��� �ʺ񺸴� �۽��ϴ�. |^|"
								,irowcount.ToString() , j.ToString() );
							throw new System.Exception(strMessage);
						}
						else
						{
							oRow[j] = en.GetString(ByteArray,itag,columnLengths[j]).TrimEnd('\0').Trim();
							//								if((line.Length - itag)<columnLengths[j])
							//									oRow[j] = line.Substring(itag,line.Length - itag);
							//								else
							//									oRow[j] = line.Substring(itag, columnLengths[j]);
							itag += columnLengths[j];
						}
					}	

					dt.Rows.Add(oRow);
					itag = 0;
					irowcount++;
				}
				// ������� ���ο� ���� 
				if(headerVisible)
				{
					string te = string.Empty;
					
					for(int i=0;i<dt.Columns.Count;i++)
					{
						te = dt.Rows[0][i].ToString();
						// ����� ���� �Ǿ��µ� �Ȱ��� �̸��� ����� ��� �̸� ó��
						if(dt.Columns.Contains(te))
						{
							te = te + i;
						}
						dt.Columns[i].ColumnName = te;
					}
					dt.Rows[0].Delete();
				}
				ds.Tables.Add(dt);
			}
			finally
			{
				if(sr != null) sr.Close();
			}
			return ds;
		}

        /// <summary>
        /// �����ڸ� ����� �ؽ�Ʈ������ �о�鿩 DataSet���� ��ȯ�Ͽ� �ش�.<para></para>
        /// ù°���� DataSet Table�� �÷������� ������ �� �ִ�.<para></para>
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="delimiter"></param>
        /// <param name="headerVisible"></param>
        /// <returns></returns>
        public  static DataSet TextFile2DataSet(string filePath, string delimiter, bool headerVisible)
		{			
			System.IO.StreamReader sr = null;
			DataSet ds = new DataSet();
			DataTable dt = new DataTable();
			DataColumn col = null;
			DataRow oRow = null;
			try
			{
				sr = new System.IO.StreamReader( System.IO.File.OpenRead(filePath), Encoding.GetEncoding(949));
				string line = string.Empty;
				string[] strArrCols = null;
				bool flag = false;
				while((line = sr.ReadLine()) != null)
				{
					strArrCols = StringManager.Split(line, delimiter);

					oRow = dt.NewRow();

					for(int i=0 ; i< strArrCols.Length; i++)
					{
						if(!flag)
						{
							col = new DataColumn();
							dt.Columns.Add(col);
						}
						
						oRow[i] = strArrCols[i];

					}

					if(strArrCols.Length != (dt.Columns.Count))
						throw new System.Exception("�������� ������ ���� ���̰� �������� �ʽ��ϴ�. |^|");

					dt.Rows.Add(oRow);
					flag = true;
				}
				
				// ��� ���� ���ο� ����
				if(headerVisible)
				{
					string te = string.Empty;
					for(int i=0;i<dt.Columns.Count;i++)
					{
						te = dt.Rows[0][i].ToString();
						// ����� ���� �Ǿ��µ� �Ȱ��� �̸��� ����� ��� �̸� ó��
						if(dt.Columns.Contains(te))
						{
							te = te + i;
						}
						dt.Columns[i].ColumnName = te;
					}
					dt.Rows[0].Delete();
				}
				ds.Tables.Add(dt);	
			}
			finally
			{
				if(sr != null) sr.Close();
			}
			return ds;
		}

        /// <summary>
        /// ���������� �о�鿩 ����Ÿ������ ��ȯ�Ѵ�.
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="headerVisible"></param>
        /// <returns></returns>
		public static DataSet Excel2DataSet(string filePath, bool headerVisible)
		{
			string strExcelConnectionString = 
				String.Format( "Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=Excel 8.0;", filePath );
			
			OleDbConnection connExcel = new System.Data.OleDb.OleDbConnection( strExcelConnectionString );
			
			System.Data.DataTable dt = null;
			DataSet dsExcel = new DataSet();

			try
			{
				connExcel.Open();
				dt = connExcel.GetOleDbSchemaTable(System.Data.OleDb.OleDbSchemaGuid.Tables, new object[] {null, null, null, "Table"});

				string sheetName = dt.Rows[0]["Table_Name"].ToString(); 
				string strQry= "select * from [" + sheetName + "]";
				
				OleDbDataAdapter daExcel = new OleDbDataAdapter( strQry, connExcel );
				
				daExcel.Fill( dsExcel );

				// 
				if(headerVisible && dsExcel.Tables[0].Columns[0].ColumnName == "Column1")
				{
					string te = string.Empty;
					for(int i=0;i<dsExcel.Tables[0].Columns.Count;i++)
					{
						te = dsExcel.Tables[0].Rows[0][i].ToString();
						if(dt.Columns.Contains(te))
						{
							te = te + i;
						}
						dsExcel.Tables[0].Columns[i].ColumnName = te;
					}
					dsExcel.Tables[0].Rows[0].Delete();
				}
			}
			finally
			{
				if( connExcel.State != ConnectionState.Closed) connExcel.Close();
				if( dt != null) dt.Dispose();
			}

			return dsExcel;
		}

        /// <summary>
        /// ������ DATASET���� ��ȯ�� DELETE �ϴ� �޼ҵ� 
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="headerVisible"></param>
        /// <returns></returns>
		public static DataSet ExcelDelete2DataSet(string filePath, bool headerVisible)
		{
			DataSet ds = StringManager.Excel2DataSet(filePath, headerVisible);
			System.IO.File.Delete(filePath);
			return ds;

        }

        #endregion == Excel �Ǵ� Text���� -> DataSet���� ==

        #region == DataTable2TextFile DataTable �� ������ �ؽ�Ʈ ���Ϸ� ��ȯ�ϴ� �Լ� (4�� �����ε�) ==

        /// <summary>
		/// DataTable �� ������ �ؽ�Ʈ ���Ϸ� ��ȯ�Ͽ� ������� ���ÿ� �����ϴ� �Լ�
		/// </summary>
		/// <param name="filePath">������ ���(����ڰ� SaveDialog ���� Ȱ���Ͽ� ������ �� �ֵ��� �Ѵ�.)</param>
		/// <param name="fileName">������ ���ϸ�(UI �����ڰ� ������ ���ǵ� ���ϸ����� �����Ѵ�.)</param>
		/// <param name="dt">�ؽ�Ʈ ���Ͽ� ������ ���������� (UI �����ڰ� ���Ŀ� �°� �����Ͽ� �ѱ⵵�� �Ѵ�.)</param>
		/// <param name="columnLengths">�� ���� �������� �����迭�� �����Ͽ� �ѱ⵵�� �Ѵ�.</param>
		/// <param name="headerVisible">�ؽ�Ʈ ���Ͽ� �÷����� �������� ���θ� �����Ѵ�. true�̸� �÷����� �ؽ�Ʈ ���Ͽ������Ѵ�.</param>
		public static void DataTable2TextFile(string filePath, DataTable dt, ColumnLengthDelimiter[] colLenDelimiter, bool headerVisible)
		{
			System.Text.StringBuilder sbResult = null;
			System.IO.StreamWriter writer = null;
			try
			{
				sbResult = new System.Text.StringBuilder();
				if ( DataTable2String(dt, colLenDelimiter, headerVisible, sbResult) )
				{
					writer = new System.IO.StreamWriter(System.IO.File.Create(filePath), Encoding.GetEncoding(949));
					writer.Write(sbResult.ToString());
					writer.Close();
				}
			}
			catch(System.Exception ex)
			{
				throw ex;
			}
			finally
			{
				if(sbResult != null) sbResult = null;
				if(writer != null )
				{
					writer.Close();
					writer = null;
				}
			}
			
		}

		/// <summary>
		/// DataTable �� ������ �ؽ�Ʈ ���Ϸ� ��ȯ�Ͽ� ������� ���ÿ� �����ϴ� �Լ�
		/// </summary>
		/// <param name="filePath">������ ���(����ڰ� SaveDialog ���� Ȱ���Ͽ� ������ �� �ֵ��� �Ѵ�.)</param>
		/// <param name="fileName">������ ���ϸ�(UI �����ڰ� ������ ���ǵ� ���ϸ����� �����Ѵ�.)</param>
		/// <param name="dt">�ؽ�Ʈ ���Ͽ� ������ ���������� (UI �����ڰ� ���Ŀ� �°� �����Ͽ� �ѱ⵵�� �Ѵ�.)</param>
		/// <param name="delimiter">�÷� �����ڸ� �����Ѵ�. �÷������ڴ� "\t", ";", "," </param>
		/// <param name="headerVisible">�ؽ�Ʈ ���Ͽ� �÷����� �������� ���θ� �����Ѵ�. true�̸� �÷����� �ؽ�Ʈ ���Ͽ������Ѵ�.</param>
		public static void DataTable2TextFile(string filePath, System.Data.DataTable dt, string delimiter, bool headerVisible)
		{
			System.Text.StringBuilder sbResult = null;
			System.IO.StreamWriter writer = null;
			try
			{
				sbResult = new System.Text.StringBuilder();
				if ( DataTable2String(dt, delimiter, headerVisible, sbResult) )
				{
					writer = new System.IO.StreamWriter(System.IO.File.Create(filePath),Encoding.GetEncoding(949));
					writer.Write(sbResult.ToString());
					writer.Close();
				}
			}
			catch(System.Exception ex)
			{
				throw ex;
			}
			finally
			{
				if(sbResult != null) sbResult = null;
				if(writer != null )
				{
					writer.Close();
					writer = null;
				}
			}
		}


		/// <summary>
		/// DataTable �� ������ �ؽ�Ʈ �������� ��ȯ�Ͽ� byte[]�� ��ȯ�ϴ� �Լ�
		/// </summary>
		/// <param name="dt">�ؽ�Ʈ ���Ͽ� ������ ���������� (UI �����ڰ� ���Ŀ� �°� �����Ͽ� �ѱ⵵�� �Ѵ�.)</param>
		/// <param name="columnLengths">�� ���� �������� �����迭�� �����Ͽ� �ѱ⵵�� �Ѵ�.</param>
		/// <param name="headerVisible">�ؽ�Ʈ ���Ͽ� �÷����� �������� ���θ� �����Ѵ�. true�̸� �÷����� �ؽ�Ʈ ���Ͽ������Ѵ�.</param>
		/// <returns>byte[]</returns>
		public static byte[] DataTable2Binary(System.Data.DataTable dt, ColumnLengthDelimiter[] colLenDelimiter, bool headerVisible)
		{
			System.Text.StringBuilder sbResult = new System.Text.StringBuilder();
			System.IO.MemoryStream stream = new System.IO.MemoryStream();
			System.IO.StreamWriter writer = null;
			if ( DataTable2String(dt, colLenDelimiter, headerVisible, sbResult) )
			{
				writer = new System.IO.StreamWriter(stream, Encoding.GetEncoding(949));
				writer.Write(sbResult.ToString());
				writer.Close();
			}
			byte[] binary =  stream.ToArray();
			stream.Close();
			return binary;
		}

		/// <summary>
		/// DataTable �� ������ �ؽ�Ʈ �������� ��ȯ�Ͽ� byte[]�� ��ȯ�ϴ� �Լ�
		/// </summary>
		/// <param name="dt">�ؽ�Ʈ ���Ͽ� ������ ���������� (UI �����ڰ� ���Ŀ� �°� �����Ͽ� �ѱ⵵�� �Ѵ�.)</param>
		/// <param name="delimiter">�÷� �����ڸ� �����Ѵ�. �÷������ڴ� "\t", ";", "," </param>
		/// <param name="headerVisible">�ؽ�Ʈ ���Ͽ� �÷����� �������� ���θ� �����Ѵ�. true�̸� �÷����� �ؽ�Ʈ ���Ͽ������Ѵ�.</param>
		/// <returns>byte[]</returns>
		public static byte[] DataTable2Binary(System.Data.DataTable dt, string delimiter, bool headerVisible)
		{
			System.Text.StringBuilder sbResult = null;
			System.IO.MemoryStream stream = null;
			System.IO.StreamWriter writer = null;
			byte[] binary = null;
			try
			{
				sbResult = new System.Text.StringBuilder();
				if ( DataTable2String(dt, delimiter, headerVisible, sbResult) )
				{
					stream = new System.IO.MemoryStream();
					writer = new System.IO.StreamWriter(stream, Encoding.GetEncoding(949));
					writer.Write(sbResult.ToString());
					writer.Close();
				}
				binary =  stream.ToArray();
				stream.Close();
			}
			catch(System.Exception ex)
			{
				throw ex;
			}
			finally
			{
				if(sbResult != null) sbResult = null;
				if(writer != null )
				{
					writer.Close();
					writer = null;
				}
				if(stream != null )
				{
					stream.Close();
					stream = null;
				}
			}
			return binary;
		}

		/// <summary>
		/// DataTable�� �����͸� �ؽ�Ʈ�� ��ȯ�Ѵ�.
		/// </summary>
		/// <param name="dt">DataTable</param>
		/// <param name="delimiter">�� ������</param>
		/// <param name="headerVisible">�÷������ �ؽ�Ʈ�� ������� ����</param>
		/// <param name="sbResult">��ȯ�Ǵ� �ؽ�Ʈ</param>
		/// <returns>��������(��ȯ�Ǵ� �ؽ�Ʈ�� ������ false)</returns>
		private static bool DataTable2String(System.Data.DataTable dt, string delimiter, bool headerVisible, System.Text.StringBuilder sbResult)
		{
			//	delimiter�� ���� ���������� Ȯ��
//			string strDelimiter = "\t;,";
//			if ( strDelimiter.IndexOf(delimiter) < 0 )
//				throw new System.Exception("�����͸� �ؽ�Ʈ�� ��ȯ���� ���߽��ϴ�. \r\n��ȿ���� ���� ������ �Դϴ�.");

			//	sbResult�� �ν��Ͻ��� �������� �ʾ����� �����ϵ��� �մϴ�.
			if ( sbResult == null )
				sbResult = new System.Text.StringBuilder();

			//	����� �ؽ�Ʈ�� ������ ����
			if ( headerVisible )
			{
				foreach ( System.Data.DataColumn col in dt.Columns )
				{
					sbResult.Append(col.ColumnName);
					sbResult.Append(delimiter);
				}
				sbResult.Remove(sbResult.Length - delimiter.Length,delimiter.Length);
				sbResult.Append("\r\n");
			}
			//	�����͸� �ؽ�Ʈ�� ��ȯ
			foreach ( System.Data.DataRow row in dt.Rows )
			{
				for ( int i = 0 ; i < dt.Columns.Count ; i++ )
				{
					sbResult.Append(row[i].ToString());
					sbResult.Append(delimiter);
				}
				sbResult.Remove(sbResult.Length-delimiter.Length,delimiter.Length);
				sbResult.Append("\r\n");
			}
			return sbResult.Length > 0;
		}

		/// <summary>
		/// DataTable�� �����͸� �ؽ�Ʈ�� ��ȯ�Ѵ�.
		/// </summary>
		/// <param name="dt">DataTable</param>
		/// <param name="columnLengths">������ �迭</param>
		/// <param name="headerVisible">�÷������ �ؽ�Ʈ�� ������� ����</param>
		/// <param name="sbResult">��ȯ�Ǵ� �ؽ�Ʈ</param>
		/// <returns>��������(��ȯ�Ǵ� �ؽ�Ʈ�� ������ false)</returns>
		private static bool DataTable2String(System.Data.DataTable dt, ColumnLengthDelimiter[] colLenDelimiter, bool headerVisible, System.Text.StringBuilder sbResult)
		{
			// ������ �迭������ ���̺��� �÷� ������ ��ġ�ϴ��� Ȯ��
			if ( dt.Columns.Count != colLenDelimiter.Length )
				throw new System.Exception("�����͸� �ؽ�Ʈ�� ��ȯ���� ���߽��ϴ�. \r\n�������� �÷� ������ ������ �迭�� ������ ��ġ���� �ʽ��ϴ�.|^|");

			//	sbResult�� �ν��Ͻ��� �������� �ʾ����� �����ϵ��� �մϴ�.
			if ( sbResult == null )
				sbResult = new System.Text.StringBuilder();

			Encoding en = Encoding.GetEncoding(949);
			string format = string.Empty;
			string strData = string.Empty;
			byte[] ByteArray = null;
			//	����� �ؽ�Ʈ�� ������ ����
			if ( headerVisible )
			{
				for ( int i = 0 ; i < dt.Columns.Count ; i++ )
				{
					//	�÷����� �ؽ�Ʈ�� ������ ������ ��� ���ܰ� �߻��մϴ�.
					//		��å������ �̰��� ����Ϸ��� if �� �ȿ��� ���ܸ� �߻���Ű�� ���� if �� �ȿ��� �÷����� ���̿� �°� �ڸ����� �����Ͻ� ���� �ֽ��ϴ�.
					
					
					ByteArray = new byte[colLenDelimiter[i].ColumnLength];
					if(en.GetByteCount(dt.Columns[i].ColumnName) > System.Math.Abs(colLenDelimiter[i].ColumnLength))
					{
						string strMessage = string.Format("�����͸� �ؽ�Ʈ�� ��ȯ���� ���߽��ϴ�. \r\n{0} ��° �÷��� {1}��(��) ������ �÷��� �ʺ񺸴� Ů�ϴ�.|^|",i.ToString(),dt.Columns[i].ColumnName);
						throw new System.Exception(strMessage);
					}				
										
					en.GetBytes(dt.Columns[i].ColumnName,0,dt.Columns[i].ColumnName.Length,ByteArray,0);
					

					if((int)colLenDelimiter[i].ColumnAlign==0)
					{
						format = string.Format("{{0,-{0}}}", (en.GetString(ByteArray)).Length);
						strData = en.GetString(ByteArray).TrimEnd('\0').PadLeft((en.GetString(ByteArray)).Length,colLenDelimiter[i].PADChar);
					}
					else
					{
						format = string.Format("{{0,{0}}}", (en.GetString(ByteArray)).Length);
						strData = en.GetString(ByteArray).TrimEnd('\0').PadRight((en.GetString(ByteArray)).Length,colLenDelimiter[i].PADChar);
					}	
					sbResult.AppendFormat(format,strData);	
				}
				sbResult.Append("\r\n");

				//ByteArray;
			}
			//	�����͸� �ؽ�Ʈ�� ��ȯ
			System.Text.RegularExpressions.Regex regNumeric = new System.Text.RegularExpressions.Regex(@"^[+-]?\d+(\.\d+)?$");	//	�����Ͱ� �������� �Ǵ��ϴ� ���Խ�
			for ( int j = 0 ; j < dt.Rows.Count ; j++ )
			{
				for ( int i = 0 ; i < dt.Columns.Count ; i++ )
				{
					ByteArray = new byte[colLenDelimiter[i].ColumnLength];

					
					if ( en.GetByteCount(dt.Rows[j][i].ToString()) >  System.Math.Abs(colLenDelimiter[i].ColumnLength) )
					{
						string strMessage = string.Format(
							"�����͸� �ؽ�Ʈ�� ��ȯ���� ���߽��ϴ�. \r\n{0} ��° ���ڵ��� {1} ��° �� {2}��(��) ������ �÷��� �ʺ񺸴� Ů�ϴ�.|^|"
							,j.ToString(), i.ToString(), dt.Rows[j][i].ToString() );
						throw new System.Exception(strMessage);
					}
					en.GetBytes(dt.Rows[j][i].ToString(),0,dt.Rows[j][i].ToString().Length, ByteArray,0);

					if((int)colLenDelimiter[i].ColumnAlign==0)
					{
						format = string.Format("{{0,-{0}}}", (en.GetString(ByteArray)).Length);
						strData = en.GetString(ByteArray).TrimEnd('\0').PadLeft((en.GetString(ByteArray)).Length,colLenDelimiter[i].PADChar);
					}
					else
					{
						format = string.Format("{{0,{0}}}", (en.GetString(ByteArray)).Length);
						strData = en.GetString(ByteArray).TrimEnd('\0').PadRight((en.GetString(ByteArray)).Length,colLenDelimiter[i].PADChar);
					}	
					sbResult.AppendFormat(format,strData);	
				}
				sbResult.Append("\r\n");
			}
			return sbResult.Length > 0;
        }

        #endregion == DataTable2TextFile DataTable �� ������ �ؽ�Ʈ ���Ϸ� ��ȯ�ϴ� �Լ� (4�� �����ε�) ==

        #region ColumnLengthDelimiter

        public class ColumnLengthDelimiter
		{
			public enum Align
			{
				Left,
				Right
			}

			Align align;
			int columnlength=0;
			char padChar;

			public ColumnLengthDelimiter(int columnLength,Align align, char padChar)
			{
				this.align = align;
				this.columnlength = columnLength;
				this.padChar = padChar;
			}

			public int ColumnLength
			{
				get{return this.columnlength;}
			}
			public Align ColumnAlign
			{
				get{return this.align;}
			}
			public char PADChar
			{
				get{return this.padChar;}
			}
		}

        #endregion

        /// <summary>
        /// DB �μ�Ʈ �� ���ڿ� Replace<para></para>
        /// <example ><![CDATA[ 
        /// & => &amp;
        /// < => &lt;
        /// > => &gt;
        /// ' => ''
        /// " => &quot;
        /// ]]></example>
        /// </summary>
        /// <param name="strVal">�ٲ� ���ڿ�</param>
        /// <returns>�ٲ� ���ڿ�</returns>
        public static string EncodeChar(string value)
        {
            string strTmp = value;
            strTmp = strTmp.Replace("&", "&amp;");
            strTmp = strTmp.Replace("<", "&lt;");
            strTmp = strTmp.Replace(">", "&gt;");
            strTmp = strTmp.Replace("'", "''");
            strTmp = strTmp.Replace("\"", "&quot;");
            return strTmp;
        }

        /// <summary>
        /// ȭ�� ��� ���ڿ� Replace<para></para>
        /// <example ><![CDATA[ 
        /// &amp;  => &
        /// &lt;   => <
        /// &gt;   => >
        /// ''     => '
        /// &quot; => "
        /// ]]></example>
        /// </summary>
        /// <param name="strVal">�ٲ� ���ڿ�</param>
        /// <returns>�ٲ� ���ڿ�</returns>
        public static string DecodeChar(string value)
        {
            string strTmp = value;
            strTmp = strTmp.Replace("&amp;", "&");
            strTmp = strTmp.Replace("&lt;", "<");
            strTmp = strTmp.Replace("&gt;", ">");
            strTmp = strTmp.Replace("''", "'");
            strTmp = strTmp.Replace("&quot;", "\"");
            return strTmp;
        }


        /// <summary>
        /// 
        /// </summary>
        public static string FILE_BYTE_ARRAY_DELIMITTER = ";;;;;;;;;;";

		/// <summary>
		/// �����н� �迭�� ���� ������ byte[]�� ����� string���� ��ȯ�Ͽ� ����
		/// </summary>
		/// <param name="arrFiles">�����н� �迭</param>
		/// <returns>������ byte[]�� ��ȯ�� string</returns>
		public static string GetFileStringByFile(string[] arrFiles)
		{
			byte[][] arrFileByte = null;
			StringBuilder sb = null;
			string strResult = string.Empty;
			if(arrFiles != null && arrFiles.Length > 0)
			{
				sb = new StringBuilder();

				// ���� ���ϸ� ����
				for(int i=0;i<arrFiles.Length;i++)
					sb.Append(System.IO.Path.GetFileName(arrFiles[i]) + FILE_BYTE_ARRAY_DELIMITTER);

				// ���ϸ�� ������ Delimitter �ΰ��� ���� ���� �������̴�..
				sb.Append(FILE_BYTE_ARRAY_DELIMITTER);

				// ���� ����
				arrFileByte = new byte[arrFiles.Length][];
				for(int i=0;i<arrFiles.Length;i++)
				{
                    arrFileByte[i] = StringManager.ReadBinaryFile(arrFiles[i]);

					char[] chArr = ByteArrayToCharArray(arrFileByte[i]);
					for (int j=0; j<chArr.Length; j++)
						sb.Append(chArr[j]);

					if(i < (arrFiles.Length - 1))
						sb.Append(FILE_BYTE_ARRAY_DELIMITTER);
				}
				strResult = sb.ToString();
			}

			return strResult;
		}


		/// <summary>
		/// ù��° ���ں��� �����ϴ� �κ� ���ڿ��� �����մϴ�. (���ϴ� length�� �� ũ�� ���ڿ��� ������ ����)<br/>
		/// </summary>
		/// <param name="text">���ڿ�</param>
		/// <param name="length">�κ� ���ڿ��� �ִ� ������ ���Դϴ�.</param>
		/// <returns></returns>
		public static string GetSubstring( string text, int length )
		{
			return GetSubstring( text, 0, length );
		}

		/// <summary>
		/// �κ� ���ڿ��� �����մϴ�. (���ϴ� length�� �� ũ�� ���ڿ��� ������ ����)<br/>
		/// </summary>
		/// <param name="text">���ڿ�</param>
		/// <param name="startIndex">�κ� ���ڿ��� ó�� ��ġ�� ���� �ε����Դϴ�.</param>
		/// <param name="length">�κ� ���ڿ��� �ִ� ������ ���Դϴ�.</param>
		/// <returns></returns>
		public static string GetSubstring( string text, int startIndex, int length )
		{
			if ( text.Length == 0 ) return String.Empty;
			if ( (text.Length - startIndex) < 0 ) return String.Empty;
	
			if ( (startIndex + length) > text.Length )
				return text.Substring( startIndex, (text.Length - startIndex) );
			else
				return text.Substring( startIndex, length );
		}

		/// <summary>
		/// �κ� ���ڿ��� �����մϴ�. (���ϴ� length�� �� ũ�� ���ڿ��� ������ ����)<br/>
		/// </summary>
		/// <param name="text">���ڿ�</param>
		/// <param name="startIndex">�κ� ���ڿ��� ó�� ��ġ�� ���� �ε����Դϴ�.</param>
		/// <param name="length">�κ� ���ڿ��� �ִ� ������ ���Դϴ�.</param>
		/// <returns></returns>
		public static string GetSubstring( object text, int startIndex, int length )
		{
			string strText = text as string;
			if ( strText == null ) return String.Empty;

			return GetSubstring( strText, startIndex, length );
		}

		/// <summary>
		/// ù��° ���ں��� �����ϴ� �κ� ���ڿ��� �����մϴ�. (���ϴ� length�� �� ũ�� ���ڿ��� ������ ����)<br/>
		/// </summary>
		/// <param name="text">���ڿ�</param>
		/// <param name="length">�κ� ���ڿ��� �ִ� ������ ���Դϴ�.</param>
		/// <returns></returns>
		public static string GetSubstring( object text, int length )
		{
			string strText = text as string;
			if ( strText == null ) return String.Empty;

			return GetSubstring( strText, 0, length );
		}
	}
}
