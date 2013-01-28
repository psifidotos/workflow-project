/////////////////*Functions that do the search in the models*////////////////////////////////
function followPath(currentObject, mouse, table, position)
{
    var coordsN = mapToItem(currentObject, mouse.x, mouse.y);
    if (position===(table.length-2)){
        if (checkTypeId(currentObject.childAt(coordsN.x, coordsN.y), table[position])){
            ///console.log(table[position]);
            return getCorrectChild(currentObject, coordsN, table[position+1])
        }
        else
            return false;
    }
    else{

        if (checkTypeId(currentObject.childAt(coordsN.x, coordsN.y),table[position])){
            var nextObject = getCorrectChild(currentObject, coordsN, table[position+1]);
            return followPath(nextObject, mouse, table, position+2);
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

function checkTypeId(obj,name){
    //console.debug(obj.typeId+"-"+name);
    if (obj === null)
        return false;
    else if (obj.typeId === name)
        return true;
    else
        return false;
}
