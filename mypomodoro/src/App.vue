<template>
  <div id="app">
    <v-app id="inspire">
      <div id="header">
        <v-app-bar color="white-somoke  flat dense" dense dark>
          <v-toolbar-title>my Pomodoro Timer</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn icon disable>
            <v-icon>mdi-help-circle</v-icon>
          </v-btn>
          <v-btn icon href="https://github.com/EndoHizumi/myPomodoro/tree/develop">
            <v-icon>mdi-github</v-icon>
          </v-btn>
        </v-app-bar>
      </div>
      <v-content>
        <v-container fluid>
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
                <v-layout column justify-center>
                  <v-row>
                    <v-col></v-col>
                    <v-col>
                      <v-text-field
                        name="name"
                        label="name"
                        class="timername"
                        v-model="element.name"
                        v-on:input="onChange(element)"
                        v-bind:disabled="state == 'process' || state == 'pause'"
                      ></v-text-field>
                    </v-col>
                    <v-col>
                      <v-text-field
                        class="timervalue"
                        v-bind:disabled="state == 'process' || state == 'pause'"
                        type="number"
                        name="number"
                        label="hour"
                        v-model="element.hour"
                        v-on:input="onChange(element)"
                      />
                    </v-col>
                    <v-col>
                      <v-text-field
                        class="timervalue"
                        v-bind:disabled="state == 'process' || state == 'pause'"
                        type="number"
                        name="number"
                        label="minute"
                        v-model="element.minute"
                        v-on:input="onChange(element)"
                      />
                    </v-col>
                    <v-col>
                      <v-text-field
                        class="timervalue"
                        v-bind:disabled="state == 'process' || state == 'pause'"
                        type="number"
                        name="number"
                        label="second"
                        v-model="element.second"
                        v-on:input="onChange(element)"
                      />
                    </v-col>
                    <v-col></v-col>
                  </v-row>
                </v-layout>
              </div>
            </v-tab-item>
          </v-tabs-items>
          <div class="group_volume">
            <v-btn
              v-bind:disabled="state == 'process' || state == 'pause'"
              v-on:click="pattern[group]['data'].push({name:'task',hour:'0',minute:'0',second:'0'})"
            >
              <v-icon>mdi-plus</v-icon>
            </v-btn>
            <v-btn
              v-bind:disabled="state == 'process' || state == 'pause'"
              v-on:click="pattern[group]['data'].pop()"
            >
              <v-icon>mdi-minus</v-icon>
            </v-btn>
          </div>
        </v-container>
      </v-content>
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
      pattern: [
          {
            name: "time1",
            data: [
              {
                name: "Work1",
                hour: "0",
                minute: "30",
                second: "0"
              },
              {
                name: "break1",
                hour: "0",
                minute: "5",
                second: "0"
              }
            ]
          }
        ],
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
      let postion_data = this.pattern[this.group]["data"][this.position];
      this.name = postion_data["name"];
      this.time =
        postion_data.hour * 3600 +
        postion_data.minute * 60 +
        parseInt(postion_data.second);
      this.$refs.timer.startTimer();
    },
    stopTimer: function() {
      this.state = "stop";
      this.position = 0;
      let postion_data = this.pattern[this.group]["data"][this.position];
      this.name = postion_data["name"];
      this.time =
        postion_data.hour * 3600 +
        postion_data.minute * 60 +
        parseInt(postion_data.second);
      this.$refs.timer.stopTimer();
    },
    pauseTimer: function() {
      this.state = "pause";
      this.$refs.timer.pauseTimer();
    },
    next: function() {
      this.state = "finish";
      this.position += 1;
      if (this.position >= this.pattern[this.group]["data"].length) {
        this.position = 0;
      }
    },
    onChange: function(element) {
      this.name = element.name;
      this.time =
        Math.abs(element.hour) * 3600 +
        Math.abs(element.minute) * 60 +
        Math.abs(parseInt(element.second));
      if (Math.abs(element.second) > 59) {
        element.minute = parseInt(Math.abs(element.minute)) + 1;
        element.second = element.second - 60;
      }
      if (Math.abs(element.minute) > 59) {
        element.hour = parseInt(Math.abs(element.hour)) + 1;
        element.minute = element.minute - 60;
      }
    }
  },
  created: function() {
    var timer_pattern = JSON.parse(localStorage.getItem("timer_pattern"));
    if (timer_pattern != null) {
      this.pattern = timer_pattern;
    }
    let postion_data = this.pattern[this.group]["data"][this.position];
    this.name = postion_data["name"];
    this.time =
      postion_data.hour * 3600 +
      postion_data.minute * 60 +
      parseInt(postion_data.second);
  },
  watch:{
    pattern:{
      handler:function(){
        localStorage.setItem("timer_pattern", JSON.stringify(this.pattern));
        console.log("watch:pattern")
        console.log(localStorage)
      },
      deep:true
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
}

#app > span > div > span {
  font-weight: bold;
  font-size: 1000%;
}

.group_volume {
  margin-top: 20px;
}
</style>
