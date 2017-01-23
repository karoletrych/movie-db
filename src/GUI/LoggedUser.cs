namespace GUI
{
    public static class LoggedUser
    {
        public static string Login { get; set; } 
        public static bool IsLogged => Login!=null;
    }
}