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
@property (strong, nonatomic) RSGameEntity *entity;
//@property (nonatomic, readonly) Vector2d acceleration;
+(instancetype)spriteNodeWithImageNamed:(NSString *)imageName andEntity:(RSGameEntity *) entity;
@end
