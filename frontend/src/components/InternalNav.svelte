<script>
	import { onMount } from 'svelte';

	export let tabs;
	export let store;

	onMount(() => {
		if (tabs?.length) $store = tabs[0].tabName;
	});
</script>

{#if tabs?.length}
	<span class="p-0.5 rounded-lg inline-block bg-gray-200 text-sm">
		{#each tabs as tab}
			<span class="inline-block group border-radius-md rounded-md">
				<button
					class="
				p-1
				lg:pl-2.5 lg:pr-3.5
				rounded-md
				flex
				items-center
				text-gray-600
				font-medium
				focus-visible:ring-2
				focus-visible:ring-teal-500
				focus-visible:ring-offset-2
				focus:outline-none
				focus-visible:ring-offset-gray-100
				{$store === tab.tabName ? 'bg-white shadow-sm ring-1 ring-black ring-opacity-5' : ''}"
					on:click={() => ($store = tab.tabName)}
				>
					<i
						class=" bi {tab.icon} lg:mr-2 goup-hover:text-gray-900 {$store === tab.tabName
							? 'text-blue-500'
							: 'text-gray-500 hover:text-gray-900'}
				"
					/>

					<span class="ml-1 text-gray-600 group-hover:text-gray-900"> {tab.display} </span>
				</button>
			</span>
		{/each}
	</span>
{/if}
