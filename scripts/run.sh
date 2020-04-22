docker build --tag srodowiskotpbl . &&\
docker run --name envtpbl -it -v /$PWD/shared:/shared   srodowiskotpbl
