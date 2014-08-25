//
//  RSCannonEntity.h
//  SpriteKitBlaster
//
//  Created by Roland Stellmach on 25.08.14.
//  Copyright (c) 2014 Roland Stellmach. All rights reserved.
//

#import "RSGameEntity.h"

@protocol RSCannonShootProtocol <NSObject>
-(void)shoot;
@end


@interface RSCannonEntity : RSGameEntity
@property (nonatomic) Vector2d shootVector;
@property (nonatomic, weak) id<RSCannonShootProtocol> delegate;
@end
