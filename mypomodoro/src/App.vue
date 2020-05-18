<template>
  <div id="app">
    <countdown :left-time="60000" :auto-start="false" ref="cnt">
      <div
      slot="before"
      >
      00:00
      </div>
      <div
        slot="process"
        slot-scope="anyYouWantedScopName"
       >      {{ `${anyYouWantedScopName.timeObj.m}:${anyYouWantedScopName.timeObj.s}` }}</div>
      <div slot="finish" style="color: red;">
          00:00
      </div>
    </countdown>
    <button @click="doRestart">スタート</button>
    <button @click="doStop">ストップ</button>
    <button @click="doSwitch">[再開]ー[一時停止]</button>
  </div>
</template>

<script>
export default {
  name: "App",
  methods: {
    doRestart: function() {
      this.$refs.cnt.startCountdown(true);
    },
    doStop: function() {
      this.$refs.cnt.stopCountdown();
    },
    doSwitch: function() {
      this.$refs.cnt.switchCountdown();
    }
  }
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

#app > span > div {
    font-weight: bold;
    font-size: 1000%;
}

</style>
