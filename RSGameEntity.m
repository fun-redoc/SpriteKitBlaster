//
//  RSGameEntity.m
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 17.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import "RSGameEntity.h"

@implementation RSGameEntity

-(instancetype)initWithPosition:(Vector2d)p {
    if( self = [super init] ) {
        State s = self.state;
        s.p = p;
        self.state = s;
    }
    return self;
}

-(Vector2d)a {
    return self.self.a;
}
-(Vector2d)v {
    return self.state.v;
}
-(Vector2d)p {
    return self.state.p;
}

-(instancetype)accelerate:(Vector2d) a dt:(NSTimeInterval) dt block:(void (^)(RSGameEntity *e)) block {
    // when the device ist tilded add max accelerattion in the tilt direction
    // beware, because of the landscape mode tilt y-achses means movement x-axes
    State newState = self.state;
    if (a.y > TILT_DEVICE_ACCELERATION)
    {
        newState.a.x = -MAX_PLAYER_ACCELERATION;
    }
    else if (a.y < -TILT_DEVICE_ACCELERATION)
    {
        newState.a.x = MAX_PLAYER_ACCELERATION;
    }
    if (a.x < -TILT_DEVICE_ACCELERATION)
    {
        newState.a.y = -MAX_PLAYER_ACCELERATION;
    }
    else if (a.x > TILT_DEVICE_ACCELERATION)
    {
        newState.a.y = MAX_PLAYER_ACCELERATION;
    }
    
    // calculate the new speed (Newton Approximation), und clamp
    newState.v.x += newState.a.x * dt;
    newState.v.y += newState.a.y * dt;
    newState.v.x = fmaxf(fminf(newState.v.x, MAX_PLAYER_SPEED), -MAX_PLAYER_SPEED);
    newState.v.y = fmaxf(fminf(newState.v.y, MAX_PLAYER_SPEED), -MAX_PLAYER_SPEED);
    
    // calculate the new position in the world
    newState.p.x = self.state.p.x + newState.v.x*dt;
    newState.p.y = self.state.p.y + newState.v.y*dt;

    self.state = newState;
    
    block(self);
    
    return self;
}

@end
