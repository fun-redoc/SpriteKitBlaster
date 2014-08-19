//
//  RSSpriteNode.h
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 18.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RSGameEntity.h"
#include "globaldefs.h"

@interface RSSpriteNode : SKSpriteNode<RSGameEntityProtocol>
+(instancetype)spriteNodeWithImageNamed:(NSString *)imageName andUpdateFunction:(void (^)(RSSpriteNode *sprite, RSGameInput *input, NSTimeInterval dt)) block;
@property (nonatomic, weak) void (^fnUpdate)(RSSpriteNode *sprite, RSGameInput *input, NSTimeInterval dt);
@end
