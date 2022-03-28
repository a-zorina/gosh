export type accountStatus = 0 | 1 | 2;

export type address = string;

export type id = string;

export type DataRow = {
  validated: boolean
  containerHash: number
  containerName: string
  imageHash: number
  buildProvider: number
}

export type DataColumn<T> = {
  Header: string
  accessor: keyof T
  [key: string]: any
}

export type Image = {
  validated: boolean
  imageHash: number
  buildProvider: number
}

export type Container = Image & {
  containerHash: number
  containerName: string
}