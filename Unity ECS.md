### Unity ECS/(Entity,Component,System)
#### Definition
+ Entity: components holder，just a ID
+ Component: data holder, IComponentData, struct
+ System: logic to process some kind of components/data
#### Coding Pattern
1. Pure ECS:
    + IComponentData: 
        - interface for all component type
        - struct
        - may not contain references to managed objects, because no gc.
        - Shared ComponentData can have references, e.g. RenderMesh
        - Shared ComponentData changing cause not shared, and moving the entity into a different chunk.
        - SystemStateComponent to record entity Create/Destroy etc.
        - DynamicBufferComponents for varying length data
    + EntityManager: 
        - CreateEntity with typeof(Component Type(s))/Archetype
        - Instantiate with an existing entity
        - then setComponentData
        - for many entities, using NativeArray<Entity>
    + ComponentSystem
        - EntityQuery to query entities
            - GetEntityQuery
            - EntityQuery.ToComponentDataArray/ToEntityArray
        - Do something on entities that from entityQuery in OnUpdate 
        - Attributions:
            - UpdateInGroup: InitializationSystemGroup/SimulationSystemGroup/PresentationSystemGroup
            - UpdateBefore/UpdateAfter
            - DisableAutoCreation
    + JobComponentSystem
        - Execute method in struct that implement IJobForEach<filterTypes...>
        - create instance of the struct in onUpdate
        - call Job.Schedule to start struct.Execute in onUpdate
    + Flow:
        - Bootstrap,use [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
        - In Bootstrap, create entities, fill component data
        - *Components would be put into the corresponding ComponentSystem's list in background by injection
            ```csharp
            #if false // Deprecated!!
                public struct Data{
                    public int Length; // this member name should not be changed!!
                    [ReadOnly] public ComponentDataArray<Position2D> Position;
                }
                [Inject] private Data m_Data;
            #else
                Entities.ForEach((ref Position2D pos)=>{ 
                    //Do something
                });
            #endif
            ```
        - *ALL CLASSes derived from ComponentSystem would invoke OnUpdate every frame
2. Hybrid ECS:
    + ？？？？
#### Memory Layout
1. Archetype/Chunk(16kb) based memory
    + Normally an Archetype cooresponding to a chunk
    + Archetype is a bunch of ComponentType.
    + Archetypes are cached, the same ComponentType[] would return the same Archetype.
    + AddComponent/RemoveComponent
        - cause entity data moving to a differnt chunk with a differnet archetype.
        - cause condense the data in the original chunk.
        - Invalidate the data using in OnUpdate, should use EntityCommandBuffer.
        - so, Predine Archetypes to avoid unneccessary chunk allocation/moving.
2. Layout:
    + Archetype{Pos, Rot} Chunk(16k)
        - Pos array [pos0][pos1][pos2][...n]
        - Rot array [rot0][rot1][rot2][...n]
    + Archetype{Rot} Chunk(16k)
        - Rot array [rot0][rot1][rot2][...n]
    + n is the total number of entities a single chunk(16kb) can store, even far less than n entities created.
    + No SCDs, but internally has an array of shared component indices used by this chunk.
3. SharedComponentData(SCD) have their own manager with a freelist array, not in the Chunk.
4. CreateEntity will initialize all components to zero, so setComponentData with zero data is not neccessary.
5. ComponentDataArray/Group/Entities.ForEach get pointers to the chunk data.
6. reference:
    + https://forum.unity.com/threads/memory-layout-for-ecs-components.590731/
    + https://forum.unity.com/threads/a-few-questions-about-archetypes.524567/
    + https://forum.unity.com/threads/ecs-memory-layout.532028/

### Job System
+ As mentioned above, a ComponentSystem would update some kinds of components from a lot of entities
+ we should optimized this code with multithread
+ so use JobSystem, kind of similar with openMP's ParallelFor, use worker threads
+ interface:IJob/IJobParallelFor(index)
+ data: NativeContainers:NativeArray,NativeList,NativeHashMap,NativeQueue (Note: += would not eval back)
+ schedule 
+ complete to unlock data, and start the next job(if scheduled)

### Debug In Unity
+ Unity 2018.2.0b5-->Window-->Debug-->Entity Debugger
+ Unity 2019-->Window-->Analysis-->Entity Debugger

### Deprecated
+ Position => Translation
+ MeshInstanceRenderer => RenderMesh
+ IJobProcessComponentData => IJobForEach
+ World.Active => World.DefaultGameObjectInjectionWorld
+ GetComponentGroup/[Inject] ==> GetEntityQuery/Entities.ForEach
+ CreateEntityQuery ==> CreateEntityQuery
+ EntityArray/ComponentDataArray ==> NativeArray<Entity/..>
+ BarrierSystem => EntityCommandBufferSystem; [Inject] => World.GetOrCreateSystem<T>
+ GetOrCreateManager<EntityManager> => EntityManager

### More
+ https://docs.unity3d.com/Packages/com.unity.entities@0.0/manual/ecs_entities.html