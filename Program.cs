using System.CommandLine;

namespace locker;

class Locker
{
    static int Main(string[] args)
    {
        var sourceOption = new Option<string>(
            name: "--source",
            description: "The source file/folder to encrypt/decrypt."
        );

        var outputOption = new Option<string>(
            name: "--output",
            description: "The output directory."
        );

        var rootCommand = new RootCommand("Locker - file/folder encryptor/decryptor");
        var encrypt = new Command("-e", "Encrypts the file/folder")
            {
                sourceOption,
                outputOption
            };
        var decrypt = new Command("-d", "Decrypts the file/folder")
            {
                sourceOption,
                outputOption
            };
        rootCommand.AddCommand(encrypt);
        rootCommand.AddCommand(decrypt);

        encrypt.SetHandler(async (source, output) =>
            {
                await Encrypt(source, output);
            },
            sourceOption,
            outputOption
        );

        decrypt.SetHandler(async (source, output) =>
            {
                await Decrypt(source, output);
            },
            sourceOption,
            outputOption
        );

        return rootCommand.InvokeAsync(args).Result;
    }

    internal static async Task Encrypt(string source, string output) {
        // todo
        await Task.Delay(1);
    }

    internal static async Task Decrypt(string source, string output) {
        // todo
        await Task.Delay(1);
    }
}