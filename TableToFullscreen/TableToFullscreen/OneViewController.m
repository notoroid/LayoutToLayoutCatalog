//
//  OneViewController.m
//  AutoLayoutTest
//
//  Created by 能登 要 on 2014/01/07.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "OneViewController.h"
#import "ExpandTableLayout.h"
#import "TwoViewController.h"

@interface FullScreenLayout : UICollectionViewLayout
{
    NSIndexPath* _indexPath;
}
- (id)initWithFullscreenIndexPath:(NSIndexPath*)indexPath;
@end

@implementation FullScreenLayout

- (id)initWithFullscreenIndexPath:(NSIndexPath*)indexPath
{
    self = [super init];
    if (self) {
        [self setInitialValues];
        _indexPath = indexPath;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setInitialValues];
    }
    return self;
}

- (void)setInitialValues {
    // カスタム初期化クラス
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setInitialValues];
    }
    return self;
}

// 表示するセルの総数を返す（今回はセクション0のみを対象とする）
- (NSInteger)count {
    return [self.collectionView numberOfItemsInSection:0];
}

// collectionViewのスクロール可能領域の大きさを返す
- (CGSize)collectionViewContentSize
{
    CGSize size = self.collectionView.bounds.size;
    return size;
}

- (CGRect) rectForRow:(NSInteger)row
{
    CGFloat top = (row - _indexPath.row) * self.collectionView.bounds.size.height;
    CGFloat height = self.collectionView.bounds.size.height;

    CGRect rect = CGRectMake(.0f, top ,self.collectionView.bounds.size.width,height);
    return rect;
}

// 指定された矩形に含まれるセルのIndexPathを返す
- (NSArray *)indexPathsForItemsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.count; i++){
        CGRect rectHittest = [self rectForRow:i];
        // 矩形を取得
        
        if( CGRectIntersectsRect(rect, rectHittest) ){
            [array addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
    return array;
}

// 指定された矩形内に含まれる表示要素のレイアウト情報を返す
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *indices = [self indexPathsForItemsInRect:rect];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:indices.count];
    for (NSIndexPath *indexPath in indices) {
        [array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return array;
}



//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
//    
//    
//    
//    return nil;
//}

// 各UICollectionViewCellに適用するレイアウト情報を返す
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if([indexPath isEqual:_indexPath] != YES ){
        attr.zIndex += 1;
    }else{
    }
    
    attr.frame = [self rectForRow:indexPath.row];
    
    return attr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
}

@end

#pragma mark - 

@interface OneViewController () <UICollectionViewDelegateFlowLayout>
{
    BOOL _fullScreen;
}
@property (strong,nonatomic) UICollectionViewLayout *originalLayout;
@property (strong,nonatomic) NSArray* colors;
@end

@implementation OneViewController

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

	self.colors = @[ [UIColor redColor],[UIColor grayColor],[UIColor blueColor]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
        // 回り込み有効

//    self.originalLayout = [[TableLayout alloc] initWithHeight:65.0f];
//    self.collectionView.collectionViewLayout = self.originalLayout;
    
        // オリジナルレイアウトを保存
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(fireChangeLayout:)]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//セクション内の行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"normalCell" forIndexPath:indexPath];
    normalCell.backgroundColor = self.colors[indexPath.row % self.colors.count];

    UILabel *label = (UILabel*)[normalCell viewWithTag:1];
    
    UIFontDescriptor *descriptor = [[UIFontDescriptor alloc] initWithFontAttributes:@{UIFontDescriptorNameAttribute:@"HelveticaNeue-UltraLight"}];
    
    label.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@(indexPath.row)] attributes:@{NSFontAttributeName:[UIFont fontWithDescriptor:descriptor size:25.0f]}];

    UIButton *button = (UIButton *)[normalCell viewWithTag:2];
    [button addTarget:self action:@selector(fireChangeLayout:) forControlEvents:UIControlEventTouchUpInside];
    
    return normalCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *footerView = nil;
    if( [kind isEqualToString:UICollectionElementKindSectionFooter] ){
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"normalFooter" forIndexPath:indexPath];
        
        UIButton *button = (UIButton *)[footerView viewWithTag:1];
        [button addTarget:self action:@selector(fireChangeLayout:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return footerView;
}

- (void) fireChangeLayout:(id)sender
{
    NSLog(@"fireChangeLayout: call");
    
    if( [self.navigationController.topViewController isKindOfClass:[OneViewController class]] ){
        UIButton* button = [sender isKindOfClass:[UIButton class]] ? sender : nil;
        NSIndexPath* indexPath = nil;
        
        NSArray *visibleCells = [self.collectionView visibleCells];
        for (UICollectionViewCell *cell in visibleCells) {
            UIButton *testButton = (UIButton *)[cell viewWithTag:2];
            if( button == testButton ){
                indexPath = [self.collectionView indexPathForCell:cell];
                break;
            }
        }
        
        TwoViewController *twoViewController = [[TwoViewController alloc] initWithCollectionViewLayout:[[ExpandTableLayout alloc] initWithHeight:65.0f fullscreenIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
        twoViewController.useLayoutToLayoutNavigationTransitions = YES;
        
        self.collectionView.bounces = NO;
        
        
        [self.navigationController pushViewController:twoViewController animated:YES];
    }else{
        self.collectionView.bounces = YES;
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
//    if( _fullScreen == NO /*self.collectionView.pagingEnabled != YES*/ ){
//        _fullScreen = YES;
//
//        [self.collectionView setCollectionViewLayout:[[ExpandTableLayout alloc] initWithHeight:65.0f fullscreenIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] animated:YES completion:^(BOOL finished) {
//
//        }];
//    }else{
//        _fullScreen = NO;
//        
//        [self.collectionView setCollectionViewLayout:self.originalLayout animated:YES completion:^(BOOL finished) {
//
//        }];
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320.0f, indexPath.row == 0 ? 85.0f : 65.0f );
}



@end
