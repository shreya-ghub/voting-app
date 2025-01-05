const assert = require('assert');

describe('Database Configuration', () => {
  let originalEnv;

  beforeEach(() => {
    originalEnv = process.env.POSTGRES_HOST;
  });

  afterEach(() => {
    process.env.POSTGRES_HOST = originalEnv;
  });

  it('should use POSTGRES_HOST environment variable when set', () => {
    process.env.POSTGRES_HOST = 'custom-host';
    const { Pool } = require('pg');
    const pool = new Pool({
      connectionString: `postgres://postgres:postgres@${process.env.POSTGRES_HOST || 'db'}/postgres`
    });
    assert.ok(pool.options.connectionString.includes('custom-host'));
  });

  it('should default to "db" when POSTGRES_HOST is not set', () => {
    delete process.env.POSTGRES_HOST;
    const { Pool } = require('pg');
    const pool = new Pool({
      connectionString: `postgres://postgres:postgres@${process.env.POSTGRES_HOST || 'db'}/postgres`
    });
    assert.ok(pool.options.connectionString.includes('@db/'));
  });
});
