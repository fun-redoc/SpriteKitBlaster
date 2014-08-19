//
//  RSGameInput.h
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 18.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "globaldefs.h"

@interface RSGameInput : NSObject
@property (nonatomic, readonly) Vector2d acceleration;
+(instancetype)GameInputWithAcceleration:(Vector2d)a;
@end
