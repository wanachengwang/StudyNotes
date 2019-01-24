## 基本概念
1. 全局工作组(Global Work Group) / 本地工作组(Local Work Group) / 工作项(Work Item)的三维数组
2. 本地布局layout(local_size_x=2, local_size_y=2, local_size_z=2) in; 
    1. 因为硬件限制，乘积<=1024
    2. 对于AMD，乘积最好是64的倍数(wavefront)
    3. 对于NVidia，最好是32的倍数(warp)
3. ID:
    1. gl_WorkGroupSize：向量，本地工作组大小，即上面本地布局设置
    2. gl_NumWorkGroups：向量，工作组个数，即glDispatchCompute传入的参数
    3. gl_LocalInvocationID：向量，vec(0)到gl_WorkGroupSize-vec(1)之间
    4. gl_WorkGroupID：向量，vec(0)到gl_NumWorkGroups-vec(1)之间
    5. gl_GlobalInvocationID：向量，gl_WorkGroupID *gl_WorkGroupSize + gl_LocalInvocationID
    6. gl_LocalInvocationIndex：标量，gl_LocalInvocationID的一维形式
4. 同步barrier
    1. execution barrier通过调用barrier()函数触发。当一个工作项遇到执行barrier，会暂停等待相同本地工作组中所有工作项都到达barrier，才继续往下执行
    2. memory barrier可以直接调用memoryBarrier()/groupMemoryBarrier()，可影响全局内存/组内内存。强制等待在此之前的内存写入操作完成写入，类似flush。
5. 启动运行
    1. glUseProgram设置需要运行的compute shader
    2. 分发到groups(个数)，并且开始运行：glDispatchCompute(num_group_x, num_group_y, num_group_z)

## Unity Compute Shader语法 / HLSL语法
1. 文件后缀.compute
2. 指定内核函数（至少一个）：#pragma kernel FuncA
    1. 后面可直接进行宏定义，也可使用#define
3. 指定本地布局：[numthreads(local_size_x, local_size_y, local_size_z)]
4. ID/可选kernel函数参数：
    1. SV_GroupID : 对应于gl_WorkGroupID
    2. SV_GroupThreadID : 对应于gl_LocalInvocationID
    3. SV_GroupIndex : 对应于gl_LocalInvocationIndex， SV_GroupThreadID的一维形式
    4. SV_DispatchThreadID : 对应于gl_GlobalInvocationID
5. 语法示例：

        /* compute shader */
        #pragma kernel CSMain
        struct MyBuffer{
            float life;
            float3 pos;
        };
        RWStructuredBuffer<MyBuffer> myBuffer;
        RWTexture2D<float4> res;
        float damping;
        [numthreads(8,8,1)]
        void CSMain(uint3 id:SV_DispatchThreadID){
        }

        /* unity monobehavior */
        int nThreads = 256;
        int nGroups = 256/(8*8*1);
        int szMyBuffer = sizeof(float) * 4;
        _computeBuffer = new ComputeBuffer(nThreads, szMyBuffer);
        //_computeBuffer.setData
        int kernelId = _shader.FindKernel("CSMain");
        _shader.SetBuffer(kernelId, "myBuffer", _computeBuffer);
        _shader.Dispatch(kernelId, nGroups, 1, 1);
6. 应用实例：
    1. 粒子系统：
        1. 用compute shader计算出每个粒子的数据(甚至可以是物理碰撞计算)，
        2. 用Graphics.DrawMeshInstancedIndirect进行gpu instancing描画，
        3. 参见https://github.com/TheAllenChou/unity-cj-lib