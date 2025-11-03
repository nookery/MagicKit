// @ts-check
import { defineConfig } from 'astro/config';
import path from 'path';
import pagefind from 'astro-pagefind';

import mdx from '@astrojs/mdx';

// https://astro.build/config
export default defineConfig({
    i18n: {
        locales: ['zh-cn', 'en'],
        defaultLocale: 'zh-cn',
        routing: {
            prefixDefaultLocale: true,
        },
    },

    vite: {
        resolve: {
            alias: {
                '@': path.resolve('./src'),
            },
        },
    },

    integrations: [pagefind(), mdx()],
});