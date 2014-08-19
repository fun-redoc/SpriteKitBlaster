//
//  RSSpriteNodeWithHealthBar.h
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 19.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RSUpdateProtocol.h"
#import "RSHealthProtocol.h"
#import "RSGameEntity.h"
#import "RSSpriteNode.h"
#include "globaldefs.h"

#define MAX_HEALTH_VAL 100

@interface RSHealthBar : SKNode <RSUpdateProtocol>
@property (nonatomic, strong) RSGameEntity<RSHealthProtocol> *entity;
@property (nonatomic, strong) RSSpriteNode *sprite;
-(instancetype)initEntity:(RSGameEntity<RSHealthProtocol> *)entity andSprite:(RSSpriteNode *)sprite;
@end
