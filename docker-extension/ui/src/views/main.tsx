import React, { useState, useEffect } from "react";
import { Container, Row, Col } from "react-bootstrap";
import { MetaDecorator, Table, Button } from "../components";

import { DockerClient } from "../client" 

import {
  DataColumn,
  Image as ImageType,
  Container as ContainerType
} from "../interfaces";

const Main:React.FunctionComponent<{}> = () => {
  const [containers, setContainers] = useState<Array<ContainerType>>([]);
  const [images, setImages] = useState<Array<ImageType>>([]);

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
      {
        Header: "Gosh network root",
        accessor: "goshRootAddress",
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
      {
        Header: "Gosh network root",
        accessor: "goshRootAddress",
        maxWidth: 400,
        minWidth: 165,
        width: 200,
      },
    ],
    []
  );

  useEffect(() => {
    DockerClient.getContainers()
    .then((value) => {
      console.log(value);
      setContainers(value || []);
      //do stuff
    });

  }, []);

  useEffect(() => {
    DockerClient.getImages()
    .then((value) => {
      console.log(value);
      setImages(value || []);
      //do stuff
    });

  }, []);

  // const data = React.useMemo<Array<ContainerType>>(() => ([{
  //   validated: "loading",
  //   containerHash: 78165381872341234,
  //   containerName: "nginx-main",
  //   imageHash: 1948731,
  //   buildProvider: "239182",
  // }]), undefined);

  const handlClick = () => {
    DockerClient.getContainers()
    .then((value) => {
      console.log(value);
      setContainers(value || []);
      //do stuff
    });
    DockerClient.getImages()
    .then((value) => {
      console.log(value);
      setImages(value || []);
      //do stuff
    });
  };

  return (
    <>
    <MetaDecorator
      title="Gosh Docker Extension"
      description="Git On-chain Source Holder Docker extension for Secure Software Supply BlockChain"
      keywords="docker, gosh, extension, sssb, sssp"
    />
    <Button
      variant="primary"
      onClick={handlClick}
    >Update data</Button>
    <Container fluid>
      <Row>
        <Col md={12} lg={12}>
          <div className="content-container">
            <Table<ContainerType> columns={columns} data={containers} />

            <Table<ImageType> columns={columnsImage} data={images} />
          </div>
        </Col>
      </Row>
    </Container>
    </>
  );
};


export default Main;
