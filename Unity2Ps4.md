
## PS4/AOT version compilation
1. Platform switch cause system memory exhausted
    - The cause maybe is Substance. Import assets after moving *.sbsar out of the project folder.
2. Some MeshCollider's mesh is not marked as readable.
    - This error seems not to fail ps4 build.
3. Compilation error(about UnityEditor or something else)
    - Delete Library/ScriptAssemblies folder, then restart Unity to let it recompile.
4. PS4 report error: FindKernel failed
    - Find the shader/computeshader and reimport it
5. MultiDimension Array may cause sigbus
    - Change multidimension array LodOctreeNode[][,,] to LodOctreeNode[][]
    - Note: In my sample scene, this would not cause sigbus
    - https://answers.unity.com/questions/250803/executionengineexception-attempting-to-jit-compile.html
6. template with parameter object cause ExecutionEngineException
    - Atempting to JIT compile method ... while running with --aot-only
    - it looks like there is a Dictionary<..,...> involved which work for some types but not for others! (<int, ...> is known to work but <object,...> could potentially bite you due to the restrictions on aot)
    - https://forum.unity.com/threads/executionengineexception-attempting-to-jit-compile-method.43038/
    - https://answers.unity.com/questions/1101274/attempting-to-jit-compile-method-best-workaround.html
7. Ran out of trampolines of type 0
    - https://stackoverflow.com/questions/5278592/ran-out-of-trampolines-of-type-0
8. RenderTextureFormat.ARGBHalf seems not supported by PS4