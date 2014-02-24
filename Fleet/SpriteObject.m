//
//  SpriteObject.m
//  Fleet
//
//  Created by Nicholas Beers on 2/20/14.
//  Copyright (c) 2014 com.peopleofthebit. All rights reserved.
//

#import "SpriteObject.h"
#import "MathFunctions.h"

const static float MOVE_SPEED = 500;
const static float ROTATE_SPEED = 30;

@interface SpriteObject()

@property (nonatomic) CFTimeInterval timeCreated;

@end

@implementation SpriteObject

- (id) initWithImageNamed:(NSString *) image {
    if(self = [super initWithImageNamed:image]) {
        _timeCreated = CFAbsoluteTimeGetCurrent();
    }
    return self;
}

- (void)moveToPosition:(CGPoint)position {
    [self rotateTo:position];
    
    CGFloat moveDuration = [self getMoveDurationTo:position];
    SKAction *moveAction = [SKAction moveTo:position duration:moveDuration];
    
    [self runAction:moveAction];
}

- (CGFloat) getMoveDurationTo:(CGPoint) position {
    CGFloat distanceBetweenSelfAndPosition = CGPointLength(CGPointSubtract(self.position, position));
    CGFloat duration = (distanceBetweenSelfAndPosition / MOVE_SPEED) + 0.1;
    
    return duration;
}

- (void)rotateTo:(CGPoint)position{
    CGFloat initialRotate = (M_PI * 3) / 2;
    CGPoint offset = CGPointSubtract(position, self.position);
    CGPoint direction = CGPointNormalize(offset);
    CGFloat targetAngle = CGPointToAngle(direction) + initialRotate;
    CGFloat rotateDuration = [self getRotateDurationTo:targetAngle];
    SKAction *rotateAction = [SKAction rotateToAngle:targetAngle duration:rotateDuration shortestUnitArc:YES];
    
    //If you try and rotate while no movement happened then a divide by zero will occur
    if([self distanceFromSelfToPositionIsZero:position])
        [self runAction:rotateAction];
}

- (CGFloat) getRotateDurationTo:(CGFloat)targetAngle {
    CGFloat duration = (targetAngle / ROTATE_SPEED) + 0.1;
    
    return duration;
}

//The SKAction method rotateToAngle:duration does not get perfectly to destination every time
//So I had to just check to see if the floats were close and not perfectly equal
- (bool) distanceFromSelfToPositionIsZero:(CGPoint)position {
    CGPoint distance = CGPointSubtract(self.position, position);
    return ABS(distance.x) > 0.01 && ABS(distance.y) > 0.01;
}

- (CGFloat) getTimeAlive {
    return CFAbsoluteTimeGetCurrent() - _timeCreated;
}

@end
