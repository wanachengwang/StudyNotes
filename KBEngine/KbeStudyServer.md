## Framework
![KBEngine Framework](files/kbefrm.png)

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

## DataBase_Tables
```c entity_table.h
#define KBE_TABLE_PERFIX					"kbe"
#define ENTITY_TABLE_PERFIX					"tbl"
#define TABLE_ID_CONST_STR					"id"
#define TABLE_PARENTID_CONST_STR			"parentID"
#define TABLE_ITEM_PERFIX					"sm"
#define TABLE_ARRAY_ITEM_VALUE_CONST_STR	"value"
#define TABLE_ARRAY_ITEM_VALUES_CONST_STR	"values"
#define TABLE_AUTOLOAD_CONST_STR			"autoLoad"
```
1. 每种Entity会对应一个tbl_[entity]的表
2. def文件中每个Persistent为true的属性对应一个sm_[property]的table item
3. 附加一个名为sm_autoLoad的table item
4. def文件中

## App脚本 kbemain.py
1. 每个App的Python脚本在kbengine_defs.xml中指定，例:
```xml
<baseapp>
    <!-- 脚本入口模块， 相当于main函数 (Entry module, like the main-function) -->
    <entryScriptFile> kbemain </entryScriptFile>
    ...
</baseapp>
```
2. 在服务器代码调用：
```
if (getEntryScript().get() && PyObject_HasAttrString(getEntryScript().get(), "onReadyForShutDown") > 0) {
    // 所有脚本都加载完毕
    PyObject* pyResult = PyObject_CallMethod(getEntryScript().get(),
        const_cast<char*>("onReadyForShutDown"),
        const_cast<char*>(""));
    ...
}
```

## Entity脚本/定义
官方文档[点此](http://kbengine.org/cn/docs/programming/entitydef.html)
### Account Entity

在服务器代码中会读取到 dbcfg.dbAccountEntityScriptType,然后通过如下代码创建Entity
```cs baseapp.cpp
Proxy* base = static_cast<Proxy*>(createEntity(g_serverConfig.getDBMgr().dbAccountEntityScriptType,
		NULL, false, entityID));
```

### Entity创建
1. 在Python脚本中：
```python
KBEngine.createBaseLocally('Avatar', props)
... or ...
KBEngine.createBaseFromDBID("Avatar", dbid, self.__onAvatarCreated)
... or ...
self.createCellEntity(space)  # create cell entity
```
2. 在服务器代码中：
```c
APPEND_SCRIPT_MODULE_METHOD(getScript().getModule(), createBaseLocally, __py_createBase,METH_VARARGS, 0);
APPEND_SCRIPT_MODULE_METHOD(getScript().getModule(), createBaseFromDBID, __py_createBaseFromDBID, 0);
... or ...
SCRIPT_METHOD_DECLARE("createCellEntity", createCellEntity,	METH_VARARGS, 0) //base.cpp
...
PyObject* Baseapp::__py_createBase(PyObject* self, PyObject* args){
    char* entityType = ...;   // Parse args to get entityType
    PyObject* e = Baseapp::getSingleton().createEntity(entityType, params);
	if(e != NULL) Py_INCREF(e);
	return e;
}
PyObject* Baseapp::__py_createBaseFromDBID(PyObject* self, PyObject* args){
    ...
}
... or ...
/** 为一个baseEntity在指定的cell上创建一个cellEntity,定义static method __py_createCellEntity */
DECLARE_PY_MOTHOD_ARG1(createCellEntity, PyObject_ptr);  //base.h
```
3. 在客户端(如果hasClient为true):
BaseApp调用createClientProxies,向客户端发送Client_onCreatedProxies消息,消息参数包含Entity名字
Client_onCreatedProxies根据消息中的Entity名字在Entity类映射表中找到Entity类,创建实例

## 脚本的调用流程
1. baseapp.cpp创建Account entity
    + 账号Entity的名称在kbengine_defs.xml中指定，例:
    ```xml
    <dbmgr><account_system>
        <accountEntityScriptType> Account </accountEntityScriptType>  ...
    </account_system></dbmgr>
    ```
    + baseapp.cpp:onQueryAccountCBFromDbmgr中创建Account
    ```cs 
    Proxy* base = static_cast<Proxy*>(createEntity(g_serverConfig.getDBMgr().dbAccountEntityScriptType,
            NULL, false, entityID));
    ```
2. Account.py中创建Avatar:
    + 新建：kbengine.createBaseLocally('Avatar', props), 然后 Avatar.WriteToDB
    + 从DB加载: kbengine.createBaseFromDBID('Avatar', dbid, onAvatarCreated)
3. baseapp的kbengine.py中创建spaces(多个space的管理器):
    + KBEngine.createBaseLocally( "Spaces", {} )
4. spaces.py中根据场景表(data\d_spaces.py)创建多个space
    |id|type|entityType|resPath|spawnPos|name|
    |-|-|-|-|-|-|-
    |1|1|Space         |spaces/xinshoucun              |(771.5861, 211.0021, 776.5501)|新手村
    |2|1|Space         |spaces/kbengine_ogre_demo      |(-97.9299, 0.0, -158.922)     |kbengine_ogre_demo      
    |3|1|Space         |spaces/kbengine_unity3d_demo   |(-97.9299, 1.5, -158.922)     |kbengine_unity3d_demo   
    |4|1|Space         |spaces/teleportspace           |(0.0, 1.5, 0.0)               |teleportspace  
    |5|2|SpaceDuplicate|spaces/duplicate               |(0.0, 0.0, 0.0)               |Duplicate(副本)
    |6|1|Space         |spaces/kbengine_cocos2d_js_demo|(108.0, 0.0, 90.0)            |kbengine_cocos2d_js_demo
    |7|1|Space         |spaces/kbengine_ue4_demo       |(-97.9299, 1.5, -158.922)     |kbengine_ue4_demo       
    + 根据以上数据创建spaceAlloc,createSpaceOnTimer中调用SpaceAlloc.Init创建Space Entity:
    KBEngine.createBaseAnywhere(spaceData["entityType"],{"spaceUType" : self._utype,
                                                         "spaceKey" : spaceKey,
                                                         "context" : context,},
                                Functor.Functor(self.onSpaceCreatedCB, spaceKey))
    + 创建了六种Space Entity, TODO:SpaceDuplicate
5. space.py的onTime创建SpawnPoint(这里只有xinshoucun)：
    + 从d_spaces_spawn.py中读取当前spaceType对应的SpawnPoint数据(d_spaces_spawns.py,xinshoucun数据定义在xml中)
    + 添加data\spawnpoints\[ResPath]_spawnpoints.xml(这里只有xinshoucun)中定义的SpawnPoint数据
    + KBEngine.createBaseAnywhere("SpawnPoint",{"spawnEntityNO" : datas[0],
                                                "position" : datas[1], 
                                                "direction" : datas[2], 
                                                "modelScale" : datas[3],
                                                "createToCell" : self.cell})
6. SpawnPoint.py创建cellapp的Entity:
    + self.createCellEntity(self.createToCell)
7. 在SpawnPoint上创建Entities
    + KBEngine.createEntity(datas["entityType"], self.spaceID, tuple(self.position), tuple(self.direction), params)
    + Entities定义(d_entities.py)如下:

    |id|runSpeed|moveSpeed|dialogID|modelID|etype|entityType|name|
    |-|-|-|-|-|-|-|-|
    |80008001|60|30|0       |80008001|1|Monster|怪物8
    |2001    |65|50|0       |2001    |1|Monster|怪物1
    |1003    |65|50|0       |1003    |1|Monster|怪物1
    |10003001|65|50|0       |10001001|1|Monster|怪物1
    |80004001|60|30|0       |80004001|1|Monster|怪物4
    |80005001|60|30|0       |80005001|1|Monster|怪物5
    |80013001|60|30|0       |80013001|1|Monster|怪物13
    |80009001|60|30|0       |80009001|1|Monster|怪物9
    |80011001|60|30|0       |80011001|1|Monster|怪物11
    |80002001|60|30|0       |80002001|1|Monster|怪物2
    |2002    |65|50|0       |2002    |1|Monster|怪物2
    |80001001|60|30|0       |80001001|1|Monster|怪物1
    |20003001|65|50|0       |20001001|1|Monster|怪物3
    |80007001|60|30|0       |80007001|1|Monster|怪物7
    |20001001|65|50|0       |20001001|1|Monster|艾克斯球
    |80010001|60|30|0       |80010001|1|Monster|怪物10
    |10004001|65|50|0       |10004001|1|Monster|怪物2
    |20002001|65|50|0       |20002001|1|Monster|压力山大巨龙
    |10001001|65|50|10001001|10001001|1|NPC    |新手接待员
    |40001002|0 |0 |0       |40001001|1|Gate   |传送门(teleport-back)
    |40001003|0 |0 |0       |40001001|1|Gate   |传送门(teleport-local)
    |1004    |65|50|0       |1004    |1|Monster|怪物2
    |80006001|60|30|0       |80006001|1|Monster|怪物6
    |1001    |65|50|10001001|1001    |1|NPC    |新手接待员
    |10002001|65|50|10001001|10001001|1|NPC    |传送员
    |40001001|0 |0 |0       |40001001|1|Gate   |传送门
    |80014001|60|30|0       |80014001|1|Monster|怪物14
    |80003001|60|30|0       |80003001|1|Monster|怪物3
    |80012001|60|30|0       |80012001|1|Monster|怪物12
    |1002    |65|50|10001001|1002    |1|NPC    |传送员
    |2003    |65|50|0       |2003    |1|Monster|怪物3
