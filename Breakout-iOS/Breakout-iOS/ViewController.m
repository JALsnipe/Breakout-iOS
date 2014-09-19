//
//  ViewController.m
//  Breakout-iOS
//
//  Created by Josh L on 9/19/14.
//  Copyright (c) 2014 Applico Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *ball;
@property (weak, nonatomic) IBOutlet UIView *paddle;

@end

@implementation ViewController

// UIKit Dynamics
UIDynamicAnimator *_animator;
UIGravityBehavior *_gravity;
UICollisionBehavior *_collision;
UIDynamicItemBehavior *bounceBehaviour;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[_ball]];
    [_animator addBehavior:_gravity];
    _collision = [[UICollisionBehavior alloc] initWithItems:@[_ball]];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:_collision];
    
    // add a boundary that coincides with the top edge
    CGPoint rightEdge = CGPointMake(_paddle.frame.origin.x +
                                    _paddle.frame.size.width, _paddle.frame.origin.y);
    [_collision addBoundaryWithIdentifier:@"paddle"
                                fromPoint:_paddle.frame.origin
                                  toPoint:rightEdge];
    
    // Bounce!
    bounceBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[ ]];
    bounceBehaviour.elasticity = 1.1;
    [_animator addBehavior:bounceBehaviour];
    
    [bounceBehaviour addItem:_ball];
    
    // paddle movement
    UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handlePan:)];
    [_paddle addGestureRecognizer:pgr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handlePan:(UIPanGestureRecognizer*)pgr;
{
    if (pgr.state == UIGestureRecognizerStateChanged) {
        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view];
        center = CGPointMake(center.x + translation.x,
                             center.y + 0);
        pgr.view.center = center;
        [pgr setTranslation:CGPointZero inView:pgr.view];
        
        // adjust collision boundaries
        [_collision removeAllBoundaries];
        CGPoint rightEdge = CGPointMake(_paddle.frame.origin.x +
                                        _paddle.frame.size.width, _paddle.frame.origin.y);
        [_collision addBoundaryWithIdentifier:@"paddle"
                                    fromPoint:_paddle.frame.origin
                                      toPoint:rightEdge];
    }
}

@end
