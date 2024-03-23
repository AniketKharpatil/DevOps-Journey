# Use NGINX base image
FROM nginx:alpine
# Copy the HTML files to NGINX default public directory
COPY index.html /usr/share/nginx/html/index.html
# Expose port 80
EXPOSE 80
# Command to start NGINX when the container starts
CMD ["nginx", "-g", "daemon off;"]
