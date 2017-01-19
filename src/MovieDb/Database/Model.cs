using System;

namespace Database
{
    public class Film
    {
        public int FilmId { get; set; }
        public DateTime? DataPremiery { get; set; }
        public string Status { get; set; }
        public decimal Dochod { get; set; }
        public string UrlPlakatu { get; set; }
        public string Tytul { get; set; }
    }

    public class FilmKrajProdukcji
    {
        public int KrajId { get; set; }
        public int FilmId { get; set; }
    }

    public class Kraj
    {
        public string KrajId { get; set; }
        public string Nazwa { get; set; }
    }

    public class FilmGatunek
    {
        public int FilmId { get; set; }
        public int GatunekId { get; set; }
    }

    public class Gatunek
    {
        public int GatunekId { get; set; }
        public string Nazwa { get; set; }
    }

    public class Recenzja
    {
        public int IdUzytkownik { get; set; }
        public int FilmId { get; set; }

        public string Tresc { get; set; }
        public int Ocena { get; set; }
    }

    public class Uzytkownik
    {
        public int IdUzytkownik { get; set; }

        public string Login { get; set; }
        public string Email { get; set; }
        public string HashHasla { get; set; }
    }

    public class Obsada
    {
        public int CzlowiekId { get; set; }
        public int FilmId { get; set; }
        public string Postac { get; set; }
    }

    public class Ekipa
    {
        public int CzlowiekId { get; set; }
        public int FilmId { get; set; }
        public int PracaId { get; set; }
    }

    public class Praca
    {
        public int PracaId { get; set; }
        public int DzialId { get; set; }
        public string Nazwa { get; set; }
    }

    public class Dzial
    {
        public int DzialId { get; set; }
        public string Nazwa { get; set; }
    }

    public class Czlowiek
    {
        public int CzlowiekId { get; set; }
        public DateTime? DataUrodzenia { get; set; }
        public DateTime? DataZgonu { get; set; }
        public string Biografia { get; set; }
        public int Plec { get; set; }
        public string MiejsceUrodzenia { get; set; }
        public string Nazwisko { get; set; }
    }

    public class KrajPochodzenia
    {
        public int CzlowiekId { get; set; }
        public int KrajId { get; }
    }
}