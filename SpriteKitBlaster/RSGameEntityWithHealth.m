//
//  RSGameEntityWithHealth.m
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 21.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import "RSGameEntityWithHealth.h"

@implementation RSGameEntityWithHealth
@synthesize health = _health;
-(instancetype)initWithPosition:(Vector2d)p andUpdateFunction:(void (^)(RSGameEntity *entity, RSGameInput *input, NSTimeInterval dt)) block;{
    if (self = [super initWithPosition:p andUpdateFunction:block]) {
        _health = MAX_HEALTH_VAL;
    }
    return self;
}
@end
