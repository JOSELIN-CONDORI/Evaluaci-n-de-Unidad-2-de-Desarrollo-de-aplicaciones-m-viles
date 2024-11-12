package com.Mariategui.registryserve;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class RegistryServeApplication {

	public static void main(String[] args) {
		SpringApplication.run(RegistryServeApplication.class, args);
	}

}
