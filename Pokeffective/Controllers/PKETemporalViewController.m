//
//  PKETemporalViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 28/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKETemporalViewController.h"

@interface PKETemporalViewController ()

- (void)configureNoContentLabel;

@end

@implementation PKETemporalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNoContentLabel];
}

- (void)configureNoContentLabel
{
    UILabel *lblNoContent = [[UILabel alloc] initWithFrame:CGRectZero];
    lblNoContent.backgroundColor = [UIColor clearColor];
    [lblNoContent setNumberOfLines:0];
    [lblNoContent setTextAlignment:NSTextAlignmentCenter];
    [lblNoContent setTextColor:[UIColor colorWithHexString:@"#898C90"]];
    [lblNoContent setText:@"We'll let you know when this is ready ;)"];
    [[self view] addSubview:lblNoContent];
    [lblNoContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(lblNoContent.superview).with.insets(UIEdgeInsetsMake(50, 50, 50, 50));
    }];
}

@end
