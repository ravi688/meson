import os


def detect_os():
    if "MSYSTEM" in os.environ:
        msystem = os.environ["MSYSTEM"]
        if msystem == "MSYS":
            return "MSYS2"
        elif msystem == "MINGW64":
            return "MINGW64"
        elif msystem == "MINGW32":
            return "MINGW32"
        elif msystem == "UCRT64":
            return "MINGW-UCRT64"
        elif msystem == "CLANG64":
            return "MINGW-CLANG64"
        else:
            return f"Unknown MSYS2 Variant: {msystem}"
    elif sys.platform.startswith("linux"):
        return "Linux"
    elif sys.platform.startswith("win32"):
        return "Windows (Non-MSYS2)"
    else:
        return f"Unknown OS: {sys.platform}"

os_str = detect_os()
dest_dir = ""
if "MINGW64" in os_str:
	dest_dir = "/mingw64"
elif "MINGW32" in os_str:
	dest_dir = "/mingw32"
elif "MSYS" in os_str:
	dest_dir = "/"
elif "UCRT64" in os_str:
	dest_dir = "/ucrt64"
elif "CLANG64" in os_str:
	dest_dir = "/clang64"
elif "Linux" in os_str:
	dest_dir = "/usr"
else:
	raise Exception("Unrecognized platform")

os.environ["DESTDIR"] = dest_dir
