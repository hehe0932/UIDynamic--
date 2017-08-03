//
//  ViewController.m
//  UIDynamic-重力行为
//
//  Created by chenlishuang on 17/5/13.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *blueView;
/** 物理仿真器*/
@property (nonatomic,strong)UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@end

@implementation ViewController

- (UIDynamicAnimator *)animator{
    if (!_animator) {
        //1.创建物理仿真器(ReferenceView ,参照视图,其实就是设置仿真范围)
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    }
    return _animator;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self testGravity];
//    [self testCollision1];
    [self testCollision2];
    self.blueView.transform = CGAffineTransformMakeRotation(M_PI_4);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获得触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    //创建吸附行为(闪电)
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self.blueView snapToPoint:point];
    //防抖洗漱(值越小,越抖)
    snap.damping = 0.1;
    //添加行为
    [self.animator removeAllBehaviors];//删掉以前的行为
    [self.animator addBehavior:snap];
}

- (void)testGravity{
    //1.创建物理仿真行为 - 重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]init];
    [gravity addItem:self.blueView];
    //重力方向
    gravity.gravityDirection = CGVectorMake(1, 1);
    // point/s²  重力加速度
    gravity.magnitude = 100;
    // 移动的距离 = 1/2 * at²
    //3.添加  物理仿真行为 到 物理仿真器中  开始物理仿真
    [self.animator addBehavior:gravity];
}
- (void)testCollision1{
    //1.创建碰撞行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]init];
    //让参照视图的bounds变为碰撞检测的边框
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [collision addItem:self.blueView];
    [collision addItem:self.segmented];
    
    //2.创建物理仿真行为 - 重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]init];
    gravity.magnitude = 1;
    [gravity addItem:self.blueView];
    //3.添加行为
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}
- (void)testCollision2{
    //1.创建 碰撞行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]init];
    [collision addItem:self.blueView];
    //    [collision addItem:self.segmented];
    
    //添加边界
//    CGFloat startX = 0;
//    CGFloat startY = self.view.frame.size.height*0.5;
//    CGFloat endX = self.view.frame.size.width;
//    CGFloat endY = self.view.frame.size.height;
//    [collision addBoundaryWithIdentifier:@"line1" fromPoint:CGPointMake(startX, startY) toPoint:CGPointMake(endX, endY)];
//    [collision addBoundaryWithIdentifier:@"line2" fromPoint:CGPointMake(startX, 0) toPoint:CGPointMake(endX, endY)];
    
    CGFloat width = self.view.frame.size.width;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, width)];
    [collision addBoundaryWithIdentifier:@"circle" forPath:path];
    //2.创建物理仿真行为 - 重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]init];
    //    gravity.magnitude = 1;
    [gravity addItem:self.blueView];
    //3.添加行为
    [self.animator addBehavior:collision];
    [self.animator addBehavior:gravity];
}
@end
