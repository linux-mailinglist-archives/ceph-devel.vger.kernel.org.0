Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A8C50B017
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Apr 2022 08:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444204AbiDVGGT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Apr 2022 02:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444191AbiDVGGL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 22 Apr 2022 02:06:11 -0400
Received: from esa1.fujitsucc.c3s2.iphmx.com (esa1.fujitsucc.c3s2.iphmx.com [68.232.152.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6D450048;
        Thu, 21 Apr 2022 23:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1650607399; x=1682143399;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MpzxhrzR/o+iSKYaZhyBop5XI6vifGzr84/p6J1sXM4=;
  b=YsUnnxu7XDDWa8aaTdllqcWh7h4HmK/fl9ihK/Jet6IPJSDBY9S2wnz9
   XD5OkOzkShz9q40YFoE9OnrvgVazqlu3XIAbNvs+cHl9qSEG7F0/cL6bA
   CFXTQ+TdS5aBg9caPdxTEsI8/3CjiCOG7tiFwGJPF3osvZorMPQL4sYzh
   ZC1jLOBGwzXZS0QFDMqcHouM8dtF7XSXG+x7MPIF38Hk1earrgja/PZ4m
   gM2U2UdqsDDaOZ9m/IxgEQLnDvdU1elz7G35rxOy4YE87YGaN9G9wmWYJ
   YlYqKpq56x+7j1tP42rxHUUB596nnUvUmHpT31yv4BO8xc/m6RzUHnZQ8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="62644769"
X-IronPort-AV: E=Sophos;i="5.90,280,1643641200"; 
   d="scan'208";a="62644769"
Received: from mail-tycjpn01lp2169.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.169])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 15:03:14 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwq03gjHlqSf1u6yib0/n+ydpwW/Fvt+8aWtGET6FcI70OVAzHrIISj/fzxmNHCmSxIWYKXC52JQXfSLFmsQefm0hWKlGJxqrj8x4mWbRjlIEi4BNEyJd8NOjo3FhKsz4TX/PP2QJ+Z4OPkNlXUwLhNY/Xz6fxClKhHpyP0pj3qD/UA6iHvULSlG8lU9CJGd8BBSOH9MW2EwSKJyzmuFicttaMZFJN604Smm9zRgu7eivYHXBwHkfmCz8J3K2lnwMQNpjnxUlhMs3QJGnCJv0X1mt0e+X40vJ94gqJuZnTaDvGcmH6ypi5rTfUpT2PLDjyXo1gcO12Q8oo9/QvSl0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpzxhrzR/o+iSKYaZhyBop5XI6vifGzr84/p6J1sXM4=;
 b=OYp3fJodsY1rV9SaF9iWlFvdtqN6fIi5FYHtnRT+SgB5B9mWUN0Z4GMYlsqMeD4CIyaw888R6bHx7Towq3bSnmkXC9YMkudgTE2vBwIyuo3K01aU/CXhPDZ32a+RYNEioVH/M7J4k9AwBiVI6jpiOGWCw3UVgQktpFc19YvpsQypPrA5xf8gif72nCPCqrTEAt+OFn2np1V6Cx4LOrNUS7pA+6CeiB2uLYnnNPqrhac844B3nLL5rSN2OhESMxgYyWSkKXDtU2FqDqlfHU8XT54lRla/ch3Qn51JDvMbBpxe0570CSKw+5uTxBi7ba9RWreCcUHadFsPCUgeYsoW4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpzxhrzR/o+iSKYaZhyBop5XI6vifGzr84/p6J1sXM4=;
 b=K3wUTOZR7ONbi6b8YNGgJihM+C5RQlNG+ISXduQAiJvqnHwmsxv8ntsdQNS4Z9JCVyWLUV5MR1CS/AUEa54qb75/mTFuhbisb9MbfO0eJGhh/31CZpc9YmUzelmri3LWAe4g454e2MEsD7AmWwPsr15XJs0aekvctQWhsC2znwU=
Received: from TY2PR01MB4427.jpnprd01.prod.outlook.com (2603:1096:404:10d::20)
 by OS3PR01MB10249.jpnprd01.prod.outlook.com (2603:1096:604:1e3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 06:03:10 +0000
Received: from TY2PR01MB4427.jpnprd01.prod.outlook.com
 ([fe80::cc0c:b99b:e3db:479f]) by TY2PR01MB4427.jpnprd01.prod.outlook.com
 ([fe80::cc0c:b99b:e3db:479f%7]) with mapi id 15.20.5186.014; Fri, 22 Apr 2022
 06:03:09 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     Christian Brauner <brauner@kernel.org>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>
Subject: Re: [PATCH v5 3/4] fs: strip file's S_ISGID mode on vfs instead of on
 underlying filesystem
Thread-Topic: [PATCH v5 3/4] fs: strip file's S_ISGID mode on vfs instead of
 on underlying filesystem
Thread-Index: AQHYVUycADeAybUFHk63mGLHHkoIM6z6Cs+AgAF5AQA=
Date:   Fri, 22 Apr 2022 06:03:09 +0000
Message-ID: <6262537C.9020908@fujitsu.com>
References: <1650527658-2218-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <1650527658-2218-3-git-send-email-xuyang2018.jy@fujitsu.com>
 <20220421083507.siunu6ohyba6peyq@wittgenstein>
In-Reply-To: <20220421083507.siunu6ohyba6peyq@wittgenstein>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 798924a4-fb4b-4990-ff16-08da2425c70d
x-ms-traffictypediagnostic: OS3PR01MB10249:EE_
x-microsoft-antispam-prvs: <OS3PR01MB10249119BFC0BBAFC7DE17F7EFDF79@OS3PR01MB10249.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MiAx+ve9JE8mw1D3zzHoqICiCO3dPPSyCbcLiKj5t8qWnkgPat4qV5vA17AZTUhA2wexa76pnhaiz1HfH7CwlLFEx7HNSg1nl5nI1YukCkSYtFE5qAeuxT1hf3mDdMYg+oD0umHifhnyuwidpXlm8rM7Xv7llEXLVdGNB9EkJizVJvZulTMBDwqRFr7QpG+c87Au9D7dG/pE4GoqmF5xAZbWYg1xTG7L6Q7n8WbWwkQtcl1ibJO43rCcYvK1dH2Sp3Cqwkf5FLegCbM6B+TfNIubmkn6dzJqdxYwigdayrodWUdWgnqF8Uete/Id13xnXVEXJaqitGSxjuWsPP+loI5E7crAB+D7SV6WkoRJ1grZokcne+AJCAT5zTYMnJAVKy/YappFmrvNDohbjIBItsIUtXvpvAeKT+MUEPlfVz6Fr000NTNqGTCwVs5QLKQSsq4ya9LvPx5yBO3zdWK88JtFr/JZSShMEob5N1kyO808+2DFR7VSl6KJRcTc9v8VgYJeQk+zSAdJIYnKHJKw9cPN7t84hPib1+SHt2qKm03KJp0A4sqZUkzAMbOVntyP0gwuxsslIkniJNxFaPFm/WUwStxu4PJvB4B5BYChSP4JNVYxqSmxGdGBJHnEuKTxKW7a8rbgIW5eJ1Fn3Z2JNl33NU5/DYUOf8vT7Rd58PDxS3tfbRWhYwgwYIzc8GrpcPzhYlo59q4C/I/kqE1CWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB4427.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(6512007)(87266011)(82960400001)(6506007)(2616005)(30864003)(5660300002)(38100700002)(38070700005)(122000001)(508600001)(86362001)(6486002)(71200400001)(6916009)(54906003)(2906002)(316002)(33656002)(8936002)(36756003)(186003)(91956017)(83380400001)(85182001)(66446008)(76116006)(8676002)(66556008)(66476007)(66946007)(4326008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0ZjNW41ak9TbUlLR0RYbWxmOUV0V3dFSWtRZk1QbkNGK1lsKzZRRjBsdUFh?=
 =?utf-8?B?b2c1NHVlRVFvdSt6aUY4MjgyZG5zOVBRV2RScHlYZ1FGOVZKelRXY3pNbGt6?=
 =?utf-8?B?STJiOCs3emxnSVRUeE1qbmxyTUNibW9uUHNkR3JOUkhXTHA3b3Q3dDI5M3VP?=
 =?utf-8?B?YWxudmc1VmluUW9qZ2htN1Z3V0NxSUo2ekRsNDNZSUZRNnJPdG1MUm5hQlJR?=
 =?utf-8?B?TlQvbk05SUZnd0xlY0RiSXhMTjUxVVduSFJpTk1RUm5nM0R2RlBnWmNnT014?=
 =?utf-8?B?a0FHdTBDbGxpLzRBWmhXRFFRcFZ1Y1FEUkpWNHUzL3ZkN0VoYTZacTlGUnBK?=
 =?utf-8?B?eHZ0Y0RRdDFlR3lyenZlSlVLWmtKQzFvZzJhNVlQMmN6RHo0MUNaVjlaQzBQ?=
 =?utf-8?B?QzdnN3BqcHNaQlMyb3ZtSzdUY1hjZDUxMTIzZEhDa0hKcjNheG5aVmFtZlFF?=
 =?utf-8?B?NlZaS1JZUmxqQUkxUVVKRUhZRjU2TFhUa0ljSGQ0L2NLNWFqQnVtUzJENXhl?=
 =?utf-8?B?VjZyM2w0Z3lZRklYRnJWaFNCeG55c010KzFyWnBZbmMwcTl5bW84RDN0ZTRk?=
 =?utf-8?B?SmlTNStCK004ODJxb2doN2lkamttTng4WXdlWEhDRVVJNnEzL09WcmVkeDh0?=
 =?utf-8?B?NUN1N21UMUZsL2JNT21kbjkxZEh3b2Z3RDkwU2kwQmtONzVEVjlDNThUSVBQ?=
 =?utf-8?B?aE0rTjdBOUdONVNTVDVROGVWOUZ4MG5WVVhtTXVDVGxOcjVjQVh3RlhQTUl5?=
 =?utf-8?B?dHpUT2ZxZ3ZHckRpTVJaLzVFRktQcE90TFRyaEJ2bnF0dUY1bzF5NGhTQUpE?=
 =?utf-8?B?REtzc0N2ZGVTYlM1Rk5icnV0MCtlMFk0TGxvRlVQdWdIdEVURlJ2ZzRqRXlT?=
 =?utf-8?B?K3hDRU1DTEFDZy9kZGpSSjFLVFI3NmtuM2xwblNUZjVTemZYQ0tmWUNIUDFO?=
 =?utf-8?B?Mk9Cd1puMTU4REtLVkVqZ2FZOUVkdWQ2dVd0T0RIQk12MWYvMDdLa0VWT244?=
 =?utf-8?B?ZFNRaHh4YmV6SCtzd2hqZ3Fhb2JlcVR4ck9hcERmaThFbTh5L3VMZ1RRZlM2?=
 =?utf-8?B?cDZGMElmcnZUSWJxRUlGbUhzM2pybDVQVXArT3JCb3dsZTgvQVFqalhOaEhU?=
 =?utf-8?B?bXE2cXUwd3ozUmM0UUhKRWlNV3cyT2xpbzhVVGxlSFNxTUNkS0VSSDMza2tR?=
 =?utf-8?B?cGRUeDFGV3VjNk1ISmJmdVRLKzgvd3BxKys5YjZKdzRwendsWUlBdDR2aVhT?=
 =?utf-8?B?d3pRRWVPWk5wYXRDbWhXdXR0RTNmV0dMdlNqZFIzejBMS3ZSNkZtTHdGdnc5?=
 =?utf-8?B?czZKdEg0SHBGNm1VeHppOUw1eGZrU1ZFaFg3aWg0M0dQOU5jWmVRVzBXVk5n?=
 =?utf-8?B?OUMyZis0V2Q2QXVZRU85bDliNnI1bjVkcWI3dTlNN3lMQlRXMUZyL3c3eG41?=
 =?utf-8?B?NnRKdTEvNUYyWjJ2ZWhJRWRmSFU0Q0dEUEh4WUZOdGlsM3gyY1pDdmFPVDVF?=
 =?utf-8?B?N1QwK3U3V2pKKzh6bFp3dGdYa1lnSmtZOG9uM0xXOXhKTkN6WklkZ0MzSlJY?=
 =?utf-8?B?dU5ZSWNIZmFIWnVTVkJMdkQzTWViUEVQcGdOTXhwMzFDcGkxb3dnWjUzQWhy?=
 =?utf-8?B?VTBXU1BIMGZ6NXV6NFcyOHladDJpMk5qSFZiQ3YwV1o0L1NKNi9qcWZOSjhO?=
 =?utf-8?B?ZVZ4dmF2WmZZRVpzM0tXcjFRQTFBN3MrYk1BcTBWTC9GYnAwa2ZBbXZzTElE?=
 =?utf-8?B?dmFLMmh3cE9jNmZzN21LRTVLdzJMUUg1bUdVT05OWHl6dnlDcEJybGh1MjQx?=
 =?utf-8?B?Ri9yVm11VWN3dzUyMytZWGxFK3cyQmw0cG5CSVBTemxaRDFnNy9HNHM4ejZN?=
 =?utf-8?B?WjhmMC9EeE1BRzI3dmYxTFU5dkt6M1lsMTZOV3ZSb2NLNFJsdXcwMENhU295?=
 =?utf-8?B?NkVRc0hhWXBMemFYUlVqM2M3ZnMxTVRvODAwVzYzR3J2MlpXUis2elZoSjJC?=
 =?utf-8?B?cVBlRE51RjkybUlrQkovS3NDc08yTEZRK1lEK1F4a1p3TjZ5ZEh6OU1yZXY4?=
 =?utf-8?B?a1ZMRGZwVUk1T2p3U1pTSVJyQVhWVkVGbk44ZTdlSDNKTHlocVRkaFB3ZE9L?=
 =?utf-8?B?eDk5cE1tSDQwVnRWTitveDJPdGMxaDVFTVNDeFgzZ2N5ZnVJdEtMbmpwOTVz?=
 =?utf-8?B?NU5qd2dpUURYdnExRjJlNEg4cjdCZ0UwN1p6TTNiYzhwN0IrV0p1WWJBai9U?=
 =?utf-8?B?dHdXeFFlWmVtYVJjM21ocUtRbW5kYTFiMVdoZzFJakpXcVgxQllLL0MySHNF?=
 =?utf-8?B?d29NRHorOURuV2ZZRFBHaGhWNC9PbFNPdlliaGxlQWZpM29RbUM1azhUM0dT?=
 =?utf-8?Q?Z6NJRphPRaxzpqVKdWvxCdhDsz2C3hTTKyRoo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80970D7ED93AD14DA0E1ADCB55939F21@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB4427.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798924a4-fb4b-4990-ff16-08da2425c70d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 06:03:09.7850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pT+j4YPh9fVHKwSaBkq57vUOp91qLrNY6Rb2DjU6bPZW0toTPhKOGE/C0gpQO4V8vXJ6ivZFLAyYSjgwpTr9d1PlaAr6UfoVmHGqPEKuhTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB10249
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

b24gMjAyMi80LzIxIDE2OjM1LCBDaHJpc3RpYW4gQnJhdW5lciB3cm90ZToNCj4gT24gVGh1LCBB
cHIgMjEsIDIwMjIgYXQgMDM6NTQ6MTdQTSArMDgwMCwgWWFuZyBYdSB3cm90ZToNCj4+IEN1cnJl
bnRseSwgdmZzIG9ubHkgcGFzc2VzIG1vZGUgYXJndW1lbnQgdG8gZmlsZXN5c3RlbSwgdGhlbiB1
c2UgaW5vZGVfaW5pdF9vd25lcigpDQo+PiB0byBzdHJpcCBTX0lTR0lELiBTb21lIGZpbGVzeXN0
ZW0oaWUgZXh0NC9idHJmcykgd2lsbCBjYWxsIGlub2RlX2luaXRfb3duZXINCj4+IGZpcnN0bHks
IHRoZW4gcG9zeGkgYWNsIHNldHVwLCBidXQgeGZzIHVzZXMgdGhlIGNvbnRyYXJ5IG9yZGVyLiBJ
dCB3aWxsDQo+PiBhZmZlY3QgU19JU0dJRCBjbGVhciBlc3BlY2lhbGx5IHdlIGZpbHRlciBTX0lY
R1JQIGJ5IHVtYXNrIG9yIGFjbC4NCj4+DQo+PiBSZWdhcmRsZXNzIG9mIHdoaWNoIGZpbGVzeXN0
ZW0gaXMgaW4gdXNlLCBmYWlsdXJlIHRvIHN0cmlwIHRoZSBTR0lEIGNvcnJlY3RseQ0KPj4gaXMg
Y29uc2lkZXJlZCBhIHNlY3VyaXR5IGZhaWx1cmUgdGhhdCBuZWVkcyB0byBiZSBmaXhlZC4gVGhl
IGN1cnJlbnQgVkZTDQo+PiBpbmZyYXN0cnVjdHVyZSByZXF1aXJlcyB0aGUgZmlsZXN5c3RlbSB0
byBkbyBldmVyeXRoaW5nIHJpZ2h0IGFuZCBub3Qgc3RlcCBvbg0KPj4gYW55IGxhbmRtaW5lcyB0
byBzdHJpcCB0aGUgU0dJRCBiaXQsIHdoZW4gaW4gZmFjdCBpdCBjYW4gZWFzaWx5IGJlIGRvbmUg
YXQgdGhlDQo+PiBWRlMgYW5kIHRoZSBmaWxlc3lzdGVtcyB0aGVuIGRvbid0IGV2ZW4gbmVlZCB0
byBiZSBhd2FyZSB0aGF0IHRoZSBTR0lEIG5lZWRzDQo+PiB0byBiZSAob3IgaGFzIGJlZW4gc3Ry
aXBwZWQpIGJ5IHRoZSBvcGVyYXRpb24gdGhlIHVzZXIgYXNrZWQgdG8gYmUgZG9uZS4NCj4+DQo+
PiBWZnMgaGFzIGFsbCB0aGUgaW5mbyBpdCBuZWVkcyAtIGl0IGRvZXNuJ3QgbmVlZCB0aGUgZmls
ZXN5c3RlbXMgdG8gZG8gZXZlcnl0aGluZw0KPj4gY29ycmVjdGx5IHdpdGggdGhlIG1vZGUgYW5k
IGVuc3VyaW5nIHRoYXQgdGhleSBvcmRlciB0aGluZ3MgbGlrZSBwb3NpeCBhY2wgc2V0dXANCj4+
IGZ1bmN0aW9ucyBjb3JyZWN0bHkgd2l0aCBpbm9kZV9pbml0X293bmVyKCkgdG8gc3RyaXAgdGhl
IFNHSUQgYml0Lg0KPj4NCj4+IEp1c3Qgc3RyaXAgdGhlIFNHSUQgYml0IGF0IHRoZSBWRlMsIGFu
ZCB0aGVuIHRoZSBmaWxlc3lzdGVtIGNhbid0IGdldCBpdCB3cm9uZy4NCj4+DQo+PiBBbHNvLCB0
aGUgaW5vZGVfc2dpZF9zdHJpcCgpIGFwaSBzaG91bGQgYmUgdXNlZCBiZWZvcmUgSVNfUE9TSVhB
Q0woKSBiZWNhdXNlDQo+PiB0aGlzIGFwaSBtYXkgY2hhbmdlIG1vZGUuDQo+Pg0KPj4gT25seSB0
aGUgZm9sbG93aW5nIHBsYWNlcyB1c2UgaW5vZGVfaW5pdF9vd25lcg0KPj4gIg0KPj4gYXJjaC9w
b3dlcnBjL3BsYXRmb3Jtcy9jZWxsL3NwdWZzL2lub2RlLmM6ICAgICAgaW5vZGVfaW5pdF9vd25l
cigmaW5pdF91c2VyX25zLCBpbm9kZSwgZGlyLCBtb2RlIHwgU19JRkRJUik7DQo+PiBhcmNoL3Bv
d2VycGMvcGxhdGZvcm1zL2NlbGwvc3B1ZnMvaW5vZGUuYzogICAgICBpbm9kZV9pbml0X293bmVy
KCZpbml0X3VzZXJfbnMsIGlub2RlLCBkaXIsIG1vZGUgfCBTX0lGRElSKTsNCj4+IGZzLzlwL3Zm
c19pbm9kZS5jOiAgICAgIGlub2RlX2luaXRfb3duZXIoJmluaXRfdXNlcl9ucywgaW5vZGUsIE5V
TEwsIG1vZGUpOw0KPj4gZnMvYmZzL2Rpci5jOiAgIGlub2RlX2luaXRfb3duZXIoJmluaXRfdXNl
cl9ucywgaW5vZGUsIGRpciwgbW9kZSk7DQo+PiBmcy9idHJmcy9pbm9kZS5jOiAgICAgICBpbm9k
ZV9pbml0X293bmVyKG1udF91c2VybnMsIGlub2RlLCBkaXIsIG1vZGUpOw0KPj4gZnMvYnRyZnMv
dGVzdHMvYnRyZnMtdGVzdHMuYzogICBpbm9kZV9pbml0X293bmVyKCZpbml0X3VzZXJfbnMsIGlu
b2RlLCBOVUxMLCBTX0lGUkVHKTsNCj4+IGZzL2V4dDIvaWFsbG9jLmM6ICAgICAgICAgICAgICAg
aW5vZGVfaW5pdF9vd25lcigmaW5pdF91c2VyX25zLCBpbm9kZSwgZGlyLCBtb2RlKTsNCj4+IGZz
L2V4dDQvaWFsbG9jLmM6ICAgICAgICAgICAgICAgaW5vZGVfaW5pdF9vd25lcihtbnRfdXNlcm5z
LCBpbm9kZSwgZGlyLCBtb2RlKTsNCj4+IGZzL2YyZnMvbmFtZWkuYzogICAgICAgIGlub2RlX2lu
aXRfb3duZXIobW50X3VzZXJucywgaW5vZGUsIGRpciwgbW9kZSk7DQo+PiBmcy9oZnNwbHVzL2lu
b2RlLmM6ICAgICBpbm9kZV9pbml0X293bmVyKCZpbml0X3VzZXJfbnMsIGlub2RlLCBkaXIsIG1v
ZGUpOw0KPj4gZnMvaHVnZXRsYmZzL2lub2RlLmM6ICAgICAgICAgICBpbm9kZV9pbml0X293bmVy
KCZpbml0X3VzZXJfbnMsIGlub2RlLCBkaXIsIG1vZGUpOw0KPj4gZnMvamZzL2pmc19pbm9kZS5j
OiAgICAgaW5vZGVfaW5pdF9vd25lcigmaW5pdF91c2VyX25zLCBpbm9kZSwgcGFyZW50LCBtb2Rl
KTsNCj4+IGZzL21pbml4L2JpdG1hcC5jOiAgICAgIGlub2RlX2luaXRfb3duZXIoJmluaXRfdXNl
cl9ucywgaW5vZGUsIGRpciwgbW9kZSk7DQo+PiBmcy9uaWxmczIvaW5vZGUuYzogICAgICBpbm9k
ZV9pbml0X293bmVyKCZpbml0X3VzZXJfbnMsIGlub2RlLCBkaXIsIG1vZGUpOw0KPj4gZnMvbnRm
czMvaW5vZGUuYzogICAgICAgaW5vZGVfaW5pdF9vd25lcihtbnRfdXNlcm5zLCBpbm9kZSwgZGly
LCBtb2RlKTsNCj4+IGZzL29jZnMyL2RsbWZzL2RsbWZzLmM6ICAgICAgICAgaW5vZGVfaW5pdF9v
d25lcigmaW5pdF91c2VyX25zLCBpbm9kZSwgTlVMTCwgbW9kZSk7DQo+PiBmcy9vY2ZzMi9kbG1m
cy9kbG1mcy5jOiBpbm9kZV9pbml0X293bmVyKCZpbml0X3VzZXJfbnMsIGlub2RlLCBwYXJlbnQs
IG1vZGUpOw0KPj4gZnMvb2NmczIvbmFtZWkuYzogICAgICAgaW5vZGVfaW5pdF9vd25lcigmaW5p
dF91c2VyX25zLCBpbm9kZSwgZGlyLCBtb2RlKTsNCj4+IGZzL29tZnMvaW5vZGUuYzogICAgICAg
IGlub2RlX2luaXRfb3duZXIoJmluaXRfdXNlcl9ucywgaW5vZGUsIE5VTEwsIG1vZGUpOw0KPj4g
ZnMvb3ZlcmxheWZzL2Rpci5jOiAgICAgaW5vZGVfaW5pdF9vd25lcigmaW5pdF91c2VyX25zLCBp
bm9kZSwgZGVudHJ5LT5kX3BhcmVudC0+ZF9pbm9kZSwgbW9kZSk7DQo+PiBmcy9yYW1mcy9pbm9k
ZS5jOiAgICAgICAgICAgICAgIGlub2RlX2luaXRfb3duZXIoJmluaXRfdXNlcl9ucywgaW5vZGUs
IGRpciwgbW9kZSk7DQo+PiBmcy9yZWlzZXJmcy9uYW1laS5jOiAgICBpbm9kZV9pbml0X293bmVy
KCZpbml0X3VzZXJfbnMsIGlub2RlLCBkaXIsIG1vZGUpOw0KPj4gZnMvc3lzdi9pYWxsb2MuYzog
ICAgICAgaW5vZGVfaW5pdF9vd25lcigmaW5pdF91c2VyX25zLCBpbm9kZSwgZGlyLCBtb2RlKTsN
Cj4+IGZzL3ViaWZzL2Rpci5jOiBpbm9kZV9pbml0X293bmVyKCZpbml0X3VzZXJfbnMsIGlub2Rl
LCBkaXIsIG1vZGUpOw0KPj4gZnMvdWRmL2lhbGxvYy5jOiAgICAgICAgaW5vZGVfaW5pdF9vd25l
cigmaW5pdF91c2VyX25zLCBpbm9kZSwgZGlyLCBtb2RlKTsNCj4+IGZzL3Vmcy9pYWxsb2MuYzog
ICAgICAgIGlub2RlX2luaXRfb3duZXIoJmluaXRfdXNlcl9ucywgaW5vZGUsIGRpciwgbW9kZSk7
DQo+PiBmcy94ZnMveGZzX2lub2RlLmM6ICAgICAgICAgICAgIGlub2RlX2luaXRfb3duZXIobW50
X3VzZXJucywgaW5vZGUsIGRpciwgbW9kZSk7DQo+PiBmcy96b25lZnMvc3VwZXIuYzogICAgICBp
bm9kZV9pbml0X293bmVyKCZpbml0X3VzZXJfbnMsIGlub2RlLCBwYXJlbnQsIFNfSUZESVIgfCAw
NTU1KTsNCj4+IGtlcm5lbC9icGYvaW5vZGUuYzogICAgIGlub2RlX2luaXRfb3duZXIoJmluaXRf
dXNlcl9ucywgaW5vZGUsIGRpciwgbW9kZSk7DQo+PiBtbS9zaG1lbS5jOiAgICAgICAgICAgICBp
bm9kZV9pbml0X293bmVyKCZpbml0X3VzZXJfbnMsIGlub2RlLCBkaXIsIG1vZGUpOw0KPj4gIg0K
Pj4NCj4+IFRoZXkgYXJlIHVzZWQgaW4gZmlsZXN5c3RlbSB0byBpbml0IG5ldyBpbm9kZSBmdW5j
dGlvbiBhbmQgdGhlc2UgaW5pdCBpbm9kZQ0KPj4gZnVuY3Rpb25zIGFyZSB1c2VkIGJ5IGZvbGxv
d2luZyBvcGVyYXRpb25zOg0KPj4gbWtkaXINCj4+IHN5bWxpbmsNCj4+IG1rbm9kDQo+PiBjcmVh
dGUNCj4+IHRtcGZpbGUNCj4+IHJlbmFtZQ0KPj4NCj4+IFdlIGRvbid0IGNhcmUgYWJvdXQgbWtk
aXIgYmVjYXVzZSB3ZSBkb24ndCBzdHJpcCBTR0lEIGJpdCBmb3IgZGlyZWN0b3J5IGV4Y2VwdA0K
Pj4gZnMueGZzLmlyaXhfc2dpZF9pbmhlcml0LiBCdXQgd2UgZXZlbiBjYWxsIHByZXBhcmVfbW9k
ZSgpIGluIGRvX21rZGlyYXQoKSBzaW5jZQ0KPj4gaW5vZGVfc2dpZF9zdHJpcCgpIHdpbGwgc2tp
cCBkaXJlY3RvcmllcyBhbnl3YXkuIFRoaXMgd2lsbCBlbmZvcmNlIHRoZSBzYW1lDQo+PiBvcmRl
cmluZyBmb3IgYWxsIHJlbGV2YW50IG9wZXJhdGlvbnMgYW5kIGl0IHdpbGwgbWFrZSB0aGUgY29k
ZSBtb3JlIHVuaWZvcm0gYW5kDQo+PiBlYXNpZXIgdG8gdW5kZXJzdGFuZCBieSB1c2luZyBuZXcg
aGVscGVyIHByZXBhcmVfbW9kZSgpLg0KPj4NCj4+IHN5bWxpbmsgYW5kIHJlbmFtZSBvbmx5IHVz
ZSB2YWxpZCBtb2RlIHRoYXQgZG9lc24ndCBoYXZlIFNHSUQgYml0Lg0KPj4NCj4+IFdlIGhhdmUg
YWRkZWQgaW5vZGVfc2dpZF9zdHJpcCBhcGkgZm9yIHRoZSByZW1haW5pbmcgb3BlcmF0aW9ucy4N
Cj4+DQo+PiBJbiBhZGRpdGlvbiB0byB0aGUgYWJvdmUgc2l4IG9wZXJhdGlvbnMsIGZvdXIgZmls
ZXN5c3RlbXMgaGFzIGEgbGl0dGxlIGRpZmZlcmVuY2UNCj4+IDEpIGJ0cmZzIGhhcyBidHJmc19j
cmVhdGVfc3Vidm9sX3Jvb3QgdG8gY3JlYXRlIG5ldyBpbm9kZSBidXQgdXNlZCBub24gU0dJRCBi
aXQNCj4+ICAgICBtb2RlIGFuZCBjYW4gaWdub3JlDQo+PiAyKSBvY2ZzMiByZWZsaW5rIGZ1bmN0
aW9uIHNob3VsZCBhZGQgaW5vZGVfc2dpZF9zdHJpcCBhcGkgbWFudWFsbHkgYmVjYXVzZSB3ZQ0K
Pj4gICAgIGRvbid0IGFkZCBpdCBpbiB2ZnMNCj4+IDMpIHNwdWZzIHdoaWNoIGRvZXNuJ3QgcmVh
bGx5IGdvIGhyb3VnaCB0aGUgcmVndWxhciBWRlMgY2FsbHBhdGggYmVjYXVzZSBpdCBoYXMNCj4+
ICAgICBzZXBhcmF0ZSBzeXN0ZW0gY2FsbCBzcHVfY3JlYXRlLCBidXQgaXQgdCBvbmx5IGFsbG93
cyB0aGUgY3JlYXRpb24gb2YNCj4+ICAgICBkaXJlY3RvcmllcyBhbmQgb25seSBhbGxvd3MgYml0
cyBpbiAwNzc3IGFuZCBjYW4gaWdub3JlDQo+PiA0KSBicGYgdXNlIHZmc19ta29iaiBpbiBicGZf
b2JqX2RvX3BpbiB3aXRoDQo+PiAgICAgIlNfSUZSRUcgfCAoKFNfSVJVU1IgfCBTX0lXVVNSKSYg
IH5jdXJyZW50X3VtYXNrKCkpIG1vZGUgYW5kDQo+PiAgICAgdXNlIGJwZl9ta29ial9vcHMgaW4g
YnBmX2l0ZXJfbGlua19waW5fa2VybmVsIHdpdGggU19JRlJFRyB8IFNfSVJVU1IgbW9kZSwNCj4+
ICAgICBzbyBicGYgaXMgYWxzbyBub3QgYWZmZWN0ZWQNCj4+DQo+PiBUaGlzIHBhdGNoIGFsc28g
Y2hhbmdlZCBncnBpZCBiZWhhdmlvdXIgZm9yIGV4dDQveGZzIGJlY2F1c2UgdGhlIG1vZGUgcGFz
c2VkIHRvDQo+PiB0aGVtIG1heSBiZWVuIGNoYW5nZWQgYnkgaW5vZGVfc2dpZF9zdHJpcC4NCj4+
DQo+PiBBbHNvIGFzIENocmlzdGlhbiBCcmF1bmVyIHNhaWQiDQo+PiBUaGUgcGF0Y2ggaXRzZWxm
IGlzIHVzZWZ1bCBhcyBpdCB3b3VsZCBtb3ZlIGEgc2VjdXJpdHkgc2Vuc2l0aXZlIG9wZXJhdGlv
biB0aGF0IGlzDQo+PiBjdXJyZW50bHkgYnVycmllZCBpbiBpbmRpdmlkdWFsIGZpbGVzeXN0ZW1z
IGludG8gdGhlIHZmcyBsYXllci4gQnV0IGl0IGhhcyBhIGRlY2VudA0KPj4gcmVncmVzc2lvbiAg
cG90ZW50aWFsIHNpbmNlIGl0IG1pZ2h0IHN0cmlwIGZpbGVzeXN0ZW1zIHRoYXQgaGF2ZSBzbyBm
YXIgcmVsaWVkIG9uDQo+PiBnZXR0aW5nIHRoZSBTX0lTR0lEIGJpdCB3aXRoIGEgbW9kZSBhcmd1
bWVudC4gU28gdGhpcyBuZWVkcyBhIGxvdCBvZiB0ZXN0aW5nIGFuZA0KPj4gbG9uZyBleHBvc3Vy
ZSBpbiAtbmV4dCBmb3IgYXQgbGVhc3Qgb25lIGZ1bGwga2VybmVsIGN5Y2xlLiINCj4+DQo+PiBT
dWdnZXN0ZWQtYnk6IERhdmUgQ2hpbm5lcjxkYXZpZEBmcm9tb3JiaXQuY29tPg0KPj4gU2lnbmVk
LW9mZi1ieTogWWFuZyBYdTx4dXlhbmcyMDE4Lmp5QGZ1aml0c3UuY29tPg0KPj4gLS0tDQo+PiB2
NC0+djU6DQo+PiBwdXQgaW5vZGVfc2dpZF9zdHJpcCBiZWZvcmUgdGhlIGlub2RlX2luaXRfb3du
ZXIgaW4gb2NmczIgZmlsZXN5c3RlbQ0KPj4gYmVjYXVzZSB0aGUgaW5vZGUtPmlfbW9kZSdzIGFz
c2lnbm1lbnQgaXMgaW4gaW5vZGVfaW5pdF9vd25lcg0KPj4gICBmcy9pbm9kZS5jICAgICAgICAg
fCAgMiAtLQ0KPj4gICBmcy9uYW1laS5jICAgICAgICAgfCAyMiArKysrKysrKystLS0tLS0tLS0t
LS0tDQo+PiAgIGZzL29jZnMyL25hbWVpLmMgICB8ICAxICsNCj4+ICAgaW5jbHVkZS9saW51eC9m
cy5oIHwgMTEgKysrKysrKysrKysNCj4+ICAgNCBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25z
KCspLCAxNSBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZnMvaW5vZGUuYyBiL2Zz
L2lub2RlLmMNCj4+IGluZGV4IDU3MTMwZTRlZjhiNC4uOTU2NjdlNjM0YmQ0IDEwMDY0NA0KPj4g
LS0tIGEvZnMvaW5vZGUuYw0KPj4gKysrIGIvZnMvaW5vZGUuYw0KPj4gQEAgLTIyNDYsOCArMjI0
Niw2IEBAIHZvaWQgaW5vZGVfaW5pdF9vd25lcihzdHJ1Y3QgdXNlcl9uYW1lc3BhY2UgKm1udF91
c2VybnMsIHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+PiAgIAkJLyogRGlyZWN0b3JpZXMgYXJlIHNw
ZWNpYWwsIGFuZCBhbHdheXMgaW5oZXJpdCBTX0lTR0lEICovDQo+PiAgIAkJaWYgKFNfSVNESVIo
bW9kZSkpDQo+PiAgIAkJCW1vZGUgfD0gU19JU0dJRDsNCj4+IC0JCWVsc2UNCj4+IC0JCQltb2Rl
ID0gaW5vZGVfc2dpZF9zdHJpcChtbnRfdXNlcm5zLCBkaXIsIG1vZGUpOw0KPj4gICAJfSBlbHNl
DQo+PiAgIAkJaW5vZGVfZnNnaWRfc2V0KGlub2RlLCBtbnRfdXNlcm5zKTsNCj4+ICAgCWlub2Rl
LT5pX21vZGUgPSBtb2RlOw0KPj4gZGlmZiAtLWdpdCBhL2ZzL25hbWVpLmMgYi9mcy9uYW1laS5j
DQo+PiBpbmRleCA3MzY0NmUyOGZhZTAuLjViOGU2Mjg4ZDUwMyAxMDA2NDQNCj4+IC0tLSBhL2Zz
L25hbWVpLmMNCj4+ICsrKyBiL2ZzL25hbWVpLmMNCj4+IEBAIC0zMjg3LDggKzMyODcsNyBAQCBz
dGF0aWMgc3RydWN0IGRlbnRyeSAqbG9va3VwX29wZW4oc3RydWN0IG5hbWVpZGF0YSAqbmQsIHN0
cnVjdCBmaWxlICpmaWxlLA0KPj4gICAJaWYgKG9wZW5fZmxhZyYgIE9fQ1JFQVQpIHsNCj4+ICAg
CQlpZiAob3Blbl9mbGFnJiAgT19FWENMKQ0KPj4gICAJCQlvcGVuX2ZsYWcmPSB+T19UUlVOQzsN
Cj4+IC0JCWlmICghSVNfUE9TSVhBQ0woZGlyLT5kX2lub2RlKSkNCj4+IC0JCQltb2RlJj0gfmN1
cnJlbnRfdW1hc2soKTsNCj4+ICsJCW1vZGUgPSBwcmVwYXJlX21vZGUobW50X3VzZXJucywgZGly
LT5kX2lub2RlLCBtb2RlKTsNCj4+ICAgCQlpZiAobGlrZWx5KGdvdF93cml0ZSkpDQo+PiAgIAkJ
CWNyZWF0ZV9lcnJvciA9IG1heV9vX2NyZWF0ZShtbnRfdXNlcm5zLCZuZC0+cGF0aCwNCj4+ICAg
CQkJCQkJICAgIGRlbnRyeSwgbW9kZSk7DQo+PiBAQCAtMzUyMSw4ICszNTIwLDcgQEAgc3RydWN0
IGRlbnRyeSAqdmZzX3RtcGZpbGUoc3RydWN0IHVzZXJfbmFtZXNwYWNlICptbnRfdXNlcm5zLA0K
Pj4gICAJY2hpbGQgPSBkX2FsbG9jKGRlbnRyeSwmc2xhc2hfbmFtZSk7DQo+PiAgIAlpZiAodW5s
aWtlbHkoIWNoaWxkKSkNCj4+ICAgCQlnb3RvIG91dF9lcnI7DQo+PiAtCWlmICghSVNfUE9TSVhB
Q0woZGlyKSkNCj4+IC0JCW1vZGUmPSB+Y3VycmVudF91bWFzaygpOw0KPj4gKwltb2RlID0gcHJl
cGFyZV9tb2RlKG1udF91c2VybnMsIGRpciwgbW9kZSk7DQo+PiAgIAllcnJvciA9IGRpci0+aV9v
cC0+dG1wZmlsZShtbnRfdXNlcm5zLCBkaXIsIGNoaWxkLCBtb2RlKTsNCj4+ICAgCWlmIChlcnJv
cikNCj4+ICAgCQlnb3RvIG91dF9lcnI7DQo+PiBAQCAtMzg1MCwxMyArMzg0OCwxMiBAQCBzdGF0
aWMgaW50IGRvX21rbm9kYXQoaW50IGRmZCwgc3RydWN0IGZpbGVuYW1lICpuYW1lLCB1bW9kZV90
IG1vZGUsDQo+PiAgIAlpZiAoSVNfRVJSKGRlbnRyeSkpDQo+PiAgIAkJZ290byBvdXQxOw0KPj4N
Cj4+IC0JaWYgKCFJU19QT1NJWEFDTChwYXRoLmRlbnRyeS0+ZF9pbm9kZSkpDQo+PiAtCQltb2Rl
Jj0gfmN1cnJlbnRfdW1hc2soKTsNCj4+ICsJbW50X3VzZXJucyA9IG1udF91c2VyX25zKHBhdGgu
bW50KTsNCj4+ICsJbW9kZSA9IHByZXBhcmVfbW9kZShtbnRfdXNlcm5zLCBwYXRoLmRlbnRyeS0+
ZF9pbm9kZSwgbW9kZSk7DQo+PiAgIAllcnJvciA9IHNlY3VyaXR5X3BhdGhfbWtub2QoJnBhdGgs
IGRlbnRyeSwgbW9kZSwgZGV2KTsNCj4+ICAgCWlmIChlcnJvcikNCj4+ICAgCQlnb3RvIG91dDI7
DQo+Pg0KPj4gLQltbnRfdXNlcm5zID0gbW50X3VzZXJfbnMocGF0aC5tbnQpOw0KPj4gICAJc3dp
dGNoIChtb2RlJiAgU19JRk1UKSB7DQo+PiAgIAkJY2FzZSAwOiBjYXNlIFNfSUZSRUc6DQo+PiAg
IAkJCWVycm9yID0gdmZzX2NyZWF0ZShtbnRfdXNlcm5zLCBwYXRoLmRlbnRyeS0+ZF9pbm9kZSwN
Cj4+IEBAIC0zOTQzLDYgKzM5NDAsNyBAQCBpbnQgZG9fbWtkaXJhdChpbnQgZGZkLCBzdHJ1Y3Qg
ZmlsZW5hbWUgKm5hbWUsIHVtb2RlX3QgbW9kZSkNCj4+ICAgCXN0cnVjdCBwYXRoIHBhdGg7DQo+
PiAgIAlpbnQgZXJyb3I7DQo+PiAgIAl1bnNpZ25lZCBpbnQgbG9va3VwX2ZsYWdzID0gTE9PS1VQ
X0RJUkVDVE9SWTsNCj4+ICsJc3RydWN0IHVzZXJfbmFtZXNwYWNlICptbnRfdXNlcm5zOw0KPj4N
Cj4+ICAgcmV0cnk6DQo+PiAgIAlkZW50cnkgPSBmaWxlbmFtZV9jcmVhdGUoZGZkLCBuYW1lLCZw
YXRoLCBsb29rdXBfZmxhZ3MpOw0KPj4gQEAgLTM5NTAsMTUgKzM5NDgsMTMgQEAgaW50IGRvX21r
ZGlyYXQoaW50IGRmZCwgc3RydWN0IGZpbGVuYW1lICpuYW1lLCB1bW9kZV90IG1vZGUpDQo+PiAg
IAlpZiAoSVNfRVJSKGRlbnRyeSkpDQo+PiAgIAkJZ290byBvdXRfcHV0bmFtZTsNCj4+DQo+PiAt
CWlmICghSVNfUE9TSVhBQ0wocGF0aC5kZW50cnktPmRfaW5vZGUpKQ0KPj4gLQkJbW9kZSY9IH5j
dXJyZW50X3VtYXNrKCk7DQo+PiArCW1udF91c2VybnMgPSBtbnRfdXNlcl9ucyhwYXRoLm1udCk7
DQo+PiArCW1vZGUgPSBwcmVwYXJlX21vZGUobW50X3VzZXJucywgcGF0aC5kZW50cnktPmRfaW5v
ZGUsIG1vZGUpOw0KPj4gICAJZXJyb3IgPSBzZWN1cml0eV9wYXRoX21rZGlyKCZwYXRoLCBkZW50
cnksIG1vZGUpOw0KPj4gLQlpZiAoIWVycm9yKSB7DQo+PiAtCQlzdHJ1Y3QgdXNlcl9uYW1lc3Bh
Y2UgKm1udF91c2VybnM7DQo+PiAtCQltbnRfdXNlcm5zID0gbW50X3VzZXJfbnMocGF0aC5tbnQp
Ow0KPj4gKwlpZiAoIWVycm9yKQ0KPj4gICAJCWVycm9yID0gdmZzX21rZGlyKG1udF91c2VybnMs
IHBhdGguZGVudHJ5LT5kX2lub2RlLCBkZW50cnksDQo+PiAgIAkJCQkgIG1vZGUpOw0KPj4gLQl9
DQo+PiArDQo+PiAgIAlkb25lX3BhdGhfY3JlYXRlKCZwYXRoLCBkZW50cnkpOw0KPj4gICAJaWYg
KHJldHJ5X2VzdGFsZShlcnJvciwgbG9va3VwX2ZsYWdzKSkgew0KPj4gICAJCWxvb2t1cF9mbGFn
cyB8PSBMT09LVVBfUkVWQUw7DQo+PiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvbmFtZWkuYyBiL2Zz
L29jZnMyL25hbWVpLmMNCj4+IGluZGV4IGM3NWZkNTRiOTE4NS4uMjFmM2RhMmU2NmM5IDEwMDY0
NA0KPj4gLS0tIGEvZnMvb2NmczIvbmFtZWkuYw0KPj4gKysrIGIvZnMvb2NmczIvbmFtZWkuYw0K
Pj4gQEAgLTE5Nyw2ICsxOTcsNyBAQCBzdGF0aWMgc3RydWN0IGlub2RlICpvY2ZzMl9nZXRfaW5p
dF9pbm9kZShzdHJ1Y3QgaW5vZGUgKmRpciwgdW1vZGVfdCBtb2RlKQ0KPj4gICAJICogY2FsbGVy
cy4gKi8NCj4+ICAgCWlmIChTX0lTRElSKG1vZGUpKQ0KPj4gICAJCXNldF9ubGluayhpbm9kZSwg
Mik7DQo+PiArCW1vZGUgPSBpbm9kZV9zZ2lkX3N0cmlwKCZpbml0X3VzZXJfbnMsIGRpciwgbW9k
ZSk7DQo+PiAgIAlpbm9kZV9pbml0X293bmVyKCZpbml0X3VzZXJfbnMsIGlub2RlLCBkaXIsIG1v
ZGUpOw0KPg0KPiBGb3IgdGhlIHJlY29yZCwgSSdtIG5vdCB0b28gZm9uZCBvZiB0aGlzIHNlcGFy
YXRlIGludm9jYXRpb24gb2YNCj4gaW5vZGVfc2dpZF9zdHJpcCgpIGJ1dCBzaW5jZSBpdCdzIG9u
bHkgb25lIGxvY2F0aW9uIHRoaXMgbWlnaHQgYmUgZmluZS4NCj4gSWYgdGhlcmUncyBtb3JlIHRo
YW4gb25lIGxvY2F0aW9uIGEgc2VwYXJhdGUgaGVscGVyIHNob3VsZCBleGlzdCBmb3INCj4gdGhp
cyB0aGF0IGFic3RyYWN0cyB0aGlzIGF3YXkgZm9yIHRoZSBmaWxlc3lzdGVtLg0KQWdyZWUuIFRo
aXMgY2FzZSBvbmx5IGJlIGZvdW5kIHdoZW4gdXNpbmcgT0NGUzJfSU9DX1JFRkxJTksgaW9jdGwu
IEFuZCANCm90aGVyIHN1cHBvcnQgcmVmbGluayBmaWxlc3lzdGVtKHhmcywgYnRyZnMpIHRoZXkg
dXNlICBGSUNMT05FIG9yIA0KRklDTE9ORVJBTkdFIGlvY3RsLg0KDQpTaW5jZSBvY2ZzMiBoYXMg
c3VwcG9ydGVkIHJlZmxpbmsgYnkgdXNpbmcgaXQgcmVtYXBfZmlsZV9yYW5nZSwgc2hvdWxkIA0K
d2Ugc3RpbGwgbmVlZCB0aGlzIGlvY3RsPw0KDQpjb21taXQgYmQ1MDg3M2RjNzI1YTlmYTcyNTky
ZWNjOTg2YzU4ODA1ZTgyMzA1MQ0KQXV0aG9yOiBUYW8gTWEgPHRhby5tYUBvcmFjbGUuY29tPg0K
RGF0ZTogICBNb24gU2VwIDIxIDExOjI1OjE0IDIwMDkgKzA4MDANCg0KICAgICBvY2ZzMjogQWRk
IGlvY3RsIGZvciByZWZsaW5rLg0KDQogICAgIFRoZSBpb2N0bCB3aWxsIHRha2UgMyBwYXJhbWV0
ZXJzOiBvbGRfcGF0aCwgbmV3X3BhdGggYW5kDQogICAgIHByZXNlcnZlIGFuZCBjYWxsIHZmc19y
ZWZsaW5rLiBJdCBpcyB1c2VmdWwgd2hlbiB3ZSBiYWNrcG9ydA0KICAgICByZWZsaW5rIGZlYXR1
cmVzIHRvIG9sZCBrZXJuZWxzLg0KDQogICAgIFNpZ25lZC1vZmYtYnk6IFRhbyBNYSA8dGFvLm1h
QG9yYWNsZS5jb20+DQoNCk9mIGNvdXJzZSwgdGhpcyBpcyBhIHByb2JsZW0gZG9lc24ndCBiZWxv
bmcgdG8gdGhpcyBzZXJpZXMuDQoNCj4NCj4gVHdvIHF1ZXN0aW9uczoNCj4gLSBTb3VsZCB0aGlz
IGNhbGwgcHJlcGFyZV9tb2RlKCksIGkuZS4gc2hvdWxkIHdlIGhvbm9yIHVtYXNrcyBoZXJlIHRv
bz8NCklNTywgaXQgZGVzbid0IG5lZWQgdG8gaG9ub3IgdW1hc2suIEJlY2F1c2UgcmVmbGluayBv
bmx5IHdpbGwgdXBkYXRlIA0KaW5vZGVfaW1vZGUgYnkgc2V0YXR0ciB0byBzdHJpcCBTX0lTR0lE
IGFuZCBTX0lTVUlEIGluc3RlYWQgb2YgY3JlYXRpbmcgDQphIGZpbGUuDQo+IC0gSG93IGlzIHRo
ZSBzZ2lkIGJpdCBoYW5kbGVkIHdoZW4gY3JlYXRpbmcgcmVmbGlua3Mgb24gb3RoZXIgcmVmbGlu
aw0KPiAgICBzdXBwb3J0aW5nIGZpbGVzeXN0ZW1zIHN1Y2ggYXMgeGZzIGFuZCBidHJmcz8NCnhm
c3Rlc3RzIGhhcyBhIHRlc3QgY2FzZSBnZW5lcmljLzY3MyBmb3IgdGhpcywgc28gYnRyZnMgYW5k
IHhmcyBzaG91bGQgDQpoYXZlIHRoZSBzYW1lIGJlaGF2aW9yLg0KSSBsb29rIGludG8geGZzIGNv
ZGUuDQoNCkZpcnN0bHkNCg0KSWYgd2UgZG9uJ3QgaGF2ZSBDQVBfRlNFVElEIGFuZCBpdCBpcyBh
IHJlZ3VscmUgZmlsZSxhbHNvIGhhdmUgc2dpZCBiaXQsIA0KdGhlbiBzaG91bGRfcmVtb3ZlX3N1
aWQgd2lsbCBnaXZlIGF0dHIgYSBBVFRSX0tJTExfU0dJRCBtYXNrLg0KDQpBVFRSX0tJTExfU0dJ
RCAtPiBjbGVhciBTX0lTR0lEIGlmIGV4ZWN1dGFibGUNCg0KaW50IHNob3VsZF9yZW1vdmVfc3Vp
ZChzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpDQp7DQogICAgICAgICB1bW9kZV90IG1vZGUgPSBkX2lu
b2RlKGRlbnRyeSktPmlfbW9kZTsNCiAgICAgICAgIGludCBraWxsID0gMDsNCg0KICAgICAgICAg
Lyogc3VpZCBhbHdheXMgbXVzdCBiZSBraWxsZWQgKi8NCiAgICAgICAgIGlmICh1bmxpa2VseSht
b2RlICYgU19JU1VJRCkpDQogICAgICAgICAgICAgICAgIGtpbGwgPSBBVFRSX0tJTExfU1VJRDsN
Cg0KICAgICAgICAgLyoNCiAgICAgICAgICAqIHNnaWQgd2l0aG91dCBhbnkgZXhlYyBiaXRzIGlz
IGp1c3QgYSBtYW5kYXRvcnkgbG9ja2luZyBtYXJrOyANCmxlYXZlDQogICAgICAgICAgKiBpdCBh
bG9uZS4gIElmIHNvbWUgZXhlYyBiaXRzIGFyZSBzZXQsIGl0J3MgYSByZWFsIHNnaWQ7IGtpbGwg
aXQuDQogICAgICAgICAgKi8NCiAgICAgICAgIGlmICh1bmxpa2VseSgobW9kZSAmIFNfSVNHSUQp
ICYmIChtb2RlICYgU19JWEdSUCkpKQ0KICAgICAgICAgICAgICAgICBraWxsIHw9IEFUVFJfS0lM
TF9TR0lEOw0KDQogICAgICAgICBpZiAodW5saWtlbHkoa2lsbCAmJiAhY2FwYWJsZShDQVBfRlNF
VElEKSAmJiBTX0lTUkVHKG1vZGUpKSkNCiAgICAgICAgICAgICAgICAgcmV0dXJuIGtpbGw7DQoN
CiAgICAgICAgIHJldHVybiAwOw0KfQ0KDQpUaGVuIGl0IHdpbGwgY2FsbCBub3RpZnlfY2hhbmdl
IHRvIG1vZGlmeSBpbm9kZSBtb2RlIGJ5IHVzaW5nIHNldGF0dHIgDQpob29rIGFzIGJlbG93Og0K
ZnMvYXR0ci5jIG5vdGZpeV9jaGFuZ2UNCgl7DQoJLi4uDQoJICBpZiAoaWFfdmFsaWQgJiBBVFRS
X0tJTExfU1VJRCkgew0KICAgICAgICAgICAgICAgICBpZiAobW9kZSAmIFNfSVNVSUQpIHsNCiAg
ICAgICAgICAgICAgICAgICAgICAgICBpYV92YWxpZCA9IGF0dHItPmlhX3ZhbGlkIHw9IEFUVFJf
TU9ERTsNCiAgICAgICAgICAgICAgICAgICAgICAgICBhdHRyLT5pYV9tb2RlID0gKGlub2RlLT5p
X21vZGUgJiB+U19JU1VJRCk7DQogICAgICAgICAgICAgICAgIH0NCiAgICAgICAgIH0NCiAgICAg
ICAgIGlmIChpYV92YWxpZCAmIEFUVFJfS0lMTF9TR0lEKSB7DQogICAgICAgICAgICAgICAgIGlm
ICgobW9kZSAmIChTX0lTR0lEIHwgU19JWEdSUCkpID09IChTX0lTR0lEIHwgU19JWEdSUCkpIHsN
CiAgICAgICAgICAgICAgICAgICAgICAgICBpZiAoIShpYV92YWxpZCAmIEFUVFJfTU9ERSkpIHsN
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlhX3ZhbGlkID0gYXR0ci0+aWFfdmFs
aWQgfD0gQVRUUl9NT0RFOw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYXR0ci0+
aWFfbW9kZSA9IGlub2RlLT5pX21vZGU7DQogICAgICAgICAgICAgICAgICAgICAgICAgfQ0KICAg
ICAgICAgICAgICAgICAgICAgICAgIGF0dHItPmlhX21vZGUgJj0gflNfSVNHSUQ7DQogICAgICAg
ICAgICAgICAgIH0NCiAgICAgICAgIH0NCgkuLi4NCkhlcmUgaXQgd2lsbCBzdHJpcCBhdHRyLT5p
YV9tb2RlIGJ5IGNoZWNrIGlub2RlLT5pX21vZGUgd2hldGhlciBoYXZlIA0Kc2dpZCBiaXQgYW5k
IGdyb3VwLWV4ZWN1dGUgYml0Lg0KDQp0aGVuIHNldGF0dHJfcHJlcGFyZSBhbmQgc2V0YXR0cl9j
b3B5IGhhcyB0aGUgcmVtYWluaW5nIHNnaWQgc3RyaXBwaW5nIA0KcnVsZSBqdXN0IG5laXRoZXIg
YXJlIGluIHRoZSBncm91cCBvZiB0aGUgY3VycmVudCBmaWxlIG5vciBoYXZlIA0KQ0FQX0ZTRVRJ
RCBpbiB0aGVpciB1c2VyIG5hbWVzcGFjZS4NCg0KICAgICAgICAgaWYgKGlhX3ZhbGlkICYgQVRU
Ul9NT0RFKSB7DQogICAgICAgICAgICAgICAgIHVtb2RlX3QgbW9kZSA9IGF0dHItPmlhX21vZGU7
DQogICAgICAgICAgICAgICAgIGtnaWRfdCBrZ2lkID0gaV9naWRfaW50b19tbnQobW50X3VzZXJu
cywgaW5vZGUpOyAvLyANCnRoaXMgY29kZSBzZWVtcyB1bm5lY2Vzc2FyeSBjYW4gYmUgdXNlZCBk
aXJlY3RseSBpbiBpbl9ncm91cF9wDQogICAgICAgICAgICAgICAgIGlmICghaW5fZ3JvdXBfcChr
Z2lkKSAmJg0KICAgICAgICAgICAgICAgICAgICAgIWNhcGFibGVfd3J0X2lub2RlX3VpZGdpZCht
bnRfdXNlcm5zLCBpbm9kZSwgDQpDQVBfRlNFVElEKSkNCiAgICAgICAgICAgICAgICAgICAgICAg
ICBtb2RlICY9IH5TX0lTR0lEOw0KICAgICAgICAgICAgICAgICBpbm9kZS0+aV9tb2RlID0gbW9k
ZTsNCg0KSXQgc2VlbXMgdGhpcyB3YXkgaGFzIHNpbWlsYXIgbG9naWMgYnV0IG5vdCBpbmNsdWRl
IHVtYXNrLg0KDQo+DQo+PiAgIAlzdGF0dXMgPSBkcXVvdF9pbml0aWFsaXplKGlub2RlKTsNCj4+
ICAgCWlmIChzdGF0dXMpDQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9mcy5oIGIvaW5j
bHVkZS9saW51eC9mcy5oDQo+PiBpbmRleCA1MzJkZTc2YzliOTEuLjBiZjgxYWI3MTYxOSAxMDA2
NDQNCj4+IC0tLSBhL2luY2x1ZGUvbGludXgvZnMuaA0KPj4gKysrIGIvaW5jbHVkZS9saW51eC9m
cy5oDQo+PiBAQCAtMzQ1OSw2ICszNDU5LDE3IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBkaXJfcmVs
YXhfc2hhcmVkKHN0cnVjdCBpbm9kZSAqaW5vZGUpDQo+PiAgIAlyZXR1cm4gIUlTX0RFQURESVIo
aW5vZGUpOw0KPj4gICB9DQo+Pg0KPj4gK3N0YXRpYyBpbmxpbmUgdW1vZGVfdCBwcmVwYXJlX21v
ZGUoc3RydWN0IHVzZXJfbmFtZXNwYWNlICptbnRfdXNlcm5zLA0KPj4gKwkJCQkgICBjb25zdCBz
dHJ1Y3QgaW5vZGUgKmRpciwgdW1vZGVfdCBtb2RlKQ0KPj4gK3sNCj4+ICsJbW9kZSA9IGlub2Rl
X3NnaWRfc3RyaXAobW50X3VzZXJucywgZGlyLCBtb2RlKTsNCj4+ICsNCj4+ICsJaWYgKCFJU19Q
T1NJWEFDTChkaXIpKQ0KPj4gKwkJbW9kZSY9IGN1cnJlbnRfdW1hc2soKTsNCj4NCj4gWW91J3Jl
IG1pc3NpbmcgYSAifiIuIEkgYXNzdW1lIHlvdSBtZWFudDoNCj4NCj4gbW9kZSY9IH5jdXJyZW50
X3VtYXNrKCk7DQpZZXMsIHNvcnJ5IGZvciB0aGlzLg==
