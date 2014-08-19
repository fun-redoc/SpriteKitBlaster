//
//  RSGameEntity.m
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 17.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import "RSGameEntity.h"

@implementation RSGameEntity
@synthesize state = _state;

-(instancetype)initWithPosition:(Vector2d)p {
    if( self = [super init] ) {
        State newS = self.state;
        newS.p = p;
        self.state = newS;
    }
    return self;
}


-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt {
    return self;
}


@end
