import os
import unittest
from app import get_redis
from flask import g

class TestConfig(unittest.TestCase):
    def test_redis_host_config(self):
        # Clear any existing redis connection
        if hasattr(g, 'redis'):
            delattr(g, 'redis')
            
        # Test default value
        os.environ.pop('REDIS_HOST', None)
        redis_conn = get_redis()
        self.assertEqual(redis_conn.connection_pool.connection_kwargs['host'], 'redis')
        
        # Test custom value
        os.environ['REDIS_HOST'] = 'custom-redis'
        if hasattr(g, 'redis'):
            delattr(g, 'redis')
        redis_conn = get_redis()
        self.assertEqual(redis_conn.connection_pool.connection_kwargs['host'], 'custom-redis')

if __name__ == '__main__':
    unittest.main()
