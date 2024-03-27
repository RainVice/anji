import { FULL_PERCENTAGE } from '../../../constants'
import { DictInfo, dictionaryResources } from '../../../model'

@Component
export struct Dict {
  @State @Watch('getTags') categoryIndex: number = 0
  @State tags: string[] = []
  category: string[] = []

  aboutToAppear(): void {
    this.getCategory()
    this.getTags()

  }

  getCategory() {
    this.category = Array.from(new Set(dictionaryResources.map((res => res.category))))
  }

  // 获取 tags
  getTags() {
    this.tags = Array.from(new Set(dictionaryResources.filter(res => res.category === this.category[this.categoryIndex])
      .flatMap(res => res.tags)))
  }

  build() {
    Column() {
      // 标题栏
      Tabs() {
        ForEach(this.category, (item: string, index: number) => {
          TabContent().tabBar(this.categoryTab(item, index))
        })
      }
      .height(56)
      .onChange(index => this.categoryIndex = index)
      .barMode(BarMode.Scrollable)
      .width(FULL_PERCENTAGE)

      // .backgroundColor(Color.Black)

      // 内容
      List({space : 10}) {
        ForEach(this.tags, (tag: string, index: number) => {
          ListItemGroup({
            header: this.listHeader(tag, index),
            space: 10
          }) {
            ForEach(dictionaryResources.filter(res => res.tags.includes(tag)), (item: DictInfo, index: number) => {
              ListItem() {
                this.bookCard(item)
              }
            })
          }
        })
      }
      .padding({ left: 10, right: 10 })
      .width(FULL_PERCENTAGE)
      .layoutWeight(1)
    }
  }

  @Builder
  listHeader(title: string, index: number) {
    Text(title)
      .margin({ top : 15,bottom : 10})
      .fontColor($r('app.color.idle'))
      .fontSize(12)
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
    Column({space : 10}) {
      Text(dictInfo.name)
        .width(FULL_PERCENTAGE)
        .fontSize(18)
        .maxLines(1)
        .fontColor($r('app.color.white'))
        .fontWeight(FontWeight.Bold)
      Text(dictInfo.description)
        .width(FULL_PERCENTAGE)
        .fontColor($r('app.color.white'))
        .fontSize(12)
      Text(`${dictInfo.length}词`)
        .fontColor($r('app.color.white'))
        .width(FULL_PERCENTAGE)
        .fontWeight(FontWeight.Bold)
    }
    .padding(15)
    .width(FULL_PERCENTAGE)
    .borderRadius(10)
    // 修改配色
    .backgroundColor("#818cf8")
    // .border({ width: 1, color: '#000' })
  }
}