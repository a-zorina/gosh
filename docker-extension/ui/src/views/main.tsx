import React, { useState, useEffect } from "react";
import { Container, Row, Col } from "react-bootstrap";
import { MetaDecorator, Table, Button, Overlay, Icon } from "../components";

import { DockerClient } from "../client";

import Content from "./content";

import {
  DataColumn,
  Image as ImageType,
  Container as ContainerType
} from "../interfaces";

const Help:React.FunctionComponent<{
  showModal: boolean,
  handleClose: any,
}> = ({showModal, handleClose}) => {
  return (
    <Overlay
      show={showModal}
      onHide={handleClose}
      fullscreen={true}
      body={<><Content title="Help" path="help" /><Button onClick={handleClose} className="close-button" variant="transparent"><Icon icon="close"/></Button></>}
    />
  )
};

const Main:React.FunctionComponent<{}> = () => {
  const [containers, setContainers] = useState<Array<ContainerType>>([]);
  const [images, setImages] = useState<Array<ImageType>>([]);
  const [showModal, setShowModal] = useState<boolean>(false);

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

  const handleClick = () => {
    DockerClient.getContainers()
    .then((value) => {
      console.log(value);
      setContainers(value || []);
      //do stuff
    });
  }
  const handleClose = () => setShowModal(false);
  const handleShow = () => setShowModal(true);


  return (
    <>
    <MetaDecorator
      title="Gosh Docker Extension"
      description="Git On-chain Source Holder Docker extension for Secure Software Supply BlockChain"
      keywords="docker, gosh, extension, sssb, sssp"
    />
    <div className="button-block">

      <Button
        variant="transparent"
        // icon={<Icon icon={"arrow-up-right"}/>}
        // iconAnimation="right"
        // iconPosition="after"
        onClick={handleShow}
      >Help <></></Button>
      <Button
        variant="primary"
        onClick={handleClick}
      >Update data</Button>
    </div>
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
      <Help
        showModal={showModal}
        handleClose={handleClose}
      />
    </>
  );
};


export default Main;
