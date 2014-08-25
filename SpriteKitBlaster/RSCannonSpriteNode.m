//
//  RSTurretSpriteNode.m
//  SpriteKitBlaster
//
//  Created by Fun Fun on 19.08.14.
//  Copyright (c) 2014 Fun Fun. All rights reserved.
//

#import "RSCannonSpriteNode.h"

@implementation RSCannonSpriteNode
-(instancetype)initWithImageNamed:(NSString *)imageName andEntity:(RSCannonEntity *)entity {
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
