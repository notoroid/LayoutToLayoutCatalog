//
//  TwoViewController.m
//  AutoLayoutTest
//
//  Created by 能登 要 on 2014/01/09.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController () <UICollectionViewDelegateFlowLayout>

@end

@implementation TwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeAll;
    // 回り込み有効

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
