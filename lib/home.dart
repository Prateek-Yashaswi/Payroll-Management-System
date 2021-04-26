import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  bool status=false;
  bool errorStatus=true;
  var empId;
  var empName;
  var empPh;
  var empEmail;
  var empAddress;
  var empDOB;
  bool balanceCalculated = false;
  var basicSalary;
  var bonus;
  var totalExpenses;
  var balance;
  bool saldatainserted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status=false;
    errorStatus=true;
    balanceCalculated = false;
  }

  Future getData() async{
    try{
      var url = Uri.https("dbmsproject00712.000webhostapp.com", "/get.php",{'q':'{https}'});
      http.Response response = await http.get(url);
      var data = jsonDecode(response.body);
      print(data.toString());
    }catch(e){
      print(e);
    }
  }

  Future insertEmpData() async{
    var url = Uri.parse("https://dbmsproject00712.000webhostapp.com/insert.php");
    try{
      var res = await http.post(url,headers: {"Accept":"application/json"},
          body: {
            "employee_id":empId,
            "ename":empName,
            "phone_no":empPh,
            "email":empEmail,
            "address":empAddress,
            "dob":empDOB
          });
      
      var resBody = json.decode(res.body);
      print(resBody);
    }catch(e){
      print(e);
    }
  }

  Widget dataRows(rowHead,rowNo,hint){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                rowHead,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 50,
              child: TextFormField(
                onChanged: (val){
                  if(rowNo==1){
                    empId=val;
                  }
                  else if(rowNo==2){
                    empName=val;
                  }
                  else if(rowNo==3){
                    empPh=val;
                  }
                  else if(rowNo==4){
                    empEmail=val;
                  }
                  else if(rowNo==5){
                    empAddress=val;
                  }
                  else if(rowNo==6){
                    empDOB=val;
                  }
                  else if(rowNo==7){
                    basicSalary=val;
                  }
                  else if(rowNo==8){
                    bonus=val;
                  }
                  else if(rowNo==9){
                    totalExpenses=val;
                  }
                },
                decoration: new InputDecoration(
                  labelText: hint,
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    borderSide: new BorderSide(
                      color: Colors.black
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length==0) {
                    return "Data cannot be empty";
                  }else{
                    return null;
                  }
                },
              ),
            )
          ],
        ),
        SizedBox(height: 36,)
      ],
    );
  }

  Widget showError(){
    return Container(
      child: errorStatus ? Text("Please Ensure That Everything Is Filled") : Text(""),
    );
  }

  Widget userData(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            dataRows("Employee ID :",1,"Integer"),
            dataRows("Employee Name :",2,"Varchar"),
            dataRows("Employee Phone :",3,"Varchar"),
            dataRows("Employee Email :",4,"Varchar"),
            dataRows("Employee Address :",5,"Varchar"),
            dataRows("Employee DOB :",6,"YYYY-MM-DD"),
            showError(),
            SizedBox(height: 20,),
            GFButton(
              onPressed: (){
                if(empId=="" || empName=="" || empPh=="" || empEmail=="" || empAddress=="" || empDOB==""){
                  print("Error");
                  setState(() {
                    errorStatus=true;
                  });
                }
                else{
                  setState(() {
                    errorStatus=false;
                    status=true;
                  });
                  insertEmpData();
                  print(empId);
                  print(empName);
                  print(empPh);
                  print(empEmail);
                  print(empAddress);
                  print(empDOB);
                }
              },
              fullWidthButton: true,
              size: GFSize.LARGE,
              text: "Submit Data",textStyle: TextStyle(fontSize: 20),
              shape: GFButtonShape.pills,
            ),
            Container(
              child: Text("Or"),
            ),
            GFButton(
              onPressed: (){
                Navigator.pushNamed(context, '/searchAndUpdate');
              },
              fullWidthButton: true,
              size: GFSize.LARGE,
              shape: GFButtonShape.pills,
              text: "Search An Employee Data",textStyle: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Future insertSalData() async{
    var url = Uri.parse("https://dbmsproject00712.000webhostapp.com/insertSal.php");
    try{
      var res = await http.post(url,headers: {"Accept":"application/json"},
          body: {
            "employee_id":empId,
            "name":empName,
            "basic_salary":basicSalary,
            "bonus":bonus,
            "total_expenses":totalExpenses,
            "balance":balance
          });

      var resBody = json.decode(res.body);
      print(resBody);
      setState(() {
        saldatainserted=true;
      });
    }catch(e){
      print(e);
    }
  }

  Widget payRoll(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text("Employee Id",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ),
                Container(child: Text("$empId",style: TextStyle(fontSize: 18),),)
              ],
            ),
            SizedBox(height: 36,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text("Employee Name",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 36,),
                Container(child: Text("$empName",style: TextStyle(fontSize: 18,),),)
              ],
            ),
            SizedBox(height: 36,),
            dataRows("Basic Salary :",7,"Integer"),
            dataRows("Bonus :",8,"Integer"),
            dataRows("Total Expenses :",9,"Integer"),
            balanceCalculated==false ? Column(
              children: [
                GFButton(
                  onPressed: (){
                    print(basicSalary);
                    print(bonus);
                    print(totalExpenses);
                    setState(() {
                      balanceCalculated=true;
                      balance=((int.parse(basicSalary)+int.parse(bonus))-int.parse(totalExpenses)).toString();
                      print(balance);
                    });
                  },
                  text: "Calculate Balance",
                  shape: GFButtonShape.pills,
                ),
                SizedBox(height: 20,),
                Container(
                  child: Text("Net Balance",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ),
                Container(child: Text("Enter Data To Calculate The Balance",style: TextStyle(fontSize: 18),),),
                SizedBox(height: 20,),
              ],
            ):
            Column(
              children: [
                Container(child: Text("Your Net Balance Is :",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                SizedBox(height: 10,),
                Container(child: Text("$balance",style: TextStyle(fontSize: 21),),),
                saldatainserted && balanceCalculated ? Container(child: Text(""),) : GFButton(
                  onPressed: insertSalData,
                  text: "Insert This Data",textStyle: TextStyle(fontSize: 20),
                  fullWidthButton: true,
                  shape: GFButtonShape.pills,
                ),
                SizedBox(height: 10,),
              ],
            ),
            SizedBox(height: 12,),
            saldatainserted ? Column(
              children: [
                Container(child: Text("Data Inserted Into Salary Table"),),
                SizedBox(height: 10,),
                GFButton(
                  onPressed: (){
                    setState(() {
                      status = false;
                      balanceCalculated=false;
                      empId="";
                      empName="";
                      empEmail="";
                      empPh="";
                      empDOB="";
                      empAddress="";
                      saldatainserted=false;
                    });
                  },
                  text: "Go Back",textStyle: TextStyle(fontSize: 20),
                  fullWidthButton: true,
                  shape: GFButtonShape.pills,
                ),
              ],
            ) : Container(child: Text(""),)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Payroll Management System"),
        ),
        body: status ? SingleChildScrollView(child: payRoll()) : SingleChildScrollView(child: userData()),
      ),
    );
  }
}
