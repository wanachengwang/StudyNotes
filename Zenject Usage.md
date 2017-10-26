# Zenject

## IOC Theory
Inversion of control / Dependency Inversion Principle means that One Implementation Should Depend On Interface Instead Of Another Implementation, this design principle aims to loose coupling.
Dependency Injection(Also known as DI) is a design pattern based on IOC principle.
### Note: 
Do not use interface anywhere, only create interfaces when the class has more than one implementation (known as the Reused Abstraction Principle)

## Execution Flow
Note: 
- _currentBindings : Queue<IBindingFinalizer>
- ProviderBindingFinalizer member: BindInfo
- BindInfo: 
    - ContextInfo = contextInfo;
    - Identifier = null;
    - ContractTypes = contractTypes;
    - oTypes = new List<Type>();
    - rguments = new List<TypeValuePair>();
    - ToChoice = ToChoices.Self;
    - CopyIntoAllSubContainers = false;
    - NonLazy = false;
    - Scope = ScopeTypes.Unset;
    - InvalidBindResponse = InvalidBindResponses.Assert;

Installer:
- >DiContainer.Bind/BindFactory/...bind TContractType with TResultType
- >new ConcreteIdBinderGeneric<TContract>(bindInfo, StartBinding())
- >DiContainer.StartBinding
- >DiContainer.FlushBindings [AFTER this,push this IBindingFinalizer into _currentBindings]
- >DiContainer._currentBindings.Dequeue
- >IBindingFinalizer.FinalizeBinding(DiContainer)
- >ProviderBindingFinalizer.FinalizeBinding/[Other Finalizer][this Provider has BindInfo]
- >ScopableBindingFinalizer.OnFinalizeBinding/[Other Finalizer]
- >FinalizeBindingSelf/FinalizeBindingConcrete
- >RegisterProvidersForAllContractsPerConcreteType/RegisterProviderPerContract
    - >Param:container----------DContainer
    - >Param:concreteTypes------TResultType
    - >Param:_providerFactory---Func<DiContainer,Type,IProvider> return IProvider

## Inject Usage
Attribute: [Inject(Id="MyId" Optional=false Source=InjectSources.AnyParent)]
| Prior | TYPE | USAGE
|-|-|-
| 0 |Ctor Params: |not need Inject except multi-ctor, or public Ctor([Inject(Id="f")]bool f)
| 1 |Field:       |[Inject]bool _autoSpawn;
| 2 |Property:    |[Inject]bool AutoSpawn{get;private set;};
| 3 |Method:      |[Inject]void Func(bool autoSpawn){}|
Note: 
1. Field/Property is not set in Constructor according to the upper priorities.
2. The order between Fields or Properties is not guaranteed(based on Type.GetFields)
3. In unity scene, scene Awake > Inject > dynCreated Prefab Awake

## Bind Usage
    Container
        .Bind<ContractType>()
        .To<ResultType>()
        .WithId(Identifier)
        .FromConstructionMethod()
        .AsScope()
        .WithArguments(Arguments)
        .When(Condition)
        .CopyIntoAllSubContainers()
        .NonLazy();
- ContractType = type to bind for, aka. type of field/parameter to inject
- ResultType = type to bind to, type of variable to fill field/parameter
    - Default: ContractType, aka. ToSelf()
- Identifier string or any type
- ConstructionMethod
    - Default: FromNew
    - Others:
        - FromComponentInHierarchy  //Find in the whole scene hierarchy
        - FromComponentSibling      //Find in current transform
        - FromComponentInChildren   //Find in current transform and children
        - FromComponentInParents    //Find in current transform and parents
        - FromComponentInNewPrefab  //Instantiate given prefab and find
        - FromComponentInNewPrefabResource  //Load prefab path and Instantiate and find
        - FromNewComponentOn        //New Component on given gameobject 
        - FromNewComponentOnNewGameObject
        - FromNewComponentSibling   //New component on current transform 
        - FromFactory(IFactory)     //
        - FromInstance
        - FromMethod
        - FromMethodMultiple        //IEnumerator
        - FromMethodUntyped         //???Not Documented
        - FromResolve               //See doc
        - FromResolveGetter         //See doc
        - FromSubcontainerResolve   //See doc
        - FromResource              //Resources.Load ex. Texture
        - FromScriptableObjectResource      //From scriptable asset(AssetDatabase.LoadAssetAtPath)
        - FromNewScriptableObjectResource   //From scriptable asset then clone

## Factories
- Doc: https://github.com/modesttree/Zenject/blob/master/Documentation/Factories.md
- Dynamic created class can not be injected directly because it's not in object graph
- Simplly override Factory<T>.Create would not inject, so use FromFactory instead or like this:
```csharp
     public class Factory : Factory<int, Enemy> {
        DiContainer _container;
        public Factory(DiContainer container) {
            _container = container;
        }
        public Enemy Create(int lv) {
            Debug.Log("Create an enemy:"+lv);
            return _container.Instantiate<Enemy>();
        }
    }
 ```
- Usage: 
    - Container.BindFactory<Ta, Factory<Ta>>();     // Ta.Factory used as short of Factory<Ta>
    - Container.BindFactory<TPara,Ta, Ta.Factory>   // Add parameters
        - Ta.Factory:Factory<TPara, Ta>
        - Ta.Factory.Create(TPara)
    - FromComponentInNewPrefab(TaPrefab)/FromComponentInNewPrefabResource(TaPrefabPath)
    - FromInstance, FromMethod, FromSubContainerResolve, etc.
    - To<Tb>        //TargetType Ta, ResultType Tb, Abstract Factory
    - FromFactory   //Customize factory ??? 

## MemoryPool
- Doc: https://github.com/modesttree/Zenject/blob/master/Documentation/MemoryPools.md
- Similar to factories
- MonoMemoryPool for Monobehaviour pool to enable/disable game object
- Usage:
    ```csharp
    Container.BindMemoryPool<Ta, MemoryPool<Ta>, MemoryPoolContractType[Optional]>()
    .With(InitialSize|FixedSize)()  // Exception throw when FixedSized exceeded.
    .ExpandBy(OneAtATime|Doubling)()
    .To<ResultType>()               // Abstract Pool(Cast to various subtype)
    .WithId(Identifier)
    .FromConstructionMethod()       // ex. FromComponentInNewPrefab
    .WithArguments(Arguments)
    .When(Condition)
    .CopyIntoAllSubContainers()
    .NonLazy();
    ```
- Func & Event:
    - Spawn
    - Despawn
    - ReInitialize  //Similar to OnSpawned but have params of this Pool
    - OnCreated     //Called immediately after the item is first added to the pool
    - OnSpawned     //Called immediately after the item is removed from the pool
    - OnDespawned   //Called immediately after the item is returned to the pool

## Guidelines / Recommendations / Tips and Tricks
- Don't use GameObject.Instantiate if your objects need injection, Use Factories.
- Best not reference to the container out of the composition root "layer"
- Don't use IInitializable, ITickable, IDisposable for dynamically created objects
    - Not work for those created by factories
    - IInitializable can be substitute with [Inject]
    - Tick should be invoked manually.
- Multi Ctor: Only the only one with[Inject] can be Injected.
- Lazy/Performance, ExecuteOrder, TransientIsDefault, etc.



