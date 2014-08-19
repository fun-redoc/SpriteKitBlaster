//
//  RSGameEntity.m
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 17.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import "RSGameEntity.h"

@implementation RSGameEntity
@synthesize state = _state;
@synthesize fnUpdate = _fnUpdate;

-(instancetype)initWithPosition:(Vector2d)p andUpdateFunction:(void (^)(RSGameEntity *entity, RSGameInput *input, NSTimeInterval dt)) block {
    if( self = [super init] ) {
        State newS = self.state;
        newS.p = p;
        self.state = newS;
        self.fnUpdate = block;
    }
    return self;
}


-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt {
    // delegate update to a function, because update may depend on other world objects, but i dont want the calss depend on the other obects
    // TODO alternativelly try to build a masseg passing mechanism among the objects
    if(_fnUpdate ) _fnUpdate(self, input, dt);
    return self;
}


@end
