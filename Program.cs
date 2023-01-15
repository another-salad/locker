class MainClass
{
    static int Main(string[] args)
    {
        if (args.Length == 1 && HelpRequired(args[0]))
        {
            DisplayHelp();
            return 1;
        }
        return 0;
    }

    private static bool HelpRequired(string param)
    {
        string normalizedParam = param.ToLower().Normalize();
        return normalizedParam == "-h" || normalizedParam == "--help" || normalizedParam == "/?";
    }

    private static void DisplayHelp() {
        string helpText = $"Command line params{Environment.NewLine}{Environment.NewLine}" +
                          $"'-e': Encrypt the source file/directory{Environment.NewLine}" +
                          $"'-d': Decrypt the source file/directory{Environment.NewLine}" +
                          $"'-source': The source file/directory{Environment.NewLine}" +
                          $"'-out': The output directory{Environment.NewLine}{Environment.NewLine}";
        Console.Write(helpText);
    }

}