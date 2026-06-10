# المرحلة الأولى: البناء باستخدام Flutter
FROM ghcr.io/cirruslabs/flutter:stable AS builder

# انسخ ملفات المشروع داخل الحاوية
WORKDIR /app
COPY . .

# حمل الـ dependencies
RUN flutter pub get

# ابني مشروع Flutter Web
RUN flutter build web

# المرحلة الثانية: التشغيل باستخدام NGINX
FROM nginx:alpine

# احذف ملفات NGINX الافتراضية
RUN rm -rf /usr/share/nginx/html/*

# انسخ ملفات Flutter Web المبنية من المرحلة السابقة
COPY --from=builder /app/build/web /usr/share/nginx/html

# افتح المنفذ 80
EXPOSE 80

# شغّل NGINX
CMD ["nginx", "-g", "daemon off;"]
