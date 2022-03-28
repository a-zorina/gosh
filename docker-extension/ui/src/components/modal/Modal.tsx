import { FunctionComponent, ReactNode } from "react";
import { Modal as ModalBootstrap } from "react-bootstrap";

import styles from "./Modal.module.scss";
import classnames from "classnames/bind";

const cn = classnames.bind(styles);

interface ModalProps {
  show: boolean,
  onHide: () => void,
  size?: "sm" | "lg" | "xl" | "fullscreen" | undefined,
  className?: string,
  header?: ReactNode,
  body?: ReactNode,
  footer?: ReactNode,
  [key: string]: any
}

export const Modal: FunctionComponent<ModalProps> = ({
  show,
  onHide,
  size,
  className,
  header,
  body,
  footer,
  ...props
}) => {
  return (
    <ModalBootstrap
      show={show}
      onHide={onHide}
      fullscreen={true}
      className={className}
      {...props} >
      {header && <ModalBootstrap.Header closeButton>
        <ModalBootstrap.Title>{header}</ModalBootstrap.Title>
      </ModalBootstrap.Header>}
      <ModalBootstrap.Body>
        {body}
      </ModalBootstrap.Body>
      {footer && <ModalBootstrap.Footer>
        {footer}
      </ModalBootstrap.Footer>}
    </ModalBootstrap>
  );
};

export const Overlay: FunctionComponent<ModalProps> = ({
  show,
  onHide,
  size,
  className,
  header,
  body,
  footer,
  ...props
}) => {
  return (
    <Modal
      show={show}
      onHide={onHide}
      fullscreen={true}
      className={cn("modal-overlay",className)}
      header={header}
      body={body}
      footer={footer}
      {...props} 
    />
  );
};


export default Modal;
