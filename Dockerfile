#
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

FROM ubuntu:xenial

MAINTAINER "Travis Wichert" <padthaitofuhot@users.noreply.github.com>

VOLUME /opt

WORKDIR /

RUN apt update
RUN apt -y full-upgrade
RUN apt -y install build-essential unzip curl gcc g++

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
