//
//  Copyright (c) 2014-2015, Licheng Guo. ( http://nsobject.me )
//  http://github.com/titman
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "Samurai.h"



typedef NS_ENUM(NSInteger, ServiceConsoleCommandType) {
    
    ServiceConsoleCommandTypeSee   ,   // see
    ServiceConsoleCommandTypeAction,   // action
    
};


@protocol ServiceConsoleCommand <NSObject>

@optional

+(NSString *) serviceConsoleCommandSee:(NSString *)cmd;
+(NSString *) serviceConsoleCommandAction:(NSString *)cmd;

-(NSString *) serviceConsoleCommandSee:(NSString *)cmd;
-(NSString *) serviceConsoleCommandAction:(NSString *)cmd;

@end


#pragma mark -


@interface ServiceConsole : SamuraiService < ManagedService, ManagedDocker >


+(BOOL) addClassCommand:(NSString *)command
            commandType:(ServiceConsoleCommandType)commandType
               impClass:(Class <ServiceConsoleCommand>)impClass
     commandDescription:(NSString *)cmdDescription;


+(BOOL) addObjectCommand:(NSString *)command
             commandType:(ServiceConsoleCommandType)commandType
               impObject:(NSObject <ServiceConsoleCommand> *)impObject
          CMDDescription:(NSString *)cmdDescription;


+(BOOL) analysisCommand:(NSString *)command;

@end


#pragma mark -


@interface ServiceCommandCache : NSObject

@prop_assign ( ServiceConsoleCommandType, cmdType );
@prop_copy   ( NSString *, cmd );
@prop_strong ( NSObject <ServiceConsoleCommand> *, object );
@prop_strong ( Class <ServiceConsoleCommand>, class );
@prop_assign ( BOOL, new );
@prop_copy   ( NSString *, cmdDescription );

@end
