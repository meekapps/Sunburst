//
//  SunburstView.m
//  Sunburst
//
//  Created by Mike Keller on 2/20/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//

#import "SunburstView.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation SunburstView

@synthesize beams, strokeColor, fillColor;

- (id)initWithFrame:(CGRect)frame beams:(NSInteger)theBeams fillColor:(UIColor*)theFillColor strokeColor:(UIColor*)theStrokeColor {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.beams = theBeams;
        self.fillColor = theFillColor;
        self.strokeColor = theStrokeColor;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat radius = rect.size.width/2.0f;
    
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGPoint centerPoint = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);

    CGPoint thisPoint = CGPointMake(centerPoint.x + radius, centerPoint.y);
    [bezierPath moveToPoint:centerPoint];
    
    CGFloat thisAngle = 0.0f;
    CGFloat sliceDegrees = 360.0f / self.beams / 2.0f;
    
    for (int i = 0; i < self.beams; i++) {
        
        CGFloat x = radius * cosf(DEGREES_TO_RADIANS(thisAngle + sliceDegrees)) + centerPoint.x;
        CGFloat y = radius * sinf(DEGREES_TO_RADIANS(thisAngle + sliceDegrees)) + centerPoint.y;
        thisPoint = CGPointMake(x, y);
        [bezierPath addLineToPoint:thisPoint];
        thisAngle += sliceDegrees;
        
        CGFloat x2 = radius * cosf(DEGREES_TO_RADIANS(thisAngle + sliceDegrees)) + centerPoint.x;
        CGFloat y2 = radius * sinf(DEGREES_TO_RADIANS(thisAngle + sliceDegrees)) + centerPoint.y;
        thisPoint = CGPointMake(x2, y2);
        [bezierPath addLineToPoint:thisPoint];
        [bezierPath addLineToPoint:centerPoint];
        thisAngle += sliceDegrees;
        
    }
    
    [bezierPath closePath];
    
    bezierPath.lineWidth = 1;
    [bezierPath fill];
    [bezierPath stroke];

}

- (void) rotateWithDuration:(CGFloat)duration clockwise:(BOOL)clockwise repeats:(BOOL)repeats {
    CGFloat direction;
    if (clockwise) direction = 1.0f;
    else direction = -1.0f;
    
    [UIView animateWithDuration:duration/2.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(179.999f * direction), 0.0f, 0.0f, 1.0f);
                     } completion:^(BOOL finished) {
                         self.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180.0f * direction), 0.0f, 0.0f, 1.0f);
                         [UIView animateWithDuration:duration/2.0f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                             self.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(359.999f * direction), 0.0f, 0.0f, 1.0f);
                                          } completion:^(BOOL finished) {
                                              self.layer.transform = CATransform3DIdentity;
                                              
                                              if (repeats) {
                                                  [self rotateWithDuration:duration clockwise:clockwise repeats:repeats];
                                              }
                                          }];
                     }];
}

- (void) dealloc {
    self.fillColor = nil;
    self.strokeColor = nil;
}

@end
