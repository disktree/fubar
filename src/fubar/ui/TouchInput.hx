package fubar.ui;

import js.Browser.document;
import js.html.Element;
import js.html.TouchEvent;

typedef Position = {
    var x : Int;
    var y : Int;
}

/*
class GestureEvent {

    public var startPosition(default,null) : Position;
    public var endPosition(default,null) : Position;
    public var position(default,null) : Position;
    public var type(default,null) : GestureInput;

    public function new() {
    }
}
*/

enum TouchGesture {
    tap;
    right(v:Float);
    left(v:Float);
    up(v:Float);
    down(v:Float);
}

class TouchInput {

    public dynamic function onStart( e : TouchEvent ) {}
    public dynamic function onMove( e : TouchEvent ) {}
    public dynamic function onEnd( e : TouchEvent ) {}
    public dynamic function onGesture( gesture : TouchGesture ) {}

    public var enabled : Bool;
    public var threshold : Int;

    var start : Position;
    var move : Position;

    public function new( element : Element, threshold = 50 ) {

        this.threshold = threshold;

        start = { x:-1, y:-1 };
        move = { x:-1, y:-1 };

        element.addEventListener( 'touchstart', handleTouchStart, false );
        element.addEventListener( 'touchmove', handleTouchMove, false );
        element.addEventListener( 'touchend', handleTouchEnd, false );

        enabled = true;
    }

    function handleTouchStart( e : TouchEvent ) {

        if( !enabled ) return;

        e.preventDefault();
        e.stopPropagation();

        if( e.touches != null ) {

            var touch = e.touches[0];
            start.x = touch.pageX;
            start.y = touch.pageY;

            onStart(e);
        }
    }

    function handleTouchMove( e : TouchEvent ) {

        if( !enabled ) return;

        e.preventDefault();
        e.stopPropagation();

        if( e.touches != null ) {

            var touch = e.touches[0];
            move.x = touch.pageX;
            move.y = touch.pageY;

            onMove(e);

            //TODO report swipe here if thresjhold reached (?)
        }
    }

    function handleTouchEnd( e : TouchEvent ) {

        if( !enabled ) return;

        e.preventDefault();
        e.stopPropagation();

        onEnd(e);

        if( start.x > -1 && move.x > -1 ) {
            var xDiff = (start.x > move.x) ? start.x - move.x : move.x - start.x;
            var yDiff = (start.y > move.y) ? start.y - move.y : move.y - start.y;
            if( xDiff > threshold ) {
                onGesture( start.x < move.x ? right(xDiff) : left(xDiff) );
            } else if( yDiff > threshold ) {
                onGesture( start.y < move.y ? down(yDiff) : up(yDiff) );
            }
        } else {
            onGesture( tap );
        }

        start.x = start.y = move.x = move.y = -1;
    }
}
