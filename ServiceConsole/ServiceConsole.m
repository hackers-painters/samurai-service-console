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

#import "ServiceConsole.h"
#import "ServiceConsoleWindow.h"


static NSMutableDictionary * __commandCache = nil;


#pragma mark -


@interface ServiceCommandCache ()

@end


#pragma mark -


@implementation ServiceCommandCache


-(NSString *)cmdDescription
{
    if ( !_cmdDescription || ![_cmdDescription isKindOfClass:[NSString class]] ) {
        
        return @"";
    }
    
    
    /*
    if (!self.new || [self.cmd isEqualToString:@"exit"] || [self.cmd isEqualToString:@"help"] || [self.cmd isEqualToString:@"lcs"]) {
        
        return [NSString stringWithFormat:@"%@ (*)",_cmdDescription];
    }
     */
    
    return _cmdDescription;
}


@end


#pragma mark -


@implementation ServiceConsole

- (void)install
{
    
    // Default cmd.
    [ServiceConsole addClassCommand:@"exit"
                        commandType:ServiceConsoleCommandTypeAction
                           impClass:self.class
                 commandDescription:@"Exit the application."];
    
    
    [ServiceConsole addClassCommand:@"help"
                        commandType:ServiceConsoleCommandTypeSee
                           impClass:self.class
                 commandDescription:@"See the all command."];
    
    
    [self performSelector:@selector(installDelay) withObject:nil afterDelay:1];
    
}

-(void)installDelay
{
    [ServiceConsoleWindow sharedInstance];
}

- (void)uninstall
{
    
}

- (void)powerOn
{
    
}

- (void)powerOff
{
    
}

- (void)didDockerOpen
{
    [[ServiceConsoleWindow sharedInstance] show];
}

- (void)didDockerClose
{
    [[ServiceConsoleWindow sharedInstance] hide];
}


#pragma mark -


+(NSMutableDictionary *) commandCache;
{
    if ( !__commandCache ) {
        
        __commandCache = [NSMutableDictionary dictionary];
    }
    
    return __commandCache;
}


#pragma mark -


+(BOOL) analysisCommand:(NSString *)command
{
    if ( command.length <= 0 ) {
        
        return NO;
    }
    
    command = [command lowercaseString];
    
    INFO(@"[ ServiceCommand ] - %@",command);
    
    NSString * errorString = [NSString stringWithFormat:@"Invalid command : %@. ( You can input 'see help' to see all command. )",command];
    
    NSMutableArray * commandArray = [[command componentsSeparatedByString:@" "] mutableCopy];
    
    if ( commandArray.count == 1 ) {
        
        [commandArray insertObject:@"sim" atIndex:0];
    }
    else if ( !commandArray || commandArray.count <= 1 || ![command isKindOfClass:[NSString class]] ) {
        
        INFO(errorString);
        return NO;
    }
    
    //NSString * type = commandArray[0];
    NSString * cmd = commandArray[1];
    
    ServiceCommandCache * cache = self.commandCache[cmd];
    
    if ( !cache ) {
        
        INFO(errorString);
        return NO;
    }
    
    if ( cache.cmdType == ServiceConsoleCommandTypeSee ) {
        
        [self execute:cache];
        return YES;
    }
    else if ( cache.cmdType == ServiceConsoleCommandTypeAction ) {
        
        [self execute:cache];
        return YES;
    }
    
    INFO(errorString);
    return NO;
}

+(void) execute:(ServiceCommandCache *)cache
{
    if ( cache.class ) {
        
        if ( cache.cmdType == ServiceConsoleCommandTypeSee ) {
            
            NSString * info = [cache.class serviceConsoleCommandSee:cache.cmd];
            
            if ( info ) {
                INFO(info);
            }
        }
        else if (cache.cmdType == ServiceConsoleCommandTypeAction){
            
            NSString * info = [cache.class serviceConsoleCommandAction:cache.cmd];
            
            if ( info ) {
                INFO(info);
            }
        }
        
        return;
    }
    
    
    if (cache.object) {
        
        if (cache.cmdType == ServiceConsoleCommandTypeSee) {
            
            NSString * info = [cache.object serviceConsoleCommandSee:cache.cmd];
            
            if ( info ) {
                INFO(info);
            }
        }
        else if (cache.cmdType == ServiceConsoleCommandTypeAction){
            
            NSString * info = [cache.object serviceConsoleCommandAction:cache.cmd];
            
            if ( info ) {
                INFO(info);
            }
        }
        return;
    }
}

+(BOOL) addClassCommand:(NSString *)command
            commandType:(ServiceConsoleCommandType)commandType
               impClass:(Class<ServiceConsoleCommand>)impClass
     commandDescription:(NSString *)cmdDescription
{
    
    if ( !command || command.length <= 0 ) {
        
        WARN(@"Can't add this command, Because it is invalid.");
        return NO;
    }
    
    ServiceCommandCache * cache = [[ServiceCommandCache alloc] init];
    cache.cmd = command;
    cache.cmdType = commandType;
    cache.class = impClass;
    cache.cmdDescription = cmdDescription;
    cache.new = YES;
    
    [self.commandCache setObject:cache forKey:command];
    
    return YES;
}

+(BOOL) addObjectCommand:(NSString *)command
             commandType:(ServiceConsoleCommandType)commandType
               impObject:(NSObject<ServiceConsoleCommand> *)impObject
          CMDDescription:(NSString *)cmdDescription
{
    if (!command || command.length <= 0) {
        
        WARN(@"Can't add command, Because it is invalid.");
        return NO;
    }
    
    ServiceCommandCache * cache = [[ServiceCommandCache alloc] init];
    cache.cmd = command;
    cache.cmdType = commandType;
    cache.object = impObject;
    cache.cmdDescription = cmdDescription;
    cache.new = YES;
    
    [self.commandCache setObject:cache forKey:command];
    
    return YES;
}

#pragma mark - 


// Default cmd
+(NSString *) serviceConsoleCommandAction:(NSString *)command
{
    if ([command isEqualToString:@"exit"]) {
        
        exit(0);
    }
    
    return nil;
}

+(NSString *) serviceConsoleCommandSee:(NSString *)command
{
    if ([command isEqualToString:@"help"]) {
        
        
        NSDictionary * datasource = self.commandCache;
        
        if ( !datasource || !datasource.allKeys.count ) {
            
            return @"No commands.";
        }
        
        NSMutableString * info = [NSMutableString stringWithFormat:@"[ Command count : %@ ]\n", @(datasource.allKeys.count)];
        
        for (NSString * key in datasource.allKeys) {
            
            ServiceCommandCache * cache = datasource[key];
            
            [info appendFormat:@"[*] %@ - %@ [ %@ ]\n", cache.cmdType == ServiceConsoleCommandTypeSee ? @"see" : @"action", cache.cmd, cache.cmdDescription];
        }
        
        return info;
    }
    
    return @"";
}


@end
