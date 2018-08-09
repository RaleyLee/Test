// The MIT License (MIT)
//
// Copyright (c) 2014 Suyeol Jeon (http:xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


//默认输入的文字
//NSDictionary *attrs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20],};
//textView.attributedText = [[NSAttributedString alloc] initWithString:@"Hi" attributes:attrs];

//文字输入的范围 居上20 居下20 居左20 居右20
//textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);

//首字下沉的效果
//UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 50)];
//textView.textContainer.exclusionPaths = @[path];



@import UIKit;

FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];

@interface UITextView (Placeholder)

@property (nonatomic, readonly) UITextView *placeholderTextView;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
