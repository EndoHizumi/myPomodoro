<template>
  <div id="app">
    <v-app id="inspire">
      <div id="header">
        <v-app-bar color="white-somoke  flat dense" dense dark>
          <v-toolbar-title>my Pomodoro</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn icon disable>
            <v-icon >mdi-help-circle</v-icon>
          </v-btn>
          <v-btn icon href="https://github.com/EndoHizumi/myPomodoro/tree/develop">
            <v-icon>mdi-github</v-icon>
          </v-btn>
        </v-app-bar>
      </div>
      <v-card>
        <timer
          v-bind:name="name"
          v-bind:startTime="time"
          v-bind:state="state"
          ref="timer"
          v-on:finish="next"
        ></timer>
        <v-btn v-on:click="startTimer" v-if="state == 'stop' || state == 'finish'">
          <v-icon x-large>mdi-play</v-icon>
        </v-btn>
        <v-btn v-on:click="startTimer" v-if="state == 'pause'">
          <v-icon x-large>mdi-play</v-icon>
        </v-btn>
        <v-btn v-on:click="pauseTimer" v-if="state == 'process'">
          <v-icon x-large>mdi-pause</v-icon>
        </v-btn>
        <v-btn v-on:click="stopTimer" v-if="state == 'pause' || state == 'finish'">
          <v-icon x-large>mdi-stop</v-icon>
        </v-btn>
        <v-tabs v-model="tab" background-color="transparent" grow>
          <v-tab v-for="item in pattern" :key="item">{{ item['name'] }}</v-tab>
        </v-tabs>

        <v-tabs-items v-model="tab">
          <v-tab-item v-for="item in pattern" :key="item['id']">
            <div v-for="element in item['data']" :key="element['id']">
              {{element['name']}}:
              <input
                class="settime"
                v-bind:disabled="state == 'process' || state == 'pause'"
                type="number"
                name="number"
                v-bind:value="element.time"
                v-on:input="onChange($event,element)"
              />
            </div>
          </v-tab-item>
        </v-tabs-items>
      </v-card>
      <div class="group_volume">
        <v-btn v-bind:disabled="state == 'process' || state == 'pause'" v-on:click='pattern[group]["data"].push({name:"task",time:"0"})'><v-icon>mdi-plus</v-icon></v-btn>
        <v-btn v-bind:disabled="state == 'process' || state == 'pause'" v-on:click='pattern[group]["data"].pop()'><v-icon>mdi-minus</v-icon></v-btn>
      </div>
    </v-app>
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
      group: 0,
      tab: null
    };
  },
  components: {
    timer
  },
  methods: {
    startTimer: function() {
      this.state = "process";
      this.name = this.pattern[this.group]["data"][this.position]["name"];
      this.time = this.pattern[this.group]["data"][this.position]["time"];
      this.$refs.timer.startTimer();
    },
    stopTimer: function() {
      this.state = "stop";
      this.position = 0;
      this.name = this.pattern[this.group]["data"][0]["name"];
      this.time = this.pattern[this.group]["data"][0]["time"];
      this.$refs.timer.stopTimer();
    },
    pauseTimer: function() {
      this.state = "pause";
      this.$refs.timer.pauseTimer();
    },
    next: function() {
      this.state = "finish";
      this.position += 1;
      if (
        this.position >= this.pattern[this.group]["data"][this.position].length
      ) {
        this.position = 0;
      }
    },
    onChange: function(event, element) {
      element.time = event.target.value;
      this.name = element.name
      this.time = element.time;
    }
  },
  created: function() {
    this.pattern.push({
      name: "time1",
      data: [
        {
          name: "Work1",
          time: "1800"
        },
        {
          name: "break1",
          time: "300"
        }
      ]
    });
    this.name = this.pattern[this.group]["data"][this.position]["name"];
    this.time = this.pattern[this.group]["data"][this.position]["time"];
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
}

#app > span > div > span {
  font-weight: bold;
  font-size: 1000%;
}

.settime {
  margin-left: 50px;
  width: 50px !important;
}

.group_volume {
  margin-top: 20px;
}
</style>
