//
//  AnimtionView.m
//  loadingAnimation
//
//  Created by dongjiangpeng on 15/12/31.
//  Copyright © 2015年 dongjiangpeng. All rights reserved.
//

#import "AnimtionView.h"
#import "AnimationLayer.h"
static CGFloat const kWidth = 5.0;
static CGFloat const kDutaTime1 = 1.0;
static CGFloat const kDutaTime2 = 0.5;
static CGFloat const kDutaTime3 = 0.15;
static CGFloat const kDutaTime4 = 1.0;
static CGFloat const kDutaTime5 = 1.0;
static CGFloat const kRadius = 30.0;
static CGFloat const kMargin = kRadius/2;//此时刚好跑到圆的顶点Y线上
static NSString * const kName = @"name";
static CGFloat const kLineWidth = 3.0;
static CGFloat const kLineHeight = 10.0;
static CGFloat const kScale = 0.8;
@interface AnimtionView ()
@property(nonatomic,strong)AnimationLayer *animationLayer;
@property(nonatomic,strong)CAShapeLayer *moveLayer;
@property(nonatomic,strong)CALayer *lineLayer;
@property(nonatomic,strong)CAShapeLayer *lineDismissLayer;
@property(nonatomic,strong)CAShapeLayer *lineAppearLayer;
@property(nonatomic,strong)CAShapeLayer *lineLeftAppearLayer;
@property(nonatomic,strong)CAShapeLayer *lineRightAppearLayer;
@property(nonatomic,strong)CAShapeLayer *successAppearLayer;
@end

@implementation AnimtionView

- (void)startAnimation{
    [self removeLayer];
    [self startAnimationWithLayer];
}
- (void)removeLayer{
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
    }
    if ((self.moveLayer)) {
        [self.moveLayer removeFromSuperlayer];
    }
    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
    }
    if (self.lineDismissLayer) {
        [self.lineDismissLayer removeFromSuperlayer];
    }
    if (self.lineAppearLayer) {
        [self.lineAppearLayer removeFromSuperlayer];
    }
    if (self.lineLeftAppearLayer) {
        [self.lineLeftAppearLayer removeFromSuperlayer];
    }
    if (self.lineRightAppearLayer) {
        [self.lineRightAppearLayer removeFromSuperlayer];
    }
    if (self.successAppearLayer) {
        [self.successAppearLayer removeFromSuperlayer];
    }
}
- (void)startAnimationWithLayer{
    self.animationLayer = [AnimationLayer layer];
    self.animationLayer.contentsScale = [UIScreen mainScreen].scale;//设置缩放率 为了高清图
    self.animationLayer.color = [UIColor purpleColor];
    self.animationLayer.lineWidth = kLineWidth;
    [self.layer addSublayer:self.animationLayer];
    self.animationLayer.bounds = CGRectMake(0, 0, kRadius*2+kWidth, kRadius*2+kWidth);
    self.animationLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.animationLayer.progress = 1.0;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"progress"];
    basicAnimation.duration = kDutaTime1;
    basicAnimation.fromValue = @0.0;
    basicAnimation.toValue = @1.0;
    basicAnimation.delegate = self;
    [basicAnimation setValue:@"basicAnimation" forKey:kName];
    [self.animationLayer addAnimation:basicAnimation forKey:nil];
}
//小弧线向上
- (void)startMoveAnimation{
    self.moveLayer = [CAShapeLayer layer];
    self.moveLayer.frame = self.layer.bounds;
    [self.layer addSublayer:self.moveLayer];
    //创建一个弧的path
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.bounds.size.width/2-kRadius-kMargin, self.bounds.size.height/2);
    CGFloat radius = kRadius*2+kMargin;
    CGFloat startAngle = M_PI*2;
    CGFloat endAngle = M_PI*2 - asin((kRadius*2)/radius);
    [movePath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:NO];
    self.moveLayer.path = movePath.CGPath;
    self.moveLayer.lineWidth = kWidth-2;
    self.moveLayer.strokeColor = [UIColor purpleColor].CGColor;
    self.moveLayer.fillColor = nil;
    //动画结束的时停在的位置
    self.moveLayer.strokeStart = 0.9;
    self.moveLayer.strokeEnd = 1.0;
    //着色的起点移动轨迹
    CGFloat startF = 0.0;
    CGFloat startE = 0.9;
    //着色的终点的移动轨迹
    CGFloat endF = 0.1;
    CGFloat endE = 1.0;
    
    CABasicAnimation *basicStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    basicStart.fromValue = @(startF);
    basicStart.toValue = @(startE);
    CABasicAnimation *basicEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicEnd.fromValue = @(endF);
    basicEnd.toValue = @(endE);
    
    CAAnimationGroup *groupAni2 = [CAAnimationGroup animation];
    groupAni2.delegate = self;
    [groupAni2 setValue:@"groupAni2" forKey:kName];
    groupAni2.animations = @[basicStart,basicEnd];
    groupAni2.duration = kDutaTime2;
    /*动画速度,何时快、慢
     kCAMediaTimingFunctionLinear 线性（匀速）|
     kCAMediaTimingFunctionEaseIn 先慢|
     kCAMediaTimingFunctionEaseOut 后慢|
     kCAMediaTimingFunctionEaseInEaseOut 先慢 后慢 中间快|
     kCAMediaTimingFunctionDefault 默认|
     */
    groupAni2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.moveLayer addAnimation:groupAni2 forKey:nil];
}
//细线从天而降
- (void)lineAnimation{
    [self.moveLayer removeFromSuperlayer];
    self.lineLayer = [CALayer layer];
    self.lineLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.lineLayer];
    self.lineLayer.bounds = CGRectMake(0, 0, kLineWidth, kLineHeight);
    self.lineLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-kRadius*2+kLineHeight/2);
    self.lineLayer.backgroundColor = [UIColor purpleColor].CGColor;
    
    CGPoint startPosition = self.lineLayer.position;
    CGPoint endPosition = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-kRadius-kLineHeight/2);
    self.lineLayer.position = endPosition;
    CABasicAnimation *basicLineAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    basicLineAnimation.fromValue = @(startPosition.y);
    basicLineAnimation.toValue = @(endPosition.y);
    basicLineAnimation.duration = kDutaTime3;
    basicLineAnimation.delegate = self;
    [basicLineAnimation setValue:@"basicLineAnimation" forKey:kName];
    [self.lineLayer addAnimation:basicLineAnimation forKey:nil];
}
//压扁圆
- (void)scaleRound{
    CGRect frame = self.animationLayer.frame;
    self.animationLayer.anchorPoint = CGPointMake(0.5, 1);//将layer固定在一个位置上改变,当前这个点不动
    self.animationLayer.frame = frame;
    
    CGFloat yFrom = 1.0;
    CGFloat yTo = kScale;
    CGFloat xFrom = 1.0;
    CGFloat xTo = 1.1;
    self.animationLayer.transform = CATransform3DMakeScale(xTo, yTo, 1);
    CABasicAnimation *xAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    xAnimation.fromValue = @(xFrom);
    xAnimation.toValue = @(xTo);
    CABasicAnimation *yAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    yAnimation.fromValue = @(yFrom);
    yAnimation.toValue = @(yTo);
    CAAnimationGroup *groupAnimation2 = [CAAnimationGroup animation];
    groupAnimation2.animations = @[xAnimation,yAnimation];
    groupAnimation2.duration = kDutaTime4;
    groupAnimation2.delegate = self;
    [groupAnimation2 setValue:@"groupAnimation2" forKey:kName];
    [self.animationLayer addAnimation:groupAnimation2 forKey:nil];
    
}
//细线消失
- (void)lineDismiss{
    [self.lineLayer removeFromSuperlayer];
    self.lineDismissLayer = [CAShapeLayer layer];
    self.lineDismissLayer.frame = self.bounds;
    [self.layer addSublayer:self.lineDismissLayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startP = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-kRadius-kLineHeight);
    CGPoint endP = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-kRadius+(1-0.8)*2*kRadius);
    [path moveToPoint:startP];
    [path addLineToPoint:endP];
    self.lineDismissLayer.path = path.CGPath;
    self.lineDismissLayer.lineWidth = kLineWidth;
    self.lineDismissLayer.strokeColor = [UIColor purpleColor].CGColor;
    self.lineDismissLayer.fillColor = nil;
    //着色的起点移动轨迹
    CGFloat startF = 0.0;
    CGFloat startE = 1.0;
    //着色的终点的移动轨迹
    CGFloat endF = kLineHeight/(kLineHeight+2*kRadius*(1-kScale));
    CGFloat endE = 1.0;
    //动画结束的时停在的位置
    self.lineDismissLayer.strokeStart = 1.0;
    self.lineDismissLayer.strokeEnd = 1.0;
    
    CABasicAnimation *basicStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    basicStart.fromValue = @(startF);
    basicStart.toValue = @(startE);
    CABasicAnimation *basicEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicEnd.fromValue = @(endF);
    basicEnd.toValue = @(endE);
    CAAnimationGroup *groupAni4 = [CAAnimationGroup animation];
    groupAni4.delegate = self;
    [groupAni4 setValue:@"groupAni4" forKey:kName];
    groupAni4.animations = @[basicStart,basicEnd];
    groupAni4.duration = kDutaTime4;
    [self.lineDismissLayer addAnimation:groupAni4 forKey:nil];
}
//粗线出现
- (void)boldLineaAnimation{
//    [self.lineDismissLayer removeFromSuperlayer];
    self.lineAppearLayer = [CAShapeLayer layer];
    self.lineAppearLayer.frame = self.bounds;
    [self.layer addSublayer:self.lineAppearLayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startP = CGPointMake(CGRectGetMidX(self.bounds),  CGRectGetMidY(self.bounds)-kRadius);
    CGPoint endP = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)+kRadius);
    [path moveToPoint:startP];
    [path addLineToPoint:endP];
    self.lineAppearLayer.path = path.CGPath;
    self.lineAppearLayer.lineWidth = kLineWidth*2;
    self.lineAppearLayer.strokeColor = [UIColor purpleColor].CGColor;
    self.lineAppearLayer.fillColor = nil;
    //着色的起点移动轨迹
    CGFloat startF = 0.0;
    CGFloat startE = 1-kScale;
    //着色的终点的移动轨迹
    CGFloat endF = 0.0;
    CGFloat endE = 0.5;
    //动画结束的时停在的位置
    self.lineAppearLayer.strokeStart = startE;
    self.lineAppearLayer.strokeEnd = endE;
    
    CABasicAnimation *basicStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    basicStart.fromValue = @(startF);
    basicStart.toValue = @(startE);
    CABasicAnimation *basicEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicEnd.fromValue = @(endF);
    basicEnd.toValue = @(endE);
    CAAnimationGroup *groupAni5 = [CAAnimationGroup animation];
    groupAni5.animations = @[basicStart,basicEnd];
    groupAni5.duration = kDutaTime4;
    groupAni5.delegate= self;
    [groupAni5 setValue:@"groupAni5" forKey:kName];
    [self.lineAppearLayer addAnimation:groupAni5 forKey:nil];

}
- (void)setAnimations{
    [self roundRecover];
    [self boldLineLong];
    [self leftLine];
    [self rightLine];
}
//圆回复原状
- (void)roundRecover{
    self.animationLayer.transform = CATransform3DIdentity;
    self.animationLayer.color = [UIColor magentaColor];
    
    CABasicAnimation *recover = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    recover.duration = kDutaTime5;
    recover.fromValue = @(kScale);
    recover.toValue = @1.0;
    [self.animationLayer addAnimation:recover forKey:nil];
    
}
//粗线延长
- (void)boldLineLong{
  
    //着色的起点移动轨迹
    CGFloat startF = 1-kScale;
    CGFloat startE = 0.0;
    //着色的终点的移动轨迹
    CGFloat endF = 0.5;
    CGFloat endE = 1.0;
    //动画结束的时停在的位置
    self.lineAppearLayer.strokeStart = startE;
    self.lineAppearLayer.strokeEnd = endE;
    
    CABasicAnimation *basicStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    basicStart.fromValue = @(startF);
    basicStart.toValue = @(startE);
    CABasicAnimation *basicEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicEnd.fromValue = @(endF);
    basicEnd.toValue = @(endE);
    CAAnimationGroup *groupAni6 = [CAAnimationGroup animation];
    groupAni6.animations = @[basicStart,basicEnd];
    groupAni6.duration = kDutaTime5;
    groupAni6.delegate= self;
    [groupAni6 setValue:@"groupAni6" forKey:kName];
    [self.lineAppearLayer addAnimation:groupAni6 forKey:nil];

}
//左边的线
- (void)leftLine{
    self.lineLeftAppearLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.lineLeftAppearLayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startP = CGPointMake(CGRectGetMidX(self.bounds),  CGRectGetMidY(self.bounds));
    CGPoint endP = CGPointMake(CGRectGetMidX(self.bounds)-kRadius*sin(M_PI/3), CGRectGetMidY(self.bounds)+kRadius*cos(M_PI/3));
    [path moveToPoint:startP];
    [path addLineToPoint:endP];
    self.lineLeftAppearLayer.path = path.CGPath;
    self.lineLeftAppearLayer.lineWidth = kLineWidth*2;
    self.lineLeftAppearLayer.strokeColor = [UIColor purpleColor].CGColor;
    self.lineLeftAppearLayer.fillColor = nil;
    //着色的终点的移动轨迹
    CGFloat endF = 0.0;
    CGFloat endE = 1.0;
    //动画结束的时停在的位置
    self.lineLeftAppearLayer.strokeEnd = endE;
    CABasicAnimation *leftbasicEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    leftbasicEnd.fromValue = @(endF);
    leftbasicEnd.toValue = @(endE);
    leftbasicEnd.duration = kDutaTime5;
    leftbasicEnd.delegate= self;
    [leftbasicEnd setValue:@"leftbasicEnd" forKey:kName];
    [self.lineLeftAppearLayer addAnimation:leftbasicEnd forKey:nil];

}
//右边的线
- (void)rightLine{
    self.lineRightAppearLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.lineRightAppearLayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startP = CGPointMake(CGRectGetMidX(self.bounds),  CGRectGetMidY(self.bounds));
    CGPoint endP = CGPointMake(CGRectGetMidX(self.bounds)+kRadius*sin(M_PI/3), CGRectGetMidY(self.bounds)+kRadius*cos(M_PI/3));
    [path moveToPoint:startP];
    [path addLineToPoint:endP];
    self.lineRightAppearLayer.path = path.CGPath;
    self.lineRightAppearLayer.lineWidth = kLineWidth*2;
    self.lineRightAppearLayer.strokeColor = [UIColor purpleColor].CGColor;
    self.lineRightAppearLayer.fillColor = nil;
    //着色的终点的移动轨迹
    CGFloat endF = 0.0;
    CGFloat endE = 1.0;
    //动画结束的时停在的位置
    self.lineRightAppearLayer.strokeEnd = endE;
    CABasicAnimation *rightbasicEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rightbasicEnd.fromValue = @(endF);
    rightbasicEnd.toValue = @(endE);
    rightbasicEnd.duration = kDutaTime5;
    rightbasicEnd.delegate= self;
    [rightbasicEnd setValue:@"rightbasicEnd" forKey:kName];
    [self.lineRightAppearLayer addAnimation:rightbasicEnd forKey:nil];
}
//对号
- (void)successAnimation{
    if (self.lineAppearLayer) {
        [self.lineAppearLayer removeFromSuperlayer];
    }
    if (self.lineLeftAppearLayer) {
        [self.lineLeftAppearLayer removeFromSuperlayer];
    }
    if (self.lineRightAppearLayer) {
        [self.lineRightAppearLayer removeFromSuperlayer];
    }
    self.successAppearLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.successAppearLayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startP = CGPointMake(CGRectGetMidX(self.bounds)-kRadius/2,  CGRectGetMidY(self.bounds));
    CGPoint endP = CGPointMake(CGRectGetMidX(self.bounds)-kRadius/8, CGRectGetMidY(self.bounds)+kRadius/2);
    [path moveToPoint:startP];
    [path addLineToPoint:endP];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds)+kRadius/2, CGRectGetMidY(self.bounds)-kRadius/2)];
    self.successAppearLayer.path = path.CGPath;
    self.successAppearLayer.lineWidth = kLineWidth;
    self.successAppearLayer.strokeColor = [UIColor orangeColor].CGColor;
    self.successAppearLayer.fillColor = nil;
    //着色的终点的移动轨迹
    CGFloat endF = 0.0;
    CGFloat endE = 1.0;
    //动画结束的时停在的位置
    self.successAppearLayer.strokeEnd = endE;
    CABasicAnimation *successbasicEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    successbasicEnd.fromValue = @(endF);
    successbasicEnd.toValue = @(endE);
    successbasicEnd.duration = kDutaTime5;
    successbasicEnd.delegate= self;
    [successbasicEnd setValue:@"successbasicEnd" forKey:kName];
    [self.successAppearLayer addAnimation:successbasicEnd forKey:nil];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([[anim valueForKey:kName] isEqualToString:@"basicAnimation"]) {
        [self startMoveAnimation];
    }else if ([[anim valueForKey:kName] isEqualToString:@"groupAni2"]){
        [self lineAnimation];
    }else if ([[anim valueForKey:kName] isEqualToString:@"basicLineAnimation"]){
        [self scaleRound];
        [self lineDismiss];
        [self boldLineaAnimation];
    }else if ([[anim valueForKey:kName] isEqualToString:@"groupAni5"]){
        [self setAnimations];
    }else if ([[anim valueForKey:kName] isEqualToString:@"groupAni6"]){
        [self successAnimation];
    }
}
@end
