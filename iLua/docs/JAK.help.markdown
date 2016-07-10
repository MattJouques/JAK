Title: JAK.help
Timestamp: 2012-10-01 05:50:40 +0000
Created: 2012-10-01 05:49:37 +0000
Last Accessed: 2012-10-02 23:15:37 +0000
Times Accessed: 1
Tags: 
Metadata: 


## Calculations

Rhumb lines

A ‘rhumb line’ (or loxodrome) is a path of constant bearing, which crosses all meridians at the same angle.

Sailors used to (and sometimes still) navigate along rhumb lines since it is easier to follow a constant compass bearing than to be continually adjusting the bearing, as is needed to follow a great circle. Rhumb lines are straight lines on a Mercator Projection map (also helpful for navigation).

Rhumb lines are generally longer than great-circle (orthodrome) routes. For instance, London to New York is 4% longer along a rhumb line than along a great circle – important for aviation fuel, but not particularly to sailing vessels. New York to Beijing – close to the most extreme example possible (though not sailable!) – is 30% longer along a rhumb line.


Distance/bearing

These formulæ give the distance and (constant) bearing between two points.

Formula:	Δφ = ln(tan(lat2/2+π/4)/tan(lat1/2+π/4))	 [= the ‘stretched’ latitude difference]
if E:W line,	q = cos(lat1)	 
otherwise,	q = Δlat/Δφ	 
 	d = √(Δlat² + q².Δlon²).R	[pythagoras]
 	θ = atan2(Δlon, Δφ)	 
 	where ln is natural log, Δlon is taking shortest route (<180º), and R is the earth’s radius
JavaScript:	
var dPhi = Math.log(Math.tan(lat2/2+Math.PI/4)/Math.tan(lat1/2+Math.PI/4));
var q = (isFinite(dLat/dPhi)) ? dLat/dPhi : Math.cos(lat1);  // E-W line gives dPhi=0

// if dLon over 180° take shorter rhumb across anti-meridian:
if (Math.abs(dLon) > Math.PI) {
  dLon = dLon>0 ? -(2*Math.PI-dLon) : (2*Math.PI+dLon);
}

var d = Math.sqrt(dLat*dLat + q*q*dLon*dLon) * R;
var brng = Math.atan2(dLon, dPhi);