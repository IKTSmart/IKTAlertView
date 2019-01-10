//
//  ViewController.m
//  IKTAlertViewDemo
//
//  Created by bcikt on 2019/1/10.
//  Copyright © 2019 ETScorpoin. All rights reserved.
//

#import "ViewController.h"
#import "IKTAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (arc4random()%2==0) {
        [self sheet];
    }else{
        [self alert];
    }
}

- (void)alert{
    
    IKTAlertView *alert = [IKTAlertView alertViewMessage:@"选择弹框" Cancle:@"取消" Action:^{
        NSLog(@"取消");
    }];
    [alert addTitle:@"确定" Action:^{
        NSLog(@"确定");
    }];
    [alert show];
}

- (void)sheet{
    
    IKTAlertView *alert = [IKTAlertView actionSheetCancle:@"取消" Action:^{
        NSLog(@"取消");
    }];
    [alert addTitle:@"拍照" Color:[UIColor redColor] Action:^{
        NSLog(@"拍照");
    }];
    [alert addTitle:@"相册" Action:^{
        NSLog(@"相册");
    }];
    [alert show];
}


@end
