//
//  ZhaoshangDailiViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ZhaoshangDailiViewController.h"

#define IMAGE_WIDTH (106)
#define IMAGE_HEIGHT (97)

@interface ZhaoshangDailiViewController ()

@end

@implementation ZhaoshangDailiViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"分类";
    
    self.cateNameArray = [NSMutableArray arrayWithObjects:@"抗生素", @"骨伤风湿", @"抗肿瘤", @"内分泌", @"泌尿生殖", @"心脑血管", @"神经", @"消化", @"呼吸", @"其它", @"", @"", nil];
    
    self.cateImageArray = [NSMutableArray arrayWithObjects:@"antibiotic", @"bone", @"tumour", @"endocrine", @"urinary", @"heart", @"nerve", @"digest", @"breath", @"other", @"", @"", nil];
    
    [self initCategory];
    
    self.cateScrollView.contentSize = CGSizeMake(320, self.adScrollView.frame.size.height + (IMAGE_HEIGHT+1)*4-1);
    
    [self initAdScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_adScrollView release];
    [_cateScrollView release];
    [_adScrollPageControl release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setAdScrollView:nil];
    [self setCateScrollView:nil];
    [self setAdScrollPageControl:nil];
    [super viewDidUnload];
}

- (void)initCategory
{
    NSInteger cateY = self.adScrollView.frame.origin.y + self.adScrollView.frame.size.height;
    
    for (int i=0; i<4; i++)
    {
        for (int j=0; j<3; j++)
        {
            if (i == 3) {
                if (j == 1 || j == 2) {
                    continue;
                }
            }
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:[self.cateNameArray objectAtIndex:i*3+j] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setBackgroundColor:RGBCOLOR(243, 244, 245)];
            [button setImage:[UIImage imageNamed:[self.cateImageArray objectAtIndex:i*3+j]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"cate_texture"] forState:UIControlStateHighlighted];
            
            button.frame = CGRectMake(j*(IMAGE_WIDTH+1), cateY+i*(IMAGE_HEIGHT+1), IMAGE_WIDTH, IMAGE_HEIGHT);
            
            // the space between the image and text
            CGFloat spacing = 4.f;
            
            // get the size of the elements here for readability
            CGSize imageSize = button.imageView.frame.size;
            CGSize titleSize = button.titleLabel.frame.size;
            
            // lower the text and push it left to center it
            button.titleEdgeInsets = UIEdgeInsetsMake(0.f, -imageSize.width, -(imageSize.height+spacing), 0.0);
            
            // the text width might have changed (in case it was shortened before due to
            // lack of space and isn't anymore now), so we get the frame size again
            titleSize = button.titleLabel.frame.size;
            
            // raise the image and push it right to center it
            button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
            
            
            button.tag = i*3+j;
            [button addTarget:self action:@selector(selectCateWithIndex:) forControlEvents:UIControlEventTouchUpInside];
            [self.cateScrollView addSubview:button];
        }

        //横向separator
        if (i<3) {
            UIImageView *sepImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator"]];
            sepImage.frame = CGRectMake(0, cateY+(i+1)*(IMAGE_HEIGHT+1)-1, 320, 1);
            [self.cateScrollView addSubview:sepImage];
        }
    }
    
    
    //竖向separator
    for (int i=1; i<3; i++)
    {
        UIImageView *sepImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_l"]];
        sepImage.frame = CGRectMake(i*(IMAGE_WIDTH+1)-1, cateY, 1, (IMAGE_HEIGHT+1)*4-1);
        [self.cateScrollView addSubview:sepImage];
    }
    
    
}

- (void)selectCateWithIndex:(UIButton *)sender
{
    DLog(@"button tag %d", sender.tag);
}

- (void)initAdScrollView
{
    self.adScrollView.contentSize = CGSizeMake(320*3, self.adScrollView.frame.size.height);
    self.adScrollView.contentOffset = CGPointMake(320, 0);
    self.adScrollView.delegate = self;
    
    for (int i=0; i<3; i++) {
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cate_ad"]];
        image.frame = CGRectMake((i)*320, 0, 320, self.adScrollView.frame.size.height);
        [self.adScrollView addSubview:image];
    }
    
    [self.adScrollView bringSubviewToFront:self.adScrollPageControl];
    
    
//    self.adScrollPageControl.numberOfPages = 3;
//    self.adScrollPageControl.currentPage = 1;
//    self.adScrollPageControl.enabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.adScrollPageControl.currentPage=page;
}




@end
