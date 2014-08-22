//
//  globaldefs.c
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 22.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#include <stdio.h>
#include <math.h>
#include "globaldefs.h"


State fnVerticalCollisionHandler(State e) {
    e.a.x = -e.a.x * BORLDER_COLLISION_DAMPING;
    e.v.x = -e.v.x * BORLDER_COLLISION_DAMPING;
    e.a.y = e.a.y * BORLDER_COLLISION_DAMPING;
    e.v.y = e.v.y * BORLDER_COLLISION_DAMPING;
    return e;
};

State fnHorizontalCollisionHandler(State e) {
    e.a.x = e.a.x * BORLDER_COLLISION_DAMPING;
    e.v.x = e.v.x * BORLDER_COLLISION_DAMPING;
    e.a.y = -e.a.y * BORLDER_COLLISION_DAMPING;
    e.v.y = -e.v.y * BORLDER_COLLISION_DAMPING;
    return e;
};

State accelerate(State state, Vector2d a, double dt) {
    // when the device ist tilded add max accelerattion in the tilt direction
    // beware, because of the landscape mode tilt y-achses means movement x-axes
    const float MovementDamping = 0.999f;
    
    State newS = state;
    Vector2d newA = newS.a;
    newA.x = - a.y * MAX_PLAYER_ACCELERATION;
    newA.y = a.x * MAX_PLAYER_ACCELERATION;
    newS.a = newA;
    
    // calculate the new speed (Newton Approximation), und clamp
    Vector2d newV = newS.v;
    newV.x += newS.a.x * dt; newV.x *= MovementDamping;
    newV.y += newS.a.y * dt; newV.y *= MovementDamping;
    newV.x = fmaxf(fminf(newV.x, MAX_PLAYER_SPEED), -MAX_PLAYER_SPEED);
    newV.y = fmaxf(fminf(newV.y, MAX_PLAYER_SPEED), -MAX_PLAYER_SPEED);
    newS.v = newV;
    
    // calculate the new position in the world
    Vector2d newP = newS.p;
    newP.x = newS.p.x + newS.v.x*dt;
    newP.y = newS.p.y + newS.v.y*dt;
    newS.p = newP;
    
    return newS;
}
