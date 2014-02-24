//
//  MyScene.m
//  Fleet
//
//  Created by Nicholas Beers on 2/16/14.
//  Copyright (c) 2014 com.peopleofthebit. All rights reserved.
//

#import "MyScene.h"
#import "Ship.h"
#import "Fleet.h"



@implementation MyScene
{
    NSTimeInterval _lastUpdatedTime;
    NSTimeInterval _dt;
    CGPoint _lastTouchedPosition;
    Fleet *_mainFleet;
    Ship *_mainShip;
    bool _touchesInitialized;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor lightGrayColor];
        Ship *ship = [Ship shipAtPosition:CGPointMake(self.size.width/2, self.size.height/2)];
        [self addChild:ship];
        _mainShip = ship;
        _mainFleet = [Fleet fleetWithLeadShip:ship];
        
        _touchesInitialized = NO;
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _lastTouchedPosition = [touch locationInNode:self];
    if(!_touchesInitialized)
        _touchesInitialized = YES;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _lastTouchedPosition = [touch locationInNode:self];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _lastTouchedPosition = [touch locationInNode:self];
//    [_mainFleet spawnNewShip];
}

-(void)update:(CFTimeInterval)currentTime {
    if(_lastUpdatedTime)
        _dt = currentTime - _lastUpdatedTime;
    else
        _dt = 0;
    _lastUpdatedTime = currentTime;
    
    if(_touchesInitialized)
        [_mainShip moveToPosition:_lastTouchedPosition];
    
}

-(void) createShipAtPosition:(CGPoint) position {
    Ship *ship = [Ship shipAtPosition:position];
    [self addChild:ship];
}



@end
