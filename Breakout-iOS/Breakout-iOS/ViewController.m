//
//  ViewController.m
//  Breakout-iOS
//
//  Created by Josh L on 9/19/14.
//  Copyright (c) 2014 Applico Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate>
@property (weak, nonatomic) IBOutlet UIView *ball;
@property (weak, nonatomic) IBOutlet UIView *paddle;
@property (weak, nonatomic) IBOutlet UIView *brick1;
@property (weak, nonatomic) IBOutlet UIView *brick2;
@property (weak, nonatomic) IBOutlet UIView *brick3;
@property (weak, nonatomic) IBOutlet UIView *brick4;
@property (weak, nonatomic) IBOutlet UIView *brick5;

@end

@implementation ViewController

// UIKit Dynamics
UIDynamicAnimator *_animator;
UIGravityBehavior *_gravity;
UICollisionBehavior *_collision;
UIDynamicItemBehavior *bounceBehaviour;
UIPushBehavior *pusher;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[_ball]];
    [_animator addBehavior:_gravity];
    
    _collision = [[UICollisionBehavior alloc] initWithItems:@[_ball, _brick1, _brick2, _brick3, _brick4, _brick5]];
    _collision.collisionDelegate = self;
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:_collision];
    
    // add a boundary that coincides with the top edge
    CGPoint rightEdge = CGPointMake(_paddle.frame.origin.x +
                                    _paddle.frame.size.width, _paddle.frame.origin.y);
    [_collision addBoundaryWithIdentifier:@"paddle"
                                fromPoint:_paddle.frame.origin
                                  toPoint:rightEdge];
    
    // Bounce!
    bounceBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[_ball]];
    bounceBehaviour.elasticity = 1.0;
//    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_ball]];
//    [itemBehavior addAngularVelocity:M_PI_2 forItem:_ball];
//    [_animator addBehavior:itemBehavior];
    [_animator addBehavior:bounceBehaviour];
    
    // paddle movement
    UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handlePan:)];
    [_paddle addGestureRecognizer:pgr];
    
    // push
//    pusher = [[UIPushBehavior alloc] initWithItems:@[_ball] mode:UIPushBehaviorModeContinuous];
//    pusher.pushDirection = CGVectorMake(0.5, 1.0);
//    pusher.active = YES;
//    [_animator addBehavior:pusher];
}

- (void) viewDidAppear:(BOOL)animated {
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[_ball]];
    [_animator addBehavior:_gravity];
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
- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id<UIDynamicItem>)item1
                 withItem:(id<UIDynamicItem>)item2
                  atPoint:(CGPoint)p {
    
    pusher.active = NO;
    
    NSLog(@"item 1: %@, item 2: %@", item1, item2);
    
    UIView *view1 = (UIView *)item1;
    NSLog(@"%ld", (long)view1.tag);
    
    UIView *view2 = (UIView *)item2;
    NSLog(@"%ld", (long)view2.tag);
    
    if(view2.tag == 1) {
        [view2 removeFromSuperview];
    }
}

- (void)collisionBehavior:(UICollisionBehavior*)paramBehavior
      beganContactForItem:(id <UIDynamicItem>)paramItem
   withBoundaryIdentifier:(id <NSCopying>)paramIdentifier
                  atPoint:(CGPoint)paramPoint{
    NSLog(@"paramItem: %@, paramIdentifier: %@", paramBehavior, paramIdentifier);
    pusher.active = NO;
}

@end
