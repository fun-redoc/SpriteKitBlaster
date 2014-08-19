//
//  RSGameEntityProtocol.h
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 18.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSGameInput.h"
#include "globaldefs.h"

@protocol RSGameEntityProtocol <NSObject>

-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt;
@end
