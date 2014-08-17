//
//  RSMyScene.m
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 15.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import "RSMyScene.h"
#import "RSGameEntity.h"
#include "globaldefs.h"

@interface RSTurningSpriteNode : SKSpriteNode
@property (nonatomic) float angle;
@property (nonatomic) float lastAngle;
-(void)rotateTowards:(float)angle;
@end
@implementation RSTurningSpriteNode
-(void)rotateTowards:(float)angle {
    
    // Did the angle flip from +Pi to -Pi, or -Pi to +Pi?
    if (self.lastAngle  < -M_PI && angle > M_PI)
    {
        self.angle += M_PI * 2.0f;
    }
    else if (self.lastAngle  > M_PI && angle < -M_PI)
    {
        self.angle -= M_PI * 2.0f;
    }
    
    self.lastAngle = angle;
    
    const float RotationBlendFactor = 0.2f;
    self.angle = angle * RotationBlendFactor + self.angle * (1.0f - RotationBlendFactor);

    self.zRotation = NORMALIZE_ANGLE(self.angle);
}
@end


CollisionHandler fnVerticalCollisionHandler = ^(State e) {
        e.a.x = -e.a.x * BORLDER_COLLISION_DAMPING;
        e.v.x = -e.v.x * BORLDER_COLLISION_DAMPING;
        e.a.y = e.a.y * BORLDER_COLLISION_DAMPING;
        e.v.y = e.v.y * BORLDER_COLLISION_DAMPING;
    return e;
};

CollisionHandler fnHorizontalCollisionHandler = ^(State e) {
        e.a.x = e.a.x * BORLDER_COLLISION_DAMPING;
        e.v.x = e.v.x * BORLDER_COLLISION_DAMPING;
        e.a.y = -e.a.y * BORLDER_COLLISION_DAMPING;
        e.v.y = -e.v.y * BORLDER_COLLISION_DAMPING;
    return e;
};


@implementation RSMyScene {
    CGSize _winSize;
    RSTurningSpriteNode *_playerSprite;
    
    CMAcceleration _accelerometer;
    
    CMMotionManager *_motionManager;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _deltaTime;
    
    RSGameEntity *_player;
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:94.0/255.0 green:63.0/255.0 blue:107.0/255.0 alpha:1.0];
        
        _winSize = CGSizeMake(size.width, size.height);

        // init world
        _player = [[RSGameEntity alloc] initWithPosition:CGPointMake(_winSize.width/2, _winSize.height /2 )];
        
        // init view
        _playerSprite = [RSTurningSpriteNode spriteNodeWithImageNamed:@"Art/Images/Player"];
        _playerSprite.position = _player.p;
        [self addChild:_playerSprite];
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    _motionManager = [[CMMotionManager alloc] init];
    [self startMonitoringAcceleration];
}

-(void)willMoveFromView:(SKView *)view {
    [self stopMonitoringAcceleration];
    _motionManager = nil;
}


- (void)startMonitoringAcceleration
{
    if (_motionManager.accelerometerAvailable) {
        [_motionManager startAccelerometerUpdates];
        NSLog(@"accelerometer updates on...");
    }
}

- (void)stopMonitoringAcceleration
{
    if (_motionManager.accelerometerAvailable && _motionManager.accelerometerActive) {
        [_motionManager stopAccelerometerUpdates];
        NSLog(@"accelerometer updates off...");
    }
}


- (void)updatePlayerAccelerationFromMotionManager
{
    const double FilteringFactor = 0.75;

    CMAcceleration acceleration = _motionManager.accelerometerData.acceleration;
    
    // low pass filter to smoothen the movements of the device
    _accelerometer.x = acceleration.x * FilteringFactor + _accelerometer.x * (1.0 - FilteringFactor);
    _accelerometer.y = acceleration.y * FilteringFactor + _accelerometer.y * (1.0 - FilteringFactor);
    
}

-(void)updateInput:(NSTimeInterval) dt {
    [self updatePlayerAccelerationFromMotionManager];
}

-(void)updateWorld:(NSTimeInterval) dt {
    [_player accelerate:CGPointMake(_accelerometer.x, _accelerometer.y)
                     dt:dt
                  block: ^(RSGameEntity *e) {
                      State s = e.state;
                      if (s.p.x < 0.0f) {
                          s.p.x = 0.0f;
                          s = fnVerticalCollisionHandler(s);
                      } else if (s.p.x > _winSize.width) {
                          s.p.x = _winSize.width;
                          s = fnVerticalCollisionHandler(s);
                      }
                      
                      if (s.p.y < 0.0f)
                      {
                          s.p.y = 0.0f;
                          s = fnHorizontalCollisionHandler(s);
                      }
                      else if (s.p.y > _winSize.height)
                      {
                          s.p.y = _winSize.height;
                          s = fnHorizontalCollisionHandler(s);
                      }
                      e.state = s;
                  }];
//    [self playerCollisionWithBounds];
    
}

-(void)updateView:(NSTimeInterval) dt {
    _playerSprite.position = _player.p;
    
    float speedSquare = _player.v.x*_player.v.x + _player.v.y*_player.v.y;
    if (speedSquare > MIN_SPEED_TO_BE_ABLE_TO_TURN * MIN_SPEED_TO_BE_ABLE_TO_TURN ) {
        float angle = atan2f(_player.v.y, _player.v.x);
        [_playerSprite rotateTowards:angle];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //To compute velocities we need delta time to multiply by points per second
    //SpriteKit returns the currentTime, delta is computed as last called time - currentTime
    if (_lastUpdateTime) {
        _deltaTime = currentTime - _lastUpdateTime;
    } else {
        _deltaTime = 0;
    }
    _lastUpdateTime = currentTime;
    
    [self updateInput:_deltaTime];
    [self updateWorld:_deltaTime];
    [self updateView:_deltaTime];

}


@end
