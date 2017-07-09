#!/usr/bin/env bash
import.require 'provision'
provision.nsq_base.init() {
	provision.nsq_base.__init() {
		  import.useModule 'provision'
	}
	provision.nsq_base.require() {
		if provision.isInstalled 'nsqd'; then
			return 0
		fi
		local nsqInstallDir='/usr/local/bin'
		local nsqUrl='https://s3.amazonaws.com/bitly-downloads/nsq/nsq-1.0.0-compat.linux-amd64.go1.8.tar.gz'
		local nsqTmpDir="$(mktemp -d)"
		local nsqTmpFile="${nsqTmpDir}/nsq.tar.gz"
		wget "${nsqUrl}" -O "${nsqTmpFile}" || {
			logger.error --message \
				'Failed to download nsq binaries'
			return 1
		}
		tar -zxvf "${nsqTmpFile}" --directory "${nsqTmpDir}" || {
			logger.error --message \
				'Failed to unpack nsq binaries'
			return 1
		}

		local nsqdTmpPath="$(find ${nsqTmpDir} -name nsqd)"
		if [ "${nsqdTmpPath}" == '' ]; then
			logger.error --message \
				"Failed to find nsqd in the extracted files at \"${}\""
			return 1
		fi

		local nsqdExtractedDir="$(dirname ${nsqdTmpPath})"
		sudo cp "${nsqdExtractedDir}/"* "${nsqInstallDir}"  || {
			logger.error --message \
				"Failed to copy nsq binaries from \"${nsqdExtractedDir}\" to \"${nsqInstallDir}\""
			return 1
		}
		if provision.isInstalled 'nsqd'; then
			return 0
		fi
		return 1
	}
}
