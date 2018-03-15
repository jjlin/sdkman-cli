#!/usr/bin/env bash

#
#   Copyright 2017 Marco Vermeulen
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

function __sdkman_echo_debug {
	if [[ "$sdkman_debug_mode" == 'true' ]]; then
		echo "$1"
	fi
}

function __sdkman_secure_curl {
	local params=(--silent --location)
	if [[ "${sdkman_insecure_ssl}" == 'true' ]]; then
		params+=(--insecure)
	fi
	curl "${params[@]}" "$1"
}

function __sdkman_secure_curl_download {
	local params=(--progress-bar --location)

	if [[ "${sdkman_insecure_ssl}" == 'true' ]]; then
		params+=(--insecure)
	fi

	local cookie_file="${SDKMAN_DIR}/var/cookie"
	if [[ -f "$cookie_file" ]]; then
		local cookie=$(<"$cookie_file")
		params+=(--cookie "$cookie")
	fi

	curl "${params[@]}" "$1"
}

function __sdkman_secure_curl_with_timeouts {
	local params=(
		--silent
		--location
		--connect-timeout ${sdkman_curl_connect_timeout}
		--max-time ${sdkman_curl_max_time}
	)
	if [[ "${sdkman_insecure_ssl}" == 'true' ]]; then
		params+=(--insecure)
	fi
	curl "${params[@]}" "$1"
}

function __sdkman_page {
	if [[ -n "$PAGER" ]]; then
		"$@" | eval $PAGER
	elif command -v less &> /dev/null; then
		"$@" | less
	else
		"$@"
	fi
}

function __sdkman_echo {
	if [[ "$sdkman_colour_enable" == 'false' ]]; then
		echo -e "$2"
	else
		echo -e "\033[1;$1$2\033[0m"
	fi
}

function __sdkman_echo_red {
	__sdkman_echo "31m" "$1"
}

function __sdkman_echo_no_colour {
	echo "$1"
}

function __sdkman_echo_yellow {
	__sdkman_echo "33m" "$1"
}

function __sdkman_echo_green {
	__sdkman_echo "32m" "$1"
}

function __sdkman_echo_cyan {
	__sdkman_echo "36m" "$1"
}

function __sdkman_echo_confirm {
	if [[ "$sdkman_colour_enable" == 'false' ]]; then
		echo -n "$1"
	else
		echo -e -n "\033[1;33m$1\033[0m"
	fi
}
