#!/bin/sh

hugo

scp -r public/* envs.net:public_html/
