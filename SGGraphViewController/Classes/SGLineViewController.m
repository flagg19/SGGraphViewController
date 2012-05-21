//
//  SGLineViewController.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGLineViewController.h"

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

- (NSArray *)convertLinesToDrawableData;

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

- (void)reloadData
{
    // No need to bother if no data source has been setted
    if (!self.dataSource)
        return;
    
    // For every lines
    int tempLines = (int)[self.dataSource performSelector:@selector(numberOfLinesInChart)];
    for (int line=0; line<tempLines; line++) {
        SGLine *newLine = [[SGLine alloc]init];
        // For every point in that line
        int tempPoints = (int)[self.dataSource performSelector:@selector(numberOfPointsInLines)];
        for (int point=0; point<tempPoints; point++) {
            SGPoint *newPoint = [[SGPoint alloc]init];
            // Setting up the point
            newPoint.x = [self.dataSource performSelector:@selector(xForPoint:inLine:)
                                               withObject:[[NSNumber alloc]initWithInt:point]
                                               withObject:[[NSNumber alloc]initWithInt:line]];
            newPoint.y = [self.dataSource performSelector:@selector(yForPoint:inLine:)
                                               withObject:[[NSNumber alloc]initWithInt:point]
                                               withObject:[[NSNumber alloc]initWithInt:line]];
            newPoint.desc = [self.dataSource performSelector:@selector(descForPoint:inLine:)
                                                  withObject:[[NSNumber alloc]initWithInt:point]
                                                  withObject:[[NSNumber alloc]initWithInt:line]];
            // Adding the point to the line
            [newLine.points addObject:newPoint];
        }
        // Adding the line to the lines array
        [_lines addObject:newLine];
    }
    
    [self setupChartWithSize:self.view.frame.size
                        data:[self convertLinesToDrawableData]
                   firstAxis:nil
                 secondyAxis:nil];
}

- (void)bindAxesToLine:(int)line withXTitle:(NSString *)xTitle andYTitle:(NSString *)yTitle
{
    // No need to bother if there's no data
    if ([_lines count] == 0)
        return;
    
    /* 
     * Try to find out what type of axis to use (numeric or category) looking at
     * the data type of the id objects in the x coordinate of a point
     */
    
    id sample = [[[_lines objectAtIndex:line] points] objectAtIndex:0];
    _firstAxes = ([[(SGPoint *)sample x] isKindOfClass:[NSString class]])
    ? [[SGAxis alloc]initCategoryAxisWithPosition:axisPositionLeft dataFieldName:@"x_0" title:xTitle drawGrid:YES]
    : [[SGAxis alloc]initNumericAxisWithPosition:axisPositionLeft dataFieldName:@"x_0" title:xTitle drawGrid:YES];

    _secondAxes = ([[(SGPoint *)sample y] isKindOfClass:[NSString class]])
    ? [[SGAxis alloc]initCategoryAxisWithPosition:axisPositionLeft dataFieldName:@"y_0" title:yTitle drawGrid:YES]
    : [[SGAxis alloc]initNumericAxisWithPosition:axisPositionLeft dataFieldName:@"y_0" title:yTitle drawGrid:YES];
}

- (NSArray *)convertLinesToDrawableData
{
    NSMutableArray *results = [[NSMutableArray alloc]init];
    
    int row = [[[_lines objectAtIndex:0] points] count];
    int column = [_lines count]*3;
    
    for (int r=0; r<row; r++) {
        NSMutableDictionary *newRow = [[NSMutableDictionary alloc] init];
        for (int c=0; c<column; c++) {
            
            NSString *key;
            switch (c%3) {
                case 0:
                    key = [NSString stringWithFormat:@"x_%d", c/3];
                    break;
                case 1:
                    key = [NSString stringWithFormat:@"y_%d", c/3];
                    break;
                case 2:
                    key = [NSString stringWithFormat:@"desc_%d", c/3];
                    break;
                default:
                    break;
            }
            [newRow setValue:[(SGPoint *)[[[_lines objectAtIndex:c/3] points] objectAtIndex:r] x]
                      forKey:key];
        }
        [results addObject:newRow];
    }
    
    return results;
    /*
     {'x_0':value, y_0:10, 'data2':12, 'data3':14, 'data4':8, 'data5':13},
     {'x_0':value, 'data1':7, 'data2':8, 'data3':16, 'data4':10, 'data5':3},
     */
}


@end










