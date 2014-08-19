//
//  RSSpriteNode.h
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 18.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RSGameEntity.h"
#include "globaldefs.h"

@interface RSSpriteNode : SKSpriteNode<RSGameEntityProtocol>
+(instancetype)spriteNodeWithImageNamed:(NSString *)imageName andUpdateFunction:(void (^)(RSSpriteNode *sprite, RSGameInput *input, NSTimeInterval dt)) block;
@property (nonatomic, weak) void (^fnUpdate)(RSSpriteNode *sprite, RSGameInput *input, NSTimeInterval dt);
@end
