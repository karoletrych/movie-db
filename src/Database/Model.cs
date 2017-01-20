using System;
using System.Collections.Generic;

namespace Database
{
    public class Movie
    {
        public int MovieId { get; set; }
        public DateTime? ReleaseDate { get; set; }
        public string Status { get; set; }
        public decimal Revenue { get; set; }
        public string PosterUrl { get; set; }
        public string Title { get; set; }
        public float AverageVote { get; set; }
    }

    public class Movie_ProductionCountry
    {
        public int CountryId { get; set; }
        public int MovieId { get; set; }
    }

    public class Country
    {
        public string CountryId { get; set; }
        public string Name { get; set; }
    }

    public class MovieGenre
    {
        public int MovieId { get; set; }
        public int GenreId { get; set; }
    }

    public class Genre
    {
        public int GenreId { get; set; }
        public string Name { get; set; }
    }

    public class Review
    {
        public int UserId { get; set; }
        public int MovieId { get; set; }

        public string Content { get; set; }
        public int Vote { get; set; }
    }

    public class Member
    {
        public int MemberId { get; set; }

        public string Login { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
    }

    public class Cast
    {
        public int PersonId { get; set; }
        public int MovieId { get; set; }
        public string Character { get; set; }
    }

    public class Crew
    {
        public int PersonId { get; set; }
        public int MovieId { get; set; }
        public int JobId { get; set; }
    }

    public class Job
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

    public class Department
    {
        public IEnumerable<Job> Jobs { get; set; }
        public string Name { get; set; }
        public int Id { get; set; }
    }

    public class Person
    {
        public int PersonId { get; set; }
        public DateTime? BirthDay { get; set; }
        public DateTime? DeathDay { get; set; }
        public string Biography { get; set; }
        public int Gender { get; set; }
        public string PlaceOfBirth { get; set; }
        public string Name { get; set; }
    }

    public class CountryOfOrigin
    {
        public int PersonId { get; set; }
        public int CountryId { get; }
    }
}