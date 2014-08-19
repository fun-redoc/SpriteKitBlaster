//
//  RSSpriteNodeWithHealthBar.h
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 19.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RSUpdateProtocol.h"
#import "RSGameEntity.h"
#include "globaldefs.h"

@interface RSHealthBar : SKNode <RSUpdateProtocol>
@property (nonatomic, strong) void (^fnUpdate)(SKNode *node, RSGameInput *input, NSTimeInterval dt);
-(instancetype)initWithUpdateFunction:(void (^)(SKNode *sprite, RSGameInput *input, NSTimeInterval dt)) block;
-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt;
@end
