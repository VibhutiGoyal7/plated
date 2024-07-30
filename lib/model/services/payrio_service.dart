import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:Payrio/model/apis/app_exception.dart';
import 'package:Payrio/model/services/base_service.dart';
import 'package:path/path.dart';
import '../../utils/Helper.dart';
import 'dart:convert';

class PayrioService extends BaseService {
  String? retrievedToken;
  var selectedLanguage;

  Future<void> setState() async {
    retrievedToken = await Helper.getUserToken();
    selectedLanguage = await Helper.getLocale();
  }

  Future<Map<String, String>> getHeaders() async {
    if (retrievedToken == null || selectedLanguage == null) {
      await setState();
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $retrievedToken',
      'Accept-Language': selectedLanguage.languageCode,
    };
  }
  Future<Map<String, String>> getMultiDataHeaders() async {
    if (retrievedToken == null || selectedLanguage == null) {
      await setState();
    }
    return {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $retrievedToken',
      'Accept-Language': selectedLanguage.languageCode,
    };
  }

  void printRequestDetails(String url, Map<String, String> headers, dynamic body) {
    print('Request URL: $url');
    print('Request Headers: $headers');
    if (body != null) {
      print('Request Body: ${jsonEncode(body)}');
    }
  }

  void printResponseDetail(http.StreamedResponse response) {
    // Implement this function to print response details
    print('Response Status: ${response.statusCode}');
    // Print other response details as needed
  }

  void printResponseDetails(http.Response response) {
    print('Response Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');
    try {
      var responseBody = jsonDecode(response.body);
      print('Success: ${responseBody['success']}');
      print('Message: ${responseBody['message']}');
      print('Status: ${responseBody['status']}');
      print('Data: ${responseBody['data']}');
    } catch (e) {
      print('Error parsing response body: $e');
    }
  }

  @override
  Future<dynamic> postResponse(String url, dynamic requestBody) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getHeaders();

      printRequestDetails(getFullUrl(url), headers, requestBody);
      final response = await http.post(
        Uri.parse(getFullUrl(url)),
        headers: headers,
        body: jsonEncode(requestBody),
      );
      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }


  @override
  Future<dynamic> putResponse(String url, dynamic requestBody) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getHeaders();

      printRequestDetails(getFullUrl(url), headers, requestBody);

      final response = await http.put(
        Uri.parse(getFullUrl(url)),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getResponse(String url) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getHeaders();

      printRequestDetails(getFullUrl(url), headers, {});

      final response = await http
          .get(Uri.parse(getFullUrl(url)), headers: headers
      );
      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> putMultiFormResponse(String url, File file) async {
    print("::::: File: $file");
    dynamic responseJson;

    try {
      // Create a multipart request
      var requestBody = http.MultipartRequest('PUT', Uri.parse(getFullUrl(url)));

      // Add file
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();

      // multipart that takes file
      var multipartFile = http.MultipartFile('customer_image', stream, length, filename: basename(file.path));
      print("Multipart File: ${multipartFile.filename}");
      requestBody.files.add(multipartFile);

      // Add headers
      var headers = await getHeaders();
      requestBody.headers.addAll(headers);

      // Debugging the request
      print("Request URL: ${getFullUrl(url)}");
      print("Request Headers: $headers");
      print("Request Files: ${requestBody.files.map((file) => file.filename).join(', ')}");

      // Send the request and get the response
      var response = await requestBody.send();
      final responses = await http.Response.fromStream(response);
      print("Response Status Code: ${responses.statusCode}");
      print("Response Body: ${responses.body}");

      responseJson = returnResponse(responses);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print('Error: $e');
      throw FetchDataException('Error occurred while sending the request');
    }
    return responseJson;
  }

  Future<dynamic> postMultiFormResponse(String url, File imageFile,String docType,File videoFile) async {
    print("::::: File: $imageFile");
    dynamic responseJson;

    try {
      // Create a multipart request
      var requestBody = http.MultipartRequest('POST', Uri.parse(getFullUrl(url)));

      // Add file
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      // multipart that takes file
      var multipartFile = http.MultipartFile("kyc_file", stream, length, filename: basename(imageFile.path));
      print("Multipart File: ${multipartFile.filename}");

      var streamVid = http.ByteStream(videoFile.openRead());
      var lengthVid = await videoFile.length();

      // multipart that takes file
      var multipartFileVid = http.MultipartFile("kyc_video", streamVid, lengthVid, filename: basename(videoFile.path));
      print("MultipartVid File: ${multipartFileVid.filename}");
      requestBody.files.add(multipartFile);
      requestBody.files.add(multipartFileVid);
      requestBody.fields['document_type'] = docType;
      //requestBody.
      // Add headers
      var headers = await getHeaders();
      requestBody.headers.addAll(headers);

      // Debugging the request
      print("Request URL: ${getFullUrl(url)}");
      print("Request Headers: $headers");
      print("Request Files: ${requestBody.files.map((file) => file.filename).join(', ')}");

      // Send the request and get the response
      var response = await requestBody.send();
      final responses = await http.Response.fromStream(response);
      print("Response Status Code: ${responses.statusCode}");
      print("Response Body: ${responses.body}");

      responseJson = returnResponse(responses);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print('Error: $e');
      throw FetchDataException('Error occurred while sending the request');
    }
    return responseJson;
  }
  //Support Ticket
  Future<dynamic> postMultiFormResponseToCreateSupport(
      String url,
      String amount,
      String paymentTime,
      String customerNumber,
      String trxId,
      String serviceType,
      String bankType,
      String comment,
      String issueType,
      File supportTicketDocument) async {
    print("::::: File: $supportTicketDocument");
    dynamic responseJson;

    try {
      // Create a multipart request
      var requestBody = http.MultipartRequest('POST', Uri.parse(getFullUrl(url)));

      // Add file
      var stream = http.ByteStream(supportTicketDocument.openRead());
      var length = await supportTicketDocument.length();

      // multipart that takes file
      var multipartFile = http.MultipartFile("support_ticket_document", stream, length, filename: basename(supportTicketDocument.path));
      print("Multipart File: ${multipartFile.filename}");
      //RequestBody.
      requestBody.files.add(multipartFile);
      requestBody.fields['amount'] = amount;
      requestBody.fields['payment_time'] = paymentTime;
      requestBody.fields['customer_number'] = customerNumber;
      requestBody.fields['service_type'] = serviceType;
      requestBody.fields['bank_type'] = bankType;
      requestBody.fields['comment'] = comment;
      requestBody.fields['issue_type'] = issueType;
      requestBody.fields['comment'] = comment;
      // Add headers
      var headers = await getHeaders();
      requestBody.headers.addAll(headers);

      // Debugging the request
      print("Request URL: ${getFullUrl(url)}");
      print("Request Headers: $headers");
      print("Request Files: ${requestBody.files.map((file) => file.filename).join(', ')}");

      // Send the request and get the response
      var response = await requestBody.send();
      final responses = await http.Response.fromStream(response);
      print("Response Status Code: ${responses.statusCode}");
      print("Response Body: ${responses.body}");

      responseJson = returnResponse(responses);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print('Error: $e');
      throw FetchDataException('Error occurred while sending the request');
    }
    return responseJson;
  }
  dynamic returnResponses(String responseString, int statusCode) {
    // Implement this function to parse and return the response
    return {
      'statusCode': statusCode,
      'body': responseString,
    };
  }

  @visibleForTesting
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 422:
        var responseBody = jsonDecode(response.body);
        print("Message >>::${responseBody['message']}");
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 401:
        //final responseBody = response;
        var responseBody = jsonDecode(response.body);
        print("Message >>::${responseBody['message']}");
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
        //throw UnauthorisedException(response.body.toString());
      case 403:
        {
          //var responseBody = jsonDecode(response);
          final responseBody = response;
          print("Message ${responseBody}");
          dynamic responseJson = jsonDecode(response.body);
          return responseJson;
         // throw UnauthorisedException("${responseBody['message']}");
        }
      case 404:
      //final responseBody = response;
        var responseBody = jsonDecode(response.body);
        print("Message >>::${responseBody['message']}");
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
    //throw UnauthorisedException(response.body.toString());
      case 500:
        throw BadRequestException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode} ${response.body
                    .toString()}');
    }
  }
}
