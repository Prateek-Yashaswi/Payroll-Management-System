import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class searchAndUpdate extends StatefulWidget {
  @override
  _searchAndUpdateState createState() => _searchAndUpdateState();
}

class _searchAndUpdateState extends State<searchAndUpdate> {

  var empId="",empName="",empPhNo="",empEmail="",empAddress="",empDOB="",basicSal="",bonus="",totalExpenses="",bal="";
  bool fetchDataStatus=false,cantfetchdata=false;
  @override
  void initState(){
    super.initState();
    fetchDataStatus=false;
    cantfetchdata=false;

  }

  Future getEmpData() async{
    print(empId);
    var url = Uri.parse("https://dbmsproject00712.000webhostapp.com/get.php");
    try{
      var res = await http.post(url,headers: {"Accept":"application/json"},
          body: {
            "employee_id":empId,
          });
      var resBody = json.decode(res.body);
      print(resBody);
      empName=resBody["empName"];
      empEmail=resBody["empEmail"];
      empPhNo=resBody["empPhNo"];
      empAddress=resBody["empAddress"];
      empDOB=resBody["empDOB"];
      setState(() {
        fetchDataStatus=true;
        cantfetchdata=false;
      });
      print(resBody);
    }catch(e){
      print(e);
      setState(() {
        cantfetchdata=true;
      });
    }
  }

  Future getSalData() async{
    print(empId);
    var url = Uri.parse("https://dbmsproject00712.000webhostapp.com/getSalData.php");
    try{
      var res = await http.post(url,headers: {"Accept":"application/json"},
          body: {
            "employee_id":empId,
          });
      var resBody = json.decode(res.body);
      print(resBody);
      setState(() {
        fetchDataStatus=true;
        cantfetchdata=false;
        basicSal=resBody["basic_sal"];
        bonus=resBody["bonus"];
        totalExpenses=resBody["total_expenses"];
        bal=resBody["balance"];
      });
      print(resBody);
    }catch(e){
      print(e);
      setState(() {
        cantfetchdata=true;
      });
    }
  }

  Widget fetchedDataRows(labelTitle,labelValue){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(labelTitle),
        ),
        Container(
          child: Text(labelValue),
        ),
      ],
    );
  }

  Widget fetchedData(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(child: Text("Employee Data Table",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.08,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),),
        SizedBox(height: 40,),
        fetchedDataRows("Employee ID : ",empId),
        SizedBox(height: 5,),
        fetchedDataRows("Employee Name : ",empName),
        SizedBox(height: 5,),
        fetchedDataRows("Employee Phone No. : ",empPhNo),
        SizedBox(height: 5,),
        fetchedDataRows("Employee Email : ",empEmail),
        SizedBox(height: 5,),
        fetchedDataRows("Employee Address : ",empAddress),
        SizedBox(height: 5,),
        fetchedDataRows("Employee DOB : ",empDOB),
        SizedBox(height: 30,),
        Container(child: Text("Salary Data Table",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.08,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),),
        SizedBox(height: 40,),
        fetchedDataRows("Basic Salary : ",basicSal),
        SizedBox(height: 5,),
        fetchedDataRows("Bonus : ",bonus),
        SizedBox(height: 5,),
        fetchedDataRows("Total Expenses : ",totalExpenses),
        SizedBox(height: 5,),
        fetchedDataRows("Balance : ",bal),
        SizedBox(height: 5,),
      ],
    );
  }

  Widget beforeDataFetch(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 8),
          child: Text("Enter Following Data",style: TextStyle(fontSize: 12)),
        ),
        SizedBox(height: 20,),
        Container(
          child: TextFormField(
            onChanged: (val){
              setState(() {
                empId=val;
              });
            },
            decoration: InputDecoration(
              labelText: "Employee ID",
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(20.0),
                borderSide: new BorderSide(
                    color: Colors.black
                ),
              ),
              //fillColor: Colors.green
            ),
          ),
        ),
        SizedBox(height: 30,),
        GFButton(
          onPressed: (){
            getEmpData();
            getSalData();
          },
          fullWidthButton: true,
          shape: GFButtonShape.pills,
          size: GFSize.LARGE,
          text: "Search In Database",textStyle: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search In The Database"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                fetchDataStatus ? Container(child: Text("Data Fetched",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),alignment: Alignment.center,) : beforeDataFetch(),
                SizedBox(height: 40,),
                fetchDataStatus ? fetchedData() : Container(child: Text("Fetching Data Might Take Some Time Depending On Your Internet Connection",textAlign: TextAlign.center,),),
                SizedBox(height: 30,),
                cantfetchdata ? Container(child: Text("The Given Employee ID Doesn't Exist In Our Database",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),) : Container(child: Text(""),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
