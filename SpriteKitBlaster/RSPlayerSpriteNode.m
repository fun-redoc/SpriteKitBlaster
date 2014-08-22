//
//  RSPlalerSpriteNode.m
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 19.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import "RSPlayerSpriteNode.h"

@interface RSPlayerSpriteNode()
@property (nonatomic) float angle;
@property (nonatomic) float lastAngle;
-(void)rotateTowards:(float)angle;
@end

@implementation RSPlayerSpriteNode
-(instancetype)initWithImageNamed:(NSString *)imageName andEntity:(RSGameEntityWithHealthAndSpin *) entity {
    if( self = [super initWithImageNamed:imageName] ) {
        self.entity = entity;
    }
    return self;
}

-(instancetype)update {
    [super update];
    self.position = self.entity.state.p  ;
    
    Vector2d v = self.entity.state.v;
    
    float speedSquare = v.x*v.x + v.y*v.y;
    if (speedSquare > MIN_SPEED_TO_BE_ABLE_TO_TURN * MIN_SPEED_TO_BE_ABLE_TO_TURN ) {
        
        float angle = atan2f(v.y, v.x);
        
        [self rotateTowards:angle];
    }
    
    return self;
}

-(void)rotateTowards:(float)angle {
    
    // Did the angle flip from +Pi to -Pi, or -Pi to +Pi?
    if (self.lastAngle - angle < -M_PI)
    {
        self.angle += M_PI * 2.0f;
    }
    else if (self.lastAngle - angle > M_PI )
    {
        self.angle -= M_PI * 2.0f;
    }
    
    self.lastAngle = angle;
    
    const float RotationBlendFactor = 0.2f;
    self.angle = angle * RotationBlendFactor + self.angle * (1.0f - RotationBlendFactor);
    
    self.zRotation = NORMALIZE_ANGLE(self.angle) - SK_DEGREES_TO_RADIANS(self.entity.spin);
}

@end
