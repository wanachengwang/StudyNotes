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
- Animator: Logic of transferring among animation clips
    - Refer to Unity 2D.md
- Timeline: Anime multi gameobjects to a movie clip

- Modeling: Generate vertices of pos/norm/etc(Other data would refer it by indice)
- Skeleton: A set of bones with position/rotation(local)
- Skinning: Join vertices with skeleton(BindShape/Matrix/Weights)
- File format:
    - fbx(http://download.autodesk.com/us/fbx/2010/fbx_sdk_help/index.html?url=WS1a9193826455f5ff-150b16da11960d83164-6c6f.htm,topicNumber=d0e127)
    - dae(https://www.khronos.org/files/collada_spec_1_5.pdf)
## Assetbundles
- Build Flow
    - Set Assetbundles name/variant(ext) in Inspector's AssetBundle lable
    - Or Drag assets into AssetBundle Browser
    - Then Build AssetBundle in AssetBundle Browser or with BuildPipeline.BuildAssetBundles
    - Scene can be build into AssetBundle, and prior to the scene in build with same name when SceneManager.LoadScene.
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