#!/bin/bash
#
# Copyright 2011 The Apache Software Foundation
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This script stops a metastore instance.
# Usage: stop-metastore.sh -p pidfilename

prgm=$0
bin=`dirname $prgm`

while [ ! -z "$1" ]; do
  if [ "$1" == "-p" ]; then
    shift
    pidfilename=$1
    shift
  else
    echo "Unknown argument $1"
    exit 1
  fi
done

# Verify our arguments exist.

if [ -z "${pidfilename}" ]; then
  echo "Missing argument: -p pidfilename"
  exit 1
fi

# Export service name for applying corresponding *-env.sh in configure-sqoop

SQOOP_NAME=sqoop-metastore
export SQOOP_NAME


# Shut down any running metastore.

if [ ! -z "$bin" ]; then
  bin="$bin/"
fi

nohup "$bin/sqoop" metastore --shutdown 2>&1 >/dev/null
ret=$?
if [ "$ret" != "0" ]; then
  echo "Could not shut down metastore."
  exit $ret
fi

# Remove the pidfile lock.

rm -f "$pidfilename"
