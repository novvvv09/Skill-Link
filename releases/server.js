const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const PORT = 3000;
const RELEASES_DIR = __dirname;

const server = http.createServer((req, res) => {
    const parsedUrl = url.parse(req.url, true);
    let pathname = parsedUrl.pathname;

    // Redirect root to index.html
    if (pathname === '/') {
        pathname = '/index.html';
    }

    const filePath = path.join(RELEASES_DIR, pathname);
    const normalizedPath = path.normalize(filePath);

    // Security: prevent directory traversal
    if (!normalizedPath.startsWith(RELEASES_DIR)) {
        res.writeHead(403, { 'Content-Type': 'text/plain' });
        res.end('403 Forbidden');
        return;
    }

    // Check if file exists
    fs.stat(filePath, (err, stats) => {
        if (err) {
            res.writeHead(404, { 'Content-Type': 'text/plain' });
            res.end('404 Not Found');
            console.log(`[404] ${pathname}`);
            return;
        }

        if (stats.isDirectory()) {
            res.writeHead(403, { 'Content-Type': 'text/plain' });
            res.end('403 Forbidden');
            return;
        }

        // Set content type
        let contentType = 'application/octet-stream';
        if (pathname.endsWith('.html')) contentType = 'text/html; charset=utf-8';
        else if (pathname.endsWith('.css')) contentType = 'text/css';
        else if (pathname.endsWith('.js')) contentType = 'application/javascript';
        else if (pathname.endsWith('.apk')) contentType = 'application/vnd.android.package-archive';
        else if (pathname.endsWith('.json')) contentType = 'application/json';

        // For APK downloads, add headers to prevent caching
        const headers = {
            'Content-Type': contentType,
            'Access-Control-Allow-Origin': '*',
            'Content-Length': stats.size
        };

        if (pathname.endsWith('.apk')) {
            headers['Content-Disposition'] = `attachment; filename="${path.basename(filePath)}"`;
            headers['Cache-Control'] = 'no-cache, no-store, must-revalidate';
            headers['Pragma'] = 'no-cache';
            headers['Expires'] = '0';
        }

        res.writeHead(200, headers);
        
        const stream = fs.createReadStream(filePath);
        stream.on('error', (err) => {
            console.error('Stream error:', err);
            res.writeHead(500, { 'Content-Type': 'text/plain' });
            res.end('500 Internal Server Error');
        });

        stream.pipe(res);

        // Log the request
        const sizeInMB = (stats.size / 1024 / 1024).toFixed(2);
        console.log(`[${new Date().toLocaleTimeString()}] GET ${pathname} (${sizeInMB} MB)`);
    });
});

server.listen(PORT, () => {
    console.log(`
╔════════════════════════════════════════════════════════╗
║           SKILL LINK DOWNLOAD SERVER                  ║
╚════════════════════════════════════════════════════════╝

✓ Server running on: http://localhost:${PORT}
✓ Files being served from: ${RELEASES_DIR}

📱 Share this link with users:
   http://localhost:${PORT}

To share publicly (using ngrok):
1. Install ngrok: npm install -g ngrok
2. Run: ngrok http ${PORT}
3. Copy the public URL and share

Press Ctrl+C to stop the server
`);
});

server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.error(`❌ Port ${PORT} is already in use!`);
        console.log(`\nTry using a different port:`);
        console.log(`   set PORT=3001 && node server.js`);
    } else {
        console.error('Server error:', err);
    }
    process.exit(1);
});
