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
      pickTime: 0
    };
  },
  props: {
    name: String,
    state: String,
    startTime: String
  },
  computed: {
    display_time: function() {
      let input = this.pickTime
      let hour = this.zeroPadding(Math.floor(input / 3600));
      input %= 3600 
      let minute = this.zeroPadding(Math.floor(input / 60));
      input %= 60 
      let second = this.zeroPadding(input);
      return hour+":"+minute+":"+second
    },
  },
  watch: {
    startTime: function() {
      this.pickTime = parseInt(this.startTime);
    },
    state: function() {
      if (this.state == "finish") {
        document.getElementById("alarm").play();
      }else{
        let audio = document.getElementById("alarm");
        audio.pause();
        audio.currentTime = 0;
      }
    }
  },
  mounted: function() {
    this.pickTime = parseInt(this.startTime);
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