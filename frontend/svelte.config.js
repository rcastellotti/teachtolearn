import preprocess from 'svelte-preprocess';
import path from 'path';
import adapter from '@sveltejs/adapter-node';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		// hydrate the <div id="svelte"> element in src/app.html
		target: '#svelte',
		adapter: adapter(),
		vite: {
			resolve: {
				alias: {
					$components: path.resolve('./src/components'),
					$src: path.resolve('./src')
				}
			}
		}
	},

	preprocess: [
		preprocess({
			postcss: true
		})
	]
};

export default config;
