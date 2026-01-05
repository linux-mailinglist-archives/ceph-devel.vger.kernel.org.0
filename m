Return-Path: <ceph-devel+bounces-4258-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D59CF5E43
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 23:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF91D3104655
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 22:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6292FE056;
	Mon,  5 Jan 2026 22:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PgeMrDmR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA472D8771
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 22:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767653268; cv=fail; b=XuORrcW3TZV28nxgd5LsBtDN663eSCQM/Zft3/TsR2w7v0oahdnzKlZK1FfzGLk+JjE8DSt2d5hn5lxKxPg0ez/nACJmhgSM/UD59ljb5Gl68B/ML6qIu0dH4Jx6jBZygfloUmxcXPP6Xea25lrM8HOvxVjRzvpUCao/zU5AIZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767653268; c=relaxed/simple;
	bh=e+7XdAlPWuQV4sjLUQ+6OgLPVfBlr7F5XwsqJNpP8B0=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=M7fRQVn1+CUMJJI+IwzWZr+LJkslENG3weI+T/70oIflusjRTxLSPmYfj0p0nT9F+xbS4HyUT8j96s7E1B1eFPX+Uy3o9cluFDyYmy/zT8/KhAbOBuFZ1Ks918KngysCGaSp/U0qW2Nm0p3lNnQxbWNlWx/l4eJMMs5Ye+39oms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PgeMrDmR; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605BIHxW010306;
	Mon, 5 Jan 2026 22:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=e+7XdAlPWuQV4sjLUQ+6OgLPVfBlr7F5XwsqJNpP8B0=; b=PgeMrDmR
	SYOSS3e16aZre/cqMhxah8dbyLH8stW1SH6GuqnhrUwXmpcG6Mf/4deWf7nk87ok
	PYKPhyKj9BCMUAEM51oK1KL/tMKvJ3aKsGpZzjC5C9VVlyDgWfMf6uLZeQWYC7lg
	loWzdtYyrXA4vR6YhOnqp5rdi+M91Ou7DNFQCggBk6R0LjebBXCuyt6pX1V5e7ls
	pfyeGVZ0vGm5oLivej1uqtyyaPgFbkcZDds+9UYpyU1OuYzXoygRjodISBUUhP0W
	I61DOlAGLJMX/YF4ZPg74TARlAOKJxcheeKKrt11f1PkRlEXnjm3e7be0W+yATQO
	jCVu+Nuy5rkooA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4berhk10x8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 22:47:34 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605Mhnc6007690;
	Mon, 5 Jan 2026 22:47:33 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010052.outbound.protection.outlook.com [52.101.56.52])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4berhk10x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 22:47:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hBLZa3jcNjzNe11NWQgK/5xFPKm3YbL5sXMDIkGuHPqRvmbAHOspaBrprlJ75jkC2Q+pUjoiIkAUOyM5Cdh2Fnvzo2+HNM9vMVsbPwe5arT+9H6OdFrXBM4ojGdAqr3AnPB7dhE67/Dx/r9sLY8dT3pb8G5F4pC68sHP/wSuW+ULqYdVFRjN3a/adxb0cus65Gns17Aka8H0w9Z4ppJpGDWxTqQIAcuYXjm1hFo38uDmcUCO7mA6lxthRlCdrF9jqOSKv82a+BOR4YKotMqvyoOSklwqgxmrQm+nfrlU0QPxkQhS1g4saiOqy1nrrXLPDV/NvuNnOHOyIn6w+RQ+1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+7XdAlPWuQV4sjLUQ+6OgLPVfBlr7F5XwsqJNpP8B0=;
 b=OpBlq+OloX1Zsidgml1youmlmNZ2ToVW6bcP1wOf7qTqinK7PERlCeBEJYXiuW3mEAUpuYX2PQkdlKQzUTg3bub+QJvAmI2Na0m4ZPHu6+L/KphEgBLLd/Jz5CTZOHUP1vk1a3W3Vc9jv3O3omY9/NyfCVOElXULCFplspp3v4SakzR0ratzYddW6wAlvLZZ1IfT6pBbmnxveNNe40JB8ceVIPk5WTYK1XyFTVPegQw6aaN/NXmi/qor3RURUcomzp5OLKPrsbJZmlEPxxYEgKYvogR4TadBlSsua1Gb873Xe1haNxkAHABIGT9AZ64UY8M989D+1yx2ENrvEBzJzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS1PR15MB6695.namprd15.prod.outlook.com (2603:10b6:8:1ec::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 22:47:30 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 22:47:30 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: "raphael.zimmer@tu-ilmenau.de" <raphael.zimmer@tu-ilmenau.de>,
        Alex
 Markuze <amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH] libceph: make calc_target() set t->paused,
 not just clear it
Thread-Index: AQHcfos7aGs2aiJK2UCv+GvvFZo0grVELXOA
Date: Mon, 5 Jan 2026 22:47:30 +0000
Message-ID: <5ed8e36b5ce24a324e31f5567d338bd35930bdfa.camel@ibm.com>
References: <20260105213509.24587-1-idryomov@gmail.com>
In-Reply-To: <20260105213509.24587-1-idryomov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS1PR15MB6695:EE_
x-ms-office365-filtering-correlation-id: 68bc8327-b4e4-44b5-8aad-08de4cac6886
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cmhkay9oOG9ieDkrd1RjUExJMU44M0lRUVNMc1VqSDRjcUZzT0tXSDU1MWc1?=
 =?utf-8?B?aXhHdHhVRFpYZ0VralNWK0NhdnM1cTVNclN2K2VnVXFIZG85dWpCRldacmpF?=
 =?utf-8?B?KzRHai80V3FyMFJ0L3Z5cFhCL0ppZFlTUndhajh3VGRkVUs0b0ZEeW1ubWpE?=
 =?utf-8?B?ejlwOHVBbmd6Njh0NEdPRmFKd1kyTzF0N2c2T1NFeWtnL2hXZWs5OVNLMERR?=
 =?utf-8?B?NnBFVlNFd3gyTzhjU2NKVEZuZnhjNEplREw0cFBPY2ZEVFVsWTRPSXBzcVcw?=
 =?utf-8?B?MmN6WUxZSmd4TCthVzkrRlJ2ZjRISVdyUDZLTjIwbGxSMGJQdk50ZnJ0cTNF?=
 =?utf-8?B?YXJ0a1J0ZHNEWmN0V1dZaG9kMzVqaGU0NXVVdHJNN0hrUDZ2WkVnVWJidFcr?=
 =?utf-8?B?dytkSEFDczNCRnZTOHhkOUJObXhieGp5NFA3a1VtWkxpTUszTTFaeVk0N25y?=
 =?utf-8?B?Z0duUTZtSzVESjNrdStpMDREVGg3WE1wVERRSkRHUDJaOG9LRmx4QkNWVDhT?=
 =?utf-8?B?WHQvaERkSEE1TVZvUUlwa2VyYnpEVEhUUHlTNVNzQzl5UmVZR2N5MEJaYXRF?=
 =?utf-8?B?NmtzZjdSQkQwNGhEL0syNnU3U2RadGJYYkdteDA0enE3ZGg0S3Q5TFRscnNI?=
 =?utf-8?B?VWhuME5VREdRQ3hZeUw3Mkx4QWRRSXo3eE8zREwrZzJPUGZ2Sy9abTVDV1Nn?=
 =?utf-8?B?S3g5Yzc4TUducFhnRFd2cDlyRnQrQ2prb3R3b2lGZEJCYUdiK3JaTG5EWkRP?=
 =?utf-8?B?TDlnQ0NXb3BWVGpmTjFtN3AvVUl6Q2FnaU00RGM0SERQbVZFU2RlMHhDdUxm?=
 =?utf-8?B?dy9TemRFRGRCRnJ3RG1HdlNwcndnc0hCS1Aydm1rcTRFQjdrSXk1elBnZ2xZ?=
 =?utf-8?B?MzViTnhjUTZZMlk5VXdwV2dlcDJjUXpHZDRMMGZGWmowbzhQWEpPZVQyM0hM?=
 =?utf-8?B?VkRwTmVXQ1EwdzhpdFlVdXhpOGlIUlloaW1GQXB3cm5iT0l6cHhVTElvMkpm?=
 =?utf-8?B?QzZQQ1pXWUlyY1FtYmhRNlE3RVBvNHlGM3duV0FQa3hrODlEdnpZcUF4ZVkv?=
 =?utf-8?B?cU5UL1d0b1JvK3dXdHBBZE1nV2Z2dG9TWHBYWTQvNVpKN0Z0YnpoeG1WdXk4?=
 =?utf-8?B?ZUNzUkw1MHgyZGVKdkIwRjVRQmErQUxlcTcxcTRSbVoxeWQ4RnZOb0E1RHNh?=
 =?utf-8?B?eVRGNDlrTFBiZVRCNEJRbUVTNWRFNkVXR3VEWS93clBUNStJZGhKNHF3K2Ny?=
 =?utf-8?B?ZHVvS0tWMTlMQ2hjQlc4V1JiWDFINWNVQm1TVzRpN25FMnVYVnowMVFkQWRp?=
 =?utf-8?B?WW93T3dEd21iQ2ZVaEtRQVJzT0FHZ1g2TVVvWFA5a2RVZjZ6Wm1uUGM0NURR?=
 =?utf-8?B?Tk9tYTBnREQ5NFdxTGRNRlZabjFPa2xFNmFYODgyZ0poVXFUNy9SaU5rR1Qr?=
 =?utf-8?B?K3U2K2sySzhUSlFsMDRHd2VsbWdGRXBHcmxVWFNiemhVRHFxaEcybEVzVnZV?=
 =?utf-8?B?OGNlaVFaMS9XZkpvRVZWVVlQRG1rREVZREpWVHFpcmw1THpmZmYzSExUWUtj?=
 =?utf-8?B?Rm9pTzREUnR2UUhmazVpa2h3M3QxUGltejU5UlNCNFVHRGl5bnFlM1IrbUF3?=
 =?utf-8?B?VVJHZk9ZUDR6SDdsRTJLOGdqWG9aV1IvaVRHNmlHSTBOMklURWZxNFVsK0wv?=
 =?utf-8?B?Y3RGblMyd21rM0tGYWVQMW52Q0pTcGpnSklhR1l1b2taUGE1MlVPVDFtK3VO?=
 =?utf-8?B?MlJuODRuQnNnMnIvTGR5V09zV25FYi9BMGtibTlHdGFQa29rNjVIRHdEM1Y2?=
 =?utf-8?B?dzBzQVhpOHkrOUNUMStjNnhzWUZZOC9YUVNPMFJUYTJsRnNHTEYyYjVYTEJi?=
 =?utf-8?B?SEdxZ0trVXFJajhONW5FdnpTR3dTTkU4QWN6VnIxbVdlbWdRWjhYcTFrRHN0?=
 =?utf-8?B?U1JCUVNqTVR3djNUWnBsL0U5UWJDYTVHS0hSd3lyQ1o5cU9KSnh3WnRBZE9D?=
 =?utf-8?B?QXBSblZJbEl4c0t0OHhHMlkyM1ZUVThhL0l6TkFpc0d6RDM3bkJjVjBsTXl4?=
 =?utf-8?Q?yw438K?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZDYxNUR2ZDMwNFl1TFFndmJXMVQvUjFVYXhOKy9sazFhb3d2WHBYU1Z3dEtS?=
 =?utf-8?B?WGpmczJkMUdYaEJ0UFBjcG9YcEtnYi9YRjF3NUt4UDJ1VVlGUEFHaHhFcDAv?=
 =?utf-8?B?Ui94OXE4anJGWWhWQmcwanRFVms2cmhZNDNhSFFkSlZPODhLVDc4RDI1OUl5?=
 =?utf-8?B?cFZIQXdtRFdPT1ZsVjV3QURHRWhLU1MwM2RlWkRJdjVrV0xTY21RU0pNdksw?=
 =?utf-8?B?bjRiYTNtSWhMdFh2MGIzbm9aSmNKalFzZWZwMEV6bU1vZ2lKNEp1dlVIeFQ1?=
 =?utf-8?B?RzF5bVI5SmhoMHFGaVhKQWdodTYybERkbXJtcDNwVVRoWTZOOU8yWkR2V2JU?=
 =?utf-8?B?dFVxWGwyRXBpSnA4OGYrejdoU053WkZlYng1WFZTMnVwdHhhT3dCbjRHcU42?=
 =?utf-8?B?U002dXUvWFRNYVJ6TnpONDBKTUJNWG1JT3RBTnV2VmorV1FEOTgyeGx0YWcy?=
 =?utf-8?B?WERIcXIvdmdxM0JWNzI2YUpHSEE5dWlXSm1xV3dqLzc1dVpOWE40YnJ3Q2J6?=
 =?utf-8?B?Nk8rdWxMb2dMdmdvMjNWcUlxZkdKMlB5eS9MeUdCN1MyUG1SUnFaYWVzYUNk?=
 =?utf-8?B?ZkVsYndEdG8vZXdoVndoNFR0ZWNDU0lUUTNlU1NONktHMEN0TkEreVk0QlBZ?=
 =?utf-8?B?a3A3YXkva29idS9jTEM2Q0xTSTVldjUvRjlLY3o4b1VUaGRud1pYY2RETDQw?=
 =?utf-8?B?emk3SldETkdOVDR1Wk0rbUdoWm5rclRNRFE2azNXeThkSm1Yd0EyYWsybFg1?=
 =?utf-8?B?TmdaS3JocjR5R2RPUnVXR0wzRkszTUc1bEIrajZCaHQ4cVVCUkxwbXhOVVM4?=
 =?utf-8?B?UnlDQjIxcTR1MXkrTjV5K3JSc3JjY0NWUVpsU0NZVUpMMkVodW5zWnFKQndY?=
 =?utf-8?B?dTMvdml5THNIRS9vMHd0MGlQU1NmNkJkdE9keDVLUkl4MlA2ZjA1NGptM25x?=
 =?utf-8?B?SWRYUDRYZklRL3dDc2s5d2EvR3gzNFNYc1Y5QVJFL2tLR2tKZVQyR1EzUUlQ?=
 =?utf-8?B?VzlMUnh0WncyR1dPZkw2VU5IUkNsUnRrYkVYendpdmhZUEp5WTdxcFkxK3NF?=
 =?utf-8?B?R1NFd2N0TVBYR1pvYUt2NXREMTI1MGRHbDRUcTJmSndGUmZiQWVUOWxIMkg2?=
 =?utf-8?B?d1VadmRqWHJ3aG9Ka2FhYlZnajIyS0hMclZqUmZwYU1LeGV6ZngrUzJ3NE5j?=
 =?utf-8?B?ZHU2bVFRSkxMYUJtaVUwM1NEMzFPWWN6akw2VDAwd3VJTTRDYzdCV0Y0NVE1?=
 =?utf-8?B?cm13Z2ZsNzFHVnBXM3FTc2V5bnF6QWxyeGF5R2d0YlozZnRudWg5V2FkbUds?=
 =?utf-8?B?T3BoRktyL3RCcFlaTnZ6NlNEZTV0cEx0cmc5UTZIeEdJandUcm9sYjVDaVFl?=
 =?utf-8?B?S2N3alFIT1FZZzJ4L3dFRDYyTWoxekxQK0Q1T0JnSHhqMGhtWjNUVm5NRnp1?=
 =?utf-8?B?N01NUGsxRGd6U3FndTBhaUZ5OVBOQXZnVXFiOVI1V2w5Q3k0SDFMSlJOMlBF?=
 =?utf-8?B?c0s3djFkUVV4aGNhSWJzNVhBTTVXOUd2NnRKU2lLc2Y5b0pCT2VQRzA4d1FO?=
 =?utf-8?B?UHZ1Z3hpT0xoZnBGb0RxWXlWYjBMWnRWeUlkQTNSR01mejVLTVZuM0FuRkRx?=
 =?utf-8?B?QmtCUUxNclEyNjIvUHNsdjgzVEZCN01IdS9HY0NvK1RpV3ZxNDRqS1dmekR2?=
 =?utf-8?B?SjZxd2pHamhTZUMza1Z6WUE3OGc5YzdyZExCNUVuQi9TU2xTSmpXYy9lM2lC?=
 =?utf-8?B?RE13M01QMTNqeGNtaWdOOFp2a2YwNk1wZU5wWitray9DaklsVC9FVVhlL3dk?=
 =?utf-8?B?TWdLV2c3RG9LTXU3dHdSY21rcDVnMDBNNFM4alNQUHJjYVg5NFpaMjJCWC82?=
 =?utf-8?B?ZWh2ZWg5MW5vZldJK0drcnBnYi9hTnF6RzVQUCtDeTdxd2Jhak9DdjJlemdj?=
 =?utf-8?B?UmdNVno3d1ZxUUcrREYxUy83MnU0NVpQYWhPK3ovYm1xQ3U0QmRvUi9Vd2tE?=
 =?utf-8?B?SDlaOUFEeVREbkRUM3hGSDNDQk5ZWGpKMldmS1BxSHNoek9RUlNMb2VydVY1?=
 =?utf-8?B?T2dYWVN5bEdOZVRUOHdMTFlXTDVEazg0VzhORThDMnA3bWtGRVFVT3BCNkZt?=
 =?utf-8?B?SFhISHBFYVJCbXVOYTJUVFQyTkptQWlxWktRS3lHS0RKNVgrZ2xEVHk3a0lO?=
 =?utf-8?B?bFpxWHJ3MU55eFg4MTNZK25ZTDJuM2xENlRibUU1eWJ6SVVlREtqK2V1OU56?=
 =?utf-8?B?RDR2MHpxNUlUMHlPc01SdHdNeWxzVTQyNGU1akk4M1BuZVdDeDdkQmZYd3dX?=
 =?utf-8?B?V3B3RE5MSHBvSjAxdndseC9PR3IxVytqeVdRR3FoWCtRNzhRQWRlRGw3UlBj?=
 =?utf-8?Q?kEmCYK+8HW1rBZCLLiFJ29OxapVVRjFDmFR6s?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <377549C5988C5F4CB0BCAC9CDE99F713@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 68bc8327-b4e4-44b5-8aad-08de4cac6886
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 22:47:30.4449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ztZaMXLjf1jKIktYf3Mg+BnQJO35yApvqgcFRCMkQ12oOnexRrUdFVFPFc1jF0wcIgQsQpmFipzmPdoL01wdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR15MB6695
X-Authority-Analysis: v=2.4 cv=P4s3RyAu c=1 sm=1 tr=0 ts=695c3f86 cx=c_pps
 a=eLvx4Fye0krSvKD/jKlmuw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=IQz-2zRJwSmIsAnYXPEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: qclKOz6sxJqtubh7xlLe5jW_frbbkGMZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE5NyBTYWx0ZWRfX3BB9gZF0s2Fl
 M8dCorXZDYsVkLGsK1ualGY5Ooc1NpMSybg6VhqaB97X6mNDhxzrpoYaIXDzRcOYn3hUtOb1FSl
 4234+BJDQVXMLDkJJ1sYt4W8Ea1tmFyhq/AUZVMAqljtUYCGpwGf//OhQpXjqvzuGP3nT+bW/+A
 qDNvumPuLcMGRzn9U68Eas7s/6jaQnHPsZs6yttJBujaQzDTa5TOmGUFQl+zHZdbVggvL/g+J8c
 /Umr9BPKL7x4YVaBeAktdviDI6+HRDyYfOCIVenSUGcqjRJWdOkC0WSiSMuA4FYC5OQzehQWR/a
 hDS3279am5LTbzetYGmxxxfn92yXcpBDzTqRimhdfM5TGC8Z5bhUx3rr3UVNblT2WIqhGZGzIYP
 oe6vL4GwymOucwzknzY85wNnF51lRqyj4ddjwqexgZ9tTQE1S+lyws/LHvutWB16g/2CpmEj9gn
 gdKZE+W5cJLO6omm07Q==
X-Proofpoint-GUID: caHi0Y6uFsDaq4OLMl4XrADLwoItdZfF
Subject: Re:  [PATCH] libceph: make calc_target() set t->paused, not just
 clear it
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601050197

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDIyOjM0ICswMTAwLCBJbHlhIERyeW9tb3Ygd3JvdGU6DQo+
IEN1cnJlbnRseSBjYWxjX3RhcmdldCgpIGNsZWFycyB0LT5wYXVzZWQgaWYgdGhlIHJlcXVlc3Qg
c2hvdWxkbid0IGJlDQo+IHBhdXNlZCBhbnltb3JlLCBidXQgZG9lc24ndCBldmVyIHNldCB0LT5w
YXVzZWQgZXZlbiB0aG91Z2ggaXQncyBhYmxlIHRvDQo+IGRldGVybWluZSB3aGVuIHRoZSByZXF1
ZXN0IHNob3VsZCBiZSBwYXVzZWQuICBTZXR0aW5nIHQtPnBhdXNlZCBpcyBsZWZ0DQo+IHRvIF9f
c3VibWl0X3JlcXVlc3QoKSB3aGljaCBpcyBmaW5lIGZvciByZWd1bGFyIHJlcXVlc3RzIGJ1dCBk
b2Vzbid0DQo+IHdvcmsgZm9yIGxpbmdlciByZXF1ZXN0cyAtLSBzaW5jZSBfX3N1Ym1pdF9yZXF1
ZXN0KCkgZG9lc24ndCBvcGVyYXRlDQo+IG9uIGxpbmdlciByZXF1ZXN0cywgdGhlcmUgaXMgbm93
aGVyZSBmb3IgbHJlcS0+dC5wYXVzZWQgdG8gYmUgc2V0Lg0KPiBPbmUgY29uc2VxdWVuY2Ugb2Yg
dGhpcyBpcyB0aGF0IHdhdGNoZXMgZG9uJ3QgZ2V0IHJlZXN0YWJsaXNoZWQgb24NCj4gcGF1c2Vk
IC0+IHVucGF1c2VkIHRyYW5zaXRpb25zIGluIGNhc2VzIHdoZXJlIHJlcXVlc3RzIGhhdmUgYmVl
biBwYXVzZWQNCj4gbG9uZyBlbm91Z2ggZm9yIHRoZSAocGF1c2VkKSB1bndhdGNoIHJlcXVlc3Qg
dG8gdGltZSBvdXQgYW5kIGZvciB0aGUNCj4gc3Vic2VxdWVudCAocmUpd2F0Y2ggcmVxdWVzdCB0
byBlbnRlciB0aGUgcGF1c2VkIHN0YXRlLiAgT24gdG9wIG9mIHRoZQ0KPiB3YXRjaCBub3QgZ2V0
dGluZyByZWVzdGFibGlzaGVkLCByYmRfcmVyZWdpc3Rlcl93YXRjaCgpIGdldHMgc3R1Y2sgd2l0
aA0KPiByYmRfZGV2LT53YXRjaF9tdXRleCBoZWxkOg0KPiANCj4gICByYmRfcmVnaXN0ZXJfd2F0
Y2gNCj4gICAgIF9fcmJkX3JlZ2lzdGVyX3dhdGNoDQo+ICAgICAgIGNlcGhfb3NkY193YXRjaA0K
PiAgICAgICAgIGxpbmdlcl9yZWdfY29tbWl0X3dhaXQNCj4gDQo+IEl0J3Mgd2FpdGluZyBmb3Ig
bHJlcS0+cmVnX2NvbW1pdF93YWl0IHRvIGJlIGNvbXBsZXRlZCwgYnV0IGZvciB0aGF0IHRvDQo+
IGhhcHBlbiB0aGUgcmVzcGVjdGl2ZSByZXF1ZXN0IG5lZWRzIHRvIGVuZCB1cCBvbiBuZWVkX3Jl
c2VuZF9saW5nZXIgbGlzdA0KPiBhbmQgYmUga2lja2VkIHdoZW4gcmVxdWVzdHMgYXJlIHVucGF1
c2VkLiAgVGhlcmUgaXMgbm8gY2hhbmNlIGZvciB0aGF0DQo+IGlmIHRoZSByZXF1ZXN0IGluIHF1
ZXN0aW9uIGlzIG5ldmVyIG1hcmtlZCBwYXVzZWQgaW4gdGhlIGZpcnN0IHBsYWNlLg0KPiANCj4g
VGhlIGZhY3QgdGhhdCByYmRfZGV2LT53YXRjaF9tdXRleCByZW1haW5zIHRha2VuIG91dCBmb3Jl
dmVyIHRoZW4NCj4gcHJldmVudHMgdGhlIGltYWdlIGZyb20gZ2V0dGluZyB1bm1hcHBlZCAtLSAi
cmJkIHVubWFwIiB3b3VsZCBpbmV2aXRhYmx5DQo+IGhhbmcgaW4gRCBzdGF0ZSBvbiBhbiBhdHRl
bXB0IHRvIGdyYWIgdGhlIG11dGV4Lg0KPiANCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gUmVwb3J0ZWQtYnk6IFJhcGhhZWwgWmltbWVyIDxyYXBoYWVsLnppbW1lckB0dS1pbG1lbmF1
LmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBJbHlhIERyeW9tb3YgPGlkcnlvbW92QGdtYWlsLmNvbT4N
Cj4gLS0tDQo+ICBuZXQvY2VwaC9vc2RfY2xpZW50LmMgfCAxMSArKysrKysrKystLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9uZXQvY2VwaC9vc2RfY2xpZW50LmMgYi9uZXQvY2VwaC9vc2RfY2xpZW50LmMNCj4g
aW5kZXggMWE3YmUyZjYxNWRjLi42MTBlNTg0NTI0ZDEgMTAwNjQ0DQo+IC0tLSBhL25ldC9jZXBo
L29zZF9jbGllbnQuYw0KPiArKysgYi9uZXQvY2VwaC9vc2RfY2xpZW50LmMNCj4gQEAgLTE1ODYs
NiArMTU4Niw3IEBAIHN0YXRpYyBlbnVtIGNhbGNfdGFyZ2V0X3Jlc3VsdCBjYWxjX3RhcmdldChz
dHJ1Y3QgY2VwaF9vc2RfY2xpZW50ICpvc2RjLA0KPiAgCXN0cnVjdCBjZXBoX3BnX3Bvb2xfaW5m
byAqcGk7DQo+ICAJc3RydWN0IGNlcGhfcGcgcGdpZCwgbGFzdF9wZ2lkOw0KPiAgCXN0cnVjdCBj
ZXBoX29zZHMgdXAsIGFjdGluZzsNCj4gKwlib29sIHNob3VsZF9iZV9wYXVzZWQ7DQo+ICAJYm9v
bCBpc19yZWFkID0gdC0+ZmxhZ3MgJiBDRVBIX09TRF9GTEFHX1JFQUQ7DQo+ICAJYm9vbCBpc193
cml0ZSA9IHQtPmZsYWdzICYgQ0VQSF9PU0RfRkxBR19XUklURTsNCj4gIAlib29sIGZvcmNlX3Jl
c2VuZCA9IGZhbHNlOw0KPiBAQCAtMTY1NCwxMCArMTY1NSwxNiBAQCBzdGF0aWMgZW51bSBjYWxj
X3RhcmdldF9yZXN1bHQgY2FsY190YXJnZXQoc3RydWN0IGNlcGhfb3NkX2NsaWVudCAqb3NkYywN
Cj4gIAkJCQkgJmxhc3RfcGdpZCkpDQo+ICAJCWZvcmNlX3Jlc2VuZCA9IHRydWU7DQo+ICANCj4g
LQlpZiAodC0+cGF1c2VkICYmICF0YXJnZXRfc2hvdWxkX2JlX3BhdXNlZChvc2RjLCB0LCBwaSkp
IHsNCj4gLQkJdC0+cGF1c2VkID0gZmFsc2U7DQo+ICsJc2hvdWxkX2JlX3BhdXNlZCA9IHRhcmdl
dF9zaG91bGRfYmVfcGF1c2VkKG9zZGMsIHQsIHBpKTsNCj4gKwlpZiAodC0+cGF1c2VkICYmICFz
aG91bGRfYmVfcGF1c2VkKSB7DQoNCkRvIHdlIG5lZWQgZG91dCgpIG1lc3NhZ2UgaGVyZSBhcyBz
eW1tZXRyaWMgdG8gdGhlIGFkZGVkIG9uZT8NCg0KPiAgCQl1bnBhdXNlZCA9IHRydWU7DQo+ICAJ
fQ0KPiArCWlmICh0LT5wYXVzZWQgIT0gc2hvdWxkX2JlX3BhdXNlZCkgew0KPiArCQlkb3V0KCIl
cyB0ICVwIHBhdXNlZCAlZCAtPiAlZFxuIiwgX19mdW5jX18sIHQsIHQtPnBhdXNlZCwNCj4gKwkJ
ICAgICBzaG91bGRfYmVfcGF1c2VkKTsNCj4gKwkJdC0+cGF1c2VkID0gc2hvdWxkX2JlX3BhdXNl
ZDsNCj4gKwl9DQo+ICsNCj4gIAlsZWdhY3lfY2hhbmdlID0gY2VwaF9wZ19jb21wYXJlKCZ0LT5w
Z2lkLCAmcGdpZCkgfHwNCj4gIAkJCWNlcGhfb3Nkc19jaGFuZ2VkKCZ0LT5hY3RpbmcsICZhY3Rp
bmcsDQo+ICAJCQkJCSAgdC0+dXNlZF9yZXBsaWNhIHx8IGFueV9jaGFuZ2UpOw0KDQpMb29rcyBn
b29kLg0KDQpSZXZpZXdlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGli
bS5jb20+DQoNClRoYW5rcywNClNsYXZhLg0K

