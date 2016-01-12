//
//  AnimationLayer.m
//  loadingAnimation
//
//  Created by dongjiangpeng on 15/12/31.
//  Copyright © 2015年 dongjiangpeng. All rights reserved.
//

#import "AnimationLayer.h"
static CGFloat const kRadius = 30.0;

@implementation AnimationLayer
@dynamic progress;
@dynamic color;
@dynamic lineWidth;

+ (BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }else if ([key isEqualToString:@"color"]){
        return YES;
    }else if ([key isEqualToString:@"lineWidth"]){
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = kRadius;
    CGFloat startAngle = M_PI*7/2 -self.progress*(M_PI*7/2-M_PI*2);
    CGFloat endAngle = M_PI*7/2*(1-self.progress);
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:NO];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextStrokePath(ctx);
}
@end
