using System;

namespace Database
{
    public class film
    {
        public int FilmId { get; set; }
        public DateTime? DataPremiery { get; set; }
        public string Status { get; set; }
        public decimal Dochod { get; set; }
        public string UrlPlakatu { get; set; }
        public string Tytul { get; set; }
    }

    public class film_kraj_produkcji
    {
        public int KrajId { get; set; }
        public int FilmId { get; set; }
    }

    public class kraj
    {
        public string KrajId { get; set; }
        public string Nazwa { get; set; }
    }

    public class film_gatunek
    {
        public int FilmId { get; set; }
        public int GatunekId { get; set; }
    }

    public class gatunek
    {
        public int GatunekId { get; set; }
        public string Nazwa { get; set; }
    }

    public class recenzja
    {
        public int IdUzytkownik { get; set; }
        public int FilmId { get; set; }

        public string Tresc { get; set; }
        public int Ocena { get; set; }
    }

    public class uzytkownik
    {
        public int IdUzytkownik { get; set; }

        public string Login { get; set; }
        public string Email { get; set; }
        public string HashHasla { get; set; }
    }

    public class obsada
    {
        public int CzlowiekId { get; set; }
        public int FamilyId { get; set; }
        public string postac { get; set; }
    }

    public class ekipa
    {
        public int CzlowiekId { get; set; }
        public int FilmId { get; set; }
        public int PracaId { get; set; }
    }

    public class praca
    {
        public int PracaId { get; set; }
        public int DzialId { get; set; }
        public string Nazwa { get; set; }
    }

    public class dzial
    {
        public int DzialId { get; set; }
        public string Nazwa { get; set; }
    }

    public class czlowiek
    {
        public int CzlowiekId { get; set; }
        public DateTime DataUrodzenia { get; set; }
        public DateTime DataZgonu { get; set; }
        public string Biografia { get; set; }
        public int Plec { get; set; }
        public string MiejsceUrodzenia { get; set; }
        public string Nazwisko { get; set; }
    }

    public class kraj_pochodzenia
    {
        public int CzlowiekId { get; set; }
        public int KrajId { get; }
    }
}