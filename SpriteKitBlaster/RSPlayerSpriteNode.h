//
//  RSPlalerSpriteNode.h
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 19.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import "RSSpriteNode.h"
#import "RSGameEntityWithHealthAndSpin.h"

@interface RSPlayerSpriteNode : RSSpriteNode
@property (nonatomic, strong) RSGameEntityWithHealthAndSpin *entity;
-(instancetype)initWithImageNamed:(NSString *)imageName andEntity:(RSGameEntityWithHealthAndSpin *) entity;;
@end
