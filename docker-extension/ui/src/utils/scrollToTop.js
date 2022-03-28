import { useEffect, useRef } from 'react';
import { withRouter } from 'react-router-dom';

function ScrollToTop({ history, location }) {
  
  const prevLocation = useRef('');

  useEffect(() => {
    if (prevLocation.current !== location.pathname) {
      window.scrollTo(0, 0);
    }
  });

  useEffect(() => {
    prevLocation.current = location.pathname;
  }, [location.pathname]);

  return (null);
}

export default withRouter(ScrollToTop);