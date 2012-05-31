//
//  SGPieViewController.h
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGGraphBaseViewController.h"

@protocol SGPieDataSource <NSObject>
@required
- (NSNumber *)numberOfSlicesInPie;
- (NSNumber *)valueForSlice:(NSNumber *)num;
- (NSString *)labelForSlice:(NSNumber *)num;
@optional
- (BOOL)shouldShowLegend;
/*
 * You can compose any string, special values are: {value} and {key} that will 
 * be replaced with the slice specific values. The rest of the string may be
 * whatever you want.
 */
- (NSString *)formatSlicesLabels;
@end

@interface SGPieViewController : SGGraphBaseViewController {
    
    // Made of delightful dictionaries -> key (slice label) value (slice value)
    NSMutableArray *_pie;
}

@property (nonatomic, retain) id <SGPieDataSource> dataSource;

@end

