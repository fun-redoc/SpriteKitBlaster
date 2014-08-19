//
//  RSSpriteNodeWithHealthBar.m
//  SpriteKitBlaster
//
//  Created by Fun Redoc on 19.08.14.
//  Copyright (c) 2014 Fun Redoc. All rights reserved.
//

#import "RSSpriteNodeWithHealthBar.h"
#import "RSGameEntityWithHealth.h"

const int MaxHP = 100;
const float HealthBarWidth = 40.0f;
const float HealthBarHeight = 4.0f;


@implementation RSSpriteNodeWithHealthBar {
    SKNode *_healthBar;
}

+(instancetype)spriteNodeWithImageNamed:(NSString *)imageName andEntity:(RSGameEntityWithHealth *)entity {
    RSSpriteNodeWithHealthBar *inst = [RSSpriteNodeWithHealthBar spriteNodeWithImageNamed:imageName];
    inst.entity = entity;
    return inst;
}

-(instancetype)updateWithInput:(RSGameInput *)input dt:(NSTimeInterval)dt {
    [super updateWithInput:input dt:dt];
    
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
