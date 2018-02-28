# 搭建KBEngine Unity Demo运行环境

## 本项目作为KBEngine服务端引擎的客户端演示而写

http://www.kbengine.org

## 官方论坛

	http://bbs.kbengine.org


## QQ交流群

	461368412


## Releases

	sources		: https://github.com/kbengine/kbengine_unity3d_demo/releases/latest
	binarys		: https://sourceforge.net/projects/kbengine/files/


## KBE插件文档

	https://github.com/kbengine/kbengine_unity3d_plugins/blob/master/README.md


## 准备:
    1. Python 3.4.3 和 MySQL 5.7
		Python 
			安装好后需要将python目录添加到Path中
    	MySQL 5.7
    		MySQL 5.7 需要 Python3.4.x(KBE对版本无要求), - Development， 并为KBE创建专门的用户/密码
    		命令行运行mysql -ukbe -pkbe -hlocalhost -P3306 测试是否成功(这里假设用户名密码都是kbe)
    		运行MySQL bench，在Option file中修改lower_case_table_names：2 for Windows，0 for Linux

	2. 确保已经下载过KBEngine服务端引擎，如果没有下载请先下载
		下载服务端源码(KBEngine)：
			https://github.com/kbengine/kbengine/releases/latest

		编译(KBEngine)：
			http://www.kbengine.org/docs/build.html

		安装(KBEngine)：
			http://www.kbengine.org/docs/installation.html
    		这里可使用python执行安装脚本,自动配置MySQL连接
    		在MySQL时选yes，127.0.0.1，用户/密码，需要为KBE创建的数据库名
    		
		配置文件
    		服务端默认配置/引擎配置(kbe\res\server\kbengine_defs.xml)
    		服务端配置({assets}/res/server/kbengine.xml)  

		NOTE：
    		KBE/Demo/Plugin的版本必须匹配。这里我们使用ver 1.1.0

	3. 下载kbengine客户端插件与服务端Demo资产库:

	    * 使用git命令行，进入到kbengine_unity3d_demo目录执行：

	        git submodule update --init --remote
![submodule_update1](http://www.kbengine.org/assets/img/screenshots/gitbash_submodule.png)

		* 或者使用 TortoiseGit(选择菜单): TortoiseGit -> Submodule Update:
![submodule_update2](http://www.kbengine.org/assets/img/screenshots/unity3d_plugins_submodule_update.jpg)

                * 也可以手动下载kbengine客户端插件与服务端Demo资产库

		        客户端插件下载：
		            https://github.com/kbengine/kbengine_unity3d_plugins/releases/latest
		            下载后请将其解压缩，插件源码请放置在: Assets/plugins/kbengine/kbengine_unity3d_plugins

		        服务端资产库下载：
		            https://github.com/kbengine/kbengine_demos_assets/releases/latest
		            下载后请将其解压缩,并将目录文件放置于服务端引擎根目录"kbengine/"之下，如下图：

	4. 拷贝服务端资产库"kbengine_demos_assets"到服务端引擎根目录"kbengine/"之下，如下图：
![demo_configure](http://www.kbengine.org/assets/img/screenshots/demo_copy_kbengine.jpg)


## 配置Demo(可选):

	改变登录IP地址与端口（注意：关于服务端端口部分参看http://www.kbengine.org/cn/docs/installation.html）:
![demo_configure](http://www.kbengine.org/assets/img/screenshots/demo_configure.jpg)

		kbengine_unity3d_demo\Scripts\kbe_scripts\clientapp.cs -> ip
		kbengine_unity3d_demo\Scripts\kbe_scripts\clientapp.cs -> port


## 启动服务器:

	确保“kbengine_unity3d_demo\kbengine_demos_assets”已经拷贝到KBEngine根目录：
		参考上方章节：开始

	使用启动脚本启动服务端：
		Windows:
			kbengine\kbengine_demos_assets\start_server.bat

		Linux:
			kbengine\kbengine_demos_assets\start_server.sh

	检查启动状态：
			如果启动成功将会在日志中找到"Components::process(): Found all the components!"。
			任何其他情况请在日志中搜索"ERROR"关键字，根据错误描述尝试解决。
			(更多参考: http://www.kbengine.org/docs/startup_shutdown.html)


## 启动客户端:

	直接在Unity3D编辑器启动或者编译后启动
	（编译客户端：Unity Editor -> File -> Build Settings -> PC, MAC & Linux Standalone.）


## 生成导航网格(可选):
	
	服务端使用Recastnavigation在3D世界寻路，recastnavigation生成的导航网格（Navmeshs）放置于：
		kbengine\kbengine_demos_assets\res\spaces\*

	在Unity3D中使用插件生成导航网格（Navmeshs）:
		https://github.com/kbengine/unity3d_nav_critterai


## 结构与释义：

	KBE插件与U3D和服务器之间的关系：
		插件与服务器：负责处理与服务端之间的网络消息包、账号登陆/登出流程、由服务端通知创建和销毁逻辑实体、维护同步的逻辑实体属性数据等等。
		插件与U3D：插件将某些事件触发给U3D图形层，图形层决定是否需要捕获某些事件获得数据进行渲染表现（例如：创建怪物、某个NPC的移动速度增加、HP变化）、
			U3D图形层将输入事件触发到插件层（例如：玩家移动了、点击了复活按钮UI），插件逻辑脚本层决定是否需要中转到服务器等等。

	Plugins\kbengine\kbengine_unity3d_plugins：
		KBE客户端插件的核心层代码。

	Scripts\kbe_scripts：
		KBE客户端的逻辑脚本（在此实现对应服务端的实体脚本、实体的背包数据结构、技能客户端判断等）。

		Scripts\kbe_scripts\Account.cs：
			对应KBE服务端的账号实体的客户端部分。

		Scripts\kbe_scripts\Avatar.cs：
			对应KBE服务端的账游戏中玩家实体的客户端部分。

		Scripts\kbe_scripts\Monster.cs：
			对应KBE服务端的怪物实体的客户端部分。

		Scripts\kbe_scripts\clientapp.cs：
			在KBE的体系中抽象出一个客户端APP，其中包含KBE客户端插件的初始化和销毁等等。

		Scripts\kbe_scripts\interfaces：
			对应KBE中entity_defs\interfaces中所声明的模块。

	Scripts\u3d_scripts：
		Unity3D图形层（包括场景渲染、UI、物体部件、人物模型、怪物模型、一切关于显示的东西等等）。

		Scripts\u3d_scripts\GameEntity.cs：
			无论是怪物还是玩家都由此脚本负责模型动画等表现部分。

		Scripts\u3d_scripts\World.cs:
			管理游戏中大地图或副本的渲染层脚本，例如：负责将具体的3D怪物创建到场景中。

		Scripts\u3d_scripts\UI.cs:
			维护游戏的UI处理脚本。

	Scenes\start.unity:
		起始场景，由此启动进入游戏。

	Scenes\_scenes\login.unity:
		登陆场景。

	Scenes\_scenes\selavatars.unity:
		角色选取场景。

	Scenes\_scenes\world.unity:
		游戏中大地图/副本场景。

## 演示截图:

![screenshots1](http://www.kbengine.org/assets/img/screenshots/unity3d_demo9.jpg)
![screenshots2](http://www.kbengine.org/assets/img/screenshots/unity3d_demo10.jpg)
![screenshots3](http://www.kbengine.org/assets/img/screenshots/unity3d_demo11.jpg)

