# --- Tahap 1: Build (Membangun Aplikasi React) ---
# Gunakan image Node.js versi LTS sebagai basis
FROM node:18-alpine AS build

# Tentukan direktori kerja di dalam container
WORKDIR /app

# Salin package.json dan package-lock.json (atau yarn.lock)
# Ini memanfaatkan cache Docker
COPY package*.json ./

# Install dependencies
RUN npm install

# Salin sisa kode aplikasi
COPY . .

# Bangun aplikasi untuk produksi
RUN npm run build

# --- Tahap 2: Serve (Menyajikan Aplikasi dengan Nginx) ---
# Gunakan image Nginx yang ringan
FROM nginx:1.25-alpine

# Salin hasil build (dari folder /app/build di tahap 'build')
# ke folder default Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# (Opsional) Salin konfigurasi Nginx kustom jika Anda punya
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Perintah default untuk menjalankan Nginx
CMD ["nginx", "-g", "daemon off;"]