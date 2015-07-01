//
//  ServiceCommandInputView.m
//  demo
//
//  Created by Licheng Guo ( http://nsobjet.me ) on 15/6/11.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "ServiceConsoleInputView.h"
#import "ServiceConsole.h"

@interface ServiceConsoleInputView () <UITextFieldDelegate>

@prop_strong ( UITextField *, textField );

@end

@implementation ServiceConsoleInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        
        self.backgroundColor   = [UIColor clearColor];
        self.backgroundColor   = [[UIColor whiteColor] colorWithAlphaComponent:1];
        self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
        self.layer.borderWidth = 2.0f;
        
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(4, 0, self.frame.size.width - 8, self.frame.size.height)];
        self.textField.backgroundColor      = [UIColor clearColor];
        self.textField.textColor            = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        self.textField.font                 = [UIFont systemFontOfSize:14];
        self.textField.returnKeyType        = UIReturnKeySend;
        self.textField.delegate             = self;
        self.textField.textAlignment        = NSTextAlignmentLeft;
        self.textField.clearsOnBeginEditing = YES;
        self.textField.placeholder          = @"Input command. ( You could input 'see help' to see the all cmd. )";
        
        [self addSubview:self.textField];
    }
    
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [ServiceConsole analysisCommand:[textField.text lowercaseString]];
    
    return YES;
}

-(BOOL) resignFirstResponder
{
    [self.textField resignFirstResponder];
    
    return [super resignFirstResponder];
}


@end
