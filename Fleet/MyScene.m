//
//  MyScene.m
//  Fleet
//
//  Created by Nicholas Beers on 2/15/14.
//  Copyright (c) 2014 com.peopleofthebit. All rights reserved.
//

#import "MyScene.h"

static const float SWARM_MOVE_POINTS_PER_SEC = 220.0;
static const float SHIP_MOVE_POINTS_PER_SEC = 220.0;
static const float SHIP_ROTATE_RADIANS_PER_SEC = 4 * M_PI;
static const float BG_POINTS_PER_SEC = 40;
static const int NUMBER_OF_SHIP_IMAGES = 48;
static const float SHIP_SCALE = 0.25;
static const float ASTEROID_SCALE = 0.05;

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}
static inline CGPoint CGPointSubtract(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}
static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}
static inline CGFloat CGPointLength(const CGPoint a)
{
    return sqrtf(a.x * a.x + a.y * a.y);
}
static inline CGPoint CGPointNormalize(const CGPoint a)
{
    CGFloat length = CGPointLength(a);
    return CGPointMake(a.x / length, a.y / length);
}
static inline CGFloat CGPointToAngle(const CGPoint a)
{
    return atan2f(a.y, a.x);
}
static inline CGFloat ScalarSign(CGFloat a)
{
    return a >= 0 ? 1 : -1;
}
static inline CGFloat ScalarShortestAngleBetween(const CGFloat a, const CGFloat b)
{
    CGFloat difference = b - a;
    CGFloat angle = fmodf(difference, M_PI * 2);
    if (angle >= M_PI) {
        angle -= M_PI * 2;
    }
    else if (angle <= -M_PI) {
        angle += M_PI * 2;
    }
    return angle;
}

#define ARC4RANDOM_MAX 0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max) {
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min));
}


@implementation MyScene
{
        SKSpriteNode *_swarm;
        CGPoint _velocity;
        NSTimeInterval _lastUpdateTime;
        NSTimeInterval _dt;
        CGPoint _lastTouchLocation;
        int _shipNumber;
        SKSpriteNode *_asteroid;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
        
        
        //self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        _shipNumber = 1;
        
        _swarm = [SKSpriteNode node];
        _swarm.position = CGPointMake(100.0f, self.size.height/2);
        [_swarm setSize:CGSizeMake(10.0, 10.0)];
        _swarm.color = [SKColor redColor];
        [self addChild:_swarm];
        
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(spawnEnemy) onTarget:self], [SKAction waitForDuration:2.0]]]]];
        
        [self runAction:[SKAction repeatActionForever: [SKAction sequence:@[[SKAction performSelector:@selector(spawnAsteroid)onTarget:self], [SKAction waitForDuration:1.0]]]]];

       
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(_lastUpdateTime){
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    
    
    [self moveSprite:_swarm velocity:_velocity];
    [self boundsCheckPlayer];
    [self rotateSprite:_swarm toFace:_velocity rotateRadiansPerSec:SHIP_ROTATE_RADIANS_PER_SEC];
    [self moveSwarm];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveSwarmTowards:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveSwarmTowards:touchLocation];
    _lastTouchLocation = touchLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    _lastTouchLocation = touchLocation;
    [self moveSwarmTowards:touchLocation];
}

- (void) didEvaluateActions
{
    [self checkCollisions];
}

- (void)spawnEnemy {
    SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithImageNamed:@"iron1"];
    enemy.name = @"enemy";
    [enemy setScale:0.1];
    SKAction *turnBrownishRedAction = [SKAction colorizeWithColor:[UIColor colorWithRed:0.8f green:0.3f blue:0.3f alpha:1.0f] colorBlendFactor:0.7f duration:0.0];
    [enemy runAction:turnBrownishRedAction];
    CGPoint enemyScenePos = CGPointMake(self.size.width + enemy.size.width/2, ScalarRandomRange(enemy.size.height/2, self.size.height - enemy.size.height/2));
    enemy.position = enemyScenePos;
    
    [self addChild:enemy];
    _asteroid = enemy;
    
    SKAction *actionRemove = [SKAction removeFromParent];
    SKAction *actionMove = [SKAction moveByX:-(enemy.size.width/2 + self.size.width) y:0.0f duration:2.0];
    [enemy runAction:[SKAction sequence:@[actionMove, actionRemove]]];
}

- (void)spawnAsteroid {
    SKSpriteNode *asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid1"];
    asteroid.name = @"asteroid";
    CGPoint asteroidScenePos = CGPointMake( ScalarRandomRange(0, self.size.width), ScalarRandomRange(0, self.size.height));
    asteroid.position = asteroidScenePos;
    asteroid.xScale = 0;
    asteroid.yScale = 0;
    [self addChild:asteroid];
    
    asteroid.zRotation = -M_PI / 16;
    SKAction *wiggleLeft = [SKAction rotateByAngle:M_PI / 8 duration:0.5f];
    SKAction *wiggleRight = [wiggleLeft reversedAction];
    SKAction *fullWiggle = [SKAction sequence:@[wiggleLeft, wiggleRight]];
    SKAction *scaleUp = [SKAction scaleBy:1.25f duration:0.25f];
    SKAction *scaleDown = [scaleUp reversedAction];
    SKAction *fulScale = [SKAction sequence:@[scaleUp, scaleDown, scaleUp, scaleDown]];
    SKAction *group = [SKAction group:@[fulScale, fullWiggle]];
    SKAction *groupWait = [SKAction repeatAction:group count:10];
    
    SKAction *appear = [SKAction scaleTo:ASTEROID_SCALE duration:0.5];
    SKAction *disappear = [SKAction scaleTo:0.0 duration:0.5];
    SKAction *removeFromParent = [SKAction removeFromParent];
    [asteroid runAction:[SKAction sequence:@[appear, groupWait, disappear, removeFromParent]]];
}

- (void) spawnShipAtPosition:(CGPoint)position
{
    if(_shipNumber > NUMBER_OF_SHIP_IMAGES)
        _shipNumber = 1;
    NSString *shipNamed = [NSString stringWithFormat:@"ship%i", _shipNumber++];
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:shipNamed];
    [ship setScale:SHIP_SCALE];
    ship.name = @"ship";
    ship.position = position;
    ship.zRotation = _swarm.zRotation;
    ship.zPosition = 100;
    [self addChild:ship];
}

- (void)checkCollisions {
    [self enumerateChildNodesWithName:@"asteroid"
                               usingBlock:^(SKNode *node, BOOL *stop){
                                   SKSpriteNode *asteroid = (SKSpriteNode *)node;
                                   if (CGRectIntersectsRect(asteroid.frame, _swarm.frame)) {
                                       [asteroid removeAllActions];
                                       [self spawnShipAtPosition:asteroid.position];
                                       [asteroid removeFromParent];
                                   }
                               }];
    [self enumerateChildNodesWithName:@"ship"
                           usingBlock:^(SKNode *node, BOOL *stop){
                               SKSpriteNode *ship = (SKSpriteNode *)node;
                               if (CGRectIntersectsRect(ship.frame, _asteroid.frame)) {
                                   [ship removeAllActions];
                                   [ship removeFromParent];
                               }
                           }];
}

- (void)moveSwarm {
    __block CGPoint targetPosition = _swarm.position;
    [self enumerateChildNodesWithName:@"ship" usingBlock:^(SKNode *node, BOOL *stop){
        if (!node.hasActions) {
            float actionDuration = 0.3;
            CGPoint offset = CGPointSubtract(targetPosition, node.position);
            CGPoint direction = CGPointNormalize(offset);
            CGPoint amountToMovePerSec = CGPointMultiplyScalar(direction, SHIP_MOVE_POINTS_PER_SEC);
            CGPoint amountToMove = CGPointMultiplyScalar(amountToMovePerSec, actionDuration);
            SKAction *moveAction = [SKAction moveByX:amountToMove.x y:amountToMove.y duration:actionDuration];
            
            float initialRotate = (M_PI * 3) / 2;
            float shortest = ScalarShortestAngleBetween(node.zRotation, CGPointToAngle(direction) + initialRotate);
            float amtToRotate = M_PI  * actionDuration;
            if(ABS(shortest) < amtToRotate){
                amtToRotate = ABS(shortest);
            }
            CGFloat angle = ScalarSign(shortest) * amtToRotate * 1.5;
            SKAction *rotate = [SKAction rotateByAngle:angle duration:actionDuration];
            SKAction *moveSwarm = [SKAction group:@[moveAction, rotate]];
            
            [node runAction:moveSwarm];
        }
        targetPosition = node.position;
    }];
}

- (void)moveSprite:(SKSpriteNode *)sprite velocity:(CGPoint)velocity
{
    CGPoint amountToMove = CGPointMultiplyScalar(velocity, _dt);
    sprite.position = CGPointAdd(sprite.position, amountToMove);
}

- (void)moveSwarmTowards:(CGPoint)location
{
    CGPoint offset = CGPointSubtract(location, _swarm.position);
    CGPoint direction = CGPointNormalize(offset);
    _velocity = CGPointMultiplyScalar(direction, SWARM_MOVE_POINTS_PER_SEC);
}

- (void)boundsCheckPlayer {
    CGPoint newPosition = _swarm.position;
    CGPoint newVelocity = _velocity;

    CGPoint bottomLeft = CGPointZero;
    CGPoint topRight = CGPointMake(self.size.width, self.size.height);
    
    if (newPosition.x <= bottomLeft.x) {
        newPosition.x = bottomLeft.x; newVelocity.x = -newVelocity.x;
    }
    if (newPosition.x >= topRight.x) {
        newPosition.x = topRight.x;
        newVelocity.x = -newVelocity.x;
    }
    if (newPosition.y <= bottomLeft.y){
        newPosition.y = bottomLeft.y; newVelocity.y = -newVelocity.y;
    }
    if (newPosition.y >= topRight.y) {
        newPosition.y = topRight.y;
        newVelocity.y = -newVelocity.y;
    }

    _swarm.position = newPosition;
    _velocity = newVelocity;
}

- (void)rotateSprite:(SKSpriteNode *)sprite toFace:(CGPoint)velocity rotateRadiansPerSec:(CGFloat)rotateRadiansPerSec
{
    float initialRotate = (M_PI * 3) / 2;
    
    float targetAngle = CGPointToAngle(velocity) + initialRotate;
    
    float shortest = ScalarShortestAngleBetween(sprite.zRotation, targetAngle);
    
    float amtToRotate = rotateRadiansPerSec * _dt;
    
    if(ABS(shortest) < amtToRotate){
        amtToRotate = ABS(shortest);
    }
    sprite.zRotation += ScalarSign(shortest) * amtToRotate;
}



@end
