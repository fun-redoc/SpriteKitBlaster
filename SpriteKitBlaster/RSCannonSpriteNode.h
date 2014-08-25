//
//  RSTurretSpriteNode.h
//  SpriteKitBlaster
//
//  Created by Fun Fun on 19.08.14.
//  Copyright (c) 2014 Fun Fun. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RSUpdateProtocol.h"
#import "RSCannonEntity.h"

@interface RSCannonSpriteNode : SKSpriteNode <RSUpdateProtocol>
@property (nonatomic, strong) RSCannonEntity *entity;
-(instancetype)initWithImageNamed:(NSString *)imageName andEntity:(RSCannonEntity *) entity;
@end
