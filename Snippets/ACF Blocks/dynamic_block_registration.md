## Dynamicly register acf block (old method)

<?php

/*
List of all available block icons
https://developer.wordpress.org/resource/dashicons/#products

*/

add_action('acf/init', function () {

	if (!function_exists('acf_register_block_type')) {
		return;
	}

	$blocks = [
		'homepage-hero',
		'header-about',
	];

	foreach ($blocks as $block) {
		register_acf_block($block);
	}
});



function register_acf_block($slug)
{

	acf_register_block_type([
		'name'              => $slug,
		'title'             => ucwords(str_replace('-', ' ', $slug)),
		'render_callback'   => 'render_acf_block',
		'category'          => 'formatting',
		'mode'              => 'preview',


	]);
}

/* 'enqueue_style' => get_template_directory_uri() . '/blocks/homepage-hero/style.css', */

function enqueue_block_style($slug)
{

	$file_path = get_template_directory() . "/blocks/{$slug}/style.css";
	$file_uri = get_template_directory_uri() . "/blocks/{$slug}/style.css";

	if (file_exists($file_path)) {
		wp_enqueue_style(
			"block-{$slug}",
			$file_uri,
			[],
			filemtime($file_path)
		);
	}
}


function render_acf_block($block)
{
	/* ]Preview $block object data */
	// echo '<pre>';
	// print_r($block);
	// echo '</pre>';   

	/* remove the the acf naming from block data */
	$slug = str_replace('acf/', '', $block['name']);

	$file = get_template_directory() . "/blocks/{$slug}/render.php";

	enqueue_block_style($slug);

	if (file_exists($file)) {
		include $file;
	}
}
