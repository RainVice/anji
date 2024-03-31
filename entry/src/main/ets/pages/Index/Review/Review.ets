/**
 * 复习界面组件
 */
import { FULL_PERCENTAGE } from '../../../constants'
import { WordCard } from '../../../model'
import { currentDict, DictHelper } from '../../../utils'

@Component
export struct Review {
  @StorageProp(currentDict) @Watch("initDict") dict: string = ""
  @State wordArr: WordCard[] = []

  aboutToAppear(): void {
    // 初始化单词列表
    this.initDict()
  }

  build() {
    Column() {
      // todo 标题栏
      Row() {

      }.height(56).width(FULL_PERCENTAGE)

      if (this.wordArr.length > 0) {
        Column({ space: 5 }) {

          if (this.wordArr[this.wordArr.length - 1]) {
            // 单词
            Text(this.wordArr[this.wordArr.length - 1].word.name)
              .fontSize(40)
              .fontWeight(FontWeight.Bold)
            // 音标
            Row({ space: 5 }) {
              if (this.wordArr[this.wordArr.length - 1].word.usphone) {
                Row({ space: 2 }) {
                  Text("us")
                    .fontSize(10)
                    .fontColor($r('app.color.white'))
                    .padding(2)
                    .textAlign(TextAlign.Center)
                    .fontWeight(FontWeight.Bold)
                    .backgroundColor($r('app.color.black'))
                    .borderRadius(5)
                  Text(this.wordArr[this.wordArr.length - 1].word.usphone)
                }
              }
              if (this.wordArr[this.wordArr.length - 1].word.ukphone) {
                Row({ space: 2 }) {
                  Text("uk")
                    .fontSize(10)
                    .fontColor($r('app.color.white'))
                    .padding(2)
                    .textAlign(TextAlign.Center)
                    .fontWeight(FontWeight.Bold)
                    .backgroundColor($r('app.color.black'))
                    .borderRadius(5)
                  Text(this.wordArr[this.wordArr.length - 1].word.ukphone)
                }
              }
              if (this.wordArr[this.wordArr.length - 1].word.notation) {
                Row({ space: 2 }) {
                  Text("no")
                    .fontSize(10)
                    .fontColor($r('app.color.white'))
                    .padding(2)
                    .textAlign(TextAlign.Center)
                    .fontWeight(FontWeight.Bold)
                    .backgroundColor($r('app.color.black'))
                    .borderRadius(5)
                  Text(this.wordArr[this.wordArr.length - 1].word.notation)
                }
              }
            }
            // 翻译
            Text(JSON.stringify(this.wordArr[this.wordArr.length - 1].word.trans)).textAlign(TextAlign.Center)
              .margin({
                left : 20,
                right : 20
              })
          }
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)

        Row({ space: 5 }) {
          Text($r('app.string.again'))
            .backgroundColor($r('app.color.again'))
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .height(FULL_PERCENTAGE)
            .borderRadius(15)
          Text($r('app.string.hard'))
            .backgroundColor($r('app.color.hard'))
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .height(FULL_PERCENTAGE)
            .borderRadius(15)
          Text($r('app.string.good'))
            .backgroundColor($r('app.color.good'))
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .height(FULL_PERCENTAGE)
            .borderRadius(15)
          Text($r('app.string.easy'))
            .backgroundColor($r('app.color.easy'))
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .height(FULL_PERCENTAGE)
            .borderRadius(15)
        }.height(50)
        .margin(10)

      } else {
        Text($r("app.string.select_dict_tip"))
          .fontSize(35)
          .fontWeight(FontWeight.Bold)
      }

    }
  }

  /**
   * 初始化单词列表
   */
  async initDict() {
    if (!this.dict) return
    this.wordArr = []
    const nextword =  await DictHelper.getNextWord()
    this.wordArr.push(nextword)
  }
}