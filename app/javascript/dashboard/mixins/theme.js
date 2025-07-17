import { mapGetters } from 'vuex';

export default {
  computed: {
    ...mapGetters({
      themeColors: 'globalConfig/themeColors',
    }),
  },
  watch: {
    themeColors: {
      handler(newColors) {
        if (newColors) {
          this.applyTheme(newColors);
        }
      },
      immediate: true,
    },
  },
  methods: {
    applyTheme(colors) {
      const root = document.documentElement;
      Object.keys(colors).forEach(theme => {
        Object.keys(colors[theme]).forEach(key => {
          root.style.setProperty(`--${theme}-${key}`, colors[theme][key]);
        });
      });
    },
  },
};
