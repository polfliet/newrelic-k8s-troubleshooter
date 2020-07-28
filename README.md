# What is this?
A simple tool that runs a few checks to help with remote troubleshooting:
* Check outbound network connectivity
* Check DNS resolution
* Test sending log message to New Relic

This is a first and simple version and can be extended to do more and better troubleshooting.

# Run the troubleshooter in Kubernetes
* Create the pod that runs the troubleshooter
`kubectl create -f troubleshooter.yaml`

* Get the troubleshooting output
`kubectl logs newrelic-troubleshooter`

# How to build & test
* Build the docker image
docker image build -t spolfliet/newrelic-troubleshooter .

* Run the troubleshooter as a standalone docker container (for testing)
docker run --env NRIA_LICENSE_KEY=$NRIA_LICENSE_KEY --env NEW_RELIC_REGION=US spolfliet/newrelic-troubleshooter