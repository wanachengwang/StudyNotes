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
| TYPE | USAGE
|-|-
| Field:       |[Inject]bool _autoSpawn;
| Property:    |[Inject]bool AutoSpawn{get;private set;};
| Constructor: |not need Inject except multi-ctor, or public Ctor([Inject(Id="f")]bool f)
| Method:      |[Inject]void Func(bool autoSpawn){}|

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
        - FromFactory(IFactory)     //???BindFactory
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

## Guidelines / Recommendations / Tips and Tricks



