export class ListAdapter<T> implements IDataSource{
  private list: T[] = []
  constructor(list: T[]){
    this.list = list;
  }

  totalCount(): number {
    return this.list.length
  }

  getData(index: number): T {
    return this.list[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {

  }

  unregisterDataChangeListener(listener: DataChangeListener): void {

  }
}

