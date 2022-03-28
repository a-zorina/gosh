export type accountStatus = 0 | 1 | 2;

export type address = string;

export type id = string;

export type status = "success" | "warning" | "error" | "loading";

export type DataColumn<T> = {
  Header: string
  accessor: keyof T
  [key: string]: any
}

export type Image = {
  validated: status
  imageHash: number
  buildProvider: string
}

export type Container = Image & {
  containerHash: number
  containerName: string
}
