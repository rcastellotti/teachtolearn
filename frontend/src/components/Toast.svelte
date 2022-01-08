<script>
	export let message;
	import { successMessage, errorMessage } from '$src/stores';
	import { slide } from 'svelte/transition';
	let icon;

	export let type;
	let color = '';
	switch (type) {
		case 'error':
			color = 'red';
			icon = 'bi-x-circle-fill';
			break;
		case 'info':
			color = 'blue';
			icon = 'bi-info-circle-fill';
			break;
		case 'success':
			color = 'green';
			icon = 'bi-check-circle-fill';
			break;
		default:
			break;
	}
	let showToast = true;
	let items = [];
	setTimeout(() => {
		$errorMessage = $successMessage = null;
		showToast = false;
	}, 2000);
	for (const [key, value] of Object.entries(message)) {
		items.push(key + ': ' + value);
	}
</script>

{#if showToast}
	<div
		transition:slide
		class="z-10 w-3/4 md:w-4/12 absolute md:top-16 md:right-16 md:bottom-auto md:translate-x-0 right-1/2 translate-x-1/2 bottom-8
    px-2 py-1 flex bg-{color}-200 rounded border-l-8 border-{color}-600 md:p-3 gap-3 items-center"
	>
		<i class="text-{color}-600 text-2xl bi {icon}" />
		<div>
			<h1 class="text-{color}-700 font-semibold">{type}</h1>
			<div class="text-{color}-700 text-xs">
				{#if typeof message === 'object' && message !== null}
					<ul>
						{#each items as item}
							<li>{item}</li>
						{/each}
					</ul>
				{:else}
					{message}
				{/if}
			</div>
		</div>
	</div>
{/if}
