//
//  Constants.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/3/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#ifndef Fat_Ninja_Constants_h
#define Fat_Ninja_Constants_h


#define backgroundLayerTag 0
#define gameLayerTag 1
#define ninjaDyingLayerTag 2

typedef enum {
    StateJumping,
    StateDie,
    StateFalling,
    StateRolling,
    StateThrowing,
    StateAfterJumping,
    StateStart,
    StateDoubleJumping
} CharacterStates; // 1

typedef enum {
    Enemy,
    Character,
    Powerup,
    Obstacle,
    None
} GameObjectType;

#endif
