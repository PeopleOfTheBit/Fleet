//
//  SpriteObject.h
//  Fleet
//
//  Created by Nicholas Beers on 2/20/14.
//  Copyright (c) 2014 com.peopleofthebit. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SpriteKit;

@interface SpriteObject : SKSpriteNode

@property (nonatomic, readonly) CFTimeInterval timeCreated;

- (void) moveToPosition:(CGPoint) position;
//- (void) moveByVelocity:(CGPoint) velocity;
- (void) rotateTo:(CGPoint) position;
//- (void) rotateBy:(CGFloat) angle;

@end
