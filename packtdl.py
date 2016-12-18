#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Needs grab, pip3 install -U grab
# (also needs: libcurl4-*-dev for curl-config, libxslt1-dev and libxml2-dev)

import configparser
import logging
import selection
import sys
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
        return self.g.doc.select('//div[@id="product-account-list"]/div[starts-with(@class, "product-line")][@title]')

    def parse_book_xsel(self, book: selection.backend.XpathSelector):
        b = PacktBook()
        b.title = book.select("@title").text()
        b.nid = book.select("@nid").text()
        b.cover_img = book.select(".//img/@src").text().replace("imagecache/thumbview/", "")

        isbn = book.select(".//div/@isbn")
        if isbn:
            b.isbn = isbn.text()

        b.dl_pdf = book.select(".//a[div/@format='pdf']/@href").text()

        dl_epub = book.select(".//a[div/@format='epub']/@href")
        if dl_epub:
            b.dl_epub = dl_epub.text()

        dl_mobi = book.select(".//a[div/@format='mobi']/@href")
        if dl_mobi:
            b.dl_mobi = dl_mobi.text()

        dl_code = book.select(".//a[starts-with(@href, '/code_download')]/@href")
        if dl_code:
            b.dl_code = dl_code.text()

        return b

p = PacktPub()
#p.login(c.get('DEFAULT', 'PACKT_LOGIN'), c.get('DEFAULT', 'PACKT_PASSWORD'))
#all_books = p.get_ebooks_list()
all_books = p.get_ebooks_list("file:///tmp/packtpub-my-ebooks.html")
print("Found {:d} ebooks.".format(len(all_books)))

ctr = 1
for b in all_books:
    book = p.parse_book_xsel(b)
    print("{:d}: {} ({})".format(ctr, book.title, book.isbn))
    if book.dl_pdf:
        print("  [PDF]", end="")
    if book.dl_epub:
        print("  [ePub]", end="")
    if book.dl_mobi:
        print("  [MOBI]", end="")
    if book.dl_code:
        print("  [Code]", end="")
    print("")
    ctr += 1
