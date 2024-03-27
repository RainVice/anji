import { FULL_PERCENTAGE } from '../../../constants'
import { DictInfo, dictionaryResources } from '../../../model'
import { LoadingDialog } from '@kit.ArkUI'
import { resourceManager } from '@kit.LocalizationKit'
import { buffer, util } from '@kit.ArkTS'

@Component
export struct Dict {
  @State @Watch('getTags') categoryIndex: number = 0
  @State tags: string[] = []
  category: string[] = []

  dialogControllerProgress: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({content: $r('app.string.swith_dict')}),
    autoCancel: false,
    // customStyle: true,
    alignment: DialogAlignment.Center
  })


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

  /**
   * 选择词典
   * @param dictInfo
   */
  selectDict(dictInfo: DictInfo){
    this.dialogControllerProgress.open()

    const dataArr = getContext(this).resourceManager.getRawFileContentSync(dictInfo.url)
    const content = util.TextDecoder.create('utf-8').decodeWithStream(dataArr)

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


      // 内容
      Scroll(){
        Column(){
          ForEach(this.tags, (tag: string, index: number) => {
            this.content(tag)
          })
        }
      }
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .margin(10)
      .layoutWeight(1)
    }
  }

  @Builder
  content(title:string){
    Column(){
      Text(title)
        .margin({ top : 15,bottom : 10})
        .fontColor($r('app.color.idle'))
        .fontSize(12)
       GridRow({
         gutter: { x: 10, y: 10 },
         columns: {
           xs: 4,
           md: 8,
           lg: 12
         }
       }){
         ForEach(dictionaryResources.filter(res => res.tags.includes(title)), (item: DictInfo, index: number) => {
           GridCol({
             span: {xs: 4,md: 4, lg: 4},
             // offset: {xs: 0,md: 1,lg: 0}
           }){
             this.bookCard(item)
           }
         })
       }
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
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .maxLines(1)
          .fontColor($r('app.color.white'))
          .fontWeight(FontWeight.Bold)
        Text(dictInfo.description)
          .width(FULL_PERCENTAGE)
          .fontColor($r('app.color.white'))
          .textOverflow({overflow: TextOverflow.Ellipsis})
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
      this.selectDict(dictInfo)
    })
  }
}