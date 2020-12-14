//
//  Order.m
//  Chateau
//
//  Created by Bogdan Coticopol on 28.08.2014.
//  Copyright (c) 2014 Bogdan Coticopol. All rights reserved.
//

#import "Order.h"

@interface Order() {
    NSString *_secret;
    NSString *_host;
    
    NSData *_requestData;
}
@end

@implementation Order

-(id)init
{
    if(self = [super init]) {
        //WebAPI secret
        _secret  = @"client=JSSeUgB6y9T7sgCRwJUs";
        //WebAPI host
        _host = [NSString stringWithFormat:@"http://lechateau.ro/ios/app/?%@",_secret];
    }
    
    return self;
}

#pragma mark - Object Methods

//generate the request object that will be send to server
-(NSURLRequest *)generateRequest
{
    //services will be a concatenated string
    NSString *servicii = [[self.content allObjects]componentsJoinedByString:@";<br>\n"];
    NSCharacterSet *toReplace = [NSCharacterSet characterSetWithCharactersInString:@"."];
    servicii = [[servicii componentsSeparatedByCharactersInSet:toReplace] componentsJoinedByString:@" / "];
    
    //url of the host
    NSURL *url = [NSURL URLWithString:_host];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    
    //WebAPI via POST
    request.HTTPMethod = @"POST";
    
    //encoded data
    NSString *stringData = [NSString stringWithFormat:@"nume=%@&email=%@&telefon=%@&data=%@&servicii=%@",
                            self.name, self.email, self.phone, self.bookingDate, servicii];
    NSData *postingData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = postingData;
    
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)postingData.length]
   forHTTPHeaderField:@"Content-Lenght"];
    
    
    return request;
}



#pragma mark - Class Methods
//generate the dictionary with services & prices
//TO-DO: in further version update this online
+(NSDictionary *)generateServicesMenu {
    NSDictionary *defaultServices;
    
    //get the last saved list
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    defaultServices = [pref objectForKey:@"Services"];
    
    //if not exists, get the default
    if(!defaultServices)
        defaultServices =
        @{
          @"Femei":@{
                  @"Tuns":@{
                          @"Simplu (vârfuri+breton)":@35,
                          @"Schimbare formă":@50
                          },
                  @"Coafat":@{
                          @"Perie":@{
                                  @"Păr scurt":@30,
                                  @"Păr mediu":@45,
                                  @"Păr lung":@50,
                                  },
                          @"Îndreptare/Bucle placă":@{
                                  @"Păr scurt":@25,
                                  @"Păr mediu":@30,
                                  @"Păr lung":@35,
                                  },
                          @"Ondulator":@{
                                  @"Păr scurt":@30,
                                  @"Păr mediu":@45,
                                  @"Păr lung":@50,
                                  },
                          @"Bigudiuri":@{
                                  @"Păr scurt":@25,
                                  @"Păr mediu":@30,
                                  @"Păr lung":@40,
                                  },
                          @"Împletit":@"15-35",
                          @"Uscat simplu":@10,
                          @"Extra styling":@10
                          },
                  @"Coafură speciala":@"100-300",
                  @"Coafură mireasa":@"200-250",
                  @"Spălat (manoperă+masaj)":@{
                          @"MOROCCANOIL": @{
                                  @"Șampon și mască":@{
                                          @"Păr scurt":@40,
                                          @"Păr mediu":@40,
                                          @"Păr lung":@55,
                                          },
                                  @"Tratament":@15,
                                  },
                          @"L'OREAL":@{
                                  @"Șampon și masca":@{
                                          @"Păr scurt":@30,
                                          @"Păr mediu":@30,
                                          @"Păr lung":@35,
                                          },
                                  @"Aplicare fiolă":@20,
                                  @"Spălat după vopsit (emulsie)":@{
                                          @"Păr scurt":@35,
                                          @"Păr mediu":@40,
                                          @"Păr lung":@45,
                                          }
                                  }
                          },
                  @"Vopsit":@{
                          @"Manoperă":@{
                                  @"Păr scurt":@40,
                                  @"Păr mediu":@50,
                                  @"Păr lung":@60,
                                  },
                          @"1 tub de vopsea + oxidant":@{
                                  @"INOA":@80,
                                  @"DIA Light Richesse":@70,
                                  @"LUOCOLOR":@70,
                                  @"MAJIREL":@70
                                  },
                          @"Cremă decolorantă PLATINUM":@40
                          },
                  @"Suvițe, ombre, balayage":@{
                          @"Manoperă":@40,
                          @"Produse":@"de la 30 lei"
                          },
                  @"Decapaj":@{
                          @"Manoperă":@{
                                  @"Păr scurt":@50,
                                  @"Păr mediu":@60,
                                  @"Păr lung":@70,
                                  },
                          @"Pudră (o cupă)":@45
                          },
                  @"Permanent":@{
                          @"Păr scurt":@170,
                          @"Păr mediu":@170,
                          @"Păr lung":@180,
                          },
                  @"Pachet coafor ALL INCLUSIVE":@{
                          @"Păr scurt":@240,
                          @"Păr mediu":@320,
                          @"Păr lung":@340,
                          },
                  @"Make Up":@{
                          @"Machiaj zi":@170,
                          @"Machiaj seară":@200,
                          @"Mireasă":@"250-300",
                          @"Probă mireasă":@150
                          },
                  @"Extensii gene (XTREME LASHES)":@{
                          @"Prima aplicare (160-200 gene)":@"110€",
                          @"Intreținere (2-3 săptămâni)":@170
                          },
                  @"Manichiură/Pedichiură":@{
                          @"Ojă clasică (OPI ciate)":@{
                                  @"Manichiură clasică":@35,
                                  @"Manichiură SPA":@48,
                                  @"Pedichiură clasică":@45,
                                  @"Pedichiură SPA":@58,
                                  @"Aplicare lac":@15,
                                  @"Caviar/Model in apă/unghie":@5
                                  },
                          
                          @"Ojă semipermanentă (GELeration)":@{
                                  @"Manichiură clasică":@57,
                                  @"Manichiură SPA":@70,
                                  @"Pedichiură clasică":@67,
                                  @"Pedichiură SPA":@80,
                                  @"Îndepartare ojă semipermanentă":@15,
                                  @"Aplicare ojă semipermanentă":@45
                                  },
                          @"Gel":@{
                                  @"Aplicare unghii cu gel":@80,
                                  @"Întreținere":@60,
                                  @"French":@20,
                                  @"Model":@"10-30"
                                  }
                          },
                  @"Cosmetică":@{
                          @"PCA SKIN":@{
                                  @"Tratament hidratare":@180,
                                  @"Tratament ten sensibil si cuperotic":@220,
                                  @"Tratament acneic":@230,
                                  @"Tratament ten matur":@240,
                                  @"Peeling (Estetique Peel, Sensi Peel)":@260
                                  },
                          @"MARIO BADESCU":@{
                                  @"Tratament hidratare":@150,
                                  @"Tratament acneic":@180,
                                  @"Tratament ten matur":@180
                                  },
                          @"Demachiere":@10,
                          @"Gommage":@15,
                          @"Masaj facial":@50,
                          @"Pensat formă":@35,
                          @"Pensat intreținere":@25,
                          @"Vopsit gene/sprâncene":@20
                          },
                  @"Epilat (ceara tradițională/unica folosință)":@{
                          @"Epilat lung":@40,
                          @"Epilat scurt":@30,
                          @"Epilat inghinal normal":@25,
                          @"Epilat inginal intim":@45,
                          @"Epilat fese":@20,
                          @"Epilat abdomen":@20,
                          @"Epilat lombar":@20,
                          @"Epilat brațe":@25,
                          @"Epilat axila":@20,
                          @"Epilat fața - total (+ demachiere)":@35,
                          @"Epilat fața bărbie/pomeți/perciuni":@15,
                          @"Epilat mustață":@15
                          }
                  
                  },
          @"Barbati":@{
                  @"Tuns":@{
                          @"Mașină de tuns":@20,
                          @"Scissors over comb":@40,
                          @"Contur și perciuni":@15
                          },
                  @"Spălat (manoperă+produse+masaj)":@20,
                  @"Nuanțat (cover 5')":@50,
                  @"Manichiură":@33,
                  @"Pedichiură":@45,
                  @"Epilat":@{
                          @"Epilat lung":@50,
                          @"Epilat inghinal partial/total":@"35/45",
                          @"Epilat fese":@25,
                          @"Epilat interfesier":@15,
                          @"Epilat piept":@35,
                          @"Epilat spate":@40,
                          @"Epilat brate":@30,
                          @"Epilat axilă":@20,
                          @"Epilat ceafă":@15
                          }
                  }
          
          };
    
    return defaultServices;
}

-(NSString *)description
{
    return _host;
}

+ (NSURLRequest *)getServices
{
    Order *tempOrder = [[Order alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",(NSString *)tempOrder]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    request.HTTPMethod = @"POST";
    
    NSString *apiCall = @"request=services";
    NSData *data = [apiCall dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)data.length] forHTTPHeaderField:@"Content-Lenght"];
    
    return request;
    
}



@end
