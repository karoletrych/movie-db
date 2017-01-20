using System.Linq;
using DataRetriever;
using Xunit;

namespace Tests
{
    public class RetrieverTests
    {
        [Fact]
        public void FilmTest()
        {
            var retriever = new HTTPRetriever();
            var movie = retriever.RetrieveFilm(123);
        }

        [Fact]
        public void CountriesTest()
        {
            var retriever = new HTTPRetriever();
            var krajs = retriever.RetrieveCountriesFromFilm(123).ToList();
        }

        [Fact]
        public void PersonTest()
        {
            var retriever = new HTTPRetriever();
            var person = retriever.RetrievePerson(123);
        }

        [Fact]
        public void CastTest()
        {
            var retriever = new HTTPRetriever();
            var person = retriever.RetrieveCastFromFilm(123).ToList();
        }
    }
}
