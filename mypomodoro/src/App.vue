<template>
  <div id="app">
    <timer startTime="180" v-bind:state="state" ref="timer"></timer>
    <button v-on:click="startTimer" v-if="state == 'stop'">start</button>
    <button v-on:click="startTimer" v-if="state == 'pause'">restart</button>
    <button v-on:click="pauseTimer" v-if="state == 'process'">pause</button>
    <button v-on:click="stopTimer" v-if="state == 'process'">stop</button>
  </div>
</template>

<script>
import timer from './components/timer'
export default {
  name: "App",
  data: function(){
    return{
      state:"stop"
    }
  },
  components:{
    timer
  },
  methods: {
   startTimer: function() {
     this.state = "process"
     this.$refs.timer.startTimer()
   },
   stopTimer: function() {
     this.state = "stop"
     this.$refs.timer.stopTimer()
   },
   pauseTimer: function() {
     this.state = "pause"
     this.$refs.timer.pauseTimer()
   },
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
