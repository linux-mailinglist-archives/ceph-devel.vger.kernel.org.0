Return-Path: <ceph-devel+bounces-4267-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A10CFAE4F
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 21:20:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9639130B239F
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 20:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E9C2877CD;
	Tue,  6 Jan 2026 20:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rS95z212"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A28E26A09B
	for <ceph-devel@vger.kernel.org>; Tue,  6 Jan 2026 20:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767730452; cv=fail; b=f/iLhuxCT9f4HZ3rA8uklICvizJ6ygnpzXj9jId664lgMmll6snGoRPUzvGVlot1ZiZFQdWdYSAKuHCkLiJw5XDF3M/n6h/5XiUcQT73Se+ajuV0ANZZI4t3REPUvtCwrD0F6Dy9i93d/pW6MoDtJuGRtvkeQXqB6rNJ8cX7xVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767730452; c=relaxed/simple;
	bh=vGmBrxrq2vYr8/F2ogz+Q3G+yI3KfZctVakN3QZmmFs=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=m1pScMKl3niEpEBRdzdePRG+1+iTumGr3Vm/Jig39603KEDQ5anwyBHEZmzwP3GVJo0nVi//67wWONsuYbx9TBXXIORxC6yde2YJ56CCTZFHffpVok0PErwIa7M0L83aNr0xUiGvSk2N9LsipCb9IllKkqLp6UISv0FzXAxNT8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rS95z212; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 606GKm4P024492;
	Tue, 6 Jan 2026 20:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=vGmBrxrq2vYr8/F2ogz+Q3G+yI3KfZctVakN3QZmmFs=; b=rS95z212
	/Y3hXUz8M/kvL3AAJJkJz+UT1YtqVEtC+DioysVtZuO89+gQNZg6n5z8y+i+H5f9
	L0H2syh24FiCGtc+R009OTiQPE4PCVFGc+uAaDRfK+W25OA3vkyYOB/hBVWrqzgr
	5gLS3g95yvrjovizNmVfJCpF0aXGynHqMhZx5A6XVFL+lKlgyRxnJwtfW/lZBD5b
	yNmryopLTekXnfRZyt7A0QFuTqNu8qhrXr83nx3D25m5fT5yLCUbnArIfjAW+nWh
	theo3V5PfcZk3B51hLQtwJ/ph9gavFavD8wOJzyhozPIoKo5BjOjHv1WSppWEiXO
	5QShr9XG+dgORg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4beshevv82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jan 2026 20:13:51 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 606KDoqe001082;
	Tue, 6 Jan 2026 20:13:50 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012046.outbound.protection.outlook.com [52.101.53.46])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4beshevv7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jan 2026 20:13:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ilqANwN4d+30KgPo6+Pw+iFNsaYbaP0pxaay5PbqcSx4suKu+nb+dWaok2nxmyTD5xCJC1NQSms+FXlkZcP9JSRUl78i74NrRw1hXjQ0jpx7/EGoiS05/2VhMx64WYELNQUsrpY4ZERZu6UD0Fnv1wnXgv05kQMvz2zhMl43wkjL8mq3og9QcMjrr6LNUshsOFdewwL//A8zMUFdaVpuQl6PccnHc9DFK0P5kdfMctARPX85WNJ04XhMxOanwCR+6QCuFB3hcLBsvZ2m8CN0d9oIX7i+XQx2hN1NKHqMdMIdFXzfbciuPuamybTJErDIrPlUufSdNQdbGPzmaYyaLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGmBrxrq2vYr8/F2ogz+Q3G+yI3KfZctVakN3QZmmFs=;
 b=nU6c117ImkRi97x5skqE/sTK0uBNudSRDh9aaAqzhnvTkvLLYm+R2p85RwDwkLonFB5GfVN5CQ+XWN0tde57GF5F+yYAqONpcAOlOvj9i00EKgH992hRqQ/7jbXlsffFYP92LLtcCtbB0iPna+eQ4h4vasFB2TZGESpTI1SLV2uG19OZHpwxMiNCs3y4DdrQeiu+82KFF/a/kljxH38gWgpUUEiRpbG2o4xGP1d5UrhtctQEnBkISj+HDn2P6ik8sVA6pGZ+RgVtBNK08qOSKdaaOmzThPtHReXzlkZM97qbgkV2xr5hr2fH0wysyMlBCGfkKMuOPCF8PRqJ+tGXzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS0PR15MB5941.namprd15.prod.outlook.com (2603:10b6:8:120::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 20:13:35 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 20:13:35 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethanwu@synology.com" <ethanwu@synology.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "ethan198912@gmail.com"
	<ethan198912@gmail.com>
Thread-Topic: [EXTERNAL] RE: [PATCH 2/2] ceph: fix snapshot context missing in
 ceph_uninline_data
Thread-Index: AQHcMdwlXbwCI2FZRk6YgpGCYjPEOrSsELiAgADzYoCAKtaZAIBuU3IA
Date: Tue, 6 Jan 2026 20:13:34 +0000
Message-ID: <ca836a4e5a1fadf6fa64e10e41f08b7157c2d2c9.camel@ibm.com>
References: <20250925104228.95018-1-ethanwu@synology.com>
		 <20250925104228.95018-3-ethanwu@synology.com>
		 <a16d910c-4838-475f-a5b1-a47323ece137@Mail>
		 <b7d93760bc06a4ca6b27f9043cb8310898cf48a4.camel@ibm.com>
		 <ec7440fbf1411b76a1a56e3511e4463716614cf2.camel@ibm.com>
		 <1084d2db-580a-417b-a99c-cbde647fd249@Mail>
	 <05735ecdb98feb50bd5edfa6b9910e4c375d6e6a.camel@ibm.com>
In-Reply-To: <05735ecdb98feb50bd5edfa6b9910e4c375d6e6a.camel@ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS0PR15MB5941:EE_
x-ms-office365-filtering-correlation-id: d2b67d32-7567-4243-815e-08de4d601232
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|14052099004|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VEIvdzhzZmphMEZVWmVvK1dXaE5xK09xOGloZm5aOWVrVUl4WDg3TEVaSDRU?=
 =?utf-8?B?dmd5ZDI5cVNNa0RDUm5qajFIM3JXU1B1My9jZUtZU0ZVK3Y1MFNuTGs5WVRV?=
 =?utf-8?B?bHNoWTgyTzNtaCtUTVlYVXFCTDQ2dVNKUzN0R3FNQW8wMmw1cHNVT3ZWaWVD?=
 =?utf-8?B?RGVtMm8xdnFEb1dqdkRTTE9JK3lLUzVqOGZsbVRGWHV3S3lSVVBTdytMbXZM?=
 =?utf-8?B?c2NpbE9jRzZjaGszWC9uREIzNFhjZ0RMZjJSK3A2UHhWeGdNekc0Uk5iSWQv?=
 =?utf-8?B?VG5JNEZwOGZxUVdRV2lZWWZRQjVUM0hWZ3ExYUFzM2dIN29paVA4OGQrc0dk?=
 =?utf-8?B?NEFrNzdmWUpQYmswY29BSTFMd2daQ0FLU09NaWJocklHVlR6RGxGYnM3VW9v?=
 =?utf-8?B?MmpxS08zY3pkcWMxazFNSkFoeGFNQkc1RHRvT2dmY0s4M0FWdDFUMUVUYjlI?=
 =?utf-8?B?eUhLRUptWmkvMENOdk5ZUy85amJ3ZzNENmttUlVqQkNqeGdHd08wODVhd1BS?=
 =?utf-8?B?STZRVmJ0dURkcmZVcUx5MzZkNVQ1Ui9iM3dkL084N09pSmFueGFCV0k1VGpS?=
 =?utf-8?B?WFZzMmg0MEl4T2dWckltc1BZUDlLLzYvSW5MN1BwTnpZdkpFQlVmL1dRbFg0?=
 =?utf-8?B?SkZ2N2RSbFNCNlNIeU1DaHNocEtSc1FVMWF4TGJmUWdtRHRpSjdveUJSeHR0?=
 =?utf-8?B?QWVZVTNvWVhHZDhiN0xLVW1QMjB1eFpUNStZZXJXZnJjSUVGRXdJMXBsZnQ1?=
 =?utf-8?B?cVFvYjlMUmI4cVN2NCtESHRMQ2gwcUhvanRsRWFCMVpLUm8zaWZScGRVY3lm?=
 =?utf-8?B?VGE0RVF5eHIrbFlaUHRsNENoeG9lZG15R2hJTDBZQUhpajhEMVVoN1lhM0dj?=
 =?utf-8?B?S1FmWjNIaDdGTXczZFRwVHVuVXNsVFlxSEtqMk1MbE1hMUJsVW1keWRneFlS?=
 =?utf-8?B?aDFEMkZ3aCtDZ0VVT243cWFaQ203MzVpdUNsblkyOGlmZEpDdkFnTmpxRTU2?=
 =?utf-8?B?N3lIRFZCUG9lNG5uY3FRMkNCWW9YRnA4TzZ3eE93OGgwYy9CSDlKcldPQUJy?=
 =?utf-8?B?bDFMOTdJN0RISkFIeTlPOEF6VU5CRzA0dTF6NDByQVZxQ0gzU3ZVWHp2T3ZU?=
 =?utf-8?B?UUl5RW9xd2JxVFFheUVwbnpFWWFHRC8raW1TOEtqQm4yRms3TjF2QUYxODJv?=
 =?utf-8?B?b0FxMWxjNmZqRmZjSWpSRzNGQkdJcGZ2dEFyc1N3NFhvY2czR1ZPdW1iM0xt?=
 =?utf-8?B?TTRHMWk0Q2xOTHJjUTR1VndBMU9wSG5iMFBwUGRHbXVOK24wZmFBZG05OFdD?=
 =?utf-8?B?aUxSMXcvVHBJbXgrN0haSnNtKzhYcWhpbUlaTnFHclRKekQrR0VlWjA0NXcw?=
 =?utf-8?B?VEVWcGxGdEcweldSMUl5RnlucE1ZbXJSL2RjajNoUmkxRjB1UDkxMS9qYWtF?=
 =?utf-8?B?a3R6U0s1SnN3WWVaZVpOSWNGclNLU2N0bHBCcjg0dGM4cnd4RG5sellxcWxW?=
 =?utf-8?B?RnJsOURHQWdhMi8zWitKQ09JbjhrakZWNFFzdEJBM3Q3dlNsdE9oMGNGQzd3?=
 =?utf-8?B?dVI4NVNIQ2RidTNLejlJNkpIek5vU0pjUmlVc2V3SmRvRWJ0MzQweW04Yk5K?=
 =?utf-8?B?dTVyaFJ3M1RJTWR0dmlVU0V4T2xUMklyZm8wTG5CcG84aHFRZHhEUEIvTWtO?=
 =?utf-8?B?UG4wcjBCMHRjZDllazRhVmJXenQ5RStYaVp0TER0UnBMUWRhVnFseTczYy9z?=
 =?utf-8?B?Y0RwY3U3V2hkaytveTlMSEpFYXEzWnlTdExuZW5BY3k0L1pmMjUybWNMR2Vj?=
 =?utf-8?B?SU5hRzdIWVR2THpsdXhqOVlrckRzWWh0TW1jZ1FwK0d4UThZWkNnWGJKZWFx?=
 =?utf-8?B?NmhVbXlXa1I4bmlxWHVYYkVmWC9iQXoyc2hScGxKU04wdzM4d2RjdTZNMENn?=
 =?utf-8?B?aXErREx0RFJkTk54UFgxL05jd1VTa3RldVdzRkxZSHYzbmhCQkVlWWY5WEgw?=
 =?utf-8?B?M2kvRkhQYTd2c1J4RjJpZEY4UDFjdnZUVm1vNFpPNGJmNVozL3NjVWpiOG9a?=
 =?utf-8?Q?6Gp58K?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(14052099004)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Wm9PTi9iQjJGVVNXMzlScTE5WlR1S2UrWWpSOVg5bE1scld4b1ZONHdWTVJq?=
 =?utf-8?B?Z0x0eXlRNnlJVHZWUGFqQ0V3UTZicG5GSlZkYkt0bzhEcmordXRPUzNsMkNx?=
 =?utf-8?B?bHRsUnAxZ2NoS2NzVlRCdHNndDNQcTRxYlpaQk9mcmdWa1RJaFBPclNCdEJS?=
 =?utf-8?B?cGxpOW9RZ3Z0WWRpUDRDbmlJRjlNVGxSMFpTUCtaLzNaS050WTBQM1NXUDFq?=
 =?utf-8?B?TUFTazYrTjUyZU9MTmJpek5QY01PbU1TWnBQejgvazhHV1pWL3F5WUFBMzIx?=
 =?utf-8?B?VExMaFhxbzZnY09rZjlHdFE5c0oxNFpHK2xKajY2VHdFcXhFZ1crVVA0bXM0?=
 =?utf-8?B?UVAzUEpXVlhoL1d4TlEya3EwOTNvdkxiNDNIbHVYV2Y0WU1wblhId0lZUDVE?=
 =?utf-8?B?MzlERnE3cVp1eHNmL2t6dXNjUGFBakJjNmFjdVhncWg0OGtKa1NnSDRNQWdu?=
 =?utf-8?B?MjVGRWh2TVhDM1I5WkxUL3BCaDE2MjYxWkJqa0pRZCtjUG95RGd3SmFRdXV5?=
 =?utf-8?B?OTFhRFhEZzFKejdSY3FIdVpZKzNEUGJ5K29aWThsbjZWNGFacFQwRi95RUxm?=
 =?utf-8?B?NHlmYjljUW93WXIvSmlQY3B2cUJvdDZWaTFlZ1pkNlNBUExwQmdWQzM3VUx4?=
 =?utf-8?B?blR4aXloSXJjWkFZVkt1YWd0NTA2UkFQa01xaVJldWswUERGb2xaazhpQW9D?=
 =?utf-8?B?UTdlYTlzVURSMmYyQ0l4NTBDS2h6VHVpRk5EQS9QeTJBcytZZE5OdXZWUVdF?=
 =?utf-8?B?RW1jaGZZd0dFSTIva0UwRjFuZFl0Y0xob1VMVnY2VThkZm9meGFNbmkxZEx6?=
 =?utf-8?B?T1pIeC9lRXlVUDZkRHcvc1ZtenU4ZGlSVFkxWFFSNnp4di90REI2dzlCWlpW?=
 =?utf-8?B?VjFLa29VUnlIdWw0aDZjZEEraXBGbTJnalJzWVZFbFIzZ1h6bXpFRGdoWnNz?=
 =?utf-8?B?UlZndW9La0x2bmx4SWkraFk3MFJlQzU5MSsvVXpaZWc5cU9JYTF4YWhlSHZi?=
 =?utf-8?B?S2tvZm0yYmE1Q3ZnUUVtNUZGN3FvQlRzeWlYVGdaUmVNMHBlZ2xwK0NrUnhl?=
 =?utf-8?B?VVlZSk4rOGg1czNlRjhqVEZibkZPUmM4MjIrRXo5MEQzQjdvL1FNZmRjYXh3?=
 =?utf-8?B?aUo1bU5yR2pGdVVJYUw1WFk4ZUZoR1Myd3ZOdzJEOE4xVkZ3VDNuM2FxY0VE?=
 =?utf-8?B?NTRUYVdwa2VscmRXWUozeEFQVzhhVjdRVnBoRk5TOTlUMHJESmUvSnk5OWk0?=
 =?utf-8?B?bHM2emRhbUZXc1g0Q2hUME1JcHZrN05VcndCc2cxaXdzdUJETTVWMlI2a0J2?=
 =?utf-8?B?cDFrK3o2bHBoSWYyNkpIK3Z5Y3U0SWQrV3QyZWRLNjVaUzlGakQyZDFESjVD?=
 =?utf-8?B?MjNtVXBTVlg0b2xiN0E4ejBIczUxOHFTVys0VGxKZTZEWHdxYS9EZjZvTXZ6?=
 =?utf-8?B?S1NJbW9qcG9hbnJnZGFudWdYYSt3SDFrWEJOWlFubU9qMG1QMHVya09sc2VY?=
 =?utf-8?B?SFJ5azVlbElPRVlYRTJWOU85dExZSGU5aVdRMCtRWXRPUDRMNkNoQ08wdUUr?=
 =?utf-8?B?bldSRC94dFdYYjB5MHQzR1Q4YVFtd0ZQZU1qNzE5am1vSVJtbzVySmNOU2sx?=
 =?utf-8?B?WWwwV01Eb2NHU1czcXU3Tk05NDI2dXlud0lQVFZZakQwMDE0SXRpV21iSCtv?=
 =?utf-8?B?MHdlUi8xS1JYS0Vhd0xEY3VJTlA0UGZpb3BPdmhDMGNnUlhwaEE0R2lnSjdn?=
 =?utf-8?B?S21PNEFwWUNqbjJHTUtwNmNNTVpyS0xRQm1hbnp0REJUaWRaWWRmdzdRbXhE?=
 =?utf-8?B?eDFpb0xPcGNMeXFEeUNsT1BoZU42WkxGYytHOWY5M3JyN3kyWGZSWFR5Lzdp?=
 =?utf-8?B?ZWlzbVhad3d2WGtEQ2N5b2tncDR0dVJ0Z1ZIY1k3S3V2d3gyQ2xPT0xUTFl2?=
 =?utf-8?B?ckwyTVB2UnY4VW9nc3dTcDdMaVRxYWpJYzVYZHY0K3V4QVAwcUlBNW5WOUVt?=
 =?utf-8?B?ZVpPenVrQTIzYzlwYk5XcXVZR1RXMks3V0V4MHZHampCY2RIdzNhNUZwTC9u?=
 =?utf-8?B?SVljVENQSjhSVU9UcVBxeGVPTExVanNabVpIQ3lmWWJSUitoMCtKT0R1V2Iw?=
 =?utf-8?B?Wi93Zm9ZYS84bllnWGpwa1hXUS9aYmd3MDR1OXk3WkFqeTFMTzgvVnFsQ2ZG?=
 =?utf-8?B?dE9BdU1nT1RXNkdxc0I3dHVneVh3L0pEMTNrbkk5MFo2V1EwUEkwNERxOVVp?=
 =?utf-8?B?dFUrSWk1UHo4ZS9ncWhvdXJ1RUVZWVRFQXdLbFg0bERINmRLY1FneW80U0xr?=
 =?utf-8?B?MUh0YkQxSjFXUTNTcHRsdHpHVHFldGwrRmNwL0t2eGlPeWJkQTNTTlJNUkJE?=
 =?utf-8?Q?2xpLdv61cRTQf/LxsK6HYauWF1HuI1+YRU+oF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <377D5891123359408948053B1D8E8EDC@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b67d32-7567-4243-815e-08de4d601232
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2026 20:13:35.0202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L7Fory2eEJNvDrd/oqHR6GCT4yBNOh02kj2rcsYot3pujG5ZU2i3ofE5W/L8EF9pGRDPgPSPv/iF52G3cnkI4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB5941
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE3MSBTYWx0ZWRfX71b4SveH8M4m
 buqSOC9g7d3n9sCoaKNd8jKroX3L2H+AqcK2WLOqit2NjCqNMxgW7HK+1egBa6qcV8qURKXEPzE
 tQNUPexx1HjDDkoHE/a76NkFvU0wAWYatUAkCC7ApLCezzhq3ZUaxzQRiwH5iJ1djyT0T5lgCvz
 fK8gBoVh4lYTAmKebjdlNrtllHK9lYoyGWgaUI/yPe3YGMHyFBJjudHY1ZufqfxCDQ35reHA8t/
 hiYgWQXMZPaAXXTLY5Dq3ArOI7iAhNMOH/DubZ30ZBQB1wLNAuSO/W+ebjmDfNAUmnrBqC0Ws06
 KBRuKFGeBBAv6gb/W0DFYCmgW7ik32aVVQWCJL8IrrAmTzZiei2aapG6odl3vBv18he9nG1bqA5
 1llBv9KDLZ2hRPu7OQldlPOj0Qlqhl0oaa0nqQ69JnGHarmeYdoc+hsm6a4tWyTzBwYiYFkZ6Bx
 6CaWK1L7trGL3mTcl9A==
X-Proofpoint-GUID: z2A-V1DB0-086NJFxIscpZN64D1NzuA1
X-Proofpoint-ORIG-GUID: vdc-znAYauHSL3W5FucL3iexGFAPHpQ2
X-Authority-Analysis: v=2.4 cv=AOkvhdoa c=1 sm=1 tr=0 ts=695d6cff cx=c_pps
 a=H8Bh8Ha9hE1t7kEFpXBZew==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=_ALjxZ2P0XbPbB_FDt8A:9 a=QEXdDO2ut3YA:10
Subject: RE: [PATCH 2/2] ceph: fix snapshot context missing in
 ceph_uninline_data
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601060171

T24gVHVlLCAyMDI1LTEwLTI4IGF0IDE1OjI2ICswMDAwLCBWaWFjaGVzbGF2IER1YmV5a28gd3Jv
dGU6DQo+IE9uIFdlZCwgMjAyNS0xMC0wMSBhdCAxNzoxNSArMDgwMCwgZXRoYW53dSB3cm90ZToN
Cj4gPiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLuKAikR1YmV5a29A4oCKaWJtLuKAimNvbT4g
5pa8IDIwMjUtMTAtMDEgMDI64oCKNDQg5a+r6YGT77yaIE9uIFR1ZSwgMjAyNS0wOS0zMCBhdCAx
NTrigIozMCArMDgwMCwgZXRoYW53dSB3cm90ZTogPiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZh
LiBEdWJleWtvQCBpYm0uIGNvbT4g5pa8IDIwMjUtMDktMjcgMDU6IDUyIOWvq+mBk++8miBPbiBU
aHUsIDIwMjUtMDktMjUgYXQgMTg6IDQyICswODAwLCBldGhhbnd1DQo+ID4gDQo+ID4gVmlhY2hl
c2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+IOaWvCAyMDI1LTEwLTAxIDAyOjQ0
IOWvq+mBk++8mg0KPiA+ID4gT24gVHVlLCAyMDI1LTA5LTMwIGF0IDE1OjMwICswODAwLCBldGhh
bnd1IHdyb3RlOg0KPiA+ID4gPiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLuKAikR1YmV5a29A
4oCKaWJtLuKAimNvbT4g5pa8IDIwMjUtMDktMjcgMDU64oCKNTIg5a+r6YGT77yaIE9uIFRodSwg
MjAyNS0wOS0yNSBhdCAxODrigIo0MiArMDgwMCwgZXRoYW53dSB3cm90ZTogPiBUaGUgY2VwaF91
bmlubGluZV9kYXRhIGZ1bmN0aW9uIHdhcyBtaXNzaW5nIHByb3BlciBzbmFwc2hvdCBjb250ZXh0
ID4gaGFuZGxpbmcgZm9yIGl0cyBPU0Qgd3JpdGUgb3BlcmF0aW9ucy4gQm90aA0KPiA+ID4gPiDC
oA0KPiA+ID4gPiANCj4gPiA+ID4gVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGli
bS5jb20+IOaWvCAyMDI1LTA5LTI3IDA1OjUyIOWvq+mBk++8mg0KPiA+ID4gPiA+IE9uIFRodSwg
MjAyNS0wOS0yNSBhdCAxODo0MiArMDgwMCwgZXRoYW53dSB3cm90ZToNCj4gPiA+ID4gPiA+IFRo
ZSBjZXBoX3VuaW5saW5lX2RhdGEgZnVuY3Rpb24gd2FzIG1pc3NpbmcgcHJvcGVyIHNuYXBzaG90
IGNvbnRleHQNCj4gPiA+ID4gPiA+IGhhbmRsaW5nIGZvciBpdHMgT1NEIHdyaXRlIG9wZXJhdGlv
bnMuIEJvdGggQ0VQSF9PU0RfT1BfQ1JFQVRFIGFuZA0KPiA+ID4gPiA+ID4gQ0VQSF9PU0RfT1Bf
V1JJVEUgcmVxdWVzdHMgd2VyZSBwYXNzaW5nIE5VTEwgaW5zdGVhZCBvZiB0aGUgYXBwcm9wcmlh
dGUNCj4gPiA+ID4gPiA+IHNuYXBzaG90IGNvbnRleHQsIHdoaWNoIGNvdWxkIGxlYWQgdG8gdW5u
ZWNlc3Nhcnkgb2JqZWN0IGNsb25lLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBSZXByb2R1
Y2VyOg0KPiA+ID4gPiA+ID4gLi4vc3JjL3ZzdGFydC5zaCAtLW5ldyAteCAtLWxvY2FsaG9zdCAt
LWJsdWVzdG9yZQ0KPiA+ID4gPiA+ID4gLy8gdHVybiBvbiBjZXBoZnMgaW5saW5lIGRhdGENCj4g
PiA+ID4gPiA+IC4vYmluL2NlcGggZnMgc2V0IGEgaW5saW5lX2RhdGEgdHJ1ZSAtLXllcy1pLXJl
YWxseS1yZWFsbHktbWVhbi1pdA0KPiA+ID4gPiA+ID4gLy8gYWxsb3cgZnNfYSBjbGllbnQgdG8g
dGFrZSBzbmFwc2hvdA0KPiA+ID4gPiA+ID4gLi9iaW4vY2VwaCBhdXRoIGNhcHMgY2xpZW50LmZz
X2EgbWRzICdhbGxvdyByd3BzIGZzbmFtZT1hJyBtb24gJ2FsbG93IHIgZnNuYW1lPWEnIG9zZCAn
YWxsb3cgcncgdGFnIGNlcGhmcyBkYXRhPWEnDQo+ID4gPiA+ID4gPiAvLyBtb3VudCBjZXBoZnMg
d2l0aCBmdXNlLCBzaW5jZSBrZXJuZWwgY2VwaGZzIGRvZXNuJ3Qgc3VwcG9ydCBpbmxpbmUgd3Jp
dGUNCj4gPiA+ID4gPiA+IGNlcGgtZnVzZSAtLWlkIGZzX2EgLW0gMTI3LjAuMC4xOjQwMzE4IC0t
Y29uZiBjZXBoLmNvbmYgLWQgL21udC9teWNlcGhmcy8NCj4gPiA+ID4gPiA+IC8vIGJ1bXAgc25h
cHNob3Qgc2VxDQo+ID4gPiA+ID4gPiBta2RpciAvbW50L215Y2VwaGZzLy5zbmFwL3NuYXAxDQo+
ID4gPiA+ID4gPiBlY2hvICJmb28iID4gL21udC9teWNlcGhmcy90ZXN0DQo+ID4gPiA+ID4gPiAv
LyB1bW91bnQgYW5kIG1vdW50IGl0IGFnYWluIHVzaW5nIGtlcm5lbCBjZXBoZnMgY2xpZW50DQo+
ID4gPiA+ID4gPiB1bW91bnQgL21udC9teWNlcGhmcw0KPiA+ID4gPiA+ID4gbW91bnQgLXQgY2Vw
aCBmc19hQC5hPS8gL21udC9teWNlcGhmcy8gLW8gY29uZj0uL2NlcGguY29uZg0KPiA+ID4gPiA+
ID4gZWNobyAiYmFyIiA+PiAvbW50L215Y2VwaGZzL3Rlc3QNCj4gPiA+ID4gPiA+IC4vYmluL3Jh
ZG9zIGxpc3RzbmFwcyAtcCBjZXBoZnMuYS5kYXRhICQocHJpbnRmICIleFxuIiAkKHN0YXQgLWMg
JWkgL21udC9teWNlcGhmcy90ZXN0KSkuMDAwMDAwMDANCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+
ID4gd2lsbCBzZWUgdGhpcyBvYmplY3QgZG9lcyB1bm5lY2Vzc2FyeSBjbG9uZQ0KPiA+ID4gPiA+
ID4gMTAwMDAwMDAwMGEuMDAwMDAwMDAgKHNlcToyKToNCj4gPiA+ID4gPiA+IGNsb25laWQgc25h
cHMgICBzaXplICAgIG92ZXJsYXANCj4gPiA+ID4gPiA+IDIgICAgICAgMiAgICAgICA0ICAgICAg
IFtdDQo+ID4gPiA+ID4gPiBoZWFkICAgIC0gICAgICAgOA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gPiBidXQgaXQncyBleHBlY3RlZCB0byBzZWUNCj4gPiA+ID4gPiA+IDEwMDAwMDAwMDAwLjAw
MDAwMDAwIChzZXE6Mik6DQo+ID4gPiA+ID4gPiBjbG9uZWlkIHNuYXBzICAgc2l6ZSAgICBvdmVy
bGFwDQo+ID4gPiA+ID4gPiBoZWFkICAgIC0gICAgICAgOA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gPiBzaW5jZSB0aGVyZSdzIG5vIHNuYXBzaG90IGJldHdlZW4gdGhlc2UgMiB3cml0ZXMNCj4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IE1heWJlLCBJIGFtIGRvaW5nIHNvbWV0
aGluZyB3cm9uZyBoZXJlLiBCdXQgSSBoYXZlIHRoZSBzYW1lIGlzc3VlIG9uIHRoZSBzZWNvbmQN
Cj4gPiA+ID4gPiBWaXJ0dWFsIE1hY2hpbmUgd2l0aCBhcHBsaWVkIHBhdGNoOg0KPiA+ID4gPiA+
IA0KPiA+ID4gPiA+IFZNMSAod2l0aG91dCBwYXRjaCk6DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
c3VkbyBjZXBoLWZ1c2UgLS1pZCBhZG1pbiAvbW50L2NlcGhmcy8NCj4gPiA+ID4gPiAvbW50L2Nl
cGhmcy90ZXN0LXNuYXBzaG90MyMgbWtkaXIgLi8uc25hcC9zbmFwMQ0KPiA+ID4gPiA+IC9tbnQv
Y2VwaGZzL3Rlc3Qtc25hcHNob3QzIyBlY2hvICJmb28iID4gLi90ZXN0DQo+ID4gPiA+ID4gdW1v
dW50IC9tbnQvY2VwaGZzDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gbW91bnQgLXQgY2VwaCA6LyAv
bW50L2NlcGhmcy8gLW8gbmFtZT1hZG1pbixmcz1jZXBoZnMNCj4gPiA+ID4gPiAvbW50L2NlcGhm
cy90ZXN0LXNuYXBzaG90MyMgZWNobyAiYmFyIiA+PiAuL3Rlc3QNCj4gPiA+ID4gPiAvbW50L2Nl
cGhmcy90ZXN0LXNuYXBzaG90MyMgcmFkb3MgbGlzdHNuYXBzIC1wIGNlcGhmc19kYXRhICQocHJp
bnRmICIleFxuIg0KPiA+ID4gPiA+ICQoc3RhdCAtYyAlaSAuL3Rlc3QpKS4wMDAwMDAwMA0KPiA+
ID4gPiA+IDEwMDAwMzEzY2IxLjAwMDAwMDAwOg0KPiA+ID4gPiA+IGNsb25laWQgc25hcHMgc2l6
ZSBvdmVybGFwDQo+ID4gPiA+ID4gNCA0IDQgW10NCj4gPiA+ID4gPiBoZWFkIC0gOA0KPiA+ID4g
PiA+IA0KPiA+ID4gPiA+IFZNMiAod2l0aCBwYXRjaCk6DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
Y2VwaC1mdXNlIC0taWQgYWRtaW4gL21udC9jZXBoZnMvDQo+ID4gPiA+ID4gL21udC9jZXBoZnMv
dGVzdC1zbmFwc2hvdDQjIG1rZGlyIC4vLnNuYXAvc25hcDENCj4gPiA+ID4gPiAvbW50L2NlcGhm
cy90ZXN0LXNuYXBzaG90NCMgZWNobyAiZm9vIiA+IC4vdGVzdA0KPiA+ID4gPiA+IHVtb3VudCAv
bW50L2NlcGhmcw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IG1vdW50IC10IGNlcGggOi8gL21udC9j
ZXBoZnMvIC1vIG5hbWU9YWRtaW4sZnM9Y2VwaGZzDQo+ID4gPiA+ID4gL21udC9jZXBoZnMvdGVz
dC1zbmFwc2hvdDQjIGVjaG8gImJhciIgPj4gLi90ZXN0DQo+ID4gPiA+ID4gL21udC9jZXBoZnMv
dGVzdC1zbmFwc2hvdDQjIHJhZG9zIGxpc3RzbmFwcyAtcCBjZXBoZnNfZGF0YSAkKHByaW50ZiAi
JXhcbiINCj4gPiA+ID4gPiAkKHN0YXQgLWMgJWkgLi90ZXN0KSkuMDAwMDAwMDANCj4gPiA+ID4g
PiAxMDAwMDMxM2NiMy4wMDAwMDAwMDoxMDAwMDMxM2NiMy4wMDAwMDAwMDoNCj4gPiA+ID4gPiBj
bG9uZWlkIHNuYXBzIHNpemUgb3ZlcmxhcA0KPiA+ID4gPiA+IDUgNSAwIFtdDQo+ID4gPiA+ID4g
aGVhZCAtIDQNCj4gPiA+ID4gDQo+ID4gPiA+IMKgDQo+ID4gPiA+IA0KPiA+ID4gPiBMb29rcyBs
aWtlIHRoZSBjbG9uZSBjb21lcyBmcm9tIHRoZSBmaXJzdCB0aW1lIHdlIGFjY2VzcyBwb29sLg0K
PiA+ID4gPiBjZXBoX3dyaXRlX2l0ZXINCj4gPiA+ID4gLS1jZXBoX2dldF9jYXBzDQo+ID4gPiA+
IC0tLS1fX2NlcGhfZ2V0X2NhcHMNCj4gPiA+ID4gLS0tLS0tY2VwaF9wb29sX3Blcm1fY2hlY2sN
Cj4gPiA+ID4gLS0tLS0tLS1fX2NlcGhfcG9vbF9wZXJtX2dldA0KPiA+ID4gPiAtLS0tLS0tLS1j
ZXBoX29zZGNfYWxsb2NfcmVxdWVzdA0KPiA+ID4gPiDCoA0KPiA+ID4gPiANCj4gPiA+ID4gSWYg
bm8gZXhpc3RpbmcgcG9vbCBwZXJtIGZvdW5kLCBpdCB3aWxsIHRyeSB0byByZWFkL3dyaXRlIHRo
ZSBwb29sIGlub2RlIGxheW91dCBwb2ludHMgdG8NCj4gPiA+ID4gYnV0IGNlcGhfb3NkY19hbGxv
Y19yZXF1ZXN0IGRvZXNuJ3QgcGFzcyBzbmFwYw0KPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+
IHNvIHRoZSBzZXJ2ZXIgc2lkZSB3aWxsIGhhdmUgYSB6ZXJvIHNpemUgb2JqZWN0IHdpdGggc25h
cCBzZXEgMA0KPiA+ID4gPiDCoA0KPiA+ID4gPiANCj4gPiA+ID4gbmV4dCB0aW1lIHdyaXRlIGFy
cml2ZXMsIHNpbmNlIHdyaXRlIGlzIGVxdWlwcGVkIHdpdGggc25hcCBzZXEgPjANCj4gPiA+ID4g
c2VydmVyIHNpZGUgd2lsbCBkbyBvYmplY3QgY2xvbmUuDQo+ID4gPiA+IMKgDQo+ID4gPiA+IA0K
PiA+ID4gPiBUaGlzIGNhbiBiZSBlYXNpbHkgcmVwcm9kdWNlLCB3aGVuIHRoZXJlIGFyZSBzbmFw
c2hvdHMoc28gd3JpdGUgd2lsbCBoYXZlIHNuYXAgc2VxID4gMCkuDQo+ID4gPiA+IFRoZSBmaXJz
dCB3cml0ZSB0byB0aGUgcG9vbCBlY2hvICJmb28iID4gL21udC9teWNlcGhmcy9maWxlDQo+ID4g
PiA+IHdpbGwgcmVzdWx0IGluIHRoZSBmb2xsb3dpbmcgb3V0cHV0DQo+ID4gPiA+IDEwMDAwMDAw
MDA5LjAwMDAwMDAwIChzZXE6Myk6DQo+ID4gPiA+IGNsb25laWQgc25hcHMgc2l6ZSBvdmVybGFw
DQo+ID4gPiA+IDMgMiwzIDAgW10NCj4gPiA+ID4gaGVhZCAtIDQNCj4gPiA+ID4gwqANCj4gPiA+
ID4gDQo+ID4gPiA+IEkgdGhpbmsgdGhpcyBjb3VsZCBiZSBmaXhlZCBieSB1c2luZyBhIHNwZWNp
YWwgcmVzZXJ2ZWQgaW5vZGUgbnVtYmVyIHRvIHRlc3QgcG9vbCBwZXJtIGluc3RlYWQgb2YgdXNp
bmcgdGhhdCBpbm9kZQ0KPiA+ID4gPiBJIGNoYW5nZSANCj4gPiA+ID4gY2VwaF9vaWRfcHJpbnRm
KCZyZF9yZXEtPnJfYmFzZV9vaWQsICIlbGx4LjAwMDAwMDAwIiwgY2ktPmlfdmluby5pbm8pOw0K
PiA+ID4gPiB1bmRlciB0byBfX2NlcGhfcG9vbF9wZXJtX2dldA0KPiA+ID4gPiBjZXBoX29pZF9w
cmludGYoJnJkX3JlcS0+cl9iYXNlX29pZCwgIiVsbHguMDAwMDAwMDAiLCBMTE9OR19NQVgpOw0K
PiA+ID4gPiB0aGUgdW5uZWNlc3NhcnkgY2xvbmUgd29uJ3QgaGFwcGVuIGFnYWluLg0KPiA+ID4g
PiDCoA0KPiA+ID4gPiANCj4gPiA+IA0KPiA+ID4gRnJhbmtseSBzcGVha2luZywgSSBkb24ndCBx
dWl0ZSBmb2xsb3cgdG8geW91ciBhbnN3ZXIuIDopIFNvLCBkb2VzIHBhdGNoIG5lZWRzDQo+ID4g
PiB0byBiZSByZXdvcmtlZD8gT3IgbXkgdGVzdGluZyBzdGVwcyBhcmUgbm90IGZ1bGx5IGNvcnJl
Y3Q/DQo+ID4gPiANCj4gPiA+IFRoYW5rcywNCj4gPiA+IFNsYXZhLg0KPiA+IA0KPiA+IMKgDQo+
ID4gSXQncyBhbm90aGVyIHBsYWNlIHRoYXQgbWlzc2VzIHNuYXBzaG90IGNvbnRleHQuDQo+ID4g
cG9vbCBwZXJtaXNzaW9uIGNoZWNrIGxpYmNlcGhmcyBhbmQga2VybmVsIGNlcGhmcyBkb2VzIG5v
dCBlcXVpcCBzbmFwc2hvdCBjb250ZXh0DQo+ID4gd2hlbiBpc3N1aW5nwqBDRVBIX09TRF9PUF9D
UkVBVEUgZm9yIHBvb2wgd3JpdGUgcGVybWlzc2lvbiBjaGVjay4NCj4gPiDCoA0KPiA+IFdoZW4g
a2VybmVsIGNlcGhmcyBjYWxswqBjZXBoX2dldF9jYXBzIG9ywqBjZXBoX3RyeV9nZXRfY2Fwcw0K
PiA+IGl0IG1heSBuZWVkwqAgY2VwaF9wb29sX3Blcm1fY2hlY2soaWYgbm8gcG9vbCBwZXJtaXNz
aW9uIGNoZWNrIGlzIGV2ZXIgZG9uZSBmb3IgdGhhdCBwb29sKS4NCj4gPiBjZXBoX3Bvb2xfcGVy
bV9jaGVjayB3aWxsIHRyeSB0byBpc3N1ZSBib3RoIHJlYWQgYW5kIHdyaXRlKHVzZSBDRVBIX09T
RF9PUF9DUkVBVEUsKSByZXF1ZXN0IG9uIHRhcmdldCBpbm9kZSB0byB0aGUgcG9vbCB0aGF0IGlu
b2RlIGJlbG9uZ3MgdG8NCj4gPiAoc2VlIGZzL2NlcGgvYWRkci5jOl9fY2VwaF9wb29sX3Blcm1f
Z2V0KQ0KPiA+IGl0IHVzZXPCoGNlcGhfb3NkY19hbGxvY19yZXF1ZXN0IHdpdGhvdXQgZ2l2aW5n
IHNuYXAgY29udGV4dCwNCj4gPiBzbyB0aGUgc2VydmVyIHNpZGUgd2lsbCBmaXJzdCBjcmVhdGUg
YW4gZW1wdHkgb2JqZWN0IHdpdGggbm8gc25hcHNob3Qgc2VxdWVuY2UuDQo+ID4gwqANCj4gPiB3
ZSdsbCBzZWUgdGhlIGZvbGxvd2luZyBvdXRwdXQgZnJvbcKgLi9iaW4vcmFkb3MgbGlzdHNuYXBz
IC1wIGNlcGhmcy5hLmRhdGEgJChwcmludGYgIiV4XG4iICQoc3RhdCAtYyAlaSAvbW50L215Y2Vw
aGZzL3Rlc3QpKS4wMDAwMDAwDQo+ID4gMTAwMDAwMDAwMzIuMDAwMDAwMDAgKHNlcTowKToNCj4g
PiBjbG9uZWlkwqAgc25hcHPCoCBzaXplIG92ZXJsYXANCj4gPiBoZWFkwqAgwqAgwqAgLcKgIMKg
IMKgIMKgIMKgIDANCj4gPiDCoA0KPiA+IExhdGVyIHdoZW4gZGF0YSBpcyB3cml0dGVuIGJhY2ss
IGl0IHdyaXRlIG9wIGlzIGVxdWlwcGVkIHdpdGggc25hcHNob3QgY29udGV4dC4NCj4gPiBjb21w
YXJlIHRoZSBzbmFwc2hvdCBpZCB3aXRoIHRoZSBvYmplY3Qgc25hcCBzZXENCj4gPiBPU0QgdGhp
bmtzIHRoZXJlJ3MgYSBzbmFwc2hvdCBhbmQgY2xvbmUgaXMgbmVlZGVkLg0KPiA+IMKgDQo+ID4g
Y2VwaC1mdXNlIC0taWQgYWRtaW4gL21udC9jZXBoZnMvDQo+ID4gL21udC9jZXBoZnMvdGVzdC1z
bmFwc2hvdDQjIG1rZGlyIC4vLnNuYXAvc25hcDENCj4gPiAvbW50L2NlcGhmcy90ZXN0LXNuYXBz
aG90NCMgZWNobyAiZm9vIiA+IC4vZHVtbXkgI2Vycm9yIG9uZQ0KPiA+IC9tbnQvY2VwaGZzL3Rl
c3Qtc25hcHNob3Q0IyBlY2hvICJmb28iID4gLi90ZXN0wqAgI2NvcnJlY3Qgb25lIGJlY2F1c2Ug
ZGF0YSBpcyBpbmxpbmVkLMKgDQo+ID4gwqANCj4gPiByYWRvcyBsaXN0c25hcHMgLXAgY2VwaGZz
X2RhdGEgJChwcmludGYgIiV4XG4iICQoc3RhdCAtYyAlaSAuL2R1bW15KSkuMDAwMDAwMDANCj4g
PiB3aWxsIHNlZQ0KPiA+IDEwMDAwMDAwMDMyLjAwMDAwMDAwIChzZXE6MCk6DQo+ID4gY2xvbmVp
ZMKgIHNuYXBzwqAgc2l6ZSBvdmVybGFwDQo+ID4gaGVhZMKgIMKgIMKgIC3CoCDCoCDCoCDCoCDC
oCAwDQo+ID4gYnV0DQo+ID4gcmFkb3MgbGlzdHNuYXBzIC1wIGNlcGhmc19kYXRhICQocHJpbnRm
ICIleFxuIiAkKHN0YXQgLWMgJWkgLi90ZXN0KSkuMDAwMDAwMDANCj4gPiBzaG93cyAoMikgTm8g
c3VjaCBmaWxlIG9yIGRpcmVjdG9yeQ0KPiA+IHNlZWluZyBFTk9FTlQgaXMgY29ycmVjdCBiZWhh
dmlvciBiZWNhdXNlIGRhdGEgaXMgaW5saW5lZC4NCj4gPiDCoA0KPiANCj4gU29ycnksIEkgd2Fz
IGluIHBlcnNvbmFsIHRyaXAgdGhlIGxhc3QgdGhyZWUgd2Vla3MuIFNvLCBJIHdhc24ndCBhYmxl
IHRvIHRha2UgYQ0KPiBkZWVwZXIgbG9vayBpbnRvIHRoaXMuDQo+IA0KPiBJIHN0aWxsIGNhbm5v
dCBjb25maXJtIHRoYXQgdGhlIHBhdGNoIGZpeGVzIHRoZSBpc3N1ZS4gVGhlIHBhdGNoJ3MgY29t
bWl0DQo+IG1lc3NhZ2UgY29udGFpbnMgZXhwbGFuYXRpb24gb2Ygc3RlcHMgYW5kIHRoZSBleHBl
Y3RlZCBvdXRjb21lLiBBbmQgSSBzZWUgdGhlDQo+IGRpZmZlcmVudCBvdXRjb21lLCB0aGlzIGlz
IHdoeSBJIGNhbm5vdCBjb25maXJtIHRoYXQgcGF0Y2ggZml4ZXMgdGhlIGlzc3VlLiBJDQo+IGJl
bGlldmUgdGhhdCB0aGUgY29tbWl0IG1lc3NhZ2UgcmVxdWlyZXMgbW9yZSBjbGVhciBleHBsYW5h
dGlvbiBvZiBzdGVwcyB0aGF0IEkNCj4gY2FuIHJlcHJvZHVjZSBhbmQgdG8gc2VlIHRoZSBzYW1l
IHJlc3VsdCBhcyBleHBlY3RlZCBvdXRjb21lLg0KPiANCg0KVW5mb3J0dW5hdGVseSwgdGhlIGRp
c2N1c3Npb24gaGFzIHN0b3BwZWQgdW5leHBlY3RlZGx5LiBJJ3ZlIHRlc3RlZCB0aGUgcGF0Y2gN
CmFuZCBJIGhhdmVuJ3QgZGlzY292ZXJlZCBhbnkgaXNzdWUgd2l0aCB0aGUgcGF0Y2guIFNvLCBJ
IGJlbGlldmUgdGhhdCB3ZSBjYW4NCnRha2UgdGhpcyBwYXRjaCBhcyBpdCBpcyBiZWNhdXNlIGl0
IGlzIGdvb2QgZml4LCBhbnl3YXkuDQoNClJldmlld2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28g
PFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NClRlc3RlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxT
bGF2YS5EdWJleWtvQGlibS5jb20+DQoNClRoYW5rcywNClNsYXZhLg0K

