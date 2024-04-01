/**
 * 复习界面组件
 */
import { FULL_PERCENTAGE } from '../../../constants'
import { fsrs, FSRS, Grade, RecordLog, RecordLogItem, ReviewLogInput } from '../../../fsrs'
import { ReviewDict } from '../../../model'
import { currentDict, DictHelper } from '../../../utils'
import { LearnRecordHelper } from '../../../utils/LearnRecordHelper'

@Component
export struct Review {
  @StorageProp(currentDict) @Watch("initDict") private dict: string = ""
  @State private wordArr: ReviewDict[] = []
  @State private showTrans: boolean = false
  private fsrs: FSRS = fsrs()

  aboutToAppear(): void {
    // 初始化单词列表
    this.initDict()
  }

  build() {
    Column() {
      if (this.wordArr.length > 0) {
        // 标题栏
        Row() {
          if (this.wordArr.length > 1) {
            Row({ space: 5 }) {
              Image($r('app.media.back')).width(25).height(25).rotate({
                y: 1,
                angle: 180
              })
              Text($r('app.string.previous')).fontSize(12).fontWeight(FontWeight.Bold)
            }
            .onClick(() => {
              this.previous()
            })
          }
          Blank()
          if (this.wordArr[this.wordArr.length - 1].wordCard.card.last_review) {
            Text("上次学习时间：" + this.wordArr[this.wordArr.length - 1].wordCard.card.last_review?.toLocaleDateString())
              .fontSize(12).height(25)
          } else {
            Text("暂无上次学习记录")
              .fontSize(12).height(25)
          }
        }.width(FULL_PERCENTAGE)
        .padding(15)

        Column() {
          Column({ space: 5 }) {

            if (this.wordArr[this.wordArr.length - 1]) {
              // 单词
              Text(this.wordArr[this.wordArr.length - 1].wordCard.word.name)
                .fontSize(40)
                .fontWeight(FontWeight.Bold)
              // 音标
              Row({ space: 5 }) {
                if (this.wordArr[this.wordArr.length - 1].wordCard.word.usphone) {
                  Row({ space: 2 }) {
                    Text("us")
                      .fontSize(10)
                      .fontColor($r('app.color.white'))
                      .padding(2)
                      .textAlign(TextAlign.Center)
                      .fontWeight(FontWeight.Bold)
                      .backgroundColor($r('app.color.black'))
                      .borderRadius(5)
                    Text(this.wordArr[this.wordArr.length - 1].wordCard.word.usphone)
                  }
                }
                if (this.wordArr[this.wordArr.length - 1].wordCard.word.ukphone) {
                  Row({ space: 2 }) {
                    Text("uk")
                      .fontSize(10)
                      .fontColor($r('app.color.white'))
                      .padding(2)
                      .textAlign(TextAlign.Center)
                      .fontWeight(FontWeight.Bold)
                      .backgroundColor($r('app.color.black'))
                      .borderRadius(5)
                    Text(this.wordArr[this.wordArr.length - 1].wordCard.word.ukphone)
                  }
                }
                if (this.wordArr[this.wordArr.length - 1].wordCard.word.notation) {
                  Row({ space: 2 }) {
                    Text("no")
                      .fontSize(10)
                      .fontColor($r('app.color.white'))
                      .padding(2)
                      .textAlign(TextAlign.Center)
                      .fontWeight(FontWeight.Bold)
                      .backgroundColor($r('app.color.black'))
                      .borderRadius(5)
                    Text(this.wordArr[this.wordArr.length - 1].wordCard.word.notation)
                  }
                }
              }

              // 翻译
              Text(JSON.stringify(this.wordArr[this.wordArr.length - 1].wordCard.word.trans))
                .textAlign(TextAlign.Center)
                .margin({
                  left: 20,
                  right: 20
                })
                .visibility(this.showTrans ? Visibility.Visible : Visibility.Hidden)
            }
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

          Text($r('app.string.review_tip'))
            .visibility(this.showTrans ? Visibility.Hidden : Visibility.Visible)


          Row({ space: 5 }) {
            Text($r('app.string.again'))
              .backgroundColor($r('app.color.again'))
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
              .height(FULL_PERCENTAGE)
              .borderRadius(15)
              .onClick(() => {
                this.handleClick(Grade.Again)
              })
            Text($r('app.string.hard'))
              .backgroundColor($r('app.color.hard'))
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
              .height(FULL_PERCENTAGE)
              .borderRadius(15)
              .onClick(() => {
                this.handleClick(Grade.Hard)
              })
            Text($r('app.string.good'))
              .backgroundColor($r('app.color.good'))
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
              .height(FULL_PERCENTAGE)
              .borderRadius(15)
              .onClick(() => {
                this.handleClick(Grade.Good)
              })
            Text($r('app.string.easy'))
              .backgroundColor($r('app.color.easy'))
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
              .height(FULL_PERCENTAGE)
              .borderRadius(15)
              .onClick(() => {
                this.handleClick(Grade.Easy)
              })
          }.height(50)
          .margin(10)
          .visibility(this.showTrans ? Visibility.Visible : Visibility.Hidden)
        }
        .onClick(() => this.showTrans = true)
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)

      } else {
        Column() {
          Text($r("app.string.select_dict_tip"))
            .fontSize(35)
            .fontWeight(FontWeight.Bold)
        }.layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
    }
  }

  /**
   * 初始化单词列表
   */
  async initDict() {
    this.wordArr = []
    this.getNext()
  }

  /**
   * 上一步
   */
  async previous() {
    // 弹出最末尾的单词
    this.wordArr.pop()
    // 回滚学习记录
    this.wordArr[this.wordArr.length - 1].wordCard.card = this.fsrs.rollback(
      this.wordArr[this.wordArr.length - 1].wordCard.card,
      this.wordArr[this.wordArr.length - 1].log as ReviewLogInput
    )
    // 更新单词
    await DictHelper.updateWord(this.wordArr[this.wordArr.length - 1].wordCard)
    // 删除一条学习记录
    await LearnRecordHelper.deleteRecord()
  }

  /**
   * 处理点击选择困难度
   * @param grade
   */
  async handleClick(grade: Grade) {
    // 复习单词
    const recordLog: RecordLog = this.fsrs.repeat(this.wordArr[this.wordArr.length - 1].wordCard.card, new Date())
    this.wordArr[this.wordArr.length - 1].wordCard.card = (recordLog[grade.valueOf()] as RecordLogItem).card
    this.wordArr[this.wordArr.length - 1].log = (recordLog[grade.valueOf()] as RecordLogItem).log
    // 更新数据库数据
    await DictHelper.updateWord(this.wordArr[this.wordArr.length - 1].wordCard)
    // 获取下一个单词
    this.getNext()
    // 大于 50 清空前面的记录
    if (this.wordArr.length > 50) {
      this.wordArr.shift()
    }
    // 隐藏学习界面
    this.showTrans = false
    // 增加学习记录
    LearnRecordHelper.addRecord()
  }

  /**
   * 获取下一个单词
   */
  async getNext() {
    const nextword = await DictHelper.getNextWord()
    // 如果数组中有这个单词就删掉这个单词
    const index = this.wordArr.findIndex(word => word.wordCard.word.name === nextword.word.name)
    if (index !== -1) {
      this.wordArr.splice(index, 1)
    }
    this.wordArr.push({ wordCard: nextword, log: null })
  }
}