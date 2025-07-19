import APIClient from 'dashboard/api/ApiClient';

class ThemeAPI extends APIClient {
  constructor() {
    super('theme');
  }

  get() {
    return this.axios.get(`${this.url}/colors`);
  }
}

export default new ThemeAPI();
