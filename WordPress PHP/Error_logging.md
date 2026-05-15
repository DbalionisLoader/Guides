### How to out any error from function.php into debug.log

1. Adapt and add eithe of the code snippet anywhere in function php where you want to check output of some values

```php
	error_log('orderby price only raw: ' . print_r($_GET['orderby'] ?? '', true));
	error_log('orderby price only query: ' . print_r($query);
```

### Things to consider

Add the error_log in a place it will run.

Or create a new function or hook to force the log.

Watch for variable SCOPE.
