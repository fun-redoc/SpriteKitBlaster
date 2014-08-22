//
//  RSMyScene.m
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 15.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

@import CoreMotion;
@import AVFoundation;

#import "RSMyScene.h"
#import "RSGameInput.h"
#import "RSSpriteNode.h"
#import "RSPlayerSpriteNode.h"
#import "RSTurretSpriteNode.h"
#import "RSGameEntity.h"
#import "RSTurretEntity.h"
#import "RSHealthBar.h"
#import "RSHealthProtocol.h"
#import "RSGameEntityWithHealth.h"
#import "RSGameEntityWithHealthAndSpin.h"
#include "globaldefs.h"

@interface KVCTest : NSObject
@property (nonatomic) int testInt;
@end
@implementation KVCTest
@end

@interface RSSShootEntity : RSGameEntity
@property (nonatomic) float angle;
@property (nonatomic, readonly, getter = isFiring) BOOL firing;
-(void)fireWithAngle:(float) angle;
-(void)endFire;
@end
@implementation RSSShootEntity
@synthesize firing = _firing;
-(void)fireWithAngle:(float) angle {
    _angle = angle;
    _firing = YES;
}
-(void)endFire {
    _firing = NO;
}
@end

const float CannonCollisionRadius = 20.0f;
const float PlayerCollisionRadius = 10.0f;

@interface RSGameCollision : NSObject
@property (nonatomic, strong) RSGameEntity *entity1;
@property (nonatomic, strong) RSGameEntity *entity2;
@property (nonatomic, strong) void (^action)();
+(instancetype)entity1:(RSGameEntity *)e1 entity2:(RSGameEntity *)e2 action:(void (^)()) block;
@end
@implementation RSGameCollision
+(instancetype)entity1:(RSGameEntity *)e1 entity2:(RSGameEntity *)e2 action:(void (^)()) block {
    RSGameCollision *inst = [[RSGameCollision alloc] init];
    inst.entity1 = e1;
    inst.entity2 = e2;
    inst.action = block;
    return inst;
}
@end

@implementation RSMyScene {
    CGSize _winSize;
    
    CMAcceleration _accelerometer;
    
    CMMotionManager *_motionManager;
    
    CGPoint _touchLocation;
    CFTimeInterval _touchTime;
    UITouch *_touch;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _deltaTime;
    
    BOOL _fireEvent;
    
    NSMutableArray *_sprites;
    NSMutableArray *_entities;
    NSMutableArray *_collisions;
    
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
        
        _fireEvent = NO;
        
        _winSize = CGSizeMake(size.width, size.height);

        // init world
        __block RSGameEntityWithHealthAndSpin *playerEntity;
        __block RSTurretEntity *turretEntity;
        __block RSGameEntityWithHealth *cannonEntity;
        __block RSSShootEntity *playerShootEntity;
        
        _entities = @[
                      playerEntity = [[RSGameEntityWithHealthAndSpin alloc] initWithPosition:CGPointMake(_winSize.width - 60.0f, 50.0f )
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
                                                     
                                                                // adjust spinn
                                                                 RSGameEntityWithHealthAndSpin *me = (RSGameEntityWithHealthAndSpin *)entity;
                                                                 if (me.spin > 0.0f)
                                                                 {
                                                                     me.spin -= 2.0f * 360.0f * dt;
                                                                     if (me.spin < 0.0f)
                                                                     {
                                                                         me.spin = 0.0f;
                                                                     }
                                                                 }
                                                           }],
                        cannonEntity = [[RSGameEntityWithHealth alloc] initWithPosition:CGPointMake(_winSize.width /2, _winSize.height / 2 )
                                                           andUpdateFunction:NULL],
                        turretEntity =[[RSTurretEntity alloc] initWithPosition:CGPointMake(_winSize.width /2, _winSize.height / 2 )
                                                           andUpdateFunction:^(RSGameEntity * me, RSGameInput *intput, NSTimeInterval dt) {
                                                               RSTurretEntity *turret = (RSTurretEntity *)me;
                                                               turret.shootVector = CGPointMake(playerEntity.state.p.x - turret.state.p.x,
                                                                                                playerEntity.state.p.y - turret.state.p.y);
                                                           }],
                      playerShootEntity = [[RSSShootEntity alloc] initWithPosition:CGPointZero andUpdateFunction:^(RSGameEntity * me, RSGameInput *intput, NSTimeInterval dt) {
                          RSSShootEntity * myself = (RSSShootEntity *)me;
                          // TODO maybe not needed
                      }]
                      ].mutableCopy;
        
        playerEntity.collisionRadius = PlayerCollisionRadius;
        cannonEntity.collisionRadius = CannonCollisionRadius;
        
        
        __block RSMyScene *blockScene = self;
        _collisions = @[
                        [RSGameCollision entity1:playerEntity entity2:cannonEntity
                                          action:^() {
                                              [blockScene runAction:[SKAction playSoundFileNamed:@"Art/Sounds/Collision.wav" waitForCompletion:NO]];
                                              const float CannonCollisionSpeed = 200.0f;
                                              
                                              State s = playerEntity.state;
                                              float angle = atan2f(s.v.y, s.v.x);
                                              
                                              s.v.x = -cosf(angle) * CannonCollisionSpeed;
                                              s.v.y = -sinf(angle) * CannonCollisionSpeed;
                                              
                                              playerEntity.health = MAX(0, playerEntity.health - 20);
                                              cannonEntity.health = MAX(0, cannonEntity.health - 5);
                                              
                                              
                                              playerEntity.state = s;
                                              
                                              // kick off spinning
                                              playerEntity.spin = 180.0f * 3.0f;
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
                     [[RSHealthBar alloc] initEntity:playerEntity andSprite:player],
                     [[RSHealthBar alloc] initEntity:cannonEntity andSprite:cannon]
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_touch && !_fireEvent) {
        _touch = [touches anyObject];
        CGPoint location = [_touch locationInNode:self];
        _touchLocation = location;
        _touchTime = CACurrentMediaTime();
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    const float ignoreSwipesLonger = 0.3f;
    const float minSwipeLength = 4.0f;
    
    if (!_fireEvent && [touches containsObject:_touch]) {
        if( CACurrentMediaTime() - _touchTime < ignoreSwipesLonger ) {
            // measure a swipe length, to short is not a swipe
            CGPoint location = [_touch locationInNode:self];
            CGPoint diff = CGPointMake(location.x - _touchLocation.x, location.y - _touchLocation.y);
            float diffLength = sqrtf(diff.x*diff.x + diff.y*diff.y);
            if (diffLength > minSwipeLength) {
                //
                _touch = nil;
                _fireEvent = YES;
                
            }
        }

    }
    
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

- (BOOL)checkCollisionRadial:(RSGameEntity *)entity1 with:(RSGameEntity *)entity2 {
    float deltaX = entity1.state.p.x - entity2.state.p.x;
    float deltaY = entity1.state.p.y - entity2.state.p.y;
    
    float distance = sqrtf(deltaX*deltaX + deltaY*deltaY);
    float collisionRadius = entity1.collisionRadius + entity2.collisionRadius;
    
    return distance <= collisionRadius;    
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
    // TODO regiester fireInputEvent
    // TODO register when the ship can fire again
    RSGameInput *input= [RSGameInput GameInputWithAcceleration:self.acceleration];
    
    // handle collisions
    for (RSGameCollision *collision in _collisions) {
        if( [self checkCollisionRadial:collision.entity1 with:collision.entity2]) {
            collision.action();
        }
    }
    
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
