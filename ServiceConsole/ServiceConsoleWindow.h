//
//  ServiceCommandLogWindow.h
//  demo
//
//  Created by Licheng Guo ( http://nsobjet.me ) on 15/6/11.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Samurai.h"

@interface ServiceConsoleWindow : UIWindow

@singleton( ServiceConsoleWindow )

- (void)show;
- (void)hide;

@end
