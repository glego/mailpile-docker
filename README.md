# Mailpile Docker
[![Build Status](https://api.travis-ci.org/glego/mailpile-docker.svg?branch=master)](https://travis-ci.org/glego/mailpile-docker)
[![Docker Stars](https://img.shields.io/docker/stars/glego/mailpile.svg?maxAge=2592000)](https://hub.docker.com/r/glego/mailpile/)
[![Docker Pulls](https://img.shields.io/docker/pulls/glego/mailpile.svg?maxAge=2592000)](https://hub.docker.com/r/glego/mailpile/)
[![Docker Layers](https://images.microbadger.com/badges/image/glego/mailpile.svg)](https://microbadger.com/images/glego/mailpile "Get your own image badge on microbadger.com")

## Work in Progress (not stable)

[`Mailpile-Docker`](https://hub.docker.com/r/glego/mailpile/) is a fully stateless and immutable Docker implementation of [`Mailpile`](https://github.com/mailpile/Mailpile). The configuration is done by the Ansible Playbook via environment variables, followed by an s6-overlay to control the application processes. The application is built inside a Python3 virtual environment (venv), to ensure all python dependencies are within one directory.

## Get started

### 1. Prerequisites

* Docker
... to-do


## References
* [Mailpile installation linux](https://github.com/mailpile/Mailpile/wiki/Getting-started-on-Linux): Getting started and dependencies
* [Mailpile Web Interface](https://github.com/mailpile/Mailpile/wiki/Using-the-Web-Interface): How to run mailpile without cli
* [Mailpile reverse proxy](https://github.com/mailpile/Mailpile/wiki/Accessing-The-GUI-Over-Internet): Accessing GUI over the internet