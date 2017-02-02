using System;

namespace GUI
{
    public static class Extensions
    {
        public static string TruncateLongString(this string str, int maxLength)
        {
            return str.Substring(0, Math.Min(str.Length, maxLength));
        }

        public static Tuple<string, string> SplitInto2Vars(this string toSplit)
        {
            var split = toSplit.Split('/');
            return Tuple.Create(split[0], split[1]);
        }

        public static Tuple<string, string, string> SplitInto3Vars(this string toSplit)
        {
            var split = toSplit.Split('/');
            return Tuple.Create(split[0], split[1], split[2]);
        }
    }
}