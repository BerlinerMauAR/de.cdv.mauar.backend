package de.cdv.mauar.backend.rest.service;

import java.util.List;

public class PhotoLocation {
	private List<Double> coord;
	private String url;
	
	public PhotoLocation(List<Double> coord, String url) {
		this.coord = coord;
		this.url = url;
	}

	public List<Double> getCoord() {
		return coord;
	}

	public void setCoord(List<Double> coord) {
		this.coord = coord;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
}
