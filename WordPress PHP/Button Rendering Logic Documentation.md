### Condition Button Rending using one page template

## Setup array with conditional field if empty checks.

Can add preference if one button has different types of links

```php
$buttons = [];
if (!empty($PostPatent)) {
	$buttons[] = "<a href='" . esc_url($PatentDownload) . "' class='SpecDownload' target='_blank'>View Patent</a>";
}

// Prefer Protected Spec over normal Specsheet
if (!empty($PasswordSpec)) {
	$buttons[] = "<a href='" . esc_url($PasswordSpec) . "' class='SpecDownload' target='_blank'>View Specification Sheet</a>";
}

if (!empty($PostSpec) && empty($PasswordSpec)) {
	$buttons[] = "<a href='" . esc_url($SpecDownload) . "' class='SpecDownload' target='_blank'>View Specification Sheet</a>";
}

if (!empty($ProtectedPageURl)) {
	$buttons[] = "<a href='" . esc_url($ProtectedPageURl) . "' class='SpecDownload' target='_blank'>Manual</a>";
}

$ButtonCount = count($buttons);

$ThreeColLayout = ($ButtonCount === 3);

$ColClass = $ThreeColLayout
	? 'col-12 col-lg-4'
	: 'col-12 col-lg-6';


if ($ButtonCount === 1) {
	array_unshift($buttons, "<div class='p-4'>&nbsp;</div>");
}

if ($ButtonCount === 0) {
	$buttons = [
		"<div class='p-4'>&nbsp;</div>",
		"<div class='p-4'>&nbsp;</div>"
	];
}

?>
```

## Output the buttons as loop

```php
	<div class="Grid">
		<div class="<?php echo ($ThreeColLayout) ? 'BG Third' : 'BG Halfs' ?>"></div>
		<div class="row">

			<?php foreach ($buttons as $button) : ?>

				<div class="<?php echo $ColClass; ?> NoPadding">
					<?php echo $button; ?>
				</div>

			<?php endforeach; ?>

		</div>
	</div>
```
