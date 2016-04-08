//
//  GameScene.m
//  ColorfulBalls
//
//  Created by 武淅 段 on 16/4/8.
//  Copyright (c) 2016年 武淅 段. All rights reserved.
//

#import "GameScene.h"

#define BALL_RADIUS 20.0
static const uint32_t lefeCategory = 0x1 << 0;
static const uint32_t ballsCategory = 0x1 << 1;

@interface GameScene ()

@property (nonatomic, assign) NSInteger fallCount;
@property (nonatomic) SKSpriteNode *lefe1;
@property (nonatomic) SKSpriteNode *lefe2;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor blackColor];
    [self initToolNode];
    [self startFallBalls];
}

- (void) initToolNode
{
    NSLog(@"\n\nsize : %@\n\n", NSStringFromCGSize(self.size));
    
    CGFloat length = self.size.width;
    CGFloat width = 10;
    CGFloat bottom = 200;
    
    
    SKSpriteNode *lefe1 = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(length, width)];
    lefe1.position = CGPointMake(self.size.width/2, bottom+length/2);
    lefe1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:lefe1.size];
    lefe1.physicsBody.restitution = 0.7;
    lefe1.physicsBody.friction = 0.0;
    lefe1.physicsBody.dynamic = NO;
    lefe1.physicsBody.usesPreciseCollisionDetection = YES;

    
    SKSpriteNode *lefe2 = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(length, width)];
//    lefe2.position = CGPointMake(self.size.width/2, bottom+length/2);
    lefe2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:lefe2.size];
    lefe2.physicsBody.restitution = 0.7;
    lefe2.physicsBody.friction = 0.0;
    lefe2.physicsBody.dynamic = NO;
    lefe2.zRotation = M_PI/2;
    lefe2.physicsBody.usesPreciseCollisionDetection = YES;
    
    //lefe1.physicsBody.categoryBitMask = lefeCategory;
    //lefe2.physicsBody.categoryBitMask = lefeCategory;
    //lefe1.physicsBody.collisionBitMask = ballsCategory;
    //lefe2.physicsBody.collisionBitMask = ballsCategory;
    [lefe1 addChild:lefe2];
    [self addChild:lefe1];
    SKAction *rotate = [SKAction rotateByAngle:M_PI*2 duration:2.0];
    [lefe1 runAction:[SKAction repeatActionForever:rotate]];
    _lefe1 = lefe1;
    _lefe2 = lefe2;
    
    //外壳
    SKSpriteNode *shellNode = [[SKSpriteNode alloc]init];
    shellNode.position = CGPointMake(self.size.width/2, bottom+length/2);
    CGMutablePathRef path = CGPathCreateMutable();
//    float a = asinf(BALL_RADIUS/self.size.width/2);
    float a = M_PI/16;
    CGPathAddArc(path, nil, 0, 0, self.size.width/2, M_PI*3/4, -M_PI/2-a, NO);
    CGPathMoveToPoint(path, nil, 0, 0);
    CGPathAddArc(path, nil, 0, 0, self.size.width/2, -M_PI/2+a, M_PI/4, NO);
    shellNode.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    shellNode.physicsBody.dynamic = NO;
    shellNode.physicsBody.restitution = 0.7;
    shellNode.physicsBody.friction = 0;
    shellNode.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:shellNode];
}

- (void) startFallBalls
{
    SKAction *wait = [SKAction waitForDuration:1.0 withRange:0.5];
    SKAction *start = [SKAction performSelector:@selector(generateBall) onTarget:self];
    SKAction *sequeue = [SKAction sequence:@[wait, start]];
    [self runAction:[SKAction repeatAction:sequeue count:1000]];
}


- (void) generateBall
{
    if(_fallCount<100){
        SKShapeNode *shapNode = [SKShapeNode shapeNodeWithCircleOfRadius:20];
        shapNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20.0];
        shapNode.physicsBody.restitution = 0.7;
        shapNode.physicsBody.friction = 0;
        shapNode.name = @"ball";
        shapNode.fillColor = [SKColor redColor];
        shapNode.physicsBody.usesPreciseCollisionDetection = YES;
        //shapNode.physicsBody.categoryBitMask = ballsCategory;
        //shapNode.physicsBody.collisionBitMask = lefeCategory | ballsCategory;
        shapNode.position = CGPointMake(self.size.width/2+arc4random()%20-20, self.size.height);
        shapNode.physicsBody.allowsRotation = YES;
        [self addChild:shapNode];
        _fallCount++;
        
        SKLabelNode *label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%2ld",_fallCount]];
        label.color = [SKColor whiteColor];
        label.position = CGPointMake(0, 0);
        [shapNode addChild:label];
    }
    else if(_fallCount == 16){
        
        [_lefe1 removeAllActions];
        [_lefe2 removeAllActions];
        
        [_lefe1 removeFromParent];
        [_lefe2 removeFromParent];
    }
}

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if(node.position.y<0){
            [node removeFromParent];
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
