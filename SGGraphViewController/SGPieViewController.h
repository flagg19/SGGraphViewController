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
- (int)numberOfSlicesInPie;
- (NSString *)labelForSlice:(int)num;
- (NSNumber *)valueForSlice:(int)num;

@end

@interface SGPieViewController : SGGraphBaseViewController {
    
    // Made of delightful dictionaries -> key (slice label) value (slice value)
    NSMutableArray *_pie;
}

@property (nonatomic, retain) id <SGPieDataSource> dataSource;

@end

