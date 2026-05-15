using System;
using System.Configuration; // <--- This allows C# to read Web.config
using System.Data.SqlClient;

namespace Group11Unishare
{
    public static class DatabaseHelper
    {
        public static SqlConnection GetConnection()
        {
            // Grabs the string named "UnishareDB" from Web.config
            string connectionString = ConfigurationManager.ConnectionStrings["UnishareDB"].ConnectionString;

            return new SqlConnection(connectionString);
        }
    }
}