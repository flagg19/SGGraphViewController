//
//  SGLineViewController.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGLineViewController.h"
#import "NSString+Additions.h"

@implementation SGPoint
@synthesize x = _x;
@synthesize y = _y;
@synthesize desc = _desc;
@end

@implementation SGLine
@synthesize points = _points;
- (id)init
{
    if (self = [super init])
        self.points = [[NSMutableArray alloc] init];
    return self;
}
@end

@interface SGLineViewController ()

- (SGAxis *)setupAxisWithTitle:(NSString *)title position:(axisPosition)position;
- (NSArray *)convertLinesToDrawableData;
- (NSString *)getJSTextSerieForLine:(int)line;

@end

@implementation SGLineViewController

@synthesize dataSource = _dataSource;

- (id)init
{
    if (self = [super init]) {
        // Custom init here...
        _lines = [[NSMutableArray alloc] init];
    }
    return self;
}

- (SGAxis *)setupAxisWithTitle:(NSString *)title position:(axisPosition)position
{
    if (!title)
        return nil;
    
    // Creating axes
    
    NSMutableArray *fields = [[NSMutableArray alloc]init];
    axisType type = axisTypeNumeric;
    
    
    for (int l=0; l<[_lines count]; l++) {
        (position == axisPositionLeft || position == axisPositionRight)
        ? [fields addObject:[NSString stringWithFormat:@"y_%d",l]]
        : [fields addObject:[NSString stringWithFormat:@"x_%d",l]];
        
        /* 
         * Try to find out what type of axis to use (numeric or category) looking at
         * the data type of the id objects in the y coordinate of a point. 
         * Falling back to axisTypeCategory if there's at least one NSString.
         */
        
        id sample = (position == axisPositionLeft || position == axisPositionRight)
        ? [(SGPoint *)[[[_lines objectAtIndex:l] points] objectAtIndex:0] y]
        : [(SGPoint *)[[[_lines objectAtIndex:l] points] objectAtIndex:0] x];
        
        if ([sample isKindOfClass:[NSString class]]) {
            type = axisTypeCategory;
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
     
     {'x_0':value, 'y_0':10, 'desc_0':12, 'x_1':14, 'y_1':8, 'desc_1':13},
     {'x_0':value, 'y_0':7, 'desc_0':8, 'x_1':16, 'y_1':10, 'desc_1':3},
     ...
     
     Every "row" is formed by the coordinate of every line: x,y,dec,x,y,des ecc.
     So the number of rows is given by the number of point in the rows.
     The number of column is 3 (x,y,des) multplyed by the number of lines.
     */
    
    int row = [[[_lines objectAtIndex:0] points] count];
    int column = [_lines count]*3;
    
    for (int r=0; r<row; r++) {
        NSMutableDictionary *newRow = [[NSMutableDictionary alloc] init];
        for (int c=0; c<column; c++) {
            
            NSString *key;
            switch (c%3) {
                case 0:
                    key = [NSString stringWithFormat:@"x_%d", c/3];
                    [newRow setValue:[(SGPoint *)[[[_lines objectAtIndex:c/3] points] objectAtIndex:r] x]
                              forKey:key];
                    break;
                case 1:
                    key = [NSString stringWithFormat:@"y_%d", c/3];
                    [newRow setValue:[(SGPoint *)[[[_lines objectAtIndex:c/3] points] objectAtIndex:r] y]
                              forKey:key];
                    break;
                case 2:
                    key = [NSString stringWithFormat:@"desc_%d", c/3];
                    [newRow setValue:[(SGPoint *)[[[_lines objectAtIndex:c/3] points] objectAtIndex:r] desc]
                              forKey:key];
                    break;
                default:
                    NSLog(@"Impossible case in convertLinesToDrawableData function.");
                    break;
            }
        }
        [results addObject:newRow];
    }
    
    return results;
}

- (NSString *)getJSTextSerieForLine:(int)line
{
    NSString *results = [NSString stringWithFormat:@"{type:\"line\",axis:\"left\",xField:%@,yField:%@}",
                         [NSString stringWithFormat:@"\"x_%d\"",line],
                         [NSString stringWithFormat:@"\"y_%d\"",line]];
    
    return results;
    
    /*
     {
     type: 'line',
     axis: 'left',
     xField: 'name',
     yField: 'data1',
     }
     */
}

#pragma mark - Superclass overriden methods

- (void)reloadData
{
    // No need to bother if no data source has been setted
    if (!self.dataSource)
        return;
    
    // For every lines
    int tempLines = (int)[self.dataSource numberOfLinesInChart];
    for (int line=0; line<tempLines; line++) {
        SGLine *newLine = [[SGLine alloc]init];
        // For every point in that line
        int tempPoints = (int)[self.dataSource numberOfPointsInLines];
        for (int point=0; point<tempPoints; point++) {
            SGPoint *newPoint = [[SGPoint alloc]init];
            // Setting up the point
            newPoint.x = [self.dataSource xForPoint:[[NSNumber alloc]initWithInt:point]
                                             inLine:[[NSNumber alloc]initWithInt:line]];
            newPoint.y = [self.dataSource yForPoint:[[NSNumber alloc]initWithInt:point]
                                             inLine:[[NSNumber alloc]initWithInt:line]];
            
            // Check if optional protocol method has being implemented
            if ([self.dataSource respondsToSelector:@selector(descForPoint:inLine:)]) {
                newPoint.desc = [self.dataSource descForPoint:[[NSNumber alloc]initWithInt:point]
                                                       inLine:[[NSNumber alloc]initWithInt:line]];
            }
            
            // Adding the point to the line
            [newLine.points addObject:newPoint];
        }
        // Adding the line to the lines array
        [_lines addObject:newLine];
    }
    
    CGSize content = CGSizeMake(800, self.view.frame.size.height);

    [self setupChartWithSize:content
                        data:[self convertLinesToDrawableData]];
    [self showChart];
}

- (NSString *)getJSTextSeries
{
    NSString *results = @"series:[";
    
    // Generating every serie (one per line)
    for (int l=0; l<[_lines count]; l++) {
        results = [results stringByAppendingString:[self getJSTextSerieForLine:l]];
        // Avoid adding comma last line
        (l+1 < [_lines count]) ? results = [results addComma] : nil;
    }
    
    return [results stringByAppendingString:@"]"];
    
    /*
     series: [{
     type: 'line',
     axis: 'left',
     xField: 'name',
     yField: 'data1',
     }, {
     type: 'line',
     axis: 'left',
     xField: 'name',
     yField: 'data4',
     }]
     */
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










