Return-Path: <ceph-devel+bounces-2772-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F64FA42D1F
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Feb 2025 20:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 001527A425C
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Feb 2025 19:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885CE2054FD;
	Mon, 24 Feb 2025 19:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="J4ywsHXX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A586F200138;
	Mon, 24 Feb 2025 19:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426942; cv=fail; b=eZpc9twCxKUcgDOsGyNZ1yOyIpyrDiV3zbqwMnJOZs9npuqG6l6VfZKd5+ibe6U/WAw8QCQvq3xQ+XuP2dlm+C00rlwZbRuj6AAZv2v62OdPDioRAlzI6AKk1Zm6fIOkKb+5g08TvIyrVGDaTn1wdEOhNBjhV4AlvhSqFJ9ntoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426942; c=relaxed/simple;
	bh=Tx4wZw9ilfk6O3bdLPHuunHZ/uZzAwcrFMN8tk71l+Y=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=TAniP94dsf8KAFvE+EzesQF2Sr/v1jP7I6p3fKUltsXIPsnEZUq/rqaencFDOSf3I0Nrfu9S1eqTX/5syIftvqDi/LDdHvJ8WqwbAkPuhZCLzw614M9SV4+/MvrpyPnB06emUWwnfrcp/BAwSUZKIYJT7DPflJNT3JGnIhdTtkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=J4ywsHXX; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OG5mJ1012339;
	Mon, 24 Feb 2025 19:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=Tx4wZw9ilfk6O3bdLPHuunHZ/uZzAwcrFMN8tk71l+Y=; b=J4ywsHXX
	Xy5KaQ8NI05e3T3oQLnaPvXdhPixWZ5dL4QatEKp0kjqbp0uiiGcGrd4r2jfyA1L
	v4yk+bCzspPKKoh7gPHQoahLvR+yCuLnUJjTStd0BzCRwxWP/9ukpVUztfMB1usr
	IBpZDhCOMwUDl6EQLq0bk8w3iY790QwNHCI7bhHj4q63v+Rt+qc3PabpBEqUgw2T
	eF5AYrFpfy9xSwVL86W+3IvwoDmSZ4oWc1pXhNLRm1Go47Gkor98PJt2gFfJb77v
	G/3+wbspndSc+0UnJ8/acNUb1BXZCBS7F/mlhL57LpnaMglBAiByT5y9qq9R9a9u
	QaWTTvnQ8er3Dw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 450jk83xyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 19:55:35 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51OJtZcv031830;
	Mon, 24 Feb 2025 19:55:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 450jk83xyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 19:55:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KSm8SEiMJAGHXe2jKGvc+hw6Ef8pYxRGABaCYnV0GKe7t8BSX7bSvZpLfhU4deBhdu7KM3VYBwQhembfiaNwzy2eJv8EYpTp2jMw85RrVEXkfzHwcmdhQcwzRW88XESIGw/Ks7+BeV4Xiyns5Fsk44L992NLcDQJQz37JegHS1n7Xf/TXTjcaZgVHwjPzOzrLPL658ZXiTRl6QD5wP7B22MO+ax3y8OMTaVPPH1Th38o9YmixdRRvSUeyi/D6uSXJLFYRjlnkeV3OgZUbDam8i1bX1hQ0BX/kOvTZnsw7HqIc6MAhwyetSALLH45N2EMEeLvYg9sqLEE7WszdI4/Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tx4wZw9ilfk6O3bdLPHuunHZ/uZzAwcrFMN8tk71l+Y=;
 b=bnskJpWcta1nYXqTxaxOQf8FWb/dp83s9BfpxJ4XzsnDyxB0qlYPXzAbtW4Ju33oj9dBoKzRP2cO7hFUWFeEzksMNnYXLHZ1Qc8Cb5U5Ii9e16PWbQJvHFnTnz/Zw97MNwQrT47EMaSIlaTh4VKxHuBx1Dime/NRlEKeLmxtb+7XpgpVsgNJ2na4VAQK77fhvIou7r1otvwLzz5hb80ji4yCON7gzOUTN/4hg93oD8+JBstGQqOaANL+guWzMo9P6fkTUUoKHlJpMEb7IGZZ8xtzriafd+s4Kfb0kEVXa5eHw0IOMFEmyAN7srpdgOl4Y9xXmtNtPOoHypFO9SViAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA6PR15MB6713.namprd15.prod.outlook.com (2603:10b6:806:41c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 19:55:29 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%4]) with mapi id 15.20.8466.016; Mon, 24 Feb 2025
 19:55:29 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        "linux@treblig.org" <linux@treblig.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] ceph: osd_client deadcode
Thread-Index: AQHbhMoY6LqlA+OIa0ikZu+6mBCbK7NW4oYA
Date: Mon, 24 Feb 2025 19:55:29 +0000
Message-ID: <5939f53e1f928e20d67b8e6fa06d6ce9a0b8a9ae.camel@ibm.com>
References: <20250222013530.171376-1-linux@treblig.org>
In-Reply-To: <20250222013530.171376-1-linux@treblig.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA6PR15MB6713:EE_
x-ms-office365-filtering-correlation-id: 2ca73d52-df18-4b9e-317f-08dd550d306f
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?N0Z0UHFUOU5tdCtPOGZ4WnhRdlRRK3dnN01pQjl1NVE0NFZsYk5ZeGltNEVP?=
 =?utf-8?B?c0Yrb21kLzRvNnVCdGpXaDZMQlFmNjZHblhlaDk3alVsS0dQRDNVVVVhZHMy?=
 =?utf-8?B?aGZVdkZxQmdmWitDdTZ1VmYxU29tWUR4WENqaHA2aDFZQ3BUbTV5ZWxZNkov?=
 =?utf-8?B?SmlPTlJrMG5saHU1Sk9zY0tOQkFSeUNqRjdveDNTRjVveDB3RXNpR1hiQnRQ?=
 =?utf-8?B?TStpSFpkRmdRRFdRdU93bmtZdDJad1cvL3hIOFRRdWViUlJJSkNPZUxMbnBT?=
 =?utf-8?B?MlVKM2VyZ2IrakJqandQcWpYWVVmZVhtVy9JMmhONFRsYkdnQUNFS28xWXVr?=
 =?utf-8?B?Q1dFSUYrdEpEM1BNdU9OZlovWWZzeUlIcEt2eEM1MFBUYW1FNXVPT2Y1RUdP?=
 =?utf-8?B?OERZUmN0QytWc3dJZjRzdVNna0thYXZlQUt3WUExT0NnL0ZEOUZBOG5iQ1RU?=
 =?utf-8?B?eUJncWJUTjlPQVBjbzNBaVg2RWdRaUtaSnZ2TFFHVDZKRnVvaUpxRmZHR2xy?=
 =?utf-8?B?Q2JxaGpyOGlpNDYyQUhtU2pMVDJINnoxQjdyRFY4Tm0xc1FQRVVkTkorMWl1?=
 =?utf-8?B?dzE1akZHZjhFUU1PV3FjeVJMR0FDTys4TExrTzhVTExWOFdjSjFLNFQ2SEcz?=
 =?utf-8?B?azhLZFZVMVVIK0NKeWYvSnUxZ2hWR2xmUkJXTTRYaFNqSUVpdnJpSi9lTHpU?=
 =?utf-8?B?MjRYWFBaK241UFJ2NDc5SXkwUUxuMEdIcWdjdEEvZ3lGcGtmSHhreDFmcGlz?=
 =?utf-8?B?ZHBScGZReWtjUC9TZzFIdmkvQmcrdmowaC9INEJYbjV3eU0wY1JaUVYxZU5S?=
 =?utf-8?B?MUZ4ejM5MmpvYzlMOTZZYmd6dDB0bTFaZ1JuMmwyTXJUSG5nNkhFNFY3czJo?=
 =?utf-8?B?MExtZXZzd0pwSDZJdTNYZ2dGU3kxUUg1NWlhSFU3UFhqR1diTlVBejdqU1pk?=
 =?utf-8?B?enFQZkZrK0plVzBmWHJwR3QrSUtGZzFjOGV1UnA3TFBoaEc0Z3VVTU4xYUN1?=
 =?utf-8?B?L09WdGNwajMvUG1wa2VnNWtORWFpYVVrcjlDTjR6NjZjdkZ0aWhnNEE3UDFs?=
 =?utf-8?B?NXVTM2dXVnpvL1VkVTFSckh5WW40RnFtR09ZVGsvU25xdkNqWnBxODdrSjhV?=
 =?utf-8?B?RzVRNm5RRVhRRU4vWTBsdllwY2FwdTF4Y090dXUvUWtPMk1CK0EreUZUdWlV?=
 =?utf-8?B?d1NpY20rYUNIcFpmbk55K0Z2dmcrZC9tMXJ0TVFrWEVKVGtsdE10YnprRVJu?=
 =?utf-8?B?Z2prQ2s4dW4xR3k0QWpPVWNXNnk0VHFneWUxMGYxRzBQYndqYmtvSmRLWEUv?=
 =?utf-8?B?d2swakZ3cWw0S0gxT0d6ekkyU0t0K3VnNVl2VWxwMC9udXpqV0Y1MFhGMUJw?=
 =?utf-8?B?SW1KYUpnZzBUODRLK1Z0R0w1K1hvNjBmcmpTZWhVS1Zid05qWldoVk54UDYz?=
 =?utf-8?B?cUNIdUZVcE5zekhzZ2dMMmIyUDVTVUJCODVjWUxsUk1LbzZMUjl3NDBxTTBC?=
 =?utf-8?B?eUFZeG9Na1dyenJXb2dFUHMvV2FtMlUwMFE5Y0o5MlpidXdHTXJoUDZHT01J?=
 =?utf-8?B?YUxUVU8zZndwRW4vVHk4aEoreXBrVFJlTFRuNVlPbGVnVDI1WXo5Y0gvU2pP?=
 =?utf-8?B?WUlUekxyZ2s3cFN2OGF3ZDNHM0FGSXlLZGpDS3NjN3BMdVBNcHJLaDBFcXIx?=
 =?utf-8?B?TVpWNy9yc2NBU0tLcmlJYmNwNXdiRUx3SklIU291Q2thNWlhZThBK2xsc2Nu?=
 =?utf-8?B?SHFmK3dqblV6ZXpaRDRLVURkS25wSDFGdnN0c200bTBBY0gxbnhldi92andP?=
 =?utf-8?B?Ny9PYndZNHR1WjYxc3ZWYW55TUFYckE4YWtDRm54Z3NQdWFoU1N4MnlwSDNF?=
 =?utf-8?B?SlNDbkZCS1J1S0RBbzNWSis1czZuQU5MVlZ4UzBzcnV1NDY5d2dvdVhreExl?=
 =?utf-8?Q?G5VduaR8dyZFZuf7p16feVyFBaajvtIF?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T1pDVm1IWXV3dUV6R1YrczdWSnRMdVhPZzNrOFlzUFBDTXV2bmtMZGJ3VHdS?=
 =?utf-8?B?cFRlb0U5eGdNYTI2UnY3UnRERU5qampQTFVpalVrcW1pQnVaZEJ6RGlWdlg0?=
 =?utf-8?B?SEJCbEcrZ1NZdWplaDNjUzl6K1pHc2xSRzBPZ0YwMEV6NEhOOFJ0R29KWElx?=
 =?utf-8?B?NmNZK1phVUxEbGp6MGFreFNRSTdRUDc5bVVNeGRCQk5uSldrTHcyS1ZYRHpu?=
 =?utf-8?B?enNMSjYzdkFkWFgwd3ZDVlhpNk14SXpvSDhMeXR5NklkU0kxTHMvMzlxbCt0?=
 =?utf-8?B?THlKd2ZXUDlyVG02bkRERXRLa0lleFlBYjJ6WnBHVFlsb0J6clJXUERJZ3gx?=
 =?utf-8?B?Zk5iRlg5VHlDMjdkL0w3M0ZJZC9WNmtIaHNxbGlKMFhZZTZXeWV3S2g3VDJW?=
 =?utf-8?B?V2xQTVI0TGxXOWliNFU4NE5nT3J6SStQTGk2Nzc1d1BaVThwM2lKRlE0VjZk?=
 =?utf-8?B?RG9rd1VWd0tQL0RsSmo4Mng4cys1T2lUcEhKSU1qNExJc3FObnlYMithVUZv?=
 =?utf-8?B?SEI5UU1mSWFqREwvazFMMm11OUJzeW1BeHFiME02MTNoWVN2YmVTSnN5dHFi?=
 =?utf-8?B?cEpGZjZFdzJ6NlBYSkozc3RTY1NXdk5hRHgxWUwydDdDNUZodVI3ZGJnZFRt?=
 =?utf-8?B?ZW5oYXdKblFBWE82cU5xT1VGaUorSkRkK2VQR1NGSnFDVFMwdjdUY1IvdmVy?=
 =?utf-8?B?algyWTR5Zld2QjBaR2pzTmZERkVMM0t5cXdzN0VvQ3dmRytnbXl2M0M1Z1ZK?=
 =?utf-8?B?QjUvVU1DSUErTEN0TVYrV0lqTW5uZmJ1SEdpWFYrOXJiTkgwTTUwZFpYdFhC?=
 =?utf-8?B?QXdPdm1zVGcrQTN1TTVmNzFjT0txT090Q0dJZkFtbVlpUXp2Wkxnd1VmaWY3?=
 =?utf-8?B?UTVYMUNnay8ydWVnbERxWjRpUldMOFJYb1JpZjUvNjk4Q2NtbFF4RTFGZVoz?=
 =?utf-8?B?RnU5cGx6Q0xucDJaTXIrZmxsWExCN1pqbzNUZlFwNDZoSHh5YmlmTEIxOFZP?=
 =?utf-8?B?ZGFFYUpGRnZtSGY4enAxeHd5V0tEQVNaQUQ4UEFab3JrK1hybXJBUEE4c1d3?=
 =?utf-8?B?NkNKNzBlaUgrWW1pSEhaTTBTZW5jV0IvaUt3aUhsVE9yZWhJUEx2YVVCWEps?=
 =?utf-8?B?cVVPdTNlMmhob2x4b3hBRW1XeHlyZElCK1JiU2VEVExodVd3Q2xYb3UrK0Zp?=
 =?utf-8?B?TytzbGxtek8zWFhPQ3JRaWtCRUk0RnhRaDlicTE3eWZIN2NVNG9HL1p1Nm9Q?=
 =?utf-8?B?T3NhRlBmTlh0blRoRHBYTjZNaE1tMHlLTFlVMy92NFhNR1VEcUpEUDQwTS93?=
 =?utf-8?B?UlFmbjJ1UmhqbllPR1N4cTJIWS9SeXAwTFR1dGJHTzZOY1poa1ZaRW5pblJT?=
 =?utf-8?B?QzV1cVp4ZlpYdmZ0eHg0Ly81MUFQNURzTGRuNnpHZjFOT2p2LzRYRWNVd3V1?=
 =?utf-8?B?NW1yMUQwRmpIUlFHSG9abUg1RFdETWVHOHU3b2pjUFF3VjQ4OE56Q0JPajN2?=
 =?utf-8?B?b2JRTzFmTkVxTVdKU3pCT042dGd2eGNtanNyV09idmVNODBBQTdzY0RiekVt?=
 =?utf-8?B?bjlReWZrdFJKWmNIVFZVT2ZKenVNUjd0Z2xta0JFdmR6YXA5a0ZmZmdyUENR?=
 =?utf-8?B?RkNPdjlHRXg1UXlMcUF3MjBWV25MVDBteWxtU1NjeWtwaWJ5U0ZVdHRwT3Nv?=
 =?utf-8?B?d3NSZmc1WjVOdldVZ3h2QTNHUE40VEl2d2hsdWRmV0xtOFpnT2ExTUxqYTZh?=
 =?utf-8?B?c2RSZlQ2NVo5L1RNdTZRcC9qS3J4TXZIditpVlZFbmwvWnZ0aHJCWkZuaTIr?=
 =?utf-8?B?by9kcG55VEJqbGc4NHN1RHhDN2VFU2lBSjJYcXM1VlY1ajBxNzV4eXBCQkNx?=
 =?utf-8?B?VVJodUdBUUt5RTdMMTlmb1VyMHRaNDFzUVh4WFcwa3BQZ1BoVlRaVGNoL1Zt?=
 =?utf-8?B?Smc4Q1piaklIREVoODh2Q3JiS3BOcTV0Y0l4STFiVVV5TVdmWXN3dWw0bjBx?=
 =?utf-8?B?YkZYYnFQSkpBV3F5TlUzanpSZU11TG4rSVZWaGN0L09IaDY1QzcyVGk3SERX?=
 =?utf-8?B?elkybDV0ZFI5VGtlWUVlNnN0dEVhTE1PeHVsWTQ1c2FFTW5peFhqWWtPb1lZ?=
 =?utf-8?B?Nm91L0MyQmxjK0J5N0o1T2hhUHp2V0hlR2xYMFdFbjRpQ2hkRE1FOEw0WEdS?=
 =?utf-8?Q?l0o07OMT+44jL3sPzigTcuw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D20DA3BAF95FDC4C8512DA9E0B838E72@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca73d52-df18-4b9e-317f-08dd550d306f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2025 19:55:29.1601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j2y4lLAG/WucZ1bC4unBTHuU1kTkg7f8n1B9MwYMq9lyOKW3ysxPitTn2aMYO6K86ifLNSwjfCUhbsLk7cmsyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR15MB6713
X-Proofpoint-ORIG-GUID: FpnvinwixrtIffYgIquNBRKOemtPYZcF
X-Proofpoint-GUID: v9MbrG8_Jdxwm_n-W8SNxluF0i-ABgI3
Subject: Re:  [PATCH] ceph: osd_client deadcode
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_09,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 malwarescore=0 spamscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502240126

T24gU2F0LCAyMDI1LTAyLTIyIGF0IDAxOjM1ICswMDAwLCBsaW51eEB0cmVibGlnLm9yZyB3cm90
ZToNCj4gRnJvbTogIkRyLiBEYXZpZCBBbGFuIEdpbGJlcnQiIDxsaW51eEB0cmVibGlnLm9yZz4N
Cj4gDQo+IG9zZF9yZXFfb3BfZXh0ZW50X29zZF9kYXRhX3BhZ2VsaXN0KCkgd2FzIGFkZGVkIGlu
IDIwMTMgYXMgcGFydCBvZg0KPiBjb21taXQgYTRjZTQwYTlhN2MxICgibGliY2VwaDogY29tYmlu
ZSBpbml0aWFsaXppbmcgYW5kIHNldHRpbmcgb3NkIGRhdGEiKQ0KPiBidXQgbmV2ZXIgdXNlZC4N
Cj4gDQo+IFRoZSBsYXN0IHVzZSBvZiBvc2RfcmVxX29wX2Nsc19yZXF1ZXN0X2RhdGFfcGFnZWxp
c3QoKSB3YXMgcmVtb3ZlZCBpbg0KPiAyMDE3J3MNCj4gY29tbWl0IGVjZDRhNjhhMjZhMiAoInJi
ZDogc3dpdGNoIHJiZF9vYmpfbWV0aG9kX3N5bmMoKSB0bw0KPiBjZXBoX29zZGNfY2FsbCgpIikN
Cj4gDQo+IFJlbW92ZSB0aGVtLg0KPiANCg0KSWYgd2UgZG9uJ3QgdXNlIHRoZXNlIG1ldGhvZHMs
IHRoZW4gaXQgbWFrZXMgc2Vuc2UgdG8gcmVtb3ZlIGl0LiBXZSBjYW4gdGFrZQ0KdGhlbSBiYWNr
IGluIHRoZSBjYXNlIG9mIHJlYWwgbmVjZXNzaXR5IGluIHRoaXMgZnVuY3Rpb25hbGl0eS4NCg0K
UmV2aWV3ZWQtYnk6IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHViZXlrb0BpYm0uY29tPg0K
DQpUaGFua3MsDQpTbGF2YS4NCg0K

