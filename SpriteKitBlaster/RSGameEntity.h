//
//  RSGameEntity.h
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 17.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSGameEntityProtocol.h"
#import "RSGameInput.h"
#include "globaldefs.h"

@interface RSGameEntity : NSObject<RSGameEntityProtocol>
@property (nonatomic) State state; // position

-(instancetype)initWithPosition:(Vector2d)p;
@end
