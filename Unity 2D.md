## Sprite Animation Importing
- Set Mode:Single/Multiple
- Use Sprite Editor -> Slice into multiple slices
- Drag multi slices into scene, Animator auto added
- Or add Animator / Animation manually
- Animation Editor(*.anim yaml with bones and matrix) to edit animation clip
    - record / edit anim in dopeSheet/Curve
    - add event if needed
    - affect self and children
    - in editor, deeper child has more left padding
    - in inner implementation, setCurve("relative path")
- Animator Editor(*.controller yaml) to edit animator
    - State machine      
    - State / Transition / Condition(Parameter) / StateMachineBehaviour / Event
    - SubStateMachine
    - Layer(normally same state machine but different anim) SetLayerWeight
    - Transition Solo/Mute to debug
    - AnyState

## Sprite Plugins
- Anim Tools
    - Spine
    - DragonBones
        - [TODO]
- Atlas
    - 2017 Sprite Atlas:(https://www.litefeel.com/blog/unity-2017-new-sprite-atlas/)
        (http://www.sohu.com/a/169409304_280780)
        - A resource created by RB Menu->SpriteAtlas,then add sprite object to pack in.
        - Master-Variant(for different resolutions)
        - SpriteAtlas.GetSprite
        - SpriteAtlasManager.atlasRequested += OnAtlasRequested;
        - SpriteMask
    - Legacy Sprite Packer
        - Project Setting->Editor to Enable Legacy Sprite Packer
        - Pack all sprites with same tag into one or more atlas(when sprites have different formats)
        - Sprites without tag will not be packed
        - Sprites in Resources folder will not be packed.
        - in folder Libary/AtlasCache
        - Runtime Load: (http://www.xuanyusong.com/archives/3304)
            - Pack imgs to altas
            - Create a prefab for each img in Resources folder
            - Use Resources.Load to load img prefabs
        - Quick Update: (http://blog.csdn.net/akof1314/article/details/48376373)
            (http://blog.csdn.net/a8856621/article/details/50388920)
            - Pack into AssetBundles
            - AssetBundles.LoadAllAssets<Sprite>(img file name with ext)
    - Texture Packer

## Sprite Physic
- Collider 2D
    - Box / Capsule / Circle / Composite / Edge / Polygon
    - Physical Material : Friction / Bouncing
- Rigidbody 2D
    - [Todo]

## Animation importing
- Rig : Legacy/Generic/Humanoid
- Rig : Optimize GameObject(Only available[Copy from other avartar])
- Animation : slice into animations(can Ctrl+D save as *.anim), set event /mask
- Animation : cannot be edited in animation editor(ReadOnly)