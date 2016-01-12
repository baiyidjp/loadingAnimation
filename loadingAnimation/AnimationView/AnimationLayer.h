//
//  AnimationLayer.h
//  loadingAnimation
//
//  Created by dongjiangpeng on 15/12/31.
//  Copyright © 2015年 dongjiangpeng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface AnimationLayer : CALayer
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,assign)CGFloat lineWidth;
@property(nonatomic,strong)UIColor *color;
@end
