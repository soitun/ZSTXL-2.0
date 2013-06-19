//
//  StarNewsViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-18.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "StarNewsViewController.h"
#import "InformationCell.h"
#import "NewsDetailController.h"

@interface StarNewsViewController ()

@end

@implementation StarNewsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)requestPara
{
    NSString *page = [NSString stringWithFormat:@"%d", self.page];
    NSDictionary *para = @{@"path": @"getInformationCollectList.json",
                           @"userid": @"109971",
                           @"page": page,
                           @"maxrow": self.maxrow};
    
    return para;
}

- (NSString *)parseKey
{
    return @"InformationList";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"InformationCell";
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:self options:nil] lastObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(InformationCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.labTitle.text = [dict objForKey:@"informationtitle"];
    cell.labSubTitle.text = [dict objForKey:@"informationtitle2"];
    
    [cell.avatar setImageWithURL:[NSURL URLWithString:[dict objForKey:@"pictureurl"]] placeholderImage:[UIImage imageNamed:@"agency_default.png"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    NewsDetailController *newsDetailVC = [[[NewsDetailController alloc] init] autorelease];
    newsDetailVC.newsId = [dict objForKey:@"id"];
    newsDetailVC.newsArray = self.dataSourceArray;
    newsDetailVC.newsIndex = indexPath.row;
    PERFORM_SELECTOR_WITH_OBJECT(self.parentController, @selector(pushViewController:), newsDetailVC);
}

@end
