/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {

    data: {
        songs: {
            "valerie": {time: 126, artist: null},
            "last night": {time: 126, artist: "The Strokes"},
            "everybody needs somebody to love": {time: null, artist: null},
            "sweet dreams": {time: 126, artist: null},
            "7 nation army": {time: 126, artist: "The White Stripes"},
            "song 2": {time: 126, artist: "Blur"},
            "i believe": {time: 126, artist: "The Darkness"}
        },

        songNames: [
            "valerie",
            "last night",
            "everybody needs somebody to love",
            "sweet dreams",
            "7 nation army",
            "song 2",
            "i believe"
        ],

        groupNames: [
          "valerie, last night mix",
          "sweet dreams mix"
        ],

        groups: {
          "valerie, last night mix": [
            "valerie",
            "last night"
          ],
          "sweet dreams mix": [
            "sweet dreams",
            "7 nation army"
          ]
        },

        set_lists: {
            "set list 1": [
                "sweet dreams mix",
                "7 nation army",
                "valerie",
                "i believe",
                "song 2"
            ],
            "set list 2": [
                "7 nation army",
                "valerie, last night mix",
                "song 2"
            ],
        }

    },

    // Application Constructor
    initialize: function() {
        this.bindEvents();        
        this.init();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);        
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');        
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    },

    init: function() {
        console.log("hello init");
        
        $.mobile.defaultPageTransition = "slide";
        // stop the 300ms delay on clicks
        $(function() {
            FastClick.attach(document.body);
        });
        
        // stop the heading creeping up too high on ios7
        if (navigator.userAgent.match(/(iPad.*|iPhone.*|iPod.*);.*CPU.*OS 7_\d/i)) {
            $("body").addClass("ios7");            
            //$("body").append('');
        }

        var _this = this; 
        var k;
        for (k in this.data.set_lists) {
          value = this.data.set_lists[k];
          $("#set-list-main").append('<a href="#set-list-display" id="' + k + '" class="set-list-button ui-btn ui-corner-all">' + k + '</a>');                             
        }
        
        $('#set-list-display').bind('pageinit', function() {
          console.log("page-init!!!!");
        });
      
        $( ".set-list-button" ).on( "click", function(e) {
            console.log("clicked on a button", e.target.id);          
            var key = e.target.id;
            $("#set-list-header").text(key);
            var songs = _this.data.set_lists[key];
            var str = "";
            for (var i=0; i<songs.length; i++) {
              console.log("getting list item", i, songs.length);
              str += _this.getListItem(songs[i])
            }
            parent = $("#set-list-display-main")
            parent.empty()            
            parent.append(str)                                    
            $(".collapse-header").listview().listview("refresh")            
            parent.find('li[data-role=collapsible]').collapsible({refresh:true}); // refresh the collapsible
        });

        this.addSongs();
        this.addGroups();

        $( ".add-song" ).on( "click", function() {
          // remove all items from the list
          while ($("#song-list").children().length > 0) {
            $("#song-list").children()[0].remove();
          }

          var listitem = $("input[name='song-title']")[0].value;
          _this.data.songNames.push(listitem.toLowerCase());
          _this.addSongs();          
          $("#song-list").listview("refresh");
        });

        $( ".add-group" ).on( "click", function() {
          // remove all items from the list
          while ($("#group-list").children().length > 0) {
            $("#group-list").children()[0].remove();
          }

          var listitem = $("input[name='group-title']")[0].value;
          _this.data.groupNames.push(listitem.toLowerCase());
          _this.addGroups();
          $("#group-list").listview("refresh");
        });
        $( "#set-list-display-main" ).sortable();
        $( "#set-list-display-main" ).disableSelection();
        // Refresh list to the end of sort to have a correct display
        $( "#set-list-display-main" ).bind( "sortstop", function(event, ui) {
          $("#set-list-display-main").listview('refresh');
        });
    },
  
    getListItem: function(key) {
      var str = "";
      var songs;
      if (songs = this.data.groups[key]) {
        str += '<li data-role="collapsible" data-iconpos="right" data-inset="false"><h2>' + key + '</h2><ul data-role="listview" class="collapse-header" data-theme="b">'
        for (i=0; i<songs.length; i++) {
          str += '<li>' + songs[i] + '</li>'
        }
        str += "</ul></li>"
      } else {        
        str += '<li>' + key + '</li>'
      }      
      return str;      
    },
  
    addSongs: function() {
      songs = this.data.songNames.sort();
      for (i=0; i<songs.length; i++) {
          $("#song-list").append('<li><a href="index.html">' + songs[i] +'</a></li>')
      }
    },

    addGroups: function() {
      console.log("add groups");
      groups = this.data.groupNames.sort();
      for (i=0; i<groups.length; i++) {
          groupName = groups[i]
          songs = this.data.groups[groupName]
          str = '<ol data-role="listview" data-theme="b">'
          for (j=0; j<songs.length; j++) {
            str += '<li><a href="#">' + songs[j] + '</a></li>'
          }
          str += '</ol>'
          $("#group-list").append('<div data-role="collapsible" data-iconpos="right" data-inset="false"><h3>' + groupName + '</h3>' + str + '</div>')
      }
    }
};


