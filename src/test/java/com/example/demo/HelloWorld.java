package com.example.demo;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class KuberixStudyGroup{
    @GetMapping("/")
    public ResponseEntity<String> hello() {
        String msg = "Kuberix Study Group!";
        return ResponseEntity.ok(msg);
    }
}