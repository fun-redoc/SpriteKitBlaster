//
//  RSGameInput.m
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 18.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import "RSGameInput.h"

@implementation RSGameInput
@synthesize acceleration = _acceleration;
-(instancetype)initWithAcceleration:(Vector2d)a {
    if( self = [super init]) {
        _acceleration = a;
    }
    return self;
}
+(instancetype)GameInputWithAcceleration:(Vector2d)a {
    RSGameInput *inst = [[RSGameInput alloc] initWithAcceleration:a];
    return inst;
}
@end
