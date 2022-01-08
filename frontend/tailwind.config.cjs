const config = {
	content: ['./src/**/*.{html,js,svelte,ts}'],
	safelist: [
		{
			pattern:
				/text-(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(600)/
		},
		{
			pattern:
				/bg-(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(500)/
		},
		{
			pattern: /bg-(red|green|blue)-(200|600)/
		},
		{
			pattern: /text-(red|green|blue)-(700)/
		},
		{
			pattern:
				/border-(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(600)/
		}
	],
	theme: {
		extend: {
			colors: {
				darky: {
					DEFAULT: '#333332',
					dark: '#242423'
				}
			}
		}
	},

	plugins: []
};

module.exports = config;
