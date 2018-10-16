//
//  TagsViewController.m
//  XianMao
//
//  Created by simon cai on 7/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "TagsViewController.h"
#import "NetworkAPI.h"
#import "Error.h"

#import "SepTableViewCell.h"

@interface TagsViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *dataSources;
@property(nonatomic,weak) UILabel *indicatorLbl;

@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"选择标签"];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    [super.topBarRightButton setTitle:@"保存" forState:UIControlStateNormal];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    [super.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
    
    _dataSources = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.alwaysBounceVertical = YES;
    //    tableView.showsVerticalScrollIndicator = NO;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    
    UILabel *lbl = [[UIInsetLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) andInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
    lbl.font = [UIFont systemFontOfSize:12.f];
    lbl.text = @"最多选择5标签";
    _tableView.tableHeaderView = lbl;
    _indicatorLbl = lbl;
    
    [self updateIndicatorLbl];
    
    if ([self.tagGroupList count]>0) {
        NSMutableArray *dataSouces = [[NSMutableArray alloc] init];
        for (TagGroupVo *tagGroupVo in self.tagGroupList) {
            if ([dataSouces count]>0) {
                [dataSouces addObject:[SepTableViewCell buildCellDict]];
            }
            [dataSouces addObject:[TagsTableViewCell buildCellDict:tagGroupVo]];
        }
        self.dataSources = dataSouces;
        [self.tableView reloadData];
    } else {
        WEAKSELF;
        [weakSelf showProcessingHUD:nil];
        
        NSDictionary *parameters = @{@"cate_id":[NSNumber numberWithInteger:self.category_id]};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"tag" path:@"tag_group_list" parameters:parameters completionBlock:^(NSDictionary *data) {
            [weakSelf hideHUD];
            
            NSMutableArray *tagGroupList = [[NSMutableArray alloc] init];
            NSArray *dictArray = [data arrayValueForKey:@"tag_group_list"];
            if ([dictArray isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in dictArray) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        TagGroupVo *tagGroupVo = [TagGroupVo createWithDict:dict];
                        [tagGroupList addObject:tagGroupVo];
                    }
                }
            }
            weakSelf.tagGroupList = tagGroupList;
            if (weakSelf.handleTagsListFetchedBlock) {
                weakSelf.handleTagsListFetchedBlock(tagGroupList);
            }
            
            NSMutableArray *dataSouces = [[NSMutableArray alloc] init];
            for (TagGroupVo *tagGroupVo in tagGroupList) {
                if ([dataSouces count]>0) {
                    [dataSouces addObject:[SepTableViewCell buildCellDict]];
                }
                [dataSouces addObject:[TagsTableViewCell buildCellDict:tagGroupVo]];
            }
            weakSelf.dataSources = dataSouces;
            
            [weakSelf.tableView reloadData];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        } queue:nil]];
    }
    
    [self bringTopBarToTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)updateIndicatorLbl
{
    NSInteger count = 0;
    for (TagGroupVo *tagGroupVo in self.tagGroupList) {
        for (TagVo *tagVo in tagGroupVo.tagList) {
            if (tagVo.isSelected) {
                count++;
            }
        }
    }
    _indicatorLbl.text = [NSString stringWithFormat:@"最多选择5标签 (%ld/5)",(long)count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [tableViewCell updateCellWithDict:dict];
    
    WEAKSELF;
    if ([tableViewCell isKindOfClass:[TagsTableViewCell class]]) {
        ((TagsTableViewCell*)tableViewCell).handleTagButtonClickedBlock = ^(TagButton *sender) {
            TagVo *tagVo = (TagVo*)(sender.tagVo);
            
            if (sender.isSelected) {
                sender.selected = NO;
                tagVo.isSelected = NO;
            } else {
                NSInteger count = 0;
                for (TagGroupVo *tagGroupVo in weakSelf.tagGroupList) {
                    for (TagVo *tagVo in tagGroupVo.tagList) {
                        if (tagVo.isSelected) {
                            count++;
                        }
                    }
                }
                if (count<5) {
                    sender.selected = YES;
                    tagVo.isSelected = YES;
                } else {
                    [weakSelf showHUD:@"最多可选5个标签" hideAfterDelay:0.8f];
                }
            }
            
            [weakSelf updateIndicatorLbl];
//            
//            if (weakSelf.handleTagsDidSelectBlock) {
//                weakSelf.handleTagsDidSelectBlock();
//            }
        };
    }
    
    return tableViewCell;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    if (self.handleTagsDidSelectBlock) {
        self.handleTagsDidSelectBlock();
    }
    
    [super dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

#import "NSMutableArray+WeakReferences.h"

@interface TagsTableViewCell ()
@property(nonatomic,strong) NSMutableArray *tagsViewArray;
@end

@implementation TagsTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([TagsTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    
    TagGroupVo *tagGroupVo = [dict objectForKey:[self cellKeyForTagGroupVo]];
    if ([tagGroupVo isKindOfClass:[TagGroupVo class]]) {
        NSInteger count = [tagGroupVo.tagList count];
        NSInteger rows = count/3+(count%3>0?1:0);
        height = rows*[TagButton tagHeight];
        height = height-(rows-1);
    }
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(TagGroupVo*)tagGroupVo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[TagsTableViewCell class]];
    if (tagGroupVo)[dict setObject:tagGroupVo forKey:[self cellKeyForTagGroupVo]];
    return dict;
}

+ (NSString*)cellKeyForTagGroupVo {
    return @"tagGroupVo";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _tagsViewArray = [NSMutableArray noRetainingArray];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    for (TagButton *tagButton in _tagsViewArray) {
        tagButton.hidden = YES;
        tagButton.selected = NO;
        tagButton.tagVo = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat X = 15.f;
    CGFloat Y = 0.f;
    for (UIView *view in _tagsViewArray) {
        if (X+view.width>=kScreenWidth) {
            X = 15;
            Y += view.height;
            Y -= 1.f;
        }
        view.frame = CGRectMake(X, Y, view.width, view.height);
        X += view.width;
        X -= 1.f;
    }
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    TagGroupVo *tagGroupVo = [dict objectForKey:[[self class] cellKeyForTagGroupVo]];
    if ([tagGroupVo isKindOfClass:[TagGroupVo class]]) {
        
        NSInteger count = _tagsViewArray.count;
        for (NSInteger index=count;index<tagGroupVo.tagList.count;index++) {
            TagButton *tagButton = [TagButton createTagButton:nil];
            tagButton.hidden = YES;
            WEAKSELF;
            tagButton.handleClickBlock = ^(CommandButton *sender) {
                [weakSelf handleTagButtonClicked:(TagButton*)sender];
            };
            [_tagsViewArray addObject:tagButton];
            [self.contentView addSubview:tagButton];
        }
        
        for (TagButton *tagButton in _tagsViewArray) {
            tagButton.hidden = YES;
            tagButton.selected = NO;
        }
        
        for (NSInteger index=0;index<tagGroupVo.tagList.count;index++) {
            TagVo *tagVo = [tagGroupVo.tagList objectAtIndex:index];
            TagButton *tagButton = [_tagsViewArray objectAtIndex:index];
            tagButton.hidden = NO;
            [tagButton updateWith:tagVo];
        }
        
        for (TagButton *tagButton in _tagsViewArray) {
            if (tagButton.tagVo && ((TagVo*)tagButton.tagVo).isSelected) {
                [tagButton bringMySelfToFront];
            }
        }
        
        [self setNeedsLayout];
    }
}

- (void)handleTagButtonClicked:(TagButton*)sender
{
    if (_handleTagButtonClickedBlock) {
        _handleTagButtonClickedBlock(sender);
    }
    
    for (TagButton *tagButton in _tagsViewArray) {
        if (tagButton.tagVo && ((TagVo*)tagButton.tagVo).isSelected) {
            [tagButton bringMySelfToFront];
        }
    }
}

@end


//category/sample[GET] ｛cate_id，传叶子类目就行｝

@implementation TagButton

+ (TagButton*)createTagButton:(NSObject*)tagVo {
    CGFloat width = (kScreenWidth-30)/3+1;
    CGFloat height = [[self class] tagHeight];
    TagButton *btn = [[TagButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor colorWithHexString:@"DADADA"].CGColor;
    btn.backgroundColor = [UIColor whiteColor];
    [btn updateWith:tagVo];
    return btn;
}

- (void)updateWith:(NSObject*)tagVo {
    self.tagVo = tagVo;
    if ([tagVo isKindOfClass:[TagGroupVo class]]) {
        [self setTitle:((TagGroupVo*)tagVo).groupName forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
        self.selected = NO;
    }
    else if ([tagVo isKindOfClass:[TagVo class]]) {
        [self setTitle:((TagVo*)tagVo).tagName forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        self.selected = ((TagVo*)tagVo).isSelected;
    }
}

- (void)bringMySelfToFront
{
    UIView *superView = self.superview;
    [superView bringSubviewToFront:self];
}

+ (NSInteger)tagHeight {
    CGFloat height = 45.f*kScreenWidth/320.f;
    return (NSInteger)(height+0.5);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        [self setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
        UIImage *img = [UIImage imageNamed:@"publish_tag_selected"];
        [self setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width-4 topCapHeight:img.size.height-4] forState:UIControlStateNormal];
    } else {
        [self setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor colorWithHexString:@"DADADA"].CGColor;
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

@end





