class JobInfo{

  // info from api
  final dynamic job;

  // company specifications
  late final String companyLogo;
  late final String companyName;
  late final String companyDescription;
  late final String companyAddress;
  late final String companyPhone;
  late final String companyEmail;
  late final String companyURL;

  // job specifications
  late final int jobID;
  late final String jobTitle;
  late final String jobDescription;
  late final String jobLocation;
  late final String jobType;
  late final String jobContract;
  late final String jobSalary;
  late final String jobPublishDate;

  // Constructor
  JobInfo({required this.job}){

    // Company
    try{
      companyLogo = job["company"]["logo"];
    } catch(e){
      companyLogo = "Logo Not Found";
    }

    try{
      companyName = job["company"]["name"];
    } catch(e){
      companyName = "Not Specified";
    }

    try{
      companyDescription = job["company"]["description"];
    } catch(e){
      companyDescription = "Not Specified";
    }

    try{
      companyAddress = job["company"]["address"];
    } catch(e){
      companyAddress = "Not Specified";
    }

    try{
      companyPhone = job["company"]["phone"];
    } catch(e){
      companyPhone = "Not Specified";
    }

    try{
      companyEmail = job["company"]["email"];
    } catch(e){
      companyEmail = "Not Specified";
    }

    try{
      companyURL = job["company"]["url"];
    } catch(e){
      companyURL = "Not Specified";
    }

    // Job
    jobID = job["id"];

    try{
      jobTitle = job["title"];
    } catch(e){
      jobTitle = "Not Specified";
    }

    try{
      jobDescription = job["body"];
    } catch(e){
      jobDescription = "Not Specified";
    }
    
    try{
      jobLocation = job["locations"][0]["name"];
    } catch(e){
      jobLocation = "Not Specified";
    }

    try{
      jobType = job["types"][0]["name"];
    } catch(e){
      jobType = "Not Specified";
    }

    try{
      jobContract = job["contracts"][0]["name"];
    } catch(e){
      jobContract = "Not Specified";
    }

    try{
      if(job["wage"]!= null){
        jobSalary = "${job["wage"]} €";
      }
      else{
        jobSalary = "Not Specified";
      }
    } catch(e){
      jobSalary = "Not Specified";
    }

    try{
      jobPublishDate = job["publishedAt"].toString().substring(0,10);
    } catch(e){
      jobPublishDate = "Not Specified";
    }
  }
}
