//
//  RSGameEntity.h
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 17.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSGameEntityProtocol.h"
#import "RSGameInput.h"
#include "globaldefs.h"

@interface RSGameEntity : NSObject<RSGameEntityProtocol>
@property (nonatomic) State state; // position
@property (nonatomic, weak) void (^fnUpdate)(RSGameEntity *entity, RSGameInput *input, NSTimeInterval dt);

-(instancetype)initWithPosition:(Vector2d)p andUpdateFunction:(void (^)(RSGameEntity *entity, RSGameInput *input, NSTimeInterval dt)) block;
@end
