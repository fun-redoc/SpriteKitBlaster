//
//  RSSpriteNodeWithHealthBar.m
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 19.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import "RSHealthBar.h"
#import "RSSpriteNode.h"

const int MaxHP = MAX_HEALTH_VAL;
const float HealthBarWidth = 40.0f;
const float HealthBarHeight = 4.0f;


@implementation RSHealthBar

-(instancetype)initEntity:(RSGameEntity<RSHealthProtocol> *)entity andSprite:(RSSpriteNode *)sprite {
    if (self = [super init]) {
        self.entity = entity;
        self.sprite = sprite;
    }
    return self;
}

-(instancetype)update {
    self.position = CGPointMake( self.sprite.position.x - HealthBarWidth/2.0f + 0.5f,
                                 self.sprite.position.y - self.sprite.size.height/2.0f - 15.0f + 0.5f);
    [self drawHealthBar:self withName:[self.entity.class description] andHealthPoints:self.entity.health];
        return self;
}


-(void) drawHealthBar:(SKNode *)node withName:(NSString *)name andHealthPoints:(int)hp
{
    [node removeAllChildren];
    
    float widthOfHealth = (HealthBarWidth - 2.0f)*hp/MaxHP;
    
    UIColor *clearColor = [UIColor clearColor];
    UIColor *fillColor = [UIColor colorWithRed:113.0f/255.0f green:202.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
    UIColor *borderColor = [UIColor colorWithRed:35.0f/255.0f green:28.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
    
    //create the outline for the health bar
    CGSize outlineRectSize = CGSizeMake(HealthBarWidth-1.0f, HealthBarHeight-1.0);
    UIGraphicsBeginImageContextWithOptions(outlineRectSize, NO, 0.0);
    CGContextRef healthBarContext = UIGraphicsGetCurrentContext();
    
    //Drawing the outline for the health bar
    CGRect spriteOutlineRect = CGRectMake(0.0, 0.0, HealthBarWidth-1.0f, HealthBarHeight-1.0f);
    CGContextSetStrokeColorWithColor(healthBarContext, borderColor.CGColor);
    CGContextSetLineWidth(healthBarContext, 1.0);
    CGContextAddRect(healthBarContext, spriteOutlineRect);
    CGContextStrokePath(healthBarContext);
    
    //Fill the health bar with a filled rectangle
    CGRect spriteFillRect = CGRectMake(0.5, 0.5, outlineRectSize.width-1.0, outlineRectSize.height-1.0);
    spriteFillRect.size.width = widthOfHealth;
    CGContextSetFillColorWithColor(healthBarContext, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(healthBarContext, clearColor.CGColor);
    CGContextSetLineWidth(healthBarContext, 1.0);
    CGContextFillRect(healthBarContext, spriteFillRect);
    
    //Generate a sprite image of the two pieces for display
    UIImage *spriteImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef spriteCGImageRef = [spriteImage CGImage];
    SKTexture *spriteTexture = [SKTexture textureWithCGImage:spriteCGImageRef];
    spriteTexture.filteringMode = SKTextureFilteringLinear; //This is the default anyway
    SKSpriteNode *frameSprite = [SKSpriteNode spriteNodeWithTexture:spriteTexture size:outlineRectSize];
    frameSprite.position = CGPointZero;
    frameSprite.name = name;
    frameSprite.anchorPoint = CGPointMake(0.0, 0.5);
    
    [node addChild:frameSprite];
}


@end
