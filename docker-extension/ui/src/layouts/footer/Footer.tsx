import { FunctionComponent } from "react";
import { Container, Nav } from "react-bootstrap";
// import { Link } from "react-router-dom";
import styles from "./Footer.module.scss";

export const Footer: FunctionComponent<{}> = () => {
  return (
    <footer className={styles.footer}>
      <Container fluid className={styles.container}>
        <Nav as="ul" className={styles.nav}>
          {/* <Nav.Item as="li" className={styles['nav-item']}>
            <Link to="/legal-notes/surf-decentralization-policy" className={styles.dod}>Surf Decentralization Policy</Link>
          </Nav.Item> */}
          <Nav.Item as="li" className={`${styles['nav-item']} ${styles['copyright']} paragraph paragraph-small`}>
            {(new Date()).getFullYear().toString()} &copy; Gosh is a part of the <span><a href="https://everscale.network/ecosystem" target="_blank" rel="noopener noreferrer nofollow"><svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg"><path fillRule="evenodd" clipRule="evenodd" d="M13.7335 21.6944L21.0388 14.4437V0.805542H7.40062L0.149902 8.11665H13.7277L13.7335 21.6944Z" fill="#6347F5"/></svg>everscale</a> core ecosystem</span>
          </Nav.Item>
          <Nav.Item as="li" className={`paragraph paragraph-small ${styles['nav-item']}`}>
            <a href="mailto:welcome@ever.surf">welcome@gosh.io</a>
          </Nav.Item>
        </Nav>
      </Container>
    </footer>
  );
};

export default Footer;
