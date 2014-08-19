//
//  RSMyScene.m
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 15.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import "RSMyScene.h"
#import "RSGameInput.h"
#import "RSSpriteNode.h"
#import "RSPlayerSpriteNode.h"
#import "RSTurretSpriteNode.h"
#import "RSGameEntity.h"
#import "RSTurretEntity.h"
#import "RSHealthBar.h"
#import "RSHealthProtocol.h"
#include "globaldefs.h"

@interface KVCTest : NSObject
@property (nonatomic) int testInt;
@end
@implementation KVCTest
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

State accelerate(State state, Vector2d a, NSTimeInterval dt) {
    // when the device ist tilded add max accelerattion in the tilt direction
    // beware, because of the landscape mode tilt y-achses means movement x-axes
    State newS = state;
    Vector2d newA = newS.a;
    if (a.y > TILT_DEVICE_ACCELERATION)
    {
        newA.x = -MAX_PLAYER_ACCELERATION;
    }
    else if (a.y < -TILT_DEVICE_ACCELERATION)
    {
        newA.x = MAX_PLAYER_ACCELERATION;
    }
    if (a.x < -TILT_DEVICE_ACCELERATION)
    {
        newA.y = -MAX_PLAYER_ACCELERATION;
    }
    else if (a.x > TILT_DEVICE_ACCELERATION)
    {
        newA.y = MAX_PLAYER_ACCELERATION;
    }
    newS.a = newA;
    
    // calculate the new speed (Newton Approximation), und clamp
    Vector2d newV = newS.v;
    newV.x += newS.a.x * dt;
    newV.y += newS.a.y * dt;
    newV.x = fmaxf(fminf(newV.x, MAX_PLAYER_SPEED), -MAX_PLAYER_SPEED);
    newV.y = fmaxf(fminf(newV.y, MAX_PLAYER_SPEED), -MAX_PLAYER_SPEED);
    newS.v = newV;
    
    // calculate the new position in the world
    Vector2d newP = newS.p;
    newP.x = newS.p.x + newS.v.x*dt;
    newP.y = newS.p.y + newS.v.y*dt;
    newS.p = newP;
    
    return newS;
}

@interface RSGameEntityWithHealth : RSGameEntity<RSHealthProtocol>
//@property (nonatomic) int health;
@end
@implementation RSGameEntityWithHealth
@synthesize health = _health;
-(instancetype)initWithPosition:(Vector2d)p andUpdateFunction:(void (^)(RSGameEntity *entity, RSGameInput *input, NSTimeInterval dt)) block;{
    if (self = [super initWithPosition:p andUpdateFunction:block]) {
        _health = MAX_HEALTH_VAL;
    }
    return self;
}

@end


@implementation RSMyScene {
    CGSize _winSize;
    
    CMAcceleration _accelerometer;
    
    CMMotionManager *_motionManager;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _deltaTime;
    
    NSMutableArray *_sprites;
    NSMutableArray *_entities;
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%@.%@ is now %@ but was %@", object, keyPath, [change objectForKey: NSKeyValueChangeNewKey], [change objectForKey: NSKeyValueChangeOldKey]);
}

-(id)initWithSize:(CGSize)size {
    
    KVCTest *kvcTest = [[KVCTest alloc] init];
    [kvcTest addObserver:self forKeyPath:@"testInt" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    NSLog(@"now");
    [kvcTest setValue:@42 forKey:@"testInt"];
    [kvcTest removeObserver:self forKeyPath:@"testInt"];
    int val = [[kvcTest valueForKey:@"testInt"] intValue];
    NSCAssert(val == 42, @"lajsdflkajsldkfj");
    
    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:94.0/255.0 green:63.0/255.0 blue:107.0/255.0 alpha:1.0];
        
        _winSize = CGSizeMake(size.width, size.height);

        // init world
        __block RSGameEntityWithHealth *playerEntity;
        __block RSTurretEntity *turretEntity;
        __block RSGameEntityWithHealth *cannonEntity;
        
        _entities = @[
                      playerEntity = [[RSGameEntityWithHealth alloc] initWithPosition:CGPointMake(_winSize.width - 60.0f, 50.0f )
                                                             andUpdateFunction:^(RSGameEntity * entity, RSGameInput *input, NSTimeInterval dt) {
                                                                             State s = accelerate(entity.state, input.acceleration, dt);
                                                                             // clamp movement inside the bounds of screen
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
                                                                             entity.state = s;
                                                           }],
                        cannonEntity = [[RSGameEntityWithHealth alloc] initWithPosition:CGPointMake(_winSize.width /2, _winSize.height / 2 )
                                                           andUpdateFunction:NULL],
                        turretEntity =[[RSTurretEntity alloc] initWithPosition:CGPointMake(_winSize.width /2, _winSize.height / 2 )
                                                           andUpdateFunction:^(RSGameEntity * me, RSGameInput *intput, NSTimeInterval dt) {
                                                               RSTurretEntity *turret = (RSTurretEntity *)me;
                                                               turret.shootVector = CGPointMake(playerEntity.state.p.x - turret.state.p.x,
                                                                                                playerEntity.state.p.y - turret.state.p.y);
                                                           }]
                      ].mutableCopy;
        
        // init view
        RSPlayerSpriteNode *player;
        RSSpriteNode *cannon;
        RSTurretSpriteNode *turret;
        _sprites = @[
                     player = [[RSPlayerSpriteNode alloc ] initWithImageNamed:@"Art/Images/Player" andEntity:playerEntity],
                     cannon = [[RSSpriteNode alloc] initWithImageNamed:@"Art/Images/Cannon"],
                     turret = [[RSTurretSpriteNode alloc] initWithImageNamed:@"Art/Images/Turret" andEntity:turretEntity],
                     [[RSHealthBar alloc] initEntity:playerEntity andSprite:player]
                    ].mutableCopy;
        
        
        cannon.position = CGPointMake(_winSize.width /2, _winSize.height / 2 );
        turret.position = CGPointMake(_winSize.width /2, _winSize.height / 2 );
        
        for (SKNode *sprite in _sprites) {
            [self addChild:sprite];
        }
        
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

- (Vector2d)acceleration {
    const double FilteringFactor = 0.75;
    
    CMAcceleration acceleration = _motionManager.accelerometerData.acceleration;
    
    // low pass filter to smoothen the movements of the device
    _accelerometer.x = acceleration.x * FilteringFactor + _accelerometer.x * (1.0 - FilteringFactor);
    _accelerometer.y = acceleration.y * FilteringFactor + _accelerometer.y * (1.0 - FilteringFactor);
    
    return CGPointMake(_accelerometer.x, _accelerometer.y);
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
    
    
    // transform input into world events
    RSGameInput *input= [RSGameInput GameInputWithAcceleration:self.acceleration];
    
    // update world
    for (RSGameEntity *entity in _entities) {
        [entity updateWithInput:input dt:_deltaTime];
    }
    
    // update view
    for (RSSpriteNode *sprite in _sprites) {
        [sprite update];
    }

}


@end
