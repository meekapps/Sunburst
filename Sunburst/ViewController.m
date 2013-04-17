//
//  ViewController.m
//  Sunburst
//
//  Created by Mike Keller on 2/20/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//

#import "ViewController.h"
#import "SunburstView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIColor *fillColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:184.0f/255.0f alpha:0.5f];
    UIColor *strokeColor = [UIColor clearColor];
    SunburstView *sunburst = [[SunburstView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 300.0f) beams:18 fillColor:fillColor strokeColor:strokeColor fadeEdges:YES];
    sunburst.layer.position = self.view.layer.position;
    [self.view addSubview:sunburst];
    [sunburst rotateWithDuration:60.0f clockwise:YES repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
