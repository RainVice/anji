import { Columns, ColumnType, Entity } from '@ohos/dataorm'
import { RecordLogItem, State, Rating, Card } from '../fsrs'

export interface WordContent {
  name: string
  trans: string[]
  usphone: string
  ukphone: string
  notation: string
}

export interface WordCard {
  id: string
  word: WordContent
  card: Card
}


@Entity('dict')
export class DictItem {
  @Columns({ columnName: 'id', types: ColumnType.str })
  id: string;
  @Columns({ columnName: 'name', types: ColumnType.str })
  name: string
  @Columns({ columnName: 'trans', types: ColumnType.str })
  trans: string
  @Columns({ columnName: 'usphone', types: ColumnType.str })
  usphone: string
  @Columns({ columnName: 'ukphone', types: ColumnType.str })
  ukphone: string
  @Columns({ columnName: 'notation', types: ColumnType.str })
  notation: string
  @Columns({ columnName: 'due', types: ColumnType.str })
  due: string; // 卡片下次复习的日期
  @Columns({ columnName: 'stability', types: ColumnType.real })
  stability: number; // 记忆稳定性
  @Columns({ columnName: 'difficulty', types: ColumnType.real })
  difficulty: number; // 卡片难度
  @Columns({ columnName: 'elapsed_days', types: ColumnType.num })
  elapsed_days: number; // 自上次复习以来的天数
  @Columns({ columnName: 'scheduled_days', types: ColumnType.num })
  scheduled_days: number; // 下次复习的间隔天数
  @Columns({ columnName: 'reps', types: ColumnType.num })
  reps: number; // 卡片被复习的总次数
  @Columns({ columnName: 'lapses', types: ColumnType.num })
  lapses: number; // 卡片被遗忘或错误记忆的次数
  @Columns({ columnName: 'state', types: ColumnType.num })
  state: State; // 卡片的当前状态（新卡片、学习中、复习中、重新学习中）
  @Columns({ columnName: 'last_review', types: ColumnType.str })
  last_review: string | null; // 最近的复习日期（如果适用）


  getWordCard(){
    const word: WordContent = {
      name : this.name,
      trans: JSON.parse(this.trans) as string[],
      usphone: this.usphone,
      ukphone: this.ukphone,
      notation: this.notation
    }
    const card: Card = {
      due: new Date(this.due),
      stability: this.stability,
      difficulty: this.difficulty,
      elapsed_days: this.elapsed_days,
      scheduled_days: this.scheduled_days,
      reps: this.reps,
      lapses: this.lapses,
      state: this.state,
      last_review: this.last_review ? new Date(this.last_review) : undefined
    }
    return {
      id: this.id,
      word: word,
      card: card
    } as WordCard
  }


  static createDictItem(wordCard: WordCard): DictItem {

    return new DictItem(
      wordCard.id,
      wordCard.word.name,
      JSON.stringify(wordCard.word.trans),
      wordCard.word.usphone,
      wordCard.word.ukphone,
      wordCard.word.notation,
      wordCard.card.due.toLocaleString(undefined,{hour12:false}).replace("24:00:00","00:00:00"),
      wordCard.card.stability,
      wordCard.card.difficulty,
      wordCard.card.elapsed_days,
      wordCard.card.scheduled_days,
      wordCard.card.reps,
      wordCard.card.lapses,
      wordCard.card.state,
      wordCard.card.last_review?.toLocaleString(undefined,{hour12:false}).replace("24:00:00","00:00:00") || null
    )

  }


  constructor(
    id: string,
    name: string,
    trans: string,
    usphone: string,
    ukphone: string,
    notation: string,
    due: string,
    stability: number,
    difficulty: number,
    elapsed_days: number,
    scheduled_days: number,
    reps: number,
    lapses: number,
    state: State,
    last_review: string | null,
  ) {
    this.id = id || "";
    this.name = name || "";
    this.trans = trans || "";
    this.usphone = usphone || "";
    this.ukphone = ukphone || "";
    this.notation = notation;
    this.due = due;
    this.stability = stability;
    this.difficulty = difficulty;
    this.elapsed_days = elapsed_days;
    this.scheduled_days = scheduled_days;
    this.reps = reps;
    this.lapses = lapses;
    this.state = state;
    this.last_review = last_review || "";
  }
}



