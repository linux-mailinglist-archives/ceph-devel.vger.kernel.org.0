Return-Path: <ceph-devel+bounces-3402-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D7EB215D0
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 21:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C1716242A0
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 19:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ADC32D878B;
	Mon, 11 Aug 2025 19:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lkmBdI+I"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970AC2D876C
	for <ceph-devel@vger.kernel.org>; Mon, 11 Aug 2025 19:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754941443; cv=fail; b=myq9ur67H8Qh4cybreAtV+faDQYB9+VJID5vcFf97+3F6hWUVFtVJCyiz05lLXx6+UqSkgWwO82/zg/plBJwFOUkmMXDEhuGJiNp3WGiN3AzA9o91Rz3vA7y3je9qM2SA0oAK/8yRDuhi6k8qLBbZMrpn85mtY/al26dgPXDyG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754941443; c=relaxed/simple;
	bh=1r8YMMdc0CqjAucm6S3n9gI2OdHdvlJMZiGWnSbnC74=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=svq3AP7a67UzQsKQPqbEi/7LQMiLXr7k+42TZiDadhsdde4Ji2MDUteekXOJAHAJPtPIxrJd33vtS9h20jYoWanyH7ts5wt+Ffh3VR/itmf5dwT2OS7Buwkzd3dd/ytyJ5fRJYB1/C+jf+gaSwjlT5t+/ih5uQeAg9e3a2igjsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lkmBdI+I; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BEs8mD027703
	for <ceph-devel@vger.kernel.org>; Mon, 11 Aug 2025 19:44:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=wkrF69HME0zm2g2VrRD6jgJOuq1HZ12VuVA2PF+Uc+M=; b=lkmBdI+I
	aGHBif3+qEKPO34v4dRSZxgOXzmHWL7/azR5MsC6lSPt+H/VFRt1Bqrsd6Pi+gcw
	nWYuBIyebHMw9J3nQWRUtE+ijvuxqmlmMvOSRJEpxqVJllzOb8W/scoZaJ0ygKia
	YL9W7cPiIPS5fVgMzDUGXlbBfPQ1AWgtX0h0G1xRcm/yZdm0w/7MIFWjCF+fcmqn
	42IXeY/D10a1aWa3nkzOZMLhsLFA0ytjGBnVqK5El9OiALqM0UaZInsVxc2HJHux
	ScCvL4uaRG0gW9PSxmk6jFc3P/DvP4EqqwjQaX1cN7tlVGe6vU6RbGe88re6ylMS
	oikKwCvTqkzgKA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duru32g4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Mon, 11 Aug 2025 19:44:00 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57BJUPK1028143
	for <ceph-devel@vger.kernel.org>; Mon, 11 Aug 2025 19:44:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duru32g1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 19:43:59 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57BJhwbA022536;
	Mon, 11 Aug 2025 19:43:58 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2041.outbound.protection.outlook.com [40.107.96.41])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duru32fw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 19:43:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o19YlDgYS/b6rR4XVxJaxucIctBTjo+O3k9xZAIWeIjj9l4OX/pd4uDetjz2tQgP7tTtrWvhq1nVCBlDTyuaZ6DmVWMrBhpTYhOExMnnSLevdNrpLWcgoQ511z6nxxlEfjVHLqI8Hj2CwZPFImZ/iX0J5bt43/UTmOHv3pcoym5yTe6nxK27y5C6/56rhEci1JKdbtKQ02uQtuxp/B9H3MGv2pRxf1cM0Xlp14ig4uON7MhPG1nE91GopVCtx7eoggRjSJPtUkkn/kOp1zUUM52awp0FV/RZy62rdiAz39RVA0UPtRkXiv1j82UF/82SXHUN3xhQy0cmdJ/Dg8Nv6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RC92n66BF8L+F25Fx68LL+lu19arYRw/Hs0kBKcJoNI=;
 b=ZV8nGriQrp39JrZ7Eaz1UYUSECIIlSngG/R9EtGZ3ZiPsmrj6Bwdvc50cBxZb5dmZ43JxxPCWGC/TjjHsrDjIOwlmb+ici81Tv1B13l3eMmqiJjjcTMkQjf8r+eTsAdE5XZBybkqnlN3uTPh20Pb0NeVi0SyDNxYTvRUIE8LuO4eBg5DF0ZRrSrdX7JV7GN5zqd3S1qb4N3RnmbSLeTnjfSsqRLqn6znDKqKJwmo4THftCwmQ9enwg5r3dEQgq4TgkMv3kHK7hXiQSZS5ZvySa8Mr40ttVW+eN4MuyhVJriLFg8klOef3YMHoMRd2A0db4yLfG19yzcNYHbuCWvbXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4598.namprd15.prod.outlook.com (2603:10b6:a03:37b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 19:43:56 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 19:43:56 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "sunzhao03@kuaishou.com"
	<sunzhao03@kuaishou.com>,
        Xiubo Li <xiubli@redhat.com>,
        "idryomov@gmail.com"
	<idryomov@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v2] ceph: fix deadlock in
 ceph_readdir_prepopulate
Thread-Index: AQHcCDY3O4dps1Ayok+9KdnqXTKeqrRd4B6A
Date: Mon, 11 Aug 2025 19:43:56 +0000
Message-ID: <1d51b68168de62cc852fc147fb5e2dc8fbd9373d.camel@ibm.com>
References: <20250808070819.18878-1-sunzhao03@kuaishou.com>
In-Reply-To: <20250808070819.18878-1-sunzhao03@kuaishou.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4598:EE_
x-ms-office365-filtering-correlation-id: ef87261e-ff3b-4232-0b49-08ddd90f68c0
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TENVR3ZPQmlyUGVIcFYvRzUxZm1wYmhLRk9nRm9xb3Z2cmdyV2xhYUtxYTN6?=
 =?utf-8?B?OGNWS2hoUjhpTHladnVRWWorZGFyRWtrREUzN2FxOWN2aVIvRlFwZTJENE1O?=
 =?utf-8?B?Rmg5cERjeWNhVm5JME5XU2xONWtkNE5uWWo1eWZEMndzdU40WStCUEVFc2Vy?=
 =?utf-8?B?dkdxWmU4VTlyc3VrZGl1TUJsWFROTmFjRWl2QWRNc0FzM043Umg5QWNza0Nj?=
 =?utf-8?B?V0YzTTY3VFREQ2wwZlJhUzZEdzZIcStkRHhhVXh4L0hYTEx2Qkx0d1pxQlFJ?=
 =?utf-8?B?akVkOGZLeVBWSGR4NWM1VWFzK0R4ZWVVNjM4R1ZRMzlqUXF3dUlzZnlUWFlQ?=
 =?utf-8?B?cmVnVlhPa29tQkpWcmZYM2FucmdSeiszUTFodC9hczM5THlibTFNNDgyejZD?=
 =?utf-8?B?UG1oaWI5YWJQZzd2NlNWMTlTUGVvWmFHckdEcFp4dGJSN0Urd0pzQ2NMTWFW?=
 =?utf-8?B?S2d3Um1oSWhjclZuUDdlSjl0WGhsbHdTVzRWZUx2RUpLSTZacW9EdWlGam1Q?=
 =?utf-8?B?NHR3T2Y2cFgxcHdZMlJEMnZWZURFTy9vQjYvL3A2WDJqVk9RMGMxOXBqcm1u?=
 =?utf-8?B?bHB4aEEyTXVqNGIyVGFxZk5pdWNFZWROblI3ejYvY2t2RFRNMmZJKzdtR3hz?=
 =?utf-8?B?bVNBMWNIMjcwWUFMeE9DVWExOUgxc0lrZ2NvajA2eXF6NE1JbHJ0bzNQTm9W?=
 =?utf-8?B?Y3o1ZVVmeXFGNEVuME9MOTIveDBxRENSVnp1UUdSbE5ISVRaSWZWa3hpdHla?=
 =?utf-8?B?dkNjd0ZUbjhSM1pKUVE5dUJxOFlDcFhGcDFpSzZvYzYwRWVTZzVxY3FqTFRh?=
 =?utf-8?B?Q09nQ2NSQ3dGWHRwTTQweHRqV05mZC9CSmlVSlFYRTJHNHJTdlBaL3dubjdp?=
 =?utf-8?B?Vk9YNmVFYklEMWVSdHFDNk1PZzZDL3hRZTdkUi9VR3lyaXljbmt5UWFlT0dP?=
 =?utf-8?B?VjUrT1lycmMvSDA4RXF1YVNHSS81RXlvZ2UxWW1QNXRVOERsSDloTTQ3WXYw?=
 =?utf-8?B?VGlwM3h1OFdBS0lpSDJlUnp2MkdQb29WREFOSWR5SmlQa2dIZk5IMkdMNnBs?=
 =?utf-8?B?ak1lQmpmWmpOY2ZIYUhNa1diaXNBeDZCNnpYRWxRYkNKMVd0b1RNUFJBTFcz?=
 =?utf-8?B?ZlAyNk5GZ2hneStyRlN1cnl3akZhYTJWamhUOXJBL1AwMFFOeHMyYTJLSWo1?=
 =?utf-8?B?QlVNR3ljRGxQbFZYOFRFMTU4OEdmellCYnMyYXc5YXE2aUVDN0NhWHRpTitk?=
 =?utf-8?B?b3hvemczU0FCVVR0Q0wwUyttYmp5V00yYVJjSExnM2JqZGJTZnJYZWxRNUVC?=
 =?utf-8?B?V2lZSjc5TUE2Smh3Ym9peVNBL0JjUEJEVHpwT09XU3Q0eFplQy80QktFbEg4?=
 =?utf-8?B?TVdldnpzUUhjTStQellFTnRvaEx1UFZvb2pvVy9hRjBnekVHdGVYRWJwd2Nj?=
 =?utf-8?B?ZFNpVkpoMEQ0Q1NadHRhaDFpS2I3MXovUmQwNERJem9rRityRGZKdjZINnUv?=
 =?utf-8?B?U2paQkY5cWhBQ3lxSjQ1VXd6K0U5WHQ3aEVwakNqdWVBWlRORnNXcmVraitL?=
 =?utf-8?B?T0xlcU1XVi9OdjJ1dWpBSmxmNHQ4OG9wTjhhY1BUeGJiM0daayszc2xRV29K?=
 =?utf-8?B?MzA1VEIrWlpSVlhMRlBBV1ZvUjcyb2s1N3FpdThOVEJkcUxrSm05Ykk3Q25s?=
 =?utf-8?B?NmFyTW9WdlpPTE1XZmZEZnh2M1lYR0Y2ODlId0YvTEdNN2hvQ2wyaDdGR1RZ?=
 =?utf-8?B?dEpZZStMTngrZ1MwV1lxWnA3aHpTS3ByWjNpRzlGdDVIdVBBdzczaTRiaUli?=
 =?utf-8?B?elhBY1ZVOFpQNzNINFJ1RHI2ZTZvSTh3UjFTQTZBYlhlTjFqRmZucnlpVlV1?=
 =?utf-8?B?bHBldCs1MXFnV2ErY3FTQnVQV3orYmV0cjlYMVZaRjV4VFFZZklIaEg2MjRP?=
 =?utf-8?Q?cOx1cxO/gjA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dkNtOWpPbndqSE1LRUtxdXh3RWpqb1FYOTFSQlI3aW8vV09JQ0lDOEgrS2t0?=
 =?utf-8?B?TzM1Y0NBejdoUHNiNWpwQk5LK2xHYk00NXJsK0pRaFZpblhZK0dPaHNhWk94?=
 =?utf-8?B?Wlk2MmtoRTFwTG9jYUhBdEpYb0kyZjdXUzFLN1d0cHlJMGlpalo0ZzNweTdY?=
 =?utf-8?B?ajZzcW5VL1VXR3JiQ3JoQkpRL09NU09aWHV1T0FIdjZldE9qdGV2dGxPclAz?=
 =?utf-8?B?aW1lUWJIVFkyeVJCMEdRV09PL2twZzNFODZSNHN3N2o4dUR4Vy9kQWVFc1hM?=
 =?utf-8?B?b0FFeWFVRkVkeTNCc3NOdnJaV2xlU0xJMXozaXp4d2dlV1RwQXV3WmpPTVYw?=
 =?utf-8?B?VFFRZXlOTnFOZ3FrQ2JLNit5WEtPeDJIZFkvbTJEeU9rN2ZxU1NzRWQvQi9s?=
 =?utf-8?B?REZrRzFIamlQdVRXLzR3c3kyN2g2Z0FUZmgza09FRFI2SzF0Qm9PNTdDMytK?=
 =?utf-8?B?cUZjcGRvdjREaVJUQ1FGNE52ZnZNTk1IZnM3eGNnY3RVT3lDeVZUYnpYNmMw?=
 =?utf-8?B?MFFScEJTYkFvU1RyMC8zcjBpVWpyenh2QzdHRG02WGE4cTNRam1Sc2tOV2Q5?=
 =?utf-8?B?NVFGWGZmaTlod3VZTXFUem1TY2xVZVl0cVRSb3Zab1h0NW9uUU1NSnc2WjQ0?=
 =?utf-8?B?bmoybWpKbnlXbHFYR3Zmd1orMmUzQk92bXlnVHgwSVQwMnRMTDFEeUt3Unox?=
 =?utf-8?B?Vk5FWEJxcHduQUlJVGx5SUZ3azllU1JjQVBJZitDVTB4TGM4TE93ZjlBTzZq?=
 =?utf-8?B?eTRKYzVtcFY5YVBtSmJUVmtZcnNwSklaaC9ucldQRlN3Ny9VRXI2WXMwSjdk?=
 =?utf-8?B?ak9nVW5uR2RvbThmaUxMK1RCUHN6bXpGSVRIMm1iV1VRM1ZZb0hkbmg5QVRl?=
 =?utf-8?B?Q1lLZGMxQ2FDVW5pT0M0VnBITG12VjV5eUhkaUdjVnViMXJqT0JuTU01WWdt?=
 =?utf-8?B?V3JtMmh4NytSSWx1dFNYNFh2dU03VDc1MDhpZkt2d1MzMFdQOGdNWUtXK09p?=
 =?utf-8?B?dFM4OU1NNlNCQVJKdXZjYUZNM3oxendEUDcxaVphSG9La1ZUL0xlcjZwQndK?=
 =?utf-8?B?dzVSeUpnY1oxRjArNWMzWTYva1VCYTVnVzBnUVdqS1ZjTWxaZjZsMHdrVHov?=
 =?utf-8?B?dkFFZkJNaWh1U0JsS1hKK2pocVhONFVHWW1scXJTbmsvbEtwcW9zdlZCdm5x?=
 =?utf-8?B?UTE2dklQOGpDYWVXSGJTZjdINnEySkFFWDBkaEdHdmMxZXVsanNKb1JUUVhh?=
 =?utf-8?B?TkNRc3BiczB3ZVRSYlBkYXZ5TEZHUzBpYXZSVWNSdlJxd2MvUWJ3TWFBcFgz?=
 =?utf-8?B?Q1dXbUNyOVpzdSttYWZNYmNiZTRiM05sMndNeTdTRXlUcVk0UGFUeHZIWElJ?=
 =?utf-8?B?R1A5QjZJM1ZZa0RlSXp0aFdRVmhkSFJsWFR4U0t0Y2M2Ri9qVUh6T2NyVERo?=
 =?utf-8?B?YXZpTlA2dXhSWXdwMzhVNzRCTHBDNXByc0JIdi9GUStoUklSd1VYc3VtOTFH?=
 =?utf-8?B?cDJVNHBUaXJDa2srSDZ2NGtOOWZvdk1Zc0FlMGRlNFJqRkZIeDUrRFBQOEIv?=
 =?utf-8?B?N2xBRnVPNmp5SDNRUzlKblJVQnM3dTVieGVoSFlXaytCRkhGakg5VnIxWHll?=
 =?utf-8?B?UnVCWVhGallienpCV0NtTis1UmdLSlRIbXBWcnNEb0VMU1NMT2ZuV1E2TnZP?=
 =?utf-8?B?RDU4b2psNHN3bzdYQTBGWjVnS1JPRFBmSTNuM2NheHY5TGkyMk5OMkM4Y1ph?=
 =?utf-8?B?cC80cVc2MlVDTFh0OGNRUEVnaDVObVZybVV5cmRpeFFDSEVDT0ZqV3RrRCtw?=
 =?utf-8?B?bittVUJNU0VYOVkzYlRaS1MxaEl4NlBlcVNUaTFiVlVOR1EraGsyb0RwQUJo?=
 =?utf-8?B?Rm5aRG45KzBsTFdKTjlDWkQ5RWVwN0hJYk5TbEZ3eHJQMFRDYjdqSzRMRlZ1?=
 =?utf-8?B?ZFdIVFI3ZnZMR3ZwMTBvUEJsMUw1S2lkcyttTnk1aVAzMWFwRXlPOU4zTyt6?=
 =?utf-8?B?eVRHZTRNQ2VXNTlMR3dIRm9nby9aUHU4Q3dhYVgxMS9KWDhGV2kzM1paK2JL?=
 =?utf-8?B?ZFhkOFpHQnZJWS9vUkErNklRQ3dmK0FwMEJLNHBudUxtNHJzMUZLTVJjeUgz?=
 =?utf-8?B?cDBBdEoyQ1J6NHdudFI4Y2EvZFVkNFUwMXFoYUUxdXNMQmtPaDNRL29tZ2xl?=
 =?utf-8?Q?4CBPWfiFh2uBFZ/cOhArpj4=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef87261e-ff3b-4232-0b49-08ddd90f68c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 19:43:56.1393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Q4xOoSU9AJaqMrc4FvxviQms+iaudfYGz7MpiAl18dcbur2P0WyWdmsDK2oIkltOCzN0CbXMh40k6Pk9zIf1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4598
X-Proofpoint-GUID: gBste16egNGgXrlq7qACd2KCyHJtXWnK
X-Proofpoint-ORIG-GUID: gZmO8sDYlUkCvm901J-JjbPPVk0ubxd1
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689a47ff cx=c_pps
 a=sowhjKjRqJSGm7WhxuffUw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=4u6H09k7AAAA:8 a=VnNdFuG1AAAA:8 a=8WozfntvheEWR_UFBHkA:9
 a=QEXdDO2ut3YA:10 a=5yerskEF2kbSkDMynNst:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDEyOSBTYWx0ZWRfXy/ndrzmYhNc+
 flsS9kPAPtzCRPEadLfJAUP7NwCvvrBqdJMywwJ+1YViHtjBPG4fuE6KHKe8f9V8kEALjNioFKW
 MK5ShZvauJxRJKhLIJK5f+jhmDoZGyzvhNN9n0wRF4PbWl5+j0YvR64a7SM+iSXJ6hL04jsOUjz
 9nvuEgV5CU65QLTssU6ooz90qMjtL/6ONz/9XQ9iQooaBoUqdICjd0uVn3u5dHNE/KnVfrDikOX
 Da4WgOjjDq53RCMUeK4oQdU4NvAkXyggUZxytVoQ4LSGvLCwibwH3iAetCBF/mzrldk0mu8Qfs7
 FJvCpj5pCz7FqC9j9ZgF4mg81hELduGLRdILYDJ1nlRUZ1AfPesud1LQbEPNt5DdcfyC+T8sRMX
 sXCx+HV5lvv72oUZ2ZTXzP6WOaRGSRyh5bWoNn9e6+hbejRyCne/YSCk2wDtK8v9phqYv43u
Content-Type: text/plain; charset="utf-8"
Content-ID: <B02C24BB9DA7EC46ABBBC6C12A918084@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH v2] ceph: fix deadlock in ceph_readdir_prepopulate
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_04,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1011
 mlxlogscore=999 bulkscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=2
 engine=8.19.0-2507300000 definitions=main-2508110129

On Fri, 2025-08-08 at 15:08 +0800, Zhao Sun wrote:
> A deadlock can occur when ceph_get_inode is called outside of locks:
>=20
> 1) handle_reply calls ceph_get_inode, gets a new inode with I_NEW,
>    and blocks on mdsc->snap_rwsem for write.
>=20

Frankly speaking, it's hard to follow to your logic. Which particular mdsc-
>snap_rwsem lock do you mean in handle_reply()?

> 2) At the same time, ceph_readdir_prepopulate calls ceph_get_inode
>    for the same inode while holding mdsc->snap_rwsem for read,
>    and blocks on I_NEW.
>=20

The same here. Which particular mdsc->snap_rwsem lock do you mean in
ceph_readdir_prepopulate()?

> This causes an ABBA deadlock between mdsc->snap_rwsem and the I_NEW bit.
>=20
> The issue was introduced by commit bca9fc14c70f
> ("ceph: when filling trace, call ceph_get_inode outside of mutexes")
> which attempted to avoid a deadlock involving ceph_check_caps.
>=20
> That concern is now obsolete since commit 6a92b08fdad2
> ("ceph: don't take s_mutex or snap_rwsem in ceph_check_caps")
> which made ceph_check_caps fully lock-free.
>=20
> This patch primarily reverts bca9fc14c70f to resolve the new deadlock,
> with a few minor adjustments to fit the current codebase.
>=20

I assume that you hit the issue. I believe it will be good to have the
explanation which use-case/workload trigger the issue and which symptoms do=
 you
see (system log's content, for example).

Thanks,
Slava.

> Link: https://tracker.ceph.com/issues/72307 =20
> Signed-off-by: Zhao Sun <sunzhao03@kuaishou.com>
> ---
>  fs/ceph/inode.c      | 26 ++++++++++++++++++++++----
>  fs/ceph/mds_client.c | 29 -----------------------------
>  2 files changed, 22 insertions(+), 33 deletions(-)
>=20
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 06cd2963e41e..d0f0035ee117 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1623,10 +1623,28 @@ int ceph_fill_trace(struct super_block *sb, struc=
t ceph_mds_request *req)
>  	}
> =20
>  	if (rinfo->head->is_target) {
> -		/* Should be filled in by handle_reply */
> -		BUG_ON(!req->r_target_inode);
> +		in =3D xchg(&req->r_new_inode, NULL);
> +		tvino.ino =3D le64_to_cpu(rinfo->targeti.in->ino);
> +		tvino.snap =3D le64_to_cpu(rinfo->targeti.in->snapid);
> +
> +		/*
> +		 * If we ended up opening an existing inode, discard
> +		 * r_new_inode
> +		 */
> +		if (req->r_op =3D=3D CEPH_MDS_OP_CREATE &&
> +		    !req->r_reply_info.has_create_ino) {
> +			/* This should never happen on an async create */
> +			WARN_ON_ONCE(req->r_deleg_ino);
> +			iput(in);
> +			in =3D NULL;
> +		}
> +
> +		in =3D ceph_get_inode(mdsc->fsc->sb, tvino, in);
> +		if (IS_ERR(in)) {
> +			err =3D PTR_ERR(in);
> +			goto done;
> +		}
> =20
> -		in =3D req->r_target_inode;
>  		err =3D ceph_fill_inode(in, req->r_locked_page, &rinfo->targeti,
>  				NULL, session,
>  				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
> @@ -1636,13 +1654,13 @@ int ceph_fill_trace(struct super_block *sb, struc=
t ceph_mds_request *req)
>  		if (err < 0) {
>  			pr_err_client(cl, "badness %p %llx.%llx\n", in,
>  				      ceph_vinop(in));
> -			req->r_target_inode =3D NULL;
>  			if (in->i_state & I_NEW)
>  				discard_new_inode(in);
>  			else
>  				iput(in);
>  			goto done;
>  		}
> +		req->r_target_inode =3D in;
>  		if (in->i_state & I_NEW)
>  			unlock_new_inode(in);
>  	}
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 230e0c3f341f..8b70f2b96f46 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3874,36 +3874,7 @@ static void handle_reply(struct ceph_mds_session *=
session, struct ceph_msg *msg)
>  				       session->s_con.peer_features);
>  	mutex_unlock(&mdsc->mutex);
> =20
> -	/* Must find target inode outside of mutexes to avoid deadlocks */
>  	rinfo =3D &req->r_reply_info;
> -	if ((err >=3D 0) && rinfo->head->is_target) {
> -		struct inode *in =3D xchg(&req->r_new_inode, NULL);
> -		struct ceph_vino tvino =3D {
> -			.ino  =3D le64_to_cpu(rinfo->targeti.in->ino),
> -			.snap =3D le64_to_cpu(rinfo->targeti.in->snapid)
> -		};
> -
> -		/*
> -		 * If we ended up opening an existing inode, discard
> -		 * r_new_inode
> -		 */
> -		if (req->r_op =3D=3D CEPH_MDS_OP_CREATE &&
> -		    !req->r_reply_info.has_create_ino) {
> -			/* This should never happen on an async create */
> -			WARN_ON_ONCE(req->r_deleg_ino);
> -			iput(in);
> -			in =3D NULL;
> -		}
> -
> -		in =3D ceph_get_inode(mdsc->fsc->sb, tvino, in);
> -		if (IS_ERR(in)) {
> -			err =3D PTR_ERR(in);
> -			mutex_lock(&session->s_mutex);
> -			goto out_err;
> -		}
> -		req->r_target_inode =3D in;
> -	}
> -
>  	mutex_lock(&session->s_mutex);
>  	if (err < 0) {
>  		pr_err_client(cl, "got corrupt reply mds%d(tid:%lld)\n",

