//
//  UITextFieldViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/21.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "UITextFieldViewController.h"

#import "UITextView+Placeholder.h"
#import "TopCircleView.h"

#define MAXLENGTH 18
#define MAXLENGTH_TV 40

#define LEFT_SPACING 15

@interface UITextFieldViewController ()<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UITextField *limitedTF1;
@property(nonatomic,strong)UITextView *limitedTV1;
@property(nonatomic,strong)UILabel *calLabel;
@property(nonatomic,strong)UISwitch *CESwitch;//控制是否区分中英文

@property(nonatomic,assign)BOOL destCAE; //是否区分

@end

@implementation UITextFieldViewController


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
   
    
    UILabel *DesLabel = [UILabel new];
    DesLabel.text = @"是否区分中英文(UITextField)";
    DesLabel.font = FONT_9_MEDIUM(15);
    [self.view addSubview:DesLabel];
    [DesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFT_SPACING);
        make.top.mas_equalTo(LEFT_SPACING);
        make.size.mas_equalTo(CGSizeMake(210, 30));
    }];
    
    [self.view addSubview:self.CESwitch];
    [self.CESwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(LEFT_SPACING);
        make.left.equalTo(DesLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(51, 31));
    }];
    
    
    UILabel *TFLabel = [UILabel new];
    TFLabel.text = [NSString stringWithFormat:@"输入字符限制%d位",MAXLENGTH];
    TFLabel.font = FONT_9_MEDIUM(15);
    [self.view addSubview:TFLabel];
    [TFLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(DesLabel.mas_bottom);
        make.left.mas_equalTo(LEFT_SPACING);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    
    
    
    [self.view addSubview:self.limitedTF1];
    [self.limitedTF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFT_SPACING);
        make.right.mas_equalTo(-LEFT_SPACING);
        make.top.equalTo(TFLabel.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    
    UILabel *TVLabel = [UILabel new];
    TVLabel.text = [NSString stringWithFormat:@"输入字符限制%d位",MAXLENGTH_TV];
    TVLabel.font = FONT_9_MEDIUM(15);
    [self.view addSubview:TVLabel];
    [TVLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFT_SPACING);
        make.top.equalTo(self.limitedTF1.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    [self.view addSubview:self.limitedTV1];
    [self.limitedTV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFT_SPACING);
        make.top.equalTo(TVLabel.mas_bottom);
        make.right.mas_equalTo(-LEFT_SPACING);
        make.height.mas_equalTo(150);
    }];
    
    [self.view addSubview:self.calLabel];
    [self.calLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.limitedTV1.mas_bottom);
        make.right.mas_equalTo(-LEFT_SPACING);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    [self textViewDidChange:self.limitedTV1];
    
    TopCircleView *circleView = [[TopCircleView alloc] initWithFrame:CGRectMake(20, 300, 100, 100)];
    circleView.backgroundColor = [UIColor orangeColor];
    circleView.contentNumber = @"103";
    [self.view addSubview:circleView];
    
}

-(UISwitch *)CESwitch{
    if (!_CESwitch) {
        _CESwitch = [UISwitch new];
        _CESwitch.on = self.destCAE;
        [_CESwitch addTarget:self action:@selector(changeValueForDistinguishBetweenChineseandEnglish) forControlEvents:UIControlEventValueChanged];
    }
    return _CESwitch;
}
#pragma mark - 是否区分中英文
-(void)changeValueForDistinguishBetweenChineseandEnglish{
    self.destCAE = !self.destCAE;
    self.CESwitch.on = self.destCAE;
    self.limitedTF1.text = @"";
}
-(UILabel *)calLabel{
    if (!_calLabel) {
        _calLabel = [UILabel new];
        _calLabel.font = FONT_9_MEDIUM(13);
        _calLabel.textAlignment = NSTextAlignmentRight;
        _calLabel.textColor = RGB_color(118);
    }
    return _calLabel;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(UITextField *)limitedTF1{
    if (!_limitedTF1) {
        _limitedTF1 = [UITextField new];
        _limitedTF1.delegate = self;
        _limitedTF1.font = FONT_9_MEDIUM(15);
        _limitedTF1.placeholder = [NSString stringWithFormat: @"请输入您的用户名(%d)",MAXLENGTH];
        _limitedTF1.clearButtonMode = UITextFieldViewModeWhileEditing;
        _limitedTF1.borderStyle = UITextBorderStyleRoundedRect;
        _limitedTF1.backgroundColor = RGB_color(244);
        _limitedTF1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_limitedTF1 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_limitedTF1 setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_limitedTF1 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _limitedTF1;
}


-(UITextView *)limitedTV1{
    if (!_limitedTV1) {
        _limitedTV1 = [UITextView new];
        _limitedTV1.delegate = self;
        _limitedTV1.tag = 106;
        _limitedTV1.placeholder = [NSString stringWithFormat:@"请输入(%d)",MAXLENGTH_TV];
        _limitedTV1.layer.borderColor = RGB_color(200).CGColor;
        _limitedTV1.backgroundColor = RGB_color(244);
        _limitedTV1.layer.borderWidth = 1.f;
        _limitedTV1.font = FONT_9_MEDIUM(15);
        [_limitedTV1 setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_limitedTV1 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return _limitedTV1;
}


- (void)textFieldChanged:(UITextField *)textField {
    NSString *toBeString = textField.text;
    if (![self isInputRuleAndBlank:toBeString]) {
        textField.text = [self disable_emoji:toBeString];
        return;
    }
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
    if([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
}

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        NSString *other = @"①②③④⑤⑥⑦⑧⑨⑩〇➋➌➍➎➏➐➑➒";
        unsigned long len=str.length;
        for(int i=0;i<len;i++)
        {
            unichar a=[str characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:str].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
        
    }
    return isMatch;
}
/**
 * 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/**
 *  过滤字符串中的emoji
 */
- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

/**
 *  获得 CharacterCount长度的字符
 */
-(NSString *)getSubString:(NSString*)string
{
    //区分中英文  2个字符/中文   1个字符/英文
    if (self.destCAE) {
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData* data = [string dataUsingEncoding:encoding];
        NSInteger length = [data length];
        if (length > MAXLENGTH) {
            NSData *data1 = [data subdataWithRange:NSMakeRange(0, MAXLENGTH)];
            NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//注意：当截取CharacterCount长度字符时把中文字符截断返回的content会是nil
            if (!content || content.length == 0) {
                data1 = [data subdataWithRange:NSMakeRange(0, MAXLENGTH - 1)];
                content =  [[NSString alloc] initWithData:data1 encoding:encoding];
            }
            return content;
        }
        return nil;
    }else{
        if (string.length > MAXLENGTH) {
            NSLog(@"超出字数上限");
            //        _totalCharacterLabel.text = @"0";
            return [string substringToIndex:MAXLENGTH];
        }else {
            //        _totalCharacterLabel.text = [NSString stringWithFormat:@"%ld",(long)(CharacterCount - string.length)];
        }
        return nil;
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        return YES;
    } else {
        NSLog(@"超出字数限制");
        return NO;
    }
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAXLENGTH_TV - comcatstr.length;
    if (caninputlen >= 0){
        return YES;
    }else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
   
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    self.calLabel.text = [NSString stringWithFormat:@"%lu/40", (unsigned long)textView.text.length];
    if ( (unsigned long)textView.text.length > MAXLENGTH_TV) {
        // 对超出的部分进行剪切
        textView.text = [textView.text substringToIndex:MAXLENGTH_TV];
        self.calLabel.text = @"40/40";
    }

    return;
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAXLENGTH_TV)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAXLENGTH_TV];
        [textView setText:s];
    }
    //不让显示负数
    self.calLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAXLENGTH_TV - existTextNum),MAXLENGTH_TV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
