# -*- coding: iso-8859-15 -*-
"""Simple FunkLoad test

$Id: test_Simple.py 1883 2005-12-19 06:43:14Z jerry $
"""
import unittest
import os
from random import random
from funkload.FunkLoadTestCase import FunkLoadTestCase

class Simple(FunkLoadTestCase):
    """This test use a configuration file Simple.conf."""

    def setUp(self):
        """Setting up test."""
	print 'ADI ucLinux Group'
        self.logd("setUp")
        self.server_url = self.conf_get('main', 'url')
	print self.server_url
	serverip = self.conf_get('main','serverip')
	#print serverip
	rcp_cmd='rcp -rp ../test root@'+serverip+':/home/httpd/'
	print rcp_cmd
	rcp_result = os.system(rcp_cmd)
	if not rcp_result:
		print 'rcp ok! Start webserver test.'
	else:
		print 'rcp error! Please confirm your server IP and destination directory!'
	
    def test_simple(self):
        # The description should be set in the configuration file
        server_url = self.server_url
        # begin of test ---------------------------------------------
        nb_time = self.conf_getInt('test_simple', 'nb_time')
        pages = self.conf_getList('test_simple', 'pages')

        for i in range(nb_time):
            self.logd('Try %i' % i)
            for page in pages:
		print 'Try %d' % i    
                self.get(server_url + page, description='Get %s' % page)
		print '    %s   ----OK!' % page

        # end of test -----------------------------------------------

    def tearDown(self):
        """Setting up test."""
        self.logd("tearDown.\n")


if __name__ in ('main', '__main__'):
    unittest.main()
