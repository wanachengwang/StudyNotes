## Compiler Config
- https://docs.unity3d.com/Manual/PlatformDependentCompilation.html
- gmcs: compiler to target the 2.0 mscorlib
- smcs: compiler to target the 2.1 mscorlib, to build Moonlight applications.
- dmcs: compiler to target the 4.0 mscorlib.
- In ver >= unity5.5, use mcs.rsp instead of previour gmcs.rsp/smcs.rsp.
    - -unsafe
## Model and Animation
- Animation: Anime current gameobject(and children)
    - Refer to Unity 2D.md
    - Animation Clip can be edited in Inspector
    - in editor, deeper child has more left padding
    - in inner implementation, setCurve("relative path")
- Animator: Logic of transferring among animation clips
    - Refer to Unity 2D.md
- Timeline: Anime multi gameobjects to a movie clip

- Modeling: Generate vertices of pos/norm/etc(Other data would refer it by indice)
    - blender
    - probuilder/hotkeys(w/e/r/ctrl+e/shift)
- Skeleton: A set of bones with position/rotation(local)
    - 骨节-IK/Bone-FK
    - 动画数据:
        - name(frame/bone名)
        - 旋转矩阵(没有位移/放缩，才能实现IK)
- Skinning: 蒙皮，将模型依附到你的骨骼上，刷权重(BindShape/Matrix/Weights)
- Binding: 绑定，包括搭建骨骼，对骨骼的设置(例如旋转角度限制)，控制器的添加，广义上也还包括蒙皮
- Rigging: 即广义的绑定
- File format:
    - fbx(http://download.autodesk.com/us/fbx/2010/fbx_sdk_help/index.html?url=WS1a9193826455f5ff-150b16da11960d83164-6c6f.htm,topicNumber=d0e127)
    - dae(https://www.khronos.org/files/collada_spec_1_5.pdf)

- SkinnedMeshRenderer与Bones:
    - SkinnedMeshRenderer中的Bones是一系列transform的数组；rootBone用于处理根节点位移动画，跟普通动画无关；bindpose数组是每个bone相对于根的位置矩阵
    - SkinnedMeshRenderer中的mesh存在boneweight数组，一个vertice有对应的一个boneweight数据(支持多达4个bone index(0,1,2,3)的权重数据)
    - Unity hierachy中的层级关系来自动画文件
        - 如果内部是按照AnimationClip的setCurve来实现的话，这个层级会作为relativePath参数传递进去
        - 如果内部是直接根据bone index来获取bone的transform的话，那这个层级关系就只有参考意义

## Assetbundles
- Build Flow
    - Set Assetbundles name/variant(ext) in Inspector's AssetBundle lable
        - AssetImporter.GetAtPath(path).assetBundleName = xxx
    - Or Drag assets into AssetBundle Browser
    - Then Build AssetBundle in AssetBundle Browser
        - BuildPipeline.BuildAssetBundles with AssetBundleBuild array
            - only build these abs
        - BuildPipeline.BuildAssetBundles without AssetBundleBuild array
            - build all abs, generate folder_name.manifest and its ab file
    - Scene can be build into AssetBundle, and prior to the scene in build with same name when SceneManager.LoadScene.
    - [参考](http://www.cnblogs.com/murongxiaopifu/p/7146430.html)
- Included In Multiple Bundles
    - Warning in AssetBundle Browser
    - Cause bigger bundle files
    - Bundling them sololy would resolve this problem
- Load Flow
    - Use WWW.assetBundle.LoadAsset
    - Use AssetBundle.LoadFromFile/Memory(...).LoadAsset
    - Unload(true/false)
- Dll can be build into AssetBundle(rename to *.bytes), load and GetType

        AssetBundle asmAb = AssetBundle.LoadFromFile(Path.Combine(Application.streamingAssetsPath, "monoclasstst"));
        TextAsset asmBytes = asmAb.LoadAsset<TextAsset>("MonoClassTst");
        Assembly asm = Assembly.Load (asmBytes.bytes);
        //Assembly asm = Assembly.LoadFile (Application.dataPath + @"/../MonoClassTst.dll");
		Type t1 = asm.GetType ("MonoClassTst.MonoClass1");
        t1.GetMethod ("Func0", System.Reflection.BindingFlags.Instance|BindingFlags.NonPublic).Invoke (t1c, null);
        gameObject.AddComponent (t1);

        Note: Not work in AOT