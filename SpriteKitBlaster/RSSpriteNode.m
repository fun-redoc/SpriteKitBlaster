//
//  RSSpriteNode.m
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 18.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import "RSSpriteNode.h"


@implementation RSSpriteNode
@synthesize fnUpdate = _fnUpdate;

+(instancetype)spriteNodeWithImageNamed:(NSString *)imageName andUpdateFunction:(void (^)(RSSpriteNode *sprite, RSGameInput *input, NSTimeInterval dt)) block {
    RSSpriteNode *inst = [RSSpriteNode spriteNodeWithImageNamed:imageName];
    inst.fnUpdate = block;
    return inst;
}

-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt {
    if(_fnUpdate) _fnUpdate(self, input,dt);
    return self;
}

@end
