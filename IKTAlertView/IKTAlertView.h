//
//  IKTAlertView.h
//  BCPro
//
//  Created by bcikt on 2018/8/13.
//  Copyright © 2018年 bcikt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IKTAlertAction)(void);

@interface IKTAlertView : UIView

+ (instancetype)alertViewMessage:(NSString *)message Cancle:(NSString *)cancle Action:(IKTAlertAction)action;

+ (instancetype)actionSheetCancle:(NSString *)cancle Action:(IKTAlertAction)action;

- (void)addTitle:(NSString *)title Action:(IKTAlertAction)action;

- (void)addTitle:(NSString *)title Color:(UIColor *)color Action:(IKTAlertAction)action;

- (void)show;

- (void)showInView:(UIView *)view;

@end
