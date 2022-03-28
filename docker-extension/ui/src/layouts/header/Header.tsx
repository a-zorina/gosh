import { useState, useEffect } from "react";
import { Navbar, Nav } from "react-bootstrap";
import { ReactComponent as Logo } from "../../assets/images/logo.svg";
import { Link } from "react-router-dom";
import styles from "./Header.module.scss";
import classnames from "classnames/bind";

const cn = classnames.bind(styles);

export const Header = ({location, ...props}: {location: string}) => {
  return (<>
    <header className={cn("header")}>
      <Navbar
        expand="sm"
        className={cn("navbar")}
      >
        <Nav className={cn("navbar-nav", "me-auto")}>
          <Navbar.Brand className={cn("navbar-brand")}><Link to="/" className="logo"><Logo/></Link></Navbar.Brand>
        </Nav>
      </Navbar>
    </header>
    </>
  );
};

export default Header;
