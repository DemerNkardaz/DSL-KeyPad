using System;
using System.Diagnostics;
using System.IO;

class Program
{
	static void Main()
	{
		string currentDirectory = AppDomain.CurrentDomain.BaseDirectory;

		string filePath = Path.Combine(currentDirectory, "DSLKeyPad.ahk");

		if (File.Exists(filePath))
		{
			Process.Start(new ProcessStartInfo(filePath) { UseShellExecute = true });
		}
		else
		{
			Console.WriteLine("File Not Found: " + filePath);
		}
	}
}
