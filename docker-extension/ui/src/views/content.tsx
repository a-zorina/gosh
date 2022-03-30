import { FunctionComponent, useState, useEffect, useRef } from "react";
import { Container, Row, Col } from "react-bootstrap";
import { useParams, useLocation } from "react-router-dom";
import ReactMarkdown from 'react-markdown';
import rehypeRaw from 'rehype-raw';
import 'bootstrap/js/dist/collapse.js'

const Content: FunctionComponent<{title?: string, path?: string}> = ({title, path}) => {
  
  const { id } = useParams<{id: string}>();
  const location = useLocation();
  const ref = useRef<HTMLElement>() as React.MutableRefObject<HTMLElement>;
  const [content, setContent] = useState<any>(null);

  useEffect(() => {
    setContent('');
    const filepath = path ? path : id;
    async function getContent () {
      const file = await import(`../content/${filepath}.md`);
      const response = await fetch(file.default);
      const markdown = await response.text();
      await setContent(markdown);
    }
    getContent();
  }, [id, path]);

  useEffect(() => {
    if (location.hash && ref && ref.current && content) ref.current.querySelector(location.hash)!.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }, [content, location.hash]);

  if (content === null ) return (<></>);

  return (
    <Container fluid="lg">
      <Row>
        <Col lg={{ span: 10, offset: 1 }}>
          <section className="content-wrapper" ref={ref}>
            <ReactMarkdown rehypePlugins={[rehypeRaw]}>{content}</ReactMarkdown>
          </section>
        </Col>
      </Row>
    </Container>
  );
};

export default Content;
