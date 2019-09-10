### About this changelog

Based on this [template](https://gist.github.com/pascalandy/af709db02d3fe132a3e6f1c11b934fe4). Release process at FirePress ([blog post](https://firepress.org/en/software-and-ghost-updates/)). Based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### Status template

- ⚡️ Updates
- 🚀 New feat.
- 🐛 Fix bug
- 🛑 Removed
- 🔑 Security

# Releases

## 2.6.9-r2
### ⚡️ Updates
- b446285 introduce a new var to fix logic is where APP_NAME is not the same as git_repo_name
- ed71456 update utility.sh v0.8.5

## 2.6.9-r1
### ⚡️ Updates
- d9deb23 update utility.sh to v0.8.4
- 8ab50df Init gitignore
- 5f66924 Init dockerignore

## 2.6.9-r0
### ⚡️ Updates
- Overall this projet is now running smoothly in the way we manage projects at FirePress.

### ⚡️ Updates
- 8b5e820 Improve README / squashed
- 200441e update license / squashed
- 966c4d7 Major CI yaml upgrades for master and edge
- 5b29b34 remove auto-update-repo (scripts)
- 5e1a631 Update utility.sh v0.8.3
- 064e4fd Dockerfile Update ARG to follow our template across our projects
- 9e914f5 CI, Use vars for Dockerfile

## 2.6.9
### ⚡️ Updates
- **Forked** from https://github.com/almir/docker-webhook
on Jul 2, 2019
- 898a549 CI / Add readme-to-dockerhub + Add Slack notification
- a54f96b Dockerfile FIX alpine instead of ubuntu
- 9afb13e Dockerfile Rollback to alpine cmds
- 6e3294b Dockerfile Add more path to VOLUME & WORKDIR
- 2d7bb53 Dockerfile use Ubuntu in the final image
- f97c639 Dockerfile Improve ENV VAR
- 645c1ca Dockerfile Run under tini and non-root
- 53c7cac Init docker_build_ci.yml
- e63fcf6 Init Dockerfile
- 497a5d1 - update version of alpine, closing #12
