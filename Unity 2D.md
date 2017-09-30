## Sprite Animation
- Mode:Single/Multiple
- Sprite Editor -> Slice
- Drag multi slices into scene, Animator auto added
- Or add Animator / Animation manually
- Animation Editor(*.anim yaml with bones and matrix)
    - record / edit anim in dopeSheet/Curve
    - add event if needed
    - self and child
- Animator Editor(*.controller yaml) 
    - State machine      
    - State / Transition / Condition(Parameter) / StateMachineBehaviour / Event
    - SubStateMacine
    - Layer(normally same state machine but different anim) SetLayerWeight

## Sprite Plugins

## Sprite Physic
- Collider 2D
    - Box / Capsule / Circle / Composite / Edge / Polygon
    - Physical Material : Friction / Bouncing
- Rigidbody 2D
    - [Todo]


## Animation importing
- Rig : Legacy/Generic/Humanoid
- Rig : Optimize GameObject(Only available[Copy from other avartar])
- Animation : slice into animations(can Ctrl+D save as *.anim), set event /mask
- Animation : cannot be edited in animation editor(ReadOnly)