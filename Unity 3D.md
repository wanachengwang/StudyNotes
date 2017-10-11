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
- Set Assetbundles name in Inspector's AssetBundle lable
- Or Drag assets into AssetBundle Browser
- Then Build AssetBundle in AssetBundle Browser or with BuildPipeline.BuildAssetBundles
- Scene can be build into AssetBundle, and prior to the scene in build with same name when SceneManager.LoadScene.
- Dll can be build into AssetBundle(rename to *.bytes), load and GetType

        AssetBundle asmAb = AssetBundle.LoadFromFile(Path.Combine(Application.streamingAssetsPath, "monoclasstst"));
        TextAsset asmBytes = asmAb.LoadAsset<TextAsset>("MonoClassTst");
        Assembly asm = Assembly.Load (asmBytes.bytes);
        //Assembly asm = Assembly.LoadFile (Application.dataPath + @"/../MonoClassTst.dll");
		Type t1 = asm.GetType ("MonoClassTst.MonoClass1");
        gameObject.AddComponent (t1);