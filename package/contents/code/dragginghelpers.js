/////////////////*Functions that do the search in the models*////////////////////////////////
function followPath(currentObject, mouse, table, position, debug)
{
    var coordsN = mapToItem(currentObject, mouse.x, mouse.y);

    if (position===(table.length-2)){
        if (checkTypeId(currentObject.childAt(coordsN.x, coordsN.y), table[position],debug)){
            if (debug)
                console.log("Last:"+table[position]);

            var nextObjectLast = getCorrectChild(currentObject, coordsN, table[position+1]);
            if (nextObjectLast !== undefined)
                return nextObjectLast;
            else
                return false;
            //return getCorrectChild(currentObject, coordsN, table[position+1])
        }
        else
            return false;
    }
    else{
        if (checkTypeId(currentObject.childAt(coordsN.x, coordsN.y),table[position], debug)){
            if (debug)
                console.log("Step: "+table[position]);

            var nextObject = getCorrectChild(currentObject, coordsN, table[position+1]);
            if (nextObject !== undefined)
                return followPath(nextObject, mouse, table, position+2, debug);
            else
                return false;
        }
        else
            return false;
    }
}

function getCorrectChild(currentObject, coords, state)
{
    if (state>0)
        return currentObject.childAt(coords.x,coords.y).children[state-1];
    else
        return currentObject.childAt(coords.x,coords.y);
}

function checkTypeId(obj, name, debug){
    //console.debug(obj.typeId+"-"+name);
    if (obj === null)
        return false;
    else if (obj.typeId === name){
        return true;
    }
    else if ((obj.typeId !== name)&&debug)
        console.debug("Other Element Found: "+obj.typeId+ " but was searching: "+name);
    else
        return false;
}
