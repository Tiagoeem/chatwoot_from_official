export default {
  mounted() {
    this.applyTheme();
  },
  methods: {
    applyTheme() {
      const themeConfig = window.themeConfig;
      if (themeConfig && themeConfig.colors) {
        const root = document.documentElement;
        Object.keys(themeConfig.colors).forEach(theme => {
          Object.keys(themeConfig.colors[theme]).forEach(key => {
            root.style.setProperty(`--${theme}-${key}`, themeConfig.colors[theme][key]);
          });
        });
      }
    },
  },
};
