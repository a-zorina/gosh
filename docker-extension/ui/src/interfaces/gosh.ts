export type accountStatus = 0 | 1 | 2;

export type address = string;

export type id = string;

export type DataRow = {
  validated: boolean
  containerHash: string
  containerName: string
  imageHash: string
  buildProvider: string
}

export type DataColumn<T> = {
  Header: string
  accessor: keyof T
  [key: string]: any
}

export type Image = {
  validated: boolean
  imageHash: string
  buildProvider: string
}

export type Container = Image & {
  containerHash: string
  containerName: string
}
