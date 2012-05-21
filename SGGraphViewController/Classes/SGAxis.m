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

- (id)initWithType:(axisType)type position:(axisPosition)position dataFieldName:(NSString *)fieldName title:(NSString *)title drawGrid:(BOOL)grid;
- (NSString *)getTextForType:(axisType)type;
- (NSString *)getTextForPosition:(axisPosition)position;

@end

@implementation SGAxis

- (id)initWithType:(axisType)type position:(axisPosition)position dataFieldName:(NSString *)fieldName title:(NSString *)title drawGrid:(BOOL)grid
{
    if (self = [super init]) {
        _type = type;
        _position = position;
        _dataFieldName = fieldName;
        _title = title;
        _grid = grid;
    }
    return self;
}

- (id)initNumericAxisWithPosition:(axisPosition)position dataFieldName:(NSString *)fieldName title:(NSString *)title drawGrid:(BOOL)grid
{
    self = [self initWithType:axisTypeNumeric position:position dataFieldName:fieldName title:title drawGrid:grid];
    
    // Any other init setting related to numeric axis gose here
    
    return self;
}

- (id)initCategoryAxisWithPosition:(axisPosition)position dataFieldName:(NSString *)fieldName title:(NSString *)title drawGrid:(BOOL)grid
{
    self = [self initWithType:axisTypeCategory position:position dataFieldName:fieldName title:title drawGrid:grid];
    
    // Any other init setting related to category axis gose here
    
    return self;
}

- (NSString *)getTextForType:(axisType)type
{
    switch (type) {
        case axisTypeNumeric:
            return @"numeric";
            break;
        case axisTypeCategory:
            return @"category";
            break;
        default:
            NSLog(@"Undefinex axis type, category will be used by default");
            return @"category";
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
    result = [result stringByAppendingFormat:@"fields:%@,",[[[NSArray alloc]initWithObjects:_dataFieldName, nil] JSONString]];
    
    // Adding optional info
    (_title) ? result = [result stringByAppendingFormat:@"title:%@,",[_title JSONString]] : nil;
    result = [result stringByAppendingFormat:@"grid:%d",[[NSNumber alloc]initWithBool:_grid]];
    
    return [result inCurlyBrackets];
}


@end
