<template>
  <div id="app">
    <v-app id="inspire">
      <div id="header">
        <v-app-bar color="white-somoke  flat dense" dense dark>
          <v-app-bar-nav-icon v-on:click="draw = true"></v-app-bar-nav-icon>
          <v-toolbar-title>my Pomodoro Timer</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-menu offset-y :close-on-content-click="false">
            <template v-slot:activator="{ on }">
              <v-btn icon slot="activator" v-on="on">
                <v-icon>{{volume_icon}}</v-icon>
              </v-btn>
            </template>
            <v-list>
              <v-list-tile>
                <v-list-tile-title>
                  {{volume}}
                  <v-text-field name="name" id="id" type="range" v-model="volume"></v-text-field>
                </v-list-tile-title>
              </v-list-tile>
            </v-list>
          </v-menu>
          <v-btn icon disable>
            <v-icon>mdi-help-circle</v-icon>
          </v-btn>
          <v-btn icon href="https://github.com/EndoHizumi/myPomodoro">
            <v-icon>mdi-github</v-icon>
          </v-btn>
        </v-app-bar>
        <v-navigation-drawer width="250" v-model="draw" fixed temporary>
          <v-list>
            <v-list-item-group>
              <v-list-item v-on:click="draw = false">
                <v-list-item-icon>
                  <v-icon>mdi-menu</v-icon>
                </v-list-item-icon>
                <v-list-item-content>my Pomodoro Timer</v-list-item-content>
              </v-list-item>
              <v-divider></v-divider>
              <v-list-item v-on:click="importSetting()">
                <v-list-item-icon>
                  <v-icon>mdi-import</v-icon>
                </v-list-item-icon>
                <v-list-item-content>Import Setting</v-list-item-content>
              </v-list-item>
              <v-list-item v-on:click="exportSetting()">
                <v-list-item-icon>
                  <v-icon>mdi-export</v-icon>
                </v-list-item-icon>
                <v-list-item-content>Export Setting</v-list-item-content>
              </v-list-item>
              <v-list-item v-on:click="clearSetting()">
                <v-list-item-icon>
                  <v-icon>mdi-playlist-remove</v-icon>
                </v-list-item-icon>
                <v-list-item-content>Clear Setting</v-list-item-content>
              </v-list-item>
              <v-list-item>
                <v-switch
                  v-model="autoplay"
                  label="Auto Play"
                  v-on:change="showAlert(`AutoPlay: ${autoplay}`, 'info')"
                ></v-switch>
              </v-list-item>
            </v-list-item-group>
          </v-list>
        </v-navigation-drawer>
      </div>
      <v-content>
        <v-container fluid>
          <v-alert dismissible :value="alert_visible" type="success">{{alert_value}}</v-alert>
          <timer
            v-bind:name="name"
            v-bind:startTime="time"
            v-bind:state="state"
            v-bind:volume="volume"
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

          <v-tabs v-model="tab" grow>
            <v-btn icon v-on:click="removeTab()">
              <v-icon>mdi-minus</v-icon>
            </v-btn>
            <v-tab
              v-for="item in pattern"
              v-bind:key="item['group_id']"
              v-on:click="groupChange(item['group_id'])"
              v-on:dblclick="editTimerName()"
            >{{ item['name'] }}_{{item['group_id']}}</v-tab>
            <v-btn icon v-on:click="appendTab()">
              <v-icon>mdi-plus</v-icon>
            </v-btn>
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
                        min="0"
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
                        min="0"
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
                        min="0"
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
          group_id:0,
          name: "time1",
          volume: "100",
          autoplay: false,
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
      autoplay: false,
      position: 0,
      group: 0,
      tab: null,
      draw: false,
      alert: null,
      alert_visible: false,
      alert_state: "success",
      alert_value: "",
      volume_draw: false,
      volume: "0",
      volume_level_icons: {
        high: "mdi-volume-high",
        medium: "mdi-volume-medium",
        low: "mdi-volume-low",
        mute: "mdi-volume-off"
      }
    };
  },
  components: {
    timer
  },
  methods: {
    editTimerName: function() {
      this.pattern[this.group]["name"] = window.prompt(
        "",
        this.pattern[this.group]["name"]
      );
    },
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
      if (this.autoplay) {
        setTimeout(this.startTimer, 500);
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
    },
    exportSetting: function() {
      var blob = new Blob([JSON.stringify(this.pattern)], {
        type: "application/json"
      });
      var filename = "timer_pattern.json";
      var link = document.createElement("a");
      link.href = window.URL.createObjectURL(blob);
      link.download = filename;
      link.click();
    },
    importSetting: function() {
      const file = document.createElement("input");
      file.type = "file";
      file.accept = ".json";
      file.click();
      file.onchange = () => {
        console.log(file.files[0]);
        // validate

        // load to this.pattern
        const reader = new FileReader();
        reader.onload = e => {
          this.pattern = JSON.parse(e.target.result);
          this.draw = false;
          let postion_data = this.pattern[this.group]["data"][this.position];
          this.name = postion_data["name"];
          this.time =
            postion_data.hour * 3600 +
            postion_data.minute * 60 +
            parseInt(postion_data.second);
          this.volume = this.pattern[this.group]["volume"]
            ? this.pattern[this.group]["volume"]
            : "100";
          this.autoplay = this.pattern[this.group]["autoplay"]
            ? this.pattern[this.group]["autoplay"]
            : false;
        };
        reader.readAsText(file.files[0]);
      };
    },
    clearSetting: function() {
      localStorage.clear();
      this.showAlert("clear your setting", "success");
    },
    showAlert: function(message, state) {
      this.draw = false;
      this.alert_value = message;
      this.alert_visible = true;
      this.alert_state = state;
      setTimeout(() => {
        this.alert_visible = false;
      }, 1000);
    },
    appendTab: function() {
      this.pattern.push({
        group_id: this.pattern.length,
        name: `time${this.pattern.length}`,
        volume: "100",
        autoplay: false,
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
      });
    },
    removeTab: function() {
      if (this.pattern.length > 1) {
        this.pattern.pop();
      }
    },
    groupChange: function(e){
      this.group = e
    }
  },
  created: function() {
    this.$ga.page("/");
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
    this.volume = this.pattern[this.group]["volume"]
      ? this.pattern[this.group]["volume"]
      : "100";
    this.autoplay = this.pattern[this.group]["autoplay"]
      ? this.pattern[this.group]["autoplay"]
      : false;
  },
  computed: {
    volume_icon: function() {
      let volume_level = "";
      if (this.volume >= 70) {
        volume_level = "high";
      } else if (this.volume >= 50) {
        volume_level = "medium";
      } else if (this.volume < 50 && this.volume > 0) {
        volume_level = "low";
      } else if (this.volume <= 0) {
        volume_level = "mute";
      }
      return this.volume_level_icons[volume_level];
    }
  },
  watch: {
    pattern: {
      handler: function() {
        localStorage.setItem("timer_pattern", JSON.stringify(this.pattern));
      },
      deep: true
    },
    volume: function() {
      this.pattern[this.group]["volume"] = this.volume;
      localStorage.setItem("timer_pattern", JSON.stringify(this.pattern));
    },
    autoplay: function() {
      this.pattern[this.group]["autoplay"] = this.autoplay;
      localStorage.setItem("timer_pattern", JSON.stringify(this.pattern));
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
}

#app > span > div > span {
  font-weight: bold;
  font-size: 1000%;
}

.group_volume {
  margin-top: 20px;
}
</style>
