Return-Path: <ceph-devel+bounces-3347-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0349B187EE
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Aug 2025 22:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62624AA5E9B
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Aug 2025 20:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6B9128395;
	Fri,  1 Aug 2025 20:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SugJElcq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68D311CA0
	for <ceph-devel@vger.kernel.org>; Fri,  1 Aug 2025 20:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754078459; cv=fail; b=J0bdROk80ChSPNT1jJ2lGYTYrOfb4Gm3Oiqvh8QlwSZKodNlfJUh6PPjPD5n3md8KV6Sxq9y4OwvwSCxv88WbIC5tPSOQT4mqCT3Wwd9XDES+OC1qQWhguU1F8tVrC72be4/84SbfILwXbXscewlkU8h+s7BNuFHiCGTWjndKtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754078459; c=relaxed/simple;
	bh=DK312Oc+VVNHoLWLy8vZPjxLCdz6hVhqQlQEqE5uOUk=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=EbgiLU/A4JBftMDrVAZdNr/myheHYVHD2mgTHI9mnzhQW3hXgtXAY9acIQpRQk5+lInYEIkzMulMj6Lnf1y1vTU1rD2qxjBPZF5GJt2bs/qewQ3mmznOn87sDaU8BbZgdlfMtHUJVhWJ47ImivpbnOBy4lBNUWWZPFC8M0XTbHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SugJElcq; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 571Dm2XT026265;
	Fri, 1 Aug 2025 20:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=DK312Oc+VVNHoLWLy8vZPjxLCdz6hVhqQlQEqE5uOUk=; b=SugJElcq
	c6LDarocNxz3OfsbeDwIBBaSsCC2zeajn1KkW8DQ4N753lQoHeNdta2Mfc1Rrc4X
	rBxpR1xNnuUV4FeSC9tAUKrADwCxhGy6IPcdrzz+gCM5AktjA/Aq8ttnBJsb4MI3
	VEfyScs8PrZriqM3ML4jfA4hNc49dhNjaen+vspKg/atPfHRRKJ8oXpuQIbuj1Mb
	iaMzaV0BX5Qt81Dr/e9eWEslcmZi/sx31iaKsKyIWmCDKJ4FUikOD2YF3EncjK4w
	3LC9HZ8R6WVJ29mXqOSS6llgioqK+iXzp4KrJ+we7wUzTS/NzncdusRYUAqeauO5
	Iz4aDtH6zqZduQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 487bu0g9g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Aug 2025 20:00:53 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 571K0rJC000622;
	Fri, 1 Aug 2025 20:00:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 487bu0g9fy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Aug 2025 20:00:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=seTGCj6OMgQI8r4WsUWdNS7rXd6JNt2J1JNU+uNg5kqzr/NDmg1P2UvRhtYUGyKuCK3HC2109subILY5CeB1vEm183eEMUaKij2NoW4NPTvjzhy+EvCb5a42QC+La1wd2aXsfElnWIsgCLpmDEIQXKmlmnwlOKBeW2pAX5oLhy+2VCzY4qKrtyYvh1x521WRU4BmZmtgjd1506MPCVwx1Z+Ud7v0jCSdQJMGB+NpRZpkgHUqPOapR9spQHE66xDnC05HVldGsItkpasfCij3K3FJai4Wao60mp9sTdrKuweGJ/gTrDHiTzCwuasYd/qGu6R08cp94hbCueoLUdPyQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DK312Oc+VVNHoLWLy8vZPjxLCdz6hVhqQlQEqE5uOUk=;
 b=WwaRSxZLLHEMlQKR6jqv6YMJd+BmguuBzoX29FYCjMsGmUHBJi35C4Wwh7O9h25+1+i+kxflo04hLz7ZeQNooNgb+uUADeoFLsr20Ute6/C8eQ32hYu4IhyWvhkB/a/qiKPWrtyMeuCgGHFna5eao9ccxKfadHH0Qy/LQhEKuRcuNUkfOJahjRvq51wViW/m25Uk/wPr5e0t4rsyrARG0uXN+Jztobq67ZrqW6EMaFSixv/56uSyHx9uZu7Qbl9eAiPXr231J/T22TeEvMshJdjs3w9MaLuql9de1XZGPDa7/4YDTajXJt4w2VrFUvploJ9ZNcT4BBEHPd5r0bQSBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4661.namprd15.prod.outlook.com (2603:10b6:a03:37a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Fri, 1 Aug
 2025 20:00:51 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8880.026; Fri, 1 Aug 2025
 20:00:51 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
CC: Venky Shankar <vshankar@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Alex Markuze <amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: Fix multifs mds auth caps issue
Thread-Index: AQHcAwnX8VFv10r3BUWfP7rTtDMVw7RON+EA
Date: Fri, 1 Aug 2025 20:00:50 +0000
Message-ID: <6ec6e3f45e4b90c2b56f4732e0e56fb389442c6e.camel@ibm.com>
References: <20250729170240.118794-1-khiremat@redhat.com>
		 <3dbbabbd68b58c95a73d02380ce6e48b5803adf2.camel@ibm.com>
	 <CAPgWtC4s6Yhjp0_pnrcU5Cv3ptLe+4uL6+whQK4y398JCcNLnA@mail.gmail.com>
In-Reply-To:
 <CAPgWtC4s6Yhjp0_pnrcU5Cv3ptLe+4uL6+whQK4y398JCcNLnA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4661:EE_
x-ms-office365-filtering-correlation-id: 55645a84-f7ab-43ff-b1b6-08ddd1361d7e
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|38070700018|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?aDF1Q0w3UzdyMmdSZVJVdkd4dEV4Zkd2N0Z5dG5aT2MzSWhrSWk3YnNHU01i?=
 =?utf-8?B?Y2FBYkJmcEhzRXVEY1RLenFDSkc1MHh3ZnlzK3hCbWd1NHpmVmJQMGx6VU8x?=
 =?utf-8?B?OTdVWW4wU0ZxcjVTY3RzdGdiNllpc0tJYTZQdWxvNW1ab0p6ZkNMdzZUekhQ?=
 =?utf-8?B?eW5ickR3R1NwaTdwTGYwWHYxczBUQUc1R3NwQ1FDanhLeXlDcE54d0ViUmNN?=
 =?utf-8?B?NjhYZ2N6UmtUbmZvSXBIMFBteStHMVZqZW1Db2NGajB6THVyYUlHUkVGZXU0?=
 =?utf-8?B?aDRWdkxKRHplVVdEUUh4UXRscFBUWFM3aGR0VG9NOFYvbDRRdko0cjRUaWtU?=
 =?utf-8?B?WEFFVno4S1NTNjF3bVBPajBCdEZUckJVRjNWdUI5bjR6YTFCcTc4c0w4c3Qr?=
 =?utf-8?B?dHhzanNtRnBjWkpZSnV6SXpDeFBMWmFneGxVTXlDODhFNkZmRFMvZTJXd1kr?=
 =?utf-8?B?L203SkYvZjMvVWI4M0Q0aElhc2hrSjEzRXkzRUlmbjdrRml6bzZvaGNnQ3dw?=
 =?utf-8?B?QTFaeHlpZVk3ZXlmYUJ5bVMrSE9NOWVuc2h2WlVmdXlpZHdnOGswTkRJeUVl?=
 =?utf-8?B?OUZvRW1Gc2JVeFRoR0xaRjVwOUp1Z0Y3RHVtOFdJZWJQSlIwbTluZ1hwcXAw?=
 =?utf-8?B?cEFMUHpXQXZmT2dJSDNUYzBCWTB2eUdJRmgxZGtXNndmaGZsWlBZeld0eXcz?=
 =?utf-8?B?czNVcGNoVkVmTzVWNjFGUFdPdi9nN2FzOGF0MEtiZDlpa3dUdVhUbi9KaUxX?=
 =?utf-8?B?VVFhRC80d1hqS0dlNU1SMjVPMmdzb1JHL2k5T1BSWnlGN2RVZjA0aVZXVEJh?=
 =?utf-8?B?RmZaU2tZRElBTjkxTVhnVlkvZUJJWXpYNUJpOTYwSytyQVUxQ0pjdHB6MUti?=
 =?utf-8?B?REdWZmNPMWMrVVFBVjdjMnF2OTBQY080aFJmVWVvd1cwdjFwZ25QMjNic0Rm?=
 =?utf-8?B?QUx6R2kya3RheUU3ZE1qbGFDWVdhVVZnZWFDbnVzR21wbFNnOWR6cm56V2ZI?=
 =?utf-8?B?KzhhSVRiVU56Qk9HZC8wUWlKSEp1WHNqT1FUdFVsR2dQV0QwTXordktrMFVD?=
 =?utf-8?B?WVBrcjVKMDZtZG5mVUk1Yy9rSWlLNW5tSzFzWGV4bW41UEVDaTZIbndob250?=
 =?utf-8?B?aVp0dFM0RWcwc1B5L3YyM0hsKzVkRis5bWhOem1nTGNmbWdpSUQ1cXBLUk5X?=
 =?utf-8?B?aHU1eFdjSmpTRWNMS0x5SGY2ZE0rcHRUMlozMHUvZm5WbnkrTkZsa2FOY01F?=
 =?utf-8?B?Vk8xOE51UGZLL1dBL2t1S3lRRHRGVjFGdWFFZkRCQnp1N0wxOWF3b3Jzbm15?=
 =?utf-8?B?Z3JQanVKVHV1c0NoKzFUM0FrOFpzWEVTN1NwN2VRc3AxaDBXSFhncS9KWGJ2?=
 =?utf-8?B?azI1Q1A5VkNBV2dUUy95NS9XNENIU21LOXpPM3JkZU9RNjdJbWlvM0ZkYTR4?=
 =?utf-8?B?U0RpeTNaaStoV0pZY2Rqd2tNN0tDVWJaK3N2OXk2S093STY2UnBncjB2VzdL?=
 =?utf-8?B?RVJNTlJyZnFhWUphRmdQdHFMaGV4ZlQxYkZIUitXcWI3dmg2azVoajZoUDIy?=
 =?utf-8?B?YzBrUVBCeXQ1N3MrUW1CUy91ZURMU3dFcWtvU216bDZFYUhnTnJGWHVMK3Ex?=
 =?utf-8?B?aU1wd29JOEtEUXlDNnVjejRXRnVCMTVybHJyYURsTm1CZERIMTVhT1lXd3dJ?=
 =?utf-8?B?UWZEeG14RDc1YzgrTlEzL2wvNzV2NFVkbWQ3OHdQL21xZFdhczVUM09JdG02?=
 =?utf-8?B?MThxMXdHNEU3TFNTcmxadUdvYWhPTnNMdTJNMXdwZXE3TWZiWnF5cmk1ejBy?=
 =?utf-8?B?ZkFNNG9ma0MwMjRtWXNiMW1NSW9sdERmeE1sdnk5MkdPNStJQ0pyS1I0eC92?=
 =?utf-8?B?YlUxNXpPODE0bWExaitUWlVzVXlTY0phMm1mRFBPc1c4YzhPRHdqWjRkY3RH?=
 =?utf-8?Q?se2Su4JdA6Y=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S3F4Q1ZIU1Q4blZHaVBIMG5kRXY4VHZIbmpkTVoyYmJGWjJuS28vNVZFUlh3?=
 =?utf-8?B?UjFzU1hXOXFWN3ZwYzIvN1NZZFBEWG02S2Q0WGV5N0NRdEFWY3NzQkRPSUFK?=
 =?utf-8?B?anZ3U0tpMTN1T0x1bSt3eWRIMlNQWHZpNGR1ZVJNNzVjUTIwODZoZFhxYVVQ?=
 =?utf-8?B?QlVvWHNMYWgyZ015aURhSEFnaDhmQWp4U3pTYTBVN0ptSGI4eUVxbldaZmVP?=
 =?utf-8?B?dkJ3aVNNdEtGN0FXV3B2SnRRUkRlNVhEOHJxdk5UYmF2dFdFVEV6dDFGc3Rx?=
 =?utf-8?B?N0ZKamNHZzVjWDYzMFloVmxPdnRPTHBGQXpVUXFacVFJd3NSME92V2h1cE1W?=
 =?utf-8?B?WkFYRVJVQVFXamJjdUo4TjJReG8vWjhNMmphWTJYaGZHU2tNK3hxVURaSEZl?=
 =?utf-8?B?RnJGTHp2SURDSlBvdlVLTmhSeDZ3UTQzYUNad2kwVDVwZGdzK1pXaHplQ0pW?=
 =?utf-8?B?ZmwxcGN6T0FieHlKM0Y3Q3NacE5lMWxIWWR5Y1BSeVFYd01ZeG1HMkY0Wkx4?=
 =?utf-8?B?cTBjbk8yRjAxQXVVVGtVT1lVSnRoQTVod1RGQSs5Z1pRclFRRWlkQjJCbHVu?=
 =?utf-8?B?Q0FaRjZpL1ZJb2Y1RitvSGxWaDVra3c3Q2I3V3Bxb25TNXZGVWp2VDVENTkw?=
 =?utf-8?B?WTF5OXEvTWZ4SDdjcDZzRXZOTC9TeWIzRytMSW5nWGVOUFN3OGJqcDhuaDNM?=
 =?utf-8?B?Y294SDhzbXVvYjB0ejNTaktvTmJBaFV3UWVyQkxyVittVHZpemlyeHlqL0FN?=
 =?utf-8?B?ZHp6SENUNWZ5NEY4a3dPSXJqbU5wMFd0WVlReDFiVEFyaVJ1OG1BT3FzY3A2?=
 =?utf-8?B?M28wbFVmbmFYV0JYNUVTd3ArQlJjaG14WTFHNFpzTVgvemtmcHI2aWRwRllY?=
 =?utf-8?B?ZmVTK25KNTRRclNyNjFMT0RESDVkTjNmdS9BK1pIN2pLQW01d2hNS1VteWtU?=
 =?utf-8?B?NFhMdmVPZjRNTkEzQWw3bGJZbGJOdm16NHJvK0hJSk8wMGFBTUQ2NFBMa2c3?=
 =?utf-8?B?MXVIeEgvaGtFTitKbVlOaURoMi9UaWpLKzZEN0RBeXZ0cS9sWklEVjl5ajhC?=
 =?utf-8?B?RUxOOU5OUVRuT3Z6RUFvNUg4Z2xkOUxxUXFyK2laY0tmQ2pkZVVKcDZXWEJ1?=
 =?utf-8?B?R1pHYUQyZmdENnkvdWNZdUhvdzVYanNuSGhtNUFaRkx4UzZKa1cra2txRk02?=
 =?utf-8?B?amZtR3puZ0xDVENKNHpMZU9hTFNITml6TG9HOE9IaitVeTgxUHM5cEtoVVNv?=
 =?utf-8?B?aU1xSUZaU1k4R1lENTFCamsrRVVUMzM3RFB0WWxVdTU3S0d2czN4WENncjE0?=
 =?utf-8?B?b1p4TUNMWGhNV0NjR2R2KzRRYWw3V1B3dWxuZEkvamlUWGlhcjJnWk51NGk4?=
 =?utf-8?B?OERYMy80NkozZHo4S2JHVlN5SGRxd3UyVU5wZUNqT0FQVkpmaTA2cDdtaDd0?=
 =?utf-8?B?a0V5V3B2a0dSeXRpZG1mdlk4QnowclRPMWkzN1ovRUFNQUg0U0RJK3I3Y0N5?=
 =?utf-8?B?WVhyT2JvazYvSWt3MTBKdDJpQnNqWUloSytZVFE2STRMNnRrUTV5YnRaNEFt?=
 =?utf-8?B?bVN0S3dFSGZqYkVoLzk1ajYwdjJXMVVNL2JYVVRnd1dLQ01TeUJWajN0Z2dm?=
 =?utf-8?B?ZWNHQVA5NWM5TWVDVGdGd2tWSmRab0p6NDhYcDNCS3JsYll2TmtwUW5CUEJo?=
 =?utf-8?B?Wm5sQk4vV2ttQVI5SUtUNXJUSHNWdXdvZjNPSlBjaUZzRm9KeGp3Wk84RWRV?=
 =?utf-8?B?V0V5QzM3eUhXb2N6em41bzR0ZEllMjhFc1A5UklUQjY2eGlEbXpubStSM1Iv?=
 =?utf-8?B?M0tIVVNUcFFWVW5NcklDdnBPQ1huZXhRU25GcEVVWFJXWTdVZEg5NSsvVjln?=
 =?utf-8?B?VEwwQVA3cWRBclptSSt5TWNIRTlOZXpCNUdwVFQvdU1lSk1xTVgvYzQrYlJo?=
 =?utf-8?B?OERqc3dIUUlCSnlZMmdHc2dJb1NtdHV1M0ZSOUdHeU5xTWdLYUpSNTNvRE5Q?=
 =?utf-8?B?aHlRaDJFSlRLWHlNRUI1RGpuMy9lZ1RJUHNYK3JFaXAwUm8rN0hrQmV3RC9q?=
 =?utf-8?B?dld4Y2QwZ29TK0dRQTlwc01GOE9ldWI2eW55cEsvVEkzckNsUzNKT1MrMmFN?=
 =?utf-8?B?Ti9uVjBVeFN4bk5kSHQ0OCtEZU9ad1lYaEkrVHNyY2NhYmtjeWluMjhwTzZV?=
 =?utf-8?Q?3c129E9+gaTOF6YLi32SB98=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A63586BBE14F1A4CAEBA6DBDB627504E@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 55645a84-f7ab-43ff-b1b6-08ddd1361d7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2025 20:00:50.9375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kaw/QCEgZ0tNzYiOP2vhygF8D+jHVFIPtWojecOqonLTK1+DoKu3c/QOK/Yfkejr222Pb6YAx0bBMgfy+twVag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4661
X-Authority-Analysis: v=2.4 cv=ZNPXmW7b c=1 sm=1 tr=0 ts=688d1cf5 cx=c_pps
 a=iHwpkFQr6pXPqst9nAN4sQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=P-IC7800AAAA:8 a=NEAV23lmAAAA:8 a=4u6H09k7AAAA:8
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=XUjlmsByKzLI2h3yXWwA:9 a=PRpDppDLrCsA:10
 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22 a=5yerskEF2kbSkDMynNst:22
X-Proofpoint-ORIG-GUID: otUJZClu7bVaMRWPC6vSzYctkNiIRC_4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDE1NyBTYWx0ZWRfX5c87QczfqcVy
 qijjZssb23jW8ouumEeqgrtm914KOR+Fnza3wzDVWSvFwhQ28rwc7POFOg9KPO5m6Q4VCXxGqCG
 iTYLC5nBvcFqfm6ZAKJs/FOYNIkQ8Ks0giZTi7T/LaG9bQmSmGO5F81NoKeZegbWWnnDiDzmwkr
 lhdGPyG2Kg3bUOhi3zT5rtr+g3tnMeJ1aYIJtZRgJZhBs3ZijfmVVX4gseDyS8nZyA8++ZThuyJ
 GREJQL8HqDNwKGil6qGWdqQWIa7OePt3qBUhDLhPGPV+69fRjXOg0AL61CpSyb2ySh5OS5iwuPX
 fQThvEtSGFIIfwUw94Wrya5reORHBTvft2OMnzObOLUnlx7bKIXmC3wgiEeW7p7lHSurM6VWD4u
 +nc/GJgFVuMT6OtWbCxM+N7BI1JSExR7OzxY7QNFzJeEaHfPT0dabVNylp8A+kmjMxDM5yt6
X-Proofpoint-GUID: FNe1UsP-lMbiVFQ05RzyUxlTFYfurSgc
Subject: RE: [PATCH] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_06,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508010157

T24gRnJpLCAyMDI1LTA4LTAxIGF0IDIyOjU5ICswNTMwLCBLb3RyZXNoIEhpcmVtYXRoIFJhdmlz
aGFua2FyIHdyb3RlOg0KPiANCj4gSGksDQo+IA0KPiAxLiBJIHdpbGwgbW9kaWZ5IHRoZSBjb21t
aXQgbWVzc2FnZSB0byBjbGVhcmx5IGV4cGxhaW4gdGhlIGlzc3VlIGluIHRoZSBuZXh0IHJldmlz
aW9uLg0KPiAyLiBUaGUgbWF4aW11bSBwb3NzaWJsZSBsZW5ndGjCoGZvciB0aGUgZnNuYW1lIGlz
IG5vdCBkZWZpbmVkIGluIG1kcyBzaWRlLiBJIGRpZG4ndCBmaW5kIGFueSByZXN0cmljdGlvbiBp
bXBvc2VkIG9uIHRoZSBsZW5ndGguIFNvIHdlIG5lZWQgdG8gbGl2ZSB3aXRoIGl0Lg0KDQpXZSBo
YXZlIHR3byBjb25zdGFudHMgaW4gTGludXgga2VybmVsIFsxXToNCg0KI2RlZmluZSBOQU1FX01B
WCAgICAgICAgIDI1NQkvKiAjIGNoYXJzIGluIGEgZmlsZSBuYW1lICovDQojZGVmaW5lIFBBVEhf
TUFYICAgICAgICA0MDk2CS8qICMgY2hhcnMgaW4gYSBwYXRoIG5hbWUgaW5jbHVkaW5nIG51bCAq
Lw0KDQpJIGRvbid0IHRoaW5rIHRoYXQgZnNuYW1lIGNhbiBiZSBiaWdnZXIgdGhhbiBQQVRIX01B
WC4NCg0KPiAzLiBJIHdpbGwgZml4IHVwIGRvdXRjIGluIHRoZSBuZXh0IHJldmlzaW9uLg0KPiA0
LiBUaGUgZnNfbmFtZSBpcyBwYXJ0IG9mIHRoZSBtZHNtYXAgaW4gdGhlIHNlcnZlciBzaWRlIFsx
XS4gVGhlIGtlcm5lbCBjbGllbnQgZGVjb2RlcyBvbmx5IG5lY2Vzc2FyeSBmaWVsZHMgZnJvbSB0
aGUgbWRzbWFwIHNlbnQgYnkgdGhlIHNlcnZlci4gVW50aWwgbm93LCB0aGUgZnNfbmFtZQ0KPiDC
oCDCoCB3YXMgbm90IGJlaW5nIGRlY29kZWQsIGFzIHBhcnQgb2YgdGhpcyBmaXgsIGl0J3MgcmVx
dWlyZWQgYW5kIGJlaW5nIGRlY29kZWQuDQo+IA0KDQpDb3JyZWN0IG1lIGlmIEkgYW0gd3Jvbmcu
IEkgY2FuIGNyZWF0ZSBhIENlcGggY2x1c3RlciB3aXRoIHNldmVyYWwgTURTIHNlcnZlcnMuDQpJ
biB0aGlzIGNsdXN0ZXIsIEkgY2FuIGNyZWF0ZSBtdWx0aXBsZSBmaWxlIHN5c3RlbSB2b2x1bWVz
LiBBbmQgZXZlcnkgZmlsZQ0Kc3lzdGVtIHZvbHVtZSB3aWxsIGhhdmUgc29tZSBuYW1lIChmc19u
YW1lKS4gU28sIGlmIHdlIHN0b3JlIGZzX25hbWUgaW50bw0KbWRzbWFwLCB0aGVuIHdoaWNoIG5h
bWUgZG8gd2UgaW1wbHkgaGVyZT8gRG8gd2UgaW1wbHkgY2x1c3RlciBuYW1lIGFzIGZzX25hbWUg
b3INCm5hbWUgb2YgcGFydGljdWxhciBmaWxlIHN5c3RlbSB2b2x1bWU/DQoNClRoYW5rcywNClNs
YXZhLg0KDQo+IMKgDQo+IA0KDQpbMV0NCmh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4
L3Y2LjE2L3NvdXJjZS9pbmNsdWRlL3VhcGkvbGludXgvbGltaXRzLmgjTDEyDQoNCj4gWzFdwqBo
dHRwczovL2dpdGh1Yi5jb20vY2VwaC9jZXBoL2Jsb2IvbWFpbi9zcmMvbWRzL01EU01hcC5oI0w1
OTYNCj4gDQo+IE9uIFR1ZSwgSnVsIDI5LCAyMDI1IGF0IDExOjU34oCvUE0gVmlhY2hlc2xhdiBE
dWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyNS0w
Ny0yOSBhdCAyMjozMiArMDUzMCwga2hpcmVtYXRAcmVkaGF0LmNvbSB3cm90ZToNCj4gPiA+IEZy
b206IEtvdHJlc2ggSFIgPGtoaXJlbWF0QHJlZGhhdC5jb20+DQo+ID4gPiANCj4gPiA+IFRoZSBt
ZHMgYXV0aCBjYXBzIGNoZWNrIHNob3VsZCBhbHNvIHZhbGlkYXRlIHRoZQ0KPiA+ID4gZnNuYW1l
IGFsb25nIHdpdGggdGhlIGFzc29jaWF0ZWQgY2Fwcy4gTm90IGRvaW5nDQo+ID4gPiBzbyB3b3Vs
ZCByZXN1bHQgaW4gYXBwbHlpbmcgdGhlIG1kcyBhdXRoIGNhcHMgb2YNCj4gPiA+IG9uZSBmcyBv
biB0byB0aGUgb3RoZXIgZnMgaW4gYSBtdWx0aWZzIGNlcGggY2x1c3Rlci4NCj4gPiA+IFRoZSBw
YXRjaCBmaXhlcyB0aGUgc2FtZS4NCj4gPiA+IA0KPiA+ID4gU3RlcHMgdG8gUmVwcm9kdWNlIChv
biB2c3RhcnQgY2x1c3Rlcik6DQo+ID4gPiAxLiBDcmVhdGUgdHdvIGZpbGUgc3lzdGVtcyBpbiBh
IGNsdXN0ZXIsIHNheSAnYScgYW5kICdiJw0KPiA+ID4gMi4gY2VwaCBmcyBhdXRob3JpemUgYSBj
bGllbnQudXNyIC8gcg0KPiA+ID4gMy4gY2VwaCBmcyBhdXRob3JpemUgYiBjbGllbnQudXNyIC8g
cncNCj4gPiA+IDQuIGNlcGggYXV0aCBnZXQgY2xpZW50LnVzciA+PiAuL2tleXJpbmcNCj4gPiA+
IDUuIHN1ZG8gYmluL21vdW50LmNlcGggdXNyQC5hPS8gL2ttbnRfYV91c3IvDQo+ID4gPiA2LiB0
b3VjaCAva21udF9hX3Vzci9maWxlMSAoU0hPVUxEIE5PVCBCRSBBTExPV0VEKQ0KPiA+ID4gNy4g
c3VkbyBiaW4vbW91bnQuY2VwaCBhZG1pbkAuYT0vIC9rbW50X2FfYWRtaW4NCj4gPiA+IDguIGVj
aG8gImRhdGEiID4gL2ttbnRfYV9hZG1pbi9hZG1pbl9maWxlMQ0KPiA+ID4gOS4gcm0gLWYgL2tt
bnRfYV91c3IvYWRtaW5fZmlsZTEgKFNIT1VMRCBOT1QgQkUgQUxMT1dFRCkNCj4gPiA+IA0KPiA+
IA0KPiA+IEkgdGhpbmsgd2UgYXJlIG1pc3NpbmcgdG8gZXhwbGFpbiBoZXJlIHdoaWNoIHByb2Js
ZW0gb3INCj4gPiBzeW1wdG9tcyB3aWxsIHNlZSB0aGUgdXNlciB0aGF0IGhhcyB0aGlzIGlzc3Vl
LiBJIGFzc3VtZSB0aGF0DQo+ID4gdGhpcyB3aWxsIGJlIHNlZW4gYXMgdGhlIGlzc3VlIHJlcHJv
ZHVjdGlvbjoNCj4gPiANCj4gPiBXaXRoIGNsaWVudF8zIHdoaWNoIGhhcyBvbmx5IDEgZmlsZXN5
c3RlbSBpbiBjYXBzIGlzIHdvcmtpbmcgYXMgZXhwZWN0ZWQNCj4gPiBta2RpciAvbW50L2NsaWVu
dF8zL3Rlc3RfMw0KPiA+IG1rZGlyOiBjYW5ub3QgY3JlYXRlIGRpcmVjdG9yeSDigJgvbW50L2Ns
aWVudF8zL3Rlc3RfM+KAmTogUGVybWlzc2lvbiBkZW5pZWQNCj4gPiANCj4gPiBBbSBJIGNvcnJl
Y3QgaGVyZT8NCj4gPiANCj4gPiA+IFVSTDogaHR0cHM6Ly90cmFja2VyLmNlcGguY29tL2lzc3Vl
cy83MjE2N8KgIA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogS290cmVzaCBIUiA8a2hpcmVtYXRAcmVk
aGF0LmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gwqAgZnMvY2VwaC9tZHNfY2xpZW50LmMgfCAxMCAr
KysrKysrKysrDQo+ID4gPiDCoCBmcy9jZXBoL21kc21hcC5jwqAgwqAgwqB8IDExICsrKysrKysr
KystDQo+ID4gPiDCoCBmcy9jZXBoL21kc21hcC5owqAgwqAgwqB8wqAgMSArDQo+ID4gPiDCoCAz
IGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiA+IA0K
PiA+ID4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvbWRzX2NsaWVudC5jIGIvZnMvY2VwaC9tZHNfY2xp
ZW50LmMNCj4gPiA+IGluZGV4IDllZWQ2ZDczYTUwOC4uYmE5MWYzMzYwZmY2IDEwMDY0NA0KPiA+
ID4gLS0tIGEvZnMvY2VwaC9tZHNfY2xpZW50LmMNCj4gPiA+ICsrKyBiL2ZzL2NlcGgvbWRzX2Ns
aWVudC5jDQo+ID4gPiBAQCAtNTY0MCwxMSArNTY0MCwyMSBAQCBzdGF0aWMgaW50IGNlcGhfbWRz
X2F1dGhfbWF0Y2goc3RydWN0IGNlcGhfbWRzX2NsaWVudCAqbWRzYywNCj4gPiA+IMKgIMKgIMKg
IMKgdTMyIGNhbGxlcl91aWQgPSBmcm9tX2t1aWQoJmluaXRfdXNlcl9ucywgY3JlZC0+ZnN1aWQp
Ow0KPiA+ID4gwqAgwqAgwqAgwqB1MzIgY2FsbGVyX2dpZCA9IGZyb21fa2dpZCgmaW5pdF91c2Vy
X25zLCBjcmVkLT5mc2dpZCk7DQo+ID4gPiDCoCDCoCDCoCDCoHN0cnVjdCBjZXBoX2NsaWVudCAq
Y2wgPSBtZHNjLT5mc2MtPmNsaWVudDsNCj4gPiA+ICvCoCDCoCDCoGNvbnN0IGNoYXIgKmZzX25h
bWUgPSBtZHNjLT5tZHNtYXAtPmZzX25hbWU7DQo+ID4gPiDCoCDCoCDCoCDCoGNvbnN0IGNoYXIg
KnNwYXRoID0gbWRzYy0+ZnNjLT5tb3VudF9vcHRpb25zLT5zZXJ2ZXJfcGF0aDsNCj4gPiA+IMKg
IMKgIMKgIMKgYm9vbCBnaWRfbWF0Y2hlZCA9IGZhbHNlOw0KPiA+ID4gwqAgwqAgwqAgwqB1MzIg
Z2lkLCB0bGVuLCBsZW47DQo+ID4gPiDCoCDCoCDCoCDCoGludCBpLCBqOw0KPiA+ID4gwqAgDQo+
ID4gPiArwqAgwqAgwqBpZiAoYXV0aC0+bWF0Y2guZnNfbmFtZSAmJiBzdHJjbXAoYXV0aC0+bWF0
Y2guZnNfbmFtZSwgZnNfbmFtZSkpIHsNCj4gPiANCj4gPiBTaG91bGQgd2UgY29uc2lkZXIgdG8g
dXNlIHN0cm5jbXAoKSBoZXJlPw0KPiA+IFdlIHNob3VsZCBoYXZlIHRoZSBsaW1pdGF0aW9uIG9m
IG1heGltdW0gcG9zc2libGUgbmFtZSBsZW5ndGguDQo+ID4gDQo+ID4gPiArwqAgwqAgwqAgwqAg
wqAgwqAgwqBkb3V0YyhjbCwgImZzbmFtZSBjaGVjayBmYWlsZWQgZnNfbmFtZT0lc8KgIG1hdGNo
LmZzX25hbWU9JXNcbiIsDQo+ID4gPiArwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBmc19u
YW1lLCBhdXRoLT5tYXRjaC5mc19uYW1lKTsNCj4gPiA+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoHJl
dHVybiAwOw0KPiA+ID4gK8KgIMKgIMKgfSBlbHNlIHsNCj4gPiA+ICvCoCDCoCDCoCDCoCDCoCDC
oCDCoGRvdXRjKGNsLCAiZnNuYW1lIGNoZWNrIHBhc3NlZCBmc19uYW1lPSVzwqAgbWF0Y2guZnNf
bmFtZT0lc1xuIiwNCj4gPiA+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGZzX25hbWUs
IGF1dGgtPm1hdGNoLmZzX25hbWUpOw0KPiA+IA0KPiA+IEkgYXNzdW1lIHRoYXQgd2UgY291bGQg
Y2FsbCB0aGUgZG91dGMgd2l0aCBhdXRoLT5tYXRjaC5mc19uYW1lID09IE5VTEwuIFNvLCBJIGFt
DQo+ID4gZXhwZWN0aW5nIHRvIGhhdmUgYSBjcmFzaCBoZXJlLg0KPiA+IA0KPiA+ID4gK8KgIMKg
IMKgfQ0KPiA+ID4gKw0KPiA+ID4gwqAgwqAgwqAgwqBkb3V0YyhjbCwgIm1hdGNoLnVpZCAlbGxk
XG4iLCBhdXRoLT5tYXRjaC51aWQpOw0KPiA+ID4gwqAgwqAgwqAgwqBpZiAoYXV0aC0+bWF0Y2gu
dWlkICE9IE1EU19BVVRIX1VJRF9BTlkpIHsNCj4gPiA+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
aWYgKGF1dGgtPm1hdGNoLnVpZCAhPSBjYWxsZXJfdWlkKQ0KPiA+ID4gZGlmZiAtLWdpdCBhL2Zz
L2NlcGgvbWRzbWFwLmMgYi9mcy9jZXBoL21kc21hcC5jDQo+ID4gPiBpbmRleCA4MTA5YWJhNjZl
MDIuLmYxNDMxYmEwYjMzZSAxMDA2NDQNCj4gPiA+IC0tLSBhL2ZzL2NlcGgvbWRzbWFwLmMNCj4g
PiA+ICsrKyBiL2ZzL2NlcGgvbWRzbWFwLmMNCj4gPiA+IEBAIC0zNTYsNyArMzU2LDE1IEBAIHN0
cnVjdCBjZXBoX21kc21hcCAqY2VwaF9tZHNtYXBfZGVjb2RlKHN0cnVjdCBjZXBoX21kc19jbGll
bnQgKm1kc2MsIHZvaWQgKipwLA0KPiA+ID4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBlbmFi
bGVkICovDQo+ID4gPiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNlcGhfZGVjb2RlXzhfc2FmZShw
LCBlbmQsIG0tPm1fZW5hYmxlZCwgYmFkX2V4dCk7DQo+ID4gPiDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC8qIGZzX25hbWUgKi8NCj4gPiA+IC3CoCDCoCDCoCDCoCDCoCDCoCDCoGNlcGhfZGVjb2Rl
X3NraXBfc3RyaW5nKHAsIGVuZCwgYmFkX2V4dCk7DQo+ID4gPiArwqAgwqAgwqAgwqAgwqAgwqAg
wqBtLT5mc19uYW1lID0gY2VwaF9leHRyYWN0X2VuY29kZWRfc3RyaW5nKHAsIGVuZCwgTlVMTCwg
R0ZQX05PRlMpOw0KPiA+ID4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKElTX0VSUihtLT5mc19u
YW1lKSkgew0KPiA+ID4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZXJyID0gUFRS
X0VSUihtLT5mc19uYW1lKTsNCj4gPiA+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oG0tPmZzX25hbWUgPSBOVUxMOw0KPiA+ID4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgaWYgKGVyciA9PSAtRU5PTUVNKQ0KPiA+ID4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgZ290byBvdXRfZXJyOw0KPiA+ID4gK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgZWxzZQ0KPiA+ID4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgZ290byBiYWQ7DQo+ID4gPiArwqAgwqAgwqAgwqAgwqAgwqAgwqB9DQo+
ID4gPiDCoCDCoCDCoCDCoH0NCj4gPiA+IMKgIMKgIMKgIMKgLyogZGFtYWdlZCAqLw0KPiA+ID4g
wqAgwqAgwqAgwqBpZiAobWRzbWFwX2V2ID49IDkpIHsNCj4gPiA+IEBAIC00MTgsNiArNDI2LDcg
QEAgdm9pZCBjZXBoX21kc21hcF9kZXN0cm95KHN0cnVjdCBjZXBoX21kc21hcCAqbSkNCj4gPiA+
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKga2ZyZWUobS0+bV9pbmZvKTsNCj4gPiA+IMKgIMKgIMKg
IMKgfQ0KPiA+ID4gwqAgwqAgwqAgwqBrZnJlZShtLT5tX2RhdGFfcGdfcG9vbHMpOw0KPiA+ID4g
K8KgIMKgIMKga2ZyZWUobS0+ZnNfbmFtZSk7DQo+ID4gPiDCoCDCoCDCoCDCoGtmcmVlKG0pOw0K
PiA+ID4gwqAgfQ0KPiA+ID4gwqAgDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9tZHNtYXAu
aCBiL2ZzL2NlcGgvbWRzbWFwLmgNCj4gPiA+IGluZGV4IDFmMjE3MWRkMDFiZi4uYWNiMGEyYTM2
MjdhIDEwMDY0NA0KPiA+ID4gLS0tIGEvZnMvY2VwaC9tZHNtYXAuaA0KPiA+ID4gKysrIGIvZnMv
Y2VwaC9tZHNtYXAuaA0KPiA+ID4gQEAgLTQ1LDYgKzQ1LDcgQEAgc3RydWN0IGNlcGhfbWRzbWFw
IHsNCj4gPiA+IMKgIMKgIMKgIMKgYm9vbCBtX2VuYWJsZWQ7DQo+ID4gPiDCoCDCoCDCoCDCoGJv
b2wgbV9kYW1hZ2VkOw0KPiA+ID4gwqAgwqAgwqAgwqBpbnQgbV9udW1fbGFnZ3k7DQo+ID4gPiAr
wqAgwqAgwqBjaGFyICpmc19uYW1lOw0KPiA+IA0KPiA+IFRoZSBjZXBoX21kc21hcCBzdHJ1Y3R1
cmUgZGVzY3JpYmVzIHNlcnZlcnMgaW4gdGhlIG1kcyBjbHVzdGVyIFsxXS4NCj4gPiBTZW1hbnRp
Y2FsbHksIEkgZG9uJ3Qgc2VlIGFueSByZWxhdGlvbiBvZiBmc19uYW1lIHdpdGggdGhpcyBzdHJ1
Y3R1cmUuDQo+ID4gQXMgYSByZXN1bHQsIEkgZG9uJ3Qgc2VlIHRoZSBwb2ludCB0byBrZWVwIHRo
aXMgcG9pbnRlciBpbiB0aGlzIHN0cnVjdHVyZS4NCj4gPiBXaHkgdGhlIGZzX25hbWUgaGFzIGJl
ZW4gcGxhY2VkIGluIHRoaXMgc3RydWN0dXJlPw0KPiA+IA0KPiA+IFRoYW5rcywNCj4gPiBTbGF2
YS4NCj4gPiANCj4gPiA+IMKgIH07DQo+ID4gPiDCoCANCj4gPiA+IMKgIHN0YXRpYyBpbmxpbmUg
c3RydWN0IGNlcGhfZW50aXR5X2FkZHIgKg0KPiA+IA0KPiA+IFsxXSBodHRwczovL2VsaXhpci5i
b290bGluLmNvbS9saW51eC92Ni4xNi9zb3VyY2UvZnMvY2VwaC9tZHNtYXAuaCNMMTENCj4gPiAN
Cg==

