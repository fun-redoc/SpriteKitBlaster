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

//@property (nonatomic) Vector2d v; // velocity
//@property (nonatomic) Vector2d a; // acceleration
//@property (nonatomic) Vector2d p; // position

@property (nonatomic) State state;

-(instancetype)accelerate:(Vector2d) a dt:(NSTimeInterval) dt;

@end
