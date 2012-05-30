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
- (NSNumber *)numberOfLinesInChart;
- (NSNumber *)numberOfPointsInLines;
- (NSString *)xForPoint:(NSNumber *)point;
- (NSString *)descForPoint:(NSNumber *)point;
- (id)yForPoint:(NSNumber *)point inLine:(NSNumber *)line;
// If nil the axis is inactive, if @"" the axis has no title
- (NSString *)titleForAxisInPosition:(axisPosition)position;
@optional
// Valid values are from 0 to 10
- (NSNumber *)smoothValueForLine:(NSNumber *)line;
- (BOOL)itemInfoInteraction;
@end


@interface SGLineViewController : SGGraphBaseViewController {
    
    NSMutableArray *_x;
    NSMutableArray *_desc;
    NSMutableArray *_ys;
}

@property (nonatomic, retain) id <SGLineDataSource> dataSource;

@end
