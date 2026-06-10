# المرحلة الأولى: البناء باستخدام Flutter
FROM ghcr.io/cirruslabs/flutter:3.38.5 AS builder

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web

# المرحلة الثانية: التشغيل باستخدام NGINX
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]