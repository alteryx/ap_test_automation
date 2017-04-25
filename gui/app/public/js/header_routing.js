function addUser(){
    window.location.href = '/customers/add';
}
function cancelAdd(){
    window.location.href = '/customers';
}


function add_testPriorityLevel(){
    window.location.href = '/testPriorityLevel/add';
}

function cancel_add_testPriorityLevel(){
    window.location.href = '/testPriorityLevel';
}


function add_entity(table_name){
    window.location.href = '/crud/'+table_name+'/add';
}

function cancel_add_entity(table_name){
    window.location.href = '/crud/'+table_name;
}
