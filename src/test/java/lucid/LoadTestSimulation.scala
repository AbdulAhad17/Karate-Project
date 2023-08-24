package lucid

import scala.language.postfixOps
import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

class LoadTestSimulation extends Simulation {
  val environment = scala.util.Properties.envOrElse("LUCID_ENVIRONMENT", "dev")
  val duration =
    Integer.parseInt(scala.util.Properties.envOrElse("LOAD_DURATION", "60"))
  val users =
    Integer.parseInt(scala.util.Properties.envOrElse("LOAD_USERS", "100"))

  val protocol = karateProtocol()
  protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
  protocol.runner.karateEnv(environment)

  val therapist = scenario("therapist").exec(
    karateFeature("classpath:lucid/load/TherapistList.feature")
  )
  val graphql = scenario("graphql").exec(
    karateFeature("classpath:lucid/load/ConsentFormGraphql.feature")
  )
  val contactProfileEvents = scenario("contact-profile-events").exec(
    karateFeature("classpath:lucid/event_logs/ContactProfileEvents.feature")
  )

  def whatever = rampUsers(users) during (duration seconds)

  setUp(
    therapist
      .inject(whatever)
      .andThen(
        graphql.inject(whatever)
      )
      .andThen(
        contactProfileEvents.inject(whatever)
      )
  ).protocols(protocol)

}
