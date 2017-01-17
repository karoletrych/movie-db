using System.Linq;
using Xunit;

namespace Tests
{
    public class Class1
    {
        [Fact]
        public void FilmTest()
        {
            var retriever = new DataRetriever.DataRetriever.HTTPRetriever();
            var movie = retriever.RetrieveFilm(123);
        }

        [Fact]
        public void CountriesTest()
        {
            var retriever = new DataRetriever.DataRetriever.HTTPRetriever();
            var krajs = retriever.RetrieveCountriesFromFilm(123).ToList();
        }
    }
}
