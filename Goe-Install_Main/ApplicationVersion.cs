using System.Security.Cryptography;

class ApplicationVersion
{
    public string applicationVersion
    {
        get { return "0.0.1"; }
    }

    public SHA512 applicationHash
    {
        get { return null; }
    }
}