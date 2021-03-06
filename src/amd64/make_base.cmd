@call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"
@call "%~dp0..\..\VC-LTL helper for nmake.cmd"

set libfileroot=%~dp0..\..\x64

set libfile=%libfileroot%\msvcrt.lib

copy "%~dp0msvcrt.lib" "%libfile%" /y

echo 删除msvcrt.dll导出符号

::删除过期符号
lib "%libfile%" /remove:d:\5359.obj.amd64fre\minkernel\crts\crtw32\misc\dlllib\objfre\amd64\gs_report.obj
lib "%libfile%" /remove:d:\5359.obj.amd64fre\minkernel\crts\crtw32\eh\dlllib\objfre\amd64\ehvecctr.obj
lib "%libfile%" /remove:d:\5359.obj.amd64fre\minkernel\crts\crtw32\eh\dlllib\objfre\amd64\ehvecdtr.obj
lib "%libfile%" /remove:d:\5359.obj.amd64fre\minkernel\crts\crtw32\eh\dlllib\objfre\amd64\ehvcccvb.obj
lib "%libfile%" /remove:d:\5359.obj.amd64fre\minkernel\crts\crtw32\eh\dlllib\objfre\amd64\ehvccctr.obj
lib "%libfile%" /remove:d:\5359.obj.amd64fre\minkernel\crts\crtw32\eh\dlllib\objfre\amd64\ehveccvb.obj
lib "%libfile%" /remove:d:\5359.obj.amd64fre\minkernel\crts\crtw32\misc\dlllib\objfre\amd64\invarg.obj
lib "%libfile%" /remove:d:\5359.obj.amd64fre\minkernel\crts\crtw32\startup\dlllib\objfre\amd64\ptd_from_dll.obj
lib "%libfile%" /remove:d:\5359.obj.amd64fre\minkernel\crts\crtw32\mbstring\safe\objfre\amd64\mbsnbset_s_l.obj

::在gs_support.obj中插入lib导入库
lib "%libfile%" /remove:d:\5359.obj.amd64fre\minkernel\crts\crtw32\misc\dlllib\objfre\amd64\gs_support.obj

"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%libfile%" x64 "%~dp0..\msvcrt_forward.def" msvcrt.dll msvcrt3.dll
"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" CreateWeak  /MACHINE:x64 /def:"%~dp0..\msvcrt_forward.def"  /out:"%libfileroot%\objs\msvcrt_forward.obj"

::填充XP不支持的接口
"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%libfile%" x64 "%~dp0..\msvcrt_winxp.def" msvcrt.dll msvcrt2.dll
"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" CreateWeak  /MACHINE:x64 /def:"%~dp0..\msvcrt_winxp.def"  /out:"%libfileroot%\objs\msvcrt_2003.obj"

::填充轻量模式
"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%libfile%" x64 "%~dp0..\msvcrt_light.def" msvcrt.dll msvcrt2.dll
"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" CreateWeak  /MACHINE:x64 /def:"%~dp0..\msvcrt_light.def"  /out:"%libfileroot%\objs\msvcrt_light.obj"

::填充增强模式
"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%libfile%" x64 "%~dp0..\msvcrt_advanced.def" msvcrt.dll msvcrt2.dll
"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" CreateWeak  /MACHINE:x64 /def:"%~dp0..\msvcrt_advanced.def"  /out:"%libfileroot%\objs\msvcrt_advanced.obj"

lib "%libfile%" /remove:msvcrt3.dll

"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" rename "%libfile%.Mode.lib" x64 "%~dp0..\" msvcrt.dll msvcrt_vista.dll

set libfiletmp=%libfileroot%\msvcrt_tmp.lib

copy "%libfile%" "%libfiletmp%" /y

::删除被外部标记的导入符号
lib "%libfile%" /remove:msvcrt2.dll
::删除所有msvcrt.dll导入
lib "%libfiletmp%" /remove:msvcrt.dll

::删除所有obj文件
"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" RemoveAllObj "%libfiletmp%"

"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%libfiletmp%" x64 all msvcrt2.dll msvcrt.dll



pushd "%libfileroot%"

md "%libfileroot%\Vista"
md "%libfileroot%\Vista\Advanced"
md "%libfileroot%\Vista\Light"

md "%libfileroot%\WinXP"
md "%libfileroot%\WinXP\Advanced"
md "%libfileroot%\WinXP\Light\"

::生成msvcrt_light.lib for vista
set tagetlibfile=%libfileroot%\Vista\Light\msvcrt_Platform.lib
copy "%libfiletmp%" "%tagetlibfile%" /y
lib "%tagetlibfile%" objs\msvcrt_light.obj

"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%tagetlibfile%" x64 "%~dp0..\msvcrt_light.def" msvcrt.dll msvcrt2.dll
lib "%tagetlibfile%" /remove:msvcrt2.dll

::生成msvcrt_light_xp.lib
set tagetlibfile=%libfileroot%\WinXP\Light\msvcrt_Platform.lib
copy "%libfiletmp%" "%tagetlibfile%" /y
lib "%tagetlibfile%" objs\msvcrt_2003.obj
lib "%tagetlibfile%" objs\msvcrt_light.obj

"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%tagetlibfile%" x64 "%~dp0..\msvcrt_winxp.def" msvcrt.dll msvcrt2.dll
"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%tagetlibfile%" x64 "%~dp0..\msvcrt_light.def" msvcrt.dll msvcrt2.dll
lib "%tagetlibfile%" /remove:msvcrt2.dll

::生成msvcrt_advanced.lib for vista
set tagetlibfile=%libfileroot%\Vista\Advanced\msvcrt_Platform.lib
copy "%libfiletmp%" "%tagetlibfile%" /y
lib "%tagetlibfile%" objs\msvcrt_advanced.obj

"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%tagetlibfile%" x64 "%~dp0..\msvcrt_advanced.def" msvcrt.dll msvcrt2.dll
lib "%tagetlibfile%" /remove:msvcrt2.dll

::生成msvcrt_advanced_xp.lib
set tagetlibfile=%libfileroot%\WinXP\Advanced\msvcrt_Platform.lib
copy "%libfiletmp%" "%tagetlibfile%" /y
lib "%tagetlibfile%" objs\msvcrt_2003.obj
lib "%tagetlibfile%" objs\msvcrt_advanced.obj

"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%tagetlibfile%" x64 "%~dp0..\msvcrt_winxp.def" msvcrt.dll msvcrt2.dll
"D:\用户数据\Documents\Visual Studio 2017\Projects\ltlbuild\Debug\LibMaker.exe" renamelib "%tagetlibfile%" x64 "%~dp0..\msvcrt_advanced.def" msvcrt.dll msvcrt2.dll
lib "%tagetlibfile%" /remove:msvcrt2.dll


lib /def:"%~dp0msvcrt.def" /out:"%~dp0msvcrtdll.lib"

lib "%libfile%" "%~dp0msvcrtdll.lib"
lib "%libfile%" "%~dp0ntdlllite.lib"
::lib "%libfile%" "%~dp0ntdlllite.lib"

::插入LibraryLoadHelper
set INCLUDE=%INCLUDE%;%~dp0..\ucrt\inc;%~dp0..\14.13.26128\vcruntime
cl /O1 /MD /Fo"objs\\gs_support_fix.obj" /c /D "NDEBUG" /D "_NO__LTL_Initialization" /D "__NO_LTL_LIB" /D "_Allow_LTL_Mode" "%~dp0..\LibraryLoadHelper.c"
lib "%libfile%" objs\gs_support_fix.obj
::lib "%libfile%" objs\LibraryLoadHelper.obj

::添加通用转发器
lib "%libfile%" objs\msvcrt_forward.obj

del "%~dp0msvcrtdll.*" /q

popd

pause