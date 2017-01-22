using System;
using System.Collections.Generic;
using System.Linq;
using Database.DAO;
using Database.Model;

namespace DataRetriever
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            var retriever = new DataRetriever();
            retriever.Retrieve();
        }
    }
}