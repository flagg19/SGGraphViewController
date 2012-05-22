//
//  SGPieViewController.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGPieViewController.h"

@interface SGPieViewController ()

@end

@implementation SGPieViewController
@synthesize dataSource = _dataSource;

- (void)reloadData
{
    // No need to bother if no data source has been setted
    if (!self.dataSource)
        return;
    
    // For every slice
    int tempSlices = (int)[self.dataSource numberOfSlicesInPie];
    for (int slice=0; slice<tempSlices; slice++) {
        
    }
    
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
    
    [self setupChartWithSize:self.view.frame.size
                        data:[self convertLinesToDrawableData]];
    [self showChart];
}

#pragma mark - Superclass overriden methods

- (NSString *)getJSTextSeries
{
    return @"series: [{\
    type: 'pie',\
    angleField: 'data2',\
    showInLegend: true,\
    label: {\
    field: 'name',\
    display: 'rotate',\
    contrast: true,\
    font: '18px Arial'\
    }}]";
}

@end
