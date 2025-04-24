// !GENERATED WITH AI, just...
using System;
using System.IO;
using System.Runtime.InteropServices;

class Program
{
	// 1) Импортируем необходимые функции WinAPI
	[DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
	static extern IntPtr LoadLibrary(string lpFileName);

	[DllImport("kernel32.dll", SetLastError = true)]
	static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

	[DllImport("ole32.dll")]
	static extern int CoInitialize(IntPtr pvReserved);

	[DllImport("ole32.dll")]
	static extern void CoUninitialize();

	// 2) Делегат для Host
	[UnmanagedFunctionPointer(CallingConvention.Cdecl)]
	delegate int HostDelegate(out IntPtr ppLib);

	static void Main()
	{
		string baseDir = AppDomain.CurrentDomain.BaseDirectory;
		string dllPath = Path.Combine(baseDir, "bin", "AutoHotkey64.dll");
		string scriptPath = Path.Combine(baseDir, "DSLKeyPad.ahk");

		if (!File.Exists(dllPath))
		{
			Console.Error.WriteLine("Не найдена DLL: " + dllPath);
			Environment.Exit(1);
		}
		if (!File.Exists(scriptPath))
		{
			Console.Error.WriteLine("Не найден DSLKeyPad.ahk: " + scriptPath);
			Environment.Exit(1);
		}

		// Загружаем DLL вручную
		IntPtr hModule = LoadLibrary(dllPath);
		if (hModule == IntPtr.Zero)
		{
			Console.Error.WriteLine("Ошибка загрузки DLL.");
			Environment.Exit(1);
		}

		// Получаем функцию Host
		IntPtr pHost = GetProcAddress(hModule, "Host");
		if (pHost == IntPtr.Zero)
		{
			Console.Error.WriteLine("Не найдена точка входа Host в DLL.");
			Environment.Exit(1);
		}

		// Инициализируем COM
		CoInitialize(IntPtr.Zero);

		try
		{
			var host = Marshal.GetDelegateForFunctionPointer<HostDelegate>(pHost);
			IntPtr pUnk;
			if (host(out pUnk) != 0 || pUnk == IntPtr.Zero)
			{
				Console.Error.WriteLine("Host() завершилась с ошибкой.");
				Environment.Exit(1);
			}


			dynamic lib = Marshal.GetObjectForIUnknown(pUnk);

			lib.LoadFile(scriptPath);
			lib.Execute();


		}
		finally
		{
			// Освобождаем COM
			CoUninitialize();
		}
	}
}
