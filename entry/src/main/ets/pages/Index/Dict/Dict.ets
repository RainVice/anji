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
      List() {
        ForEach(this.tags, (tag: string, index: number) => {
          ListItemGroup({
            header: this.listHeader(tag, index)
          }) {
            ForEach(dictionaryResources.filter(res => res.tags.includes(tag)), (item: DictInfo, index: number) => {
              ListItem() {
                // todo 优化列表
                Text(item.name)
              }
            })
          }
        })
      }
      .padding({ left: 10, right: 10 })
      .width(FULL_PERCENTAGE)
      .height(FULL_PERCENTAGE)
    }
  }

  @Builder
  listHeader(title: string, index: number) {
    Text(title)
  }

  @Builder
  categoryTab(title: string, index: number) {
    Text(title)
      .fontSize(this.categoryIndex === index ? 20 : 16).fontWeight(FontWeight.Bold)
      .fontColor(this.categoryIndex === index ? $r('app.color.primary') : $r('app.color.idle'))
      .margin(10)
  }
}