using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time;
//using Toybox.Time.Gregorian;

var iconsFont;
//var batteryFont;
var dataFont;
var isSleeping;


class SimpleGarminLikeWFView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
        Application.getApp().onSettingsChanged();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
       	
//     	watchHeight = dc.getHeight();
       	//System.println("watchHeight: "+watchHeight);
//		watchWidth = dc.getWidth();
		//System.println("watchWidth: "+watchWidth);
		iconsFont = WatchUi.loadResource(Rez.Fonts.IconsFont);
//		batteryFont = WatchUi.loadResource(Rez.Fonts.BatteryFont);
		dataFont = WatchUi.loadResource(Rez.Fonts.NormalFont);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    //! Called each minute or after a geature
    // Update the view
    function onUpdate(dc) {

		// Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        if (((sleepOption == 1) && (isSleeping == 0)) || (sleepOption == 0)) { // While NOT sleeping OR Screensaver Mode is OFF
        	// Call BT icon display
        	drawBluetooth(dc, System.getDeviceSettings().phoneConnected);
        
	        // Manage Alarm icon display
	        if (System.getDeviceSettings().alarmCount > 0) {
	        	drawAlarm(dc);
	        }
	        
	        // Manage Notifications display      
	        if (System.getDeviceSettings().notificationCount > 0)  {
	        	drawNotifications(dc, System.getDeviceSettings().notificationCount);
	        }
	        
	    	// Manage DND display
	    	if (System.getDeviceSettings().doNotDisturb) {
	    		drawDND(dc);
	    	}
	        
	        // Manage Battery display
	        drawBattery(dc, System.getSystemStats().battery);
	        
	        // Manage Move Alert
	        drawMoveAlert(dc);
	       
		    // Call Active Minutes display
		    drawActiveMinutes(dc);        
	        
	        // Call Steps circle display function
			drawSteps(dc);
		}
		else { // While sleeping and screenSaver mode is ON
			if (System.getDeviceSettings().phoneConnected == 0) { //draw BT icon in sleeping mode if disconnected
				drawBluetooth(dc, 0);
			}
		}        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	isSleeping = 0;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	isSleeping = 1;
    }

	function drawBluetooth(dc, phoneConnected)  { //! Manage BT icon display

		var x = 90; //watchWidth*0.43;
		var y = 40; //watchHeight*0.15;
		
				
		if (phoneConnected == 1) {
			dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
			//System.println("BT ON");
		}
		else {
			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			//System.println("BT OFF");
		}
		
		
		dc.drawText(
			x,
			y,
			iconsFont,
			"8", // BT characters
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);
	}//! end of drawBluetooth()
	
	function drawAlarm(dc)  { //! Manage Alarms icon display

		var x = 152; //watchWidth*0.7;
		var y = 40; //watchHeight*0.15;
		
		
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
		
		dc.drawText(
			x,
			y,
			iconsFont,
			":", // Alarm characters
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);
	}//! end of drawAlarm
	
	function drawNotifications(dc, nb)  { //! Notifications icon display management

		var x = 57; //watchWidth*0.3;
		var y = 40; //watchHeight*0.15;
		
		
		dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
		
		//! no notification count for this WF
		dc.drawText(
			x-18,
			y,
			Graphics.FONT_XTINY,
			nb, // Notification characters
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);
//		
//		if (nb < 10) { x += 18; }  // shift x to display notif number
//		else { x+= 25; }   
		
		dc.drawText(
			x,
			y,
			iconsFont,
			"5", // Notification characters
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);
		
	}//! end of drawNotifications()
	
	function drawBattery(dc, nb)  { //! Battery level display management

		var x = 120; //watchWidth*0.57;
		var y = 16; //watchHeight*0.15;
		
		//System.println("x: "+x+" y: "+y);
		if (nb >= 10) {
			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y, dataFont, nb.format("%2d")+" %", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		}
		else {
			dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
			dc.drawRoundedRectangle(x-12, y-4, 24, 12, 5);
			//dc.setPenWidth(16);
			//dc.drawCircle(x, y, 8);
			dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
			dc.drawText(x, y, dataFont, nb.format("%1d")+" %", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		}
	}//! end of drawBattery()


	function drawDND(dc) {
	
		var x = 184;
		var y = 37;
	
		dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
		dc.drawText(x, y, dataFont, "Z", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(x+6, y+1, dataFont, "z", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(x+12, y+5, dataFont, "z", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	} //! End drawDND
	
	
	function drawMoveAlert(dc) { //! Move Alert Arc from 07h to 08h00 => 0 to 5 level 
	
//	var topMoves = 270; // 0% => 06 o'clock
	var myMoves = ActivityMonitor.getInfo().moveBarLevel;
	var rLocal = 100;
	
	dc.setPenWidth(8);
	
	dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
	dc.drawArc(120, 120, 105, Graphics.ARC_CLOCKWISE, 245, 195);
	dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
	dc.drawText(10, 130, dataFont, "move", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
	
	
	if (myMoves > 0) {
		switch (myMoves) {
			
			case 1:	 // First level of movebar detected: draw points
					dc.drawArc(120, 120, 105, Graphics.ARC_CLOCKWISE, 245, 235);
//					for (var i=245 ; i>=235 ; i-=2) {
//						dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, i, i-1);
//					}
					break;
		
			case 2: // Second level of movebar detected
					dc.drawArc(120, 120, 105, Graphics.ARC_CLOCKWISE, 245, 225);
//					for (var i=245 ; i>=235 ; i-=2) {
//						dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, i, i-1);
//					}
//					for (var i=234 ; i>=225 ; i-=3) {
//						dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, i, i-2);
//					}
					break; 
			
			case 3: // 3rd level
					dc.drawArc(120, 120, 105, Graphics.ARC_CLOCKWISE, 245, 215);
//					for (var i=245 ; i>=235 ; i-=2) {
//						dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, i, i-1);
//					}
//					for (var i=234 ; i>=225 ; i-=3) {
//						dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, i, i-2);
//					}
//					dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, 223, 220);
//					dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, 218, 215);	
					break;
		
			case 4: // 4th level
					dc.drawArc(120, 120, 105, Graphics.ARC_CLOCKWISE, 245, 205);
//					for (var i=245 ; i>=235 ; i-=2) {
//						dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, i, i-1);
//					}
//					for (var i=234 ; i>=225 ; i-=3) {
//						dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, i, i-2);
//					}
//					dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, 223, 220);
//					dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, 218, 215);
//					dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, 214, 206);
					break;
		
			case 5: // 5th level
					dc.drawArc(120, 120, 105, Graphics.ARC_CLOCKWISE, 245, 195);
//					for (var i=245 ; i>=235 ; i-=2) {
//						dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, i, i-1);
//					}
//					for (var i=234 ; i>=225 ; i-=3) {
//						dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, i, i-2);
//					}
//					dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, 223, 220);
//					dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, 218, 215);
//					dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, 214, 206);
//					dc.drawArc(120, 120, 110, Graphics.ARC_CLOCKWISE, 205, 195);
					break;
			}
		}
	} //! End of Move Alert Arc
	
	
	function drawActiveMinutes(dc) { //! Weekly Active Minutes column display management
	
		var wamIndex = 295 + ActivityMonitor.getInfo().activeMinutesWeek.total * 50 / ActivityMonitor.getInfo().activeMinutesWeekGoal;
		
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(120, 120, 105, Graphics.ARC_COUNTER_CLOCKWISE, 295, 345);
		dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
		dc.drawText(230, 130, dataFont, "wam", Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
		
		if (wamIndex > 295) {
			if (wamIndex > 345) { wamIndex = 345; }
			dc.drawArc(120, 120, 105, Graphics.ARC_COUNTER_CLOCKWISE, 295, wamIndex);
		}
		
	} //! End of drawActiveMinutes()

	
	function drawSteps(dc) { //! Steps column display management
	
		var mySteps = ActivityMonitor.getInfo().steps;	
		var stepsX = 240 - 300 * mySteps / ActivityMonitor.getInfo().stepGoal;
		
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(120, 200, 30, Graphics.ARC_CLOCKWISE, 240, 300);
		dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
		dc.drawText(120, 225, iconsFont, "0", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
		if (mySteps > 20) {
			if (stepsX < -60) { stepsX = -60;}
			if (stepsX > 0) {
				dc.drawArc(120, 200, 30, Graphics.ARC_CLOCKWISE, 240, stepsX);
			}
			else {
				dc.drawArc(120, 200, 30, Graphics.ARC_CLOCKWISE, 240, 360+stepsX);
			}
		}
		
		dc.drawText(120, 200, dataFont, ActivityMonitor.getInfo().steps, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		
	} //! end of drawSteps


//	function drawCalories(dc) { //! Daily calories display management 
//		
//		var info = ActivityMonitor.getInfo();
//       	if (info has :calories) {
//       		var caloriesBurnt =  info.calories;
//       		 
//            //var activeCalories = calculateCalories(info.calories);
//            
//            if ((totalCalories == null) || (totalCalories == 0)) {
//            	totalCalories = 2200;
//            } 
//            
//            //System.println("totalCalories: "+totalCalories);
//            var caloriesY = caloriesBurnt * 75 / totalCalories;
//		
//			if (caloriesY >= 75) {
//				caloriesY = 75; // Max height of column is 80 pixels
//				if (columnColor == 1) { // Change color of column if target reached
//					dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
//					dc.fillRoundedRectangle(0, 240-caloriesY, 85, 75, 8); // 85 pixels width for 1st column 
//					dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
//					dc.drawText(55, 240-60, dataFont, caloriesBurnt, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER );
//					dc.drawText(55, 240-35, iconsFont, "6", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER );
//				}
//				else {
//					dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
//					dc.fillRoundedRectangle(0, 240-caloriesY, 85, 75, 8); // 85 pixels width for 1st column 
//					dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
//					dc.drawText(55, 240-60, dataFont, caloriesBurnt, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER );
//					dc.drawText(55, 240-35, iconsFont, "6", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER );
//				}
//			}
//			else {
//				if (caloriesY >= 50) {
//					dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
//					dc.fillRoundedRectangle(0, 240-caloriesY, 85, 75, 8); // 85 pixels width for 1st column 
//					dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
//					dc.drawText(55, 240-35, iconsFont, "6", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER );
//				}
//				else {
//					dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
//					dc.fillRoundedRectangle(0, 240-caloriesY, 85, 75, 8); // 85 pixels width for 1st column
//				}
//			}
//		}
//	} //! End of drawCalories()


//	private function calculateCalories(calories) { // Calculate theorical daily calories burn 
//        if (calories == null) {
//            return 0;
//        }
//            
//        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);     
//        var profile = UserProfile.getProfile();
//        var age = today.year - profile.birthYear;
//        var weight = profile.weight / 1000.0;
//
//        var restCalories = 0;
//        if (profile.gender == UserProfile.GENDER_MALE) {
//            restCalories = 5.2 - 6.116 * age + 7.628 * profile.height + 12.2 * weight;
//        }
//        else {
//            restCalories = -197.6 - 6.116 * age + 7.628 * profile.height + 12.2 * weight;
//        }
//        
//        restCalories = Math.round((today.hour * 60 + today.min) * restCalories / 1440 ).toNumber();
//        System.println("restCalories: "+restCalories);
//        
//        var activeCalories = calories - restCalories;
//        activeCalories = activeCalories < 0 ? 0 : activeCalories;
//        
//        // return type == ACTIVE_CALORIES ? activeCalories : restCalories;
//        System.println("activeCalories: "+activeCalories);
//        return activeCalories;
//    } //! End of calculateCalories()

}
