const express = require('express');
const env = require('node-env-file');
const fs = require('node:fs');

env(__dirname + '/.env');

const port = process.env.NODE_PORT;

const PROTOCOLS = {
    HTTP : 'http',
    HTTPS: 'https'
};

function createServer()
{
    let protocol = PROTOCOLS.HTTP
    let params = [];

    if (process.env.SSL_KEY_PATH && process.env.SSL_CERT_PATH) {
        protocol = PROTOCOLS.HTTPS;
        params.push({
            key : fs.readFileSync(process.env.SSL_KEY_PATH),
            cert: fs.readFileSync(process.env.SSL_CERT_PATH),
        });
    }

    const factory = require(protocol);
    const app = express();

    params.push(app);

    return factory.createServer.apply(this, params);
}

const server = createServer();


server.listen(port, function () {
    console.log('Server listening at port %d', port)
})
