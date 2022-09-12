//> using scala "3.nightly"
//> using lib "org.typelevel::cats-effect:3.3.12"
//> using options "-Ycc"

/*********** Capture Checking **************/

import annotation.capability
import cats.effect.IO

def impure2: {*} String -> Int = _.toInt
def impure: String => Int = _.toInt
def pure: Int -> String = _.toString
def byName(x: -> Int): Int = x

@capability
trait Logger:
  def info(str: => String): Unit

object LoggerImpl extends Logger:
  def info(str: => String): Unit = println(str)

def foo(using log: Logger): {log} Int -> String = n =>
  log.info("foo calling...")
  pure(n)

@capability
trait LoggerF[F[_]]:
  def info(str: => String): F[Unit]

object LoggerIO extends LoggerF[IO]:
  def info(str: => String): IO[Unit] = IO.println(str)

def bar(using log: LoggerF[IO]): IO[{log} Int -> String] =
  log.info("bar calling...").as(pure)

/*********** Safer Exceptions **************/

import language.experimental.saferExceptions

val limit = 100d
class OddNumberNotAllowed extends Exception
class LimitExceeded extends Exception

def f(x: Double): Double throws LimitExceeded =
  if x < limit then x * x else throw LimitExceeded()

def g(x: Double): Double throws OddNumberNotAllowed =
  if (x % 2 == 0) then x else throw OddNumberNotAllowed()

def handler(x: Double ): Double =
  try g(f(x))
  catch
    case _: LimitExceeded       => -1
    case _: OddNumberNotAllowed => 0

/*********** Main **************/

import cats.effect.unsafe.implicits.global

@main def hello =
  println(foo(using LoggerImpl)(123))
  println(handler(99))
  bar(using LoggerIO).map(_.apply(22)).unsafeRunSync()
