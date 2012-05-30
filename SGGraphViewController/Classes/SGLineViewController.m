//
//  SGLineViewController.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGLineViewController.h"
#import "NSString+Additions.h"


@interface SGLineViewController ()

- (SGAxis *)setupAxisWithTitle:(NSString *)title position:(axisPosition)position;
- (NSArray *)convertLinesToDrawableData;
- (NSString *)getJSTextSerieForLine:(int)line;
// Future improvement should move intteraction to a separate class
- (NSString *)getJSTextInteractions;

@end

@implementation SGLineViewController

@synthesize dataSource = _dataSource;

- (id)init
{
    if (self = [super init]) {
        // Custom init here...
        _x = [[NSMutableArray alloc] init];
        _desc = [[NSMutableArray alloc] init];
        _ys = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Private functions

- (SGAxis *)setupAxisWithTitle:(NSString *)title position:(axisPosition)position
{
    if (!title)
        return nil;
    
    // Creating axes
    NSMutableArray *fields = [[NSMutableArray alloc]init];
    axisType type = axisTypeUndefined;
    
    
    if ((position == axisPositionTop || position == axisPositionBottom)) {
        // Adding x field to the x axis
        [fields addObject:@"x"];
        type = axisTypeCategory;
    }
    else {
        // Looping throught ys and adding them all to the y axis
        for (int l=0; l<[_ys count]; l++) {
            [fields addObject:[NSString stringWithFormat:@"y_%d",l]];
            // If type is still numeric, looking if the actual line is numeric only
            if (type == axisTypeNumeric) {
                for (id sample in [_ys objectAtIndex:l]) {
                    if ([sample isKindOfClass:[NSString class]]) {
                        type = axisTypeCategory;
                        break;
                    }
                }
            }
        }
    }
    
    return (type == axisTypeCategory)
    ? [[SGAxis alloc]initCategoryAxisWithPosition:position dataFieldNames:fields title:title drawGrid:YES]
    : [[SGAxis alloc]initNumericAxisWithPosition:position dataFieldNames:fields title:title drawGrid:YES];
}

- (NSArray *)convertLinesToDrawableData
{
    NSMutableArray *results = [[NSMutableArray alloc]init];
    
    /*
     The final strcture will be something like this: an array of dic.
     {'x':value, 'y_0':10, 'desc':12, 'y_1':8},
     {'x':value, 'y_0':7, 'desc':8, 'y_1':10},
     ...
     */

    int rows = [_x count];
    int column = [_ys count];
    
    for (int r=0; r<rows; r++) {
        NSMutableDictionary *row = [[NSMutableDictionary alloc]init];
        [row setValue:[_x objectAtIndex:r] forKey:@"x"];
        [row setValue:[_desc objectAtIndex:r] forKey:@"desc"];
        for (int c=0; c<column; c++) {
            [row setValue:[[_ys objectAtIndex:c] objectAtIndex:r] forKey:[NSString stringWithFormat:@"y_%d",c]];
        }
        [results addObject:row];
    }
    
    return results;
}

- (NSString *)getJSTextSerieForLine:(int)line
{
    // Asking for optional smooth value
    NSNumber *smooth = ([self.dataSource respondsToSelector:@selector(smoothValueForLine:)])
    ? [self.dataSource smoothValueForLine:[[NSNumber alloc]initWithInt:line]]
    : [[NSNumber alloc]initWithInt:0];
    
    NSString *results = [NSString stringWithFormat:@"{type:\"line\",axis:\"left\",smooth:%d,xField:\"x\",yField:\"y_%d\"}",
                         [smooth intValue],
                         line];
    return results;
}

- (NSString *)getJSTextInteractions
{
    // Asking for optional itemInfo 
    BOOL itemInfo = ([self.dataSource respondsToSelector:@selector(itemInfoInteraction)])
    ? [self.dataSource itemInfoInteraction]
    : NO;
    
    if (itemInfo) {
        return
        @"interactions:[{"
        "type:'iteminfo',"
        "listeners: {"
        "show: function(interaction, item, panel) {"
        "panel.update(['<ul><li>'+item.storeItem.get('desc')+'</li>','<li>'+item.value[1]+'</li></ul>'].join(''));"
        "}}}]";
    }
    
    return nil;
}

#pragma mark - Superclass overriden methods

- (void)reloadData
{
    // Clearing the local arrays
    [_x removeAllObjects];
    [_desc removeAllObjects];
    [_ys removeAllObjects];
    
    // No need to bother if no data source has been setted
    if (!self.dataSource)
        return;
    
    int tempLines = [[self.dataSource numberOfLinesInChart] intValue];
    int tempPoints = [[self.dataSource numberOfPointsInLines] intValue];
    
    // Asking for x & desc
    for (int point=0; point<tempPoints; point++) {
        [_x addObject:[self.dataSource xForPoint:[[NSNumber alloc]initWithInt:point]]];
        [_desc addObject:[self.dataSource descForPoint:[[NSNumber alloc]initWithInt:point]]];
    }
    
    // Asking for ys
    for (int line=0; line<tempLines; line++) {
        NSMutableArray* tempY = [[NSMutableArray alloc] init];
        for (int point=0; point<tempPoints; point++) {
            [tempY addObject:[self.dataSource yForPoint:[[NSNumber alloc]initWithInt:point]
                                                 inLine:[[NSNumber alloc]initWithInt:line]]];
        }
        [_ys addObject:tempY];
    }

    [self setupChartWithData:[self convertLinesToDrawableData]];
    [self showChart];
}

- (NSString *)getJSTextSeries
{
    NSString *results = @"series:[";
    
    // Generating every serie (one per line)
    for (int l=0; l<[_ys count]; l++) {
        results = [results stringByAppendingString:[self getJSTextSerieForLine:l]];
        // Avoid adding comma last line
        (l+1 < [_ys count]) ? results = [results addComma] : nil;
    }
    
    return [results stringByAppendingString:@"]"];
}

- (NSString *)getJSTextAxes
{
    NSMutableArray *axes = [[NSMutableArray alloc]init];
    
    // Asking the datasource for axes settings
    
    SGAxis *temp1 = [self setupAxisWithTitle:[self.dataSource titleForAxisInPosition:axisPositionLeft] position:axisPositionLeft];
    (temp1) ? [axes addObject:temp1] : nil;
    SGAxis *temp2 = [self setupAxisWithTitle:[self.dataSource titleForAxisInPosition:axisPositionRight] position:axisPositionRight];
    (temp2) ? [axes addObject:temp2] : nil;
    SGAxis *temp3 = [self setupAxisWithTitle:[self.dataSource titleForAxisInPosition:axisPositionTop] position:axisPositionTop];
    (temp3) ? [axes addObject:temp3] : nil;
    SGAxis *temp4 = [self setupAxisWithTitle:[self.dataSource titleForAxisInPosition:axisPositionBottom] position:axisPositionBottom];
    (temp4) ? [axes addObject:temp4] : nil;
        
    if ([axes count] == 0) {
        return nil;
    }
 
    return [SGAxis getJSTextAxes:axes];
}

@end










