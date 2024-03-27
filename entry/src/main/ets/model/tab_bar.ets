/**
 * Tab 菜单模型
 */

export interface TabBarInfo{
  id: number
  title: ResourceStr
  image: ResourceStr
}


export const tabBarInfos: TabBarInfo[] = [
  {
    id: 0,
    title: $r('app.string.review'),
    image: $r("app.media.review")
  },
  {
    id: 1,
    title: $r('app.string.dicts'),
    image: $r("app.media.dicts")
  },
  {
    id: 2,
    title: $r('app.string.statistics'),
    image: $r("app.media.statistics")
  },
]
