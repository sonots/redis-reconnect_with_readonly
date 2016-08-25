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
