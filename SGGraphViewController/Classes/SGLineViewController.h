//
//  SGLineViewController.h
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGGraphBaseViewController.h"
@class SGAxis;

@protocol SGLineDataSource <NSObject>

@required
- (int)numberOfLinesInChart;
- (int)numberOfPointsInLines;
// If nil is setted the axis is inactive
- (NSString *)titleForAxisInPosition:(axisPosition)position;
- (id)xForPoint:(NSNumber *)point inLine:(NSNumber *)line;
- (id)yForPoint:(NSNumber *)point inLine:(NSNumber *)line;
@optional
// Value not in use atm.
- (NSString *)descForPoint:(NSNumber *)point inLine:(NSNumber *)line;

@end

/*
 * Used to rapresent the points of the line chart (obj-c side)
 */
@interface SGPoint : NSObject
@property (nonatomic, retain) id x;
@property (nonatomic, retain) id y;
@property (nonatomic, retain) NSString *desc;
@end

/*
 * Used to rapresent the lines of the line chart (obj-c side)
 */
@interface SGLine : NSObject
// Made of SGPoint
@property (nonatomic, retain) NSMutableArray *points;
@end


@interface SGLineViewController : SGGraphBaseViewController {
    
    // Made of SGLine
    NSMutableArray *_lines;
}

@property (nonatomic, retain) id <SGLineDataSource> dataSource;

@end
