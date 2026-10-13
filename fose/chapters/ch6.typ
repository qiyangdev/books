#import "@preview/ilm:2.1.1": blockquote

= 探索与修改陌生系统

#blockquote[
  我最宝贵的一些经验，来自维护一个遗留应用。我强烈推荐这段经历，却不愿任何人亲身遭遇。

  ——软件开发者达莉娅·阿博·谢阿莎（Dalia Abo Sheasha）
]

许多开发者喜欢从零开始的新项目（greenfield project），喜欢面对一张白纸。然而，软件开发的现实是：我们的大部分工作都发生在已有系统上。别因此对这个职业灰心。已有代码库自有好处：许多关键决策已经做出，你可以专注解决眼前的问题，而不必从基础设施开始操心。

无论是刚加入一个项目，还是只想摸清一个陌生代码库，你都需要学会探索并修改不熟悉的系统。本章将介绍如何在陌生代码中找到方向、理解它，以及如何安全地做出改动。不论你要加入新团队，还是维护遗留系统，这些能力都能帮助你有把握地为任何代码库作出贡献。这里的讨论建立在第二章介绍的代码阅读方法之上。

== 理解陌生代码库

不论是入职新公司，还是在现有公司转入新项目，面对陌生代码库都可能让人焦虑：未知的东西太多，语言、框架或工具也可能不熟悉。但只要带着明确的计划，掌握在未知领域中探路的方法，成功的机会和信心都会提高。

本节会介绍如何理解项目的全貌与目标，如何沿着代码的运行路径熟悉新项目，以及如何把复杂系统拆成易于掌握的部分，逐步建立心智模型（mental model）。阅读本章或探索新项目时，请记住：一开始不懂代码库里的每件事，完全正常。即使在项目里工作多年的队员，也不可能无所不知。

=== 先看全局

俗话说，“只见树木，不见森林。”如果一心盯着琐碎细节——比如框架具体用了哪个版本——就可能忽略更大的问题：这个项目究竟要实现什么。你也许想立刻投入工作，为团队证明自己的价值。但先有计划总是好事。以下方法可以帮你把握全貌。

*理解项目*

理解代码之前，先理解项目的目的和意图。先从高处看：项目为何存在？相关人员是谁？它对雇主意味着什么？它是不是业务的重要组成部分？

了解这些问题的方法很多，一个好的起点是找一位深知产品的人，例如产品经理。试着约他谈谈，做好学习的准备。尽可能记笔记，以便日后查阅；如果是线上会议，可以询问是否能录下来供以后重看。最重要的是主动提问。真正愚蠢的问题，是你没问出口的问题。

与产品负责人交谈，获得项目概览后，再深入技术层面。找正在项目中工作的软件工程师交流；如果能找到最初开发系统的人，那简直像淘金时挖到了金矿。最好还能请教技术负责人或架构师，他们可以解释当初为什么做出某些决策。

产品的客户是谁？找找关于项目的公开资料；如果有，试着从客户视角阅读。有些公司会为产品建立用户画像（user persona）：根据真实用户虚构出的典型人物，帮助团队理解不同用户、他们的目标与痛点。这些背景能让你看明白某些技术决策的缘由。

*查阅现有文档*

和相关人员聊过之后，下一步是仔细阅读所有能找到的文档，包括架构决策记录（architecture decision record，ADR）。有了对项目的总体认识，文档中的许多内容应该开始说得通了。此时，你的目标是尽可能通过文档了解代码库。

其中重要的一部分，是那份大名鼎鼎的“项目入职文档”：它应当告诉你如何在本机把项目运行起来。Docker 等工具出现后，这类文档比过去好用了一些，但逐项核对仍可能费时费力。

你还在熟悉项目，此时不必急着写正式文档；但要随手记下发现，并标出文档中的缺口。以后回来补上，也是为团队做贡献的好办法。

#blockquote[
  #align(center)[*文档陷阱*]

  我是丹（Dan）。有一次，我花了三天试图弄懂一个复杂的身份认证系统，认真读着一份自以为最新的文档。最后我去向队友求助，他笑着说：“那是两个版本前的文档。去年我们把认证系统整个重写了。”教训是什么？文档可能骗你，代码不会。读到的内容，要拿实际运行的系统核实；也不要怕求助。一次三分钟的交谈，本可以替我省下三天。
]

*理解架构与项目结构*

弄清项目全貌、看过现有文档后，就该检查代码库的架构和组织方式。深入阅读代码、配置或动手编写之前，这一步很重要。项目结构能透露大量信息，给你更完整的视角，方便日后在代码库里找路。

大多数项目都遵循某种架构模式：有些是有意设计的，有些则自然演变而来。先辨认代码库采用的是哪一种，或哪几种模式的组合。

_按层组织（package by layer）_，是根据技术职责横向组织代码。顶层目录通常包括控制器、服务、仓储和模型。这种方式把同类技术组件放在一起，便于找到某一类组件。示例：

```text
src/
  ├── controllers/
  │   ├── UserController.java
  │   └── ProductController.java
  ├── services/
  │   ├── UserService.java
  │   └── ProductService.java
  ├── repositories/
  │   ├── UserRepository.java
  │   └── ProductRepository.java
  └── models/
      ├── User.java
      └── Product.java
```

_按功能组织（package by feature）_，则围绕业务能力或功能纵向组织代码。顶层目录对应用户、商品、订单等业务领域。一个功能的各个部分集中在一起，更容易看清完整的业务流程。示例：

```text
src/
  ├── users/
  │   ├── UserController.java
  │   ├── UserService.java
  │   ├── UserRepository.java
  │   └── User.java
  └── products/
      ├── ProductController.java
      ├── ProductService.java
      ├── ProductRepository.java
      └── Product.java
```

_六边形架构（hexagonal architecture）_，又称端口与适配器架构（ports and adapters），通过代码组织将业务逻辑与外部事务分开。你会看到核心领域模型，以及围绕它、连接外部世界的适配器。这种模式强调业务规则与技术实现的隔离。示例：

```text
src/
  ├── domain/                  // 业务逻辑
  │   ├── model/
  │   └── service/
  ├── application/             // 用例与编排
  │   └── service/
  ├── ports/                   // 适配器接口
  │   ├── input/
  │   └── output/
  └── adapters/                // 技术实现
      ├── web/
      ├── persistence/
      └── messaging/
```

_微服务架构（microservices architecture）_，把功能拆成多个独立服务。如果项目采用微服务，你既要理解自己负责的服务内部如何组织，也要明白它在更大的生态中处于什么位置。下面的 `user-service` 等顶层服务，各自都是一个微服务：

```text
microservices-system/
├── user-service/
│   ├── controllers/
│   ├── services/
│   ├── repositories/
│   ├── models/
│   └── Dockerfile
├── product-service/
│   ├── controllers/
│   ├── services/
│   ├── repositories/
│   ├── models/
│   └── Dockerfile
├── order-service/
│   ├── controllers/
│   ├── services/
│   ├── repositories/
│   ├── models/
│   └── Dockerfile
├── api-gateway/
│   ├── config/
│   ├── filters/
│   └── routes/
└── shared/
    ├── common-models/
    └── utils/
```

=== 理解执行流程

_执行流程（execution flow）_是程序运行时指令依次走过的路径，包括决定执行哪些代码、按什么顺序执行的条件判断、循环和函数调用。

现在你知道项目为何存在、全貌如何，可以开始看代码了。不过此时我们还不写代码，也不深入分析，只是尝试摸清代码怎样流动。下面会介绍三种方法：找到应用的入口，追踪请求与响应，找出外部依赖。

*找到应用入口*

应用有许多扇“门”，也就是进入它的入口点（entry point）：主方法、公开 API、Web 界面等等。想了解应用的不同执行路径，从这些门开始很合适。

例如，在 Spring Boot Web 应用中，#footnote[本章的示例将使用 Spring PetClinic。即使你不熟悉 Java 或 Spring，应该也不难理解。]可以寻找 `@SpringBootApplication` 注解与 `main` 方法，找到主类：

```java
@SpringBootApplication
public class PetClinicApplication {
    public static void main(String[] args) {
        SpringApplication.run(PetClinicApplication.class, args);
    }
}
```

找到入口后，就可以沿着代码的执行流程往下走。这时，IDE 的调试器很有用：在 `run` 方法处设断点，再单步执行。你会看到框架在底层做了什么，这也是理解代码库的好起点。

还可以寻找应用的公开 API；在这个 PetClinic 示例中，它们是 REST 端点。下面的 `@GetMapping` 表明，请求 `/pets/new` 时会执行哪个方法。借助 IDE 和调试工具，就可以继续追踪这条执行路径：

```java
@GetMapping("/pets/new")
public String initCreationForm(Owner owner, ModelMap model) {
   Pet pet = new Pet();
   owner.addPet(pet);
   return VIEWS_PETS_CREATE_OR_UPDATE_FORM;
}
```

有许多入口能帮助你描绘应用的执行流程，常见的包括：

- _主方法或引导方法（main/bootstrap method）_：传统的执行起点，例如 Java 的 `main()`。
- _公开 API或控制器（public API/controller）_：向外部系统开放功能的端点。
- _事件处理器或监听器（event handler/listener）_：响应特定事件或触发条件而执行的代码。
- _定时任务（scheduled task/job）_：按预定时间间隔运行的功能。
- _生命周期钩子（lifecycle hook）_：在组件创建、启动或关闭时调用的方法。
- _插件或扩展点（plug-in/extension point）_：供应用扩展功能的接口。
- _消息消费者（message consumer）_：响应队列或消息代理发来消息的代码。
- _命令行参数处理器（command-line argument processor）_：处理启动参数的逻辑。
- _数据库触发器或存储过程（database trigger/stored procedure）_：响应数据变化而在服务器端执行的代码。

关键是知道该打开哪扇门。找到入口，就能从那里走进应用的执行流程。

*顺着数据走：追踪请求的旅程*

面对现有代码库，尤其是 Web 应用或 REST、GraphQL、gRPC 等 API，追踪一条请求如何穿过系统，是理解代码及其涉及的系统的好办法。文档和测试也许会告诉你“应该”发生什么；跟着请求走，才能看到“实际”发生了什么。

请求追踪（request tracing）有价值，因为它能：

- 揭示请求实际穿过多个组件和系统的执行路径；
- 找出涉及的各层，包括控制器、服务、仓储等；
- 显示途中发生的数据转换；
- 揭示隐藏的业务逻辑和校验规则；
- 展示错误实际上如何处理。

探索新代码库时，可以使用不少好工具。下面介绍几种。你不必每一种都用，但知道手边有什么总归有益。不妨试一试，看看哪些适合自己的工作方式。

*浏览器开发者工具。* 对于 Web 应用，浏览器开发者工具是检查请求和响应的好起点。下面的例子运行 PetClinic 应用，为一位主人添加新宠物（图 6-1）。

填写表单并点击“Add Pet”按钮，会向以下端点发送请求：

```java
@PostMapping("/pets/new")
public String processCreationForm(Owner owner, @Valid Pet pet,
BindingResult result,
      RedirectAttributes redirectAttributes) {
   if (StringUtils.hasText(pet.getName()) && pet.isNew() &&
   owner.getPet(pet.getName(), true) != null)
      result.rejectValue("name", "duplicate", "already exists");
   LocalDate currentDate = LocalDate.now();
   if (pet.getBirthDate() != null && pet.getBirthDate().isAfter(currentDate)) {
      result.rejectValue("birthDate", "typeMismatch.birthDate");
   }
   if (result.hasErrors()) {
      return VIEWS_PETS_CREATE_OR_UPDATE_FORM;
   }
   owner.addPet(pet);
   this.owners.save(owner);
   redirectAttributes.addFlashAttribute("message", "New Pet has been Added");
   return "redirect:/owners/{ownerId}";
}
```

打开开发者工具的“网络”（Network）面板，就能看到发往 `/pets/new` 的 `POST` 请求，并检查请求头、请求载荷、响应等信息，如图 6-2 所示。

*API 测试工具。* 如果只想直接测试某个 API 端点，而且它是简单的 `GET` 请求，把 URL 输进浏览器即可看到结果。若是 `POST`、`PUT`、`PATCH`、`DELETE` 等其他请求方法，就需要 API 测试工具。Postman、Insomnia、Bruno 都是不错的选择；许多主流 IDE 也有功能相近的插件。

上一小节里，我们在浏览器中提交表单，用开发者工具查看背后的 `POST` 请求。但如果不想经过界面，而要直接测试端点呢？这正是 API 测试工具的用武之地。它让你发送带有请求头、授权信息、请求体等内容的 `POST` 请求；发送后还能检查响应，完全绕过界面（图 6-3）。

你可以用 Postman 之类的工具测试端点，检查以下方面：

- _必填字段与数据类型_：请求体中哪些字段必填？预期格式是什么，例如字符串、数字还是数组？
- _输入校验行为_：API 如何处理无效数据、缺失字段、格式错误的 JSON，以及空字符串、`null` 等边界情况？
- _身份认证与授权_：受保护的端点是否正确拒绝未经授权的请求，并接受有效凭据？
- _响应结构与状态码_：请求成功和不同类型的失败（400、401、404、500 等）分别返回什么数据？
- _错误信息质量_：错误响应能否提供清晰、可用于排查问题的提示？
- _性能特征_：响应耗时多少？是否有异常缓慢的端点？

*日志。* 日志让你看到系统内部的行为。在许多应用中，它可能是生产环境里排查问题、追踪请求路径的唯一工具。阅读代码时，留意这样的日志语句：

```java
log.info("Finding owner with id: {}", ownerId);
```

下面的端点列出某位主人的所有宠物。如果带着有效的主人 ID 请求它，日志中会出现两条新记录（图 6-4）；你还会看到花括号被实际值替换：

```java
@GetMapping("/owners/{id}/pets")
public List<Pet> findAllPets(@PathVariable("id") int ownerId) {
   log.info("Finding owner with id: {}", ownerId);
   Optional<Owner> owner = ownerRepository.findById(ownerId);
   if (owner.isPresent()) {
      var pets = owner.get().getPets();
      log.info("Found {} pets for owner", pets.size());
      return pets;
   }
   return null;
}
```

*调试。* IDE 的调试功能可以让你逐步跟踪代码执行，理解复杂业务逻辑时尤其宝贵。再看看前面的宠物创建校验：

```java
@PostMapping("/pets/new")
public String processCreationForm(Owner owner, @Valid Pet pet,
BindingResult result
      RedirectAttributes redirectAttributes) {
   // Set breakpoint here
   if (StringUtils.hasText(pet.getName()) && pet.isNew()
   && owner.getPet(pet.getName(), true) != null)
      result.rejectValue("name", "duplicate", "already exists");
   // Additional validation...
}
```

你知道应用拒绝了新宠物的某个值，但为什么？只有这个条件判断中的各部分都为真，才会报“名称重复”。在这里设断点，就可以单步检查（图 6-5）：

- _每个条件的结果_：`StringUtils.hasText(pet.getName())` 返回 `true` 吗？`pet.isNew()` 是 `true` 吗？
- _对象的状态_：这位主人已经有哪些宠物？正在检查的准确名称是什么？
- _方法调用的结果_：`owner.getPet(pet.getName(), true)` 实际返回什么？

用 IDE 调试器单步走过复杂业务逻辑，你看到的不只是代码走了哪条路，还能明白它为什么走这条路。实际行为与你的预期不符时，这尤其有价值。例如，日志说宠物名称已存在，而你确信不对；调试器能让你直接查证。

*找出外部依赖*

很少有应用完全独立运行。现代应用通常要与公开 API、内部服务等外部系统通信。理解执行流程的重要一环，就是找出应用交互的所有外部依赖（external dependency）：其他 API、数据库、缓存等等。

在还没完全理解应用时，怎样找出它们？先看配置文件很有效。这个基于 Spring Boot 的 PetClinic 应用可以检查 `application.properties` 或 `application.yaml`，看看声明了什么依赖。以下配置说明应用依赖 PostgreSQL 数据库、外部服务和邮件主机：

```properties
# database
spring.datasource.url=jdbc:postgresql://db-server:5432/petclinic \
  spring.datasource.driver-class-name=org.postgresql.Driver
# external service
payment.service.endpoint=https://payments.example.com/api/v2
# email host
email.service.host=smtp.company.com
```

对于容器化应用，还可以检查 Docker Compose 文件或 Kubernetes 清单，找出关联的服务：

```yaml
# In docker-compose.yml
services:
  app:
    image: petclinic:latest
    depends_on:
      - mysql
      - redis
      - kafka
```

*找出内部框架与库*

探索已有代码库的一大难题，是碰到内部开发的框架和库。这些是团队为解决特定业务或技术问题而自建的方案。创建时，它们或许是正确选择；但新队员要探索、修改代码库时，它们往往带来独有的障碍。

团队为什么不采用外部方案，反而自己造一套？内部框架通常出于以下原因：

- 现有库不具备原团队需要的功能；
- 团队有特别的安全或性能要求；
- 引入外部方案的总成本太高；
- 团队为迅速解决一个问题做了工具，后来它逐渐发展壮大；
- 团队不知道现成方案存在，或没有充分理解它。

#blockquote[
  做“元工作”比做真正的工作更有趣。

  ——Thoughtworks 总监、软件架构师、作家及演讲者尼尔·福特（Neal Ford）
]

遗憾的是，这些自建方案常常文档不全、找不到最初的开发者，维护也不连贯。

*识别内部框架。* 内部框架直接嵌在代码库里，可能比外部依赖更难辨认。以下迹象表明，你可能面对的是自建方案：

- _包命名模式_：带公司专属前缀的包，或名称笼统的包，例如 `com.yourcompany.framework`、`utils.common.core`、`internal.shared`。
- _自定义基类_：许多类继承 `BaseService`、`AbstractController`、`CommonEntity` 等自定义基类，往往意味着有一套框架代码。
- _自定义注解_：不属于常见框架的非标准注解，常是内部方案的信号。例如：
  ```java
  @Entity
  @CompanyTable(name = "users", audit = true)
  public class User extends BaseCompanyEntity {
      @CompanyField(encrypted = true)
      private String email;
  }
  ```
- _职责宽泛的工具类_：`AppUtils`、`BusinessHelper`、`SystemManager` 等跨越应用多个领域、承担多种职责的类。
- _繁重的配置_：大量不符合标准库惯例的自定义 YAML／XML 文件或配置类。

*与内部框架打交道。* 以下做法能帮助你探索它，并让代码比你接手时更好：

- _先找使用示例_：在代码库中搜索其他开发者如何使用框架。真实例子往往比文档更能说明问题。
- _查找测试_：框架代码需要适应多种场景，有时测试覆盖反而更好。测试能揭示预期行为与边界情况。
- _边学边记录_：记下框架做什么、怎样使用。哪怕最基本的文档，也能帮到后来者。
- _查版本控制历史_：借助 `git blame` 和提交消息，弄清框架为何而建、如何演变。
- _评估取舍_：想想框架是否仍有价值，还是已成为维护负担。有时长期来看，改用标准库更合适。
- _逐步改进_：使用框架时践行本章稍后介绍的童子军法则，改善命名、补充文档或提高测试覆盖率。

=== 逐步建立心智模型

心智模型是你在脑中建立的“系统如何运作”的图景。建立可靠的模型，需要时间与有意识的练习。想理解一个系统，逐步拆解会容易得多。与其试图一次搞懂整个电商应用，不如先沿着结账流程走一遍，再从那里扩展。也别让工具或完美主义妨碍你；很多时候，随手画在草稿纸上的简单模型就足够了。

下面介绍几种实用做法：把复杂系统拆小、把心智模型画出来，并逐渐扩大理解范围。

#blockquote[
  #align(center)[*关于 AI*]

  文本绘图如今还有一个好处：生成式 AI 可以先帮你起草，再由你手工完善。你可以向 AI 工具描述系统或流程，让它生成 Mermaid 语法，然后反复修改结果，使之符合实际需要。
]

*拆解复杂系统*

拆解是建立心智模型的重要部分。刚加入大型代码库，如果_试图一次理解所有东西，既容易不堪重负，也没有效率_。更好的办法，是将复杂系统分成可掌握的小块。

前面介绍的应用入口，就是一个很好的起点。例如，电商应用中可能有以下几条执行流程：

- _新客户流程_：新用户注册，成为客户，收到促销优惠券。
- _结账流程_：用户购买购物车中商品时，会发生什么。
- _商品评价流程_：客户对已购买商品给出反馈。

这些都是把复杂系统拆成小块的例子。看过一条新评价如何写入、涉及哪些代码之后，你就能开始建立对这段流程的心智模型。每个人的学习方式不同；你也许更愿意围绕代码，而不是围绕流程建立模型。如果应用按功能组织包，就可以逐个功能建模。下面集中列出了购物车功能相关的代码：

```text
src/
├── cart/
│   ├── CartController.java
│   ├── CartService.java
│   ├── CartRepository.java
│   ├── Cart.java
│   ├── CartItem.java
│   └── dto/
│       ├── CartDTO.java
│       └── CartItemDTO.java
```

*把心智模型画出来*

把代码间的关系可视化，有助于建立心智模型。第四章介绍了软件建模和多种可用的图。你的图不必专业漂亮：简单草图、完整的 UML 图都可以。选择能帮助你理解系统的细节程度即可。第一步是确定图的类型，不同的图适合不同目的：

- _流程图（flowchart）_：帮助理解顺序流程与决策点。
- _实体关系图（entity–relationship diagram）_：厘清数据结构及其关系。
- _时序图（sequence diagram）_：展示组件如何随时间交互。
- _组件图（component diagram）_：展示高层架构与依赖。
- _思维导图（mind map）_：按层次组织相关概念。

一开始可以画得简单，随着理解加深再添细节。例如，要描绘电商系统的结账流程，可以先只画主要组成部分。下面是用 Mermaid 语法编写的简单流程图；Mermaid 是一种流行的基于 Markdown 的绘图工具：

```mermaid
graph TD
    A[Shopping Cart] --> B[Checkout Form]
    B --> C[Payment Processing]
    C --> D[Order Confirmation]
```

以上代码会生成图 6-6 那样的流程图。

学到更多后，可以加入具体服务、数据库交互和外部集成。例如：

```mermaid
sequenceDiagram
    participant U as User
    participant FE as Frontend
    participant API as API Layer
    participant CS as CartService
    participant PS as PaymentService
    participant OS as OrderService
    participant DB as Database
    participant PP as Payment Provider

    U->>FE: Click "Checkout"
    FE->>API: POST /checkout
    API->>CS: validateCart()
    CS->>DB: getCartItems()
    DB-->>CS: cartItems
    CS-->>API: validation result
    API->>PS: processPayment()
    PS->>PP: authorizeCharge()
    PP-->>PS: authorization
    PS-->>API: payment result
    API->>OS: createOrder()
    OS->>DB: saveOrder()
    DB-->>OS: orderConfirmation
    OS-->>API: order details
    API-->>FE: success response
    FE-->>U: Display confirmation
```

这段代码生成图 6-7 所示的图。

*逐渐扩大范围*

理解单个组件后，再逐步把注意力扩展到整个系统的行为：

1. 从孤立的单个方法开始。
2. 转向类及其直接依赖。
3. 再看跨越多个组件的功能流程。
4. 最后理解安全、事务处理等横切关注点（cross-cutting concern）。

这种循序渐进的方式，能避免认知负担过重，同时逐步形成对系统的全面认识。

花时间建立准确的心智模型，修改代码库时就能做出更好的决定。记住，这是一个持续、耗时的过程。系统不断演变，即使经验丰富的队员，也在持续修正自己对它的理解。了解了怎样理解陌生代码库，接下来看看一套可供参考的工作流程。

== 一套示例流程

随着经验积累，你会逐渐形成处理现有代码的直觉。但一套流程仍有帮助。克里斯托弗·贾德（Christopher Judd）在训练营中教授以下方法：

1. 从源代码管理系统克隆项目。
2. 阅读 README、编码规范、架构说明和其他辅助文档。
3. 边做边记笔记：架构、构建命令、常用 SQL、行业标准、术语等。别怕把笔记分享给队友。
4. 检查构建脚本。
5. 检查项目依赖。
6. 检查项目结构：包、命名空间、模块、构建产物等。
7. 检查 CI/CD 流水线。
8. 安装项目依赖的构建工具、运行时与语言环境。
9. 在 IDE 中：
  - 运行并调试应用；
  - 在值得关注的方法上设断点，将它们与运行中的应用联系起来；
  - 运行并调试单元测试；
  - 在测试涉及的关键方法上设断点，观察它们如何作用于运行中的应用。
10. 在命令行中：
  - 构建项目产物；
  - 运行单元测试；
  - 启动必需的容器，例如数据存储；
  - 在本地运行应用，确认端口与 URL 等信息。

理解已有代码库是一个反复深入的过程。第一次通读不可能全部弄懂，这完全正常。每处理一个问题、开发一项新功能，你都会比以前更了解它。

== 安全地做出改动

掌握了理解现有代码库的方法和流程之后，就该学习怎样安全地修改它。已有系统很可能经历了多轮迭代和功能添加。你不能像莽撞的拳手一样，一进拳台就胡乱挥拳，在第一回合耗尽力气。要有条理地探索代码库，谨慎行事，避免把东西弄坏。你或许听过“快速行动，打破常规”（move fast and break things）；在某些场景它可能适用，但这里不合适。

=== 安全重构

维护遗留系统和已有代码库时，往往有机会通过重构改善可读性、性能等方面。这时需要先有计划，别想一次做太多。

*依靠现有测试*

前面已经说过，测试在理解代码库时作用很大；它也让重构更安全、更容易。如果项目有全面的测试套件，就充分利用它。测试是你的安全网：做一点小改动、运行测试，确认没有波及项目其他地方。

下面的例子重构 `calculateTotal`：把计算小计与应用折扣分开。重构的目标是改善结构、保持行为不变，所以应避免修改测试。每完成一步，都要运行与这个方法相关的测试，确认行为仍然一致：

```java
// Before refactoring
public double calculateTotal(Order order) {
    double total = 0;
    for (OrderItem item : order.getItems()) {
        total += item.getPrice() * item.getQuantity();
    }
    if (order.hasDiscount()) {
        total = total * (1 - order.getDiscountRate());
    }
    return total;
}
// After refactoring
public double calculateTotal(Order order) {
    double subtotal = calculateSubtotal(order);
    return applyDiscount(subtotal, order);
}
private double calculateSubtotal(Order order) {
    return order.getItems().stream()
        .mapToDouble(item -> item.getPrice() * item.getQuantity())
        .sum();
}
private double applyDiscount(double amount, Order order) {
    return order.hasDiscount()
        ? amount * (1 - order.getDiscountRate())
        : amount;
}
```

*重构前补测试*

前面的例子依靠已有测试，确保项目其他部分未受影响。如果应用对你打算修改的代码没有足够的测试覆盖，就先补测试，再重构现有代码。这种做法有时称为测试驱动重构（test-driven refactoring）：

1. 编写记录当前行为的测试。
2. 确认测试在当前实现下通过。
3. 重构代码。
4. 确认测试在新实现下仍然通过。

下面的单元测试确认：订单符合折扣条件时，订单服务计算总价会正确应用 10% 折扣。

```java
@Test
public void calculateTotalAppliesDiscountWhenOrderHasDiscount() {
    // Given
    OrderItem item1 = new OrderItem("Product1", 10.0, 2);
    OrderItem item2 = new OrderItem("Product2", 15.0, 1);
    Order order = new Order(Arrays.asList(item1, item2), true, 0.1);

    // When
    double total = orderService.calculateTotal(order);

    // Then
    assertEquals(31.5, total, 0.001); // (10*2 + 15*1) * 0.9 = 31.5
}
```

改动前先写这样的测试，既能帮你理解现有行为，也让你有把握确认重构保留了它。

#blockquote[
  给已有代码库补测试时，首要目标是记录当前行为，而不是改变它。即使你知道有更好的重构方式，或确信某处是缺陷，也应先写测试确认当前行为。测试就位后，再回来修复缺陷或继续重构。
]

=== 童子军法则

_童子军法则（scout rule）_是软件开发中的一条原则：“离开时，让代码比你接手时更好。”它源于美国童子军的露营理念：离开营地时，要让它比来时更干净。

这条法则鼓励你每次修改文件时，都顺手为代码质量做一点小而持续的改善，例如：

- 补充缺失的文档；
- 把变量或方法名改得更清楚；
- 拆分过于复杂的方法；
- 删除不再使用的代码；
- 修复发现的小缺陷。

下面的例子只是改善方法名、加入类型参数、改用增强型 `for` 循环、补上文档，就在不改变核心功能的情况下，显著提高了可维护性：

```java
// Before applying the Scout Rule
public void prcs(List l) {
    for (int i = 0; i < l.size(); i++) {
        Object o = l.get(i);
        // Process object
        // ...
    }
}
// After applying the Scout Rule
/**
 * Processes a list of customer records and updates their status in the database.
 *
 * @param customers The list of customers to process
 */
public void processCustomers(List<Customer> customers) {
    for (Customer customer : customers) {
        // Process customer
        // ...
    }
}
```

不过，随手清理代码也要与手头任务保持平衡。在大型代码库中，如果一味改善代码，你可能忙了半天，才发现原本要修的问题还没碰。

能改善的代码，不必都立刻改善。决定是否重构时，考虑以下因素。

适合重构的情形：

- 正在处理的代码难以理解；
- 需要在这块代码中增加功能；
- 正在修复这里的缺陷；
- 这块代码引起性能问题；
- 多位开发者经常共同修改它。

适合暂缓重构的情形：

- 代码运行正常，也很少需要改；
- 截止时间紧迫；
- 破坏代码的风险超过改善带来的收益；
- 重构会牵涉大量超出当前任务的改动；
- 缺少足够的测试覆盖，无法保证安全。

=== 小步修改，便于撤回

修改现有代码，最安全的办法是每次只做一点，并确保容易撤回，不至于牵动整个系统。这项能力需要不断练习。你或许想一次解决复杂问题，产品负责人也可能推动规模更大、影响更显著的改动；但你的目标应该是做较小的修改，不扰乱系统整体。

*变更管理策略*

对软件团队来说，_变更管理策略（change management strategy）_是一套有结构的方法，用于处理应用改动：如何提出、审查、实施和追踪变更，从而维持代码质量和团队共识。如果坚持小步、可撤回的改动，策略就应把安全性和可见性放在前面。

实践中可以这样做：

- _让改动清楚可见_：把改动记录清楚，让别人容易理解。不必面面俱到，只需说明为什么改、怎样改。
- _加入验证环节_：设法确认改动符合预期。团队可以使用自动化测试、代码审查和静态分析等手段。
- _准备回滚_：墨菲定律说，可能出错的事终会出错。问题出现时，总要有撤回改动的办法。改动越小，回滚通常越容易。
- _观察改动效果_：留意意料之外的后果。这时，应用具备良好的可观测性（observability）就派上用场了。

*小而可测的增量*

习惯把工作拆成能分别测试的小步之后，修改现有代码库就没那么紧张，也更容易管理。这种做法有以下好处：

- 限制每次改动的范围，从而降低风险；
- 让测试更有针对性、更有效；
- 让代码审查更容易进行；
- 出问题时更方便排查。

这可能意味着：当功能请求太大时，你需要提出异议，将它拆成较小的功能，以控制每次改动的规模。记住，连续交付几次成功的小改动，胜过一次引入缺陷的大改动。

假设有人要求修改系统处理订单的方式。下面的 `processOrder` 已经承担了太多职责，值得重构。与其一口气改掉整个方法的逻辑，不如先提取一部分功能为小方法，为它写测试，确认正确后，再处理下一部分：

```java
// Instead of changing this entire method at once...
public void processOrder(Order order) {
    // Validate order
    // Calculate totals
    // Apply discounts
    // Calculate shipping
    // Apply taxes
    // Process payment
    // Update inventory
    // Send confirmation
}
// Break it down into smaller, separate changes:
// 1. First, extract the validation logic
private boolean validateOrder(Order order) {
    // Validation logic here
    return isValid;
}
// 2. Next, extract the totals calculation
private double calculateOrderTotal(Order order) {
    // Total calculation logic here
    return total;
}
// 3. Continue with other extractions, testing after each change
```

*版本控制的最佳实践*

你接触的大多数新项目，可能已经采用版本控制。但有时你会遇到版本控制不规范的现有代码，或需要从一开始建立好的做法：

- _遗留代码库_：旧项目也许有版本控制，却没有良好实践。大家可能直接向 `main` 提交，没有分支策略；提交消息不统一；堆积了大量未合并改动；仓库里还跟踪着本不该提交的生成文件或依赖。
- _个人或小型项目_：自己开项目，或在很小的团队里工作，容易想省去版本控制，觉得“只有我一个人”或“我们直接沟通就行”。但从一开始养成好习惯，可以防止技术债积累，也方便项目扩大或新成员加入。
- _开源贡献_：复刻仓库或参与开源项目时，需要理解并遵循项目的版本控制惯例，同时妥善维护自己的分支仓库（fork）。
- _承包或顾问工作_：加入已有项目时，你也许需要建立或改善此前未被重视的版本控制实践。

无论哪种情形，Git 之类的版本控制系统，都是安全修改现有代码库的重要工具。用得好，它就像安全网：你可以试验、追溯历史、与人协作，而不必担心丢失工作或破坏功能。

*有策略地提交。* 处理现有代码时，提交记录应能讲清代码如何一步步演变：

- _做原子提交（atomic commit）_：每次提交代表一项独立的逻辑改动。这样更容易理解、审查，必要时也更容易撤回。
- _写有意义的提交消息_：好的消息既说明改了什么，也说明为什么改。未来的开发者——包括未来的你——都会感谢这些背景信息。下面是好坏对比：
  ```text
  # 较差的提交消息
  修复缺陷

  # 较好的提交消息
  修复折扣码被应用两次时的订单金额计算

  客户同时在移动端和桌面端输入折扣码时，系统会重复应用折扣。
  此次修复确保每份订单只应用一次折扣。
  ```
- _经常提交_：别等积攒了几十项改动才提交。小而频繁、各有清晰目的的提交，更方便查出问题何时、在哪里引入。

*明智地使用分支。* 各组织、团队和项目的分支策略不同，但处理现有代码时有几条普遍适用的原则：

- _创建功能分支（feature branch）_：在专用分支中隔离改动，待准备好后再集成。主分支因此更稳定，你也能自由试验。
- _让分支保持短命_：分支存在越久，就越偏离主代码库，集成也越难。尽量在几天内而不是几周后合并。
- _合并前按需变基（rebase）_：适当时，把改动变基到最新的主分支上，确保你基于当前版本工作。注意，变基会重写提交历史；共享分支上尤其要谨慎。

*拉取请求与代码审查。* 拉取请求（pull request，PR）是开发者提出的分支合并请求。它让工作在集成前接受审查、讨论和自动检查。PR 应聚焦、易于审查。一次改动横跨 20 个文件、修改 1000 行代码，审查起来很困难。尽量让每个 PR 只处理一项明确的问题。

代码审查时，要说明你在解决什么问题，以及改动如何解决它；相关问题单或需求也应附上。代码审查的目的是改进方案，而非批评开发者。听取建议，愿意反复打磨自己的做法。

可见，修改已有代码库不该莽撞，但也不必怕留下自己的成果。借助测试安全重构，践行童子军法则，专注小而可撤回的改动。

== 小结

与现有代码打交道，是让你从写代码的人成长为软件工程师的一项基本能力。本章探讨了如何在代码库中找路、理解它，并安全地修改它。你学会了先看全局、查阅文档、理解项目架构；学会了通过寻找入口、追踪请求、识别外部依赖来掌握执行流程；也知道怎样拆解复杂系统、画出各部分关系，逐步建立心智模型。最后，我们讨论了如何通过谨慎重构、童子军法则和良好的版本控制实践，让改动更安全。

这些能力绝非可有可无，而是软件工程师成长所必需的。从零开发新应用固然有趣、令人兴奋，但职业生涯中的大部分时间，你多半要面对已有代码。掌握这些方法，无论代码库规模多大、多复杂，都能帮助你迅速而自信地作出贡献。

== 付诸实践

知识还要付诸行动。下面这些练习能帮助你在现有代码中运用探索与修改的能力：

1. 找一个感兴趣的开源项目，只读不写，花 30 分钟探索代码库，重点理解它的结构与组织方式。
2. 选一个 Web 应用，例如 PetClinic，完整追踪一段用户旅程：从界面交互，到 API 调用，再到数据库变化；依次使用浏览器开发者工具、日志和调试器。
3. 从开源项目里挑一个难懂的方法，在不改变行为的前提下重构，提高可读性。
4. 找一个测试覆盖很少的遗留项目，练习补写记录现有行为的测试。
5. 从真实代码库中选一段业务流程，画一张心智模型图——手绘、流程图、时序图或组件图都可以——展示代码实际如何流动，再请队友核对。
6. 在现有代码库中，借助小而可撤回的提交完成一次复杂改动，并请同伴评价你的提交策略。
7. 在自己的项目中践行童子军法则：找出三处可以做的小改进，让代码比你接手时更好。
8. 找出项目的一项外部依赖，研究怎样安全升级或替换它，包括影响分析与回滚计划。

== 延伸阅读

- #link(
    "https://martinfowler.com/books/refactoring.html",
  )[Refactoring: Improving the Design of Existing Code by Martin Fowler (Addison-
    Wesley Professional, 2018)]
- #link(
    "https://www.oreilly.com/library/view/working-effectively-with/0131177052",
  )[Working Effectively with Legacy Code by Michael Feathers (Prentice Hall, 2004)]
- #link(
    "https://leanpub.com/gettingtoknowIntelliJIDEA",
  )[Getting to Know IntelliJ IDEA by Trisha Gee and Helen Scott (JetBrains, 2021)]
