<template>
  <div id="app">
    <timer v-bind:name="name" v-bind:startTime="time" v-bind:state="state" ref="timer" v-on:finish="next"></timer>
    <button v-on:click="startTimer" v-if="state == 'stop' || state == 'finish'">start</button>
    <button v-on:click="startTimer" v-if="state == 'pause'">restart</button>
    <button v-on:click="pauseTimer" v-if="state == 'process'">pause</button>
    <button v-on:click="stopTimer" v-if="state == 'pause' || state == 'finish'">reset</button>
  </div>
</template>

<script>
import timer from "./components/timer";
export default {
  name: "App",
  data: function() {
    return {
      state: "stop",
      time: "00",
      pattern: [],
      position: 0,
    };
  },
  components: {
    timer
  },
  methods: {
    startTimer: function() {
      this.state = "process";
      this.name = this.pattern[this.position]['name'];
      this.time = this.pattern[this.position]["time"];
      this.$refs.timer.startTimer();
    },
    stopTimer: function() {
      this.state = "stop";
      this.position = 0
      this.name = this.pattern[0]['name'];
      this.time = this.pattern[0]["time"];
      this.$refs.timer.stopTimer();
    },
    pauseTimer: function() {
      this.state = "pause";
      this.$refs.timer.pauseTimer();
    },
    next: function() {
      this.state = "finish"
      this.position += 1
      if(this.position >= this.pattern.length){
          this.position = 0
      }
    }
  },
  created: function() {
    this.pattern.push({
      name: "Work1",
      time: "10"
    },
    {
      name: "Work2",
      time: "15"
    },
    {
      name: "break1",
      time: "5"
    });
    this.name = this.pattern[this.position]['name'];
    this.time = this.pattern[this.position]["time"];
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

#app > span > div > span {
  font-weight: bold;
  font-size: 1000%;
}
</style>
