//
//  RSUpdateProtocol.h
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 19.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSGameInput.h"
#import "RSGameEntity.h"

@protocol RSUpdateProtocol <NSObject>
-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt;
-(instancetype)updateWithEntity:(RSGameEntity *) entity;
@end
