//
//  DetailViewController.h
//  Movie_Collection
//
//  Created by Bandana Choudhury on 26/05/17.
//  Copyright © 2017 Omniroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface DetailViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *backImageview;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageview;
- (IBAction)backTapped:(id)sender;
@property NSInteger indexPath;
@property NSString *value2, *value3;


@property NSString *coreImagePoster;

@property NSURLSession *urlSession;
@property NSMutableURLRequest *urlRequest;
@property NSURLSessionDataTask *dataTask;
@property NSMutableDictionary *serverResponseDic;
@property NSMutableArray *serverResponseArr,*alertArray,*movieArr;
@property (nonatomic,strong) 	NSMutableArray *titleArr;
@property (nonatomic,strong) 	NSMutableArray *json;
@property NSMutableArray *arr,*titlosArray,*keimenoArray,*thumbNailArray,*id1Array;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleMovie;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionCredit;

@property NSURLSession *urlSession1;
@property NSMutableURLRequest *urlRequest1;
@property NSURLSessionDataTask *dataTask1;

@property NSMutableArray *creditNameArr ,*ratingArr,*castName,*castImage;
@property NSMutableDictionary *creditDic,*ratingDic;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (weak, nonatomic) IBOutlet UILabel *ratingL;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addFav;

- (IBAction)addFav:(id)sender;

@property (strong) NSManagedObjectModel *device;

@end
