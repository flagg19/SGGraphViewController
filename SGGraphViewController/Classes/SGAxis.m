//
//  SGAxis.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGAxis.h"
#import "NSString+Additions.h"
#import "JSONKit.h"

@interface SGAxis ()

- (id)initWithType:(axisType)type position:(axisPosition)position dataFieldNames:(NSArray *)fieldNames title:(NSString *)title drawGrid:(BOOL)grid;
- (NSString *)getTextForType:(axisType)type;
- (NSString *)getTextForPosition:(axisPosition)position;

@end

@implementation SGAxis

- (id)initWithType:(axisType)type position:(axisPosition)position dataFieldNames:(NSArray *)fieldNames title:(NSString *)title drawGrid:(BOOL)grid
{
    if (self = [super init]) {
        _type = type;
        _position = position;
        _dataFieldNames = fieldNames;
        _title = title;
        _grid = grid;
    }
    return self;
}

- (id)initNumericAxisWithPosition:(axisPosition)position dataFieldNames:(NSArray *)fieldNames title:(NSString *)title drawGrid:(BOOL)grid
{
    self = [self initWithType:axisTypeNumeric position:position dataFieldNames:fieldNames title:title drawGrid:grid];
    
    // Any other init setting related to numeric axis gose here
    
    return self;
}

- (id)initCategoryAxisWithPosition:(axisPosition)position dataFieldNames:(NSArray *)fieldNames title:(NSString *)title drawGrid:(BOOL)grid
{
    self = [self initWithType:axisTypeCategory position:position dataFieldNames:fieldNames title:title drawGrid:grid];
    
    // Any other init setting related to category axis gose here
    
    return self;
}

- (NSString *)getTextForType:(axisType)type
{
    switch (type) {
        case axisTypeNumeric:
            return @"Numeric";
            break;
        case axisTypeCategory:
            return @"Category";
            break;
        default:
            NSLog(@"Undefinex axis type, category will be used by default");
            return @"Category";
            break;
    }
}

- (NSString *)getTextForPosition:(axisPosition)position
{
    switch (position) {
        case axisPositionTop:
            return @"top";
            break;
        case axisPositionLeft:
            return @"left";
            break;
        case axisPositionBottom:
            return @"bottom";
            break;
        case axisPositionRight:
            return @"right";
            break;
        default:
            NSLog(@"Undefinex axis position, left will be used by default");
            return @"left";
            break;
    }
}

- (NSString *)getJSTextAxis
{
    NSString *result = @"";
    
    // Adding mandatory info
    result = [result stringByAppendingFormat:@"type:%@,",[[self getTextForType:_type] JSONString]];
    result = [result stringByAppendingFormat:@"position:%@,",[[self getTextForPosition:_position] JSONString]];
    result = [result stringByAppendingFormat:@"fields:%@,",[_dataFieldNames JSONString]];
    
    // Adding optional info
    (_title && ![_title isEqualToString:@""]) ? result = [result stringByAppendingFormat:@"title:%@,",[_title JSONString]] : nil;
    result = [result stringByAppendingFormat:@"grid:%d",[[[NSNumber alloc]initWithBool:_grid] intValue]];
    
    return [result inCurlyBrackets];
}

+ (NSString *)getJSTextAxes:(NSArray *)axes
{
    // Putting all axes together
    NSString *results = @"axes:[";
    
    for (SGAxis *axis in axes) {
        results = [results stringByAppendingString:[axis getJSTextAxis]];
        if (![axis isEqual:[axes lastObject]]) {
            results = [results addComma];
        }
    }
    
    return [results stringByAppendingString:@"]"];
}


@end
