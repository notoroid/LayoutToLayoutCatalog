//
//  TwoViewController.m
//  AutoLayoutTest
//
//  Created by 能登 要 on 2014/01/08.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 不具合?
    // 1番目のUICollectionViewFlowLayout を使っていると2番目に定義したUICollectionViewFlowLayoutのdelegate を参照してしまう
    // LayoutToLayout を使うとUICollectionViewFlowLayoutのdelegateが元にもどらないのかもしれない
    // 以上の理由でUICollectionViewFlowLayoutDelegateを使ったレイアウト調整は危険かもしれない
    
    
    return CGSizeMake(320.0f, indexPath.row == 0 ? 85.0f : 65.0f );
}

@end
