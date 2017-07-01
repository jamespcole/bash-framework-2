import.require 'logger>base'
logger.init() {
	logger.__init() {
		import.useModule 'logger_base'
	}
    logger.args() {
        logger_base.args "$@"
    }
    logger.setConsoleLogHandler() {
		logger_base.setConsoleLogHandler "$@"
	}
    logger.printCommandStart() {
		logger_base.printCommandStart "$@"
	}
    logger.processStartupArgs() {
        logger_base.processStartupArgs "$@"
    }
    logger.printCommandEnd() {
		logger_base.printCommandEnd "$@"
	}
	logger.debug() {
		logger_base.debug "$@"
	}
	logger.success() {
		logger_base.success "$@"
	}
	logger.info() {
		logger_base.info "$@"
	}
	logger.warning() {
		logger_base.warning "$@"
	}
	logger.error() {
		logger_base.error "$@"
	}
    logger.beginTask() {
		logger_base.beginTask "$@"
	}
    logger.endTask() {
		logger_base.endTask "$@"
	}
    logger.step() {
		logger_base.step "$@"
	}
    logger.printLoop() {
        logger_base.printLoop "$@"
    }
	logger.print() {
		logger_base.print "$@"
	}
    logger.supportsMarkup() {
        logger_base.supportsMarkup "$@"
    }
	logger.forceVerbose() {
		logger_base.forceVerbose "$@"
	}
    logger.forceDecoration() {
		logger_base.forceDecoration "$@"
	}
    logger.decorationCallback() {
        logger_base.decorationCallback "$@"
    }
    logger.forceHidePrefix() {
        logger_base.forceHidePrefix "$@"
    }
}
