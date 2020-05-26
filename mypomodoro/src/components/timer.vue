<template>
  <div id="display">
    <span id="name">{{this.name}}</span>
    <span id="timer" v-bind:class="state">{{this.display_time}}</span>
    <audio id="alarm" src="./sound/pager.mp3" loop></audio>
  </div>
</template>
<script>
export default {
  data: function() {
    return {
      timer: null,
      pickTime: 0,
      vibrate: null
    };
  },
  props: {
    name: String,
    state: String,
    startTime: String,
    volume: String
  },
  computed: {
    display_time: function() {
      let input = this.pickTime;
      let hour = this.zeroPadding(Math.floor(input / 3600));
      input %= 3600;
      let minute = this.zeroPadding(Math.floor(input / 60));
      input %= 60;
      let second = this.zeroPadding(input);
      return hour + ":" + minute + ":" + second;
    }
  },
  watch: {
    startTime: function() {
      this.pickTime = parseInt(this.startTime);
    },
    state: function() {
      if (this.state == "finish") {
        document.getElementById("alarm").play();
        this.vibrate = setInterval(() => navigator.vibrate([200, 100, 200, 100, 200, 100]), 900);
      }else{
        let audio = document.getElementById("alarm");
        audio.pause();
        clearInterval(this.vibrate)
        audio.currentTime = 0;
      }
    },
    volume: function(){
      document.getElementById("alarm").volume=this.volume/100;
    }
  },
  mounted: function() {
    this.pickTime = parseInt(this.startTime);
    document.getElementById("alarm").volume=this.volume;
    navigator.vibrate(1);
  },
  methods: {
    startTimer: function() {
      if (this.state == "process") {
        return;
      }
      if (this.state == "stop" || this.state == "finish") {
        this.pickTime = parseInt(this.startTime);
      }
      this.timer = setInterval(() => this.countdown(), 1000);
    },
    stopTimer: function() {
      clearInterval(this.timer);
      this.timer = null;
      this.pickTime = parseInt(this.startTime);
    },
    pauseTimer: function() {
      clearInterval(this.timer);
    },
    zeroPadding: time => {
      return (time < 10 ? "0" : "") + time;
    },
    countdown: function() {
      if (this.pickTime > 1) {
        this.pickTime--;
      } else {
        this.pickTime = 0;
        clearInterval(this.timer);
        this.$emit("finish");
      }
    }
  }
};
</script>

<style>
#name {
  display: block;
  font-weight: bold;
  font-size: 300%;
}

#timer {
  font-weight: bold;
  font-size: 500%;
  display: block;
}

@keyframes blink {
  75% {
    opacity: 0;
  }
}

.finish {
  /* text-decoration: blink; の代わりに以下の指定を入れる */
  color: red;
  animation: blink 0.8s step-end infinite;
}
</style>