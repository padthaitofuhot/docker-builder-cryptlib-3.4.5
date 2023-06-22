#!/usr/bin/env bash
#    A simple build script template for producing binaries in docker images.
#    Copyright (C) 2023 Travis Wichert <padthaitofuhot@users.noreply.github.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

PROJECT_NAME=cryptlib
PROJECT_SOURCE=libcl.so.3.4.5
PROJECT_TARGET=/usr/lib/libcl.so

o() {
    printf "%s\n" "${*}"
}

askyn() {
    read -p "${*} <y/N> " -r -e
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

build_docker_image() {
  askyn "Build the builder Docker image?" || return 0
  sudo docker build . -t "docker-builder-${PROJECT_NAME}:latest" \
        && o "Docker image build process completed." \
        && return 0
  o "Docker image build process failed."
  return 1
}

build_payload() {
  ! (docker images | grep -q "docker-builder-${PROJECT_NAME}") && return 0
  askyn "Build ${PROJECT_NAME}?" || return 0
  sudo docker run -it --rm --mount type=bind,source="$(pwd)",target=/opt "docker-builder-${PROJECT_NAME}:latest" \
        && o "Project build process completed." \
        && return 0
  o "Project build process failed."
  return 1
}

install_payload() {
  ! [ -f "${PROJECT_SOURCE}" ] && return 0
  askyn "Install ${PROJECT_NAME} to ${PROJECT_TARGET}?" || return 0
  sudo install -v -m 644 -o root "${PROJECT_SOURCE}" "${PROJECT_TARGET}" \
        && printf "SHA256: %s\n" "$(sha256sum "${PROJECT_TARGET}")" \
        && stat "${PROJECT_TARGET}" \
        && o "Project install completed." \
        && return 0
  o "Project install failed."
  return 1
}

remove_image() {
    ! (docker images | grep -q "docker-builder-${PROJECT_NAME}") && return 0
    askyn "Remove builder image for ${PROJECT_NAME}?" || return 0
    sudo docker rmi  "docker-builder-${PROJECT_NAME}:latest" \
          && o "Builder image removed." \
          && return 0
    o "Builder image remove failed."
    return 1
}

procedure() {
  build_docker_image || exit 1
  build_payload || exit 1
  install_payload || exit 1
  remove_image || exit 1
}

procedure
