//
//  NSString+Additions.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *)inRoundBrackets
{
    return [NSString stringWithFormat:@"%@%@%@",@"(",self,@")"];
}

- (NSString *)inSquareBrackets
{
    return [NSString stringWithFormat:@"%@%@%@",@"[",self,@"]"];
}

- (NSString *)inCurlyBrackets
{
    return [NSString stringWithFormat:@"%@%@%@",@"{",self,@"}"];
}

- (NSString *)inApexs
{
    return [NSString stringWithFormat:@"%@%@%@",@"'",self,@"'"];
}

- (NSString *)addComma
{
    return [NSString stringWithFormat:@"%@%@",self,@","];
}

- (NSString *)addColon
{
    return [NSString stringWithFormat:@"%@%@",self,@":"];
}

- (NSString *)addSemiColon
{
    return [NSString stringWithFormat:@"%@%@",self,@";"];
}

@end
