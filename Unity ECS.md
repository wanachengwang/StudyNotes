### Unity ECS/(Entity,Component,System)
#### Definition
+ Entity: components holder
+ Component: data/property holder
+ System: logic to process some kind of components/data
#### Coding Pattern
1. Pure ECS:
    + IComponentData: interface for all component type
    + EntityManager: createEntity with typeod(Component Type), and setComponentData
        + Entity
    + ComponentSystem/JobComponentSystem
    + Flow:
        - Bootstrap,use [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
        - In Bootstrap, create entities, fill component data
        - components would be put into the corresponding ComponentSystem's list in background by injection
        - all ComponentSystem would invoke OnUpdate every frame
2. Hybrid ECS:
    + ？？？？

### Job System
+ As mentioned above, a ComponentSystem would update some kinds of components from a lot of entities
+ we should optimized this code with multithread
+ so use JobSystem, kind of similar with openMP's ParallelFor, use worker threads
+ interface:IJob/IJobParallelFor(index)
+ data: NativeArray (Note: += would not eval back)
+ schedule 
+ complete to unlock data, and start the next job(if scheduled)
