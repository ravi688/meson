# Modifications since fork

## New wrap file support of type `[wrap-path]`
`[wrap-path]` allows you to use a meson project located anywhere in your disk to be used as a subproject into another meson project.
**Example wrap-path file**:
```yaml
[wrap-path]
path=../../

[provide]
sge = sge_static_dep
```

## Full support for fetching, and applying patch archives
After cloning a git repo, you may need to apply some patches to the subproject (cloned repo inside subpojects/ dir).
For example, if the git repo is based on cmake build system and it doesn't use PIC (position independent code) to let you link it against a shared library based on meson,
in that case you would have to apply a patch to enable PIC flag into the CMakeLists.txt file of the cloned git repo.
**Example wrap-git file with patch application**:
```yaml
[wrap-git]
url = https://github.com/DaanDeMeyer/reproc.git
revision = HEAD
depth = 1
method = cmake
patch_url=https://raw.githubusercontent.com/ravi688/patch-archives/refs/heads/main/reproc-enable-pic.tar
patch_filename=reproc-enable-pic.tar
patch_hash=5eb5f757e24bc140d0ff55c1d33a8124a58e5b580bb09453d894d359ede0506e

[provide]
reproc = reproc_dep
```
> [!Note]
> The patch commands are run inside the cloned directory, i.e. subprojects/<package_name>. Therefore, you must create your patches relative to clone directory.

### Few useful command for creating patches
#### Creating tar archive
```
$ tar -cf reproc-enable-pic.tar reproc-enable-pic.patch
```
#### Calculated 256 bit sha checksum for integrity verification
```
$ shasum -a 256 reproc-enablel-pic.tar
```
This would print the hash (along with the file name, but you can ignore that).

> [!Note]
> When you execute `meson subprojects purge --confirm`, then the patch archive extract directories will also be removed
