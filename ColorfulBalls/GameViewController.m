//
//  GameViewController.m
//  ColorfulBalls
//
//  Created by 武淅 段 on 16/4/8.
//  Copyright (c) 2016年 武淅 段. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController ()

@property (nonatomic) GameScene *ballsScene;
@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
    scene.size = [UIScreen mainScreen].bounds.size;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    _ballsScene = scene;
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}
- (IBAction)didTapColorBallButton:(id)sender
{
    
    
    // Present the scene.
    [((SKView *)self.view) presentScene:_ballsScene];

}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
