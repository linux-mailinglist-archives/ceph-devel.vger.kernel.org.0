Return-Path: <ceph-devel+bounces-3985-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5963CC49473
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 21:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C9892344FE8
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 20:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA502F2914;
	Mon, 10 Nov 2025 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sdQbiCA5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817682F28E9;
	Mon, 10 Nov 2025 20:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762807345; cv=fail; b=G508/QASPk7gSEzN2KLwXXIdbRY9baBH8h01v1z3/0e1pWUPwoEEiTEKgeyrgGdWokQJkOWtgy/kp6xpU6OetypznyvWJpwjfOb7L/DtJfI4Z1n7vP70asKEIcrNz4QAlFs1zT1cKtp4GFVgV7Wfsgh2hnrCIDTfPt2nScXeGgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762807345; c=relaxed/simple;
	bh=9nBvOsQbCLWpORZ12K6tAAyk1BFHaSVOI4AqOCPu/AU=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=juLYdwyfB1ugKv/H2aKjoGUcuT3sWuwn0vXamR0j9+3knnsl2eE0ovXvefU/Pzwd4daSlty8lt1AyCjkF0IfD1B0ezyu/2L4LKMhHn/WI8FLDI1PdTUf/edpIr1rDQ49H4Iv7lEtkK/M/sfxvfroJ2Z6VgTW4srgMS3+IE9w+qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sdQbiCA5; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AADRFnj023602;
	Mon, 10 Nov 2025 20:42:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=9nBvOsQbCLWpORZ12K6tAAyk1BFHaSVOI4AqOCPu/AU=; b=sdQbiCA5
	MJebfbYyLEQYWpllVPLJzbwbuYYaFEhpFoe5NpY3+XaPRgWCRefFAM8VBmvGseUk
	cZsLWYXRD7zRdTjs7DJzJS4EhyrMdmZB3WwMMbg9OHAlEhtyl9HObAD9Dx8VGZaU
	eWLcW9vLQnKHwt65XCTMINQSdszVLu3u5u7AeNdqlhVOk970HcCF2ecsRYGBDzcx
	2SK4154vZr89GqQw01Xx6zQyscm1sDvVPwU0gp2USUR+1M6O0/J4t2i0Unif3YGx
	bGr95uSps5pEJvQGK18VE9hPIoJk8Q/7OoL40t0dvLQlmRC/RFfLTL2S9v2RDK1j
	qJf4mcq880GnQQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cj0wtp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 20:42:16 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AAKgF1r022465;
	Mon, 10 Nov 2025 20:42:15 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011064.outbound.protection.outlook.com [40.93.194.64])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cj0wtm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 20:42:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UcTZQELM3DYKmI3SDI8l/agYMNuqw1G0HYeGASZ9XHbWEXX7uOO1TqXk7SuhvF96bpWx1Fea60rkKdMJ4Orr9l3YnedWff9I+VJSg6BGm+hKRbAx1wU4IYl6ZW2nSM79k4AnskZ5nVHxDfD5yOA68BimIp038472GGh52V/abeVn1YBynWSYwPMjgOFHEjftG7kNopwXA9Sqbv479q4GFyAPbmdrgVchR0jpeNaKajPS0CizdQi6HWTgeY8oK8Y4tvwJ5oEjOhcumHvHnfL2zTbDK1QqyxNsieypMWORLxZaDyySiyoL8pbAcWDr0Fpivv7zqFsH7ATwrdfZkAC4kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9nBvOsQbCLWpORZ12K6tAAyk1BFHaSVOI4AqOCPu/AU=;
 b=TWuY+i+Ty0Ujcwy92tYQUnlKt4tv7Ac48tdMLVFDdiT+n34keVfdYAfSSu/9FOgbUpyHMXzbr07AmOrpUreSjNnHy7Alf2/ZAhFuT5DJns4RO5zHymjLaK5bMCVsRYamWrV9fcJKAFbxg3HOP6NMt/BAnnDYjUsPXWk/GekEqYhWjUfvDhkFpe3Z2Tivo3TbnQugZv7LSJeR9Mnw/O2baZv7UBCL1Ov7unQtqYDwWYv4x3AcGhDci1uvADFYJu0mZWBTQj/uDyKHUloobWwVGnWnsSi/GVtT2dsbPbaJWbPbHegoH8p7BxPrPZc+a8z5Grqqid1EAigGv6YFekZvUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA3PR15MB5727.namprd15.prod.outlook.com (2603:10b6:806:311::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 20:42:13 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 20:42:13 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
CC: Xiubo Li <xiubli@redhat.com>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "morbo@google.com"
	<morbo@google.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH v1 1/1] ceph: Amend checking to fix `make
 W=1` build breakage
Thread-Index: AQHcUnpBY6YJKfAb+keetMdZm4Ts4LTsYAYA
Date: Mon, 10 Nov 2025 20:42:13 +0000
Message-ID: <c2805e34c4054bfa3308af0d18712e412f024ed6.camel@ibm.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
	 <9f7339a71c281e9f9e5b1ff34f7c277f62c89a69.camel@ibm.com>
	 <aRJASMinnNnUVc3Z@smile.fi.intel.com>
In-Reply-To: <aRJASMinnNnUVc3Z@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA3PR15MB5727:EE_
x-ms-office365-filtering-correlation-id: 7438f797-1be9-4b12-2823-08de2099a0b4
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?aTRoRDhzUTdHUE16SmZRQkFxdXpDZDlrd0pVc3lPSnVoSDUwTVV1Ym40Unlx?=
 =?utf-8?B?elNGYlRRbEF6VytUNXI3TmRZemV1VEJmb21TeVNaclhBdlpXcy9ybk0wK1F1?=
 =?utf-8?B?bVkrNGxKckdiQnhOWW5VcFluekIrQ0krb1pPWkJnNG1IN1RFYXZza1o1RGgw?=
 =?utf-8?B?eGJQOTV6VWZ0U005VjkvdTlSbzRMM2lpKzNUZFN5eGQ2NnM5Ulp3bU4vWTNN?=
 =?utf-8?B?eTN2QTRkaUhyM2hrOTlyZTVyNjh4dGtTcmtsVC9JWHcvcXlqNVBVcmJuUERL?=
 =?utf-8?B?ckJnMXZIZXQ3UEpIZ0JjaVlaL1NpR3k0ZjZONzRmRmNPMEhkQ0dtZlRPaFpv?=
 =?utf-8?B?SzU3eEFTWDVObmR0NWk4T3JPVzlpOHI4d21kbjFvdGNkQy9nbUxIRzZjZWl6?=
 =?utf-8?B?cTB4WDNnb21YMHFyZWJEYkhMSVJ2V2FSeWxMb0lMZTA4aDQyKzRzeHBtck1K?=
 =?utf-8?B?ZGlnUE5DSVM4RjlXSHZPRWVjLyt3cFUvRTdtdE9HbDJYaGdkcWl1alh5bmZX?=
 =?utf-8?B?ZnFwK3krU09FbXl2YlBONVh4ckxzNzB4ekVFWUR3TW51a2hJQ0xYQ0RkWnBR?=
 =?utf-8?B?aHE2UlpENVBaQVZmcTJtUUFMUDg5MkRidUxGVTdkdWlnK21Jem8zZVhQbTlR?=
 =?utf-8?B?dzRCbDlMNTdvbGtSQ0RyeGwwbDBEQTJobHUwTTVCZURtc2FibkZXTHlMV1Jn?=
 =?utf-8?B?TXFuSkRwMWEwRWF4U0xCMGVJa0F5b04zVnpnRHZsNWZGU0NUbmFoUmJjQ21W?=
 =?utf-8?B?RHVrTndaWEF2UHo3cWdUN0U1TGExbDlMbU1yVGduY3pocXVtbzdhZWJOVWN0?=
 =?utf-8?B?bkZRUHdRYmFZellqc0wxWnEvRGZGZXRHdk92SW01VGtXbkgrWWZEY2JpM2Vq?=
 =?utf-8?B?TzIyTCtvNXFUTWlzbE1zSHp4blRsM01yWmcrS1B0QWthd3RXdUE0OFVnRFdQ?=
 =?utf-8?B?UzdZTE5hdHNSQmZIU2pDK3dpaU9FaHNqd2VGbU5tbmxDbkpDMW1YNUNmMUxz?=
 =?utf-8?B?MXFaaVpOaEtjcGgwMTYrYUhueEJaY0N5a3R1N01lK3ExMmI4TEh5dlk5UXd0?=
 =?utf-8?B?Qk5FT1VYMDlncUFTR3RQN2o3L1QycjZNRkwzNkU3N2g2Rk5UV1drc05JZjVa?=
 =?utf-8?B?VzJ2c2NlM09nVGZjblJSQit2dGVHRWpkQjZXQVhQWkVsRFhLbTBsKzZIZUZZ?=
 =?utf-8?B?b2h3aUZzR0gwaUxnU21Na21kbDM5d2cxMG9ZRUZKRU1mbWRISHhqc0FGT3Fp?=
 =?utf-8?B?d1o0VUcrN0JUU2laVkdwaDl5WWNESU1zVWRnRzEwZW1jL1NEVTR1aTdseXM1?=
 =?utf-8?B?U05FemxlS0ZYSjFic0E1cXRWdS9SY0lqaTJRMWdJYkpyQzF6bm43SXBRWmdz?=
 =?utf-8?B?V0pRUC9mZ1NWUE9iUDdscEhrdlR3MmVVdFlManRobFZENEZWaXRvNWRIeVBP?=
 =?utf-8?B?aElaOEFmdHBUWVRaeFFaTVBhZWl3YTQ5NzFNekpSQlllR0kvMEZZd0hVL2hL?=
 =?utf-8?B?aVMvVFRMTDNkMExCNEtmbmNpNWNGS3ZPeGo1MzlQMXozd3NzZGtDenBxR0Fy?=
 =?utf-8?B?Zm9uSEpSMDZzcVhhdW5aZjl4Zk8yeERSYUFKdnpNeE1EV1B4eFc4ZXRmY1E3?=
 =?utf-8?B?cFJRT3Z1S0RoOTdsK3dvTWh5ZTVzTFdhNXpBTFJ4NEFWTkk3bytZRHc5WHBw?=
 =?utf-8?B?OE9uRzEzSTlvV1psM25tTXhXM3FSZ21FZTJNZ0U1MDRGcXMrakU3b21hak1x?=
 =?utf-8?B?SllmajBlMytWMTZvY1BRSHpEcW1ETWRPQVIxVUJ6SnFmSzh5TjRxOW0yVG55?=
 =?utf-8?B?dDY3NXpaYWtOdXlFR2l2RDh2cW9NL2syWVh3SFErOXk2OUszMWN0KzBXS0Vu?=
 =?utf-8?B?L2g5RmhNc1kyZUVBQXUxUGM2b09DSm9IYzZnQitxL3Zac1VJL2dySFVUVXNB?=
 =?utf-8?B?VW1saEUwOVRjbWFrZ1NoQ3pOd0J3ODRTK3N0bFcyUHdsZmFaM0ZuQ29lQWVh?=
 =?utf-8?B?V2E5V2wvNXcyaktCMVB3amhIMDB6MEs3NkJPNFhqSDg1RnRZVUpaakFvN0hv?=
 =?utf-8?Q?g8Oo4o?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TkZkYkpia2QxUE1ldUVTZlUrUUhEZFRZYk9LS3hMWk5IRWVNcXJXc2thZmt1?=
 =?utf-8?B?Zkw0TXh2YXV5QTUzais4T1RkQjYvNm50Y29CcUVxcWtBYUlQYzRXUmdaUzJG?=
 =?utf-8?B?MHppd2U3OEVxcGJGU2IvTUpEbTllOVNmN2hVY0p1ZEZ3UHVFVkYvQWZUQW9w?=
 =?utf-8?B?TnFvR2VucEt1UVNjckVrQktQY2tXSHo1WDRWVjNYS1FOakRKRWp3U1dGdEFq?=
 =?utf-8?B?U1V1TXJnRVdrd1pXRkRqNis5a2J4dEtFUWRsT0dKYW5DR1BPWFdtUlA5RDFv?=
 =?utf-8?B?TEVHRnRnQzVVOXFrN0VKUmNPSkNRYVhrTldjNEFrWm41YmQ5OWZtYnI1YktV?=
 =?utf-8?B?dUJ2MjEyczNnU0tlYXdkeEYzMWxMSzhQdHpiem4yWmozRVlab050THZqZmVt?=
 =?utf-8?B?RVRtdWFuWmQ2c0daVU5hei84NnF1aVZaZW92bzVhRE5CWnBPaml5Z20zWkx3?=
 =?utf-8?B?MkdrMmlQZnM3Mm8zQUJqU0s4My84TXNtZEZxNHprK2JwMlU5bUtUSFRyeFpN?=
 =?utf-8?B?QTB2bzEvSmJ1bVYyYzVHdHVSQzhjS281RVdRbGpkQ3BSQUlqbFBtVG5MOEoy?=
 =?utf-8?B?N0RhVFJZZDJXWWJXczBUaWlzYTJEM1FXU2d2anZueWdzcGY1SlR1dnB4ZHRB?=
 =?utf-8?B?SENpc0hyUU1Rcm55ZVVlaXRBY2g4RWVoSnU1Tk9MVnk2OGZLWDhuZGpCV1VV?=
 =?utf-8?B?VEVGRSs0cHVCclg3NzJmK205TjcyTXhkZGZWWlF3U2RselRDVjB1cUJJTURM?=
 =?utf-8?B?MUcwQWRVZWlLbHZUSlFqdk5YekZKSmZxY0hVa0hGcmRhcjBIZGJMZjFpWmJ3?=
 =?utf-8?B?UnlCcHBiLzl4Y0JQT1RGM0psek54RlJOUVZENGZRbm9lUlJwRUtpTWhXWTR6?=
 =?utf-8?B?bmFXRCtaZmpkd1VUa243UmlUY2RIWHdVY2xGUUJXd3krUEgxbDZ2U1dZNk1G?=
 =?utf-8?B?WlhSdzlKZ2tWSkdHa0xZRFg2bG1FR2l2SU5LNEorRjNONXAwR2lGbTU1cGpp?=
 =?utf-8?B?dzVTbmJwdUo4ODhlbWU2QWdnZzdPcmpIaHZsRVJ6RUwxbUd3dWVYWUIycFJI?=
 =?utf-8?B?LzFXa28xM2pJQm1XZ0xwVTVHMFRLYU5XVXRRcXVPRmMzdUFRMDRFZ2dpSG53?=
 =?utf-8?B?Rjg2V1IyV3MwZlFGL1BHR0p5aXgxRjhMZ2gyT1NBeWFHVGtFeEFrc1MxYnVt?=
 =?utf-8?B?bEo5Wjhuc3hPS2wyNW9BRlJlUHRxZ0ZGaWtwNGVMVmtXYUhaSkJkRVYrVTFD?=
 =?utf-8?B?Y041c3p2cVZ0SkRtTi96YXdWNHRoWTNwb3YzalJGVEk2S3V0VkQ5VURlT3Z5?=
 =?utf-8?B?YzlWbFB5VHVtTjNjamc3ZVRHcys0RFcxeHdudGorQlhhcWhxNTJ2cFMrbjhF?=
 =?utf-8?B?WFBXL01IaGJaeEFyMU5QMlJmZUJNMHZsYVQ0Vks2RDJKSzBCVjVNZEFRQ253?=
 =?utf-8?B?b1hQNnZPY0wrcFpsM1lEckw5d0xXWDM2bnVHaWpxSDZMaXpxTjFtQy9VQU9M?=
 =?utf-8?B?VTVJN3h5OEV2eE96WjdyMjkvQnhUTUpPeElIQndUUkpxMmY1L2tZQldrWlpB?=
 =?utf-8?B?OURXcmNsUTdHakx2OW1Zc2NDQTBEbVVMSUxQdUVkM2pvODF4Tk1BNDBrWEhQ?=
 =?utf-8?B?MmszTUo5dnVqSVY1dElRWnhweVRIekxSUDJVZjM5VUdBckRZcG1ycmFNN25h?=
 =?utf-8?B?Q3pMUVhhZzNNQTBIR09qQXQxaEEvOEdIK1F3bm5JTEtqZ0pmUXB3M1JFQnBC?=
 =?utf-8?B?Smg5KzNuWVJYaXZ2VjhPdDRhRzBqUlg5SnRXS0lWY0xNaS91V0F5bGJRVmJy?=
 =?utf-8?B?TkkvU2RUVFZUbUtlYWRWMXVxTHk1eHdFS2E2YUxBcEp2ZzBUU3VTME1SZWJ1?=
 =?utf-8?B?NlBQeTZHWVo0R1NZeGx3OEJ3dkJvWmtHcmt4QWpuTnRmc05PQ2piSmZwODVB?=
 =?utf-8?B?ck1hRXhPcHNEeW9uMXU1ZE5zRitJTkI5cExXV2NPc3NSZ2lPbkd6ajJwak1S?=
 =?utf-8?B?alN6U0NNTzljK3JBTlZWQmhSVUxxZFA5OUpZZG56Z29kaktPR2F1VUllM1Vm?=
 =?utf-8?B?NTREeHNyTGxYSHNMTGY0dFUra1NnUmo3QnhjSG5TQng5YWYvR0ZsUVVIL2RR?=
 =?utf-8?B?TkJWYkFtVGV6WXhhbG56Tk1MZXZCVzBXRG54Um9nVlJ4dGNKR2J0b0JPc1pC?=
 =?utf-8?Q?u5qSq4RL+GmS39vjWfMik0A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08A540A4A56C254DA250DD280D5DCE5E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7438f797-1be9-4b12-2823-08de2099a0b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2025 20:42:13.1198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8gCzXDZreH5RZgRIMbuCRuIIOTgGwVlrx6a2l3m+saiVni861t9j6eHVLiOEFbZXezXi9DtClc2b68HCHpTLYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR15MB5727
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=69124e28 cx=c_pps
 a=cAYAfY5XwGGlFG+HVYY7CQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8
 a=B_QdrmtyfgwEUcUavNkA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfX67bd069aNiv1
 rY1++c60LHB+h2r8zKbPrAeeuRGoDZ9WSeZ07dFPYQDHz4uAR46DxEB5NjXlz41QJI1WO7z9B5C
 Pqma5tztIizP5XzBp/pCplErcXFcKNMYfga1xMyriUwmluDgyYiUEj2SiTcE76EccgBZXzouH6l
 P2gOQ7T7aLVErSKwmYwWNCYlTbQzKKNzrWs4zp2+nyquYFBl7Y3etKVZqOIw7X5cVL5wAztBOgj
 QF5IugSQ/n4UEwAZK/JOZ7bEmCiOgDZxCRJCnGNn/EzgIPgQ/nesmUndqRfbrBW506VDnBaciWv
 4Wgwnt5KbXulaEbn/EK0arP+iQi61tRgLCmmt3NPBEJ+HkQlrGZ6yT4XgnBd+oTeTq9Nbc1NfhE
 FtgUOejKnL8C7FtUkClPf5axACYlXQ==
X-Proofpoint-GUID: FXL9LAKS4tYAxk-Fp8t7_D3fGXqml-kI
X-Proofpoint-ORIG-GUID: 5O0QgTlb5agRWiQog0lJFEP-Bl06PIg4
Subject: RE: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095

T24gTW9uLCAyMDI1LTExLTEwIGF0IDIxOjQzICswMjAwLCBhbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20gd3JvdGU6DQo+IE9uIE1vbiwgTm92IDEwLCAyMDI1IGF0IDA3OjM3OjEzUE0g
KzAwMDAsIFZpYWNoZXNsYXYgRHViZXlrbyB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjUtMTEtMTAg
YXQgMTU6NDQgKzAxMDAsIEFuZHkgU2hldmNoZW5rbyB3cm90ZToNCj4gPiA+IEluIGEgZmV3IGNh
c2VzIHRoZSBjb2RlIGNvbXBhcmVzIDMyLWJpdCB2YWx1ZSB0byBhIFNJWkVfTUFYIGRlcml2ZWQN
Cj4gPiA+IGNvbnN0YW50IHdoaWNoIGlzIG11Y2ggaGlnaGVyIHRoYW4gdGhhdCB2YWx1ZSBvbiA2
NC1iaXQgcGxhdGZvcm1zLA0KPiA+ID4gQ2xhbmcsIGluIHBhcnRpY3VsYXIsIGlzIG5vdCBoYXBw
eSBhYm91dCB0aGlzDQo+ID4gPiANCj4gPiA+IGZzL2NlcGgvc25hcC5jOjM3NzoxMDogZXJyb3I6
IHJlc3VsdCBvZiBjb21wYXJpc29uIG9mIGNvbnN0YW50IDIzMDU4NDMwMDkyMTM2OTM5NDggd2l0
aCBleHByZXNzaW9uIG9mIHR5cGUgJ3UzMicgKGFrYSAndW5zaWduZWQgaW50JykgaXMgYWx3YXlz
IGZhbHNlIFstV2Vycm9yLC1XdGF1dG9sb2dpY2FsLWNvbnN0YW50LW91dC1vZi1yYW5nZS1jb21w
YXJlXQ0KPiA+ID4gICAzNzcgfCAgICAgICAgIGlmIChudW0gPiAoU0laRV9NQVggLSBzaXplb2Yo
KnNuYXBjKSkgLyBzaXplb2YodTY0KSkNCj4gPiA+ICAgICAgIHwgICAgICAgICAgICAgfn5+IF4g
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4gPiA+IA0KPiA+ID4g
Rml4IHRoaXMgYnkgY2FzdGluZyB0byBzaXplX3QuIE5vdGUsIHRoYXQgcG9zc2libGUgcmVwbGFj
ZW1lbnQgb2YgU0laRV9NQVgNCj4gPiA+IGJ5IFUzMl9NQVggbWF5IGxlYWQgdG8gdGhlIGJlaGF2
aW91ciBjaGFuZ2VzIG9uIHRoZSBjb3JuZXIgY2FzZXMuDQo+IA0KPiAuLi4NCj4gDQo+ID4gPiAt
CWlmIChudW0gPiAoU0laRV9NQVggLSBzaXplb2YoKnNuYXBjKSkgLyBzaXplb2YodTY0KSkNCj4g
PiA+ICsJaWYgKChzaXplX3QpbnVtID4gKFNJWkVfTUFYIC0gc2l6ZW9mKCpzbmFwYykpIC8gc2l6
ZW9mKHU2NCkpDQo+ID4gDQo+ID4gVGhlIHNhbWUgcXVlc3Rpb24gaXMgaGVyZS4gRG9lcyBpdCBt
YWtlcyBzZW5zZSB0byBkZWNsYXJlIG51bSBhcyBzaXplX3Q/IENvdWxkDQo+ID4gaXQgYmUgbW9y
ZSBjbGVhbiBzb2x1dGlvbj8gT3IgY291bGQgaXQgaW50cm9kdWNlIGFub3RoZXIgd2FybmluZ3Mv
ZXJyb3JzPw0KPiANCj4gTWF5YmUuIE9yIGV2ZW4gbWF5YmUgdGhlIFUzMl9NQVggaXMgdGhlIHdh
eSB0byBnbzogRG9lcyBhbnlib2R5IGNoZWNrIHRob3NlDQo+IGNvcm5lciBjYXNlcz8gQXJlIHRo
b3NlIG5ldmVyIHRlc3RlZD8gUG90ZW50aWFsIChzZWN1cml0eSkgYnVnPw0KPiANCj4gLi4uDQo+
IA0KPiBXaGF0ZXZlciB5b3UgZmluZCwgaW4gY2FzZSBpZiBpdCB3aWxsIGJlIG5vdCB0aGUgcHJv
cG9zZWQgc29sdXRpb24gYXMgaXMsDQo+IGNvbnNpZGVyIHRoZXNlIHBhdGNoZXMgYXMgUmVwb3J0
ZWQtYnkuDQo+IA0KPiBBbmQgdGhhbmtzIGZvciB0aGUgcmV2aWV3cyENCg0KSSB0aGluayB3ZSBj
YW4gdGFrZSB0aGUgcGF0Y2ggYXMgaXQuIEl0IGxvb2tzIGdvb2QuIFByb2JhYmx5LCBpdCBtYWtl
cyBzZW5zZSB0bw0KdGFrZSBhIGRlZXBlciBsb29rIGluIHRoZSBjb2RlIG9uIG91ciBzaWRlLg0K
DQpSZXZpZXdlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+
DQoNClRoYW5rcywNClNsYXZhLg0K

