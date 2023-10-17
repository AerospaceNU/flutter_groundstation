import 'dart:typed_data';

import 'package:flutter_groundstation/hardware_interface/serial_groundstation_interface.dart';
import 'package:test/test.dart';

void main() {
  test("Parse Position Data", () {
    // Test data from: https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGEgOykrgAyeAyYAHI%2BAEaYxBIAbIEADqgKhE4MHt6%2BAaSp6Y4CoeFRLLHxXEm2mPZFDEIETMQE2T5%2BXIF2mA6Zjc0EJZExcYldTS1tuZ22E4Nhw%2BWjVf4AlLaoXsTI7BzmAMxhyN5YANQm%2B25iwCSECCwX2CYaAIIHRyeY55cKBPiCADoEI9nm9XgB6ABUoNOkNOxCY%2BFQAH1kkxkABrTAEZEEACeyUwCiBMMh4NBFLMhyoDCwVFObgA8gBZZmMiLIoQATSEABVsMzkbyXkIANJCZEAJReABEAJKM5HKF5uUXYXlCrnKbASgASyMp%2BzpCwZLLZHO5fIFQpF4qlsoVSpVao1vK1OuR%2Bopr3eDGOXjOFzcv3%2BBBJ%2ByePp9VON4VOupFyJl2AAahBVKtTlxvW8Y5gaHHlarsDLObzJXI3LzTvjCXTTr9iF4HKdkcimAQCMQ8NEvARMG2oG20ZjMOg26tVjmDrGvpKABrIixyABiK%2BRwWwESzAFYc%2BDwadeQgvugO0wG13mwRTlRiKgWDWT6daCbkH3%2B8RQbWx/nL02WzbDsux7PsB2RIdUXRLFx2RSdzn8KxXlOU4vDCAgAA5cRfBY3A/OIygqC4LBQg9TjlGVTmSe9gARFg2HQU50NQJ8vlfON307OIAVOZkmDxWIGUlNxTlQKgYRQySpOkmTZNOMjmDYC4VwktDBCwm9fg7TBiNU9D9jMbDHDYLSWGSXTkNQ/TDJvaiiQULYdP2JCXhQqhaFQDtTjERwCADJyXLcjyvKwWgmheMLCH8izXNvYKb37My4g7RyYqCzyb3RHZaAiEgHmciT3Iy05omAuI8TSqzBCqbDOKERglGzArLLUggapvOqGswMxKta9rTnfYhiEYYQut69D%2BuSBBUCIYb0l%2BEgYpMfxKKGPCuOIGVz2RBQlohQ8VxIU4AHdu0cIxTjPJoaxY9ymAUBBzjMBI4rwYAEBvAA3Zo8CYaJ6BfVBgG/Alf3pRtr1bdtO27Xt%2B0HCARxg%2BDlsCqrMOw9jMHWz9CLiYjSMPeqvj%2B1BPp0yyiq818WEIFNanG6qEmwnyoqwJq0b65nMsivysB65rYtagzsPwBRhvzGVan4jm9MEEWbzFiWqClgw8QFtGqds46WBTTwmmATBZcp%2BKqJ1vWwqYQ2NbltrubNlgZS2DtMkZu3Mbej7jzm6baHQN2FZw96CF5btgEN4heTwJTBZQ4WbIbTAmGCTBydoZQ5oc4alpW041vw4gV1fYOU2aBQdr2l4yMZbsRpdgRSG8owvAMYh4W03boyNfMTX5TdmXVSUuWRCjkUZSU5S3YVeQVbceteIs1VLPkKyrBDOfQjTL20yrN%2BwgBHY7G/31Rj7xY%2BAC9Kq1k7T5O8%2BTovxumDv/jn6fkq7%2BiB/oiv2OmKZizIw9BcQonJi0PAohaA5xlKCGueA671GUNBbEFdBagjIsEVAoh6iXXPMpZSt57yPgIM%2BdiGISoBkNjeAA4qgIGAMHqYGxIaWcR5sD90HsPUeyhGRCDlDPdkpx9igkXiWMsq9qyo0KqbRKyRG4FGRB/NOSjG4GAIGohupxgDJHLj5RupVOzIk%2BvrBQjcFCEjHKKBgM0zESSkmgLYSgpbA3/vHbCOiFBRxjhvdS2EFAdjMdvfsBjWivhGrtf%2BZFsSmB9CtURaQMgCGQaOHEkSXKsJ7nGPuAouEj1LMEOUERsBuDkLyfkkpTiSFEc6cRK9KxSMQnnXCBctpNB2ngpoBNlqwNePnDaKSsRpMrmROQyRyFjn/GEYApwIA2JvOEHYCgAndloHiU4DAW60AALSflpswfs6ApxdzYTkge5ZuHL3LEUmhpw9wnKyXOB0ipmQvEXCvG5VSMKGjwPSaU8oXlvIkZ8x4pwNCqCoOJLucR7xt3MGYSUiInBTIuvQIwpDAZGDiE%2BQwWYSp4n7GAMA8LDSuF%2BTU4sVzJHr1tlvNFbst54H9m4vemkQJGBMDuCw/zHSvPedciINDOWwPQfE14bhXyNG7EYQZqD0nTipL8%2BMiZkxpgsC8SULJ1TYElMc3M3cCxfGUJKHUQg5AmuRAPIQQgXg0OwMiCIchBTqs1ecnVQhTjzzBPq05HDckXPyciF4wQNRFJXIyU4CQKVLwkQ0mlJtip2WWalLlxrTXmvtVam1dqHVOqXBqrVFShDCuvqbJNWdMCSnzI3WimxaTYHoN9eoNb7xeFpLyTAZkYGggigQOUDB%2BCyuGegqkZL6TyUPAmCUqqIAusLTqvVmTDXsM4QG0eCZJQygAOoavtXyF4vI5Aev8NGup5Y43SJaqyqieJ7weEEGENC%2BI3b9RAuHOIK48DDX6H5eVV6/E3jug9RQVsAoUjFS8XUzR0DHWaJgH9XgFBDrQRkh5y6zl5NHoU4ppTyk6uRCmDVHrvkL1qVSi9TT%2BmfiLp7AgpdiDlwUJ0pg3SINUbiPRpDKDh2oZeD%2BesbbMjxtivAxBmRkNMduGJgQlVlCJKQdxjpBQkkMDaSx/%2B7HiASZwuEHG%2BMNMtI2px7TWM9OF2Lh9TjlUJV4CldM7TxxbPstcRkxV9Ip1JlTLOgtbrdUSV7f2wdimmOsz5pgQLqAlqjtpEqidyrp1ebnb5vVKEoPEBg3BhDXHUkdIQNB2D36mi/pgacZBeJgroGQ14SuYjyNr0vULa9SNsS8lBgy/xYkCAFcwPTBjrsWUAZKp5dLO04i/VoMiTZ%2BVfEEEDsZIkTQzLMj/bFZAeW25QNoOkYADBOUWG%2BTuEVaMysVaq1RfiFXu2vERUiCTlcZyPNODywFi5Nzbi4GYEjfHQb1ghoBaGIE4bgSgM1o5mYGtx2vVdFjXLnuWqBW9ktA2MY3gREiOUzK0bXoY%2BkSq0R6G0AGtsdrN5aD7zwCVm7Tgq3IAQeTSrwX7vRfwOOsiTJWTsk5DyfkgphRiglHDsRrp3R6gNFGfVHx/LfDcMgEMTgQTi/QqcFgTAwgQHB4hexT2kWoBp3Tsc2nEPRCHZVOOChjfcYBMgbY3xKJXjA5ZM3FvUkAhx3gW3pxtlmA0Kb1C5uh0AjJ%2B7i4lEbaO7987oZrudcY49z79B4eqeoG05CKgTAsTIjR8ikPsyk8p9WEbgP0Pfdp4z1n1A2zHjNZDqDD3GG12ll4fwwREQS/p4HOXyvEY0Tlc8ugAEyn6hqYBIYnEJiwpMZzx9gEJ7/5uXb5nnXXfsA94qwP%2BTmRh/qI95IePaN59l6X1Xi7ff1%2BFE3%2BeQPAgPfbP8HvnMUlWpb0hMkNTHuIBP%2BwpCKcz1C/cd99ROhFQBAPCmgAwL8Mxh7ntk9GYFOHPreEdBAOkBfAODeMHvsJRHvkxNLg2HgCgWJB/v7txnASRBTpYNYBrvvtJCGCACAIAYIMASSmYDuF4DAQompnthTodiQVrj0lrvQQQIwWYD1IdvCjwXEjKBwOsLQJwDuLwH4BwFoKQKgJwG4NYNYA2JsNsF8AcDwKQAQJoFIesBiCADuBoPoJwJIPIYYcoZwLwAoCAOYQYYoVIaQHALAEgJgKoD0H2CQOQJQM0MAFxuELQEINNMdAoXoWgGZHQPXAwMgiEWEagBETYdEckHQKMMAFwAZKQGkRkcQBEKwLsLwHkfQMQIyH2EkSkS4UEN4cgC8MQEEXYbUT0I0P8M0fwIICIGIOwFIDIIIIoCoOoDUboFwPoIYMYOoZYPoD2A4ZAOsKgMkPUA4RwPYVoTsHoHLvEYYLUFUZEbwKdEwMkJwDwNIbIdYTUSoRwNgHUb4W3KoBhAkNsgkJINosgMgFmPsACGYLMmoeQdMacLgIQEdLoasLwM4VoOsBAEgKUXEP4RALCfEFkTkVgJ9JAj1ggsdIyISPsXwHQJ%2BA4RANEDYdEGEM0HiCcbwKScwMQHiIyNENoD0M4VEQ%2BGwIIIyAwGsjYVgL2MAFcLQFtpSaQFgCrsArsEofgMNL0OTCsUoV4T4f2EKehLUDYa%2BNEAiLSR4FgDYSBCwJSesHdEESmJidiYwEKZ0cIFAr0dIBaYMWoDYboGYOMUYCgFMTYGqXMersoUsZkCsdsoyHoWTDCkykSPAOsN0L0M4BAK4FMB0EELSEMHjJUPkBvgILGXoIPpkImSMMmRGfUP0JMJ4O0JsbUEyX0HMNmUsLmXMOmWMVpC0JWRUBIOGesb0WcRwHIaQAoUoVcacA8U8S8W8R8dkd8bMkCbNE9PsFwGCfoYYZOKQCeIiKMF6SYWYRYRwFYaQHqVwBoOYd2bwFcfYY4bOS4fOTIRwGYBcT2c0RCUYaQOAukM4JIEAA
    // 12.7 volts batt, lat 40, lon -70
    const data = [ 3, 4, 0, 0, 0, 0, 0, 0, 1, 18, 0, 0, 176, 4, 0, 0, 144, 0, 0, 0, 0, 0, 0, 0, 18, 0, 0, 0, 0, 32, 66, 0, 0, 140, 194, 0, 0, 0, 0, 51, 51, 75, 65, 0, 121, 0, 0, 0, 128, 0, 0, 0, 235, 0, 0, 0, 255, 17, 0, 0, 0, 0, 0, 0, 128, 75, 206, 177, 14, 127, 0, 0, 255, 17, 0, 0, 0, 0, 0, 0, 0, 32, 1, 0, 0, 0, 0, 0, 144, 255, 255, 255, 255, 255, 255, 255, 46, 101, 104, 95, 112, 111, 111, 108, 77, 18, 64, 0, 0, 0, 0, 0, 232, 146, 206, 177, 14, 127, 0, 0, 0, 18, 64, 0, 0, 0, 0, 0, 0, 236, 1, 2, ];
    var interface = SerialGroundstationInterface();

    interface.callback(Uint8List.fromList(data));
  });
}