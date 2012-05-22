//
//  ExempleLineViewController.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExempleLineViewController.h"

@interface ExempleLineViewController ()

@end

@implementation ExempleLineViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setDataSource:self];
    [self reloadData];
}


#pragma mark - SGLineDataSource

- (int)numberOfLinesInChart
{
    return 2;
}

- (int)numberOfPointsInLines
{
    return 37;
}

- (id)xForPoint:(NSNumber *)point inLine:(NSNumber *)line
{
    if ([line intValue] == 0)
        return point;
    else
        return @"hello";
}

- (id)yForPoint:(NSNumber *)point inLine:(NSNumber *)line
{
    if ([line intValue] == 0)
        return point;
    else
        return [[NSNumber alloc]initWithInt:[point intValue]+1];
}

- (NSString *)titleForAxisInPosition:(axisPosition)position
{
    if (position == axisPositionLeft || position == axisPositionBottom) {
        return @"test";
    }
    return nil;
}

@end
