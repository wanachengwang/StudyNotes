## Server资产库目录结构
\<assets>
+ scripts
    + entities.xml          // 列出所有的entity
    + entity_defs       
        - \<entity>.def     // entity定义文件，定义entity属性和方法
    + base                  // BaseApp脚本(*.py)
    + bots                  // 机器人压力测试脚本，简化模拟客户端(登录/AI),bots需要实现ClientMethod
    + cell                  // CellApp脚本
    + client                // ?Client脚本(使用Unity插件,经测试不会被调用此内脚本)
    + common                // 公用脚本(Cell/Base/Client共用的实现函数)
    + data                  // 服务端逻辑数据文件，比如策划导表数据
    + db                    // 数据库扩展
    + interface
    + logger
    + login
    + server_common         // 公用脚本(Cell/Base共用的实现函数)
    + user_type             // 自定义类型脚本
+ res
    + server
        - kbengine.xml      // 服务端配置文件
    + spaces                // 空间的资源数据，比如碰撞信息，寻路数据

## 定义Entity
http://kbengine.org/cn/docs/programming/entitydef.html

## 脚本的调用流程
？？？？