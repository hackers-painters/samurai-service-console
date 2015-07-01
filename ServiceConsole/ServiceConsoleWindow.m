//
//  ServiceCommandLogWindow.m
//  demo
//
//  Created by Licheng Guo ( http://nsobjet.me ) on 15/6/11.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "ServiceConsoleWindow.h"
#import "ServiceConsoleLogView.h"


#pragma mark -


@interface ServiceConsoleWindow ()

@prop_strong( ServiceConsoleLogView *, logView );

@end


#pragma mark -


@implementation ServiceConsoleWindow

@def_singleton( ServiceConsoleWindow )

- (id)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if ( self )
    {
        self.hidden = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.windowLevel   = UIWindowLevelStatusBar + 2.0f;
        
        
        UIButton * closeButton = UIButton.new;
        closeButton.frame = CGRectMake(0, 20, self.frame.size.width, 30);
        closeButton.showsTouchWhenHighlighted = YES;
        closeButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [closeButton setTitle:@"Close" forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        
        self.logView = [[ServiceConsoleLogView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height - 50)];
        [self addSubview:self.logView];
        
        
        
        [SamuraiLogger sharedInstance].outputHandler = ^(NSString * text){
            
            [self.logView appendLogString:text];
        };
    }
    
    return self;
}

- (void)dealloc
{
    
}

#pragma mark -

- (void)show
{
    self.hidden = NO;
}

- (void)hide
{
    self.hidden = YES;
}

#pragma mark -

@end
