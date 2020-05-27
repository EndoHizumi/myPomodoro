import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify';
import VueAnalytics from 'vue-analytics'

Vue.config.productionTip = false
Vue.use(VueAnalytics, {
  id: 'UA-xxxxxxxxx-x'
});

new Vue({
  vuetify,
  render: h => h(App)
}).$mount('#app')
