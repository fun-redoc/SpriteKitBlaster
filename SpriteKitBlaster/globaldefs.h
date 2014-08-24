//
//  Header.h
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 17.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#ifndef SpriteKitBlaster_Header_h

#include <CoreGraphics/CGGeometry.h>

#define SpriteKitBlaster_Header_h

#define SK_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180
#define SK_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180
#define SGNF(__VAL__) ((__VAL__>=0.0f)?(1.0f):(-1.0f))

#define VEC_LEN(__V__) (sqrtf((((__V__).x)*((__V__).x)) + (((__V__).y)*((__V__).y))))


#define NORMALIZE_ANGLE(__ANGLE__) ((__ANGLE__) - SK_DEGREES_TO_RADIANS(90))




/* points per second^2 */
#define MAX_PLAYER_ACCELERATION 400.0f
/* points per second */
#define MAX_PLAYER_SPEED 200.0f
#define TILT_DEVICE_ACCELERATION 0.05f
#define BORLDER_COLLISION_DAMPING 0.9f
#define MIN_SPEED_TO_BE_ABLE_TO_TURN 20.0f

#define MAX_HEALTH_VAL 100

typedef CGPoint Vector2d;
typedef struct structState {
    Vector2d v; // velocity
    Vector2d a; // acceleration
    Vector2d p; // position
    float spin; // radians
} State;

//typedef boolean_t (^Test)(State);
//typedef State (^CollisionHandler)(State);

State fnVerticalCollisionHandler(State e);
State fnHorizontalCollisionHandler(State e);
State accelerate(State state, Vector2d a, double dt);


// Vectors
Vector2d unitVector(Vector2d v);
Vector2d linearProduct(Vector2d v, float c);
Vector2d vecAdd(Vector2d v1, Vector2d v2);

#endif
