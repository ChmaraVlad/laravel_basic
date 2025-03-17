import express from 'express';
import factory from 'https';

import env from  'node-env-file';
import fs from 'node:fs';

import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

env(__dirname + '/.env');

const port = process.env.NODE_PORT;

function createServer()
{
    const params = [];

   params.push({
        key : fs.readFileSync(process.env.SSL_KEY_PATH),
        cert: fs.readFileSync(process.env.SSL_CERT_PATH),
    });

    const app = express();

    params.push(app);

    return factory.createServer.apply(this, params);
}

const server = createServer();


server.listen(port, function () {
    console.log('Server listening at port %d', port)
})
