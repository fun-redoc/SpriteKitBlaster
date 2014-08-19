//
//  RSTurretSpriteNode.h
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 19.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RSUpdateProtocol.h"
#import "RSTurretEntity.h"

@interface RSTurretSpriteNode : SKSpriteNode <RSUpdateProtocol>
@property (nonatomic, strong) RSTurretEntity *entity;
-(instancetype)initWithImageNamed:(NSString *)imageName andEntity:(RSTurretEntity *) entity;
@end
