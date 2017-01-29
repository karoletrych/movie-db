using System;
using System.Collections.Generic;

namespace Database.Model
{
    public class Movie
    {
        public Movie(DateTime? releaseDate, int movieId, string status, decimal revenue, string posterUrl, string title, float? averageVote)
        {
            ReleaseDate = releaseDate;
            MovieId = movieId;
            Status = status;
            Revenue = revenue;
            PosterUrl = posterUrl;
            Title = title;
            AverageVote = averageVote;
        }

        public int MovieId { get; private set; }
        public DateTime? ReleaseDate { get; private set; }
        public string Status { get; private set; }
        public decimal Revenue { get; private set; }
        public string PosterUrl { get; private set; }
        public string Title { get; private set; }
        public float? AverageVote { get; private set; }
    }

    public class Country
    {
        public Country(string countryId, string name)
        {
            CountryId = countryId;
            Name = name;
        }

        public string CountryId { get; private set; }
        public string Name { get; private set; }
    }

    public class MovieGenre
    {
        public MovieGenre(int movieId, int genreId)
        {
            MovieId = movieId;
            GenreId = genreId;
        }

        public int MovieId { get; private set; }
        public int GenreId { get; private set; }
    }

    public class Genre
    {
        public Genre(int genreId, string name)
        {
            GenreId = genreId;
            Name = name;
        }

        public int GenreId { get; private set; }
        public string Name { get; private set; }
    }

    public class Review
    {
        public Review(int vote, string content, int movieId, int userId)
        {
            Vote = vote;
            Content = content;
            MovieId = movieId;
            UserId = userId;
        }

        public int UserId { get; private set; }
        public int MovieId { get; private set; }

        public string Content { get; private set; }
        public int Vote { get; private set; }
    }

    public class Member
    {
        public Member(int memberId, string login, string email, string passwordHash)
        {
            MemberId = memberId;
            Login = login;
            Email = email;
            PasswordHash = passwordHash;
        }

        public int MemberId { get; private set; }

        public string Login { get; private set; }
        public string Email { get; private set; }
        public string PasswordHash { get; private set; }
    }

    public class Cast
    {
        public Cast(int person, int movie, string character)
        {
            PersonId = person;
            MovieId = movie;
            Character = character;
        }

        public int PersonId { get; private set; }
        public int MovieId { get; private set; }
        public string Character { get; private set; }
    }

    public class Crew
    {
        public Crew(int person, int movie, string jobName)
        {
            PersonId = person;
            MovieId = movie;
            JobName = jobName;
        }

        public int PersonId { get; private set; }
        public int MovieId { get; private set; }
        public string JobName { get; private set; }
    }

    public class Job
    {
        public Job(string name)
        {
            Name = name;
        }

        public string Name { get; private set; }
    }

    public class Department
    {
        public Department(int id, string name, IEnumerable<Job> jobs)
        {
            Id = id;
            Name = name;
            Jobs = jobs;
        }

        public IEnumerable<Job> Jobs { get; private set; }
        public string Name { get; private set; }
        public int Id { get; private set; }
    }

    public class Person
    {
        public Person(string name, int personId, DateTime? birthDay, DateTime? deathDay, string biography, int gender, string placeOfBirth)
        {
            Name = name;
            PersonId = personId;
            BirthDay = birthDay;
            DeathDay = deathDay;
            Biography = biography;
            Gender = gender;
            PlaceOfBirth = placeOfBirth;
        }

        public int PersonId { get; private set; }
        public DateTime? BirthDay { get; private set; }
        public DateTime? DeathDay { get; private set; }
        public string Biography { get; private set; }
        public int Gender { get; private set; }
        public string PlaceOfBirth { get; private set; }
        public string Name { get; private set; }
    }
}