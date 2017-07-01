import.require 'logger.handlers.formatted>base'
logger.handlers.formatted.init() {
	logger.handlers.formatted.__init() {
		import.useModule 'logger.handlers.formatted_base'
	}
    logger.handlers.formatted.create() {
        logger.handlers.formatted_base.create "$@"
    }
    logger.handlers.formatted.processStartupArgs() {
        logger.handlers.formatted_base.processStartupArgs "$@"
    }
    logger.handlers.formatted.printCommandStart() {
        logger.handlers.formatted_base.printCommandStart "$@"
    }
    logger.handlers.formatted.printCommandEnd() {
        logger.handlers.formatted_base.printCommandEnd "$@"
    }
	logger.handlers.formatted.debug() {
		logger.handlers.formatted_base.debug "$@"
	}
	logger.handlers.formatted.info() {
		logger.handlers.formatted_base.info "$@"
	}
	logger.handlers.formatted.success() {
		logger.handlers.formatted_base.success "$@"
	}
	logger.handlers.formatted.warning() {
		logger.handlers.formatted_base.warning "$@"
	}
	logger.handlers.formatted.error() {
		logger.handlers.formatted_base.error "$@"
	}
    logger.handlers.formatted.beginTask() {
        logger.handlers.formatted_base.beginTask "$@"
	}
    logger.handlers.formatted.endTask() {
        logger.handlers.formatted_base.endTask "$@"
	}
    logger.handlers.formatted.step() {
        logger.handlers.formatted_base.step "$@"
    }
    logger.handlers.formatted.printLoop() {
        logger.handlers.formatted_base.printLoop "$@"
    }
	logger.handlers.formatted.print() {
		logger.handlers.formatted_base.print "$@"
	}
    logger.handlers.formatted.supportsMarkup() {
        logger.handlers.formatted_base.supportsMarkup "$@"
    }
}
