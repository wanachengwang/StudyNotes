## Net Analysis Console Tool
    netstat -ano | findstr "52280"    
        0.0.0.0:   本机的所有IP集合
        127.0.0.1：本机loopback地址，无法对外提供服务
    nslookup 163.com
        查看DNS解析记录，如有多个记录，用Ping只能看到一个
    tracert 163.com
        跟踪显示本地到目标站沿途经过的节点

## 命令行参数
    cid: Component ID
    gus: Used to generate UUID as hi-16-bit

## Listen/Connection Relation Table
[详见这里](kbenginePortTbl.md)

## App 概述
-n 代表一个服务器组可以开多个
-1 代表一个服务器组只能开1个
### loginapp -n
+ Connect Point(Domain/Port public to Client),authentication,registration
+ Load balancing with DNS轮询(添加多条A记录，将请求逐个分配给每个A记录)，即意味着loginapp可以放在不同的机器上。
+ Conn：logger/dbmgr/baseappmgr

### logger -1
+ Log collection and backup
+ Conn：loginapp/dbmgr/baseappmgr/cellappmgr/baseapp/cellapp

### dbmgr -1
+ High performance multi-threaded access to data，支持MySQL/MongoDB/Redis，最好是独立的机器运行
+ Conn：logger/loginapp/baseappmgr/cellappmgr/baseapp/cellapp/interfaces(第三方账号接入)以及数据库MySQL

### baseappmgr -1
+ Coordinate all baseapp work, including load balancing processing
+ Conn：logger/loginapp/dbmgr/cellappmgr/baseapp/cellapp

### cellappmgr -1
+ Coordinate all cellapp work, including load balancing processing
+ Conn：logger/dbmgr/baseappmgr/baseapp/cellapp

### baseapp -n
+ client and server communicate only through baseapp(assigned by the loginapp).
+ Scheduled Backup entity to the database, baseapp mutual backup, Disaster Recovery.
+ Baseapp can deploy multi processes on multi machines, Multi processes can auto-load-balancing.
+ Script layer usually choose as implemented in baseapp: Social system, radio chat, games hall, etc.
+ Conn：logger/dbmgr/baseappmgr/cellappmgr/cellapp

### cellapp -n
+ Real-time processing logic game, such as: AOI(def 500M), Navigate, AI, Fighting, etc.
+ Cellapp can deploy multi processes on multi machines, Multi processes can auto-load-balancing.
+ The game logic processing related to space and position.
+ Conn：logger/dbmgr/baseappmgr/cellappmgr/baseapp

### interfaces -1
+ Quick access to third-party billing, third-party accounts, third-party datas.
+ Conn: dbmgr

### machine -1 per machine
+ Abstract a server hardware node(A hardware server can only exist one such process).
+ Receive remote commands, Collect hardware information, Collection components status.
such as: CPU, Memory, cellapp, etc. This information is provided to the component of interest. 
+ Inspect all apps status

### guiconsole
+ A visual GUI console tools, real-time observation of the server running, 
real-time observation of the dynamics of different Space in Entity, 
And supports dynamic debugging server-side Python logic,
See server logs, Startup and Shutdown, etc.

## How to find each other in the same Server Group
+ 组件启动后主动在局域网内广播UDP包，提交自己的身份（所有组件必须在同一局域网内）
+ 反复查找其他组件
+ 组件查找函数

        findComponent(COMPONENT_TYPE componentType, int32 uid, COMPONENT_ID componentID)
+ 组件类别定义

        enum COMPONENT_TYPE {
            UNKNOWN_COMPONENT_TYPE	= 0,
            DBMGR_TYPE				= 1,
            LOGINAPP_TYPE			= 2,
            BASEAPPMGR_TYPE			= 3,
            CELLAPPMGR_TYPE			= 4,
            CELLAPP_TYPE			= 5,
            BASEAPP_TYPE			= 6,
            CLIENT_TYPE				= 7,
            MACHINE_TYPE			= 8,
            CONSOLE_TYPE			= 9,
            LOGGER_TYPE				= 10,
            BOTS_TYPE				= 11,
            WATCHER_TYPE			= 12,
            INTERFACES_TYPE			= 13,
            TOOL_TYPE				= 14,
            COMPONENT_END_TYPE		= 15,
        };
+ uid：在bat中定义的环境变量，可以看作服务器组的ID

        if defined uid (echo UID = %uid%) else set uid=%random%%%32760+1
+ How to start other components in other machines in lan?


## 代码结构
+ XXX: Module Names listed above(interface/logger/bots/kbcmd is srv_tools), and libs(Client).
+ Note: Db(数据库接口)/Network(..) 不在此类，是单独的接口实现。
+ XXX.h
+ XXX_interface.h
    - baseapp_interface.h:      BASEAPP所有消息接口在此定义
    - baseappmgr_interface.h:   BASEAPPMGR所有消息接口在此定义
    - cellapp_interface.h:      cellapp所有消息接口在此定义
    - cellappmgr_interface.h:   cellappmgr所有消息接口在此定义
    - dbmgr_interface.h:        DBMGR所有消息接口在此定义
    - interfaces_interface.h:   Interfaces所有消息接口在此定义
    - logger_interface.h:       Logger所有消息接口在此定义
    - loginapp_interface.h:     LOGINAPP所有消息接口在此定义
    - machine_interface.h:      machine所有消息接口在此定义

    - bots_interface.h:         Bots所有消息接口在此定义
    - kbcmd_interface.h:        KBCMD所有消息接口在此定义 //Python module
    - client_interface.h:       CLIENT所有消息接口在此定义
+ XXX_interface_macros.h
+ XXX_interface.cpp

        #include "XXX_interface.h"
        #define DEFINE_IN_INTERFACE
        #define XXX
        #include "XXX_interface.h"
        namespace KBEngine{
            namespace XXXInterface{
                //----------------------------------------------
            }
        }
+ Macros:
    - interface_defs.h
    - Terminology:
        1. APP: App Name; 
        2. NAME: Method Name; 
        3. NA: Count of args;
    - Sample: APP#_MESSAGE_HANDLER_ARGS#NA(NAME,MSG_LENGTH)
        1. NETWORK_MESSAGE_DECLARE_ARGS#NA(APP, NAME, NAME#APP#Messagehandler#NA, MSG_LENGTH):
        在KBEngine::APP中定义NAME方法，例如

                KBEngine::APP::getSingleton().NAME(Network::Channel* pChannel);
        2. APP_MESSAGE_HANDLER_ARGS#NA(NAME,[ArgType, ArgName]):  定义类NAME#Messagehandler#NA，包含一个handle函数

                class NAME#APP#Messagehandler##NA : public Network::MessageHandler{		
                public:																		
                    virtual void handle(Network::Channel* pChannel,							
                                        KBEngine::MemoryStream& s){
                        KBEngine::APP::getSingleton().NAME(pChannel);                    
                    }	
                };	
        3. MESSAGE_ARGS#NA(NAME, [ArgType, ArgName]): 定义消息体结构

                class NAME##Args1 : public Network::MessageArgs	{
                    ...
                }
## 执行流程 
+ 这里讨论的是非Bot的执行流程，bot是模拟客户端，里面的main/kbeMain/KBENGINE_MAIN与服务端APP不同
+ 每个APP的main.cpp中的 KBENGINE_MAIN宏 包含 main(整个定义在宏内部)和 kbeMain(紧跟在宏后)

        #define KBENGINE_MAIN					\
            kbeMain(int argc, char* argv[]);    \   // 声明kbeMain
            int main(int argc, char* argv[])    \   // 定义main
            {								    \
                loadConfig();					\
                g_componentID = genUUID64();	\   // 命令行参数cid
                parseMainCommandArgs(argc, argv);\
                char dumpname[MAX_BUF] = {0};	\
                kbe_snprintf(dumpname, MAX_BUF, "%"PRAppID, g_componentID);\
                KBEngine::exception::installCrashHandler(1, dumpname);\
                int retcode = -1;				\
                THREAD_TRY_EXECUTION;			\
                retcode = kbeMain(argc, argv);	\
                THREAD_HANDLE_CRASH;			\
                return retcode;					\
            }								    \
            int kbeMain                             // 开始定义kbeMain        
        // 接在KBENGINE_MAIN后面，其实是kbeMain的定义(这里以CellApp举例)：
        ENGINE_COMPONENT_INFO& info = g_kbeSrvConfig.getCellApp();
        int ret = kbeMainT<Cellapp>(argc, argv, CELLAPP_TYPE, -1, -1, "", 0, info.internalInterface);
        return ret; 

+ ENGINE_COMPONENT_INFO& info = g_kbeSrvConfig.getXXXApp()；
+ kbeMainT<XXX>     //kbemain.h
    - setEnv
    - networkInterface  //创建网络接口，消息派发器
    - APP(dispatcher, networkInterface, componentType, g_componentID) //创建APP实例
    - findLogger        //Attach logger
    - START_MSG
    - pApp->initialize();
    -   pApp->run();
    - pApp->finalise();
