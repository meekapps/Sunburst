//
//  SunburstView.h
//  Sunburst
//
//  Created by Mike Keller on 2/20/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunburstView : UIView {
    NSInteger beams;
    UIColor *fillColor, *strokeColor;
}

@property (nonatomic) NSInteger beams;
@property (nonatomic, strong) UIColor *fillColor, *strokeColor;

- (id)initWithFrame:(CGRect)frame beams:(NSInteger)beams fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor;
- (void) rotateWithDuration:(CGFloat)duration clockwise:(BOOL)clockwise repeats:(BOOL)repeats;

@end
