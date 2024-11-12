package com.Mariategui.configserve_tarea;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer
public class ConfigserveTareaApplication {

	public static void main(String[] args) {
		SpringApplication.run(ConfigserveTareaApplication.class, args);
	}

}
