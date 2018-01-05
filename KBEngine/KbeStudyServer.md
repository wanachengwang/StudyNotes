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

## App脚本
每个App的Python脚本在kbengine_defs.xml中指定，例:
```xml
<baseapp>
    <!-- 脚本入口模块， 相当于main函数 (Entry module, like the main-function) -->
    <entryScriptFile> kbemain </entryScriptFile>
    ...
</baseapp>
```
在服务器代码调用：
```
if (getEntryScript().get() && PyObject_HasAttrString(getEntryScript().get(), "onReadyForShutDown") > 0) {
    // 所有脚本都加载完毕
    PyObject* pyResult = PyObject_CallMethod(getEntryScript().get(),
        const_cast<char*>("onReadyForShutDown"),
        const_cast<char*>(""));
    ...
}
```

## 定义Entity
官方文档[点此](http://kbengine.org/cn/docs/programming/entitydef.html)
### Account Entity
账号Entity的名称在kbengine_defs.xml中指定，例:
```xml
<dbmgr>
    <account_system>
        <!-- 账号Entity的名称 (Name of AccountEntity) -->
        <accountEntityScriptType>	Account	</accountEntityScriptType>
        ...
    </account_system>
</dbmgr>
```
在服务器代码中会读取到 dbcfg.dbAccountEntityScriptType

### Entity创建
在Python脚本中：
```python
KBEngine.createBaseLocally('Avatar', props)
... or ...
KBEngine.createBaseFromDBID("Avatar", dbid, self.__onAvatarCreated)
```
在服务器代码中：
```c
APPEND_SCRIPT_MODULE_METHOD(getScript().getModule(), createBaseLocally, __py_createBase,METH_VARARGS, 0);
APPEND_SCRIPT_MODULE_METHOD(getScript().getModule(), createBaseFromDBID, __py_createBaseFromDBID, 0);
...
PyObject* Baseapp::__py_createBase(PyObject* self, PyObject* args){
    char* entityType = ...;// Parse args to get entityType
    PyObject* e = Baseapp::getSingleton().createEntity(entityType, params);
	if(e != NULL) Py_INCREF(e);
	return e;
}
PyObject* Baseapp::__py_createBaseFromDBID(PyObject* self, PyObject* args){
    ...
}
```

## 脚本的调用流程
？？？？