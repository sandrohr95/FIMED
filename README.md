<p align="center">
  <br/>
  <img src=docs/Fimed_logo.png alt="WK">
  <br/>
  <br/>
  <em>Flexible management of biomedical data</em>
</p>

FIMED is a software tool for clinical data collections allowing clinicians without programming skills flexible management of clinical research information. It provides many functionalities in order to facilitate data management by clinicians, such a (I) personalized form design ("do-it-yourself") dynamically adapting to each of the patients entries in the application; (II) browse functionality to store gene expression assays associated to the patient with metadata to grant additional information to the samples; (III) the modification and the update of the data over the time; and (IV) a search tool to provide direct access to the data with different filter options. Additionally, FIMED integrates analysis tools for clinical trials to allow clinicians to perform different types of analysis towards a deeper comprehension of the molecular mechanisms in a particular disease through the interpretation of results. Moreover, FIMED offers some mechanisms to extend the software with new components in order to expand its functionalities.

<p align="center">
  <br/>
  <img src=docs/home.png alt="FIMED HOME">
 
</p>


Current version incorporates algorithms for gene expression data analysis and offers visualization tools for the exploration of these data: Heatmaps, Cluster Heatmaps and Gene Regulatory Networks.

<p align="center">
  <br/>
  <img src=docs/analysis.png alt="FIMED ANALYSIS">
 
</p>

## Description
The tool has been developed in JAVA, JSP and JavaScript languages and follows a Model-View-Controller (MVC)
software design pattern by means of which, it manages a MongoDB database and serves the user interface through a standard Tomcat 9 Web application service. 
## Build and Install
The software has been tested in Intellij and Eclipse on different operative systems

1. Prerequisites
  - download and install a recent Java 11 JDK (https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) 
  - download a recent version of MongoDB, since FIMED has been developed using MongoDB (https://www.mongodb.com/download-center)
  - download Tomcat 9 Web to deploy de application (https://tomcat.apache.org/download-90.cgi)
  
To download and install FIMED just clone the Git repository hosted in GitHub:

```console
git clone https://github.com/sandrohr95/FIMED.git

```
