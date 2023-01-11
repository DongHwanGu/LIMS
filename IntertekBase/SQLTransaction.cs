using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;


namespace IntertekBase
{
    public class SQLTransaction
    {
        #region = Transaction 생성 =
        public static TransactionScope GetTransaction()
        {
            TransactionOptions options = new TransactionOptions();
            options.IsolationLevel = System.Transactions.IsolationLevel.ReadUncommitted;
            options.Timeout = TransactionManager.DefaultTimeout;

            TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, options);

            return scope;
        }
        #endregion
    }
}
