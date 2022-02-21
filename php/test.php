<?php

/**
 * Logs using the given streams.
 *
 * @author Rémi Marseille <marseille@ekino.com>
 */
class Logger
{
    /**
     * @var resource
     */
    private $stdOut;

    /**
     * @var resource
     */
    private $stdErr;

    /**
     * @param resource $stdOut
     * @param resource $stdErr
     */
    public function __construct($stdOut, $stdErr)
    {
        $this->stdOut = $stdOut;
        $this->stdErr = $stdErr;
    }

    /**
     * Closes the opened streams.
     */
    public function __destruct()
    {
        fclose($this->stdOut);
        fclose($this->stdErr);
    }

    /**
     * Logs the given message as info.
     *
     * @param string $message
     * @param bool   $appendBreakingLine
     */
    public function info($message, $appendBreakingLine = true)
    {
        fwrite($this->stdOut, sprintf("\033[36m%s\033[39m%s", $message, $appendBreakingLine ? "\n" : ""));
    }

    /**
     * Logs the given message as success.
     *
     * @param string $message
     * @param bool   $appendBreakingLine
     */
    public function success($message, $appendBreakingLine = true)
    {
        fwrite($this->stdOut, sprintf("\033[32m%s\033[39m%s", $message, $appendBreakingLine ? "\n" : ""));
    }

    /**
     * Logs the given message as failure.
     *
     * @param string $message
     * @param bool   $appendBreakingLine
     */
    public function failure($message, $appendBreakingLine = true)
    {
        fwrite($this->stdErr, sprintf("\033[31m%s\033[39m%s", $message, $appendBreakingLine ? "\n" : ""));
    }
}

/**
 * Checks the PHP installation.
 *
 * @author Rémi Marseille <marseille@ekino.com>
 */
class Checker
{
    /**
     * @var Logger
     */
    private $logger;

    /**
     * @var int
     */
    private $exitStatus = 0;

    /**
     * @param Logger $logger
     */
    public function __construct(Logger $logger)
    {
        $this->logger = $logger;
    }

    /**
     * Checks the PHP installation.
     *
     * @return int
     */
    public function check()
    {
        $this->logger->info(<<<"EOF"
                      _    _
                  ___| | _(_)_ __   ___
                 / _ \ |/ / | '_ \ / _ \
                |  __/   <| | | | | (_) |
                 \___|_|\_\_|_| |_|\___/
  ____  _   _ ____     ____ _               _
 |  _ \| | | |  _ \   / ___| |__   ___  ___| | _____ _ __
 | |_) | |_| | |_) | | |   | '_ \ / _ \/ __| |/ / _ \ '__|
 |  __/|  _  |  __/  | |___| | | |  __/ (__|   <  __/ |
 |_|   |_| |_|_|      \____|_| |_|\___|\___|_|\_\___|_|

EOF
        );

        $this->logger->info(sprintf('> PHP version: %s', PHP_VERSION));

        $this->checkExtensions();
        $this->checkIniConfig();

        $this->logger->info('');

        if ($this->exitStatus === 0) {
            $this->logger->success('Good job, all checks are ok!');
        } else {
            $this->logger->failure('Please fix issues ;).');
        }

        return $this->exitStatus;
    }

    /**
     * Checks PHP extensions.
     */
    private function checkExtensions()
    {
        $this->logger->info('> PHP extensions: ', false);

        $errors                    = [];
        $commonExtensionsExpected  = [
            'apcu', 'bcmath', 'blackfire', 'exif', 'gd', 'iconv', 'intl', 'mbstring', 'memcached', 'mysqli', 'pcntl',
            'pcov', 'pdo_mysql', 'pdo_pgsql', 'pgsql', 'redis', 'soap', 'sockets', 'ssh2', 'xdebug', 'xsl', 'Zend OPcache',
            'zip',
        ];
        $unreadyNextMajorExtensions = ['ssh2'];
        $extensionsExpected        = \PHP_VERSION_ID < 80000 ? $commonExtensionsExpected
            : array_diff($commonExtensionsExpected, $unreadyNextMajorExtensions);

        $extensionsMissing = array_filter($extensionsExpected, function ($extension) {
            return !extension_loaded($extension);
        });

        if ($extensionsMissing) {
            $errors[] = sprintf('    >> missing "%s"', implode('", "', $extensionsMissing));
        }

        if (false === iconv("UTF-8", "UTF-8//IGNORE", "This is the Euro symbol '\''€'\''.")) {
            $errors[] = '    >> "iconv" seems to be broken';
        }

        if ($errors) {
            $this->logger->failure(sprintf("\n%s", implode("\n", $errors)));

            ++$this->exitStatus;
        } else {
            $this->logger->success(sprintf('ok! ("%s")', implode('", "', $extensionsExpected)));
        }
    }

    /**
     * Checks ini configuration.
     */
    private function checkIniConfig()
    {
        $this->logger->info('> PHP configuration: ', false);

        $errors = [];

        if (($value = ini_get('date.timezone')) !== 'UTC') {
            $errors[] = sprintf('    >> "date.timezone" should be equal to "UTC", got "%s"', $value);
        }

        $value = ini_get('short_open_tag');

        if (!in_array($value, ['', 'Off', 0])) {
            $errors[] = sprintf('    >> "short_open_tag" should be equal to "Off", got "%s"', $value);
        }

        if ($errors) {
            $this->logger->failure(sprintf("\n%s", implode("\n", $errors)));

            ++$this->exitStatus;
        } else {
            $this->logger->success('ok!');
        }
    }
}

if (in_array('-s', $argv) || in_array('--silent', $argv)) {
    $stdOut = fopen('php://memory', 'w');
    $stdErr = fopen('php://memory', 'w');
} else {
    $stdOut = STDOUT;
    $stdErr = STDERR;
}

$checker = new Checker(new Logger($stdOut, $stdErr));

exit($checker->check());
