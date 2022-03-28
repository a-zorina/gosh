#!/usr/bin/env python3
"""
Very simple HTTP server in python for logging requests
Usage::
    ./server.py [<port>]
"""
from http.server import BaseHTTPRequestHandler, HTTPServer
import logging
from urllib import parse

class S(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        logging.info(str(parse.parse_qs(parse.urlsplit(self.path).query).get('log', [None])[0]))
        self._set_response()
        self.wfile.write(b'')

    def log_message(self, *args):
        pass


def run(port=8888):
    logging.basicConfig(level=logging.INFO)
    server_address = ('', port)
    httpd = HTTPServer(server_address, S)
    logging.info('Starting httpd...\n')
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    logging.info('Stopping httpd...\n')

if __name__ == '__main__':
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()
