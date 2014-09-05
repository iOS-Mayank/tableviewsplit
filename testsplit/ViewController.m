//
//  ViewController.m
//  testsplit
//
//  Created by jonathan twaddell on 9/5/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
  NSMutableArray *_data;
  UIImageView *_topImageFrag;
  UIImageView *_bottomImageFrag;
  
  
  CGFloat _fixedCellHeight;

}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  _fixedCellHeight=100;
  
  NSDictionary *obj1=@{@"name":@"Julie"};
  NSDictionary *obj2=@{@"name":@"Melissa"};
  NSDictionary *obj3=@{@"name":@"Betty"};
  NSDictionary *obj4=@{@"name":@"Christina"};
  NSDictionary *obj5=@{@"name":@"Emily"};
  NSDictionary *obj6=@{@"name":@"Emma"};
  NSDictionary *obj7=@{@"name":@"Julie"};
  NSDictionary *obj8=@{@"name":@"Bill"};
  NSDictionary *obj9=@{@"name":@"Laura"};
  NSDictionary *obj10=@{@"name":@"Amy"};
  NSDictionary *obj11=@{@"name":@"Lisa"};
  NSDictionary *obj12=@{@"name":@"Jennifer"};
  
  _data=[[NSMutableArray alloc] init];
  [_data addObject:obj1];
  [_data addObject:obj2];
  [_data addObject:obj3];
  [_data addObject:obj4];
  [_data addObject:obj5];
  [_data addObject:obj6];
  [_data addObject:obj7];
  [_data addObject:obj8];
  [_data addObject:obj9];
  [_data addObject:obj10];
  [_data addObject:obj11];
  [_data addObject:obj12];
  
  self.tableView.dataSource=self;
  self.tableView.delegate=self;
  
  
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat _topOffset=41.0f; // magic number???
  NSLog(@"here i am at %i", indexPath.row);
  // here we have the full size right????
  UIView *tmpSnap = [self.tableView snapshotViewAfterScreenUpdates:YES];

  
  // how to calculate the offset for tmpSnap????
  CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
  CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];
  NSLog(@"Y of Cell is: %f", rectOfCellInSuperview.origin.y);
  
  UIGraphicsBeginImageContextWithOptions(tmpSnap.frame.size, YES, 1.0);
  NSLog(@"here is size: %f and %f",tmpSnap.frame.size.height, tmpSnap.frame.size.width );
  // [view.layer renderInContext:UIGraphicsGetCurrentContext()]; // <- same result...
  [tmpSnap drawViewHierarchyInRect:tmpSnap.bounds afterScreenUpdates:YES];
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  // lets get CGImage
  CGFloat offset=(rectOfCellInSuperview.origin.y + (_fixedCellHeight / 2));
  
  
  CGRect fromRect = CGRectMake(0, 0, 320, offset);
  CGImageRef drawImage = CGImageCreateWithImageInRect(img.CGImage, fromRect);
  UIImage *newImage = [UIImage imageWithCGImage:drawImage];
  
  _topImageFrag=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, _topOffset, 320.0f,offset)];
  _topImageFrag.image=newImage;
  //_topImageFrag.layer.borderWidth=2.0f;
  //_topImageFrag.layer.borderColor=[UIColor yellowColor].CGColor;

  
  CGRect bottomRect = CGRectMake(0, offset, 320.0f, 480.0f-offset );
  CGImageRef bottomImageRef = CGImageCreateWithImageInRect(img.CGImage, bottomRect);
  UIImage *bottomImage = [UIImage imageWithCGImage:bottomImageRef];

  
  _bottomImageFrag=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, (rectOfCellInSuperview.origin.y + (_fixedCellHeight / 2))+_topOffset, 320.0f,480.0f-offset)];
  _bottomImageFrag.image=bottomImage;
  
  [self.view addSubview:_topImageFrag];
  [self.view addSubview:_bottomImageFrag];
  [self animateFrags];
  [self.tableView removeFromSuperview];
}

-(void)animateFrags
{
  [UIView animateWithDuration:1.0f
                        delay:0
                      options: UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     NSLog(@"animate");
                     _topImageFrag.frame=CGRectMake(0.0f, 0-_topImageFrag.frame.size.height, 320.0f, _topImageFrag.frame.size.height);
                     _bottomImageFrag.frame=CGRectMake(0.0f, 480.0f, 320.0f, _bottomImageFrag.frame.size.height);
                   } completion:^(BOOL finished){
                     NSLog(@"animate complete");
                   }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return _fixedCellHeight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"here is %i", [_data count]);
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableCell"];
  
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:@"SimpleTableCell"];
    
    cell.textLabel.text=[_data[indexPath.row] objectForKey:@"name"];
    
    
  }
  
  if(indexPath.row % 2){
    [cell setBackgroundColor:[UIColor redColor]];
  }else{
    [cell setBackgroundColor:[UIColor blueColor]];
  }
  
  
  return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
