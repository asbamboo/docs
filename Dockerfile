FROM asbamboo/nginx:1.0.0

WORKDIR /html

ADD ./_build /html/_build

COPY nginx.conf /html/asbamboo.nginx.conf

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]