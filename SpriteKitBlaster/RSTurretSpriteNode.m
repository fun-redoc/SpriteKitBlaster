//
//  RSTurretSpriteNode.m
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 19.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import "RSTurretSpriteNode.h"
#import "RSTurretEntity.h"

@implementation RSTurretSpriteNode
-(instancetype)initWithImageNamed:(NSString *)imageName andEntity:(RSTurretEntity *)entity {
    if (self = [super initWithImageNamed:imageName]) {
        self.entity = entity;
    }
    return self;
}

-(instancetype)update {
      Vector2d v = self.entity.shootVector;
      float angle = atan2f(v.y, v.x);

      // damping!
      const float RotationBlendFactor = 0.05f;
      float newRotationAngle = NORMALIZE_ANGLE(angle);
      float dampedNewRotationAngle = newRotationAngle*RotationBlendFactor + self.zRotation*(1.0f - RotationBlendFactor);
      self.zRotation = dampedNewRotationAngle;
    return self;
}
@end
