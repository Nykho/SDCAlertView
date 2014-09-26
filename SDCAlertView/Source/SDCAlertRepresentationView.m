//
//  SDCAlertRepresentationView.m
//  SDCAlertView
//
//  Created by Scott Berrevoets on 9/21/14.
//  Copyright (c) 2014 Scotty Doesn't Code. All rights reserved.
//

#import "SDCAlertRepresentationView.h"

#import "SDCAlertController.h"
#import "SDCAlertViewBackgroundView.h"
#import "SDCAlertScrollView.h"
#import "SDCAlertControllerCollectionViewFlowLayout.h"
#import "SDCAlertCollectionViewCell.h"

#import "UIView+SDCAutoLayout.h"

static NSString *const SDCAlertControllerCellReuseIdentifier = @"SDCAlertControllerCellReuseIdentifier";

@interface SDCAlertRepresentationView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) SDCAlertViewBackgroundView *backgroundView;
@property (nonatomic, strong) SDCAlertScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *buttonCollectionView;
@property (nonatomic, strong) SDCAlertControllerCollectionViewFlowLayout *collectionViewLayout;
@end

@implementation SDCAlertRepresentationView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
	self = [self init];
	
	if (self) {
		_scrollView = [[SDCAlertScrollView alloc] initWithTitle:title message:message];
		
		_collectionViewLayout = [[SDCAlertControllerCollectionViewFlowLayout alloc] init];
		_buttonCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
		[_buttonCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		[_buttonCollectionView registerClass:[SDCAlertCollectionViewCell class] forCellWithReuseIdentifier:SDCAlertControllerCellReuseIdentifier];
		_buttonCollectionView.delegate = self;
		_buttonCollectionView.dataSource = self;
		_buttonCollectionView.backgroundColor = [UIColor clearColor];

		_backgroundView = [[SDCAlertViewBackgroundView alloc] init];
		[_backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self addSubview:_backgroundView];
		
		self.layer.masksToBounds = YES;
		self.layer.cornerRadius = 5;
		
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	}
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	[self.backgroundView sdc_alignEdgesWithSuperview:UIRectEdgeAll];
	
	[self addSubview:self.scrollView];
	[self.scrollView setNeedsLayout];
	[self.scrollView layoutIfNeeded];
	
	[self.scrollView sdc_alignEdgesWithSuperview:UIRectEdgeLeft|UIRectEdgeTop|UIRectEdgeRight];
	[self.scrollView sdc_setMaximumHeight:76];
	
	[self addSubview:self.buttonCollectionView];
	[self.buttonCollectionView sdc_alignEdge:UIRectEdgeTop withEdge:UIRectEdgeBottom ofView:self.scrollView];
	[self.buttonCollectionView sdc_alignEdgesWithSuperview:UIRectEdgeLeft|UIRectEdgeRight];
	[self.buttonCollectionView sdc_pinHeight:44];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.actions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	SDCAlertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SDCAlertControllerCellReuseIdentifier
																				 forIndexPath:indexPath];
	
	SDCAlertAction *action = self.actions[indexPath.item];
	cell.textLabel.text = action.title;
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(CGRectGetWidth(self.bounds) / self.actions.count, CGRectGetHeight(collectionView.bounds));
}

@end
