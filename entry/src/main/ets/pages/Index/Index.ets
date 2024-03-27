import { FULL_PERCENTAGE } from '../../constants';
import { TabBarInfo, tabBarInfos } from '../../model';
import { Dict } from './Dict/Dict';
import { Review } from './Review/Review';

@Entry
@Component
struct Index {

  /**
   * 当前 tab 索引
   */
  @State tabsIndex:number = 0;

  build() {
    // Tab 栏
    Tabs() {
      ForEach(tabBarInfos,(item:TabBarInfo,index: number) => {
        TabContent() {
          if (item.id === 0) Review()
          if (item.id === 1) Dict()

        }
        .tabBar(this.tabMenu(item))
      })
    }
    .onChange((index) => {
      this.tabsIndex = index
    })
    .barPosition(BarPosition.End)
    .width(FULL_PERCENTAGE)
    .height(FULL_PERCENTAGE)
    .backgroundColor("#ffe7f5dc")
  }

  /**
   * 菜单栏
   * @param tabBarInfo
   */
  @Builder
  tabMenu(tabBarInfo: TabBarInfo) {
    Column(){
      Image(tabBarInfo.image).width(30).height(30)
      if (this.tabsIndex === tabBarInfo.id){
        Text(tabBarInfo.title).width(FULL_PERCENTAGE).textAlign(TextAlign.Center)
      }
    }
  }
}