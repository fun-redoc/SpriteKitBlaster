//
//  RSCannonEntity.m
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 25.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import "RSCannonEntity.h"
#define MAX_TIME_INTERVAL 10.0f

@implementation RSCannonEntity
-(instancetype)initWithPosition:(Vector2d)p andUpdateFunction:(void (^)(RSGameEntity *entity, RSGameInput *input, NSTimeInterval dt)) block {
    if( self = [super initWithPosition:p andUpdateFunction:block] ) {
        srand48(time(0)); // seed the random genertor
        [self shoot];
    }
    return self;
}
-(void)shoot {
    if (self.delegate) {
        [self.delegate shoot];
    }
    [self performSelector:@selector(shoot) withObject:self afterDelay:drand48()*MAX_TIME_INTERVAL];
}
@end
