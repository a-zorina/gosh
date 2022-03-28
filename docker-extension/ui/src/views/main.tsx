import React, { useRef, useEffect } from "react";
import { Container, Row, Col } from "react-bootstrap";
import { MetaDecorator, Table } from "../components";

import {
  DataColumn,
  Image as ImageType,
  Container as ContainerType
} from "../interfaces";

const Main:React.FunctionComponent<{}> = () => {
  const columns: Array<DataColumn<ContainerType>> = React.useMemo(
    () => [
      {
        Header: "",
        accessor: "validated",
        maxWidth: 30,
        minWidth: 30,
        width: 30,
      },
      {
        Header: "Container hash",
        accessor: "containerHash",
        maxWidth: 400,
        minWidth: 150,
        width: 200,
      },
      {
        Header: "Container name",
        accessor: "containerName",
        maxWidth: 400,
        minWidth: 165,
        width: 200,
      },
      {
        Header: "Image hash",
        accessor: "imageHash",
        maxWidth: 400,
        minWidth: 165,
        width: 200,
      },
      {
        Header: "Build provider",
        accessor: "buildProvider",
        maxWidth: 400,
        minWidth: 165,
        width: 200,
      },
    ],
    []
  );

  const columnsImage: Array<DataColumn<ImageType>> = React.useMemo(
    () => [
      {
        Header: "",
        accessor: "validated",
        maxWidth: 30,
        minWidth: 30,
        width: 30,
      },
      {
        Header: "Image hash",
        accessor: "imageHash",
        maxWidth: 400,
        minWidth: 165,
        width: 200,
      },
      {
        Header: "Build provider",
        accessor: "buildProvider",
        maxWidth: 400,
        minWidth: 165,
        width: 200,
      },
    ],
    []
  );

//  const containers = await window.ddClient.docker.listContainers();
//  console.log("containers: ${JSON.stringify(containers)}");

  const data = React.useMemo(() => ([{
    validated: false,
    containerHash: 78165381872341234,
    containerName: "nginx-main",
    imageHash: 1948731,
    buildProvider: 239182,
  }]), undefined);

  const dataImage = React.useMemo(() => ([{
    validated: false,
    imageHash: 17862459821341,
    buildProvider: 78165381872341234,
  }]), undefined);

  return (
    <>
    <MetaDecorator
      title="Fast payments and Ever for you · Payments Surf"
      description="Payments framework built on low-fees Everscale blockchain"
      keywords="ever, surf, payments, everscale, swap, trade, dex, exchange, buy, sell, forward, crypto, pamp, nft, checkout"
    />
    <Container fluid className="content-container">
      <Row>
        <Col md={12} lg={12}>
          <Table<ContainerType> columns={columns} data={data} />

          <Table<ImageType> columns={columnsImage} data={dataImage} />
        </Col>
      </Row>
    </Container>
    </>
  );
};


export default Main;
