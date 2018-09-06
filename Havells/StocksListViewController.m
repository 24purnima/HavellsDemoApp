//
//  StocksListViewController.m
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import "StocksListViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "StocksListTableViewCell.h"
#import "StockDetailViewController.h"
#import "MyStocksViewController.h"


#define databaseName @"HAVELS"
#define collectionNameStr @"PRODUCTS"
#define stockDetailIdentifier @"stockDetail"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface StocksListViewController ()
@property (nonatomic, strong) NSMutableArray *stocksListArray;
@property (nonatomic, strong) NSMutableArray *stockDetailArray;
@property (nonatomic, strong) NSMutableArray *stockRecommendedArray;

@end

@implementation StocksListViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    
    self.stocksTableView.separatorColor = UIColorFromRGB(0x909092);
    self.view.backgroundColor = UIColorFromRGB(0xECEBF3);
    
//    UIImage *img = [UIImage imageNamed:@"120px.png"];
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [imgView setImage:img];
//    // setContent mode aspect fit
//    [imgView setContentMode:UIViewContentModeScaleAspectFit];
//    self.navigationItem.titleView = imgView;

    NSLog([App42API getInstallId]);///788ffd514b335f46a2c971e31dc74d10
    
    self.navigationItem.title = @"Products";
    self.stocksListArray = [NSMutableArray new];
    self.stockDetailArray = [NSMutableArray new];
    self.stockRecommendedArray = [NSMutableArray new];
    
    [self getAllDataFromStorage:databaseName collectionName:collectionNameStr];
    
    self.stocksTableView.tableFooterView = [[UIView alloc] init];
    self.stocksTableView.backgroundColor = UIColorFromRGB(0xECEBF3);
    self.stocksTableView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)getRecommandedStocks:(NSString *)dbname collectionname:(NSString *)collectionName {
    
    NSString *anotherUserName;
    
    if ([[App42API getLoggedInUser] isEqualToString:@"purnima"]) {
        anotherUserName = @"sushil";
    }
    else {
        anotherUserName = @"purnima";
    }
    
    Query *q1 = [QueryBuilder buildQueryWithKey:@"userName" value:anotherUserName andOperator:APP42_OP_EQUALS];
    StorageService *storageService = [App42API buildStorageService];
    
    Query *q2 = [QueryBuilder buildQueryWithKey:@"userName" value:[App42API getLoggedInUser] andOperator:APP42_OP_NOT_EQUALS];
    Query *query = [QueryBuilder combineQuery:q1 withQuery:q2 usingOperator:APP42_OP_AND];
    
    [storageService findDocumentsByQuery:query dbName:dbname collectionName:collectionName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)      {
            self.stockRecommendedArray = nil;
            self.stockRecommendedArray = [NSMutableArray new];
            
            Storage *storage =  (Storage*)responseObj;
//            NSLog(@"dbName is %@" , storage.dbName);
//            NSLog(@"collectionNameId is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)           {
//                NSLog(@"objectId is = %@ " , jsonDoc.docId);
//                NSLog(@"jsonDoc is = %@ " , jsonDoc.jsonDoc);
                
                NSArray *arr = [self convertStringToJson:jsonDoc.jsonDoc];
                [self.stockRecommendedArray addObject:arr];
            }
            
            NSLog(@"stockRecommendedArray: %@", self.stockRecommendedArray);
            [self recommendedView];

        }
        else      {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            
        }
    }];
}*/

-(void)getAllDataFromStorage:(NSString *)dbName collectionName:(NSString *)collectionName {
    StorageService *storageService = [App42API buildStorageService];
    [storageService findAllDocuments:dbName collectionName:collectionName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage =  (Storage*)responseObj;
//            NSLog(@"dbName is %@" , storage.dbName);
//            NSLog(@"collectionNameId is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
//                NSLog(@"objectId is = %@ " , jsonDoc.docId);
//                NSLog(@"jsonDoc is = %@ " , jsonDoc.jsonDoc);
                NSArray *arr = [self convertStringToJson:jsonDoc.jsonDoc];
                [self.stocksListArray addObject:arr];

            }
            
            NSLog(@"stocks array data: %@", self.stocksListArray);
            
            [self.stocksTableView reloadData];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
        
        self.listLoader.hidden = YES;
        self.stocksTableView.hidden = NO;
    }];
}

-(NSArray *)convertStringToJson:(NSString *)convertStr {
    NSData *strData = [convertStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:strData options:kNilOptions error:nil];
    return arr;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stocksListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"stocksTableCell";
    
    StocksListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = UIColorFromRGB(0xECEBF3);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *productImageStr = [NSString stringWithFormat:@"product_%@.jpg", [[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"productId"]];
    NSString *productName = [[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"productName"];
    [cell.productImage setImage:[UIImage imageNamed:productImageStr]];
    cell.nameStr.text = productName;
    cell.priceLabel.text = [NSString stringWithFormat:@"₹%@", [[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"price"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.stockDetailArray = [self.stocksListArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:stockDetailIdentifier sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:stockDetailIdentifier]) {
        StockDetailViewController *detailVC = [segue destinationViewController];
        detailVC.stockArray = self.stockDetailArray;
    }
    else if([segue.identifier isEqualToString:@"myStocks"]) {
        MyStocksViewController *detailVC = [segue destinationViewController];
        detailVC.allStocksArray = self.stocksListArray;
    }
    
}






- (IBAction)logoutBtnClick:(id)sender {
    
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    
    [self.navigationController popViewControllerAnimated:true];
}
@end
