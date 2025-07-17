import APIClient from './APIClient';

class ThemeAPI extends APIClient {
  constructor() {
    super('theme');
  }

  get() {
    return this.axios.get(`${this.url}/colors`);
  }
}

export default new ThemeAPI();
