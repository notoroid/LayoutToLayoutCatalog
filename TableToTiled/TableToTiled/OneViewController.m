//
//  OneViewController.m
//  AutoLayoutTest
//
//  Created by 能登 要 on 2014/01/07.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "OneViewController.h"

@interface ExtendedLayoutTableLayout : UICollectionViewFlowLayout
{

}
@end

@implementation ExtendedLayoutTableLayout

// 表示するセルの総数を返す（今回はセクション0のみを対象とする）
- (NSInteger)count {
    return [self.collectionView numberOfItemsInSection:0];
}

// collectionViewのスクロール可能領域の大きさを返す
- (CGSize)collectionViewContentSize
{
    CGSize size = [super collectionViewContentSize];
    
    return CGSizeMake(size.width,20.0f + self.itemSize.height * self.count + self.footerReferenceSize.height );
}

- (CGRect) rectForRow:(NSInteger)row
{
    CGFloat top = self.itemSize.height * row;
    CGFloat height = self.itemSize.height;

    if( top == 0 )
        height += 20.0f;
    else
        top += 20;
    
    // footer size
    
    CGRect rect = CGRectMake(.0f, top ,self.itemSize.width,height);
    return rect;
}

//// 指定された矩形に含まれるセルのIndexPathを返す
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
    
    CGRect footerRect = [self footerRectForSection:0];
    if( CGRectIntersectsRect(rect, footerRect) ){
        [array addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:self.count-1 inSection:0]] ];
    }
    
    return array;
}

// 各UICollectionViewCellに適用するレイアウト情報を返す
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = [self rectForRow:indexPath.row];
    
    return attr;
}

- (CGRect) footerRectForSection:(NSInteger)section
{
    return section == 0 ? CGRectMake(.0f, 20.0f + self.itemSize.height * self.count , self.footerReferenceSize.width , self.footerReferenceSize.height) : CGRectZero;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = nil;
    
    if( indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionFooter] ){
        attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        attr.frame = CGRectMake(.0f, 20.0f + self.itemSize.height * self.count , self.collectionViewContentSize.width , self.footerReferenceSize.height);
    }
    
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
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
        // 回り込み有効
    
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
        UICollectionViewController* collectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController2"];
        collectionViewController.useLayoutToLayoutNavigationTransitions = YES;

        [self.navigationController pushViewController:collectionViewController animated:YES];
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UICollectionViewController* collectionViewController = [segue.destinationViewController isKindOfClass:[UICollectionViewController class]] ? segue.destinationViewController : nil;
    collectionViewController.useLayoutToLayoutNavigationTransitions = YES;
}


@end
