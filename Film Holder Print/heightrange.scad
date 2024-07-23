 $fs=0.1;

width=200; // width of the film holder
depth=20;
slotTop=8.5;
slotBottom=9.75;
plateDepth=15;
height=5;
extra=1;
base_height=2.19;
gap=1.0;
range=2;

module box(width,depth,height){
    translate([-width/2.0, -depth/2.0, 0]){
        cube([width,depth,height]);
    }
}


module plate(width,depth,height,cornerRadius,corners)
{
    translate([-width/2.0, -depth/2.0, 0])
    {
        difference()
        {
            cube([width,depth,height]);
            if (corners[0]==1){
                translate([-extra,-extra,-extra])
                {
                     cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
            if (corners[1]==1){
                translate([-extra,depth-cornerRadius,-extra])
                {
                    cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
            if (corners[2]==1){
                translate([width-cornerRadius,depth-cornerRadius,-extra])
                { 
                    cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
            if (corners[3]==1){
                translate([width-cornerRadius,-extra,-extra])
                {
                    cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
        }
        translate([cornerRadius,cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([width-cornerRadius,cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([cornerRadius,depth-cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([width-cornerRadius,depth-cornerRadius,0]) cylinder(r=cornerRadius,h=height);
    }
}   

module stripHolder(offset)
{

    difference(){
        // outer box
        plate(width,depth,height,2,[1,1,1,1]);
        
        // film slot
        translate([-extra,0,base_height+offset]){
            box(width+(3*extra),slotBottom,height+(2*extra));
        }
        
        // through hole
        translate([0,0,-extra]){
           plate(width-20,slotTop,height+(2*extra),1,[1,1,1,1]);
        }
        
        // holder cutout
        translate([0,0,base_height+offset]){
            plate(width-10,plateDepth,height+(3*extra),1,[1,1,1,1]);
        }
    }
}

module holderLid()
{
    difference(){
        union(){
            // lid strip
            translate([0,0,0]){
                box(width,slotBottom-gap,height-base_height);
            }
            // lid surround
            plate(width-10-gap,plateDepth-gap,height-base_height,1,[1,1,1,1]);
            
        }
        union(){
            translate([0,0,-extra]){
               box(width-20,slotTop,height+(2*extra));
            }
            
            angle=30;
            translate([0,2,-1]){
                rotate(angle,[1,0,0]){
                    box(width-20,slotBottom-gap,height-base_height);
                }
            }
            translate([0,-2,-1]){
                rotate(-angle,[1,0,0]){
                    box(width-20,slotBottom-gap,height-base_height);
                }
            }
        }
    }
}

module testFilmHolder(inRange, inLength){
    range = inRange;
    length = inLength;
    union(){
        for ( i=[0:1:range*2]){
            translate([0,(i*(depth-2)),0]){
                stripHolder((i-range)/10);
            }
        }
    }
}

module filmHolder(inOffset, inNoOfHolders){
    union(){
        for ( i=[0:1:inNoOfHolders]){
            translate([0,(i*(depth-2)),0]){
                stripHolder(inOffset);
            }
            translate([0,100+i*20,0]){
                holderLid();
            }
        }
    }
}


//testFilmHolder(2,100);
//translate([0,100,0]){
//    holderLid();
}

filmHolder(0.2,4);

