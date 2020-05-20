<template>
    <div id="display">
      <span id="name">{{this.name}}</span>
      <span id="timer" v-bind:class=state>{{this.display_hour}}:{{this.display_minute}}:{{this.display_second}}</span>
    </div>
</template>
<script>
export default {
  data: function() {
    return {
      timer: null,
      pickTime: 0,
    };
  },
  props:{
      name: String,
      state: String,
      startTime: String
  },
  computed: {
    display_hour: function(){
        let hour =  Math.floor(this.pickTime / 3600)
        return this.zeroPadding(hour)
    },
    display_minute: function() {
        let minute = Math.floor(this.pickTime / 60)
        return this.zeroPadding(minute)
    },
    display_second: function() {
        let second = Math.floor(this.pickTime - (this.display_hour * 3600 + this.display_minute * 60))
        return this.zeroPadding(second)
    }
  },
  mounted: function(){
    this.pickTime = parseInt(this.startTime);
  },
  methods: {
    startTimer: function() {
      if(this.state == "process"){
          return
      }
      if (this.state == 'stop' || this.state == 'finish'){
        this.pickTime = parseInt(this.startTime);
      }
      this.timer = setInterval(() => this.countdown(), 1000);
    },
    stopTimer: function() {
      clearInterval(this.timer);
      this.timer = null;
    },
    pauseTimer: function() {
      clearInterval(this.timer);
    },
    zeroPadding: time => {
      return (time < 10 ? "0" : "") + time;
    },
    countdown: function() {
        if(this.pickTime > 1){
            this.pickTime--;
        }else{
            this.pickTime = 0
            this.stopTimer()
            this.$emit('finish')
        }
    }
  }
};
</script>

<style>
#name{
  display: inline-block;
  font-weight: bold;
  font-size: 300%
}

#timer{
    font-weight: bold;
    font-size: 600%;
    display:inline-block;
}

@keyframes blink {
  75% { opacity: 0.0; }
}

.finish {
  /* text-decoration: blink; の代わりに以下の指定を入れる */
  color: red;
  animation: blink 0.8s step-end infinite;
}
</style>