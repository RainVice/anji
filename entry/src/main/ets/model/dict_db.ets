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
      wordCard.card.due.toLocaleString(),
      wordCard.card.stability,
      wordCard.card.difficulty,
      wordCard.card.elapsed_days,
      wordCard.card.scheduled_days,
      wordCard.card.reps,
      wordCard.card.lapses,
      wordCard.card.state,
      wordCard.card.last_review?.toLocaleString() || null
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
/*
  // Getter and Setter for id
  public getId(): string {
    return this.id;
  }

  public setId(value: string): void {
    this.id = value;
  }

  // Getter and Setter for name
  public getName(): string {
    return this.name;
  }

  public setName(value: string): void {
    this.name = value;
  }

  // Getter and Setter for trans
  public getTrans(): string {
    return this.trans;
  }

  public setTrans(value: string): void {
    this.trans = value;
  }

  // Getter and Setter for usphone
  public getUsphone(): string {
    return this.usphone;
  }

  public setUsphone(value: string): void {
    this.usphone = value;
  }

  // Getter and Setter for ukphone
  public getUkphone(): string {
    return this.ukphone;
  }

  public setUkphone(value: string): void {
    this.ukphone = value;
  }

  // Getter and Setter for notation
  public getNotation(): string {
    return this.notation;
  }

  public setNotation(value: string): void {
    this.notation = value;
  }

  // Getter and Setter for due
  public getDue(): string {
    return this.due;
  }

  public setDue(value: string): void {
    this.due = value;
  }

  // Getter and Setter for stability
  public getStability(): number {
    return this.stability;
  }

  public setStability(value: number): void {
    this.stability = value;
  }

  // Getter and Setter for difficulty
  public getDifficulty(): number {
    return this.difficulty;
  }

  public setDifficulty(value: number): void {
    this.difficulty = value;
  }

  // Getter and Setter for elapsed_days
  public getElapsed_days(): number {
    return this.elapsed_days;
  }

  public setElapsed_days(value: number): void {
    this.elapsed_days = value;
  }

  // Getter and Setter for scheduled_days
  public getScheduled_days(): number {
    return this.scheduled_days;
  }

  public setScheduled_days(value: number): void {
    this.scheduled_days = value;
  }

  // Getter and Setter for reps
  public getReps(): number {
    return this.reps;
  }

  public setReps(value: number): void {
    this.reps = value;
  }

  // Getter and Setter for lapses
  public getLapses(): number {
    return this.lapses;
  }

  public setLapses(value: number): void {
    this.lapses = value;
  }

  // Getter and Setter for state
  public getState(): State {
    return this.state;
  }

  public setState(value: State): void {
    this.state = value;
  }

  // Getter and Setter for last_review
  public getLast_review(): string | null {
    return this.last_review;
  }

  public setLast_review(value: string | null): void {
    this.last_review = value;
  }*/
}



