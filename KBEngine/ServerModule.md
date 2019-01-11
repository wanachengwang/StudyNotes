### Modules
| MODULE | Desc | Properties/Methods 
|--------|------|---------------------
| State | 状态/禁止 | state/subState/forbids/_forbidCounter 
| | |                changeState
| Flags | 标记 | flags
| | |                setFlags/hasFlags/addFlags/removeFlags
| Motion | 移动 | moveSpeed/isMoving/nextMoveTime
| | |                gotoEntity/gotoPosition/randomWalk
| Combat | 战斗 | enemyLog/HP/MP/AtkStr
| | |                addEnemy/removeEnemy/recvDamage
| GameObject | 场景物体 | uid-id of entity in spawnData/utype-userDefinedType
| | |                nameId/modelId/modelScale/iconId---可以放在客户端
| | |                direction甚至position(对于不移动的物体)都可以放在客户端
| NpcObject | 非玩家可重生 | spawnId---记录spawner/spawnPoint
| | |                spawnPos---用来做让ai回出生点




### Data Sheet Design
1. 基本上所有数据sheet都只有server需要，客户端不需要；客户端只需要表现层的数据，如id-prefab表，id-icon表，而且这些表应该是可以跟随assetbundle一起做更新的，这样添加模型/Icon就不需要修改客户端代码了。
2. 尽量可能更新/修改的美术数据都放在assetbundle，方便更新。