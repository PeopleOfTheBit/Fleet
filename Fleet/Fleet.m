//
//  Fleet.m
//  Fleet
//
//  Created by Nicholas Beers on 2/20/14.
//  Copyright (c) 2014 com.peopleofthebit. All rights reserved.
//

#import "Fleet.h"
#import "Ship.h"
@import SpriteKit;

typedef enum {
    Leader,
    Follower
} Rank;

@interface Fleet()

@property (nonatomic, retain) NSMutableArray *followingShips;
@property (nonatomic, strong) Ship *leadShip;

@end

@implementation Fleet

+ (Fleet *) fleetWithLeadShip:(Ship *) ship{
    Fleet *fleet = [[Fleet alloc] initWithShip:ship];
    
    return fleet;
}

- (id) initWithShip:(Ship *) ship {
    if(self = [super init]){
        _followingShips = [[NSMutableArray alloc] init];
        [self addShipToFleet:ship];
        [self chooseLeadShip];
    }
    return self;
}

- (void) chooseLeadShip {
    if([self fleetHasShips]) {
        __block NSUInteger indexOfOldestShip = 0;
        [_followingShips enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isKindOfClass:[Ship class]]){
                Ship *oldestShip = [_followingShips objectAtIndex:indexOfOldestShip];
                Ship *nextShip = (Ship *)obj;
                if(nextShip.timeCreated > oldestShip.timeCreated)
                    indexOfOldestShip = idx;
            }
        }];
        _leadShip = [_followingShips objectAtIndex:indexOfOldestShip];
        [_followingShips removeObjectAtIndex:indexOfOldestShip];
        [self addFleetRingtoShip:_leadShip ForRank:Leader];
    }
}

- (bool) fleetHasShips {
    if ([_followingShips count] == 0){
        //Delete yourself?
        return NO;
    }
    return YES;
}

- (void) addShipToFleet:(Ship *)ship {
    [_followingShips addObject:ship];
    [self addFleetRingtoShip:ship ForRank:Follower];
}

- (SKSpriteNode *) createFleetRingForRank:(Rank)rank {
    NSString *ringType;
    if(rank == Leader)
        ringType = @"leaderRing";
    else if(rank == Follower)
        ringType = @"followerRing";
    
    SKSpriteNode *fleetRing = [SKSpriteNode spriteNodeWithImageNamed:ringType];
    fleetRing.anchorPoint = CGPointMake(0.5, 0.5);
    fleetRing.zPosition = 70;
    fleetRing.name = @"fleetRing";
    [fleetRing setScale:0.75];
    
    SKAction *rotateAction = [SKAction rotateByAngle:M_PI * 2 duration:10.0];
    SKAction *repeatRotationForeverAction = [SKAction repeatActionForever:rotateAction];
    [fleetRing runAction:repeatRotationForeverAction];
    return fleetRing;
}

- (void) spawnNewShip {
    Ship *ship = [Ship shipAtPosition:_leadShip.position];
    ship.zRotation = _leadShip.zRotation;
    [[_leadShip parent] addChild:ship];
    [self addShipToFleet:ship];
}

- (void) addFleetRingtoShip:(Ship *)ship ForRank:(Rank)rank {
    [self removeFleetRingFromShip:ship];
    SKSpriteNode *fleetRing = [self createFleetRingForRank:rank];
    [ship addChild:fleetRing];
}

- (void) removeFleetRingFromShip:(Ship *)ship {
    [ship enumerateChildNodesWithName:@"fleetRing" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
}

@end
