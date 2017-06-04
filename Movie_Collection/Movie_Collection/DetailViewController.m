//
//  DetailViewController.m
//  Movie_Collection
//
//  Created by Bandana Choudhury on 26/05/17.
//  Copyright © 2017 Omniroid. All rights reserved.
//

#import "DetailViewController.h"
#import "CViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CreditCollectionViewCell.h"
#import "AppDelegate.h"

@interface DetailViewController (){
    UIScrollView *myScrollView;
}

@end
CViewController *cv;
AppDelegate *ad;
UINavigationController *nc;
@implementation DetailViewController
@synthesize device;

-(NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.creditNameArr = [[NSMutableArray alloc]init];
    self.castName = [[NSMutableArray alloc]init];
    self.castImage = [[NSMutableArray alloc]init];
    
    //NSLog(@"%@",self.value2);
//self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width+100, self.view.frame.size.height+100);
    
    
    [self addScrollView];
    [self retriveData];
    self.collectionCredit.delegate = self;
    self.collectionCredit.dataSource = self;
    [self getCreditDetails];
   
    // Do any additional setup after loading the view.
   //self.scrollView.scrollEnabled = YES;
    
//[self.view addSubview:self.scrollView];
    
    if (self.device) {
        [self.coreImagePoster setValue:self.device forKey:@"text1"];
        [self.titleMovie    setText:[self.device valueForKey:@"text2"]];
    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addScrollView{
//    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//
//    NSInteger viewcount= 4;
//    for (int i = 0; i <viewcount; i++)
//    {
//        CGFloat y = i * self.view.frame.size.height;
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y,self.view.frame.size.width, self .view.frame.size.height)];
//        view.backgroundColor = [UIColor greenColor];
//        [scrollview addSubview:view];
//    }
//    
//    scrollview.contentSize = CGSizeMake(self.view.frame.size.width+70, self.view.frame.size.height+70);
//    [self.view addSubview:scrollview];
}


-(void)retriveData{
    
    NSString *baseMovieDetailUrl = @"https://api.themoviedb.org/3/movie/%@?api_key=14885c7681d501d10dbf8700d3daaf9f&language=en-US";
    
    NSString *mainUrl = [NSString stringWithFormat:baseMovieDetailUrl, self.value2];
    
    //NSLog(@"%@",mainUrl);
    
    
    self.urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.urlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", mainUrl]]];
    self.urlRequest.HTTPMethod = @"GET";
    self.dataTask = [self.urlSession dataTaskWithRequest:self.urlRequest completionHandler:^(NSData *_Nullable data,NSURLResponse *_Nullable response ,NSError *_Nullable error){
        
        
        ///ewVHnq4lUiovxBCu64qxq5bT2lu.jpg
        
        
        self.serverResponseDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSString *my_backdrop = @"https://image.tmdb.org/t/p/w500";
        NSString *my_backdrop2 = [self.serverResponseDic valueForKeyPath:@"backdrop_path"];
        
        NSString *backdrop_image = [my_backdrop stringByAppendingString:my_backdrop2] ;
        

//        NSDecimal rrp = [[self.serverResponseDic objectForKey:@"popularity"] decimalValue];
        
        //NSString *asd = self.value3;
        
        //NSLog(@"%@", self.value3);
        
        self.titleMovie.text = [self.serverResponseDic objectForKey:@"title"];

        self.textLabel.text = [self.serverResponseDic objectForKey:@"overview"];
       
        

        
        //NSLog(@"%@",[self.serverResponseDic objectForKey:@"title"]);
        
        [self.backImageview sd_setImageWithURL:[NSURL URLWithString:backdrop_image] placeholderImage:[UIImage imageNamed:@"tapanBack.jpg"]];
        
        NSString *my_poster = @"https://image.tmdb.org/t/p/w500";
        NSString *my_poster2 = [self.serverResponseDic valueForKeyPath:@"poster_path"];
        
         self.coreImagePoster = [my_poster stringByAppendingString:my_poster2] ;
        
        [self.posterImageview sd_setImageWithURL:[NSURL URLWithString:self.coreImagePoster] placeholderImage:[UIImage imageNamed:@"tapanBack.jpg"]];
        
            }];
    
    
    
    [self.dataTask resume];
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.castName.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CreditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1"forIndexPath:indexPath];
    // cell.textLabel.text = [NSString stringWithFormat:@"%li",(long)indexPath.row + 1];
    cell.creditName.text = [self.castName objectAtIndex:indexPath.row];
    
    NSString *my_credits = @"https://image.tmdb.org/t/p/w500";
    NSString *my_credits2 = [self.castImage objectAtIndex:indexPath.row];
    
    NSString *credits_image = [my_credits stringByAppendingString:my_credits2] ;
    
    [cell.creditImageview sd_setImageWithURL:[NSURL URLWithString:credits_image] placeholderImage:[UIImage imageNamed:@"tapanBack.jpg"]];
//      cell.creditImageview.layer.cornerRadius = cell.creditImageview.frame.size.height /2;
//    cell.creditImageview.layer.masksToBounds = YES;
//    cell.creditImageview.layer.borderWidth = 0.5;


    
    return cell;
}



-(void)getCreditDetails{
    NSString *baseCreditDetailUrl = @"https://api.themoviedb.org/3/movie/%@/credits?api_key=14885c7681d501d10dbf8700d3daaf9f";
    NSString *mainUrl = [NSString stringWithFormat:baseCreditDetailUrl, self.value2];
    
    //NSLog(@"------%@",mainUrl);
    
    
    self.urlSession1 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.urlRequest1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", mainUrl]]];
    self.urlRequest1.HTTPMethod = @"GET";
    self.dataTask1 = [self.urlSession1 dataTaskWithRequest:self.urlRequest1 completionHandler:^(NSData *_Nullable data,NSURLResponse *_Nullable response ,NSError *_Nullable error){
        
        
        self.creditDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
       self.creditNameArr = [self.creditDic objectForKey:@"cast"] ;
        [self.castImage removeAllObjects];
        [self.castName removeAllObjects];

        

        for (NSDictionary *item in self.creditNameArr)
        {
            [self.castName addObject:[item objectForKey:@"name"]];
            [self.castImage addObject:[item objectForKey:@"profile_path"]];
            
        }

//       for (int i=0; i<_creditNameArr.count; i++) {
//           
//             //NSLog(@"kkkkkkk------%@", [[self.creditNameArr objectAtIndex:i]objectForKey:@"profile_path"] );
//       }
       

        [self.collectionCredit reloadData];
    }];
    
    [self.dataTask1 resume];
    

}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}















/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backTapped:(id)sender {
    nc = [self.storyboard instantiateViewControllerWithIdentifier:@"NC"];
    
    [self presentViewController:nc animated:YES completion:^{
        
    }];
    
}
- (IBAction)addFav:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.device) {
        [self.device setValue:self.coreImagePoster forKey:@"text1"];
        [self.device setValue:self.titleMovie.text forKey:@"text2"];
    } else {
        
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
        
            [newDevice setValue:self.coreImagePoster forKey:@"text1"];
            [newDevice setValue:self.titleMovie.text forKey:@"text2"];
        
    }
    
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        //NSLog(@"%@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    

}

//-(void)getDetails{
//    NSFetchRequest *getDetail = [NSFetchRequest fetchRequestWithEntityName:@"device"];
//    NSError *errorObj;
//    NSArray *retrivedDetail = [ad.managedObjectContext executeFetchRequest:getDetail error: &errorObj];
//    //NSLog(@"fetched objevts are %@",retrivedDetail);
//    for (int i=0; i<retrivedDetail.count; i++) {
//        NSManagedObject * arrObj = [retrivedDetail objectAtIndex:i];
//        //NSLog(@"%@",[arrObj valueForKey:@"text2"]);
//    }

    
//}
@end
