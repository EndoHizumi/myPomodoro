<template>
    <div id="display">{{this.display_hour}}:{{this.display_minute}}:{{this.display_second}}</div>
</template>
<script>
export default {
  data: function() {
    return {
      timer: null,
      pickTime: 0
    };
  },
  props:{
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
      if(this.pickTime == 0){
          this.pickTime = parseInt(this.startTime);
      }
      this.timer = setInterval(() => this.countdown(), 1000);
    },
    stopTimer: function() {
      clearInterval(this.timer);
      this.timer = null;
      this.pickTime = this.startTime;
    },
    pauseTimer: function() {
      clearInterval(this.timer);
    },
    zeroPadding: time => {
      return (time < 10 ? "0" : "") + time;
    },
    countdown: function() {
        if(this.pickTime > 0){
            this.pickTime--;
        }else{
            this.pickTime = 0
            this.stopTimer()
        }
    }
  }
};
</script>

<style>
#display{
    font-weight: bold;
    font-size: 500%;
}
</style>