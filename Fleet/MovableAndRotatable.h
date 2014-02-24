//
//  MovableAndRotatable.h
//  Fleet
//
//  Created by Nicholas Beers on 2/24/14.
//  Copyright (c) 2014 com.peopleofthebit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MovableAndRotatable <NSObject>

@required
- (void) moveToPosition:(CGPoint) position;
//- (void) moveByVelocity:(CGPoint) velocity;
- (void) rotateTo:(CGPoint) position;
//- (void) rotateBy:(CGFloat) angle;

@end
