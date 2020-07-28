FROM alpine:3.12.0

RUN apk update && apk add bash curl

COPY troubleshoot.sh .
RUN chmod +x ./troubleshoot.sh

CMD [ "./troubleshoot.sh" ]
