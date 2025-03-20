import os
import certifi
import shutil

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
msys2_path = shutil.which('python3')

def get_root(delimit) -> str:
    msys2_path = shutil.which('python3')
    print(msys2_path)
    msys2_path = msys2_path.replace("\\", "/")
    msys2_path = msys2_path.replace("//", "/")
    parts = msys2_path.split('/')  # Split into segments
    collected_parts = []
    for part in parts:
        print(part)
        if part.lower() == delimit:
            break
        collected_parts.append(part)
    if len(collected_parts) > 0 and collected_parts[0].endswith(':'):
        collected_parts[0] += '/' 
    result = os.path.join(*collected_parts, delimit)
    return result

if "MINGW64" in os_str:
    dest_dir = get_root("mingw64")
elif "MINGW32" in os_str:
    dest_dir = get_root("mingw32")
elif "UCRT64" in os_str:
    dest_dir = get_root("ucrt64")
elif "CLANG64" in os_str:
    dest_dir = get_root("clang64")
elif "Linux" in os_str:
    dest_dir = "/"
else:
    raise Exception("Unrecognized platform")

os.environ["DESTDIR"] = dest_dir
# Force Python to use the correct CA file
os.environ['SSL_CERT_FILE'] = certifi.where()
