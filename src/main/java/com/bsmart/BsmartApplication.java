package com.bsmart;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = { SecurityAutoConfiguration.class })
public class BsmartApplication {
	public static void main(String[] args) {
		SpringApplication.run(BsmartApplication.class, args);
	}
}

// @SpringBootApplication
// public class BsmartApplication {

// public static void main(String[] args) {
// SpringApplication.run(BsmartApplication.class, args);
// }

// }
