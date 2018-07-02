# UnityPrjStructure
A standard unity project directory structure.

## Directory Description
* 3rdParty--------All 3rd party packages
* ArtAssets-------All artists-made assets
    + Audio
        - Music
        - Sfx
    + Effects-----Particle effects
    + Gui---------Ui sprites/ UI Atlas /Font
    + Textures----For textures not belonging to a model, such as skyboxs, texture atlas
    + Models------All models/animations/textures here
        - Characters
        - Enviroment
    + Animations--Only for those animations not attached with models
    + Animators
* GameModules-----Program code for game modules
* Materials-------Common use(not artist-made) mat
    + Shaders
* Plugins
* Prefabs---------Prefabs should be made by designers.
                  Try to prefab everything you put on scenes
    + Resources---If it is loaded by Resources.Load, add Resources folder

* Scenes
    + Levels------1.Make the game runnable from every scene. It reduces testing time.
                  2.Put empty gameobjects to make scene organized

* StreamingAssets
* TestingGround---Put all your test assets(code/scene/other) here
    + Editor
    + userName----For this user only

## Game Modules
* Singleton Mgr(Mgr of all mgrs, using Zenject)
    + Persistent Mgr(SaveLoad) 
    + Input Mgr
    + Version/Hotfix Mgr
    + Res Mgr(load/cache assets)
    + Scene Flow Mgr
* Utils
    + Bug reporter
    + game debugger
    + ...

## Coding Convention
| IDENTIFIER | CASE | EXAMPLE 
|------------|------|-----------
| Namespace | Pascal | System.Drawing
| Interface | Pascal with prefix I | IDisposal
| Class | Pascal | AppDomain
| Exception class | Pascal | WebException
| Enumeration types | Pascal | ErrorLevel
| Enumeration values | Pascal | FileError
| Event | Pascal | ValueChange
| Method | Pascal | ToString
| Readonly static field/Const | Pascal | RedValue
| Private (static) field | Camel with prefix _ | _myVal
| Public (static) field/Property | Pascal | BackColor
| Parameter/Local variables | Camel | localVar

## Class file layout
* [StyleCop in stackoverflow](https://stackoverflow.com/questions/150479/order-of-items-in-classes-fields-properties-constructors-methods)
    + Within a class, struct or interface: (SA1201 and SA1203)
        - Constant Fields
        - Fields
        - Constructors
        - Finalizers (Destructors)
        - Delegates
        - Events
        - Enums
        - Interfaces
        - Properties
        - Indexers
        - Methods
        - Structs
        - Classes
    + Within each of these groups order by access: (SA1202)
        - public
        - internal
        - protected internal
        - protected
        - private
    + Within each of the access groups: (SA1204)
        - static
        - non-static
    + Within each of the static/non-static groups of fields: (SA1214 and SA1215)
        - readonly
        - non-readonly

## 3rd Frameworks/Packages
* [Zenject](https://github.com/modesttree/Zenject)----------a IOC/DependencyInjection framework
* [UniRx](https://github.com/neuecc/UniRx)------------Reactive Extention for Unity3d
* [Entitas CSharp](https://github.com/sschmid/Entitas-CSharp) - entity component system framework, but I think it is a little overdesigned.
* [Node Editor](https://github.com/Baste-RainGames/Node_Editor) - (calculation-)node editor
* [Fungus](https://github.com/snozbot/fungus) - 2d interactive storytelling game framework
* VertExmotion - vert morph anim, can be used to simulate physics
* LeanTween
* Vectrosity - Draw points/lines/curves
* PoolManager

and more packages [here](https://github.com/wcwsoft/Unity-Script-Collection).