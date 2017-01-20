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
            var retriever = new HttpRetriever();
            var movie = retriever.RetrieveMovie(123);
        }

        [Fact]
        public void CountriesTest()
        {
            var retriever = new HttpRetriever();
            var countries = retriever.RetrieveCountriesFromFilm(123).ToList();
        }

        [Fact]
        public void PersonTest()
        {
            var retriever = new HttpRetriever();
            var people = retriever.RetrievePerson(123);
        }

        [Fact]
        public void CastTest()
        {
            var retriever = new HttpRetriever();
            var casts = retriever.RetrieveCastFromFilm(123).ToList();
        }

        [Fact]
        public void CrewTest()
        {
            var retriever = new HttpRetriever();
            var crews = retriever.RetrieveCrewFromFilm(123).ToList();
        }

        [Fact]
        public void JobsTest()
        {
            var retriever = new HttpRetriever();
            var jobs = retriever.RetrieveDepartments().ToList();
        }
    }
}
