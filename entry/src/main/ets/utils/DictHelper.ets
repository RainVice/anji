import { Context } from '@kit.AbilityKit'
import { DaoMaster, Database, OpenHelper, BaseDao, GlobalContext, Property, inquiry } from '@ohos/dataorm';
import { createEmptyCard } from '../fsrs';
import { DictItem, WordCard, WordContent } from '../model';
import { preferences } from '@kit.ArkData';


export const currentDict = "currentDict"

const dbName = 'dict.db'
const preferencesName = "Dict"


export class DictHelper extends OpenHelper {
  constructor(context: Context, name: string) {
    super(context, name);
  }

  async onUpgradeDatabase(_db: Database, _oldVersion: number, _newVersion: number): Promise<void> {

  }

  async onCreateDatabase(db: Database): Promise<void> {
    super.onCreateDatabase(db)
  }

  private static context: Context
  private static pre: preferences.Preferences
  private static dao: BaseDao<DictItem, void>

  /**
   * 初始化
   * @param context
   */
  static async init(context: Context) {
    // 保存 context
    DictHelper.context = context;
    // 初始化 hepler
    const dictHelper = new DictHelper(context, dbName)
    dictHelper.setEncrypt(false);
    dictHelper.setEntities(DictItem)
    const db = await dictHelper.getWritableDb()
    const session = new DaoMaster(db).newSession()
    DictHelper.dao = session.getBaseDao(DictItem)
    // 初始化首选项
    DictHelper.pre = await preferences.getPreferences(context, preferencesName)

  }

  /**
   * 添加词典
   * @param wordContents 词典中的单词数组
   */
  static async addDict(id: string, wordContents: WordContent[]) {

    // 检查数据库中有没有数据
    const properties = DictHelper.getProperty()
    const list = await DictHelper.dao.queryBuilder().where(properties.id.eq(id)).list()
    if (list.length === 0) {
      // 修改数据，保存到数据库
      const _dictItem: DictItem[] = wordContents.map((word) => {
        return DictItem.createDictItem({
          id: id,
          word: word,
          card: createEmptyCard(new Date(0))
        })
      })
      await DictHelper.dao.insertOrReplaceInTxArrAsync(_dictItem)
    }
    // 修改当前词典
    await DictHelper.setCurrentDict(id);
  }

  /**
   * 设置当前词典
   * @param id
   */
  private static async setCurrentDict(id: string) {
    // 先保存到本地
    await DictHelper.pre.put(currentDict, id)
    await DictHelper.pre.flush()
    // 再更新运行状态的
    AppStorage.setOrCreate<string>(currentDict, id)
  }

  /**
   * 获取当前词典
   * @returns
   */
  static getCurrentDict() {
    return DictHelper.pre.getSync(currentDict, "") as string
  }


  static async getNextWord() : Promise<WordCard>{

    const property = DictHelper.getProperty()
    const now = new Date()
    const taday = new Date(now.toLocaleDateString())
    const tomorrow = new Date(taday.getTime() + 24 * 60 * 60 * 1000)

    // 先获取需要复习的单词
    let words = await DictHelper.dao.queryBuilder()
      .where(
        property.id.eq(DictHelper.getCurrentDict()),
        [
          property.due.between(taday.toLocaleString(), tomorrow.toLocaleString()),
          property.last_review.lt(new Date(now.getTime() - 60 * 1000).toLocaleString()),
        ]
      )
      .orderAsc(property.due)
      .limit(1)
      .list()
    if (words.length === 1) {
      return words[0].getWordCard()
    }
    // 没有再获取需要学习的单词
    words = await DictHelper.dao.queryBuilder()
      .where(property.id.eq(DictHelper.getCurrentDict()))
      .orderAsc(property.due)
      .limit(1)
      .list()
    return words[0].getWordCard()
  }

  /**
   * 获取属性名
   * @returns
   */
  private static getProperty() {
    let entityClass = GlobalContext.getContext().getValue(GlobalContext.KEY_CLS) as Record<string, Object>;
    return entityClass.DictItem as Record<string, Property>;
  }
}