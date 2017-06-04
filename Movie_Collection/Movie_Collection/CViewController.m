//
//  CViewController.m
//  Movie_Collection
//
//  Created by Bandana Choudhury on 25/05/17.
//  Copyright © 2017 Omniroid. All rights reserved.
//

#import "CViewController.h"
#import "DemoCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailViewController.h"

@interface CViewController ()
{
    NSArray *names;
    NSArray *pickerData;
    NSString *movieID;
    
    
}


@end
DetailViewController *dvc;
@implementation CViewController
@synthesize titleArr,serverResponseArr,serverResponseDic,json;

- (void)viewDidLoad {
    [super viewDidLoad];
    pickerData = @[@"upcoming", @"top_rated", @"popular", @"now_playing"];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.textField1.delegate = self;
    self.picker = [[UIPickerView alloc]init];
    
    
    self.myCollectionView.delegate =self;
    self.myCollectionView.dataSource = self;
    self.titleArr = [[NSMutableArray alloc]init];
    self.ratingArr = [[NSMutableArray alloc]init];
    self.titlosArray = [[NSMutableArray alloc] init];
    self.thumbNailArray = [[NSMutableArray alloc] init];
    self.keimenoArray = [[NSMutableArray alloc] init];
    self.id1Array = [[NSMutableArray alloc] init];

   
    
    self.alertArray = [[NSMutableArray  alloc]initWithCapacity:40];

    self.yourComponentValue = @"upcoming";
    [self retriveData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.titlosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   DemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"forIndexPath:indexPath];
    // cell.textLabel.text = [NSString stringWithFormat:@"%li",(long)indexPath.row + 1];
    // cell.textLabel.text = [[self.json objectAtIndex:indexPath.row]objectForKey:@"title"];
    
    NSString *movieTitl = [self.titlosArray objectAtIndex:indexPath.row];
    
    movieID = [self.id1Array objectAtIndex:indexPath.row];
    
    cell.textLabel.text = movieTitl;
        // Configure the cell
    
    NSString *my_thumb_url = @"https://image.tmdb.org/t/p/w500";
    NSString *my_thumb_url2 = [self.thumbNailArray objectAtIndex:indexPath.row];

    NSString *poster_image = [my_thumb_url stringByAppendingString:my_thumb_url2] ;
    
    cell.poster.layer.cornerRadius = 2.0;
        [cell.poster sd_setImageWithURL:[NSURL URLWithString:poster_image] placeholderImage:[UIImage imageNamed:@"tapanBack.jpg"]];
        cell.poster.contentMode = UIViewContentModeScaleAspectFit;
    
   // NSLog(@"%@ %@",movieTitl,poster_image);
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DVC"];
    dvc.indexPath = indexPath.row;
    dvc.value2 = [self.id1Array objectAtIndex:indexPath.row];
    dvc.value3 = [self.ratingArr objectAtIndex:indexPath.row];
    NSLog(@"%@",dvc.value2);
    [self presentViewController:dvc animated:YES completion:^{
        
    }];
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor blueColor];
    
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat padding = 10;
    CGFloat cellSize = collectionView.frame.size.width - padding ;
    return CGSizeMake(cellSize / 2, cellSize / 2);
}


-(void)retriveData{
    NSString *baseURL = @"https://api.themoviedb.org/3/movie/%@?api_key=14885c7681d501d10dbf8700d3daaf9f&language=en-US&page=1";
    NSString *mainUrl = [NSString stringWithFormat:baseURL, self.yourComponentValue];
    
    //NSLog(@"%@",mainUrl);

    
    self.urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.urlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", mainUrl]]];
    self.urlRequest.HTTPMethod = @"GET";
    self.dataTask = [self.urlSession dataTaskWithRequest:self.urlRequest completionHandler:^(NSData *_Nullable data,NSURLResponse *_Nullable response ,NSError *_Nullable error){
        
        
        ///ewVHnq4lUiovxBCu64qxq5bT2lu.jpg
        
        
        self.serverResponseDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        
        NSArray *items = [self.serverResponseDic valueForKeyPath:@"results"];
        [self.titlosArray removeAllObjects];
        [self.thumbNailArray removeAllObjects];
        [self.keimenoArray removeAllObjects];
        [self.id1Array removeAllObjects];
        [self.ratingArr removeAllObjects];
        
        for (NSDictionary *item in items)
        {
            [self.titlosArray addObject:[item objectForKey:@"title"]];
            [self.thumbNailArray addObject:[item objectForKey:@"poster_path"]];
            [self.keimenoArray addObject:[item objectForKey:@"overview"]];
            [self.id1Array addObject:[item objectForKey:@"id"]];
            [self.ratingArr addObject:[item objectForKey:@"vote_average"]];
            
            
            //NSLog(@"------%@",self.titlosArray);
            
        }
        
        [self.myCollectionView reloadData];
    }];
    
    [self.dataTask resume];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addTapped:(id)sender {
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(45, 50, 200, 40)];
    tf.backgroundColor=[UIColor redColor];
    UIPickerView * picker = [[UIPickerView alloc]initWithFrame:CGRectMake(230, 0, 200, 150)];
    //picker.transform = CGAffineTransformMakeScale(.75f, 0.75f);
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
 
    
    [tf addSubview:picker];
    
    [self.view addSubview:picker];
    [tf resignFirstResponder];
    
    }
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    self.yourComponentValue = [NSString stringWithFormat:@"%@",[pickerData objectAtIndex:row]];
    
    [self retriveData];    
    
}




@end
