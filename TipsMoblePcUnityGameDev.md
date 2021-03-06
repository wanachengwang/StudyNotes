# Some Notes About Multiplateform Game

## 手机游戏性能规范---2015年uwa 给出了一组数据(同屏)：

- DrawCall 250
    - Batching
        - 一个Batch是 改变GPU状态(mesh, shader, tex, blendSettings and other shader properties) + 一个或更多Draw指令
        - 故Batching需要相同材质，不支持skinned mesh renderer
        - Static Batching 勾选 Static
        - Dynamic Batching需900 slots以下
    - GPU Instancing
        - 不支持skinned mesh renderer
        - 在Material上Enable GPU Instancing
        - 相同mesh，相同material，加per-instance data（即不是完全相同的material）
            
            `_Color ("Color", Color) = (1,1,1,1)
            ...
            UNITY_INSTANCING_CBUFFER_START(Props)
                UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
            UNITY_INSTANCING_CBUFFER_END`
            
            ·MaterialPropertyBlock props = new MaterialPropertyBlock();
            props.SetColor("_Color", new Color(r, g, b))
            renderer.SetPropertyBlock(props);
            ·
    - 纹理打包成Atlas图集(POT并注意节约空间)，减少Material数量
        - [TODO]Assetbundle how?
    - 不同Material排定不同的Queue，以避免不同Material在渲染时 互相插队 ，产生冗余DrawCall
    - Imposter
        - TODO
- 三角面 100K 
- vbo 5M
- skinned meshes  50
- rigid body 50 
- physics simulate 100 
- 纹理 50M 

因为他说的比较快，我这个手记得也不知道准不准，你可以找一找当年的视频。当然，手机性能不断发展，而且从技术角度来讲任何一个超标的项都可以优化，比如自己写GPU 蒙皮，比如 lod, imposter。你也可以根据你的目标机型，自己测一套数据出来然后再预估

## Quick Update(热更新)
- In Steam, Steam would take over all update things;
- For Code Update(http://www.cnblogs.com/quansir/p/6610449.html)
    - Assembly(Dll) Update
        - Dll(raw file or rename to *.bytes and assetbundled),use System.Relection
        - System.Relection.Emit would not be used in AOT
        - Not allowed by App Store policy, WorkArounds:
            - C#Light
            - ILRuntime(used in ILXtime,Egametang),here use ILXTime and inject special methods as follow:
                - Awake
                - Start
                - Update
                - LateUpdate
                - OnTriggerEnter
                - OnTriggerStay
                - OnTriggerExit
                - OnCollisionEnter
                - OnCollisionStay
                - OnCollisionExit
                - OnEnable
                - OnDisable
                - OnDestroy
    - Lua(uLua,xLua,toLua)
- For Resource Update
    - AssetBundles


## 从Mobile版到PC版差异
- 之前因为性能限制的做法需要恢复
    - 模型可以更多面（可以通过lod调节）
    - 更好效果的Material/shader/texture，重新分uv(3dMax:UVW XForm Modifier)
- 操作/视野范围/其他不同的设计
- AssetBundle文件是平台依赖的，不兼容
- 其他
    - 针对mobile的GCloud服务

## TODO:
### 规范
所有口头或文档的规范，很难得到严格遵守，也就是说，不能用程序检测的规范都是空规范。
1. 美术资源/策划资源 做成Editor菜单检查校验 / 或在资源导入时检查
2. 程序规范
    
+ 管理
    1. Redmine 使用要求
+ 程序
    1. 编码规范/单元测试/文件夹结构/编程工具/调试工具
    2. 性能要求/framework
    3. 系统设计/数据库
    4. 返回值定义+0xAABB:
        + AA:系统编号
        + BB:返回值
            - 00~7f 非错误
            - 80~ff 错误
        + 通常的OK = 0
        + 通常的FAIL = -1
+ 策划: 做成Editor菜单检查校验 / 或在资源导入时检查
    1. 
+ 美术: 做成Editor菜单检查校验 / 或在资源导入时检查
    1. 命名规范
    2. 面限制
### 防作弊（特别是PC版）
### GM工具
### 任务链、编辑器及任务进度管理
### 物品/背包
1. 如果武平不多(几百以内)，可以用实体自动存储，否则用executeRawDatabaseCommand是最可控的。 http://bbs.kbengine.org/forum.php?mod=viewthread&tid=3993&highlight=%E8%83%8C%E5%8C%85
2. 
### 技能编辑器
1. Animation/Timeline
### AI 行为树编辑器(python)
1. 参考：behavior3/behaviac等
2. NodeEditor
3. 移动
4. 发动技能

2. State Machine 
    + Animation Editor as State Editor 
    + Animator Editor as State Machine Editor
    + 讨论，在有服务器的情况下
