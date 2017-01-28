using System;

namespace DataRetriever
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            var retriever = new DataRetriever();
            int count;
            if(!int.TryParse(args[0], out count))
            {
                Console.WriteLine("Podaj liczbe filmow");
            }
            else
            {
                retriever.Retrieve(count);
            }
        }
    }
}