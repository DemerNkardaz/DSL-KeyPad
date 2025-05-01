using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Globalization;
using System.Threading;

class Program
{
	[DllImport("shell32.dll", CharSet = CharSet.Auto)]
	static extern IntPtr FindExecutable(string lpFileName, string lpDirectory, StringBuilder lpResult);

	[DllImport("kernel32.dll", SetLastError = true)]
	static extern IntPtr GetStdHandle(int nStdHandle);

	[DllImport("kernel32.dll", SetLastError = true)]
	static extern bool GetConsoleMode(IntPtr hConsoleHandle, out int lpMode);

	[DllImport("kernel32.dll", SetLastError = true)]
	static extern bool SetConsoleMode(IntPtr hConsoleHandle, int dwMode);

	const int STD_OUTPUT_HANDLE = -11;
	const int ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004;
	const long SE_ERR_NOASSOC = 31;

	static bool isRussian;
	static bool vtEnabled;

	static void Main()
	{
		Console.OutputEncoding = Encoding.UTF8;

		isRussian = Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName.Equals("ru", StringComparison.OrdinalIgnoreCase);


		EnableVirtualTerminal();

		string currentDirectory = AppDomain.CurrentDomain.BaseDirectory;
		string filePath = Path.Combine(currentDirectory, "DSLKeyPad.ahk");

		if (!File.Exists(filePath))
		{
			if (isRussian)
			{
				Console.WriteLine("Основной файл '" + filePath + "' не найден, проверьте установку");
				Console.WriteLine("Git-репозиторий: " + WrapLink("https://github.com/DemerNkardaz/DSL-KeyPad"));
				Console.WriteLine("SourceForge репозиторий: " + WrapLink("https://sourceforge.net/projects/dsl-keypad/"));
			}
			else
			{
				Console.WriteLine("Main file '" + filePath + "' not found, check your installation");
				Console.WriteLine("Git Repository: " + WrapLink("https://github.com/DemerNkardaz/DSL-KeyPad"));
				Console.WriteLine("SourceForge Repository: " + WrapLink("https://sourceforge.net/projects/dsl-keypad/"));
			}
			Console.WriteLine();
			Console.WriteLine(isRussian ? "Нажмите любую клавишу для продолжения..." : "Press any key to continue...");
			Console.ReadLine();
			return;
		}

		if (!HasFileAssociation(filePath))
		{
			if (isRussian)
			{
				Console.WriteLine("«AutoHotkey» не был обнаружен в системе, но требуется для работы программы");
				Console.WriteLine("Пожалуйста, установите AutoHotkey (версии 2.0 и выше): " + WrapLink("https://www.autohotkey.com/") + ", затем повторите запуск");
			}
			else
			{
				Console.WriteLine("“AutoHotkey” was not found in the system, but is required for the program to work”");
				Console.WriteLine("Please install AutoHotkey from " + WrapLink("https://www.autohotkey.com/") + " before running this software");
			}
			Console.WriteLine();
			Console.WriteLine(isRussian ? "Нажмите любую клавишу для продолжения..." : "Press any key to continue...");
			Console.ReadLine();
			return;
		}

		string autoHotkeyPath = @"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe";
		if (File.Exists(autoHotkeyPath))
		{
			Process.Start(new ProcessStartInfo(
				autoHotkeyPath,
				"/restart /script \"" + filePath + "\"")
			{ UseShellExecute = true });
		}
		else
		{
			Process.Start(new ProcessStartInfo(filePath) { UseShellExecute = true });
		}
	}

	static bool HasFileAssociation(string path)
	{
		StringBuilder outPath = new StringBuilder(260);
		IntPtr result = FindExecutable(path, null, outPath);
		return result.ToInt64() > SE_ERR_NOASSOC;
	}

	static void EnableVirtualTerminal()
	{
		IntPtr handle = GetStdHandle(STD_OUTPUT_HANDLE);
		if (handle == IntPtr.Zero) return;

		int mode;
		if (!GetConsoleMode(handle, out mode)) return;

		mode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
		if (SetConsoleMode(handle, mode))
		{
			vtEnabled = true;
		}
	}

	static string WrapLink(string url)
	{
		if (!vtEnabled) return url;
		return "\u001b]8;;" + url + "\u0007" + url + "\u001b]8;;\u0007";
	}
}
