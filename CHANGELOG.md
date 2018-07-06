# okta-terraform-generator CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## 0.1.1 (2018-07-06)

Fixed bug that removes users that had a state of `LOCKED_OUT`, `PASSWORD_EXPIRED` or `RECOVERY`; these users still exist and should not be ignored.

## 0.1.0 (2018-06-13)

First release.
