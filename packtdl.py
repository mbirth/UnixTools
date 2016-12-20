#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Needs grab, pip3 install -U grab
# (also needs: libcurl4-*-dev for curl-config, libxslt1-dev and libxml2-dev)

import configparser
import logging
import selection
import sys
from argparse import ArgumentParser
from grab import Grab
from io import StringIO

config_str = '[DEFAULT]\n' + open(sys.path[0] + '/CONFIG', 'r').read()
config_fp  = StringIO(config_str)

c = configparser.RawConfigParser()
c.readfp(config_fp)

logging.basicConfig(level=logging.DEBUG)

class LoggedOutException(Exception):
    '''Raise when attempting an action needing login without being logged in.'''

class PacktBook():
    def __init__(self):
        self.title = ""
        self.isbn = ""
        self.nid = ""
        self.cover_img = ""
        self.dl_pdf = ""
        self.dl_epub = ""
        self.dl_mobi = ""
        self.dl_code = ""

    def __str__(self):
        output = "["
        output += "P" if self.dl_pdf else "-"
        output += "e" if self.dl_epub else "-"
        output += "K" if self.dl_mobi else "-"
        output += "Z" if self.dl_code else "-"
        output += "] {} ({})".format(self.title, self.isbn)
        return output

    def parse_from_xsel(self, book: selection.backend.XpathSelector):
        self.title = book.select("@title").text()
        self.nid = book.select("@nid").text()
        self.cover_img = book.select(".//img/@src").text().replace("imagecache/thumbview/", "")

        isbn = book.select(".//div/@isbn")
        if isbn:
            self.isbn = isbn.text()

        self.dl_pdf = book.select(".//a[div/@format='pdf']/@href").text()

        dl_epub = book.select(".//a[div/@format='epub']/@href")
        if dl_epub:
            self.dl_epub = dl_epub.text()

        dl_mobi = book.select(".//a[div/@format='mobi']/@href")
        if dl_mobi:
            self.dl_mobi = dl_mobi.text()

        dl_code = book.select(".//a[starts-with(@href, '/code_download')]/@href")
        if dl_code:
            self.dl_code = dl_code.text()


class PacktPub():
    def __init__(self):
        self.g = Grab()
        self.g.setup(follow_location=True)
        self.g.setup(follow_refresh=True)
        self.g.setup(timeout=120)
        self.g.setup(connect_timeout=10)
        #self.g.setup(body_maxsize=512000)
        self.logged_in = False

    def login(self, email, password):
        self.g.go('https://www.packtpub.com/')
        self.g.doc.save('/tmp/packtpub-home.html')
        self.g.doc.choose_form(id='packt-user-login-form')
        print("Logging in with account: {}".format(email))
        self.g.doc.set_input('email', email)
        self.g.doc.set_input('password', password)
        self.g.doc.submit()
        self.g.doc.save('/tmp/packpub-home-after-login.html')
        self.g.doc.text_assert('"sid":')
        self.logged_in = True

    def get_ebooks_list(self, url="https://www.packtpub.com/account/my-ebooks"):
        '''Loads the list of purchased ebooks and returns a Selection object with all books.'''
        if url.startswith("http") and not self.logged_in:
            raise LoggedOutException("Must be logged in before getting ebooks list!")
        self.g.go(url)
        self.g.doc.save('/tmp/packtpub-my-ebooks.html')
        self.g.doc.text_assert('<h1>My eBooks </h1>')
        all_books_xsel = self.g.doc.select('//div[@id="product-account-list"]/div[starts-with(@class, "product-line")][@title]')
        all_books = []
        for b in all_books_xsel:
            book_obj = PacktBook()
            book_obj.parse_from_xsel(b)
            all_books.append(book_obj)
        return all_books

parser = ArgumentParser(description="List or download all purchased ebooks from your PACKT account.")
parser.add_argument("--start", help="Index to start at (default: 1)", metavar="NUMBER", type=int, dest="idx_start", required=False)
parser.add_argument("-n", "--count", help="Number of items to download, starting at --start index", metavar="COUNT", type=int, dest="count", required=False)
parser.add_argument("--end", help="Index to stop at (default: last)", metavar="NUMBER", type=int, dest="idx_end", required=False)
#parser.add_argument("--verbose", help="Verbose logging to STDERR", action="store_true")
opts = parser.parse_args()
opts = vars(opts)


p = PacktPub()
#p.login(c.get('DEFAULT', 'PACKT_LOGIN'), c.get('DEFAULT', 'PACKT_PASSWORD'))
#all_books = p.get_ebooks_list()
all_books = p.get_ebooks_list("file:///tmp/packtpub-my-ebooks.html")
print("Found {:d} ebooks.".format(len(all_books)))

ctr = 1
for book in all_books:
    print("{:d}: {}".format(ctr, book))
    ctr += 1
