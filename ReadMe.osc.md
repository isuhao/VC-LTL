﻿# VC-LTL——编译精巧的程序原来如此简单

- [English](ReadMe.md)

## 1. 关于VC-LTL

VC-LTL是一个基于微软VC修改的开源运行时，有效减少应用程序体积并摆脱微软运行时DLL，比如msvcr120.dll、api-ms-win-crt-time-l1-1-0.dll等依赖。

VC-LTL最初是Dism++专用运行时。2017年3月6号从Dism++源代码中分离，并正式对外开源，为社区贡献自己的微薄之力。

在大型项目中往往有众多模块，如果都采用静态编译那么造成的空间浪费先不说，最后也会因为`Fls上限`导致程序无法正常运行。

而VC-LTL能让你的项目如同系统文件一样共享系统内置`msvcrt.dll`，有效的解决`Fls上限`以及`运行时部署问题`，同时`大大缩减程序体积`，可以说一箭三雕！

所有人都可以无条件、免费使用，包括用于商业环境。当然如果大家在自己的程序说明文件中声明使用了VC-LTL那就更好了。

* GitHub：[github.com/Chuyu-Team/VC-LTL（英文）](https://github.com/Chuyu-Team/VC-LTL)    
* 码云：[gitee.com/Chuyu-Team/VC-LTL（中文）](https://gitee.com/Chuyu-Team/VC-LTL)    
* 网盘：[现成使用VC-LTL编译的库，比如QT等](https://pan.baidu.com/s/1thlI5X8P5YwC-3rbO60hOw#list/path=%2F使用VC-LTL编译的库)    
* QQ群：[633710173](https://shang.qq.com/wpa/qunwpa?idkey=21d51d8ad1d77b99ea9544b399e080ec347ca6a1bc04267fb59cebf22644a42a)

### 1.1. 原理
使用VC-LTL后可以将程序动态链接到系统自带的msvcrt.dll中，来减少程序体积。目前使用CRT以及STL的工程一般都可以使用。但是MFC工程不能使用，因为MFC类库太复杂了，尚未适配。

> 使用VC-LTL，C++程序体积大约缩减30%，而纯C程序则大约缩减50%。

### 1.2. 亮点
* 晚起的鸟儿也有虫虫吃，优雅的引用方式，仅添加一个属性表就能享受极致的体积体验。
* 无缝使用最新C/C++库以及最新编译器，尽情的使用最新规范。神马异常流防护（guard:cf）、静态对象线程安全初始化（threadSafeInit）……统统放马过来吧！！
* 拥有比微软原版更好的兼容性，即使想兼容Windows XP RTM也可以安心的对新编译器说“Yes”。
* 完全的开放代码，广泛的接受用户意见，希望大家能踊跃的 pull requests，为VC-LTL添砖加瓦。

> 让我们一起跟VS 2008说拜拜！

## 2. VC-LTL兼容性
此表展示了VC-LTL，C/C++库函数覆盖率，通过覆盖情况，可以大致了解VC-LTL的完善程度。

|  模块  | XP模式              | Vista模式 | UCRT模式 | 相关文件 
|  ----  | --------            | --------- | -------- | --------
|   CRT  | 88.845%             | 91.911%   |   100%   | ltl.lib，msvcrt.lib，msvcrt_Platform.lib，ucrt.lib，vc.lib
|   STL  | 100.1%（超标准支持）| 100%      |   100%   | ltlcprt.lib，ltlcprtxp.lib
| ConcRT | 100%                | 100%      |   100%   | libconcrt.lib，libconcrtxp.lib
|   ATL  | 100%                | 100%      |   100%   | -
|   MFC  | 不支持              | 不支持    |    ?     | -
|   AMP  |   -                 |   -       |    -     | -
| OpenMP |   -                 |   -       |    -     | -

### 2.1. 支持的IDE
* Visual Studio 2015（包含Clang with Microsoft CodeGen、Clang 3.7 with Microsoft CodeGen、Clang-LLVM）
* Visual Studio 2017（包含Clang with Microsoft CodeGen）

### 2.2. 支持的编译工具
|    编译工具    | 支持文件
| -------------- | --
| Visual Studio  | [VC-LTL helper for Visual Studio.props](#32-在visual-studio中使用vc-ltl)
| CMake          | [VC-LTL helper for cmake.cmake](#33-在cmake中使用vc-ltl)
| NMake、CL      | [VC-LTL helper for nmake.cmd](#34-在nmake纯cl中使用vc-ltl)

### 2.3. 支持的操作系统
|   操作系统                                          | x86 | x64 | arm | arm64 
|    ----                                             | --- | --- | --- | ----
| Windows XP、Windows Server 2003                     | √  | √  | -   | -
| Windows Vista、Windows Server 2008                  | √  | √  | -   | -
| Windows 7、Windows Server 2008 R2                   | √  | √  | -   | -
| Windows 8、Windows Server 2012、Windows RT          | √  | √  | √（需要安装[KB2999226](http://support.microsoft.com/kb/2999226)）  | -
| Windows 8.1、Windows Server 2012 R2、Windows RT 8.1 | √  | √  | √（需要安装[KB2999226](http://support.microsoft.com/kb/2999226)）  | -
| Windows 10、Windows Server 2016                     | √  | √  | √ | √

> 采用VC-LTL编译后的程序能兼容Windows XP RTM以上所有操作系统，无需安装任何SP补丁包。

## 3. 使用方法

### 3.1. 安装VC-LTL
假如，你将[VC-LTL Binary](https://gitee.com/Chuyu-Team/VC-LTL/releases)下载并解压至`D:\Src\VC-LTL`（具体位置无任何要求），双击`D:\Src\VC-LTL\Install.cmd`即可。

> 脚本会在`HKCU\Code\VC-LTL`创建注册表。

### 3.2. 在Visual Studio中使用VC-LTL

#### 3.2.1. 添加VC-LTL属性表
将属性表`VC-LTL helper for Visual Studio.props`复制到你的工程目录，你可以打开属性管理器（视图 - 属性管理器），然后Release配置上右键`添加现有属性表`，然后选择`VC-LTL helper for Visual Studio.props`即可。

![AddShared](https://raw.githubusercontent.com/wiki/Chuyu-Team/VC-LTL/zh-Hans/image/AddShared.png)

#### 3.2.2. 配置工程属性
* C/C++ - 代码生成 -【运行库】调整为【多线程 DLL (/MD)】

![ConfigurationProject](https://raw.githubusercontent.com/wiki/Chuyu-Team/VC-LTL/zh-Hans/image/ConfigurationProject.png)

> 如需支持XP，请在平台工具集中选择`Windows XP`或者修改`VC-LTL helper for Visual Studio.props`启用 `<SupportWinXP>true</SupportWinXP>` 即可。

### 3.3. 在CMake中使用VC-LTL

#### 3.3.1. 添加VC-LTL配置文件

将模块文件`VC-LTL helper for cmake.cmake`复制到你的工程目录（顶层CMakeLists.txt同级目录）。然后在`CMakeLists.txt`中添加一行 `include("VC-LTL helper for cmake.cmake")` 即可。

**示例：**
```
cmake_minimum_required(VERSION 3.5.2)
project(ltltest)

include("VC-LTL helper for cmake.cmake")

add_subdirectory(src)
```

#### 3.3.2. 调整配置工程

> 务必确保使用`/MD`编译代码。如需支持XP，请修改`VC-LTL helper for cmake.cmake`启用 `set(SupportWinXP "true")` 即可。

### 3.4. 在NMake/纯CL中使用VC-LTL

#### 3.4.1. 运行VC-LTL辅助脚本

将辅助脚本`VC-LTL helper for nmake.cmd`复制到你的工程目录。启动`vcvars32.bat/vcvars64.bat`执行此脚本即可，脚本将自动修改`include`以及`lib`环境变量。

**示例：**
```
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
call "D:\VC-LTL\VC-LTL helper for nmake.cmd"

nmake /f Test.mak
```
#### 3.4.2. 配置工程属性

> 务必确保使用`/MD`编译代码。如需支持XP，请修改`VC-LTL helper for nmake.cmd`启用 `set SupportWinXP=true`，并且需要自行调整连接器最低系统支持为`5.01`（WinXP x86）或者`5.02`（WinXP x64）。


### 3.5. 重新编译（仅Release）
现在是不是体积就小了很多。如果你编译不通过，可以先参考 [4. 常见问题](#4-常见问题)。如果还是不通过可以反馈，共同改进VC-LTL。

如果正确引用VC-LTL，那么 会在生成时输出：`note: 进入ltl普通模式，已准备引用到VC-LTL。定义 _DISABLE_DEPRECATE_LTL_MESSAGE 可关闭信息提示。`。

> 使用VC-LTL编译时必须采用`/MD`编译，并且所有依赖的静态库也必须使用VC-LTL重新编译。

![AppBuildByVC-LTL](https://raw.githubusercontent.com/wiki/Chuyu-Team/VC-LTL/image/AppWithLTL.png)


## 4. 常见问题
### 4.1. 未共享到msvcrt.dll
#### 问题原因
未正确引用VC-LTL。建议看看生成日志，是否包含：`note: 进入ltl普通模式，已准备引用到VC-LTL。定义 _DISABLE_DEPRECATE_LTL_MESSAGE 可关闭信息提示。`。

#### 解决方案
1：请务必确保 `VC-LTL helper for Visual Studio.props` 已经添加到工程。

2：确保以下设置正确：
* VC++ 目录 - 包含目录 - 【√ 从父项或项目默认设置继承(I)】
* VC++ 目录 - 库目录 - 【√ 从父项或项目默认设置继承(I)】

### 4.2. 无法解析外部符号 delete 等
#### 问题原因

没有正确引入vc.lib、msvcrt_Platform.lib。

#### 解决方案
* VC++ 目录 - 包含目录 - 【√ 从父项或项目默认设置继承(I)】
* VC++ 目录 - 库目录 - 【√ 从父项或项目默认设置继承(I)】

### 4.3. 检测到RuntimeLibrary的不匹配项
#### 问题原因

引入了没有使用VC-LTL编译的静态lib文件。

#### 解决方案

使用VC-LTL重新编译对应的静态lib（具体lib名称错误日志会给出）。

### 4.4. 支持XP时从msvcrt.dll导入大量XP不支持的函数
#### 问题原因

可能没有开启引用消除

#### 解决方案
* C/C++ - 语言 - 移除未引用的代码和数据 - 【是(/Zc:inline)】
* 连接器 - 优化 - 引用 - 【是(/OPT:REF)】


## 5. 已知问题
* 由于WinXP本身Bug，printf相关函数输入缓冲区最大字符数为0x3FFFFFFF（包含）。当你需要兼容XP时，请务必确认缓冲区输入长度小于0x3FFFFFFF，或者直接使用 _CRT_STDIO_SIZE_MAX 宏。_s 版本不存在此问题。
* 由于WinXP本身Bug，printf相关函数无法正常支持`%ll`。当你需要兼容XP时，请优先考虑使用`%I64`代替。_s 版本也存在此问题。
* 由于msvcrt本身限制，setlocale/_create_locale相关函数不支持UCRT的locale name，使用时必须按VC 2008规范使用，比如 `setlocale(0, ".936");` 这样调用，而不是传入 `setlocale(0, "zh-CN");`。

## 附：已知使用VC-LTL的官方项目

|  项目                                                        | 备注
|  ---                                                         | ----
| [NSudo](https://github.com/M2Team/NSudo)                     | 一个强大的系统管理工具。VC-LTL的帮助下减少30%的程序体积，包括NSudo for arm64。
| [Menu98](https://github.com/rikka0w0/Menu98)                 | 经典样式可自定义的开始按钮右键菜单。使用VC-LTL移除运行时依赖。
| [壁虎浏览器](http://bhbrowser.com/)                          | 一款专业解决DNS劫持的浏览器。使用VC-LTL有效减少程序体积，减少安装包大小。
| [librech551](https://github.com/rgwan/librech551)            | 开源跨平台的CH55x ISP软件。使用VC-LTL移除运行时依赖。
| [Dism++](https://www.chuyu.me/)                              | Dism GUI版。初雨团队自身项目，使用VC-LTL有效减少程序体积，减少安装包大小。
| [360安全卫士](https://www.360.cn/)                           | 奇虎360推出的上网安全软件。360EvtMgr.exe、360leakfixer.exe、360Util.dll、leakrepair.dll等文件使用VC-LTL编译，在VC-LTL的支持下：升级新编译器，减少文件尺寸，完美兼容WinXP，一箭三雕。

## 更新日志

### 3.1.0.1 - 添加Clang支持（2018-06-18 13:13）
* 新增[Fea 34](https://github.com/Chuyu-Team/VC-LTL/issues/34)，添加Clang with Microsoft CodeGen、Clang 3.7 with Microsoft CodeGen、Clang-LLVM工具集支持（感谢 hzqst）。
* 解决Bug，非中文代码页corecrt.h报告 C4828警告（感谢 临渊羡鱼乎）。
* 解决[Bug 35](https://github.com/Chuyu-Team/VC-LTL/issues/35)，调用vsnprintf时触发警告C4389: “==”: 有符号/无符号不匹配（感谢  zhaooptimus）
* 解决Bug，减少amd64程序调用_hypotf函数时的二进制体积。
* 解决Bug，解决VS15.7 special_math无法使用问题


### 3.0.0.3 - 儿童节专版（2018-05-31 17:07）
* 解决[Bug 32](https://github.com/Chuyu-Team/VC-LTL/issues/32)，链接时找不到符号`__p__fmode`（感谢 augustheart）。
* 更新许可。


### 3.0.0.2 - 添加Vistual Studio 2017 15.7支持（2018-05-18 21:07）
* 新增Fea，添加VC 14.0.24234以及14.14.26428支持。
* 新增Fea，添加UCRT 10.0.17134.0支持。
* 新增Fea，添加Spectre缓解库支持。
* 解决Bug，找不到gets符号问题（感谢 npc）。

> VC-LTL本次从仓库中剔除了lib文件，VC-LTL用户请下载[VC-LTL Binary](https://gitee.com/Chuyu-Team/VC-LTL/releases)，然后再使用VC-LTL编译代码。


### 3.0.0.1 - 改进平台支持（2018-04-26 18:48）
* 解决[Bug 27](https://github.com/Chuyu-Team/VC-LTL/issues/27)，非中文环境调用_set_abort_behavior输出警告问题（感谢 myfreeer）。
* 解决[Bug 21](https://github.com/Chuyu-Team/VC-LTL/issues/21)，特定情况nothrow符号冲突问题（感谢 waiting4love）。
* 解决Bug，解决x64系统无法使用`__p__*`系列函数问题（感谢 昌平）。
* 改进体验，当RC中意外引入_msvcrt.h时 自动跳过处理，避免RC报错（感谢 风清凉）。
* 改进体验，“Shared.props”改名为“VC-LTL helper for Visual Studio.props”并大幅度增强对某些极端工程的支持。
* 新增[Fea 25](https://github.com/Chuyu-Team/VC-LTL/issues/25)，添加“VC-LTL helper for nmake.cmd”，方便nmake引入VC-LTL。
* 新增Fea，添加“VC-LTL helper for cmake.cmake”，方便cmake引入VC-LTL（感谢 Sandro）。
* 新增Fea，全面支持ARM、ARM64支持。


### 2.0.0.8 - 累计BUG修复以及适配新版本（2018-03-23 14:58）
* 解决一些潜在找不到符号问题以及链接失败问题（感谢 Too Simple）。
* 修正__crtLCMapString相关字符串操作兼容性问题（感谢 Too Simple）。
* 解决_getptd_noexit在获取msvcrt.dl的DllMain中创建的 ptd结构时会返回失败问题（感谢 亮亮）。
* 添加最新Vistual Studio 2017 15.6支持。


### 2.0.0.7 - 重新规范VC-LTL（2018-03-06 17:17）
* 重新整理VC-LTL，尽可能减少对原版改动。
* 解决一些Bug（感谢 亮亮、layerfsd、waiting4love）。


### 2.0.0.6 - 2018新春贺岁版（2018-01-17 17:15）
* 添加Vistual Studio 2017 15.5新增函数支持。
* 新增Shared.props改进属性表引用灵活性。
* 新增VC-LTL轻量模式以及高级模式支持（修改Shared.props可以调整模式）。
* 继续扩充CRT函数支持。


### 2.0.0.5 - 增强C++ 17支持（2017-12-10 20:56）
* 新增C++ 17 align new/delete支持。
* 解决兼容WinXP时可能出现的ntdll.lib依赖失败以及某些函数转发切换到weak别名技术。

> 本次更新主要添加对Vistual Studio 2017 15.5以及更高版本新增的C++ 17功能支持。


### 2.0.0.4 - 全面覆盖STL、ConcRT（2017-12-03 20:40）
* 全面覆盖STL、ConcRT库，让C++如鱼得水，尽情使用STL。
* 全新的weak别名转发技术，实现零jmp解决新老CRT命名冲突。


### 2.0.0.3 - 补充大量XP静态实现（2017-11-18 14:18）
* Vista编译模式，CRT函数覆盖率达到90%以上。
* XP编译模式，CRT函数覆盖率达到80%以上。
* 简化注册表引用方式。
* 添加std::thread支持。


### 2.0.0.2 - 扩充对C++类库的支持（2017-11-05 14:14）
* 新增 _configthreadlocale、_get_current_locale、_create_locale、_free_locale接口支持。
* 为Windows XP添加 _time32、_fseeki64静态实现。
* 解决[Bug 14](https://github.com/Chuyu-Team/VC-LTL/issues/14)，新增 _getpid、_sys_nerr、_sys_errlist无法使用问题（感谢 HwangBae）。
* 新增C++类，mutex、thread、xtime、xonce支持。
* 优化编译方式，消除无意义符号，减少ltl库体积。


### 2.0.0.1 - 新增C++类库支持（2017-10-29 22:23）
* 新增iostream、stringstream支持。
* 解决使用_fstat32、_fstat32i64、_fstat64i32、_stat32、_stat32i64、_stat64i32、_wstat32、_wstat32i64、_wstat64i32导致编译不通过问题。
* 修正`__acrt_iob_func`始终返回输入流问题。
* 解决 type_info operator != 功能无法使用问题（感谢 sonyps5201314）。
* 解决_daylight，_dstbias，_timezone，_tzname无法使用问题（感谢 sonyps5201314）。
* 解决32位 SSE高精度数据函数无法使用问题，比如_libm_sse2_tan_precise，_libm_sse2_sqrt_precise，_libm_sse2_sin_precise（感谢 stsm85）。


### 1.0.0.13 - 新增 Windows 10 16299 UCRT支持（2017-10-11 14:00）
* 解决Bug，atanh、acosh、asinh无法使用问题（感谢 stsm85）。
* 新增Windows 10 16299 UCRT支持。
* 移除Windows 10 14393 UCRT支持。

> 16299已经发布，因此移除老版本14393支持。相关项目请迁徙到15063或者最新16299。

### 1.0.0.12 - 解决某些函数无法使用问题（2017-09-15 13:33）
* 解决Bug，使用strcat_s时在Windows XP中提示找不到指定符号（感谢 stsm85）。
* 解决Bug，解决SSE2除法导致编译不通过问题（感谢 stsm85）。
* 解决Bug，解决wcstoll、vsnprintf、rand_s、strtoll无法使用问题（感谢 stsm85）。
* 代码调整，消除所有VC-LTL编译警告，强迫症患者福音。

> 本次更新后，FastCopy、winpck相关程序直接可以使用VC-LTL编译。


### 1.0.0.11 - 解决lib依赖问题（2017-08-23 19:00）
* 解决Bug，使用_difftime64时Windows XP无法运行。
* 解决Bug，_msvcrt.cpp始终会引入urct_14393.lib问题（感谢 亮叔叔）。
* 更新VC141头文件以及实现，全部同步到最新14.11。


### 1.0.0.10 - 改进对Windows XP的支持（2017-07-28 20:28）
* 解决[Bug 9](https://github.com/Chuyu-Team/VC-LTL/issues/9)，某些时候编译器引用异常导致XP模式时意外引入_except_handler4_common（感谢 HwangBae）。
* 解决[Bug 8](https://github.com/Chuyu-Team/VC-LTL/issues/8)，修复typeid功能无法使用问题（感谢 HwangBae）。
* 调整异常实现代码，尽可能复用msvcrt.dll代码减少代码体积。
* 解决Bug，修复无法使用`__argc`、`__argv`、`__wargv`、`_environ`、`_wenviron`全局变量问题（感谢 亮叔叔）。
* 解决微软Bug，修复使用ATL库的程序不支持XP RTM问题。


### 1.0.0.9 - 添加C++异常支持（2017-05-26 14:46）
* 改进Windows XP支持。
* 优化库结构裁剪ltl库体积。
* 解决使用自定义异常导致程序编译不通过问题。
* 调整`*_p`系列函数定义，以免使用`*_p`系列函数时编译不通过。
* 解决使用浮点除法时导致编译不通过问题。


### 1.0.0.8 - 简化VC-LTL使用（2017-04-25 20:37）
* 简化库引用方式。
* 更新14393 ucrt到最新版（2017-01-05版）。
* 添加15063 ucrt支持。


### 1.0.0.7 - 初步添加Windows XP支持（2017-04-22 19:26）
* 初步添加Windows XP支持。
* 添加C++异常支持。
* 添加/GS特性支持。
* 添加/guard:cf支持。
* VC140库升级到Vistual Studio 2015 Update3。


### 1.0.0.6 - 优化引用方式（2017-03-18 13:46）
* 优化文件引用。


### 1.0.0.5 - 新增Visual Studio 2017支持（2017-03-16 20:53）
* 新增VC 2017支持。


### 1.0.0.4 - 公众第一版（2017-03-06 16:15）
* 与Dism++彻底分离，方便以后与Dism++共享代码。


### 1.0.0.3 2016-11-28 12:54
* 改进对C工程的兼容性。


### 1.0.0.2 2016-06-14 12:52
* 解决C编译不通过问题。


### 1.0.0.1 2016-05-23 13:42
* 解决C++异常无法使用问题。