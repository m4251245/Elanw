#import "HFImageEditorViewController.h"

typedef enum {
    Type16_9=1,
    Type16_10,
    Type4_3,
    Type1_1,
    Type3_4,
    Type9_16,
}ChangeSizeType;
    
@interface PhotoEditorCtl : HFImageEditorViewController

@property(nonatomic,retain) IBOutlet UIBarButtonItem *saveButton;

@property (weak, nonatomic) UIButton *selectedBtn;//选择的比例
@property (weak, nonatomic) IBOutlet UIButton *btn1_1;
@property (weak, nonatomic) IBOutlet UIButton *btn4_3;
@property (weak, nonatomic) IBOutlet UIButton *btn3_4;
@property (weak, nonatomic) IBOutlet UIButton *btn16_9;
@property (weak, nonatomic) IBOutlet UIButton *btn9_16;
@property (weak, nonatomic) IBOutlet UIButton *rotateBtn;
@property (nonatomic,assign)ChangeSizeType sizeType;

@property (nonatomic,assign) BOOL isOnlyOneSel;

@property (nonatomic,assign) int imageType;

- (IBAction)btnResponse:(id)sender;
- (IBAction)rotateImge:(id)sender;

@end
