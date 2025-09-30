Return-Path: <ceph-devel+bounces-3767-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80340BAE562
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Sep 2025 20:44:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CA72324A8B
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Sep 2025 18:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4221B24EAB1;
	Tue, 30 Sep 2025 18:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hYoPRPvI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D6C269CF1
	for <ceph-devel@vger.kernel.org>; Tue, 30 Sep 2025 18:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759257869; cv=fail; b=rjYZgBLy2wQJyiSn2HAsWxbZrsEUEr76XwitXsAjsvX1VUPIcbU4MARWDvJ7da+GViAu7c+fWuv6HRSRWzKfoMpfQcr69Vd38QHw8+iWeHrXrrYYLhsx/il2ZzQwirvuSGwiwHC1catCe/iM5JNY7MJMTSeJwGimoQ/dcEA49Fk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759257869; c=relaxed/simple;
	bh=iS5iuif5mUeGPDjHmZFwa/WhhsriomOy5FVSvoaQti0=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=TiK59uLZ7lIVPjLmAKyf2P/1rRZbpy5ZQdEhTAIIpt4pUILBVQftwE83FN3HApjNt0Xbs9NlXaKCYbTFOXRtQZ8CgEliXZECD/4PBQnfKyNGnCZa+JJN+xP3eedLJk7ZXbicpinzxGNeaubXd4EkQPe3UrmjeNou1dPxZFndP+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hYoPRPvI; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UC8qpI015793;
	Tue, 30 Sep 2025 18:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=iS5iuif5mUeGPDjHmZFwa/WhhsriomOy5FVSvoaQti0=; b=hYoPRPvI
	aHLCs/e9dJ1Z+sorFv1lqIVzPiVdBLAyZoj6O43fdtPRLsuHERjq1fKAZ+9yPbNr
	hbzcmGAwaoNEaTMmUmNiOlBl449LMzOweXR2IqQX6qSAq9Yif8nw1226UgJpkYRq
	WyZArqQg0klH0+yXo3ZGZnBC/HeagpkKiRT3zYl4J2OaOAjvYc5Wwj3v8pG/NZ0o
	3o5i33D3VLPtgyO3hhCvaaxtRGe6DmCJyZDOb076vaRCACOTN7k1XRgUqdOuCwHn
	T2BK42xBOOlCfvld/sQJUnOEuE8RhKMmHAZUyiGs1dIQL4fNiHOHVPWITJ2cvRjd
	FrrmspvAyUR/nQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e5bqtq1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 18:44:19 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58UIgKqE008490;
	Tue, 30 Sep 2025 18:44:19 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012052.outbound.protection.outlook.com [52.101.53.52])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e5bqtq1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 18:44:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dwtz+DQOCJtEHvhfdpGnnPSPK1TUYkCyqb/RG6ZnksTgRTrBtJpMfDBZwAIctztxPZwdmMm2fCtmzaDycDNDznNbq3jxCmJEDWKF8Bnf5KOH/mFNm8kTwEpjhf9JNYcQbM838+/c5Z9KP7X+3/twZ+4IiGSKGfjQI9NJH0LeW6yo+NIE9kjf4WntJP8Fws91kOejY8eXj4kX8zgtKqkqUjG7YZQKn4c4fkdHwxOOIphdgFuGkmQB74y39YeIk2GWETYehgeU6HcPPLsxAcc6DTOB+sjBtmtFeox+pp18uuWvCKg8e4fXBg9gJsJg1zr7ELsOnH0JQkBe2MyUcn4p/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iS5iuif5mUeGPDjHmZFwa/WhhsriomOy5FVSvoaQti0=;
 b=LPXqvLW+NKjwtMONXXPlJ5WL9DGlKSfsYMD9nMVQN2KOYFPWSF+zwI8XGxEbx+IYOX6qsd/ohDoDH2L9wvgnkJ8hCcqQHMY+N0TKHDQ+pD7heBH4aQTzg3rUSpmwh5Wzd7pX4s8bOk9n1WNgjHWvsaOHmxLq5SX7G7I3tvQLRSS87WhsjRwz7zpCMugWFbHMPkANNyt982ieAC3H2gCnUpTZOzJ0WwMFiqMAqnczMhzQqhLu6Gm0Iz06QwMrxW8zrMd+Vl5GkmA0xd7vGNiua1a/1OdIpUSfuN+QBZ/35T2OtHfWpy+wpGOEBdN0VCWOMS782OpryUc2B/plnJ/nfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by IA1PR15MB5535.namprd15.prod.outlook.com (2603:10b6:208:418::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 18:44:16 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Tue, 30 Sep 2025
 18:44:16 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethanwu@synology.com" <ethanwu@synology.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "ethan198912@gmail.com"
	<ethan198912@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH 2/2] ceph: fix snapshot context missing in
 ceph_uninline_data
Thread-Index: AQHcMdwlXbwCI2FZRk6YgpGCYjPEOrSsELiA
Date: Tue, 30 Sep 2025 18:44:16 +0000
Message-ID: <ec7440fbf1411b76a1a56e3511e4463716614cf2.camel@ibm.com>
References: <20250925104228.95018-1-ethanwu@synology.com>
	 <20250925104228.95018-3-ethanwu@synology.com>
	 <b7d93760bc06a4ca6b27f9043cb8310898cf48a4.camel@ibm.com>
	 <a16d910c-4838-475f-a5b1-a47323ece137@Mail>
In-Reply-To: <a16d910c-4838-475f-a5b1-a47323ece137@Mail>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|IA1PR15MB5535:EE_
x-ms-office365-filtering-correlation-id: cf14544f-3383-4376-da50-08de00515b8c
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SHhmRTRxclRzdTFwMUZXTjdhWEdsak9wU3JrNzVqSnhWM1V2K01VVUw5eXN6?=
 =?utf-8?B?K09zWmhpZGppc2h3UDBzd3hHUGk2Z3NlT25RbW1ZSHliL28zU3Mwek9FMFJQ?=
 =?utf-8?B?NnFNOHBFaGJmekJkSklaanNYU2pxb1NqUkZrNFE3OUhQL2c0WFE4allPQlFl?=
 =?utf-8?B?UVc4SFliRFZLQXVKc0JVWTZUanYzSkRzbysvVmpBbkFmeGpwbW8yZXNUK1dF?=
 =?utf-8?B?cDFzNzJyUEZVRXlEbHhOMitZaTNJTzA5Vk9jOWhnSUpzNUNoYnVWSlNhTnhE?=
 =?utf-8?B?M2ZNTVYyU3B0QnA1TUMvR0E1ZFBWUGU5RERRQVZXV29nTEtsVDM3OEM1N1Nn?=
 =?utf-8?B?dDZRNk9scGJ2RUk3eDNMUzNVSjhyQ3NURThOWm9TRVpRZW01bmVEVnZDRXlz?=
 =?utf-8?B?eEFVaFkyUmExYWtMU2xXbi9ycE1oY3NxdEFWbU5lSi9ubXIxRFlST2R3QVNN?=
 =?utf-8?B?MHdYWFJjTU9CQjdjcXQxcmsxRWxEZldTY0c1dGpsYnlyRU45T3ZQaVg3WXEz?=
 =?utf-8?B?eElHVVRJUUZCeG9NU0xvVmc0UTVyZzFWWDBsVHFGY1B1U1hRdHV5S2lBWjdw?=
 =?utf-8?B?NVZRa3A5NFJXSXloMUkrRk00NS9JUldtMTZkR0xlbDNvYnU5VllYRllYV3dQ?=
 =?utf-8?B?SEQ5Q0tFbVhtQkZaaXR2cW43bnR0ODEwSkFUc0M5UWloRG5vcHlZaTYvU1BK?=
 =?utf-8?B?MExDTnR2OURiczh6NHBXMy9SQUxPN3pGOS9MNG02NE9RSkxzQTFUSWp1RURr?=
 =?utf-8?B?aWRqL1A4dTJzaW1SL3MzMUl2Z1hVQnQvQm1lN1lNQlFwZjI1QWxtZkpadkFh?=
 =?utf-8?B?NTRvSGpTamRQeDkvU205REtuZlN2eWpWYVFseFZ5c1NCUnQwZE1NTXNzVUcw?=
 =?utf-8?B?L2NvRUNsZFhrY2pDcjVLSEtQWkNlSjJ2WUlrOHNRSkl4U3g0UDFIU3dDVmdv?=
 =?utf-8?B?anptdit1SmtzbU4zTEFLTUdXMzEvd1pSMXJEVzNCREhpWUdRcVRBbGR6SlN1?=
 =?utf-8?B?OFB3dDlVTkhPWG9UM0JvSDh1Ykwxay81WkxsQ05KZU50SDlvc3BGMXlGazdT?=
 =?utf-8?B?YmVIcU1XT0hEVkJRblBzb21jYXFFQllWb0Y5enpUalljY1BVOUt4SWhDVlEw?=
 =?utf-8?B?RGVZbU55eHFwT2o0VGtSOVlDdW9PTkltMjBIYzhKbkQzTFQrVk81aE9LcTh2?=
 =?utf-8?B?djIyMmgvWC9vN1RKRTZmSVFpSnMrMm1PM2M5a25RdW04VUowZDMyMnVoRFpy?=
 =?utf-8?B?VEU1Zkkra29BamRITnhoY3Z1NnhqL1pocUNZR1ljNGJ1MmFvUGlJNDhGQ3k4?=
 =?utf-8?B?MW0vNk5aKy9hOWNvU2Q4WW5OVVRoYzAzZHVPSVBOZTB3NzVFWTJiV2VnVG9r?=
 =?utf-8?B?S2xTeVYvS0prdUZ2ZU1UMDZacUpvZ1JQTDhXZHM4YXJZSUpXQXZ2eCs1Q2F2?=
 =?utf-8?B?bWZ6SnAwcEZxL1ZCQUVJTFpld1IvVU1FTE4xQVZvakhWdmwwYldDT2U5UHpK?=
 =?utf-8?B?Qlh3MzlSbHFDU3ZIRS9zcFdnVm5LQ1ZIdzV5c2ZUL21XK09rL3phalpiMWhh?=
 =?utf-8?B?QUQwVmp5R0t4S3JMN3RTeTEzczRaQ0Q0L0dQVjRndHlGcW5yRVh6ek9Kc2k2?=
 =?utf-8?B?Nnd4dkdCV1ZnTlMyRnZrTFRQN0puZ2hldnl6SkRCS252R3lHWVh0VEZ4c2VO?=
 =?utf-8?B?NDhVdHBNT0szd1Ezd2xxYk1CMWRqZEowRWNmN0J3Rm1hSURjcHNibnNsVTNl?=
 =?utf-8?B?c1ZXMG16RVlCc2RBL1JJTEl6YWNob08xRDZXM0RucjFPUEdsR2xTZXNQN3lQ?=
 =?utf-8?B?REsxSUI3WVZBdzlPQXlGNlpFTG01RkpKVDMxdExhSDFCMk1BSWJYUjdPd052?=
 =?utf-8?B?dGV2eFI0MklMcmI4eGxYQTdOaTRzTGI1d3hsYzRWRTFvenhsVllEbHFqamVp?=
 =?utf-8?B?WnBwL3RGVjB4T0pIK3Vta2FVeXBXRkZlbkxid3MxcTZqTlR6Y2JJZG5mZWQy?=
 =?utf-8?B?WGFKeDVJdW9penhmNTBIa285QzVhL1FMY0NzNGdUYng0WTRxaFV4T09GREVB?=
 =?utf-8?Q?v1S8bH?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ek9MdDIrVWthaEFxVXJUMVA2dGtjeU15SDlJekJ5T1NjU0Zlb3Z2cDFwR2RS?=
 =?utf-8?B?RzA4WEtUMzBLOTk2b1BlelBiSFRrejB0YUhnTU9kR0l1ZXFUTEtUaERONTdk?=
 =?utf-8?B?cENjSlo4QlhQWEJlSDNmbCsyWUtqSzl3Y21JRG5LNlIvQ2QralJ1NVpxeWJE?=
 =?utf-8?B?Z3J5MjYzNklvcWcyL2Y0VnZDbFJncW1mT1FLMi9XdHBWSVYvSnZlaEd1R3Av?=
 =?utf-8?B?MlFRYThwOHF1SDV2Rnp0MXgxQ1FtY3JqVTJkaURvKzgzRW9Kd011ZUVpK0lI?=
 =?utf-8?B?dDBXWGRVV2hTVHhwbmtSU2tRcGRENHllWTdXT2pIVFpPbDlNTFRPWTdKMmNs?=
 =?utf-8?B?ZDJBVFhTejl6L0pXYXIwMVNrc1RYZkZkOG8xZ2hKYk5BK0RMYVd0ZWxzVWdE?=
 =?utf-8?B?aDUvOFlVWm1GUGxqM3ZFL2ZWS1VNQ3dlMTZaMU5sTDQwbmdQUFNqV1RLOXVa?=
 =?utf-8?B?V1VGTVZvRFB0YURic0dPaDF2OFJVR3VTeWJQV2dzaktHV0VuWEZ6YUlaZWsz?=
 =?utf-8?B?OGJIMWhvbHN1NjBnZW56QlM0MGRCTFduK0d4UnlGZnNubWpRYTRrZi9aa3Zt?=
 =?utf-8?B?cWs4ckkyVVA2NDBRdDdFbTZUWUpabGJCWkF0VU9YcEsyS3dIR1lwaFVQdmly?=
 =?utf-8?B?Qk9aZHhvMFdqY3ZXVGN5SDRFbmttay85YzlBV0NDUmN1TjJuVERwRWZ0dXc5?=
 =?utf-8?B?NjE2SjdZZHV2RnVvdkNSSTRueTd0SXkyN0JvTmN6TzIzT25TQkxTSjloTkM1?=
 =?utf-8?B?MmJUNmYyVEZoS29FTVd5ZEE0a0d1a1dFOHA4LzNBcHhGanhXcFRINEJ5amxH?=
 =?utf-8?B?T1ZJbUdONitWTVZzbnVhcnJOV1RseUNqK0V5TStrS0FMZVFsSU5YakxJSWk4?=
 =?utf-8?B?MzlsaHhvYXM0WitzMUljWkFOcXgwKzg1bCtNem1YcjhRQ3o2THViM2VMRjha?=
 =?utf-8?B?SzA5Mi9oTUFxeTRmcXVsRVdmUi95YUhNeVVyL2pvclRYU3VTT1JkanRpZTNu?=
 =?utf-8?B?TmhSZzdBTmRVd1VrRlh2dXZvYlZrSTZqMHFQMUJiaER5Y0FRc240aVRKVi8w?=
 =?utf-8?B?emdnLzAzNmlPdG5kbUFpdEsrRXpCOE4rQXUrTzRjVFdKZ0RwZXA5K05jR21o?=
 =?utf-8?B?TUhncE5iRGxUTGNVTWU1eVBqYitjV0NOZnFtTXZkWkpVMUFaY2c3aFdlaTJB?=
 =?utf-8?B?Y3g0ZWdNQ2t6NVgvVHFySDVwUUVvRlppOE9BMU12TERHQWhCWGluM1ZFdHRS?=
 =?utf-8?B?L1NhSTFocTRRRFlwczFBT3JTWkNMMysrRit2MnpmYkp6VkRsRkF0Z0t6cGpR?=
 =?utf-8?B?RGNTLysyU3dESDBxM2JHeE9DaG8remtmRlByQVdXbFJRL2FjdERVKzNTcXBT?=
 =?utf-8?B?bnBzaDBkYXY2c1h0ZjdxNnhBek16YkNVbGVwdjFJeXFFWVBQK2VJdEM0S2Iv?=
 =?utf-8?B?NjN0a1ZBell5NXFrM0ExM2dIQ2FWUERuYnhBdUkrQUROc3I4TVQzRjNkQ2dI?=
 =?utf-8?B?aHRKNm9KMkJVdDkxeDJueUszUFhYNzdxaUxkZkN5VFN4RTM2cXlwUmtnMkRH?=
 =?utf-8?B?OEl5a1lObm0rNkRxMkxpK3pZMFZyKzg1Y0FNSjJzdTdxbWdsN05GUjFaUTV4?=
 =?utf-8?B?T0VHRy9XVjYrSStCNmU0THo5MGN2WjZOaTNqQklrLzIxY2E4K21wWGFaU2FV?=
 =?utf-8?B?YWVrWnQ5dWFhMzdWSE83amFFRGY5SjhycXU4d2ZxUk9Udm1RTDVaMG43Tjh6?=
 =?utf-8?B?UmpGWHNCQUpHWVVRSGNhS0xmb2xDK1VNRTRONDlreFVPeC9EelFrRndJSE9r?=
 =?utf-8?B?YnpJd2xZVm9pbk9UcnEwV3NuN1AyRXltcHJsT1NuemxhOHNYalE5UUJ6dFRT?=
 =?utf-8?B?Zm9LUld0UzVvRzRUWDNFMXo1R1YydUtOT0llc2lFbWQxa2FrR0hwa3pmOWVz?=
 =?utf-8?B?cDkya1ZEUUtiRTRJMHZWaW52NE9MV1hJWHhTV29sc2srSS84M0FHR3p0M0VQ?=
 =?utf-8?B?Rmxta2JJOGl1Rm1iSzNSb1Uwdy9RelJDWHgzUnNXRy9KcGtKRGUvUS9RaXBO?=
 =?utf-8?B?NFVJSnh0Q3F0WHQ5aUxocm13NmhCemd4SEFlSUxDcXFBRTZnOFU2ek1XODVY?=
 =?utf-8?B?UmM4OUFJbmlaTDd5TlRRT0hkejJjYXIwaENhTXl5Ty8xaDV1R0g4dS9UV0Ry?=
 =?utf-8?Q?f1xm8GC5/fmTOHdts2oRWAI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0122E053E7395A4CB8789F9E13C86356@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cf14544f-3383-4376-da50-08de00515b8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 18:44:16.0506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pk72OKm8MHAJPqBW35mZKm92G//A5GeTtVHlsAHoCSQuhv773NMu4Agm1GxVAcPNlr2CUW1iTcU0Kdx/xHjewA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB5535
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI2MDIxNCBTYWx0ZWRfXz0ZU1k1QdM6A
 F4jJz6mmgNwWwmLiIl/GgSi/aHujCsT/GQveJkxud6tQGf5PgOp++xGXOgKL3O6h549Q6hD1Fz/
 zx1eZgSmZkTmlmbSBKX3UMFSuaiJb6fNHm6gg0wsrJHiCbfWRA1SRWuyaUJ+h34XUl7LFU8Bcm7
 xxTR2IDfhLQ4l+1N/VDLEh7fJfIIxFJ60rdP3oyVZrrDkR3KSQ5CWAw6DjxY+6bqReYrDejRyas
 2zlt/ke4/vlD4/Sb+VMfNEFyt+aCgQiA+N0BIVU5E85UT0hTOLcLy6aewot/DcO2sZ58yGD1xZy
 YfBSwPUKAkhA/c255AGAVGKosmVc62MxRSy7gjd7McPM5T2aVCoX9C9DkH+/Nb3/jKr/j7U98bO
 MfDUHplNEIVE5UmSKBOFxHw54+6JlQ==
X-Proofpoint-GUID: 3rdIEjCDzDeefiFliX9nbNVjcIj_simM
X-Authority-Analysis: v=2.4 cv=LLZrgZW9 c=1 sm=1 tr=0 ts=68dc2504 cx=c_pps
 a=Bsy78vmKOeQIAJqgrxlU3A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=LM7KSAFEAAAA:8 a=emaWRauEbPqtpJClV2gA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: zQMk2EXDHtNrDgpJhC162Bqg_TrwXALX
Subject: RE: [PATCH 2/2] ceph: fix snapshot context missing in
 ceph_uninline_data
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509260214

T24gVHVlLCAyMDI1LTA5LTMwIGF0IDE1OjMwICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBWaWFj
aGVzbGF2IER1YmV5a28gPFNsYXZhLuKAikR1YmV5a29A4oCKaWJtLuKAimNvbT4g5pa8IDIwMjUt
MDktMjcgMDU64oCKNTIg5a+r6YGT77yaIE9uIFRodSwgMjAyNS0wOS0yNSBhdCAxODrigIo0MiAr
MDgwMCwgZXRoYW53dSB3cm90ZTogPiBUaGUgY2VwaF91bmlubGluZV9kYXRhIGZ1bmN0aW9uIHdh
cyBtaXNzaW5nIHByb3BlciBzbmFwc2hvdCBjb250ZXh0ID4gaGFuZGxpbmcgZm9yIGl0cyBPU0Qg
d3JpdGUgb3BlcmF0aW9ucy4gQm90aA0KPiDCoA0KPiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZh
LkR1YmV5a29AaWJtLmNvbT4g5pa8IDIwMjUtMDktMjcgMDU6NTIg5a+r6YGT77yaDQo+ID4gT24g
VGh1LCAyMDI1LTA5LTI1IGF0IDE4OjQyICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiA+ID4gVGhl
IGNlcGhfdW5pbmxpbmVfZGF0YSBmdW5jdGlvbiB3YXMgbWlzc2luZyBwcm9wZXIgc25hcHNob3Qg
Y29udGV4dA0KPiA+ID4gaGFuZGxpbmcgZm9yIGl0cyBPU0Qgd3JpdGUgb3BlcmF0aW9ucy4gQm90
aCBDRVBIX09TRF9PUF9DUkVBVEUgYW5kDQo+ID4gPiBDRVBIX09TRF9PUF9XUklURSByZXF1ZXN0
cyB3ZXJlIHBhc3NpbmcgTlVMTCBpbnN0ZWFkIG9mIHRoZSBhcHByb3ByaWF0ZQ0KPiA+ID4gc25h
cHNob3QgY29udGV4dCwgd2hpY2ggY291bGQgbGVhZCB0byB1bm5lY2Vzc2FyeSBvYmplY3QgY2xv
bmUuDQo+ID4gPiANCj4gPiA+IFJlcHJvZHVjZXI6DQo+ID4gPiAuLi9zcmMvdnN0YXJ0LnNoIC0t
bmV3IC14IC0tbG9jYWxob3N0IC0tYmx1ZXN0b3JlDQo+ID4gPiAvLyB0dXJuIG9uIGNlcGhmcyBp
bmxpbmUgZGF0YQ0KPiA+ID4gLi9iaW4vY2VwaCBmcyBzZXQgYSBpbmxpbmVfZGF0YSB0cnVlIC0t
eWVzLWktcmVhbGx5LXJlYWxseS1tZWFuLWl0DQo+ID4gPiAvLyBhbGxvdyBmc19hIGNsaWVudCB0
byB0YWtlIHNuYXBzaG90DQo+ID4gPiAuL2Jpbi9jZXBoIGF1dGggY2FwcyBjbGllbnQuZnNfYSBt
ZHMgJ2FsbG93IHJ3cHMgZnNuYW1lPWEnIG1vbiAnYWxsb3cgciBmc25hbWU9YScgb3NkICdhbGxv
dyBydyB0YWcgY2VwaGZzIGRhdGE9YScNCj4gPiA+IC8vIG1vdW50IGNlcGhmcyB3aXRoIGZ1c2Us
IHNpbmNlIGtlcm5lbCBjZXBoZnMgZG9lc24ndCBzdXBwb3J0IGlubGluZSB3cml0ZQ0KPiA+ID4g
Y2VwaC1mdXNlIC0taWQgZnNfYSAtbSAxMjcuMC4wLjE6NDAzMTggLS1jb25mIGNlcGguY29uZiAt
ZCAvbW50L215Y2VwaGZzLw0KPiA+ID4gLy8gYnVtcCBzbmFwc2hvdCBzZXENCj4gPiA+IG1rZGly
IC9tbnQvbXljZXBoZnMvLnNuYXAvc25hcDENCj4gPiA+IGVjaG8gImZvbyIgPiAvbW50L215Y2Vw
aGZzL3Rlc3QNCj4gPiA+IC8vIHVtb3VudCBhbmQgbW91bnQgaXQgYWdhaW4gdXNpbmcga2VybmVs
IGNlcGhmcyBjbGllbnQNCj4gPiA+IHVtb3VudCAvbW50L215Y2VwaGZzDQo+ID4gPiBtb3VudCAt
dCBjZXBoIGZzX2FALmE9LyAvbW50L215Y2VwaGZzLyAtbyBjb25mPS4vY2VwaC5jb25mDQo+ID4g
PiBlY2hvICJiYXIiID4+IC9tbnQvbXljZXBoZnMvdGVzdA0KPiA+ID4gLi9iaW4vcmFkb3MgbGlz
dHNuYXBzIC1wIGNlcGhmcy5hLmRhdGEgJChwcmludGYgIiV4XG4iICQoc3RhdCAtYyAlaSAvbW50
L215Y2VwaGZzL3Rlc3QpKS4wMDAwMDAwMA0KPiA+ID4gDQo+ID4gPiB3aWxsIHNlZSB0aGlzIG9i
amVjdCBkb2VzIHVubmVjZXNzYXJ5IGNsb25lDQo+ID4gPiAxMDAwMDAwMDAwYS4wMDAwMDAwMCAo
c2VxOjIpOg0KPiA+ID4gY2xvbmVpZCBzbmFwcyAgIHNpemUgICAgb3ZlcmxhcA0KPiA+ID4gMiAg
ICAgICAyICAgICAgIDQgICAgICAgW10NCj4gPiA+IGhlYWQgICAgLSAgICAgICA4DQo+ID4gPiAN
Cj4gPiA+IGJ1dCBpdCdzIGV4cGVjdGVkIHRvIHNlZQ0KPiA+ID4gMTAwMDAwMDAwMDAuMDAwMDAw
MDAgKHNlcToyKToNCj4gPiA+IGNsb25laWQgc25hcHMgICBzaXplICAgIG92ZXJsYXANCj4gPiA+
IGhlYWQgICAgLSAgICAgICA4DQo+ID4gPiANCj4gPiA+IHNpbmNlIHRoZXJlJ3Mgbm8gc25hcHNo
b3QgYmV0d2VlbiB0aGVzZSAyIHdyaXRlcw0KPiA+ID4gDQo+ID4gDQo+ID4gTWF5YmUsIEkgYW0g
ZG9pbmcgc29tZXRoaW5nIHdyb25nIGhlcmUuIEJ1dCBJIGhhdmUgdGhlIHNhbWUgaXNzdWUgb24g
dGhlIHNlY29uZA0KPiA+IFZpcnR1YWwgTWFjaGluZSB3aXRoIGFwcGxpZWQgcGF0Y2g6DQo+ID4g
DQo+ID4gVk0xICh3aXRob3V0IHBhdGNoKToNCj4gPiANCj4gPiBzdWRvIGNlcGgtZnVzZSAtLWlk
IGFkbWluIC9tbnQvY2VwaGZzLw0KPiA+IC9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNob3QzIyBta2Rp
ciAuLy5zbmFwL3NuYXAxDQo+ID4gL21udC9jZXBoZnMvdGVzdC1zbmFwc2hvdDMjIGVjaG8gImZv
byIgPiAuL3Rlc3QNCj4gPiB1bW91bnQgL21udC9jZXBoZnMNCj4gPiANCj4gPiBtb3VudCAtdCBj
ZXBoIDovIC9tbnQvY2VwaGZzLyAtbyBuYW1lPWFkbWluLGZzPWNlcGhmcw0KPiA+IC9tbnQvY2Vw
aGZzL3Rlc3Qtc25hcHNob3QzIyBlY2hvICJiYXIiID4+IC4vdGVzdA0KPiA+IC9tbnQvY2VwaGZz
L3Rlc3Qtc25hcHNob3QzIyByYWRvcyBsaXN0c25hcHMgLXAgY2VwaGZzX2RhdGEgJChwcmludGYg
IiV4XG4iDQo+ID4gJChzdGF0IC1jICVpIC4vdGVzdCkpLjAwMDAwMDAwDQo+ID4gMTAwMDAzMTNj
YjEuMDAwMDAwMDA6DQo+ID4gY2xvbmVpZCBzbmFwcyBzaXplIG92ZXJsYXANCj4gPiA0IDQgNCBb
XQ0KPiA+IGhlYWQgLSA4DQo+ID4gDQo+ID4gVk0yICh3aXRoIHBhdGNoKToNCj4gPiANCj4gPiBj
ZXBoLWZ1c2UgLS1pZCBhZG1pbiAvbW50L2NlcGhmcy8NCj4gPiAvbW50L2NlcGhmcy90ZXN0LXNu
YXBzaG90NCMgbWtkaXIgLi8uc25hcC9zbmFwMQ0KPiA+IC9tbnQvY2VwaGZzL3Rlc3Qtc25hcHNo
b3Q0IyBlY2hvICJmb28iID4gLi90ZXN0DQo+ID4gdW1vdW50IC9tbnQvY2VwaGZzDQo+ID4gDQo+
ID4gbW91bnQgLXQgY2VwaCA6LyAvbW50L2NlcGhmcy8gLW8gbmFtZT1hZG1pbixmcz1jZXBoZnMN
Cj4gPiAvbW50L2NlcGhmcy90ZXN0LXNuYXBzaG90NCMgZWNobyAiYmFyIiA+PiAuL3Rlc3QNCj4g
PiAvbW50L2NlcGhmcy90ZXN0LXNuYXBzaG90NCMgcmFkb3MgbGlzdHNuYXBzIC1wIGNlcGhmc19k
YXRhICQocHJpbnRmICIleFxuIg0KPiA+ICQoc3RhdCAtYyAlaSAuL3Rlc3QpKS4wMDAwMDAwMA0K
PiA+IDEwMDAwMzEzY2IzLjAwMDAwMDAwOjEwMDAwMzEzY2IzLjAwMDAwMDAwOg0KPiA+IGNsb25l
aWQgc25hcHMgc2l6ZSBvdmVybGFwDQo+ID4gNSA1IDAgW10NCj4gPiBoZWFkIC0gNA0KPiANCj4g
wqANCj4gTG9va3MgbGlrZSB0aGUgY2xvbmUgY29tZXMgZnJvbSB0aGUgZmlyc3QgdGltZSB3ZSBh
Y2Nlc3MgcG9vbC4NCj4gY2VwaF93cml0ZV9pdGVyDQo+IC0tY2VwaF9nZXRfY2Fwcw0KPiAtLS0t
X19jZXBoX2dldF9jYXBzDQo+IC0tLS0tLWNlcGhfcG9vbF9wZXJtX2NoZWNrDQo+IC0tLS0tLS0t
X19jZXBoX3Bvb2xfcGVybV9nZXQNCj4gLS0tLS0tLS0tY2VwaF9vc2RjX2FsbG9jX3JlcXVlc3QN
Cj4gwqANCj4gSWYgbm8gZXhpc3RpbmcgcG9vbCBwZXJtIGZvdW5kLCBpdCB3aWxsIHRyeSB0byBy
ZWFkL3dyaXRlIHRoZSBwb29sIGlub2RlIGxheW91dCBwb2ludHMgdG8NCj4gYnV0IGNlcGhfb3Nk
Y19hbGxvY19yZXF1ZXN0IGRvZXNuJ3QgcGFzcyBzbmFwYw0KPiANCj4gDQo+IHNvIHRoZSBzZXJ2
ZXIgc2lkZSB3aWxsIGhhdmUgYSB6ZXJvIHNpemUgb2JqZWN0IHdpdGggc25hcCBzZXEgMA0KPiDC
oA0KPiBuZXh0IHRpbWUgd3JpdGUgYXJyaXZlcywgc2luY2Ugd3JpdGUgaXMgZXF1aXBwZWQgd2l0
aCBzbmFwIHNlcSA+MA0KPiBzZXJ2ZXIgc2lkZSB3aWxsIGRvIG9iamVjdCBjbG9uZS4NCj4gwqAN
Cj4gVGhpcyBjYW4gYmUgZWFzaWx5IHJlcHJvZHVjZSwgd2hlbiB0aGVyZSBhcmUgc25hcHNob3Rz
KHNvIHdyaXRlIHdpbGwgaGF2ZSBzbmFwIHNlcSA+IDApLg0KPiBUaGUgZmlyc3Qgd3JpdGUgdG8g
dGhlIHBvb2wgZWNobyAiZm9vIiA+IC9tbnQvbXljZXBoZnMvZmlsZQ0KPiB3aWxsIHJlc3VsdCBp
biB0aGUgZm9sbG93aW5nIG91dHB1dA0KPiAxMDAwMDAwMDAwOS4wMDAwMDAwMCAoc2VxOjMpOg0K
PiBjbG9uZWlkIHNuYXBzIHNpemUgb3ZlcmxhcA0KPiAzIDIsMyAwIFtdDQo+IGhlYWQgLSA0DQo+
IMKgDQo+IEkgdGhpbmsgdGhpcyBjb3VsZCBiZSBmaXhlZCBieSB1c2luZyBhIHNwZWNpYWwgcmVz
ZXJ2ZWQgaW5vZGUgbnVtYmVyIHRvIHRlc3QgcG9vbCBwZXJtIGluc3RlYWQgb2YgdXNpbmcgdGhh
dCBpbm9kZQ0KPiBJIGNoYW5nZcKgDQo+IGNlcGhfb2lkX3ByaW50ZigmcmRfcmVxLT5yX2Jhc2Vf
b2lkLCAiJWxseC4wMDAwMDAwMCIsIGNpLT5pX3Zpbm8uaW5vKTsNCj4gdW5kZXIgdG/CoF9fY2Vw
aF9wb29sX3Blcm1fZ2V0DQo+IGNlcGhfb2lkX3ByaW50ZigmcmRfcmVxLT5yX2Jhc2Vfb2lkLCAi
JWxseC4wMDAwMDAwMCIsIExMT05HX01BWCk7DQo+IHRoZSB1bm5lY2Vzc2FyeSBjbG9uZSB3b24n
dCBoYXBwZW4gYWdhaW4uDQo+IMKgDQoNCkZyYW5rbHkgc3BlYWtpbmcsIEkgZG9uJ3QgcXVpdGUg
Zm9sbG93IHRvIHlvdXIgYW5zd2VyLiA6KSBTbywgZG9lcyBwYXRjaCBuZWVkcw0KdG8gYmUgcmV3
b3JrZWQ/IE9yIG15IHRlc3Rpbmcgc3RlcHMgYXJlIG5vdCBmdWxseSBjb3JyZWN0Pw0KDQpUaGFu
a3MsDQpTbGF2YS4NCg0KDQo+IHRoYW5rcywNCj4gZXRoYW53dQ0KPiA+IA0KPiA+IE1heWJlLCBy
ZXByb2R1Y3Rpb24gcGF0aCBpcyBub3QgY29tcGxldGVseSBjb3JyZWN0PyBXaGF0IGNvdWxkIGJl
IHdyb25nIG9uIG15DQo+ID4gc2lkZT8NCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gU2xhdmEuDQo+
ID4gDQo+ID4gPiBjbG9uZSBoYXBwZW5lZCBiZWNhdXNlIHRoZSBmaXJzdCBvc2QgcmVxdWVzdCBD
RVBIX09TRF9PUF9DUkVBVEUgZG9lc24ndA0KPiA+ID4gcGFzcyBzbmFwIGNvbnRleHQgc28gb2Jq
ZWN0IGlzIGNyZWF0ZWQgd2l0aCBzbmFwIHNlcSAwLCBidXQgbGF0ZXIgZGF0YQ0KPiA+ID4gd3Jp
dGViYWNrIGlzIGVxdWlwcGVkIHdpdGggc25hcHNob3QgY29udGV4dC4NCj4gPiA+IHNuYXAuc2Vx
KDEpID4gb2JqZWN0IHNuYXAgc2VxKDApLCBzbyBvc2QgZG9lcyBvYmplY3QgY2xvbmUuDQo+ID4g
PiANCj4gPiA+IFRoaXMgZml4IHByb3Blcmx5IGFjcXVpcmluZyB0aGUgc25hcHNob3QgY29udGV4
dCBiZWZvcmUgcGVyZm9ybWluZw0KPiA+ID4gd3JpdGUgb3BlcmF0aW9ucy4NCj4gPiA+IA0KPiA+
ID4gU2lnbmVkLW9mZi1ieTogZXRoYW53dSA8ZXRoYW53dUBzeW5vbG9neS5jb20+DQo+ID4gPiAt
LS0NCj4gPiA+IMKgZnMvY2VwaC9hZGRyLmMgfCAyNCArKysrKysrKysrKysrKysrKysrKysrLS0N
Cj4gPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
DQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2FkZHIuYyBiL2ZzL2NlcGgvYWRk
ci5jDQo+ID4gPiBpbmRleCA4YjIwMmQ3ODllOTMuLjBlODdhM2U4ZmQyYyAxMDA2NDQNCj4gPiA+
IC0tLSBhL2ZzL2NlcGgvYWRkci5jDQo+ID4gPiArKysgYi9mcy9jZXBoL2FkZHIuYw0KPiA+ID4g
QEAgLTIyMDIsNiArMjIwMiw3IEBAIGludCBjZXBoX3VuaW5saW5lX2RhdGEoc3RydWN0IGZpbGUg
KmZpbGUpDQo+ID4gPiDCoMKgc3RydWN0IGNlcGhfb3NkX3JlcXVlc3QgKnJlcSA9IE5VTEw7DQo+
ID4gPiDCoMKgc3RydWN0IGNlcGhfY2FwX2ZsdXNoICpwcmVhbGxvY19jZiA9IE5VTEw7DQo+ID4g
PiDCoMKgc3RydWN0IGZvbGlvICpmb2xpbyA9IE5VTEw7DQo+ID4gPiArIHN0cnVjdCBjZXBoX3Nu
YXBfY29udGV4dCAqc25hcGMgPSBOVUxMOw0KPiA+ID4gwqDCoHU2NCBpbmxpbmVfdmVyc2lvbiA9
IENFUEhfSU5MSU5FX05PTkU7DQo+ID4gPiDCoMKgc3RydWN0IHBhZ2UgKnBhZ2VzWzFdOw0KPiA+
ID4gwqDCoGludCBlcnIgPSAwOw0KPiA+ID4gQEAgLTIyMjksNiArMjIzMCwyNCBAQCBpbnQgY2Vw
aF91bmlubGluZV9kYXRhKHN0cnVjdCBmaWxlICpmaWxlKQ0KPiA+ID4gwqDCoGlmIChpbmxpbmVf
dmVyc2lvbiA9PSAxKSAvKiBpbml0aWFsIHZlcnNpb24sIG5vIGRhdGEgKi8NCj4gPiA+IMKgwqDC
oGdvdG8gb3V0X3VuaW5saW5lOw0KPiA+ID4gwqANCj4gPiA+IA0KPiA+ID4gKyBkb3duX3JlYWQo
JmZzYy0+bWRzYy0+c25hcF9yd3NlbSk7DQo+ID4gPiArIHNwaW5fbG9jaygmY2ktPmlfY2VwaF9s
b2NrKTsNCj4gPiA+ICsgaWYgKF9fY2VwaF9oYXZlX3BlbmRpbmdfY2FwX3NuYXAoY2kpKSB7DQo+
ID4gPiArICBzdHJ1Y3QgY2VwaF9jYXBfc25hcCAqY2Fwc25hcCA9DQo+ID4gPiArICAgIGxpc3Rf
bGFzdF9lbnRyeSgmY2ktPmlfY2FwX3NuYXBzLA0KPiA+ID4gKyAgICAgIHN0cnVjdCBjZXBoX2Nh
cF9zbmFwLA0KPiA+ID4gKyAgICAgIGNpX2l0ZW0pOw0KPiA+ID4gKyAgc25hcGMgPSBjZXBoX2dl
dF9zbmFwX2NvbnRleHQoY2Fwc25hcC0+Y29udGV4dCk7DQo+ID4gPiArIH0gZWxzZSB7DQo+ID4g
PiArICBpZiAoIWNpLT5pX2hlYWRfc25hcGMpIHsNCj4gPiA+ICsgICBjaS0+aV9oZWFkX3NuYXBj
ID0gY2VwaF9nZXRfc25hcF9jb250ZXh0KA0KPiA+ID4gKyAgICBjaS0+aV9zbmFwX3JlYWxtLT5j
YWNoZWRfY29udGV4dCk7DQo+ID4gPiArICB9DQo+ID4gPiArICBzbmFwYyA9IGNlcGhfZ2V0X3Nu
YXBfY29udGV4dChjaS0+aV9oZWFkX3NuYXBjKTsNCj4gPiA+ICsgfQ0KPiA+ID4gKyBzcGluX3Vu
bG9jaygmY2ktPmlfY2VwaF9sb2NrKTsNCj4gPiA+ICsgdXBfcmVhZCgmZnNjLT5tZHNjLT5zbmFw
X3J3c2VtKTsNCj4gPiA+ICsNCj4gPiA+IMKgwqBmb2xpbyA9IHJlYWRfbWFwcGluZ19mb2xpbyhp
bm9kZS0+aV9tYXBwaW5nLCAwLCBmaWxlKTsNCj4gPiA+IMKgwqBpZiAoSVNfRVJSKGZvbGlvKSkg
ew0KPiA+ID4gwqDCoMKgZXJyID0gUFRSX0VSUihmb2xpbyk7DQo+ID4gPiBAQCAtMjI0NCw3ICsy
MjYzLDcgQEAgaW50IGNlcGhfdW5pbmxpbmVfZGF0YShzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gPiA+
IMKgwqByZXEgPSBjZXBoX29zZGNfbmV3X3JlcXVlc3QoJmZzYy0+Y2xpZW50LT5vc2RjLCAmY2kt
PmlfbGF5b3V0LA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgY2VwaF92aW5vKGlub2RlKSwgMCwg
JmxlbiwgMCwgMSwNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoENFUEhfT1NEX09QX0NSRUFURSwg
Q0VQSF9PU0RfRkxBR19XUklURSwNCj4gPiA+IC0gICAgICAgIE5VTEwsIDAsIDAsIGZhbHNlKTsN
Cj4gPiA+ICsgICAgICAgIHNuYXBjLCAwLCAwLCBmYWxzZSk7DQo+ID4gPiDCoMKgaWYgKElTX0VS
UihyZXEpKSB7DQo+ID4gPiDCoMKgwqBlcnIgPSBQVFJfRVJSKHJlcSk7DQo+ID4gPiDCoMKgwqBn
b3RvIG91dF91bmxvY2s7DQo+ID4gPiBAQCAtMjI2MCw3ICsyMjc5LDcgQEAgaW50IGNlcGhfdW5p
bmxpbmVfZGF0YShzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gPiA+IMKgwqByZXEgPSBjZXBoX29zZGNf
bmV3X3JlcXVlc3QoJmZzYy0+Y2xpZW50LT5vc2RjLCAmY2ktPmlfbGF5b3V0LA0KPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgY2VwaF92aW5vKGlub2RlKSwgMCwgJmxlbiwgMSwgMywNCj4gPiA+IMKg
wqDCoMKgwqDCoMKgwqDCoENFUEhfT1NEX09QX1dSSVRFLCBDRVBIX09TRF9GTEFHX1dSSVRFLA0K
PiA+ID4gLSAgICAgICAgTlVMTCwgY2ktPmlfdHJ1bmNhdGVfc2VxLA0KPiA+ID4gKyAgICAgICAg
c25hcGMsIGNpLT5pX3RydW5jYXRlX3NlcSwNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoGNpLT5p
X3RydW5jYXRlX3NpemUsIGZhbHNlKTsNCj4gPiA+IMKgwqBpZiAoSVNfRVJSKHJlcSkpIHsNCj4g
PiA+IMKgwqDCoGVyciA9IFBUUl9FUlIocmVxKTsNCj4gPiA+IEBAIC0yMzIzLDYgKzIzNDIsNyBA
QCBpbnQgY2VwaF91bmlubGluZV9kYXRhKHN0cnVjdCBmaWxlICpmaWxlKQ0KPiA+ID4gwqDCoMKg
Zm9saW9fcHV0KGZvbGlvKTsNCj4gPiA+IMKgwqB9DQo+ID4gPiDCoG91dDoNCj4gPiA+ICsgY2Vw
aF9wdXRfc25hcF9jb250ZXh0KHNuYXBjKTsNCj4gPiA+IMKgwqBjZXBoX2ZyZWVfY2FwX2ZsdXNo
KHByZWFsbG9jX2NmKTsNCj4gPiA+IMKgwqBkb3V0YyhjbCwgIiVsbHguJWxseCBpbmxpbmVfdmVy
c2lvbiAlbGx1ID0gJWRcbiIsDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgY2VwaF92aW5vcChpbm9k
ZSksIGlubGluZV92ZXJzaW9uLCBlcnIpOw0KPiBEaXNjbGFpbWVyOiBUaGUgY29udGVudHMgb2Yg
dGhpcyBlLW1haWwgbWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBjb25maWRlbnRpYWwg
YW5kIGFyZSBpbnRlbmRlZCBzb2xlbHkgZm9yIGFkZHJlc3NlZS4gVGhlIGluZm9ybWF0aW9uIG1h
eSBhbHNvIGJlIGxlZ2FsbHkgcHJpdmlsZWdlZC4gVGhpcyB0cmFuc21pc3Npb24gaXMgc2VudCBp
biB0cnVzdCwgZm9yIHRoZSBzb2xlIHB1cnBvc2Ugb2YgZGVsaXZlcnkgdG8gdGhlIGludGVuZGVk
IHJlY2lwaWVudC4gSWYgeW91IGhhdmUgcmVjZWl2ZWQgdGhpcyB0cmFuc21pc3Npb24gaW4gZXJy
b3IsIGFueSB1c2UsIHJlcHJvZHVjdGlvbiBvciBkaXNzZW1pbmF0aW9uIG9mIHRoaXMgdHJhbnNt
aXNzaW9uIGlzIHN0cmljdGx5IHByb2hpYml0ZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRl
ZCByZWNpcGllbnQsIHBsZWFzZSBpbW1lZGlhdGVseSBub3RpZnkgdGhlIHNlbmRlciBieSByZXBs
eSBlLW1haWwgb3IgcGhvbmUgYW5kIGRlbGV0ZSB0aGlzIG1lc3NhZ2UgYW5kIGl0cyBhdHRhY2ht
ZW50cywgaWYgYW55Lg0K

