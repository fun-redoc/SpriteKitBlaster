//
//  RSSpriteNode.m
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 18.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import "RSSpriteNode.h"


@implementation RSSpriteNode

+(instancetype)spriteNodeWithImageNamed:(NSString *)imageName andEntity:(RSGameEntity *)entity {
    RSSpriteNode *inst = [RSSpriteNode spriteNodeWithImageNamed:imageName];
    inst.entity = entity;
    return inst;
}

-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt {
    NSAssert(self.entity != NULL, @"Programming Error: property entity must not be NULL");
    [self.entity updateWithInput:input dt:dt];
    self.position = self.entity.state.p;
    return self;
}

@end
