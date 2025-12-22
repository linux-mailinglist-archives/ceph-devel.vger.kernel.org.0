Return-Path: <ceph-devel+bounces-4216-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B252BCD70A3
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Dec 2025 21:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF7C83013EFD
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Dec 2025 20:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8341E327C09;
	Mon, 22 Dec 2025 20:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="giXSpwEy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACE12C029D
	for <ceph-devel@vger.kernel.org>; Mon, 22 Dec 2025 20:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766434091; cv=fail; b=WYXYV0rv8VLLMv6+Z5niGTkUJEJ8U1xrfeYLFAuqJLL26Q7nsxYBU/C5ELov/GqaZdmoNB18aEuwPPvrGMFc4tFg+po+f2qpvy+46Shoc2rH9qKpBR1rWMdueBuW0jQK7RmeCyuvXQYhBxYBa+aOATonFrqmYNNnjoT/zkocjtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766434091; c=relaxed/simple;
	bh=mlCctf9bjuh8kpEuABoXXBsIMxVh5vprwQ86W0dz4CI=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=b97gdrM+N6f4nqotXH3wAio2L3bmdIJMLFQbPtpwvcddPYic2jbuWQG8uh8BwK2cMORN0ZL5g1/C299gvWesgD3B0Ne0PzmMoBFwpJNs8jP55bFqkDAyK/dnOxyFpu2kkfOk1kwNO1JApTcv906CuorCxF7T5oGua61JwEy7nC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=giXSpwEy; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMClGrd002030
	for <ceph-devel@vger.kernel.org>; Mon, 22 Dec 2025 20:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=WLNZ+Idhgq76UjZIi9wGtjub0KXWsj6ksU/ebWVwcnw=; b=giXSpwEy
	FIwQd7EVtuJ8ajJ62j7ccpmUHCak5Gqs/dLLBwU3ESgBraujR6N8YokYMIEyPjqP
	lgI3qSRzvHPvN0T9U0nh4Pgb8Vpp/i26v/igW4G1kdXPiBG5A2NlliOEk5gW1YDW
	KYF89MBGraO0okaDoUauDmtXBlG2Cuz9Xctk97rtaUHzrWte7cLnlRFe8jlF3x8f
	UzURAjknHF7ZKz+LH1SZe8DHj3a6+vWyVPEBtiKMGwMQN+uJt5MlfXMBQSyL6iby
	hlGhx4uNajsvfd18TG/ZnsiTwupRHsW5gvUsA7G3qmQDHjXdnk1QZklqDhtp5iAL
	0QsD+Y/9Ptbpgg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kh49w45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Mon, 22 Dec 2025 20:08:07 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BMK2vnC007767
	for <ceph-devel@vger.kernel.org>; Mon, 22 Dec 2025 20:08:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kh49w41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:08:07 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BMK3QZu008241;
	Mon, 22 Dec 2025 20:08:06 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kh49w3x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:08:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cn3eWgTyz1EKc+8bAqOgUDN317Hmkm0KMpzBMTK1grGmcDTc4V3ORD7RK7tXl1CbVfxpazCEUfji2jt53LZQ9uJS7yPMN3Fy9Ng6KIyITU7HQbdYKTTkzGR6hqcXgos7pvuKHMXrXRFXtZilT0zpRtMGAnqB7FQ0Lc7LRNZnxFH9nLYrBLIRdNvB5mYFt1HIUQ8WK7NmiNuKMZ4+S1qLRMk8+dHQaHOS3f4VJ4LnTVRejz+fcY565cZ1BQA0vquLQqUTbBt5UU+7TRAs4Q9j0v/cQ5Tk7u/pe2Q1j3j08dqndHKNGe7NwCB3gFfrL98g5/ofy/Fv0XDN1etElb6AxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHMJsXmSCFKllOtOZXhUMtP1z+lANrOGX1SHf2ePhHs=;
 b=dUwAzL8zX2AH9JRP2k3BkE15G99ZFLqT1GM5Rbo3m4f/vuzDQImaURmeLnsuv40UW/n+l36qOubmiTwrzhK6F4IB2C2H2n1vlJr2viR5KG6Qi9swHovEB407m2aUeezkqsngxPfn1zCfiE55B99n74EsVO0Dcj1ke9O2WsufWSQSNf+QIcy5Jc8lWIH6j78298wTbjNMjseT/SHvspdQ0G9cIgtNDt/MT1l0M6j75tpq3fPzA2XeT/MNLapoR8hZRsmzrxVR870A0ayBOBQFNsQQSEriK+luvm+9rbIj9mEVmXJfBmskWu+0G483AkY3L5Y+/azAplRtydKyA/BaHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by MW4PR15MB5159.namprd15.prod.outlook.com (2603:10b6:303:186::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Mon, 22 Dec
 2025 20:08:03 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9434.001; Mon, 22 Dec 2025
 20:08:03 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "daniel@chaospixel.com" <daniel@chaospixel.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
CC: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] [PATCH] fs/ceph: Fix kernel oops due invalid pointer
 for kfree() in parse_longname()
Thread-Index: AQHccbqrzI7Nz9eVWkOv1xDwXBLt6bUuGeQA
Date: Mon, 22 Dec 2025 20:08:03 +0000
Message-ID: <62924ea8997fb174034e6333db3a52b2f30f0e68.camel@ibm.com>
References: <20251220140153.1523907-1-daniel@chaospixel.com>
In-Reply-To: <20251220140153.1523907-1-daniel@chaospixel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|MW4PR15MB5159:EE_
x-ms-office365-filtering-correlation-id: 22e7e043-3248-49ea-562b-08de4195d03b
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?T1pVcm50bTV4ekowNGlXSitIY0NYMzB2UnNLbWg4UnZJdmhjY2hDSXJHY0dh?=
 =?utf-8?B?WEpFSlREVWZrSzBRNTdVQXZxSE43YlB3NUhGUVp3RWhGNUY5WEozWksrbTJN?=
 =?utf-8?B?MTU0VmFWMU5FNlRNcEEyWjg5Wll6aUl5bTNUQTUxd1NaN1lKL3ZMUkppa3Nh?=
 =?utf-8?B?eGVIdkRSRDYra3hXaU9JQXI0U0tGWTlCOEd0Y2pxVnBvTlNROFNuT0g4U3BM?=
 =?utf-8?B?aG43c291QldJVUlENkc2VGJUOXYyM2RoZ09lUWdibjU1L1RtZDNML1J0eUNs?=
 =?utf-8?B?SFFzUENta2hmNGhLMmgxYmtKeXlGT0szR3NXMnYwYmk5NVl3WTlCbEl4eExB?=
 =?utf-8?B?aVcwM0pHMGVjY3lFbHNncVlPUUNuVlo1WGlodG53eTMvdnJ3RE1lM09UYlV2?=
 =?utf-8?B?VTMxWGcweFRWT2p6TXF5SDEvb3ZHVmxJWnNIS0JBNDhYb3pWVUE4TEhmV1A0?=
 =?utf-8?B?RWFwcXRMRzhXRFJCQ3ZDekNueWQyZ29CVDBJSmR2V3dnZERHUmQra29zQ3Jm?=
 =?utf-8?B?SnJ5UlAxdjhLU1JVdTRTQUhRM0JMWEk2b0lrS0xiOG1MTnNQeVF6YW9vS1VR?=
 =?utf-8?B?M1h2eWZ4Z3IrWkh0eTgwR3l5b2ltYVc5SW01dHJnRVNBY2grMGs3NFJ1b1dz?=
 =?utf-8?B?ZFo0elBjSUR1M1dUQ0krQXNsS1ZGTUlVTmhIWWRpNE9OQWhOTTNEOC9KVWc3?=
 =?utf-8?B?eXd4QW1wOExvWmxPNnVKYm9NN3k4WkJRUkZKTExoZXVSK01uczV4NlNhckor?=
 =?utf-8?B?V1Iyeitqc3IwTHB1QzNYYkFxNHFVbENsYitabk9ORDJLL1E3ZFJ3ejJoRDBZ?=
 =?utf-8?B?c0ZLVm9UVmQ2VUczTkc1VmcwZHNhcDVmbHgvQS9tNERoaVc1VFpxRFBIbHhY?=
 =?utf-8?B?Q3ZVRE5XRXNyOUVWTjQzSHdZd3ZwbDlsd0tLNGZZbUIxMTVjaWMrbnQrS0lY?=
 =?utf-8?B?NUsrbGJiaE5KVGZ1eXlqMTV3TWt0dVlBZ1JZU2JVUUVDNHRzT1FKNnlVR2NI?=
 =?utf-8?B?YWRpdlJPRjJiVW5zSDFHNkowcUFVam0rd3NoRmM1Znlla1htRGxnWTRVcitX?=
 =?utf-8?B?OEp5ZzRkMHQzWHErMktTcnUwSnVkS2pUVVJFaHB0ak9Fb3Q2aDVtMy84MXZB?=
 =?utf-8?B?ZDJsRVBDbjNpNlMxeWVUWmtEYndTUGdpS1lySC9TeFhodVZpZE1xMmlTcjBB?=
 =?utf-8?B?Q2xjdlhqQVlPSmhSOHpHSUh2ZG9NdWp5REZKa2xXbkdINHI4Y2sxa2trcEN3?=
 =?utf-8?B?V0FCeVZRVHFVeTZ6aXFOTjVkdWFneTNaTFVvSVpab1ZUQkcvd3lXVTI4blk4?=
 =?utf-8?B?TU9aZVA5R2FWWUh6WDhVS1VGeW5aV29CSVN4TG1sZDhRR3JMZHNxT1Uxdmt5?=
 =?utf-8?B?K1hNbEYreXp0bldFTkx3NjJKTWx6YXdod0xIWXBPOStaRW93d2NUclVlVC95?=
 =?utf-8?B?ckN2OHJLSmdvYkdPaVd6NUkxZVE2bW83OUxJSzNhWkxPZW54ZHJLQ2ZocWpL?=
 =?utf-8?B?bm9va0Y2THBXWW1jd3J6Rnp0cWlYK3Zkc1d0Wk9mYnY1M0doZEszU0EwK3Qx?=
 =?utf-8?B?ZFZaT1NwNmhBbjBvNmtVck1VQUxod0YreS9WRFdlTkdpVDBWVVRwMFl1MGRR?=
 =?utf-8?B?U29sdi9Ib3h4TlZsaFFCRFU3RHlVVmdNVy9zVVhjVGROSm54NStVL0ZIUEU5?=
 =?utf-8?B?QUNFQlJUc1RlVzlKNC9GMGtidEJPWktPcm5hTDZlL2srU29ZS0h1TmJwNFBj?=
 =?utf-8?B?cFpaOUplV0tnVDNCeDFvU3JRWmUzN3hHZUtUYjdxRGFUL0Uyb2xjYnVsYjZK?=
 =?utf-8?B?YzhSWkZyekZjQjhzZXlFRXlBM1pTSU05eXJQMk9IVVdPd3hzakFBRXZ5VzJY?=
 =?utf-8?B?dGU0VWFtTFZlUWZiNjRTNy9jMGZsQUZFbkNLV1l3SVRaNUU1a0RvRDdPYzhw?=
 =?utf-8?Q?9dYy4FV3HKwx5QpR9J5KLcxHuiibxKaS?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NCtqQk9IcVdKY2NpclpXd2h4Qnp5aC8yU21jZXRJeldXcjBxdVU2RG5vaC9z?=
 =?utf-8?B?OFM2d0w5WDN1UkplZ2huMWtVR0VyZ1gyTkliVU9RUEVHaUtzaUtMWnY2cENN?=
 =?utf-8?B?WjVhWVJuSC9SNFVGcnBmemI1T0I3bVBZUWtlUU1wVmpRcGY2TE84NmlDSkdB?=
 =?utf-8?B?cmcvMXVtQWc2R2l1THpOQTEwMTFXOEp2STFDblQ3aDFPV0pabkNscDNYMDVo?=
 =?utf-8?B?ckc0SDFseXhUV2NaeS9EZWRRMEo2MVU4ZUlpR0JXNTQxcFVIZzdqUlZJMStT?=
 =?utf-8?B?VlhuK2tmbnMxQkNzbG1WVmkvZ1VzOXhYc1dQeFhXMHRYWEZ3b0drTURKWG9n?=
 =?utf-8?B?TlA1NU9oVjdqZVREaHA5VGMxMGowME5nVmFkZ0tGM0tod2pkZ2hlSFB0Z2pj?=
 =?utf-8?B?SU9lR1hvcXc0SVBsREpxdmxIQ2NtdlRpbThjd3YwcEMxTGtjN2trbTZ2S2c0?=
 =?utf-8?B?ZXNHNTByM0FKTEJLMitLcERSUDRZYkp1YUMzTytTbGZBbmlYc01XT3BnNEp4?=
 =?utf-8?B?dHE1TEY5UlZhZUV3MTVhdDh3c0d1dll5MkxMOFRtQkNJRzFKWlZCZ25PZ1B0?=
 =?utf-8?B?ZWlKVXNrempQVDdqUkxjZHBsUjd6OG02UzVrbHpPdlI4UStIbzhKSU9oYVFC?=
 =?utf-8?B?WXBqbmdoRkNneGdrQ2EvMldYU01CYVU2MkFNbk5qZnpGdzRmRTBzZldTbWhj?=
 =?utf-8?B?NndRWVdyUFJBSEJmT1NwbVY1OVEzaVZoWEd3MnNvdTV5U1ZQcUNxaVVneXc2?=
 =?utf-8?B?aUI5YmlnZ1Jxd3BrYmRJWEZJL3FIVUVXREt1TGFRYTI2UnQvTDFtSGhFeGor?=
 =?utf-8?B?QlJCVWVwQmJjaVlnU21hMjYvdzB4NGJsZFRoT0lnYnlsUTJsMTBlaVpDVlBV?=
 =?utf-8?B?NmlSMXBGK01WZC9oU2YyUWxISk96Z1Q3WWNwT0tDMzBRVmhaUTV6V0FaMTJ4?=
 =?utf-8?B?UmtZY0hHeVJsT3QxYkJYc0R4c3dZZ2FSZ1N6ajJJYWt1WU5VaVVNdEtmb0FS?=
 =?utf-8?B?VG1MeVhTYWJKVWJDOHpMQW1jRm15ZkV5L1FLUGdqU1Q5SDUzRFFMcnVmdHVo?=
 =?utf-8?B?SUNSc1pPMS9uMnUxTmFqTnpvRloxTVdleGtaTnJXdm1XZzUyd2RMTTE1MHBS?=
 =?utf-8?B?bkFJUlExYnh5Wm9uV3E5T3E2NjJOOVlSbk9IbVh3NE0vVG1UZzU0MG5FUWc2?=
 =?utf-8?B?VzRJM2VHUjZ3ZnlWczVZVGJmaTRoU05CUWtMMU1TbWtZS01sNm1rY0dwdDhk?=
 =?utf-8?B?czNkR0FEK0txeGZ6UzRRMG9Sd1NLN1p5eldGMk45bzhqWkFJK0dtVFA0QUs1?=
 =?utf-8?B?eElHVThvNlNvd2lTUldHNjdDdlBCaVJVZ3FiR3l0OGM3K0pvZ3Azc1lydVJM?=
 =?utf-8?B?MHFoNVZtK0Z2U3B5N2xoRjU2aFZoNWF6ZjR0dzdUNWNidS9tODVjUUI2d2Zv?=
 =?utf-8?B?ZG01LzVxUFVQR2dGRGNHWXlUaDE1MkhPU3kyTHpBK3dZZjNyUU9LRnd6eXNT?=
 =?utf-8?B?S29OWFpTL2VUbkdCem5Ma2ZNbTJqQ2dDMmhIc3NVdm9QeTVYQ1d0a0pyVE0x?=
 =?utf-8?B?TjI5cVRzMXpaR3NybnR0bGtxMUFjUW1tZzhVdEVaM1N4SSs2SWhJbFpNMzAy?=
 =?utf-8?B?SmtvbHhtUU13YmZNVjJOeHJ0R0JDZzk0L0piOXp5OElGSHNrblY0aTU5RVow?=
 =?utf-8?B?Y3dKTjEvdnVqS2pIWUdBbUJqMEhYeGJNRDloNGVIS09mY3hxRlpDRC9YWndO?=
 =?utf-8?B?VTlnSmJwU1BFRHJxenJ3WjQ0cHR3YkxFNnZCNi91c0I1ZUtnRWJHbDVBaXE3?=
 =?utf-8?B?M0hjVTd5dEJxTXo4amExa1pzdEQ0VHI5OTlKOWRBWFF1NTRtVXVVTTFlUTVn?=
 =?utf-8?B?dkEzMk1NNTJHSHQwV0ZHY25NYXBpSmhsUC9PUGpUNXN2ZFUzOE42MkI0a1h2?=
 =?utf-8?B?d2xEeCt1OVFQM0Ivc1orSFlHQXVJZG1YMTFiMDkxSUhMTERuYzFJOEozWGVW?=
 =?utf-8?B?RGE0TWxjZHdibzFuSkhXOHJrTTU0ekhmenNNTGhMdCtGU0tDeFdJNURwZ2dn?=
 =?utf-8?B?ZG1ZVTV5c1ExVCtyaGNBVkxWdnJYNDVTRFNJODY2WTU3YzVJT2NpMWUwTzNq?=
 =?utf-8?B?UEc5c0FHc1IxKzV0M1pEaGY1emp6NUo1dVc2MnJ3SjBic1FBOTlQYVAzSlB6?=
 =?utf-8?B?SDFQank3MUFwSjJBTnBGWjNEVmlrWWsxYXNpT0w4L09Td25lUEcybGJrelRM?=
 =?utf-8?B?S0pJR2czMEJGWnBiQlAzb0FBa0xTNUR1aFN1MUhVeExrK0tnTFJEaDRGYXNY?=
 =?utf-8?B?SW5mWnFPUnBxa0twaUxrdU8yTVd3UnFKNmNSRE5FRGpLQUJVV21sOUFWNCtJ?=
 =?utf-8?Q?nHHB+bL/TRCQnHavVSyDOY83poDQ4JjGQlaz3?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e7e043-3248-49ea-562b-08de4195d03b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2025 20:08:03.2207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BLVHBD4DVmHUIjlQiKpDW8Lj7ixXRhVIpDUxxWUouboUbuSPOpIVCDvC+S7yxd8b0zVVi1Cuv1tMSzppUGYG4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB5159
X-Proofpoint-ORIG-GUID: 8nxZCiKlCVvqOSnY04PR-jhZzt_4gBAE
X-Authority-Analysis: v=2.4 cv=bulBxUai c=1 sm=1 tr=0 ts=6949a527 cx=c_pps
 a=3NFNipLq04N0pvkhkOyhzw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=4u6H09k7AAAA:8
 a=Zv-iYU-hAAAA:8 a=9xkvoRjyvAr2xsQkfgsA:9 a=QEXdDO2ut3YA:10
 a=5yerskEF2kbSkDMynNst:22 a=7POGK4OykCGyYpN2cFti:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE4MiBTYWx0ZWRfX2c2V2y9W3dpL
 S45bAWti7jwkR+Em/74kbjxKEo8LS8dHaEDKytIdkMHcT+0LB9uFMBPKClMTZ3mYSG8am+9YRvI
 wiVBgUZSny50/WysUph+vlz1dtRyU06V4/g0//1lgoTsTbuXOfCDALugSE9nd+9r/w9/1eM/0s+
 qheRwbUSo/hvB9T13i6MI+TJDKTu6fHMowbLCtw/wFEbCawcl4vtugv++IC7jg3hycMmy6aOyNj
 FFhNtm4z8qQlIqcmvM4q2W7BAVIaZkMroZNDHk6L4G5hLMC1W3brjt0LR2oVFlHB/6J8pdl1io/
 rMyIKLgujNW2i2ca3ZlGsMUe4EeVgyGheJ8hr4UCgXL3micc8Kp/zZEweLveUxZwjFogVUlDg3M
 te3RYtpRUCHTH31sIaTZiyfip7kZR83uBE7Ul4s2HgC9UMIbcmo8CW1iQONhYlG7RlNGcoh1tI+
 7ZFJbK4CMF8fwXsU2gg==
X-Proofpoint-GUID: pM18E3ZCF5FX29gPHlcKUzsPkBUcm2oS
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DED40F069F11D45AA6540E649368567@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH] fs/ceph: Fix kernel oops due invalid pointer for kfree()
 in parse_longname()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_03,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=2 engine=8.19.0-2512120000
 definitions=main-2512220182

On Sat, 2025-12-20 at 15:01 +0100, Daniel Vogelbacher wrote:
> This fixes a kernel oops when reading ceph snapshot directories (.snap),
> for example by simply run `ls /mnt/my_ceph/.snap`.
>=20

Frankly speaking, it's completely not clear how this kernel oops can happen.
Could you please explain in more details how it can happen and what is the
nature of the issue? How the issue can be reproduced?

> The bug was introduced in commit:
>=20
> bb80f7618832 - parse_longname(): strrchr() expects NUL-terminated string
>=20
> str is guarded by __free(kfree), but advanced later for skipping
> the initial '_' in snapshot names.
> This patch removes the need for advancing the pointer so kfree()
> could do proper memory cleanup.
>=20

I cannot follow of this explanation. What is the wrong? Why should we fix
something here?

> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D220807=20
>=20

Why the issue had not been reported to CephFS community through email or by
means of=C2=A0https://tracker.ceph.com?=20

Have you run xfstests for your patch?

> =20
> Fixes: bb80f7618832 - parse_longname(): strrchr() expects NUL-terminated =
string
>=20
> Cc: stable@vger.kernel.org
> Suggested-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Daniel Vogelbacher <daniel@chaospixel.com>
> ---
>  fs/ceph/crypto.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index 0ea4db650f85..3e051972e49d 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -166,12 +166,12 @@ static struct inode *parse_longname(const struct in=
ode *parent,
>  	struct ceph_vino vino =3D { .snap =3D CEPH_NOSNAP };
>  	char *name_end, *inode_number;
>  	int ret =3D -EIO;
> -	/* NUL-terminate */
> -	char *str __free(kfree) =3D kmemdup_nul(name, *name_len, GFP_KERNEL);
> +	if (*name_len <=3D 1)

I believe that even if we have *name_len <=3D 1, then current logic can man=
age it.
Why do we need this fix? The commit message sounds really unclear for my ta=
ste.
Could you prove that we really need this fix?

Thanks,
Slava.

> +		return ERR_PTR(-EIO);
> +	/* Skip initial '_' and NUL-terminate */
> +	char *str __free(kfree) =3D kmemdup_nul(name + 1, *name_len - 1, GFP_KE=
RNEL);
>  	if (!str)
>  		return ERR_PTR(-ENOMEM);
> -	/* Skip initial '_' */
> -	str++;
>  	name_end =3D strrchr(str, '_');
>  	if (!name_end) {
>  		doutc(cl, "failed to parse long snapshot name: %s\n", str);

