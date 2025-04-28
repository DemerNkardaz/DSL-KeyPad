using System;
using System.Diagnostics;
using System.IO;

class Program
{
	static void Main()
	{
		string currentDirectory = AppDomain.CurrentDomain.BaseDirectory;
		string filePath = Path.Combine(currentDirectory, "DSLKeyPad.ahk");
		string autoHotkeyPath = @"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe";

		if (File.Exists(filePath))
		{
			if (File.Exists(autoHotkeyPath))
			{
				Process.Start(new ProcessStartInfo(autoHotkeyPath, "/restart /script \"" + filePath + "\"") { UseShellExecute = true });
			}
			else
			{
				Process.Start(new ProcessStartInfo(filePath) { UseShellExecute = true });
			}
		}
		else
		{
			Console.WriteLine("Main file “" + filePath + "” not found, check you installation");
			Console.WriteLine("Git Repository: https://github.com/DemerNkardaz/DSL-KeyPad");
			Console.WriteLine("\nPress any key to continue...");
			Console.ReadLine();
		}
	}
}