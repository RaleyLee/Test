//
//  MessageViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/7.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageFrame.h"
#import "MessageModel.h"
#import "MessageCell.h"


@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UIView *bottomView;
    UITextField *inputTF;
}
@property(nonatomic,strong)UITableView *chatTableView;
@property(nonatomic,strong)NSMutableArray *messageFrames;

@property(nonatomic,strong)UIView *toolView;

@end

@implementation MessageViewController

#pragma mark - 懒加载数据
-(NSMutableArray *)messageFrames{
    if (_messageFrames == nil) {
        NSString *infoPath = [[NSBundle mainBundle] pathForResource:@"Message" ofType:@"plist"];
        NSArray *arrayDict = [NSArray arrayWithContentsOfFile:infoPath];
        NSMutableArray *arrayModels = [NSMutableArray array];
        for (NSDictionary *dict in arrayDict) {
            //创建数据模型
            MessageModel *model = [MessageModel messageWithDict:dict];
            
            //获取上一个数据模型
            MessageModel *lastMessage = (MessageModel *)[[arrayModels lastObject] message];
            
            //判断当前模型的消息发送时间是否和上一个模型的消息发送时间一致
            //如果一样 做标记
            if ([model.time isEqualToString:lastMessage.time]) {
                model.hideTime = YES;
            }else{
                model.hideTime = NO;
            }
            
            model.text = [dict objectForKey:@"text"];
            model.type = [[dict objectForKey:@"type"] isEqualToString:@"1"] ? CZMessageTypeOther : CZMessageTypeMe;
            model.time = [dict objectForKey:@"time"];
            //创建frame模型
            MessageFrame *modelFrame = [[MessageFrame alloc] init];
            modelFrame.message = model;
            
            
            //把frame模型加到arrayModels
            [arrayModels addObject:modelFrame];
        }
        _messageFrames = arrayModels;
    }
    return _messageFrames;
}

-(UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        _toolView.backgroundColor = RGB_color(235);
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RGB_color(215);
        [_toolView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
       
        __weak typeof (self) weakSelf = self;
        
        UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [voiceButton setImage:[UIImage imageNamed:@"wechat-voice"] forState:UIControlStateNormal];
        [_toolView addSubview:voiceButton];
        [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-11);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:[UIImage imageNamed:@"wechat_message_add"] forState:UIControlStateNormal];
        [_toolView addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-11);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [faceButton setImage:[UIImage imageNamed:@"wechat_message_emoji"] forState:UIControlStateNormal];
        [faceButton addTarget:self action:@selector(sendBiaoQingAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:faceButton];
        [faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-11);
            make.right.equalTo(addButton.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        UITextView *textView = [UITextView new];
        textView.delegate = self;
        textView.tag = 200;
        textView.layer.borderColor = RGB(221, 221, 221).CGColor;
        textView.layer.borderWidth = 1;
        textView.layer.cornerRadius = 3;
        textView.layer.masksToBounds = YES;
//        textView.contentMode = UIViewContentModeCenter;
//        textView.textContainerInset = UIEdgeInsetsMake(0, 5, 0, 5);
        textView.font = [UIFont systemFontOfSize:15];
//        [textView addObserver:self forKeyPath:@"contentSize"options:NSKeyValueObservingOptionNew context:nil];
         [_toolView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(voiceButton.mas_right).offset(10);
            make.right.equalTo(faceButton.mas_left).offset(-10);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(-5);
        }];
        
    }
    return _toolView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context

{
    UITextView *textView = (UITextView *)object;
    CGFloat topCorrect = ([textView bounds].size.height - [textView contentSize].height);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    textView.contentOffset = (CGPoint){.x = 0, .y = -topCorrect / 2};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGB_color(235);
    
    __weak typeof (self) weakSelf = self;
    
    
    [self.view addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    self.chatTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    self.chatTableView.separatorColor = [UIColor clearColor];
    [self.chatTableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.chatTableView];
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(weakSelf.toolView.mas_top);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageFrames.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageFrame *modelFrame = self.messageFrames[indexPath.row];
    
    MessageCell *cell = [MessageCell messageCellWithTableView:tableView];
    
    cell.messageFrame = modelFrame;
    cell.headName = self.iamgeName;
    
    return cell;
}

#pragma mark - 返回每行行高

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageFrame *messageFrame = _messageFrames[indexPath.row];
    return messageFrame.rowHeight;
}


#pragma mark - 发送表情
-(void)sendBiaoQingAction:(UIButton *)sender{

}


#pragma mark - 发生消息方法
-(void)sendMessage:(NSString *)msg withType:(CZMessageType)type{
    //2.创建一个数据模型和frame模型
    MessageModel *model = [[MessageModel alloc] init];
    model.text = msg;
    model.type = type;
    NSDate *nowDate = [NSDate date];//获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];//设置格式
    formatter.dateFormat = @"今天 HH:mm";
    model.time = [formatter stringFromDate:nowDate];
    
    //创建frame模型
    MessageFrame *modelFrame = [[MessageFrame alloc] init];
    
    
    //根据当前消息时间和上一条消息的时间  判断是否隐藏时间label
    MessageFrame *lastMessageFrame = [_messageFrames lastObject];
    NSString *lastTime = lastMessageFrame.message.time;
    if ([model.time isEqualToString:lastTime]) {
        model.hideTime = YES;
    }else{
        model.hideTime = NO;
    }
    modelFrame.message = model;
    //3.把frame模型加到集合中
    [_messageFrames addObject:modelFrame];
    
    //4.刷新UITableView的数据
    [self.chatTableView reloadData];
    
    //5.把最后一行滚到最上面
    NSIndexPath *loastRowIndexPath = [NSIndexPath indexPathForRow:_messageFrames.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:loastRowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.chatTableView scrollToRow:self.messageFrames.count-1 inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

-(void)KeyboardWillShowNotification:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        
        weakSelf.chatTableView.contentOffset = CGPointMake(0, SCREEN_HEIGHT-rect.size.height-50-64);
        [weakSelf.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-rect.size.height);
        }];
        [self.chatTableView scrollToRow:self.messageFrames.count-1 inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    UITextView *tf = (UITextView *)[self.toolView viewWithTag:200];
    [tf resignFirstResponder];
}


-(void)KeyboardWillHideNotification:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.chatTableView.contentOffset = CGPointMake(0, 0);
        [weakSelf.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        
    }];
    [self.chatTableView scrollToRow:self.messageFrames.count-1 inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)textViewDidChange:(UITextView *)textView
{

    CGSize size2 =  [textView.text boundingRectWithSize:CGSizeMake(textView.width-10, MAXFLOAT)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                          context:nil].size;

    UIFont *font = textView.font;
    CGFloat hei = font.lineHeight;
    NSInteger lines = (NSInteger)(size2.height / font.lineHeight);
    CGFloat frameHeight = hei;
    if (lines == 1) {
        frameHeight = 40;
    }else{
        frameHeight = 18*lines+10;
    }
    if (frameHeight >= 100) {
        frameHeight = 100;
    }
    UITextView *tv2 = (UITextView *)[self.toolView viewWithTag:200];
    [tv2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(frameHeight);
    }];
    [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(frameHeight+10);
    }];
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    if ((!selectedRange ||  !pos) && textView.text.length && [text isEqualToString:@"\n"]) {
        NSString *text = textView.text;
        
        [self sendMessage:text withType:CZMessageTypeMe];
        [self sendMessage:text withType:CZMessageTypeOther];
        
        textView.text = @"";
        
        [self textViewDidChange:textView];
        return NO;
    }
        
    
    CGSize size2 =  [textView.attributedText.string boundingRectWithSize:CGSizeMake(textView.width-10, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                context:nil].size;
    UIFont *font = textView.font;
    CGFloat hei = font.lineHeight;
    NSInteger lines = (NSInteger)(size2.height / font.lineHeight);
    CGFloat frameHeight = hei;
    if (lines == 1) {
        frameHeight = 40;
    }else{
        frameHeight = 18*lines+10;
    }
    if (frameHeight >= 100) {
        frameHeight = 100;
    }
    UITextView *tv2 = (UITextView *)[self.toolView viewWithTag:200];
    [tv2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(frameHeight);
    }];
    [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(frameHeight+10);
    }];
    return YES;
    
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
