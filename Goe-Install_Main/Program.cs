using System;
using System.IO;
using System.Linq.Expressions;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace Goe_Install;

class Program
{
    static void Main(string[] args)
    {
        // Variablen Initialisierung
        //bool userApplicationExit = false;
        string applicationVersion = "0.0.1";
        //string userInput;
        string osInfo = getOSArch() + " - Version: " + getOSVerion(getOSArch(), false);

        // Keep Application Open Until User wants to exit

            // User Handling (Welcome Screen)
            Console.WriteLine("### GÖ - Install Version: " + applicationVersion + " ###\n");
            File.Copy("/etc/os-release", "/home/juliusreiter/Dokumente/Privat/Programmierung");

            //Console.WriteLine("You are running: " + osInfo);

            // Waiting for User Input on what to do
            Console.ReadLine();

            // Calc User Req Action


    }

    // Detect Kernal (Win/Linux/Mac)
    public static string getOSArch()
    {
        if (System.Runtime.InteropServices.RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        { return "Win"; }
        if (System.Runtime.InteropServices.RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
        { return "Mac"; }
        if (System.Runtime.InteropServices.RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
        { return "Linux"; }
        else 
        { return "N/A"; }
    }

    // Detect OS Version
    private static string getOSVerion(string osArch, bool shortendOSVersion)
    {
        //try
        //{
        string osVersion = Convert.ToString(System.Environment.OSVersion);
        // Check if OS Version could be returned
        if (osVersion != null)
        {
            switch (osArch)
            {
                case "Win":
                    if (shortendOSVersion)
                    {
                        // Short Version to first 2 Letters
                        return osVersion.Substring(0, 2);
                    }
                    else { return osVersion; }

                case "Mac":
                    if (shortendOSVersion)
                    {
                        // Short Version to first 2 Letters
                        return osVersion.Substring(0, 2);
                    }
                    else { return osVersion; }

                // Does not work. Find Fix. For some reason it cant read file contents
                case "Linux":
                    {
                        // Getting OS Version from Filesystem

                        // Define Variables
                        var osDistro = string.Empty;
                        var osDistroVersion = string.Empty;
                        string filePath = "//etc/os-release";

                        // Open Distro Info File
                        using (FileStream fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read))
                        {
                            // Using StreamReader to read through Distro Info File
                            using (StreamReader reader = new StreamReader(fileStream))
                            {
                                string line;

                                while ((line = reader.ReadLine()) != null)
                                {

                                    if (line.StartsWith("NAME"))
                                    {
                                        osDistro = line.Split('\"')[1]; //split the line string by " and get the second slice
                                    }

                                    if (line.StartsWith("VERSION_ID"))
                                    {
                                        osDistroVersion = line.Split('\"')[1];
                                    }
                                }
                            }
                        }

                        if (shortendOSVersion) { return osDistro + ";" + osDistroVersion; }
                        else { return osDistro + " - " + osDistroVersion; }
                    }

                default:
                    return "N/A";
            }
        }
        // Display Error
        else

        {
            System.Console.WriteLine("Error! - Could not find OS Version, returning null!");
            Console.ReadLine();
            Environment.Exit(-1);
            return "";
        }
    }
        /*catch(Exception ex)
        {
            Console.WriteLine(ex + " - Could Not get OS Version!");
            Console.ReadLine();
            Environment.Exit(-1);
            return "";
        }
    }*/
    
    // Check Java Version
    private string detectJavaVersion()
    {
        return "Test";
    }

    // Method for starting the Linux install
    private void fullInstallLinux()
    {
    }
}
