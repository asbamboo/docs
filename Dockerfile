FROM nginx

WORKDIR /srv/asbamboo/docs

ADD ./_build /srv/asbamboo/docs/web

COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]