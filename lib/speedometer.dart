import 'dart:html';
import 'dart:math' as Math;

class Speedometer {
  final CanvasElement canvas;
  final CanvasRenderingContext2D ctx;
  final int centerX;
  final int centerY;
  final int radius;
  final int outerRadius;
  int levelRadius;
  Speedometer(canvas, {this.centerX: 210, this.centerY: 210, this.radius: 200, this.outerRadius: 200})
      : canvas = canvas,
        ctx = canvas.context2D {
    levelRadius = radius - 10;
  }
  void draw(double speed) {
    _drawOuterMetalicArc();
    _drawInnerMetalicArc();
    _drawBackground();
    _drawSmallTickMarks();
    _drawLargeTickMarks();
    _drawSpeedometerColourArc();
    _drawNeedle(speed);
  }

  _drawOuterMetalicArc() {
    ctx.beginPath();
    ctx.fillStyle = "rgb(127,127,127)";
    ctx.arc(centerX, centerY, radius, 0, Math.PI, true);
    ctx.fill();
  }

  _drawInnerMetalicArc() {
    ctx.beginPath();
    ctx.fillStyle = "rgb(255,255,255)";
    ctx.arc(centerX, centerY, (radius / 100) * 90, 0, Math.PI, true);
    ctx.fill();
  }

  _drawBackground() {
    ctx.globalAlpha = 0.2;
    ctx.fillStyle = "rgb(255,255,255)";
    for (var i = 170; i < 180; i++) {
      ctx.beginPath();
      ctx.arc(centerX, centerY, 1 * i, 0, Math.PI, true);
      ctx.fill();
    }
  }

  _drawSmallTickMarks() {
    var tickvalue = levelRadius - 8;
    var iTick = 0;
    var iTickRad = 0;
    _applyDefaultContextSettings();
    for (iTick = 10; iTick < 180; iTick += 20) {
      iTickRad = _degToRad(iTick);
      var onArchX = radius - (Math.cos(iTickRad) * tickvalue);
      var onArchY = radius - (Math.sin(iTickRad) * tickvalue);
      var innerTickX = radius - (Math.cos(iTickRad) * radius);
      var innerTickY = radius - (Math.sin(iTickRad) * radius);
      var fromX = (centerX - radius) + onArchX;
      var fromY = (centerY - radius) + onArchY;
      var toX = (centerX - radius) + innerTickX;
      var toY = (centerY - radius) + innerTickY;
      _drawLine(alpha: 0.6, lineWidth: 3, fillStyle: "rgb(127,127,127)", fromX: fromX, fromY: fromY, toX: toX, toY: toY);
    }
  }

  _drawLargeTickMarks() {
    var tickvalue = levelRadius - 8, iTick = 0, iTickRad = 0, innerTickY, innerTickX, onArchX, onArchY, fromX, fromY, toX, toY;
    _applyDefaultContextSettings();
    tickvalue = levelRadius - 2;
    for (iTick = 20; iTick < 180; iTick += 20) {
      iTickRad = _degToRad(iTick);
      onArchX = radius - (Math.cos(iTickRad) * tickvalue);
      onArchY = radius - (Math.sin(iTickRad) * tickvalue);
      innerTickX = radius - (Math.cos(iTickRad) * radius);
      innerTickY = radius - (Math.sin(iTickRad) * radius);
      fromX = (centerX - radius) + onArchX;
      fromY = (centerY - radius) + onArchY;
      toX = (centerX - radius) + innerTickX;
      toY = (centerY - radius) + innerTickY;
      _drawLine(alpha: 0.6, lineWidth: 3, fillStyle: "rgb(127,127,127)", fromX: fromX, fromY: fromY, toX: toX, toY: toY);
    }
  }

  _applyDefaultContextSettings() {
    ctx.lineWidth = 2;
    ctx.globalAlpha = 0.5;
    ctx.strokeStyle = "rgb(255, 255, 255)";
    ctx.fillStyle = 'rgb(255,255,255)';
  }

  double _degToRad(angle) => ((angle * Math.PI) / 180);
  _drawLine({alpha, int lineWidth, fillStyle, fromX, fromY, toX, toY}) {
    ctx.beginPath();
    ctx.globalAlpha = alpha;
    ctx.lineWidth = lineWidth;
    ctx.fillStyle = fillStyle;
    ctx.strokeStyle = fillStyle;
    ctx.moveTo(fromX, fromY);
    ctx.lineTo(toX, toY);
    ctx.stroke();
  }

  _drawTextMarkers() {
    var innerTickX = 0, innerTickY = 0, iTick = 0, iTickToPrint = 0;
    _applyDefaultContextSettings();
    ctx.font = 'italic 10px sans-serif';
    ctx.textBaseline = 'top';
    ctx.beginPath();
    for (iTick = 10; iTick < 180; iTick += 20) {
      innerTickX = radius - (Math.cos(_degToRad(iTick)) * radius);
      innerTickY = radius - (Math.sin(_degToRad(iTick)) * radius);
      if (iTick <= 10) {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX, (centerY - radius - 12) + innerTickY + 5);
      } else if (iTick < 50) {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX - 5, (centerY - radius - 12) + innerTickY + 5);
      } else if (iTick < 90) {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX, (centerY - radius - 12) + innerTickY);
      } else if (iTick == 90) {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX + 4, (centerY - radius - 12) + innerTickY);
      } else if (iTick < 145) {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX + 10, (centerY - radius - 12) + innerTickY);
      } else {
        ctx.fillText(iTickToPrint.toString(), (centerX - radius - 12) + innerTickX + 15, (centerY - radius - 12) + innerTickY + 5);
      }
      iTickToPrint += 10;
    }
    ctx.stroke();
  }

  _drawSpeedometerColourArc() {
    var startOfGreen = 10, endOfGreen = 200, endOfOrange = 280;
    _drawSpeedometerPart(1.0, "rgb(0, 153, 37)", startOfGreen);
    _drawSpeedometerPart(0.9, "rgb(238, 178, 17)", endOfGreen);
    _drawSpeedometerPart(0.9, "rgb(213, 25, 37)", endOfOrange);
  }

  _drawSpeedometerPart(double alphaValue, String strokeStyle, int startPos) {
    ctx.beginPath();
    ctx.globalAlpha = alphaValue;
    ctx.lineWidth = 5;
    ctx.strokeStyle = strokeStyle;
    ctx.arc(centerX, centerY, levelRadius, Math.PI + (Math.PI / 360 * startPos), 0 - (Math.PI / 360 * 10), false);
    ctx.stroke();
  }

  _drawNeedleDial(double alphaValue, String strokeStyle, String fillStyle) {
    ctx.globalAlpha = alphaValue;
    ctx.lineWidth = 3;
    ctx.strokeStyle = strokeStyle;
    ctx.fillStyle = fillStyle;
    for (var i = 0; i < 30; i++) {
      ctx.beginPath();
      ctx.arc(centerX, centerY, i, 0, Math.PI, true);
      ctx.fill();
      ctx.stroke();
    }
  }

  _drawNeedle(double speed) {
    var iSpeedAsAngle = _convertSpeedToAngle(speed), iSpeedAsAngleRad = _degToRad(iSpeedAsAngle), innerTickX = radius - (Math.cos(iSpeedAsAngleRad) * 20), innerTickY = radius - (Math.sin(iSpeedAsAngleRad) * 20), fromX = (centerX - radius) + innerTickX, fromY = (centerY - radius) + innerTickY, endNeedleX = radius - (Math.cos(iSpeedAsAngleRad) * radius), endNeedleY = radius - (Math.sin(iSpeedAsAngleRad) * radius), toX = (centerX - radius) + endNeedleX, toY = (centerY - radius) + endNeedleY;
    ctx.globalAlpha = 1.0;
    _drawLine(alpha: 0.6, lineWidth: 15, fillStyle: "rgba(255,0,0, 255)", fromX: fromX, fromY: fromY - 5, toX: toX, toY: toY);
    _drawNeedleDial(0.8, "rgb(127, 127, 127)", "rgb(255,255,255)");
    _drawNeedleDial(0.4, "rgb(127, 127, 127)", "rgb(127,127,127)");
  }

  double _convertSpeedToAngle(double speed) {
    var iSpeed = (speed / 10), iSpeedAsAngle = ((iSpeed * 20) + 10) % 180;
    if (iSpeedAsAngle > 180) {
      iSpeedAsAngle = iSpeedAsAngle - 180;
    } else if (iSpeedAsAngle < 0) {
      iSpeedAsAngle = iSpeedAsAngle + 180;
    }
    return iSpeedAsAngle;
  }
}
