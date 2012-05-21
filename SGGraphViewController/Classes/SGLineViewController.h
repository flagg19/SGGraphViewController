//
//  SGLineViewController.h
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGGraphBaseViewController.h"

@protocol SGLineDataSource <NSObject>

- (int)numberOfLinesInChart;
- (int)numberOfPointsInLines;
- (id)xForPoint:(NSNumber *)point inLine:(NSNumber *)line;
- (id)yForPoint:(NSNumber *)point inLine:(NSNumber *)line;
- (NSString *)descForPoint:(NSNumber *)point inLine:(NSNumber *)line;

@end


@interface SGPoint : NSObject
@property (nonatomic, retain) id x;
@property (nonatomic, retain) id y;
@property (nonatomic, retain) NSString *desc;
@end

@interface SGLine : NSObject
// Made of SGPoint
@property (nonatomic, retain) NSMutableArray *points;
@end


@interface SGLineViewController : SGGraphBaseViewController {
    
    // Made of SGLine
    NSMutableArray *_lines;
}

@property (nonatomic, retain) id <SGLineDataSource> dataSource;

- (void)bindAxesToLine:(int)line withXTitle:(NSString *)xTitle andYTitle:(NSString *)yTitle;
- (void)reloadData;

@end
