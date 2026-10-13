#import "@preview/ilm:2.1.1": blockquote

= 自动化测试

#blockquote[
  质量不是一种行为，而是一种习惯。

  ——哲学家威尔·杜兰特（Will Durant）对亚里士多德观点的转述
]

新年伊始，许多人会立下目标，希望以更健康的方式生活。但吃一顿健康餐、去一次健身房，并不能实现目标；关键是大多数时候都坚持做出有益健康的选择。同样，高质量、易维护的软件，来自编写、审查和测试代码时始终保持良好习惯。维持健康的生活方式并不轻松，开发软件也是如此；找借口只会让你退步。

然而，养成习惯并非一路顺畅。许多开发者会自我怀疑：自己的决定对吗？解决问题的方式会不会受到质疑？编写高质量软件是一门需要经常练习的功夫。日积月累，你投入的测试工作会成为有效的保障，队友和未来的自己都会感谢你。本章将介绍自动化测试的益处、常见的测试类型，以及如何编写测试。

== 自动化测试的益处

为了验证已经写好的代码，再写一份代码，你对此有所怀疑很正常。有时，这似乎不值得费力；你可能还会想，它是否只是又一阵潮流，或只是给简历增光的手段。但自动化测试远不止于此。它是一项宝贵的技能，也是对代码库的重要投资。

下面，我们会看看自动化测试的具体益处：它如何提高代码质量、增强你对自己工作的信心，并最终让你成为更高效的工程师。理解这些益处，能帮助你明确测试工作的重点，也能明白为什么投入时间进行自动化测试有利于职业成长。

=== 充当文档

加入一个已有项目，难免让人不知从何下手（第六章会讨论该怎么做）。项目有文档，已属幸运。#footnote[文档能及时更新且准确无误，就更难得了。]若运气更好，你或许还能先请首席开发者或领域专家讲解全貌。但这并非总能做到；文档可能很少，甚至根本不存在。这时，写得好的测试就是你的救星。

假设你要修复某类支付卡的处理问题。如果既没有合适的文档，也没有测试，你只好在陌生、很可能相当复杂的代码中翻找，或向同事求助。

再设想，你找到一套完整的支付测试。其中有个 `PaymentProcesserTests` 类，测试名称写得很清楚，例如：

- `shouldValidateValidCreditCardNumber`
- `shouldProcessCreditCardTransaction`
- `shouldProcessOrangePay`

这些测试让你知道模块有哪些功能，也指向相关代码。现代集成开发环境（IDE）可以方便地跳转到被测服务（有效阅读代码的方法见第二章）。如果测试失败，你也能顺着它找到代码库中最可能出错的地方。

你也许会发现一个名为 `shouldFailWhenCreditCardTypeIsOrangePay` 的测试，由此得知系统其实不支持 Orange Pay。这条信息能帮你迅速识别并解决问题，更新前端，并完善文档。

这个例子说明，测试可以充当文档，帮你更快熟悉代码库。持续改进测试套件（test suite），还能提升代码质量、减少生产环境中的问题，让你更快为项目做出贡献。

=== 提高可维护性

写出好用又易维护的代码，通常需要多年磨炼（详见第三章）。先写测试，就像开口之前先想一想：它能帮你理清思路、组织表达。初学者的首要目标往往只是让代码跑起来。这当然重要，但写测试能让你更早发现改进之处。

看下面的 `BlogPostController` 示例（为简洁起见，省略了实际代码）：

```java
public class BlogPostController {
   public void publish(Post post) {
       // save blog post to the database (flip isPublished to true)
       // log blog post has been published
       // send email to subscribers about the new post
   }
}
```

乍看之下，这似乎没什么问题。但一旦尝试为这个方法写测试，你很快会发现它做了太多事：

- 与数据库通信；
- 记录日志；
- 发送电子邮件。

这违反了单一职责原则（single responsibility principle）：“一个类应当只有一个引起它变化的原因。”

思考怎样测试这段代码时，你便自然而然地看到了它的缺陷。接下来可以把发布流程的各个部分重构为独立的类，让它们更容易测试和维护。

测试不仅验证功能，也引导你做出更好的代码设计。它帮助你在小问题变成大问题之前发现它们，让软件更易维护和复用。

=== 增强信心

自动化测试有许多益处，其中一项尤其突出：让你敢于放手写代码。在生活的许多场合，表现出信心有助于应对压力，迎接个人和职业上的挑战。软件开发本就是不断迭代的过程：我们反复编写、试验、重构。没有测试，你可能会束手束脚，生怕改动弄坏现有功能，也不敢尝试新技术或有创意的方案。有了扎实的测试套件，你就有了一张安全网。它会从根本上改变你写代码的方式：你敢于修改、尝试新方案、放心重构，因为你知道测试会帮你发现问题。

修改和重构代码可能令人紧张。你未必完全了解应用，副作用也往往难以预测。没有测试就动手，好比不系安全绳攀山：一切顺利时固然刺激，一次失手却可能酿成大祸。

在代码库中摸索时，测试就是安全网，让你能够更有把握地行动。起初你只想让新功能正常运行，但还必须考虑改动会如何影响整个系统。没有全面的测试，一切看似正常，问题却可能到了生产环境才暴露。

扎实的测试套件让团队能够：

- 放心重构代码；
- 确保改动不会破坏已有功能；
- 在问题进入生产环境前发现它们。

编写并维护全面的测试，还能让我们：

- 更好地理解系统行为；
- 在开发早期抓住缺陷，此时修复更简单、成本更低；
- 降低引入回归问题（regression）的可能性；
- 确保功能符合规格，并通过自动化测试维持代码质量。

这不只提高代码质量，也增强你作为开发者的信心。你能安心修改代码、增加功能和重构，相信测试会捕捉潜在问题。

写代码的信心来自知识、经验与工具的共同作用。在整个开发生涯中，自动化测试都是帮助你建立并维持这份信心的有力伙伴。

=== 带来一致性和可重复性

过去，开发者常常花无数时间进行手工测试。你会列出一套步骤，对新功能进行压力测试。即使大多数时候都照着步骤做，人工操作仍容易出错，难以精确复现，而且耗费大量人力和时间。人天生无法一遍又一遍毫无差别地做同一件事。

自动化测试则能给出一致、可重复的结果。测试脚本每次都严格执行相同步骤，不会像人一样遗漏或失误。只需点击按钮，或在构建过程中触发，就能以很少的额外劳动快速运行。回归测试（regression test）专门验证：代码变动后，现有功能是否依然正常。

有了全面的测试套件，无论环境如何，都能持续、反复地运行测试。自动化测试可以经常执行，#footnote[很可能每次提交代码时，都会作为持续集成（continuous integration）流程的一部分执行。]有效地进行回归检查：既能防止修复过的缺陷莫名其妙地回来，也能发现代码库变动引入的新缺陷。测试新功能时，可以省去昂贵的人工测试，依靠自动化测试。

== 自动化测试的类型

既然明白为什么要测试，接下来看看应该测试什么，以及什么不该测试。自动化测试涵盖 UI 测试、端到端测试、集成测试和单元测试。人们常用图 5-1 所示的金字塔来理解这些测试。

测试金字塔（testing pyramid）是软件测试中的重要概念，却常被误解，甚至完全忽视。迈克·科恩（Mike Cohn）提出的这一模型，直观地提示应用中应当有哪些类型的测试。

这三种自动化测试是：

*单元测试（unit test）*：将单个组件或函数与系统其他部分隔离，检验它自身是否正常工作。

*集成测试（integration test）*：验证系统的不同组件或模块如何协同工作。

*端到端测试（end-to-end test，E2E test）*：覆盖整个应用，从用户界面一直延伸到后端系统。

这种结构源于软件测试中的基本权衡。越往金字塔上层走，测试执行越慢、维护成本越高，也越容易因变动而失败。单元测试可能只需几微秒，端到端测试却可能耗时数分钟。若有数百、数千个测试，差别就十分可观。下面逐一细看。

=== 单元测试

单元测试构成测试金字塔的底座，在测试套件中占比最大。可以把它看成代码必须履行的契约：如果代码的功能行为变了，相应的单元测试应当失败，提醒你留意可能的问题。单元测试将组件或函数隔离出来，确认每一部分自身都正确工作。

单元测试与静态分析（static analysis）、代码审查（code review）并肩，构成抵御缺陷的第一道防线。它应当容易编写、运行迅速，让你在开发时很快得到反馈。单元测试失败，通常会指向某个具体函数或某行代码，排查相对直接。速度和定位精度使单元测试在开发功能、持续集成时格外有用，也让开发者敢于快速迭代、改进代码。

=== 集成测试

集成测试更细致地验证系统的不同组件或模块能否作为整体协同工作。单元测试把代码中的各部分分开检查；集成测试的范围更广，关注它们之间的交互。

但与评估整个系统性能和功能的完整系统测试相比，集成测试的焦点仍较窄。它之所以重要，是因为有些问题只有在分别测试过的组件组合起来后才会出现。集成测试帮助我们发现这类问题，确保组合后的系统正确而高效地运作。这是软件开发生命周期（software development life cycle，SDLC）中维持系统整体完整性与可靠性的重要一步。

由于范围更大、复杂度更高，集成测试通常比单元测试运行得久，执行频率也往往更低。一旦失败，通常还需要进一步调查，才能找到是哪一处模块间交互出了问题。

=== 端到端测试

端到端测试是一种覆盖整个应用的综合测试，从用户界面一路检查到后端系统。它模拟真实用户场景，确认应用在实际环境中能按预期运行。

由于复杂而全面，端到端测试通常执行缓慢，需要投入较多资源和时间。因此，它的数量一般少于其他测试，运行频率也更低，常作为定时流程的一部分执行。端到端测试还可能很脆弱，更容易出现假阴性（false negative）：测试失败也许只是因为某个界面元素发生了微小变化，并非功能真的出了问题。排查端到端测试失败的原因，可能要费不少工夫。

尽管如此，端到端测试仍极有价值。它能让我们对系统的整体功能有较强信心，帮助确认应用各部分可以顺畅协同。

=== 各类测试该写多少？

测试的实际数量因项目而异，取决于应用的复杂度、所用技术栈，以及应用的重要程度。组织的标准和惯例也可能影响数量，其中或许包含覆盖率和测试质量的具体指引。关键是根据项目自身需求调整测试策略，同时保持均衡，覆盖应用中需要检查的各个方面。

=== 什么不该测？

全面测试对软件质量固然重要，明智地选择测试对象同样重要。制定测试策略时，请避开以下几类：

- 把重点放在自己的代码上，不必测试语言特性或框架代码。#footnote[语言和框架的维护者负责测试他们的代码，不是你。]
- 避免测试自动生成的代码，例如 getter、setter、构建器方法，以及自动生成的数据传输对象（data transfer object，DTO）。
- 避免直接测试私有方法；应关注调用它们的公共接口。
- 避免编写依赖外部服务的测试；单元测试可使用模拟对象（mock），集成测试可使用测试替身（test double）。

设计良好的测试套件应全面，却又易于维护：覆盖充分，不至于臃肿失控。专注测试自己的代码，省去不必要的测试，才能让测试套件更有效率、也更有效。现在你已经了解自动化测试的类型，以及精力该投向哪里，接下来谈谈代码覆盖率。

== 代码覆盖率

代码覆盖率（code coverage）衡量的是：运行测试时，有多少比例的代码得到了执行。可以把它想成电子游戏中的地图。一开始，地图一片漆黑；随着你走过、探索各个区域，它们才显现出来。执行到某段代码的测试就像点亮了那片区域，表明你去过那里。覆盖率高，意味着探索过地图的大部分地方；覆盖率低，则说明仍有缺陷可能藏身的盲区。

覆盖率在测试领域很重要，因此许多 IDE 和各编程语言的工具都提供支持。开发者可以直接在 IDE 中运行覆盖率分析，立即看到结果；也可以把工具接入持续集成与持续交付（CI/CD）流水线，强制要求达到最低覆盖率。若低于门槛，流水线就可能失败，进而阻止拉取请求（pull request，PR）合并。

覆盖率工具分析测试执行情况，生成报告，精确指出哪些代码行、分支和函数被执行了。你可能看到“行覆盖率 85%”或“分支覆盖率 72%”，这些数字表示测试期间执行到了多少代码。

覆盖率很有参考价值，但也有局限。常见的误解是：覆盖率越高，测试就自动越好。有些组织甚至规定，部署前必须达到 80%～90% 的最低覆盖率。规定的出发点虽好，却也可能诱发适得其反的行为。

开发者完全可以写出“执行了代码，却没有验证有意义的行为”的测试，相当于钻覆盖率指标的空子。一个测试调用了某个方法，却没有做任何有用的断言，照样计入覆盖率，却几乎不能防范缺陷。

与其把 100% 覆盖率当作目标——它往往只是好看的数字——不如把覆盖率当作测试工作的反馈。关键业务逻辑的覆盖率很低，可能说明那部分代码需要更多关注；数据载体类或配置代码覆盖率很高，则可能说明你在测试不必测试的东西。

应把精力放在验证行为的、有意义的测试上，让覆盖率引导你发现需要多加关注的代码。目的不是完成某个任意的数字要求；测试是为了让你对自己编写并最终发布到生产环境的代码有信心。理解覆盖率后，我们就开始写测试，亲手使用这些工具。

== 编写测试

现在来看看编写测试的具体方法。

=== 从哪里开始

无论使用哪种编程语言、框架或元框架（meta-framework），通常都有不止一种测试工具可选。本节使用 Java。你使用的语言可能有不同的配置方式和语法，但背后的思想是一样的。

创建项目后，要决定使用哪个测试框架。可选项很多；Java 中最流行的测试框架是 JUnit。要引入 JUnit，可以在 Maven 的 POM 文件中声明所需依赖并安装。

这里不细讲 JUnit；如果想深入了解，可以读它出色的用户指南。安装好 JUnit，就可以开始写测试了。

写测试主要有两种方式：先写测试，或后写测试。

- *测试先行（test first）*：测试驱动开发（test-driven development，TDD）等方法遵循“红—绿—重构”（red-green-refactor）循环。先写一个会失败的测试（红）；再写刚好能让它通过的最少代码（绿）；最后在不改变行为的前提下改进代码（重构）。
- *测试后补（test last）*：先实现功能，再编写测试。

两种方式各有优点，如何选择通常取决于项目要求和团队偏好。无论采用哪一种，都要通过断言（assertion）验证结果是否符合预期。

#blockquote[
  #align(center)[*关于 AI*]

  编写测试很适合借助 AI。你可以把现有测试套件中的示例交给 AI 工具，让它了解组织偏好的测试风格、命名习惯和编码规范。AI 能帮助生成测试用例、提出你可能漏掉的边界情况、编写样板测试代码，还能协助重构已有测试，让它更易读。这样可以在遵循团队既有模式的同时，大幅加快测试工作。
]

=== 断言

断言是一个函数或方法，用于验证程序运行时是否满足特定条件。Java 有多种断言库，各有不同功能。

JUnit 5 提供了许多断言，可以执行各种验证。它们都是 `org.junit.jupiter.Assertions` 类中的静态方法。假如你要确认一次数学运算的和是否正确，可以使用接收两个整数的 `assertEquals`。第一个参数是预期值，第二个是实际值：

```java
@Test
void shouldAdd2Numbers() {
   int expected = 3;
   int actual = 2 + 1;
   assertEquals(expected,actual);
}
```

两数相等，断言通过，测试也通过；不相等，断言失败，测试随之失败。要熟悉可用的断言，请阅读你所用断言库的文档。

=== 编写单元测试

记住，单元测试相互隔离、独立运行，而且速度很快。设想有一个执行数学运算的类，我们需要为其中每种运算编写测试。下面是示例类 `Operations`：

```java
package com.fose;
public class Operations {
   public double add(double a, double b) {
       return a + b;
   }
   public double subtract(double a, double b) {
       return a - b;
   }
}
```

创建第一个测试前，先留意源代码的位置。这个类位于 `com.fose` 包。测试类应放在 `/src/test/java` 下，并与源代码处于同一个包中。下面将分别测试加法和减法，覆盖 `Operations` 类的全部功能。

这里采用测试后补的方式：功能已经实现，再写测试。你可以先为每项测试建好空方法：

```java
package com.fose;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
class OperationsTest {
   @Test
   void add() {
   }
   @Test
   void subtract() {
   }
}
```

首先需要一个 `Operations` 实例。你常会听到它被称为被测系统（system under test，SUT），指当前测试的那个组件、模块或系统部分。这里的单元测试只关注 `Operations` 类：

```java
class OperationsTest {
   private final Operations sut = new Operations();
}
```

有了被测系统的实例，就可以填入测试方法。这里没有什么特别的技巧，但务必覆盖边界情况——别让用户替你发现它们：

```java
package com.fose;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
class OperationsTest {
   private final Operations sut = new Operations();
   @Test
   void add() {
       assertEquals(5, sut.add(2,3));
       assertEquals(0, sut.add(-1,1));
       assertEquals(-5, sut.add(-2,-3));
   }
   // Additional tests omitted for brevity
}
```

=== 使用模拟对象

在软件测试中，模拟（mocking）指创建依赖项的仿真版本——在这个语境下，常称为测试替身——以便隔离被测代码。

什么是依赖项（dependency）？编写单元测试时，被测系统为了完成任务而依靠的任何其他类，都是依赖项。模拟对象有助于在单元测试中隔离这些依赖；而在集成测试中，依赖关系却带来显著挑战。集成测试要验证各依赖项如何配合，这可能很棘手：管理多个依赖、确保它们处于正确状态、处理彼此之间的交互，都会迅速增加测试的复杂度。就像同时抛接好几个球，你得一直留意每个依赖的行为及其对其他依赖的影响。

下面的 `UserService` 有两个依赖：`UserRepository` 和 `EmailService`。前者负责从数据库读取、向数据库持久化用户；后者负责发送邮件：

```java
package com.fose;
public class UserService {
   private UserRepository userRepository;
   private EmailService emailService;
   public UserService(UserRepository userRepository, EmailService emailService) {
       this.userRepository = userRepository;
       this.emailService = emailService;
   }
   public void registerUser(String username, String email) {
       // register user
   }
}
```

如果想为 `UserService.registerUser` 写单元测试，该怎么做？这个类目前有两个依赖；若把两者的真实实现都纳入测试，写出的就不再是单元测试，而是集成测试。

这时便轮到模拟框架（mocking framework）登场。我们不用生产环境中的 `UserRepository`，而用它的模拟对象：看起来像这个类，实际上却不是。你或许听过类似的说法：“它走路像鸭子、叫声像鸭子，却不是鸭子。”这个模拟对象看起来像 `UserRepository`，却不会执行将新用户持久化到数据库等真实业务逻辑；它只会按你设定的方式行动。

只测试 `UserService` 即可；各依赖项会有自己的单元测试。这里使用 Java 中流行的 Mockito 模拟框架，但相关概念同样适用于其他语言。

配置好 Mockito 后，就可以编写 `UserServiceTest`：

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
   @Mock
   private UserRepository userRepository;
   @Mock
   private EmailService emailService;
   @InjectMocks
   private UserService userService;
   @Test
   public void testUserRegistration() {
       String username = "newuser";
       String email = "newuser@example.com";
       when(userRepository.existsByUsername(username)).thenReturn(false);
       userService.registerUser(username, email);
       verify(userRepository).save(any(User.class));
       verify(emailService).sendWelcomeEmail(email);
   }
}
```

上面的测试用 `@Mock` 注解创建模拟依赖，因此无需真实实现，也能在受控条件下测试。随后，这些模拟依赖会自动注入被测类。

=== 编写集成测试

上一节的 `UserService` 同时依赖 `UserRepository` 和 `EmailService`。编写单元测试时，为了隔离 `UserService`，我们模拟了这两个依赖。

集成测试则要验证 `UserService` 如何与依赖项交互。先建一个名为 `UserServiceIntTest` 的测试；名称中的 `Int` 明确表示它是集成测试。

`UserService` 依赖仓储和邮件服务，所以必须先有这两个类的实例，才能创建 `UserService`。真实应用或许使用依赖注入框架，可以直接索取实例；这里需要手动创建：

```java
class UserServiceIntTest {
   private UserRepository userRepository;
   private EmailService emailService;
   private UserService userService;
   @BeforeEach
   void setUp() {
       userRepository = new UserRepository();
       emailService = new EmailService();
       userService = new UserService(userRepository,emailService);
   }
}
```

现在，`UserService` 使用的是真实依赖，而不是模拟对象，可以编写集成测试了：

```java
@Test
void shouldNotRegisterUserWithUsernameOfUser() {
   // Test valid user registration
}
@Test
void shouldRegisterValidUser() {
   // Test invalid user registration
}
```

=== 编写端到端测试

本例的端到端测试聚焦后端 API。测试需要真实的运行环境，这里使用带嵌入式 Tomcat 服务器的 Spring Boot。目标是让服务器实际运行，向它发送请求，并验证响应。下面是一个简短的端到端测试示例（完整示例可在 GitHub 找到）：

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
class UserRegistrationE2ETest {
   @Autowired private MockMvc mockMvc;
   @Autowired private UserRepository userRepository;
   @Autowired private EmailService emailService;
   @Autowired private ObjectMapper objectMapper;
   @BeforeEach
   void setUp() {
       userRepository.deleteAll();
   }
   @Test
   void testUserRegistration() throws Exception {
       String username =
               "testuser";
       String email = "testuser@example.com";
       User request = new User(username, email);
       // Perform the request
       mockMvc.perform(post("/api/users/register")
              .contentType(MediaType.APPLICATION_JSON)
              .content(objectMapper.writeValueAsString(request)))
              .andExpect(status().isOk());
       // Verify that the user was saved in the database
       Optional<User> savedUser = userRepository.findByUsername(username);
       assertTrue(savedUser.isPresent());
       assertEquals(email, savedUser.get().email());
       // // Additional verifications (welcome email sent) omitted for brevity
   }
}
```

这个测试做了不少事：

1. 为服务器配置随机端口。
2. 使用 `MockMvc` 获得 Spring MVC 的服务端测试支持。
3. 每次测试前清理数据库。
4. 模拟用户注册请求。
5. 验证响应与数据库状态。

这样便能测试从 API 请求到数据库交互的整条流程，确认系统端到端正常运作。

== 小结

本章探讨了自动化测试，以及它在软件开发中的关键作用。测试可以成为有价值的文档，提升代码质量，也为重构提供安全网。从单元测试到端到端测试，每一种都在确保软件按预期工作方面发挥着重要作用。

记住，和保持健康生活一样，写好软件靠的是建立好习惯，并持续做出正确选择。带着扎实的测试套件写代码，就像有教练指导，也有明确的训练计划。测试让你有信心继续前进、尝试新事物、做出修改，不必时刻担心失手。有了这份信心，你就能应对软件开发的复杂性，不断改进、适应新需求，同时不必惧怕破坏现有功能。

在今后的职业生涯中，努力让测试成为习惯。起初它或许像是额外工作，但长远来看，它对代码质量、项目可维护性和个人成长的益处难以估量。质量不是一次性的举动，而是持续的实践。拥抱自动化测试，不只是为了捉住缺陷，也是在让自己成为更高效、更自信、更娴熟的开发者。

== 付诸实践

写测试的能力不可能一夜练成，它来自持续实践。无论你正在开发新功能、修复缺陷，还是改善代码库，以下做法都能成为入门点。不要想着一次做完全部；先挑一两项适合当前情形的，从那里开始。待习惯养成，再逐步加入其他做法。记住，今天写一个测试，也胜过一个都不写。

_向开源库学习_

研究一个你喜欢的开源库：

- 阅读它的测试。
- 你从中了解了哪些原本不知道的功能？
- 它的测试做法与你有什么不同？
- 考虑把其中一些策略用到自己的项目中。

_把测试当作文档_

接手代码库中不熟悉的部分时：

- 先找现有测试。
- 如果测试缺失或不足，就在理解代码的过程中补写测试。

_改善现有代码库_

如果发现项目测试不足：

- 不要试图一口气补齐；逐步改进。
- 鼓励每位开发者，包括你自己，每天写一个新测试。

_从新功能开始写测试_

下次接到新功能时，先写测试。这有助于厘清需求，并从一开始就把代码设计得更好。

_用测试处理缺陷_

修复缺陷时：

- 先写一个能证明缺陷存在的测试；起初它应当失败。
- 写测试的过程，也可能成为重构代码、提升质量、可读性或可维护性的机会。

_推动团队重视测试_

如果遇到本可通过合适测试避免的问题：

- 补上能够捕捉该问题的测试。
- 把它当作团队共同学习的机会。
- 与经理讨论如何通过改进测试覆盖，预防今后出现类似问题。

_练习_

提高测试编写能力，唯有不断练习。可以尝试编程刻意练习题（code kata），以有结构、反复迭代的方式锻炼测试技能。

记住，构建扎实的测试套件是持续进行的工作。测试实践中每一个小小的进步，都会提升代码库的整体质量和可维护性。

== 延伸阅读

- #link("https://oreil.ly/Ui_00")[Single responsibility principle]
- #link("https://oreil.ly/DkLzi")[Mockito]
- #link("https://oreil.ly/eWw_h")[JUnit 5]
- #link("https://oreil.ly/b5rLP")[AssertJ]
- #link("https://oreil.ly/fOAgm")[Hamcrest]
- #link(
    "https://www.oreilly.com/library/view/clean-code-a/9780136083238",
  )[Clean Code: A Handbook of Agile Software Craftsmanship by Robert C. Martin(Pearson, 2008)]
