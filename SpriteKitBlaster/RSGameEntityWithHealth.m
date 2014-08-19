//
//  RSGameEntityWithHealth.m
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 19.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import "RSGameEntityWithHealth.h"

#define MAX_HEALTH_VAL 100

@implementation RSGameEntityWithHealth
-(instancetype)initWithPosition:(Vector2d)p {
    if (self = [super initWithPosition:p]) {
        self.healthPercent = MAX_HEALTH_VAL;
    }
    return self;
}
@end
