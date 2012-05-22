//
//  SGAxis.h
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    axisTypeNumeric,
    axisTypeCategory,
    axisTypeUndefined
} axisType;

typedef enum {
    axisPositionLeft,
    axisPositionRight,
    axisPositionBottom,
    axisPositionTop
} axisPosition;

@interface SGAxis : NSObject {
    
    axisType _type;                 // Needed
    axisPosition _position;         // Needed (left assumed if not setted)
    
    // An array of strings
    NSArray *_dataFieldNames;       // Needed
    
    NSString *_title;               // Optional
    BOOL _grid;                     // Optional (NO assumed if not setted)
}

// They are almost identical now but further implementation will differ a lot
- (id)initNumericAxisWithPosition:(axisPosition)position dataFieldNames:(NSArray *)fieldNames title:(NSString *)title drawGrid:(BOOL)grid;
- (id)initCategoryAxisWithPosition:(axisPosition)position dataFieldNames:(NSArray *)fieldNames title:(NSString *)title drawGrid:(BOOL)grid;

// Using internal vars, return something like:
/*
 {
 type: 'Numeric',
 position: 'left',
 fields: ['data1'],
 title: 'Sample Values',
 grid: true,
 minimum: 0
 }
 */
- (NSString *)getJSTextAxis;
+ (NSString *)getJSTextAxes:(NSArray *)axes;

@end
