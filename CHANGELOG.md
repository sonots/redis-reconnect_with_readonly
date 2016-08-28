# 0.9.3 (2016-08-28)

Fixes:

* raise e on give up

# 0.9.2 (2016-08-28)

Enhancements:

* Add logger option

# 0.9.1 (2016-08-26)

Fixes:

* Disconnect!

# 0.9.0 (2016-08-25)

Enhancements:

* Add `initial_retry_wait`

Changes:

* Rename `max_retry_interval` to `max_retry_wait`
* Change wait formula from `initial_retry_wait ^ number of retries` to `initial_retry_wait * number of retries`

# 0.1.1 (2016-08-24)

* Make configurable `reconnect_attempts` and `max_retry_interval`

# 0.1.0 (2016-08-24)

First version
