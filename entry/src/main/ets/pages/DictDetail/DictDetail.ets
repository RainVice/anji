import { LoadingDialog, router } from '@kit.ArkUI'
import { util } from '@kit.ArkTS'
import { DictHelper, ListAdapter } from '../../utils'
import { DictInfo, WordContent } from '../../model'
import { TitleBar } from '../../component'
import { FULL_PERCENTAGE } from '../../constants'

@Entry
@Component
struct DictDetail {
  dictInfo: DictInfo = router.getParams() as DictInfo
  @State dictJson: WordContent[] = []
  @State currentIndex: number = -1;

  aboutToAppear(): void {
    this.initDict()
  }

  private dialogControllerProgress: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ content: $r('app.string.swith_dict') }),
    autoCancel: false,
    // customStyle: true,
    alignment: DialogAlignment.Center
  })

  build() {
    Column() {
      TitleBar() {
        Text($r('app.string.select_dict')).fontSize(12).fontColor($r('app.color.primary'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.selectDict()
          })
      }

      Column() {
        List({space: 10}) {
          LazyForEach(new ListAdapter<WordContent>(this.dictJson), (word: WordContent, index: number) => {
            ListItem() {
              Column({space: 5}){
                Text(word.name)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(index === this.currentIndex ? $r('app.color.primary') : $r('app.color.black'))
                if (index === this.currentIndex) {
                  // 翻译
                  Column({space : 5}){
                    ForEach(word.trans,(tran: string) => {
                      Text(tran)
                        .fontSize(13)
                        .width(FULL_PERCENTAGE)
                        .textAlign(TextAlign.Start)
                        .maxLines(1)
                        .textOverflow({overflow: TextOverflow.Ellipsis})
                    })

                  }
                }
              }
              .width(FULL_PERCENTAGE)
              .alignItems(HorizontalAlign.Start)
              .padding({top: 10,bottom : 10})
              .onClick(() => {
                this.currentIndex = index
              })
            }
          })
        }.width(FULL_PERCENTAGE)
        .divider({
          strokeWidth : 2,
        })
      }
      .layoutWeight(1)
      .padding({
        left : 20,right : 20
      })

    }
    .backgroundColor($r('app.color.background'))
  }

  /**
   * 初始化词典
   */
  async initDict() {
    const dataArr = getContext(this).resourceManager.getRawFileContentSync(this.dictInfo.url)
    const content = util.TextDecoder.create('utf-8').decodeWithStream(dataArr)
    this.dictJson = JSON.parse(content) as WordContent[]
  }

  /**
   * 选择词典
   * @param dictInfo
   */
  async selectDict() {
    this.dialogControllerProgress.open()
    await DictHelper.addDict(this.dictInfo.id, this.dictJson)
    this.dialogControllerProgress.close()
    router.back()
  }
}