> _**theme:** api improvement; separation and stabilization_

  * ~~refactoring~~
    * ~~decouple romloader and framework~~
    * ~~adhere to maven [SDL](http://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html) - http://sonatype.com/books/mvnref-book/reference/public-book.html~~
  * specific TODOs
    *~~sequence high-level build properly~~1.~~gamerom-api~~1.~~framework, romloader~~1.~~roms~~*~~refactor C to accept formatter, default to internal class~~*~~move examples out of framework into roms~~*~~update existing roms~~*~~add shared target to unzip os desktop romloader into shared~~*~~ControlTest (r-c4d3 controls)~~*~~GetToTheSpot (simplest playable game)~~*~~Hungries (simple 4-player game)~~* Rocks (bitmap collisions and special effects)
      * Warehouse (level loading)
  * replace default romloader rom with one that is freshly compiled, announces version info / stats
  *~~clean up releases~~*~~docs folder~~*~~romloader folder~~*~~rename api to docs~~*~~remove hx-classes~~*~~separate debug versions from release