#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Needs grab, pip3 install -U grab

import configparser
import logging
import sys
from grab import Grab
from io import StringIO

config_str = '[DEFAULT]\n' + open(sys.path[0] + '/CONFIG', 'r').read()
config_fp  = StringIO(config_str)

c = configparser.RawConfigParser()
c.readfp(config_fp)

logging.basicConfig(level=logging.DEBUG)

g = Grab()
g.setup(follow_location=True)
g.setup(follow_refresh=True)
g.setup(timeout=60)
g.setup(connect_timeout=10)
g.setup(body_maxsize=512000)
g.go('https://www.packtpub.com/packt/offers/free-learning')
g.doc.save('/tmp/free-learning.html')
g.doc.choose_form(id='packt-user-login-form')
login = c.get('DEFAULT', 'PACKT_LOGIN')
print("Logging in with account: {}".format(login))
g.doc.set_input('email', c.get('DEFAULT', 'PACKT_LOGIN'))
g.doc.set_input('password', c.get('DEFAULT', 'PACKT_PASSWORD'))
g.doc.submit()
g.doc.save('/tmp/free-learning-after-login.html')
g.doc.text_assert('"sid":')
g.doc.text_assert('Claim Your Free eBook')
claim_book = g.doc.select('//div[@class="dotd-title"]/h2').text()
print("Book: {}".format(claim_book))
claim_url = g.doc.select('//a[@class="twelve-days-claim"]/@href').text()
print("Claim URL: {}".format(claim_url))
g.go(claim_url)
g.doc.save('/tmp/free-learning-after-claim.html')
g.doc.text_assert('<h1>My eBooks </h1>')
print("Claim successful.")
last_claimed_title = g.doc.select('(//div[@id="product-account-list"]/div)[1]/@title').text()
print("Last claimed book: {}".format(last_claimed_title))
