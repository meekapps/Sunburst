//
//  SunburstView.h
//  Sunburst
//
//  Created by Mike Keller on 2/20/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIView

@end

@interface SunburstView : UIView {
    NSInteger beams;
    UIColor *fillColor, *strokeColor;
    BOOL fadeEdges;
}

@property (nonatomic) NSInteger beams;
@property (nonatomic, strong) UIColor *fillColor, *strokeColor;
@property (nonatomic) BOOL fadeEdges;

- (id)initWithFrame:(CGRect)frame beams:(NSInteger)theBeams fillColor:(UIColor*)theFillColor strokeColor:(UIColor*)theStrokeColor fadeEdges:(BOOL)fadeEdges;
- (void) rotateWithDuration:(CGFloat)duration clockwise:(BOOL)clockwise repeats:(BOOL)repeats;

@end
