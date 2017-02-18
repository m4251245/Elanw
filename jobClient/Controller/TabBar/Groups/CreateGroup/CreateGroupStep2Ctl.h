

#import "BaseEditInfoCtl.h"
#import "CreateGroupDataModel.h"
#import "ExRequetCon.h"
#import "CreateGroupStep3Ctl.h"
#import "CustomButton.h"

//#define HORIZONTAL_PADDING 7.0f
//#define VERTICAL_PADDING 3.0f

@interface CreateGroupStep2Ctl : BaseEditInfoCtl
{
    IBOutlet    UIView      *gourpTagView_;
    IBOutlet    UITextField *groupTagTfview_;

    CustomButton *_tagBtn;/**< 标签 */
    NSString *groupTags;
    UILabel *_alertlab;/**< 标签字数提示 */
    IBOutlet UIButton *addBtn;
    
    
    CreateGroupDataModel    *inModel_;
    RequestCon              *createCon_;
    CreateGroupStep3Ctl     *step3Ctl_;
    RequestCon     *updateImgCon_;
    NSString       *groupImgUrl_;
}

@property(nonatomic,assign) int enterType_;

@property(nonatomic,strong) NSMutableArray *tagsMade;/**< 标签数组 */
@property (nonatomic, strong) NSMutableArray *tagViews;/**< 标签数组 */
@property (nonatomic, assign) BOOL readyToDelete;
@property (nonatomic, assign) BOOL focusOnAddTag;
@property (nonatomic, assign) CGFloat tagGap;/**< 间距 */

@end
