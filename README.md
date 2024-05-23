# GreenScan Development Report

Welcome to the documentation pages of the GreenScan!

You can find here details about the GreenScan, from a high-level vision to low-level implementation decisions, a kind of Software Development Report, organized by type of activities: 

* [Business Modelling](docs/BusinessModelling.md)
  * [Product Vision](docs/BusinessModelling.md#Product-Vision)
  * [Features and Assumptions](docs/BusinessModelling.md#Features-and-Assumptions)
  * [Elevator Pitch](docs/BusinessModelling.md#Elevator-Pitch)
* [Requirements](docs/Requirements.md)
  * [Domain model](docs/Requirements.md#Domain-Model)
  * [Mockup](docs/Requirements.md###Mockup)
* [Architecture and Design](docs/ArchitectureAndDesign.md###Logical-architecture)
  * [Logical architecture](docs/ArchitectureAndDesign.md)
  * [Physical architecture](docs/ArchitectureAndDesign.md#Physical-architecture)
  * [Vertical prototype](docs/ArchitectureAndDesign.md###Vertical-prototype)
* [Project management]

Contributions are expected to be made exclusively by the initial team, but we may open them to the community, after the course, in all areas and topics: requirements, technologies, development, experimentation, testing, etc.

Please contact us!

Thank you!

- Afonso Cruz up202006020
- Bruno Pereira up202206251
- Eduardo Cunha up202207126
- Ricardo Ramos up202206349
- Tiago Ferreira up202207311


## Business Modelling

### Product Vision

Our app empowers consumers to make environmentally conscious choices by providing them with essential information about product´s sustainability, putting the power to align their purchasing habits with their values directly in their hands.

### Features and Assumptions

- Search for product ecological footprint by name or barcode scan.
- Sort products by descending order of sustainability.
- View detailed product description including price, place of manufacture, and environmental impact.
- Register an account in the application.
- View product sales locations and stock availability.
- Log in to the account.
- Provide feedback on specific products.
- View search history.
- Save purchased products.
- Add a product to a wishlist.
- Receive notifications for promotions on wishlist items.
- Receive notifications for new product/brand releases

### Elevator Pitch

In modern times, with a wide range of brands and products, it's tough to know if the products you buy are actually good for your health and for the health of the planet. Our app, GreenScan, changes that hard choices. With a simple barcode, you get instant acess to sustainability ratings, manufacturing details, and full information of a product's environmental impact. Plus, you can find stores near you that carry the sustainable items you want. We put the power of conscious shopping right in your pocket, helping you make informed choices that align with your values.

## Requirements

### Domain Model

![DomainModel](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/blob/eb37c9efd472f40d6a0749b5b83e210bacdc3e3a/docs/Domain%20Model.png)


### Mockup

![Mockup](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/blob/dd44bda11ca11a4a14d58000d5668fc12bf1d536/docs/Mockup.png)

## Architecture and Design

### Logical architecture

![Logical Architecture](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/blob/028771d5450493930b426ff15894f5687c30e83e/docs/images/Logical%20architecture.png)


### Physical architecture

![Physical Architecture](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/blob/main/docs/images/physical_uml.png)


### Vertical prototype

![Vertical prototype](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/blob/main/docs/images/vertical_prototype.gif)


# Sprint Retrospective
## Sprint 1
During the Sprint 1, and despite many challenges, our team managed to complete most of the user stories and features we had planned, namely the user authentication system, an homepage, a location service, a loading page, the search of products, as well as viewing their details, all while integrating our Firebase database, populating it and making the necessary connections. Some scoring criteria for products was also implemented. Since this was the first sprint and the first time doing hands-on on a real project and using real-world practises, and we found it a bit difficult and faced some challenges. To summarize:
### The Good
We managed to complete most of our planned features, and we're satisfied with the work we put in to refine some features and pages. We managed to grasp the basics of Flutter/Dart, while also designing the pages and making sure that the client gets a good user experience. 
### The Bad
Overall, we struggled more with scrum/agile/sprint-planning techniques, and think that our work could've been better coordinated. Some user-stories weren't specific enough, and we'll need to work a little more on that.
### Project Board At The Beginning of Sprint 1
![Before](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/blob/main/docs/images/Before.png)
### Project Board At The End of Sprint 1
![After](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/blob/main/docs/images/After.png)
### User Stories concluded
- [#6: As a app user, I want to login into my account](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/issues/6)
- [#2: As a app user, I want to be able to search for products by bar code](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/issues/2)
- [#4: As a app user, I want to create and register an account](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/issues/4)
- [#5: As a app user, I want to consult detailed information about a product](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/issues/5)
- [#3: As an app user, I want to be able to search for products by name](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/issues/3)


## Sprint 2
In this sprint, we attempted to implement most of the functionalities where the map would be important and to create a page for adding products from the application, as well as to improve the functioning of the database. In addition to this, we made some enhancements to the application overall. Overall, we were able to complete a large portion of the proposed user stories for this sprint. We encountered some issues with code merging.

### The Good
Once again, we were able to fulfill the majority of the user stories and improve our skills in database manipulation and Flutter development.

### The Bad
This time, the issues didn't focus so much on sprint organization, but rather on coordinating different code in Git, especially with conflicts during merging.

### Project Board At The Beginning of Sprint 2
![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/assets/38361094/f531b101-3598-4d45-807a-96149b730daf)
### Project Board At The End of Sprint 2
![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/assets/38361094/35ee0080-f2ac-44ac-b727-c7c4f06504e2)

### User Stories Concluded
- [#15: As an app user, I want to check my product scan history](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/issues/15)
- [#16: As a app user, I want to see the selling places of a product](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/issues/16)
- [#18: As an admin, I want to be able to add product information to the database](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/issues/18)
- [#19: As an app user, I want to get more sustainability details about a product, like labeling and more material information](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/issues/19)
- [#20: As an app user, I want to get a product not found page in case the product I'm looking for doesn't exist yet](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/issues/20)


## Sprint 3
In this final sprint, we we focus more on fixing bugs and developing tests for our application. In addition of improving the features we already had, we also created a product comparator, as it was an important feature for the concept of our application.

### The Good
This time, there was no merging conflicts and we were much more organized and managed to finish everything proposed for this sprint.

### The Bad
One of the biggest problems with the project has always been time management and this time was no different. Despite that, we managed to complete everything that was propose.

### Project Board At The Beginning of Sprint 3
![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC08T3/blob/main/docs/images/sprint3before.png)
### Project Board At The End of Sprint 3


### User Stories Concluded
