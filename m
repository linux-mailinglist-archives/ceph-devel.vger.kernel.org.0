Return-Path: <ceph-devel+bounces-3736-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDADBA1376
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 21:37:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0BCE37BAB8F
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 19:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCB831CA6D;
	Thu, 25 Sep 2025 19:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NxN6zybx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B26A31D36F
	for <ceph-devel@vger.kernel.org>; Thu, 25 Sep 2025 19:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758829015; cv=fail; b=hSzaKNxt3zqSBSORC0Yp9XuFF7CgmEoN8LIS6e5anrhxb2Ae21LaSDYX+1XT6JjMtc5VCtpfmjPCfQ6YcoPubU3f8Gvn26h2TfnTJvC2EseUbA6DRgtiK4apkkDtjslsnp5nLZ9uT5W6NHhSCOwo0RoDG01vxLb0hJ4BgWZJf5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758829015; c=relaxed/simple;
	bh=pezlGYBcjEcGkc/m7FRYEDreJUON7kzWToIN+yy7suM=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=P+cqtLUrHcYM6FiN7PuG5Awm3rotGp7xx6quhBQBoSmRsmaPC7/QmszEzjThTl1LkJbweco1hbOjZsA/L4YJpR6UQD/gRFcEqKxC/lHr20mruaKX0hsgalt0JO1p9KVM4+JaU0pAHhEYBPUsIhvNeXVb1fpE+TczHvrpUTYswvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NxN6zybx; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58PImS3n017942;
	Thu, 25 Sep 2025 19:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=pezlGYBcjEcGkc/m7FRYEDreJUON7kzWToIN+yy7suM=; b=NxN6zybx
	maxXuqAzeYjsDFQT5eZ376m+Nr17uqOEbQrnInIAeCXz72ccq+945tqeUKplXF4f
	CvXyw7mQrMutxi2tuFRe/oPFdGHfNWFY9AZTiweOBOPvVpnSzygqC/L2MIMjww0I
	7CbYcfHnq4A4sfLT0J5buIMqF8gMfgqCs0Vcrl9Wpb4pysxRn/3mg9DFHiJTF95J
	wG4s8cEVGe5DeT+PjUr+YsKZcQD8X4s9oiZTt0PboHLL/hXhz0WT+N3z5nusr1rJ
	LWSiSHwKR5Y683yVEcyibKVz+X7C4BdoLQukeXSJTA17XskiTBI6VaCEWj7kJSdd
	TaWqeYJSNa26ZQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbbd882s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 19:36:45 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58PJaj1j022175;
	Thu, 25 Sep 2025 19:36:45 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010005.outbound.protection.outlook.com [52.101.61.5])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbbd882f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 19:36:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HhF7eFUDtx/V0GfPnDz0ceh4/VAGzmCnQuo5HV3JUZAoiLqmKOrUxT8RNXPZDd/4TaTYNnH8wQ/4GqR/k1NQ0aaznWgE04vqDDStQpYL+u2IFUFr+MdqT9IDYx2Y/93P/NStQFfLE1quG6mgG09dbDAM1hCBWZsdaNsTkayFypcaSXSQpaZjL3chzoTivU5CRD2jweNbW0GsaWpgN2CrMwOek5jKKut1J67UPfT3/pG9n/+H50ujvxbzYGiPwR7FdWm3i4NdaNO9RZiAPHHTSmVx5spoxkILe4jgB7MvGqMY9twtmTHkQWzNqaihgA+HWQ/mtdQlVjS54pVgrfqGZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pezlGYBcjEcGkc/m7FRYEDreJUON7kzWToIN+yy7suM=;
 b=IyMd+EDsVki9Y3qIW5zFkjKpHM1jVjkUi1y2qxn/5F7KYUZJ7oTMFIdwPxQ1gedOGM101V7iVa0ejTBTvlN+LMo6qDtKMmAqe9x0rivHXS+8qgCfL+BtOtb76CIFIFxS9z8iRlaJbX6dYWpaDauc3ecRc1REvBTm1He1tT+DPT6RqbadYKOwHLA/b8buiRSbMdlRBdBv3nwz4DCVHLKyK0BUrIYVQZcusKAjP+zcdKElFYDrGX5f4XF6cgQcHDNziwyptvKHsP/Hv8SUF6JHdAuLOPnjfO95UdW6UyzkSthd4z2V03hopsyCClrQghmIrLVxz/3PiZ9JdHpFugbh+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BLAPR15MB4050.namprd15.prod.outlook.com (2603:10b6:208:27e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 19:36:41 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Thu, 25 Sep 2025
 19:36:41 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethanwu@synology.com" <ethanwu@synology.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
CC: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>
Thread-Topic: [EXTERNAL] [PATCH 0/2] ceph: fix missing snapshot context in
 write operations
Thread-Index: AQHcLgkpgjKHGYaflEuAfwqiiuYbyrSkS1sA
Date: Thu, 25 Sep 2025 19:36:41 +0000
Message-ID: <af696053838498289451025201e33d2e4fdfb589.camel@ibm.com>
References: <20250925104228.95018-1-ethanwu@synology.com>
In-Reply-To: <20250925104228.95018-1-ethanwu@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BLAPR15MB4050:EE_
x-ms-office365-filtering-correlation-id: 04ad6eca-1c7d-4d6a-9994-08ddfc6ada0f
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZTNhVjlJL0VnMmNmMG40OU9DR1QyR1BJMkt6VEV2REU0NGJHUk5wZ2crNEM4?=
 =?utf-8?B?MWhCRElMaGNjNERoY3lTTmUrL2ZaUGVxbFBPelg3K3F2NTRQYTJEUmx1b2lS?=
 =?utf-8?B?SjNlL3ZodE5xNFBCMVhMVTNiNkJFSVhML29zSVdNVldRekN2bEppT1RuV1I0?=
 =?utf-8?B?RUFIMDhmZXJZblpXaSs1OGZIVWVhQktWc09MaXVDbGV5ZXlBaFdWSU5kUSs2?=
 =?utf-8?B?ZXo1UjFJcTBCUDhIVU41bmJBNlVzQURWcEJyRHpqUk16bkRLMlhFamJ1MUpi?=
 =?utf-8?B?TGcybGlZSEYvNDRDTlVyODJXekY4S3dsck1Oa2lMMWxNTG1nT0dWWUF2Mmx5?=
 =?utf-8?B?bWo2V1REa2hINHkyaWlKVy9QNXVMZ0d5L1pEYTFVbWNxSGs1cnNCVWFOemQ4?=
 =?utf-8?B?amNGOFVMN2laQk5NVkRIMEhTekFBOEt5STE2M0VxRmJCam93djRMZVNNR0hM?=
 =?utf-8?B?OEZkOWdtcjVrTlllL0hEVzNiV3c5dmNydHNGaVBKR0h5cVNuc1FqRFdDQzE1?=
 =?utf-8?B?WDJFUTlSMEdlamhBTHpHR1V1SzNESzhoSnBVcURpWm9MWHFBZFJZL1hjMTRY?=
 =?utf-8?B?N05rN2NUaVRRYzNUVVFtR3ZMM2lQM3BHZUIxTWdNN2xSdzdjSGpMNmg0bXUz?=
 =?utf-8?B?eDMwUkpZZHM3T0J4OWtLdzdlMkNGek1wZjU4LzdFc1liU0hWT0R2a3hlZmNx?=
 =?utf-8?B?VlhBeUlQc0pBcHZncXZuajhTcHBtYVJRUjVESVpwV2o4cEQvSDRpYWRERHNa?=
 =?utf-8?B?K0Z1RHpsM3B6OVNBRlR3a25BdVNLTkJnR3FnWVBrUjdQZGpCVnhSSjFqejVT?=
 =?utf-8?B?TjhqTlc4blhnZldDU1gzNWVhcUs1Ni9kNWhTNnM0blVIWlh4dmgxeWo5NmhF?=
 =?utf-8?B?RE1PY0N1SjMyZTR6c2tvazQ4ZWl4Y1MvSEdQbWVKdVhDdlJGd0M2S0ViaUdC?=
 =?utf-8?B?VUdBQnRsamxkVXJEdWU2SURXNWM2L1czUjRWWVlKM2R3d0ZDdVRWNWM1Rkxm?=
 =?utf-8?B?L2Yzd0ZEbS9HNWZNc1Y4dUdnbXQ5VFE3eERQdHA4M2xzUWRWNzRaWGU5MlZY?=
 =?utf-8?B?RjZtRjExTGhnZEU1RHVPN3E3clBNazdXYWpEYU9oZnQxeFJrR1cweER5d3Bq?=
 =?utf-8?B?V1J1aUFrRDhXZDZKN2lTMHMzUnk2K0tqRVErVXRmMlpKSVhuTkdDR0p4dVZ5?=
 =?utf-8?B?Q1BVa0tWR0YvSmJHeGI3Z01MR1VkcUd3cFhUblRGNzNGalZ3dDg5Wmh1RCtE?=
 =?utf-8?B?a1huenU5d0IwdThCNjZMOGxPVVFCeDZISG1FUTA0VkZnQ3lIS20wQnJReVdq?=
 =?utf-8?B?YVRQMUlhaFJiMjM0TlJkQ29DaWRyZDJTeENVNXY3UXMvRXZzQkpOZm5sU1VG?=
 =?utf-8?B?RDVMM3pPcisvR2FGL0ZKTHBzcFU0ZVlvQ1BQdXo1RXQwWGN0cGlZWmJvUWpi?=
 =?utf-8?B?anE0YkdjSDArM3d4R0dtYmNwVEJDbHhaNkt6MDdNeDBWSjZNeHlWWHJob3pr?=
 =?utf-8?B?VkhINk9Jd0lCd2FHNTNkcjZHZkJtdzBML0tnakFIUDFiSEUrVUkrWUJad01W?=
 =?utf-8?B?eVlRMUVaUE5TZDZJZFhrNVcvbjV6TWFiV3AwRkJzNnJyNHVJR05LQ0J6VDE2?=
 =?utf-8?B?eTNub29ETG56VjlGWFlDc2RDYWxoS1hDeFlpeXJLbitzb1dlQ0l5UWdRZ1hh?=
 =?utf-8?B?eXZvTzNUNlR4MVUvcC9PZjcyWDdKZ1NaSG52eHd3ZXBqTXBRVDJIOU83VGZp?=
 =?utf-8?B?V0I2V1ltZWRHZjA3Q0RiN25hS2tNVWF0ejVMeWxpaE5XOGRMbUdEUFloVmpi?=
 =?utf-8?B?bHM3WWQ2R090eWt6WTIzTFQvWWt5RTkvQWlQSVp5TEJvc1Bpc1gwSG4rWmQy?=
 =?utf-8?B?ZElrTEJNT3kxd0Y0TmVJT2E4LzhjNkxkMHl0NmJEK2JHV0xPQ0MvOGRVbEp4?=
 =?utf-8?B?amJWay8vN1RPYUZMQnNVR2Nmc3k3Y3dVR2xqWkFtejJ1ZVRYcVc1bkFieVpN?=
 =?utf-8?Q?cSw13lvxR4dRURLiEUcFd4xuJu/+Ng=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WEYwM1BmaURoODNQZkNOM1c2dmJwSWM3RCtPMWxCYUVuM3ZoRGgvZXBrTFlz?=
 =?utf-8?B?K21XbHVxMjcxS1prUUJZL2RpSVFML1p5d2RVclMrdDByL0ZrQmtQRWcvME02?=
 =?utf-8?B?S1JlOTBnenZBNnY3UUlrRjgzRzVZMWp0ZnFHV3FZQXlzZTZIdGRaN0puekVr?=
 =?utf-8?B?SUYzbHg2L2RpVDltSHRObXRLRS96WW9MbTRLZWgrYzNweVhRMTM0NFRkN3lY?=
 =?utf-8?B?bHRlRGl0OVBNOTFoWTIwRWxKc3hBd0w5aTJqeGN5cGRaaVBkZWVzRG1ZQkRr?=
 =?utf-8?B?cEJDc01PNFNTb1FUOUNhNzUxYjVhWXRaRWJRcXV5UHpuNFByRWpVR2ZnYjQ5?=
 =?utf-8?B?ejZ2NDBHL0JlWjZIcFQ1YjBGYkZ5TzNRU1lhKzFobjlXQm84RFJZTmtubW5a?=
 =?utf-8?B?L0JLcTE0blFlRnRWVDM1RFJDSUlLZUlvQVdpQ1UzZjQ1am9SYWllK0tuUEpY?=
 =?utf-8?B?SkF0VXNWVU8xN3hSVGJSSE4veTJDQWRYYjBCa3duclRlS1JJWTNuYUJBSFZD?=
 =?utf-8?B?S0l5R3VKWXp1RHdzemhqOFRvNFJ2WUdocXFKN3IxSDFzVktzSURNd3kxRzFZ?=
 =?utf-8?B?cmNPdXh0eS9KeWZlZmRwTndxejVFdnoxVmMxRWcwMmRIYkNpU2N6R1pVaXFR?=
 =?utf-8?B?OThodjFUU0RSQWZJZ0lwOVR0NStxT1IwT0M4Q0xHblFtMFp5NWo3bmkxN2Va?=
 =?utf-8?B?dUkwcWYxcU04aG43TWNsNkRTbVdsb2dxdVB3VGJIeHhnU21Ec0FLU2xDVkRK?=
 =?utf-8?B?TjNzVll5dUt0ZHQzeWFCaE5sVS9LbU5DRTJIL2lSQmlmRFBqeUFpcE53dVpu?=
 =?utf-8?B?enFjblRYck4ySkNIQ3oyQk5qeHNQNXdIdFZURE5lMTJaMjZNemRwUTNRNGtu?=
 =?utf-8?B?TkRCeTRwdmhnUFhnTWRXaWRUTDV4ZkpBbEIrSzFIWkEzQ0xqVkFnRHJLYnJK?=
 =?utf-8?B?bC9Gb2EzYmxKa0R1SjlML2tYTGdjTEFKa2dxTFcyMHFVdGtVS0VWM09CU1NJ?=
 =?utf-8?B?M2xaTFlKVzZ3M0dRWjVwdjAyZnFoQzFtbjZHeWZhY285enlJUDdPMldRZlRV?=
 =?utf-8?B?Vjc4b2Ztb0QvV3cxNkZ6K1RWQ1VYaU8rZk1rK0I4TWVRYy9zZ044cWVpd2o2?=
 =?utf-8?B?U2FTdExoVklHSVBtbks4NHZCMjJEZ0N4OVBtbElhVXNFMlE2T2drMSthZXJm?=
 =?utf-8?B?a0crSEN5UDAxZmdyYlAyZ1hDZytmNjdxYTJaZEl6ZnVIT2dvYUlHcUx6WDhp?=
 =?utf-8?B?cytwQURiUDRHb1FOci9jRXErNWU4SWJyUFpvbFFVSXNCUXJMNDZ5WWszVDhq?=
 =?utf-8?B?My9IL3phMWhDTlJpL2NiekNTUDdWUy9vSHFRd3dqdW5ldFBObDVseFNVQUpQ?=
 =?utf-8?B?WDU0UjlmNElmY0RtWWFVUzRFdGw5NjBaeU1nZ1A1WlppNHFSa0l4dVJtSUNz?=
 =?utf-8?B?VGZ6VWxGMS9FdUp6ZGJyUnJUVU92M25BeDB1OUhvWGt2YUh3N21sbktwY2Vi?=
 =?utf-8?B?QktqeTZUaUkvREYyZ01KS2NOdHZoeFR6eHdocG1tL3BvNjRZaDY0cTE4Z0lt?=
 =?utf-8?B?UWw0K0xGc3VPT1N3MDlIYlNHeERoNUJLZGZRbWZDVXZuR2cxR1pUNFpNU3Y2?=
 =?utf-8?B?YlF4NUQ1bld6eWp5NjZLZ0hEbWFkeTNhM1FVU0ZvUDJjcHd4Y0RSN3RpWjQ5?=
 =?utf-8?B?Yk4yN2w0TGpiak1QVVJ4TUhNWEIrUmd0bEYwSlhtNkFmc3d0S05IZ0xzUXpB?=
 =?utf-8?B?NGVLNWgyN1RFWm5JcE12YjRzblV5VGEzVW9DRTBMcmI2VGQ0cmxDbFBCU3l1?=
 =?utf-8?B?ZzZSTWJ4VDRhbzVJMkpSL3N0VWVxTHZwdnduMHZWdGQ3OEVrMWZucUorM21J?=
 =?utf-8?B?V0xpMWlRMVZhMGtaQlM0L25jdEpGTTF2M0xwRFNwUWQ4THlxbGJJK3FqdkZN?=
 =?utf-8?B?TE9vMWJzZ0ovWmpoZHhiVEhaRElNU1dDSS9kOWZHcnZvcS9pRU10NFhhZFZU?=
 =?utf-8?B?OFFENnJlRnViV0hrTnBMcTBVSjNLeEkzZS9EYnpoQzFSQTg0eDhrYlAzbW1O?=
 =?utf-8?B?S3RzR0p1RWE2cGNSSUZQL2QrdmdMNVZ0djFGa09WT0toNk9GWEk5c1h4U3h6?=
 =?utf-8?B?Q04vc043OXlpYWJMRWJhcEl5bzNadk9kdU1VN1BlckswQW1ta2wrK0ljcWpR?=
 =?utf-8?Q?tN6KyqQmLMosW7PD0OO/qyE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F458B17C455A94BB627A7F6E2A16680@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ad6eca-1c7d-4d6a-9994-08ddfc6ada0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 19:36:41.1045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U3QbCALs4IGnp9NJp7YarYZT5iSWwirBp+99rlV49RQcd8X3c70tjwg5WX+qI3erCIACDGk/B/ts48+wIuTtfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB4050
X-Authority-Analysis: v=2.4 cv=F/Jat6hN c=1 sm=1 tr=0 ts=68d599cd cx=c_pps
 a=FYyDd4Hx0FY4jkPLXAZhlw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=1hL7ykf2qNw15pntqXAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3NCBTYWx0ZWRfXwO4eyOzHzoHQ
 ZJ/hjRwC7m6fU8WXsD2PozS5UeVvW7ECn7Pu4sw7TH8DOvtw7lBglwQGO16xmbzC5fQ1dfmEfnz
 Matm1RkF+Vtb684o4MfTVqJvkkXfliQKOBIfWAlxwU3FQW8sigcKAlPYrb4YaKN49wR2yumdb6T
 uaTat4qECT9Z2RXTzaf8rRQWgPm4YEe7rmgBBS/9EY9nHRucFQQ6GxSKAfUiGTBJptS6qL671F+
 QpuXp4PbdWEQaODjeGvVymCSeWi5Yic6WbbSQxv2e7uEqe8c1SGyYfYDUAUi5N1rAG9WvTdndCh
 O2B4lpC66whdV41b+MgRqVlBNWpGXvHpflBvDv4txaiT+cqSE/KMMvz7a1Y2CS3qSvTwb7ct6zQ
 0QXTc3Fb9HGheO1UIh0E71bAPg6y2Q==
X-Proofpoint-GUID: wiizBXPUxH7mnwUBOGPhFDlDbJ5O97mY
X-Proofpoint-ORIG-GUID: 9Gt_Ch-m5FaUCC0AgqaS_bMxQBh7Pphd
Subject: Re:  [PATCH 0/2] ceph: fix missing snapshot context in write
 operations
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250174

T24gVGh1LCAyMDI1LTA5LTI1IGF0IDE4OjQyICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBUaGlz
IHNlcmllcyBhZGRyZXNzZXMgdHdvIGluc3RhbmNlcyB3aGVyZSBDZXBoIGZpbGVzeXN0ZW0gb3Bl
cmF0aW9ucw0KPiB3ZXJlIG1pc3NpbmcgcHJvcGVyIHNuYXBzaG90IGNvbnRleHQgaGFuZGxpbmcs
IHdoaWNoIGNvdWxkIGxlYWQgdG8NCj4gZGF0YSBpbmNvbnNpc3RlbmNpZXMgaW4gc25hcHNob3Rz
Lg0KPiANCj4gVGhlIGlzc3VlIG9jY3VycyBpbiB0d28gc2NlbmFyaW9zOg0KPiAxLiBjZXBoX3pl
cm9fcGFydGlhbF9vYmplY3QoKSBkdXJpbmcgZmFsbG9jYXRlIHB1bmNoIGhvbGUgb3BlcmF0aW9u
cw0KPiAyLiBjZXBoX3VuaW5saW5lX2RhdGEoKSB3aGVuIGNvbnZlcnRpbmcgaW5saW5lIGRhdGEg
dG8gcmVndWxhciBvYmplY3RzDQo+IA0KPiBCb3RoIGZ1bmN0aW9ucyB3ZXJlIHBhc3NpbmcgTlVM
TCBzbmFwc2hvdCBjb250ZXh0IHRvIE9TRCB3cml0ZQ0KPiBvcGVyYXRpb25zIGluc3RlYWQgb2Yg
YWNxdWlyaW5nIHRoZSBhcHByb3ByaWF0ZSBjb250ZXh0LiBUaGlzIGNvdWxkDQo+IHJlc3VsdCBp
biBzbmFwc2hvdCBkYXRhIGNvcnJ1cHRpb24gd2hlcmUgc3Vic2VxdWVudCByZWFkcyBmcm9tIHNu
YXBzaG90cw0KPiAgd291bGQgcmV0dXJuIG1vZGlmaWVkIGRhdGEgaW5zdGVhZCBvZiB0aGUgb3Jp
Z2luYWwgc25hcHNob3QgY29udGVudC4NCj4gDQo+IFRoZSBmaXggZW5zdXJlcyB0aGF0IHByb3Bl
ciBzbmFwc2hvdCBjb250ZXh0IGlzIGFjcXVpcmVkIGFuZCBwYXNzZWQgdG8NCj4gYWxsIE9TRCB3
cml0ZSBvcGVyYXRpb25zIGluIHRoZXNlIGNvZGUgcGF0aHMuDQo+IA0KPiBldGhhbnd1ICgyKToN
Cj4gICBjZXBoOiBmaXggc25hcHNob3QgY29udGV4dCBtaXNzaW5nIGluIGNlcGhfemVyb19wYXJ0
aWFsX29iamVjdA0KPiAgIGNlcGg6IGZpeCBzbmFwc2hvdCBjb250ZXh0IG1pc3NpbmcgaW4gY2Vw
aF91bmlubGluZV9kYXRhDQo+IA0KPiAgZnMvY2VwaC9hZGRyLmMgfCAyNCArKysrKysrKysrKysr
KysrKysrKysrLS0NCj4gIGZzL2NlcGgvZmlsZS5jIHwgMTcgKysrKysrKysrKysrKysrKy0NCj4g
IDIgZmlsZXMgY2hhbmdlZCwgMzggaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KTGV0
IG1lIHNwZW5kIHNvbWUgdGltZSBmb3IgdGVzdGluZyB0aGUgcGF0Y2ggc2V0Lg0KDQpUaGFua3Ms
DQpTbGF2YS4NCg==

