import { FULL_PERCENTAGE } from '../../../constants'
import { WordContent, DictInfo, dictionaryResources } from '../../../model'
import { LoadingDialog, router } from '@kit.ArkUI'
import { util } from '@kit.ArkTS'
import { DictHelper } from '../../../utils'

@Component
export struct Dict {
  @State private categoryIndex: number = 0

  build() {
    Column() {
      Tabs() {
        // 标题栏
        ForEach(Array.from(new Set(dictionaryResources.map((res => res.category)))), (item: string, index: number) => {
          TabContent() {
            Column() {
              // 内容
              Scroll() {
                Column({ space: 10 }) {
                  ForEach(Array.from(new Set(dictionaryResources.filter(res => res.category === item)
                    .flatMap(res => res.tags))), (tag: string) => {
                    this.content(tag)
                  })
                }
              }
              .align(Alignment.Top)
              .scrollBar(BarState.Off)
              .margin(5)
              .layoutWeight(1)
            }
          }.tabBar(this.categoryTab(item, index))
        })
      }
      .scrollable(false)
      .onChange(index => this.categoryIndex = index)
      .barMode(BarMode.Scrollable)
      .width(FULL_PERCENTAGE)
    }
  }

  @Builder
  content(title: string) {
    Column() {
      Text(title)
        .margin({ bottom: 10 })
        .fontColor($r('app.color.idle'))
        .fontSize(12)
      GridRow({
        gutter: { x: 10, y: 10 },
        columns: {
          xs: 4,
          md: 8,
          lg: 12
        }
      }) {
        ForEach(dictionaryResources.filter(res => res.tags.includes(title)), (item: DictInfo) => {
          GridCol({
            span: { xs: 4, md: 4, lg: 4 },
            // offset: {xs: 0,md: 1,lg: 0}
          }) {
            this.bookCard(item)
          }
        })
      }
    }
  }

  @Builder
  categoryTab(title: string, index: number) {
    Text(title)
      .fontSize(this.categoryIndex === index ? 20 : 16).fontWeight(FontWeight.Bold)
      .fontColor(this.categoryIndex === index ? $r('app.color.primary') : $r('app.color.idle'))
      .margin(10)
  }

  @Builder
  bookCard(dictInfo: DictInfo) {
    Column({ space: 10 }) {
      Text(dictInfo.name)
        .width(FULL_PERCENTAGE)
        .fontSize(18)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontColor($r('app.color.white'))
        .fontWeight(FontWeight.Bold)
      Text(dictInfo.description)
        .width(FULL_PERCENTAGE)
        .fontColor($r('app.color.white'))
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize(12)
        .maxLines(1)
      Text(`${dictInfo.length}词`)
        .fontColor($r('app.color.white'))
        .width(FULL_PERCENTAGE)
        .fontWeight(FontWeight.Bold)
    }
    .padding(15)
    .width(FULL_PERCENTAGE)
    .borderRadius(10)
    // 修改配色
    .backgroundColor($r('app.color.card_background'))
    // .border({ width: 1, color: '#000' })
    .onClick(() => {
      router.pushUrl({
        url: "pages/DictDetail/DictDetail",
        params: dictInfo
      })
      // this.selectDict(dictInfo)
    })
  }
}