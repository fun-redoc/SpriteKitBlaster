//
//  RSGameEntity.h
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 17.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "globaldefs.h"

@interface RSGameEntity : NSObject

@property (nonatomic, readonly) Vector2d v; // velocity
@property (nonatomic, readonly) Vector2d a; // acceleration
@property (nonatomic, readonly) Vector2d p; // position

@property (nonatomic) State state;

-(instancetype)initWithPosition:(Vector2d)p;

-(instancetype)accelerate:(Vector2d) a dt:(NSTimeInterval) dt block:(void (^)(RSGameEntity *e)) block;

@end
