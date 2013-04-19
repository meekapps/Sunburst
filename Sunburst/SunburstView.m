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

#pragma mark - Mask
@implementation MaskView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float gradRadius = MIN(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f) ;
    
    CGContextDrawRadialGradient (context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
}

@end

#pragma mark - Sunburst

@implementation SunburstView

@synthesize beams, strokeColor, fillColor, fadeEdges;

- (id)initWithFrame:(CGRect)frame beams:(NSInteger)theBeams fillColor:(UIColor*)theFillColor strokeColor:(UIColor*)theStrokeColor fadeEdges:(BOOL)theFadeEdges {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.beams = theBeams;
        self.fillColor = theFillColor;
        self.strokeColor = theStrokeColor;
        self.fadeEdges = theFadeEdges;
        
        if (self.fadeEdges) {
            MaskView *maskView = [[MaskView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
            UIImage *_maskingImage = [self imageWithView:maskView];
            CALayer *_maskingLayer = [CALayer layer];
            _maskingLayer.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
            [_maskingLayer setContents:(id)[_maskingImage CGImage]];
            [self.layer setMask:_maskingLayer];
            
        }
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}

- (UIImage *) imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)drawRect:(CGRect)rect {
    CGFloat radius = rect.size.width/2.0f;
    
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGPoint centerPoint = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
    
    [bezierPath moveToPoint:centerPoint];
    
    CGFloat thisAngle = 0.0f;
    CGFloat sliceDegrees = 360.0f / self.beams / 2.0f;
    
    CGPoint thisPoint;
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
                         if (!finished) return;
                         self.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180.0f * direction), 0.0f, 0.0f, 1.0f);
                         [UIView animateWithDuration:duration/2.0f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(359.999f * direction), 0.0f, 0.0f, 1.0f);
                                          } completion:^(BOOL finished) {
                                              if (!finished) return;
                                              self.layer.transform = CATransform3DIdentity;
                                              
                                              if (repeats) {
                                                  [self rotateWithDuration:duration clockwise:clockwise repeats:repeats];
                                              }
                                          }];
                     }];
}

- (void) stopRotation {
    [self.layer removeAllAnimations];
}

- (void) dealloc {
    self.fillColor = nil;
    self.strokeColor = nil;
}

@end
