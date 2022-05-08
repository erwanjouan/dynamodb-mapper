package com.example.dynamodb.controllers;

import com.example.dynamodb.dtos.StudentDTO;
import com.example.dynamodb.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/dynamoDb")
public class DynamoDbController {

    @Autowired
    private StudentService studentService;

    @PostMapping("/save")
    public StudentDTO insertIntoDynamoDB(@RequestBody StudentDTO dto) {
        return  studentService.insertIntoDynamoDB(dto);
    }
}
