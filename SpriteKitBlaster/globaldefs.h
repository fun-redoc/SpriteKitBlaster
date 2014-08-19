//
//  Header.h
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 17.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#ifndef SpriteKitBlaster_Header_h
#define SpriteKitBlaster_Header_h

#define SK_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180
#define SK_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180
#define SGNF(__VAL__) ((__VAL__>=0.0f)?(1.0f):(-1.0f))

#define NORMALIZE_ANGLE(__ANGLE__) ((__ANGLE__) - SK_DEGREES_TO_RADIANS(90))

/* points per second^2 */
#define MAX_PLAYER_ACCELERATION 400.0f
/* points per second */
#define MAX_PLAYER_SPEED 200.0f
#define TILT_DEVICE_ACCELERATION 0.05f
#define BORLDER_COLLISION_DAMPING 0.9f
#define MIN_SPEED_TO_BE_ABLE_TO_TURN 20.0f

typedef CGPoint Vector2d;
typedef struct structState {
    Vector2d v; // velocity
    Vector2d a; // acceleration
    Vector2d p; // position
} State;

typedef boolean_t (^Test)(State);
typedef State (^CollisionHandler)(State);

#endif
