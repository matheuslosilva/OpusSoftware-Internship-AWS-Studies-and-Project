const http = require('http');
const fs = require('fs');
const path = require('path');

const server = http.createServer((req, res) => {
  // Define o caminho para o arquivo index.html
  const filePath = path.join(__dirname, 'index.html');

  // Lê o conteúdo do arquivo index.html
  fs.readFile(filePath, 'utf-8', (err, content) => {
    if (err) {
      // Se houver um erro, retorna um status de erro
      res.writeHead(500);
      res.end(`Erro ao carregar o arquivo index.html: ${err}`);
    } else {
      // Se tudo estiver correto, define o status e envia o conteúdo do arquivo index.html
      res.writeHead(200, { 'Content-Type': 'text/html' });
      res.end(content);
    }
  });
});

const port = process.env.PORT || 3200;

server.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});