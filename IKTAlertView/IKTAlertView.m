//
//  IKTAlertView.m
//  BCPro
//
//  Created by bcikt on 2018/8/13.
//  Copyright © 2018年 bcikt. All rights reserved.
//

#import "IKTAlertView.h"

typedef enum : NSUInteger {
    IKTAlertDefault,
    IKTActionSheet,
} IKTAlertViewStyle;

@interface IKTAlertView ()
{
    CGFloat _lineHeight;        //按钮高度
    CGFloat _cancleSpace;       //取消按钮间隔
    CGFloat _sheetY;            //记录sheet实时Y值
    BOOL _exitCancle;           //取消按钮是否初始化成功(主要是actionsheet底部间隔区别)
}

@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UILabel *messageView;

@property (nonatomic, strong) UIView *shadow;

@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSMutableArray *titleColors;

@property (nonatomic, strong) NSMutableArray *actions;

@property (nonatomic, assign) IKTAlertViewStyle style;

@end

@implementation IKTAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _lineHeight = [UIScreen mainScreen].bounds.size.width/375.0*57;
        _cancleSpace = [UIScreen mainScreen].bounds.size.width/375.0*6.7;
        _sheetY = self.frame.size.height;
        [self shadow];
    }
    return self;
}

- (NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray arrayWithCapacity:0];
    }
    return _titles;
}

- (NSMutableArray *)titleColors{
    if (!_titleColors) {
        _titleColors = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleColors;
}

- (NSMutableArray *)actions{
    if (!_actions) {
        _actions = [NSMutableArray arrayWithCapacity:0];
    }
    return _actions;
}

- (UIView *)shadow{
    if (!_shadow) {
        _shadow = [[UIView alloc] initWithFrame:self.frame];
        _shadow.backgroundColor = [UIColor blackColor];
        _shadow.alpha = 0.55;
        [self addSubview:_shadow];
    }
    return _shadow;
}

- (UIView *)animationView{
    if (!_animationView) {
        _animationView = [[UIView alloc] initWithFrame:self.shadow.frame];
        [self addSubview:_animationView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAnimation)];
        [_animationView addGestureRecognizer:tap];
    }
    return _animationView;
}

+ (instancetype)alertViewMessage:(NSString *)message Cancle:(NSString *)cancle Action:(IKTAlertAction)action{
    
    IKTAlertView *alert = [self instanceCancle:cancle Action:action Style:IKTAlertDefault];
    alert.messageView.text = [message mutableCopy];
    return alert;
}

+ (instancetype)actionSheetCancle:(NSString *)cancle Action:(IKTAlertAction)action{
    return [self instanceCancle:cancle Action:action Style:IKTActionSheet];
}

+ (instancetype)instanceCancle:(NSString *)cancle Action:(IKTAlertAction)action Style:(IKTAlertViewStyle)style{
    IKTAlertView *alert = [[IKTAlertView alloc] initWithFrame:[UIApplication sharedApplication].delegate.window.frame];
    alert.style = style;
    if (cancle) {
        alert->_exitCancle = YES;
    }
    
    [alert addTitle:cancle Action:action];
    return alert;
}

- (void)addTitle:(NSString *)title Action:(IKTAlertAction)action{
    
    UIColor *color = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1];
    [self addTitle:title Color:color Action:action];
}

- (void)addTitle:(NSString *)title Color:(UIColor *)color Action:(IKTAlertAction)action{
    if (!title) {
        return;
    }
    if (!action) {
        
        action = ^{};
    }
    if (!color) {
        
        color = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1];
    }
    
    [self.titles addObject:title];
    [self.actions addObject:action];
    [self.titleColors addObject:color];
    
}

- (void)show{
    
    [self showInView:[UIApplication sharedApplication].delegate.window];
}

- (void)showInView:(UIView *)view{
    
    NSInteger count = self.titles.count;
    if (self.style==IKTActionSheet) {
        
        for (int i = 0; i < count; i++) {
            [self addActionClickViewTag:i];
        }
    }else{
        
        for (int i = 0; i < count; i++) {
            [self addAlertViewTag:i];
        }
    }
    
    [view addSubview:self];
    [self showAnimation];
}

- (void)showAnimation{
    
    CGRect frame = self.frame;
    CGRect animation;
    if (self.style==IKTActionSheet) {
        animation = CGRectMake(self.frame.origin.x, self.frame.origin.y+_lineHeight*_titles.count, self.frame.size.width, self.frame.size.height);
    }else{
        animation = CGRectMake(self.frame.origin.x, self.frame.origin.y+_lineHeight, self.frame.size.width, self.frame.size.height);
    }
    self.animationView.frame = animation;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.38 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
        weakSelf.animationView.transform = CGAffineTransformMake(1.0f, 0, 0, 1.0f, 0, 0);
        
        weakSelf.animationView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenAnimation{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.3 delay:.1 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark -- AlertView SetUpView

- (UIView *)alertView{
    if (!_alertView) {
        CGFloat scaleX = [UIScreen mainScreen].bounds.size.width/375.0*44.0;
        CGFloat width = self.frame.size.width-scaleX*2.0;
        CGFloat scaleHeight = [UIScreen mainScreen].bounds.size.width/375.0*166.3;
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(scaleX, 0, width, scaleHeight)];
        _alertView.layer.cornerRadius = [UIScreen mainScreen].bounds.size.width/375.0*5.3;
        _alertView.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
        _alertView.center = CGPointMake(self.center.x, self.center.y*.8);
        [self.animationView addSubview:_alertView];
    }
    return _alertView;
}

- (UILabel *)messageView{
    if (!_messageView) {
        CGFloat margin = [UIScreen mainScreen].bounds.size.width/375.0*15.0;
        CGFloat scaleHeight = [UIScreen mainScreen].bounds.size.width/375.0*90.0;
        CGFloat fontSize = [UIScreen mainScreen].bounds.size.width/375.0*17.4;
        _messageView = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, self.alertView.frame.size.width-margin*2.0, scaleHeight)];
        _messageView.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1];
        _messageView.textAlignment = NSTextAlignmentCenter;
        if (@available(iOS 9.0, *)) {
            _messageView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
        }else{
            _messageView.font = [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize];
        }
        _messageView.numberOfLines = 3;
        [self.alertView addSubview:_messageView];
    }
    return _messageView;
}

- (void)addAlertViewTag:(NSInteger)tag{
    
    CGFloat width = self.alertView.frame.size.width/self.titles.count;
    CGFloat height = self.alertView.frame.size.height-self.messageView.frame.size.height-self.messageView.frame.origin.y;
    CGFloat fontSize = [UIScreen mainScreen].bounds.size.width/375.0*17.4;
    
    UIButton *click = [[UIButton alloc] initWithFrame:CGRectMake(width*tag, self.messageView.frame.size.height+self.messageView.frame.origin.y, width, height)];
    click.tag = tag;
    [click setTitle:self.titles[tag] forState:UIControlStateNormal];
    [click setTitleColor:self.titleColors[tag] forState:UIControlStateNormal];
    if (@available(iOS 9.0, *)) {
        [click.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]];
    }else{
        [click.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:fontSize]];
    }
    [self.alertView addSubview:click];
    [click addTarget:self action:@selector(alertActionClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark -- ActionSheet SetUpView
- (void)addActionClickViewTag:(NSInteger)tag{
    
    CGFloat fontSize = [UIScreen mainScreen].bounds.size.width/375.0*17.4;
    UIButton *click = [[UIButton alloc] initWithFrame:CGRectMake(0, _sheetY-_lineHeight, self.frame.size.width, _lineHeight)];
    click.tag = tag;
    click.backgroundColor = [UIColor whiteColor];
    [click setTitle:self.titles[tag] forState:UIControlStateNormal];
    [click setTitleColor:self.titleColors[tag] forState:UIControlStateNormal];
    if (@available(iOS 9.0, *)) {
        [click.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]];
    }else{
        [click.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:fontSize]];
    }
    [self.animationView addSubview:click];
    [click addTarget:self action:@selector(alertActionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消按钮间隔
    if (tag==0 && _exitCancle) {
        _sheetY -= (_lineHeight+_cancleSpace);
    }else{
        _sheetY -= _lineHeight;
    }
    
}

- (void)alertActionClick:(UIButton *)btn{
    
    NSInteger tag = btn.tag;
    IKTAlertAction action = [self.actions objectAtIndex:tag];
    action();
    [self hiddenAnimation];
}

@end
