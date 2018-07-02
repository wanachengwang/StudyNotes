#### Packages环境：
1. SRP Core 1.1.8 preview
2. Lightweight Render Pipeline 1.1.8 preview
3. High Definition Render Pipeline 1.1.8 preview(Exlporer打开文件后，每次鼠标点击/窗口OnFocus都会引起文件重导入，所以删除了)
4. Shader Graph 1.1.9 preview

#### 问题及解决：
1. 如上3所述， 删除High Definition Render Pipeline解决
2. 如果报错(Enable "Allow 'unsafe' code" in the inspector ... asdmdef),现在在asmdef的Inspector是灰的，不能修改，可以在文件中添加("allowUnsafeCode": true)
3. 只有sub graph不报错，其他pbr/unlit graph都是紫色， 需要先create-->Rendering-->Lightweight Pipeline Asset，并且在Project Settings-->Graphics中指定给Scriptable Render Pipeline Settings
4. 按照视频教程在Blackboard上添加变量，可以拖出来成为Property，不能拖出；但可以先创建一个节点(如Color/Texture 2D Asset)，右键Convert To Property，这样可以在Material中调整

#### 开始
1. PBR Graph PBR图
2. Sub Graph 子图，用于创建一些可复用的节点
3. Unlit Graph 不受光照的图
