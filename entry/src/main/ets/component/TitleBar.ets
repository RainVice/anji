/**
 * 二级页面标题栏
 */
import { router } from '@kit.ArkUI'
import { FULL_PERCENTAGE } from '../constants'

@Preview
@Component
export struct TitleBar {

  @BuilderParam menus: () => void

  build() {
    Row() {
      Row(){
        Image($r("app.media.ic_back"))
          .rotate({angle: 180})
          .height(20)
          .width(20)
        Text("返回").fontSize(12).fontWeight(FontWeight.Bold)
      }.onClick(() => router.back())
      Blank()
      this.menus()
    }
    .width(FULL_PERCENTAGE)
    .padding(15)
  }
}