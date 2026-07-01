FROM python:alpine
WORKDIR /tmp
COPY ./requirements.txt .

# Устанавливаем системные библиотеки для генерации PDF и сам MkDocs
RUN apk add --no-cache build-base libffi-dev zlib-dev \
    libwebp-dev jpeg-dev harfbuzz-dev fribidi-dev freetype-dev \
    cairo-dev musl-dev pango-dev gdk-pixbuf-dev \
    ttf-dejavu font-noto \
    && pip install --no-cache-dir -r ./requirements.txt

# Рабочая папка для документации
WORKDIR /MkDocs

# Команда сборки сайта по умолчанию
CMD ["mkdocs", "build"]