//
//  ViewController.m
//  loadingAnimation
//
//  Created by dongjiangpeng on 15/12/31.
//  Copyright © 2015年 dongjiangpeng. All rights reserved.
//

#import "ViewController.h"
#import "AnimtionView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet AnimtionView *animationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startAnimation:(UIButton *)sender {
    [self.animationView startAnimation];
}

@end
