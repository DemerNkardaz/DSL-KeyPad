// !GENERATED WITH AI, just...
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


		//"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" /restart /script "E:\Work\GitRepos\DSL-KeyPad\Testing\DSLKeyPad\DSLKeyPad.ahk"

		if (File.Exists(filePath))
		{
			//Process.Start(new ProcessStartInfo(filePath) { UseShellExecute = true });
			Process.Start(new ProcessStartInfo(autoHotkeyPath, "/restart /script \"" + filePath + "\"") { UseShellExecute = true });
		}
		else
		{
			Console.WriteLine("File Not Found: " + filePath);
		}
	}
}
