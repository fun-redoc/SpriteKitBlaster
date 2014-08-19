//
//  RSMyScene.m
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 15.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import "RSMyScene.h"
#import "RSGameEntityProtocol.h"
#import "RSGameInput.h"
#import "RSSpriteNode.h"
#import "RSGameEntity.h"
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


@interface RSTurretSprite : RSSpriteNode
@property (strong, nonatomic) Vector2d (^pointToVector)();
+(instancetype)spriteNodeWithImageNamed:(NSString *)imageName andEntity:(id<RSGameEntityProtocol>)entity pointToVectorBlock:(Vector2d (^)(State state)) block;

@end
@implementation RSTurretSprite
+(instancetype)spriteNodeWithImageNamed:(NSString *)imageName andEntity:(id<RSGameEntityProtocol>)entity pointToVectorBlock:(Vector2d (^)(State state)) block {
    RSTurretSprite *inst = [RSTurretSprite spriteNodeWithImageNamed:imageName];
    inst.entity = entity;
    inst.pointToVector = block;
    return inst;
}

-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt {
    [super updateWithInput:input dt:dt];
    Vector2d v = self.pointToVector(self.entity.state);
    float angle = atan2f(v.y, v.x);
    
    // damping!
    const float RotationBlendFactor = 0.05f;
    float newRotationAngle = NORMALIZE_ANGLE(angle);
    float dampedNewRotationAngle = newRotationAngle*RotationBlendFactor + self.zRotation*(1.0f - RotationBlendFactor);
    self.zRotation = dampedNewRotationAngle;
    
    return self;
}


@end

@interface RSPlayerEntity : RSGameEntity
@property (strong, nonatomic) void (^handleBoundsCollisionBlock) (RSGameEntity *e);
-(instancetype)initWithPosition:(Vector2d)p andBoundsCollisionBlock:(void (^)(RSGameEntity *e)) block;
//-(instancetype)accelerate:(Vector2d) a dt:(NSTimeInterval) dt block:(void (^)(RSGameEntity *e)) block;
@end
@implementation RSPlayerEntity

-(instancetype)initWithPosition:(Vector2d)p andBoundsCollisionBlock:(void (^)(RSGameEntity *e)) block {
    if( self = [super initWithPosition:p] ) {
        self.handleBoundsCollisionBlock = block;
    }
    return self;
}

-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt {
    return [[super updateWithInput:input dt:dt] accelerate:input.acceleration dt:dt block:self.handleBoundsCollisionBlock];
}

-(instancetype)accelerate:(Vector2d) a dt:(NSTimeInterval) dt block:(void (^)(RSGameEntity *e)) block {
    // when the device ist tilded add max accelerattion in the tilt direction
    // beware, because of the landscape mode tilt y-achses means movement x-axes
    State newS = self.state;
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
    
    self.state = newS;
    
    // handle collison with bounds
    
    block(self);
    
    return self;
}

@end



@interface RSPlayerSpriteNode : RSSpriteNode
@property (nonatomic) float angle;
@property (nonatomic) float lastAngle;
-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt;
@end
@implementation RSPlayerSpriteNode
+(instancetype)spriteNodeWithImageNamed:(NSString *)imageName andEntity:(id<RSGameEntityProtocol>)entity {
    RSPlayerSpriteNode *inst = [RSPlayerSpriteNode spriteNodeWithImageNamed:imageName];
    inst.entity = entity;
    return inst;
}

-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt {
    [super updateWithInput:input dt:dt];
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
    
    self.zRotation = NORMALIZE_ANGLE(self.angle);
}
@end

@implementation RSMyScene {
    CGSize _winSize;
    
    CMAcceleration _accelerometer;
    
    CMMotionManager *_motionManager;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _deltaTime;
    
    NSMutableArray *_sprites;
    
    RSPlayerSpriteNode *_playerSprite;

    
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
        // TODO
        
        // init view
        _sprites = @[
                     _playerSprite = [RSPlayerSpriteNode spriteNodeWithImageNamed:@"Art/Images/Player"
                                                        andEntity:[[RSPlayerEntity alloc] initWithPosition:CGPointMake(_winSize.width - 60.0f, 50.0f ) andBoundsCollisionBlock:^(RSGameEntity *e) {
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
                                                                         }]],
                     
                     [RSSpriteNode spriteNodeWithImageNamed:@"Art/Images/Cannon" andEntity:[[RSGameEntity alloc] initWithPosition:CGPointMake(_winSize.width /2, _winSize.height / 2 )]],
                     [RSTurretSprite spriteNodeWithImageNamed:@"Art/Images/Turret" andEntity:[[RSGameEntity alloc] initWithPosition:CGPointMake(_winSize.width /2, _winSize.height / 2 )]
                                           pointToVectorBlock:^(State state) {
                                               return CGPointMake(_playerSprite.entity.state.p.x - state.p.x,
                                                                  _playerSprite.entity.state.p.y - state.p.y);
                                           }]
                     
                     
                    ].mutableCopy;
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
    
    
    RSGameInput *input= [RSGameInput GameInputWithAcceleration:self.acceleration];
    for (id<RSGameEntityProtocol> sprite in _sprites) {
        [sprite updateWithInput:input dt:_deltaTime];
    }

}


@end
