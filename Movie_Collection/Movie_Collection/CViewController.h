//
//  CViewController.h
//  Movie_Collection
//
//  Created by Bandana Choudhury on 25/05/17.
//  Copyright © 2017 Omniroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>
@property NSURLSession *urlSession;
@property NSMutableURLRequest *urlRequest;
@property NSURLSessionDataTask *dataTask;
@property NSMutableDictionary *serverResponseDic;
@property NSMutableArray *serverResponseArr,*alertArray,*movieArr;

@property NSMutableArray *arr,*titlosArray,*keimenoArray,*thumbNailArray,*id1Array, *ratingArr;
- (IBAction)addTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic,strong) 	NSMutableArray *titleArr;
@property (nonatomic,strong) 	NSMutableArray *json;

-(void)retriveData;

@property NSString *yourComponentValue ;
@property UIPickerView *picker;
@property UITextField *textField1;

@property UIAlertController * alertController;

@end
