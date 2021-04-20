using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class HoursMinutes extends Ui.Drawable {


	function initialize(params) {
		Drawable.initialize(params);
	}
	
	
	function draw(dc) {
		drawHoursMinutes(dc);
	}


	function drawHoursMinutes(dc) {
	
		var clockTime = Sys.getClockTime();
		var formattedTime = App.getApp().getFormattedTime(clockTime.hour, clockTime.min);
		formattedTime[:amPm] = formattedTime[:amPm].toUpper();

		var hours = formattedTime[:hour];
//		var separator = ":";
		var minutes = formattedTime[:min];
//		var amPmText = formattedTime[:amPm];

//		var halfDCWidth = watchWidth / 2;
//		var halfDCHeight = (watchHeight / 2) /* + mAdjustY */; 

		// Centre combined hours and minutes text (not the same as right-aligning hours and left-aligning minutes).
		// Font has tabular figures (monospaced numbers) even across different weights, so does not matter which of hours or
		// minutes font is used to calculate total width. 
//		var totalWidth = dc.getTextWidthInPixels(hours + separator + minutes, Graphics.FONT_SYSTEM_NUMBER_THAI_HOT);
//		hoursHeight = dc.getFontHeight(Graphics.FONT_SYSTEM_NUMBER_THAI_HOT);
//		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
//		dc.drawLine(120,0,120,240);
//		var x = halfDCWidth - (totalWidth / 2);
		//System.println("xHours: "+x);
					
//		// Draw separator
		dc.setColor(separatorColor, Graphics.COLOR_TRANSPARENT);
		dc.drawText(
			120,
			87,
			Graphics.FONT_SYSTEM_NUMBER_HOT, 
			":",
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);

		var xDifference = dc.getTextWidthInPixels(":", Graphics.FONT_SYSTEM_NUMBER_HOT); 

		// Draw hours
		dc.setColor(hoursColor, Graphics.COLOR_TRANSPARENT);
		dc.drawText(
			120-xDifference,
			87,
			Graphics.FONT_SYSTEM_NUMBER_HOT,
			hours,
			Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
		);

		
		// Draw minutes
		dc.setColor(minutesColor, Graphics.COLOR_TRANSPARENT);
		dc.drawText(
			120+xDifference,
			87,
			//halfDCHeight,
			Graphics.FONT_SYSTEM_NUMBER_HOT, 
			minutes,
			Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
		);

		// If required, draw AM/PM after minutes, vertically centred.
		/*if (amPmText.length() > 0) {
			//dc.setColor(gThemeColour, Graphics.COLOR_TRANSPARENT);
			dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
			x += dc.getTextWidthInPixels(minutes, mMinutesFont);
			dc.drawText(
				x + AM_PM_X_OFFSET, // Breathing space between minutes and AM/PM.
				halfDCHeight,
				mSecondsFont,
				amPmText,
				Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
			);
		}*/
	}


	// Called to draw seconds both as part of full draw(), but also onPartialUpdate() of watch face in low power mode.
	// If isPartialUpdate flag is set to true, strictly limit the updated screen area: set clip rectangle before clearing old text
	// and drawing new. Clipping rectangle should not change between seconds.
//	function drawSeconds(dc, isPartialUpdate) {
//		if (mHideSeconds) {
//			return;
//		}
//		
//		var clockTime = Sys.getClockTime();
//		var seconds = clockTime.sec.format("%02d");
//
//		if (isPartialUpdate) {
//
//			dc.setClip(
//				mSecondsClipRectX + mSecondsClipXAdjust,
//				mSecondsClipRectY,
//				mSecondsClipRectWidth,
//				mSecondsClipRectHeight
//			);
//
//			// Can't optimise setting colour once, at start of low power mode, at this goes wrong on real hardware: alternates
//			// every second with inverse (e.g. blue text on black, then black text on blue).
//			//dc.setColor(gThemeColour, /* Graphics.COLOR_RED */ gBackgroundColour);
//			dc.setColor(Graphics.COLOR_RED, /* Graphics.COLOR_RED */ Graphics.COLOR_TRANSPARENT);	
//
//			// Clear old rect (assume nothing overlaps seconds text).
//			dc.clear();
//
//		} else {
//
//			// Drawing will not be clipped, so ensure background is transparent in case font height overlaps with another
//			// drawable.
//			//dc.setColor(gThemeColour, Graphics.COLOR_TRANSPARENT);
//			dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
//		}
//
//		dc.drawText(
//			mSecondsClipRectX + mSecondsClipXAdjust,
//			mSecondsY,
//			mSecondsFont,
//			seconds,
//			Graphics.TEXT_JUSTIFY_LEFT
//		);
//	}
}