#!/usr/bin/env bash
import.require 'logger.handlers.fancy>base'
logger.handlers.fancy.init() {
	logger.handlers.fancy.__init() {
		import.useModule 'logger.handlers.fancy_base'
	}
    logger.handlers.fancy.create() {
        logger.handlers.fancy_base.create "$@"
    }
    logger.handlers.fancy.processStartupArgs() {
        logger.handlers.fancy_base.processStartupArgs "$@"
    }
    logger.handlers.fancy.printCommandStart() {
        logger.handlers.fancy_base.printCommandStart "$@"
    }
    logger.handlers.fancy.printCommandEnd() {
        logger.handlers.fancy_base.printCommandEnd "$@"
    }
	logger.handlers.fancy.debug() {
		logger.handlers.fancy_base.debug "$@"
	}
	logger.handlers.fancy.info() {
		logger.handlers.fancy_base.info "$@"
	}
	logger.handlers.fancy.success() {
		logger.handlers.fancy_base.success "$@"
	}
	logger.handlers.fancy.warning() {
		logger.handlers.fancy_base.warning "$@"
	}
	logger.handlers.fancy.error() {
		logger.handlers.fancy_base.error "$@"
	}
    logger.handlers.fancy.beginTask() {
        logger.handlers.fancy_base.beginTask "$@"
    }
    logger.handlers.fancy.endTask() {
        logger.handlers.fancy_base.endTask "$@"
    }
    logger.handlers.fancy.step() {
        logger.handlers.fancy_base.step "$@"
    }
    logger.handlers.fancy.printLoop() {
        logger.handlers.fancy_base.printLoop "$@"
    }
	logger.handlers.fancy.print() {
		logger.handlers.fancy_base.print "$@"
	}
    logger.handlers.fancy.supportsMarkup() {
        logger.handlers.fancy_base.supportsMarkup "$@"
    }
}
