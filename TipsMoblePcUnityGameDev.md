# Some Notes About Multiplateform Game

## 手机游戏性能规范---2015年uwa 给出了一组数据(同屏)：

- DrawCall 250
    - 利用Static Batching和Dynamic Batching（虽然900 slots以下有效）
    - 纹理打包成Atlas图集（POT并注意节约空间），减少Material数量
    - 不同Material排定不同的Queue，以避免不同Material在渲染时互相插队，产生冗余DrawCall
- 三角面 100K 
- vbo 5M
- skinned meshes  50
- rigid body 50 
- physics simulate 100 
- 纹理 50M 

因为他说的比较快，我这个手记得也不知道准不准，你可以找一找当年的视频。当然，手机性能不断发展，而且从技术角度来讲任何一个超标的项都可以优化，比如自己写GPU 蒙皮，比如 lod, imposter。你也可以根据你的目标机型，自己测一套数据出来然后再预估

## 规范的执行

所有口头或文档的规范，很难得到严格遵守，也就是说，不能用程序检测的规范都是空规范。
- 美术资源/策划资源 做成Editor菜单检查校验 / 或在资源导入时检查
- 程序规范

## 防作弊（特别是PC版）

## 从Mobile版到PC版差异
- 之前因为性能限制的做法需要恢复
    - 模型可以更多面（可以通过lod调节）
    - 更好效果的Material/shader/texture，重新分uv
- 操作/视野范围/其他不同的设计



