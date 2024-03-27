/**
 * 复习界面组件
 */
import { FULL_PERCENTAGE } from '../../../constants'

@Component
export struct Review {
  build() {
    Column() {

      Column({ space: 5 }) {
        // 单词
        Text("cancel")
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
        // 音标
        Row({ space: 5 }) {
          Row({ space: 2 }) {
            Text("us")
              .fontSize(10)
              .fontColor($r('app.color.white'))
              .padding(2)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)
              .backgroundColor($r('app.color.black'))
              .borderRadius(5)
            Text("kænsl")
          }

          Row({ space: 2 }) {
            Text("us")
              .fontSize(10)
              .fontColor($r('app.color.white'))
              .padding(2)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)
              .backgroundColor($r('app.color.black'))
              .borderRadius(5)
            Text("kænsl")
          }
        }

        // 翻译
        Text("取消， 撤销； 删去").textAlign(TextAlign.Center)
      }.layoutWeight(1)
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
    }

  }
}