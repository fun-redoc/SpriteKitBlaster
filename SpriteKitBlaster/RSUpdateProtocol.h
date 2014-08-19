//
//  RSUpdateProtocol.h
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 19.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSGameInput.h"
#import "RSGameEntity.h"

@protocol RSUpdateProtocol <NSObject>
-(instancetype)update;
@end
