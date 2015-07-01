//
//  ServiceCommandLogView.m
//  demo
//
//  Created by Licheng Guo ( http://nsobjet.me ) on 15/6/11.
//  Copyright (c) 2015年 Geek-Zoo Studio. All rights reserved.
//

#import "Samurai.h"
#import "ServiceConsoleLogView.h"
#import "ServiceConsoleInputView.h"


#pragma mark -


@interface __KeyboardHandler : NSObject
{
    CGRect		_accessorFrame;
    UIView *	_accessor;
}

@prop_assign( NSInteger, animationCurve );
@prop_assign( CGFloat, animationDuration );
@prop_assign( CGFloat, height );
@prop_assign( BOOL, isShowing );

- (void)setAccessor:(UIView *)view;

@end


#pragma mark -


@implementation __KeyboardHandler


-(void) dealloc
{
    [self unobserveAllNotifications];
}


-(id) init
{
    if ( self = [super init] ) {
        
        _isShowing = NO;
        _animationDuration = 0.25;
        _height = 216.0f;
        
        
        [self observeNotification:UIKeyboardDidShowNotification];
        [self observeNotification:UIKeyboardDidHideNotification];
        [self observeNotification:UIKeyboardWillChangeFrameNotification];
    }
    
    return self;
}

-(void) handleNotification:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    
    if ( userInfo )
    {
        _animationCurve =[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        _animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    if ([notification.name isEqualToString:UIKeyboardDidShowNotification]) {
        
        if (NO == _isShowing){
            _isShowing = YES;
            // Is showing.
        }
        
        NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        if (value)
        {
            CGRect keyboardEndFrame = [value CGRectValue];
            CGFloat	keyboardHeight = keyboardEndFrame.size.height;
            
            if ( keyboardHeight != _height )
            {
                _height = keyboardHeight;
                // Height changed.
            }
        }
        
        
    }else if ([notification.name isEqualToString:UIKeyboardWillChangeFrameNotification]){
        
        NSValue * value1 = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
        NSValue * value2 = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        if (value1 && value2)
        {
            CGRect rect1 = [value1 CGRectValue];
            CGRect rect2 = [value2 CGRectValue];
            
            if (rect1.origin.y >= [UIScreen mainScreen].bounds.size.height){
                if (NO == _isShowing){
                    _isShowing = YES;
                    // Is showing.
                }
                
                if ( rect2.size.height != _height ){
                    _height = rect2.size.height;
                    // Height changed.
                }
            }
            else if (rect2.origin.y >= [UIScreen mainScreen].bounds.size.height){
                if (rect2.size.height != _height){
                    _height = rect2.size.height;
                    // Height changed.
                }
                
                if (_isShowing){
                    _isShowing = NO;
                    // Is hidden.
                }
            }
        }
    }else if ([notification.name isEqualToString:UIKeyboardDidHideNotification]){
        
        NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        if (value)
        {
            CGRect	keyboardEndFrame = [value CGRectValue];
            
            CGFloat	keyboardHeight = keyboardEndFrame.size.height;
            
            if (keyboardHeight != _height){
                _height = keyboardHeight;
            }
        }
        
        if (_isShowing){
            _isShowing = NO;
            // Height changed.
        }
    }
    
    [self updateAccessorFrame];
}

- (void)setAccessor:(UIView *)view
{
    _accessor = view;
    _accessorFrame = view.frame;
}

-(void) updateAccessorFrame
{
    if ( nil == _accessor )
        return;
    
    
    [UIView animateWithDuration:self.animationDuration animations:^{
       
        [UIView setAnimationCurve:self.animationCurve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        if (_isShowing){
            
            CGFloat containerHeight = _accessor.superview.bounds.size.height;
            CGRect newFrame = _accessorFrame;
            newFrame.origin.y = containerHeight - (_accessorFrame.size.height + _height);
            _accessor.frame = newFrame;
        }
        else{
            _accessor.frame = _accessorFrame;
        }
        
    }];
}


@end


#pragma mark -


@interface ServiceConsoleLogView ()

@prop_strong( UITextView *, logView );
@prop_strong( ServiceConsoleInputView *, inputView );
@prop_strong( __KeyboardHandler *, keyboardHandler );

@end


#pragma mark -


#define MAX_LOG_LENGTH 10000


@implementation ServiceConsoleLogView

-(instancetype) initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        
        CGRect logViewFrame = self.bounds;
        logViewFrame.size.height -= 60;
        
        
        self.logView                 = UITextView.new;
        self.logView.frame           = logViewFrame;
        self.logView.editable        = NO;
        self.logView.font            = [UIFont fontWithName:@"Menlo" size:10.0f];
        self.logView.textColor       = [UIColor whiteColor];
        self.logView.backgroundColor = [UIColor clearColor];
        self.logView.text            = [NSString stringWithFormat:@"[ Service-Command ]\n\n You can input 'see help' to see the all cmd.\n\n"];
        
        [self addSubview:self.logView];
        
        
        self.inputView = [[ServiceConsoleInputView alloc] initWithFrame:CGRectMake(0, frame.size.height - 40 - 20, self.frame.size.width, 40)];
        [self addSubview:self.inputView];
        
        
        self.keyboardHandler = [[__KeyboardHandler alloc] init];
        [self.keyboardHandler setAccessor:self.inputView];

    }
    
    return self;
}

-(void) appendLogString:(NSString *)logString
{
    if ( !self.superview ) {
        
        return;
    }
    
    if ( [logString rangeOfString:@"__KeyboardHandler"].length ||
         [logString rangeOfString:@"touch moved"].length ||
         [logString rangeOfString:@"touch began"].length ||
         [logString rangeOfString:@"touch ended"].length ) {
        
        return;
    }
    
    //dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString * newLogString = [self.logView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",logString]];
        
        if ( newLogString.length > MAX_LOG_LENGTH ) {
            
            newLogString = [newLogString substringWithRange:NSMakeRange(newLogString.length - MAX_LOG_LENGTH, MAX_LOG_LENGTH)];
        }
        
        self.logView.text = newLogString;
        
        
        [UIView animateWithDuration:1 animations:^{
           
            NSRange txtOutputRange;
            
            txtOutputRange.location = _logView.text.length;
            txtOutputRange.length = 0;
            
            self.logView.editable = YES;
            
            [self.logView scrollRangeToVisible:txtOutputRange];
            [self.logView setSelectedRange:txtOutputRange];
            
            self.logView.editable = NO;

            
        }];

    //});
}


@end
