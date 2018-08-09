//
//  PopAddStockView.m
//  Kinds
//
//  Created by hibor on 2018/7/25.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "PopAddStockView.h"

@interface PopAddStockView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property(nonatomic,assign)BOOL isPopKey;

@end


NSString *const regex = @"  ~!#$%^&*)(|`-={}[]\\:;<>,./?！·@￥…&（）《》，。、？；：‘’“”+—。";

@implementation PopAddStockView

+(PopAddStockView *)popAddStockView{
    PopAddStockView *addView = [[NSBundle mainBundle] loadNibNamed:@"PopAddStockView" owner:nil options:nil].firstObject;
    return addView;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = [UIScreen mainScreen].bounds;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotation) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [_inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tapHidden = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self addGestureRecognizer:tapHidden];
    
    return self;
}

-(void)setPopStyle:(PopAddViewStyle)popStyle{
    _popStyle = popStyle;
}

- (void) textFieldDidChange:(UITextField *) TextField{
    
    if (TextField.markedTextRange == nil) {
        
        //限制字符长度
        if (TextField.text.length>6) {
            
            TextField.text = [TextField.text substringToIndex:6];
            NSLog(@"组名过长,最大为6个字符");
        }
    }
    
}

-(void)hiddenKeyBoard{
    [self.inputTextField resignFirstResponder];
}

-(void)changeRotation{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animateTextField:self.inputTextField up:[self.inputTextField isFirstResponder]];
    });
 
}

-(void)awakeFromNib{
    [super awakeFromNib];

    UIBezierPath *besizer = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = besizer.CGPath;
    self.bgView.layer.mask = shapeLayer;
}

-(void)show{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    [self animatedIn];
}

-(void)dismiss{
    [self animatedOut];
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self animatedOut];
}

- (IBAction)confirmButtonAction:(UIButton *)sender {
    if (_inputTextField.text.length == 0) {
        NSLog(@"请输入组名！");
        return;
    }
    if (_inputTextField.text.length>0) {
        
        //判断非法字符
        NSString *falseChar = @"";
        
        for (int i=0; i<_inputTextField.text.length; i++) {
            
            NSString *lastString = [_inputTextField.text substringWithRange:NSMakeRange(i, 1)];
            
            if ([regex rangeOfString:lastString].location != NSNotFound) {
                
                falseChar = [falseChar stringByAppendingString:lastString];
                
                break; //add by w.g
                
            }
        }
        //change by w.g
        if ([falseChar isEqualToString:@" "] || [falseChar isEqualToString:@" "]) {
            falseChar = @"空格";
        }
        if (falseChar.length>0) {
            NSLog(@"%@",[NSString stringWithFormat:@"非法字符 %@",falseChar]);
            
            return;
        }
        //change by w.g end
        if (_inputTextField.text.length<=6) {
            if (_confirmClickBlock) {
                _confirmClickBlock(_inputTextField.text);
            }
            [self dismiss];
        } else {
            NSLog(@"组名过长");
        }
    }
//    [self animatedOut];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (_popStyle == PopAddViewStyleAdd) {
        _titleLabel.text = @"添加分组";
    }else if (_popStyle == PopAddViewStyleReName) {
        _titleLabel.text = @"修改组名";
    }
}

#pragma mark - Animated Mthod
- (void)animatedIn{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut{
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.isPopKey = YES;
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.39 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animateTextField:textField up:NO];
        self.isPopKey = NO;
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];

    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{

    if (!self.isPopKey) {
        return;
    }
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.bgView.frame = CGRectOffset(self.bgView.frame, 0, movement);
    [UIView commitAnimations];
}

@end
