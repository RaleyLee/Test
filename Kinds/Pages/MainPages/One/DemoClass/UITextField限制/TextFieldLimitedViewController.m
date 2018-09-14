//
//  TextFieldLimitedViewController.m
//  Kinds
//
//  Created by hibor on 2018/9/3.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "TextFieldLimitedViewController.h"

typedef NS_ENUM(NSInteger,TFSwitchType){
    TFSwitchType_English,
    TFSwitchType_Chinese,
    TFSwitchType_Number,
    TFSwitchType_Emoji
};
#define kMaxLength 100
#define TFFont(font) [UIFont systemFontOfSize:font]

@interface TextFieldLimitedViewController ()<UITextFieldDelegate,TXScrollLabelViewDelegate,UIScrollViewDelegate>

//英文限制  中文限制  数字限制  表情限制
@property(nonatomic,strong)UILabel *englishLabel , *chineseLabel,  *numberLabel,  *emojiLabel,  *limitedLabel;
@property(nonatomic,strong)UISwitch *englishSwitch, *chineseSwitch, *numberSwitch, *emojiSwitch;
@property(nonatomic,assign)BOOL englishOpen, chineseOpen, numberOpen, emojiOpen;

@property(nonatomic,strong)UITextField *inputTextField;

@property(nonatomic,strong)TXScrollLabelView *scrollLabel1, *scrollLabel2, *scrollLabel3, *scrollLabel4;

@end

@implementation TextFieldLimitedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"UITextField限制";
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof (self) weakSelf = self;
    
    [self.view addSubview:self.englishLabel];
    [self.englishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.englishSwitch];
    [self.englishSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.englishLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.englishLabel);
    }];
    
    
    [self.view addSubview:self.chineseLabel];
    [self.chineseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.englishSwitch.mas_right).offset(30);
        make.top.equalTo(weakSelf.englishLabel);
        make.height.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.chineseSwitch];
    [self.chineseSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.chineseLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.chineseLabel);
    }];
    
    
    [self.view addSubview:self.limitedLabel];
    [self.limitedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.chineseSwitch.mas_right).offset(30);
        make.top.equalTo(weakSelf.englishLabel);
        make.height.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.englishLabel);
        make.top.equalTo(weakSelf.englishLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.numberSwitch];
    [self.numberSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.numberLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.numberLabel);
    }];
    
    [self.view addSubview:self.emojiLabel];
    [self.emojiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.numberSwitch.mas_right).offset(30);
        make.top.equalTo(weakSelf.numberLabel);
        make.height.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.emojiSwitch];
    [self.emojiSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.emojiLabel.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.emojiLabel);
    }];
    
    
    [self.view addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.englishLabel);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(20);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    
    
    self.scrollLabel1 = [[TXScrollLabelView alloc] initWithTitle:@"1234567890" type:TXScrollLabelViewTypeLeftRight velocity:3 options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    self.scrollLabel1.delegate = self;
    self.scrollLabel1.frame = CGRectMake(50, 100, 300, 30);
    [self.view addSubview:self.scrollLabel1];
    [self.scrollLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.inputTextField.mas_bottom).offset(50);
        make.height.mas_equalTo(30);
    }];
    [self.scrollLabel1 beginScrolling];
    
    self.scrollLabel2 = [[TXScrollLabelView alloc] initWithTitle:@"1234567890" type:TXScrollLabelViewTypeUpDown velocity:3 options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    self.scrollLabel2.delegate = self;
    self.scrollLabel2.frame = CGRectMake(50, 100, 300, 30);
    [self.view addSubview:self.scrollLabel2];
    [self.scrollLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.scrollLabel1.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
    }];
    [self.scrollLabel2 beginScrolling];
    
    self.scrollLabel3 = [[TXScrollLabelView alloc] initWithTitle:@"1234567890" type:TXScrollLabelViewTypeFlipRepeat velocity:3 options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    self.scrollLabel3.delegate = self;
    self.scrollLabel3.frame = CGRectMake(50, 100, 300, 30);
    [self.view addSubview:self.scrollLabel3];
    [self.scrollLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.scrollLabel2.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
    }];
    [self.scrollLabel3 beginScrolling];
    
    self.scrollLabel4 = [[TXScrollLabelView alloc] initWithTitle:@"1234567890" type:TXScrollLabelViewTypeFlipNoRepeat velocity:3 options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    self.scrollLabel4.delegate = self;
    self.scrollLabel4.frame = CGRectMake(50, 100, 300, 30);
    [self.view addSubview:self.scrollLabel4];
    [self.scrollLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.scrollLabel3.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
    }];
    [self.scrollLabel4 beginScrolling];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return [self isInputRuleAndNumber:string];
}

- (BOOL)isInputRuleAndNumber:(NSString *)str {
    if (!self.englishOpen && !self.chineseOpen && !self.numberOpen && !self.emojiOpen) {
        return YES;
    }
    //小写  a-z
    //大写  A-Z
    //汉字  \u4E00-\u9FA5
    //数字  \u0030-\u0039
    NSString *paString = @"[";
    if (self.englishOpen) {
        paString = @"a-zA-Z";
    }
    if (self.chineseOpen) {
        paString = [paString stringByAppendingString:@"\u4E00-\u9FA5"];
    }
    if (self.numberOpen) {
        paString = [paString stringByAppendingString:@"\\u0030-\\u0039"];
    }
    paString = [paString stringByAppendingString:@"]"];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", paString];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

-(void)textFieldChanged:(UITextField *)textField{
    
    NSString *toBeString = textField.text;
    if (![self isCheckValue:toBeString]) {
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

-(BOOL)isCheckValue:(NSString *)str{
    if (!self.englishOpen && !self.chineseOpen && !self.numberOpen && !self.emojiOpen) {
        return YES;
    }
    NSString *checkValue = @"^[";
    if (_englishOpen) {
        checkValue = [checkValue stringByAppendingString:@"a-zA-Z"];
    }
    if (_chineseOpen) {
        checkValue = [checkValue stringByAppendingString:@"\u4E00-\u9FA5"];
    }
    if (_numberOpen) {
        checkValue = [checkValue stringByAppendingString:@"\\d"];
    }
    checkValue = [checkValue stringByAppendingString:@"]*$"];
    NSPredicate *check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",checkValue];
    return [check evaluateWithObject:str];
}


-(UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [UITextField new];
//        _inputTextField.delegate = self;
        _inputTextField.font = TFFont(15);
        _inputTextField.placeholder = @"输入内容";
        _inputTextField.layer.borderColor = RGB_color(220).CGColor;
        _inputTextField.layer.borderWidth = 0.5f;
        _inputTextField.layer.cornerRadius = 5;
        _inputTextField.layer.masksToBounds = YES;
        [_inputTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputTextField;
}


-(UILabel *)englishLabel{
    if (!_englishLabel) {
        _englishLabel = [UILabel new];
        _englishLabel.font = TFFont(15);
        _englishLabel.text = @"限制英文";
    }
    return _englishLabel;
}

-(UILabel *)chineseLabel{
    if (!_chineseLabel) {
        _chineseLabel = [UILabel new];
        _chineseLabel.font = TFFont(15);
        _chineseLabel.text = @"限制中文";
    }
    return _chineseLabel;
}

-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
        _numberLabel.font = TFFont(15);
        _numberLabel.text = @"限制数字";
    }
    return _numberLabel;
}

-(UILabel *)emojiLabel{
    if (!_emojiLabel) {
        _emojiLabel = [UILabel new];
        _emojiLabel.font = TFFont(15);
        _emojiLabel.text = @"限制表情";
    }
    return _emojiLabel;
}

-(UILabel *)limitedLabel{
    if (!_limitedLabel) {
        _limitedLabel = [UILabel new];
        _limitedLabel.font = TFFont(15);
        _limitedLabel.text = @"限制长度";
    }
    return _limitedLabel;
}

-(UISwitch *)englishSwitch{
    if (!_englishSwitch) {
        _englishSwitch = [UISwitch new];
        _englishSwitch.on = self.englishOpen;
        _englishSwitch.tag = TFSwitchType_English;
        [_englishSwitch addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _englishSwitch;
}

-(UISwitch *)chineseSwitch{
    if (!_chineseSwitch) {
        _chineseSwitch = [UISwitch new];
        _chineseSwitch.on = self.chineseOpen;
        _chineseSwitch.tag = TFSwitchType_Chinese;
        [_chineseSwitch addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _chineseSwitch;
}

-(UISwitch *)numberSwitch{
    if (!_numberSwitch) {
        _numberSwitch = [UISwitch new];
        _numberSwitch.on = self.numberOpen;
        _numberSwitch.tag = TFSwitchType_Number;
        [_numberSwitch addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _numberSwitch;
}

-(UISwitch *)emojiSwitch{
    if (!_emojiSwitch) {
        _emojiSwitch = [UISwitch new];
        _emojiSwitch.on = self.emojiOpen;
        _emojiSwitch.tag = TFSwitchType_Emoji;
        [_emojiSwitch addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _emojiSwitch;
}


-(void)changeSwitchValue:(UISwitch *)tSwitch{
    if (tSwitch.tag == TFSwitchType_English) {
        self.englishOpen = !self.englishOpen;
        self.englishSwitch.on = self.englishOpen;
    }
    
    if (tSwitch.tag == TFSwitchType_Chinese) {
        self.chineseOpen = !self.chineseOpen;
        self.chineseSwitch.on = self.chineseOpen;
    }
    
    if (tSwitch.tag == TFSwitchType_Number) {
        self.numberOpen = !self.numberOpen;
        self.numberSwitch.on = self.numberOpen;
    }
    
    if (tSwitch.tag == TFSwitchType_Emoji) {
        self.emojiOpen = !self.emojiOpen;
        self.emojiSwitch.on = self.emojiOpen;
    }
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




/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
/**
 * 字母、数字、中文正则判断（包括空格）【注意3】
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
/**
 *  获得 kMaxLength长度的字符
 */
-(NSString *)getSubString:(NSString*)string
{
    if (string.length > kMaxLength) {
        NSLog(@"超出字数上限");
//        _totalCharacterLabel.text = @"0";
        return [string substringToIndex:kMaxLength];
    }else {
//        _totalCharacterLabel.text = [NSString stringWithFormat:@"%ld",(long)(CharacterCount - string.length)];
    }
    return nil;
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (length > kMaxLength) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//【注意4】：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return nil;
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


@end
