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
@property (nonatomic, assign) NSInteger ballsNum;
@property (nonatomic) SKSpriteNode *lefe1;
@property (nonatomic) SKSpriteNode *lefe2;
@property (nonatomic) SKSpriteNode *board;
@property (nonatomic) NSMutableArray *numContainer;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    _numContainer = [[NSMutableArray alloc]init];
    self.backgroundColor = [SKColor blackColor];
    [self initToolNode];
    [self startFallBalls];
}

- (void) initToolNode
{
    NSLog(@"\n\nsize : %@\n\n", NSStringFromCGSize(self.size));
    
    CGFloat length = self.size.width-20;
    CGFloat width = 10;
    CGFloat bottom = 400;
    
    /*
    SKSpriteNode *lefe1 = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(length, width)];
    lefe1.position = CGPointMake(self.size.width/2, bottom+length/2);
    lefe1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:lefe1.size];
    lefe1.physicsBody.restitution = 1;
    lefe1.physicsBody.friction = 0.0;
    lefe1.physicsBody.dynamic = NO;
    lefe1.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:lefe1];
    SKAction *rotate = [SKAction rotateByAngle:M_PI*2 duration:1.5];
    [lefe1 runAction:[SKAction repeatActionForever:rotate]];
    
    SKSpriteNode *lefe2 = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(length, width)];
//    lefe2.position = CGPointMake(self.size.width/2, bottom+length/2);
    lefe2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:lefe2.size];
    lefe2.physicsBody.restitution = 0.7;
    lefe2.physicsBody.friction = 0.0;
    lefe2.physicsBody.dynamic = NO;
    lefe2.physicsBody.pinned = YES;
    lefe2.physicsBody.allowsRotation = NO;
    lefe2.zRotation = M_PI/2;
    lefe2.physicsBody.usesPreciseCollisionDetection = YES;
    
    //lefe1.physicsBody.categoryBitMask = lefeCategory;
    //lefe2.physicsBody.categoryBitMask = lefeCategory;
    //lefe1.physicsBody.collisionBitMask = ballsCategory;
    //lefe2.physicsBody.collisionBitMask = ballsCategory;
    [lefe1 addChild:lefe2];
    [self addChild:lefe1];
    
    SKAction *rotate = [SKAction rotateByAngle:M_PI*2 duration:1.5];
    [lefe1 runAction:[SKAction repeatActionForever:rotate]];
    _lefe1 = lefe1;
    _lefe2 = lefe2;*/
    
    //外壳
    SKSpriteNode *shellNode = [[SKSpriteNode alloc]initWithImageNamed:@"circle"];
    shellNode.size = CGSizeMake(self.size.width, self.size.width);
    shellNode.position = CGPointMake(self.size.width/2, bottom+length/2);
    CGMutablePathRef path = CGPathCreateMutable();
    float a = asinf((BALL_RADIUS+3)/(self.size.width/2));
//    shellNode.scene.scaleMode = SKSceneScaleModeAspectFill;
    NSLog(@"\n\n arc: %lf\n\n", a/M_PI);
//    float a = M_PI/16;
   // CGPathAddArc(path, nil, 0, 0, self.size.width/2, M_PI*3/4, -M_PI/2-a, NO);
    CGPathAddArc(path, nil, 0, 0,self.size.width/2,  -M_PI/2+a,-M_PI/2-a, NO);
    shellNode.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    shellNode.physicsBody.dynamic = NO;
    shellNode.physicsBody.restitution = 1;
    shellNode.physicsBody.friction = 0;
    shellNode.physicsBody.linearDamping = 0;
    shellNode.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:shellNode];
     
     SKSpriteNode *board = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(80, 10)];
     board.position = CGPointMake(0, -self.size.width/2-5);
     board.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:board.size];
     board.physicsBody.dynamic = NO;
     board.physicsBody.usesPreciseCollisionDetection = YES;
     [shellNode addChild:board];
     _board = board;

    
    SKSpriteNode *tube = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(50, bottom)];
    tube.position = CGPointMake(self.size.width/2, bottom/2);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, nil, -25, bottom/2);
    CGPathAddLineToPoint(path2, nil, -25, 150);
    CGPathAddLineToPoint(path2, nil, 0, 50);
    CGPathAddLineToPoint(path2, nil, self.size.width/2-60, -50);
    CGPathAddLineToPoint(path2, nil, self.size.width/2-60, -100);
    CGPathAddLineToPoint(path2, nil, -self.size.width/2, -150);
    CGPathAddLineToPoint(path2, nil, -self.size.width/2, -200);
    CGPathAddLineToPoint(path2, nil, self.size.width/2, -160);
    CGPathAddLineToPoint(path2, nil, self.size.width/2, 50);
    CGPathAddLineToPoint(path2, nil, self.size.width/2-50, 100);
    CGPathAddLineToPoint(path2, nil, 40, bottom/2);
    
    
    
    tube.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path2];
    tube.physicsBody.dynamic = NO;
    tube.physicsBody.friction = 0.1;
    tube.physicsBody.resting = 0;
    tube.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:tube];
    /*SKSpriteNode *shellNode2 = [[SKSpriteNode alloc]init];
    shellNode2.position = CGPointMake(self.size.width/2, bottom+length/2);
    CGMutablePathRef path2 = CGPathCreateMutable();
    //    float a = M_PI/16;
    //CGPathAddArc(path, nil, 0, 0, self.size.width/2, M_PI*3/4, -M_PI/2-a, NO);
    CGPathAddArc(path2, nil, 0, 0, self.size.width/2, -M_PI/2+a, M_PI/4, NO);
    shellNode2.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path2];
    shellNode2.physicsBody.dynamic = NO;
    shellNode2.physicsBody.restitution = 0.7;
    shellNode2.physicsBody.friction = 0;
    shellNode2.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:shellNode2];
    */
    
    
    
    
}

- (void) startFallBalls
{
    SKAction *wait = [SKAction waitForDuration:0.2 withRange:0.2];
    SKAction *start = [SKAction performSelector:@selector(generateBall) onTarget:self];
    SKAction *sequeue = [SKAction sequence:@[wait, start]];
    [self runAction:[SKAction repeatAction:sequeue count:1000]];
}


- (void) generateBall
{
    if(_ballsNum<32){
        SKShapeNode *shapNode = [SKShapeNode shapeNodeWithCircleOfRadius:20];
        shapNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20.0];
        shapNode.physicsBody.restitution = 1;
        shapNode.physicsBody.friction = 0.0;
        shapNode.name = @"ball";
        shapNode.fillColor = [SKColor redColor];
        
        //shapNode.physicsBody.categoryBitMask = ballsCategory;
        //shapNode.physicsBody.collisionBitMask = lefeCategory | ballsCategory;
       
        
        [self addChild:shapNode];
        
        shapNode.position = CGPointMake(self.size.width/2+rand()%20-20, 200+self.size.width-40);
        shapNode.physicsBody.allowsRotation = NO;
        float x = rand()%20+20;
        float y = rand()%20+20;
        [shapNode.physicsBody applyImpulse:CGVectorMake(x, y)];
        shapNode.physicsBody.usesPreciseCollisionDetection = YES;
        shapNode.physicsBody.dynamic = YES;
        shapNode.physicsBody.linearDamping = 0;
        _ballsNum++;
        
        
        SKLabelNode *label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%2ld",_ballsNum]];
        label.color = [SKColor whiteColor];
        label.fontSize = 20;
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        label.position = CGPointMake(0, 0);
        [shapNode addChild:label];

        
    }
    else if(_ballsNum == 32){
        
        [SKView animateWithDuration:0.5 animations:^{
            _board.position = CGPointMake(80, -self.size.width/2-5);
        } completion:^(BOOL finished) {
            //[_board removeFromParent];
        }];
        
    }
}

- (void)didSimulatePhysics
{
    
    
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        
        NSLog(@"\n\nball position : %.1f", node.position.y);
        
        if(_fallCount>=6){
            _board.position = CGPointMake(0, -self.size.width/2-5);
            node.physicsBody.restitution = 0.2;
            return;
        }
        
        if(node.position.y<0){
            [node removeFromParent];
        }
        else if(node.position.y < 400){
            node.physicsBody.restitution = 0.2;
            SKLabelNode *label = (SKLabelNode *)[node.children lastObject];
            for(NSNumber *num in _numContainer){
                if(num.intValue == label.text.intValue){
                    return ;
                }
            }
            _fallCount++;
            [_numContainer addObject:@(label.text.intValue)];
//            node.physicsBody.velocity = CGVectorMake(0, 0.3);
            
            if(_fallCount==6){
                _board.position = CGPointMake(0, -self.size.width/2-5);
            }
            
        }
        
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void) startFallRandomBalls
{
    SKAction *wait = [SKAction waitForDuration:0.3 withRange:0.2];
    //    SKAction *start = [SKAction performSelector:@selector(generateBall) onTarget:self];
    SKAction *start = [SKAction performSelector:@selector(generateRandomBall) onTarget:self];
    SKAction *sequeue = [SKAction sequence:@[wait, start]];
    [self runAction:[SKAction repeatAction:sequeue count:1000]];
}

- (void) generateRandomBall
{
    if(_fallCount<1000){
        SKShapeNode *shapNode = [SKShapeNode shapeNodeWithCircleOfRadius:10];
        shapNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10.0];
        shapNode.physicsBody.restitution = 0.0;
        shapNode.physicsBody.friction = 0.7;
        shapNode.name = @"ball";
        shapNode.fillColor = [SKColor redColor];
        
        //shapNode.physicsBody.categoryBitMask = ballsCategory;
        //shapNode.physicsBody.collisionBitMask = lefeCategory | ballsCategory;
        
        
        [self addChild:shapNode];
        
        shapNode.position = CGPointMake(rand()%(int)self.size.width, 600);
        shapNode.physicsBody.allowsRotation = NO;
        //float x = rand()%20+20;
        //float y = rand()%20+20;
        //[shapNode.physicsBody applyImpulse:CGVectorMake(x, y)];
        shapNode.physicsBody.usesPreciseCollisionDetection = YES;
        shapNode.physicsBody.dynamic = YES;
        shapNode.physicsBody.linearDamping = 0;
        
    }
}

@end
