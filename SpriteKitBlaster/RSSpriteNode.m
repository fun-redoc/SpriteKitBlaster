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

-(instancetype)initWithImageNamed:(NSString *)imageName andUpdateFunction:(void (^)(RSSpriteNode *sprite, RSGameInput *input, NSTimeInterval dt)) block {
    if (self = [super initWithImageNamed:imageName]) {
        self.fnUpdate = block;
    }
    return self;
}

-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt {
    if(_fnUpdate) {
        __block id blockSelf = self;
        _fnUpdate(blockSelf, input, dt);
    }
    return self;
}

@end
