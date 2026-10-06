# Mock guiado do FirawSelector (firawselector.firawynix.com.br): nginx com o site DENTRO da imagem, inclusive o
# instalador online assinado. Construída e assinada pela esteira (firawynix-workspace .github/workflows/build.yml); a
# produção roda só a imagem assinada, pelo firaw-deploy.
FROM nginx:1.31-alpine
# Só o site: tira a página padrão do nginx (index.html e 50x.html). Em produção, a montagem do public/ escondia
# essa pasta inteira; sem isto a imagem teria arquivos a mais (o transcricao-site voltou por isso em 05/10).
RUN rm -rf /usr/share/nginx/html
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/
# busybox wget: não grava nada (a raiz do container é só leitura em produção)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1
