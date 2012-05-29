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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - SGLineDataSource

- (int)numberOfLinesInChart
{
    return 1;
}

- (int)numberOfPointsInLines
{
    return 30;
}

- (id)xForPoint:(NSNumber *)point inLine:(NSNumber *)line
{
    return [[NSDate date] description];
}

- (id)yForPoint:(NSNumber *)point inLine:(NSNumber *)line
{
    if ([line intValue] == 0)
    {
        return [[NSNumber alloc]initWithInt:arc4random_uniform(30)];
    }
    else
        return [[NSNumber alloc]initWithInt:[point intValue]+1];
}

- (NSString *)descForPoint:(NSNumber *)point inLine:(NSNumber *)line
{
    if ([line intValue] == 0)
        return [NSString stringWithFormat:@"test1_%d",[point intValue]];
    else
        return [NSString stringWithFormat:@"test2_%d",[point intValue]];
}

- (NSString *)titleForAxisInPosition:(axisPosition)position
{
    if (position == axisPositionLeft || position == axisPositionBottom) {
        return @"test";
    }
    return nil;
}

@end
