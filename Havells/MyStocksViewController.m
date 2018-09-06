//
//  MyStocksViewController.m
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import "MyStocksViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "StocksListTableViewCell.h"
#import "StockDetailViewController.h"

#define databaseName @"HAVELS"
#define collectionNameStr @"PURCHASELIST"

#define stocksDetails @"myStockDetail"
#define myStockDetailIdentifier @"myStocks"
#define myRecommendStockDetailIdentifier @"myRecommededStocks"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define APP42_APP_KEY @"ad30291e5cceea743e318c575ebf0ff789cf1b2cf987c34c4a55604dd1898537"
#define APP42_SECRET_KEY @"0ba9695bdc4b3b733b1e584ef95a0b9f053b72a4340a55b0018956bd294feb5a"


@interface MyStocksViewController () {
    NSMutableArray *StockArray;
}
@property (nonatomic, strong) NSMutableArray *stocksListArray;
@property (nonatomic, strong) NSMutableArray *stockDetailArray;
@property (nonatomic, strong) NSMutableArray *finalStockArray;
@end

@implementation MyStocksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.myStocksTableView.separatorColor = UIColorFromRGB(0x909092);
    self.view.backgroundColor = UIColorFromRGB(0xECEBF3);
    
    self.navigationItem.title = @"My Purchases";
    
    self.stocksListArray = [NSMutableArray new];
    self.stockDetailArray = [NSMutableArray new];
    self.finalStockArray = [NSMutableArray new];
    
    
    self.myStocksTableView.tableFooterView = [[UIView alloc] init];
    self.myStocksTableView.backgroundColor = UIColorFromRGB(0xECEBF3);
    self.errorMessageLabel.hidden = YES;
    self.myStocksTableView.hidden = YES;
    
    self.myStocksTableView.dataSource = self;
    self.myStocksTableView.delegate = self;
    
    self.recommendTableView.dataSource = self;
    self.recommendTableView.delegate = self;
    
    
    NSMutableDictionary *myDictionary1 = [[ NSMutableDictionary alloc] init];
    [ myDictionary1 setObject:@"101" forKey:@"productId"];
    [ myDictionary1 setObject:@"Havells Fusion 900 mm Silver Blue Ceiling Fan" forKey:@"productName"];
    
    NSMutableDictionary *myDictionary2 = [[ NSMutableDictionary alloc] init];
    [ myDictionary2 setObject:@"102" forKey:@"productId"];
    [ myDictionary2 setObject:@"Havells 200 Mm Fan Ventil Air Dx" forKey:@"productName"];
    
    NSMutableDictionary *myDictionary3 = [[ NSMutableDictionary alloc] init];
    [ myDictionary3 setObject:@"103" forKey:@"productId"];
    [ myDictionary3 setObject:@"Havells Monza-EC White Storage Geyser 10 ltr" forKey:@"productName"];
    
    NSMutableDictionary *myDictionary4 = [[ NSMutableDictionary alloc] init];
    [ myDictionary4 setObject:@"104" forKey:@"productId"];
    [ myDictionary4 setObject:@"Havells 600W Power Hand Blender" forKey:@"productName"];
    
    NSMutableDictionary *myDictionary5 = [[ NSMutableDictionary alloc] init];
    [ myDictionary5 setObject:@"105" forKey:@"productId"];
    [ myDictionary5 setObject:@"Havells Oro Dry Iron 1000 Watts" forKey:@"productName"];
    
    NSMutableDictionary *myDictionary6 = [[ NSMutableDictionary alloc] init];
    [ myDictionary6 setObject:@"106" forKey:@"productId"];
    [ myDictionary6 setObject:@"Havells 400 Mm Swing Lx Table Fan White" forKey:@"productName"];
    
    NSMutableDictionary *myDictionary7 = [[ NSMutableDictionary alloc] init];
    [ myDictionary7 setObject:@"107" forKey:@"productId"];
    [ myDictionary7 setObject:@"Anemos Regal Mb 1524 Mm Matt Black Ceiling Fan" forKey:@"productName"];
    
    NSMutableDictionary *myDictionary8 = [[ NSMutableDictionary alloc] init];
    [ myDictionary8 setObject:@"108" forKey:@"productId"];
    [ myDictionary8 setObject:@"Havells Ventil Air Db Grey Fan" forKey:@"productName"];
    
    NSMutableDictionary *myDictionary9 = [[ NSMutableDictionary alloc] init];
    [ myDictionary9 setObject:@"109" forKey:@"productId"];
    [ myDictionary9 setObject:@"Havells Pentaforce 1320 mm Rainbow Pearl Ivory Ceiling Fan" forKey:@"productName"];
    
    NSMutableDictionary *myDictionary10 = [[ NSMutableDictionary alloc] init];
    [ myDictionary10 setObject:@"110" forKey:@"productId"];
    [ myDictionary10 setObject:@"Havells Jio Dry Iron Pink 1000 Watts" forKey:@"productName"];
    
    StockArray = [[NSMutableArray alloc] initWithObjects:myDictionary1, myDictionary2, myDictionary3, myDictionary4, myDictionary5, myDictionary6, myDictionary7, myDictionary8, myDictionary9, myDictionary10, nil];
    self.recommendView.hidden = true;
    
    
    self.recommendView.layer.shadowRadius  = 3.5f;
    self.recommendView.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.recommendView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.recommendView.layer.shadowOpacity = 0.9f;
    self.recommendView.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.recommendView.bounds, shadowInsets)];
    self.recommendView.layer.shadowPath    = shadowPath.CGPath;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllDataFromStorage:databaseName collectionName:collectionNameStr];
//    [self getRecommendedStocks];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllDataFromStorage:(NSString *)dbName collectionName:(NSString *)collectionName {
    StorageService *storageService = [App42API buildStorageService];
    [storageService findDocumentByKeyValue:dbName collectionName:collectionName key:@"userId" value:[App42API getLoggedInUser] completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            if (self.stocksListArray) {
                [self.stocksListArray removeAllObjects];
            }
            Storage *storage =  (Storage*)responseObj;
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray) {
                [self convertStringToJson:jsonDoc.jsonDoc];
            }
            
            NSLog(@"self.stocksListArray: %@", self.stocksListArray);
            
            [self.myStocksTableView reloadData];
            
            [self getRecommendedStocks];

        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            self.errorMessageLabel.hidden = NO;
            self.errorMessageLabel.text = [exception reason];
        }
        
        self.myStocksLoader.hidden = YES;
        self.myStocksTableView.hidden = NO;
    }];
    
}



-(void)convertStringToJson:(NSString *)convertStr {
    NSData *strData = [convertStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:strData options:kNilOptions error:nil];
    [self.stocksListArray addObject:arr];
    
    for (int i = 0; i < self.stocksListArray.count; i++) {
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:[[self.stocksListArray objectAtIndex:i] objectForKey:@"productName"]];
    }
    
}

//header title color- 66646B

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count;
    if (tableView == self.myStocksTableView) {
        count = [self.stocksListArray count];
    }
    
    if (tableView == self.recommendTableView) {
        count = [self.finalStockArray count];
    }
    
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StocksListTableViewCell *cell;
    
    if (tableView == self.myStocksTableView) {
        cell = (StocksListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:myStockDetailIdentifier forIndexPath:indexPath];
        cell.backgroundColor = UIColorFromRGB(0xECEBF3);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *productImageStr = [NSString stringWithFormat:@"product_%@.jpg", [[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"productId"]];
        NSString *productName = [[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"productName"];
        [cell.productImage setImage:[UIImage imageNamed:productImageStr]];
        cell.nameStr.text = productName;
        cell.priceLabel.text = [NSString stringWithFormat:@"₹%@", [[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"price"]];

    }
    
    
    if (tableView == self.recommendTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:myRecommendStockDetailIdentifier forIndexPath:indexPath];
        cell.backgroundColor = UIColorFromRGB(0xECEBF3);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *productImageStr = [NSString stringWithFormat:@"product_%@.jpg", [[self.finalStockArray objectAtIndex:indexPath.row] objectForKey:@"productId"]];
        NSString *productName = [[self.finalStockArray objectAtIndex:indexPath.row] objectForKey:@"productName"];
        [cell.productImage setImage:[UIImage imageNamed:productImageStr]];
        cell.nameStr.text = productName;
        cell.priceLabel.text = [NSString stringWithFormat:@"₹%@", [[self.finalStockArray objectAtIndex:indexPath.row] objectForKey:@"price"]];

    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.myStocksTableView) {
        return 100.0f;
    }
    
    if (tableView == self.recommendTableView) {
        return 130.0f;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.myStocksTableView) {
        self.stockDetailArray = [self.stocksListArray objectAtIndex:indexPath.row];
    }
    
    if (tableView == self.recommendTableView) {
        self.stockDetailArray = [self.finalStockArray objectAtIndex:indexPath.row];
    }
    
    NSLog(@"self.stockDetailArray: %@", self.stockDetailArray);
    
    [self performSegueWithIdentifier:stocksDetails sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:stocksDetails]) {
        StockDetailViewController *detailVC = [segue destinationViewController];
        detailVC.stockArray = self.stockDetailArray;
    }
}

-(void)getRecommendedStocks
{
    NSString *api_key = @"fa1bade990a004f74430cd7a2a591a04edb381329c905412d718340feff5806d"; //@"6ada5ffb6533ca92f9af6a4ba28c3319e03fba04e36a88c4214b02e468bc6c95";
    NSString *secret_key = @"8d78f04c7d56548d7b3a9a1ba2829945c82620441f4e591e6c721b221a1029a7"; // @"3c1305c1b2bd6fdedc11e1fe195040f8155ac37b41caddfc61175b77d07a4ba4";
    
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];

    long userid = [[App42API getLoggedInUser] longLongValue];
    int size = 100;
    int howmany = 10;
    
    [App42API initializeWithAPIKey:api_key andSecretKey:secret_key];
    [App42API setBaseUrl:@"https://api.shephertz.com"];
    
    RecommenderService *recommenderService = [App42API buildRecommenderService];
    
    
    [recommenderService itemBasedBySimilarity:EUCLIDEAN_DISTANCE userId:userid howMany:howmany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)      {
            Recommender *recommender =  (Recommender*)responseObj;
            
            if (self.stocksListArray.count > 0) {
                
                [self.finalStockArray removeAllObjects];
                
                NSMutableArray *recommendedItemList =  recommender.recommendedItemList;
                for(RecommendedItem *recommendedItem in recommendedItemList){
                    
                    NSPredicate *stockIdPred = [NSPredicate predicateWithFormat:@"productId == %@",recommendedItem.item];
                    NSMutableArray *stocks = [StockArray filteredArrayUsingPredicate:stockIdPred];
                    
                    if (stocks.count > 0) {
                       
                        NSPredicate *productnamePred = [NSPredicate predicateWithFormat:@"productName == %@", [[stocks objectAtIndex:0] objectForKey:@"productName"]];
                        NSMutableArray *companyArray = [self.stocksListArray filteredArrayUsingPredicate:productnamePred];
                        
                        if (companyArray.count == 0) {
                            NSArray *recommendedStockArray = [self.allStocksArray filteredArrayUsingPredicate:productnamePred];
                            [self.finalStockArray addObjectsFromArray:recommendedStockArray];
                        }
                    }
                }
                
                if (self.finalStockArray.count > 0) {
                    [self.recommendTableView reloadData];
                    self.recommendView.hidden = false;
                }
            }
            
        }
        else      {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
    
    [App42API initializeWithAPIKey:APP42_APP_KEY andSecretKey:APP42_SECRET_KEY];
    [App42API setBaseUrl:@"https://in-api.shephertz.com"];
}


- (IBAction)closeBtnClick:(UIButton *)sender {
    
    self.recommendView.hidden = true;
}
@end
