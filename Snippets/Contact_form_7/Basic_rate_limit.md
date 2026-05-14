## Basic Rate limiter for contact form 7

Useful reference for fetching contact form object, WP transients, IP address fetch.

## Code

function cf7_rate_limit($result, $tags)
{
	$submission = WPCF7_Submission::get_instance();
	if (!$submission) {
return $result;
}

    //Need find the correct function to retreive form id





    $ip = $_SERVER['HTTP_CF_CONNECTING_IP']
    	?? $_SERVER['HTTP_X_FORWARDED_FOR']
    	?? $_SERVER['REMOTE_ADDR']
    	?? 'unknown';

    //Rate limit settings
    $limit_seconds = 60;

    //Create unique key per ip to keep track of submissions
    $key = 'cf7_last_submit_' . md5($ip);

    //Check last submission time
    $last_submit = get_transient($key);

    if ($last_submit && (time() - $last_submit) < $limit_seconds) {
    	$wait = (int) ceil($limit_seconds - (time() - $last_submit));

    	$tag = !empty($tags) ? array_shift($tags) : null;

    	if ($tag) {
    		$result->invalidate($tag, 'Too many submissions. Please wait ' . $wait . ' second before trying again');
    	}

    	return $result;
    }

    return $result;

}

function cf7_rate_limit_store_success($contact_form)
{

    $submission = WPCF7_Submission::get_instance();
    if (!$submission) {
    	return;
    }

    $ip = $_SERVER['HTTP_CF_CONNECTING_IP']
    	?? $_SERVER['HTTP_X_FORWARDED_FOR']
    	?? $_SERVER['REMOTE_ADDR']
    	?? 'unknown';

    $limit_seconds = 60;

    $key = 'cf7_last_submit_' . md5($ip);

    set_transient($key, time(), $limit_seconds);

}

add_action('wpcf7_mail_sent', 'cf7_rate_limit_store_success');
