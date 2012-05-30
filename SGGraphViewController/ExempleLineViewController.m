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

- (NSNumber *)numberOfLinesInChart
{
    return [[NSNumber alloc]initWithInt:2];
}

- (NSNumber *)numberOfPointsInLines
{
    return [[NSNumber alloc]initWithInt:30];
}

- (id)xForPoint:(NSNumber *)point
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

- (NSString *)descForPoint:(NSNumber *)point
{
    return @"test";
}

- (BOOL)itemInfoInteraction
{
    return YES;
}

- (NSNumber *)smoothValueForLine:(NSNumber *)line
{
    return [[NSNumber alloc]initWithInt:4];
}

- (NSString *)titleForAxisInPosition:(axisPosition)position
{
    if (position == axisPositionLeft || position == axisPositionBottom) {
        return [NSString string];
    }
    return nil;
}


@end
