Return-Path: <ceph-devel+bounces-2283-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 597499EB918
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2024 19:13:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73594167B91
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2024 18:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A238204698;
	Tue, 10 Dec 2024 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mOCtTlNQ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD2786320
	for <ceph-devel@vger.kernel.org>; Tue, 10 Dec 2024 18:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733854398; cv=fail; b=W4weFxduVrDZvY9OwhQ436VLX/KDhsWnzaMeQP6kKXkwIU48q8d/lJ/lLPAS1mcHAzBmr/5WXPEcG/ToQOCCUp/4Rgq6yrAncaQ+iddXuyB/VlAbluqiSUjf7B691BkDD2TbGK/aCpyM7GC5+ntu2VK+L0EV/6p13BxeV5QSObQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733854398; c=relaxed/simple;
	bh=w80maztWrEnyL+ckNeEr87KnIvI/yy9NuBoH1SJw178=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=qQv9O8njgAutgji2grSN0+QukigNIeisTHNIc8vXdWIc0Dy/QZVxB+6T67lpdrPV5nA6eaDgB+bNkyrrh8fq9YOhMm+nE3GS8F2407pMr9qmwhHUdDU2noSESJOJsTF5fZVtoAOYH3nafaDYMPnPO2kNBTa7yM7sP8rOGH3YQEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mOCtTlNQ; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BADrad7025948
	for <ceph-devel@vger.kernel.org>; Tue, 10 Dec 2024 18:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=rr6scy5hSs0Iq4cYRVdnC7dOSt4iC2BDP5a+la3EM3I=; b=mOCtTlNQ
	RlIWVrIqr+d0hWN6oEtz9KEI2qjS5/258OdjBOUBx1Pqj8R3bZjajf1LOUY9YBeg
	D8DWonil2oumO+vvajGsBQt25Skkyk5lOwaPmNKSHsD+UY/3HT6yuRJB2kzrWQvY
	Ks8Dso8sW0FvIXgWqrAwIXi69mYihOsY2gVxr1qdjEPdfDOMjPEPC2+pcn8B6mCo
	WES20CAEHVfl9McYl+SUlLtReCwB1f5Ii3MAtlQnZr+c9eZWjfeM7F5lj1/PBkS4
	uE6+i9DIiWvwU5Cvwu3ksqoP4OSUSlnYy9jRso4kigviai5AMIcHIs0+hQJoFrzt
	FWBpaxmaBEGQTA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cbsq811r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Tue, 10 Dec 2024 18:13:15 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BAIDFJP001544;
	Tue, 10 Dec 2024 18:13:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cbsq811n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 18:13:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qDrNegs3nJlvA5sfp6CzTFY4q51foI1Hx+TJ+UZU70Jpvgu9lrtlBfWWmvY7910ptik3S1pI4yizMy8/YwIA0OPLdTGj6u47ljWhmAlP84x7+HmaJbk33qpo7GmgyJcGkvAVNecrbSD/2viOSs+m/OOjuOpM2OVbesGLinibaU6mqh28ryxRDObO2dGZQ5CYYPHTsOQHc29ObEXKxs+69S/icd8LV3RaP6UMLEHnPb4tWiypvNCmSjznRzdWa03LCXH8t8bp3XpT9qVv72a7ZfRhUftVbUgvYTjx7GmF+0VXJX4ZQ22kY5gs92rH6lfbsPCbmGIKWaxri8tvQNTCsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHZysM0r5NM9vUxCk6LyjDobUMjRYDxTGzdc5j+srkU=;
 b=xvCDwL1e0uc0S86RCv8J+5d8QBSfYGFXJBeKMZCoG05Hw68zFkE4O5xlwkAq62NasTpfti2KOFobN+rMoazilyoSaU/fSTYj2ZkmlTnVTaR/O4S71uVFy4J5xQ9QarajnPr/KaIzHpcRk8kzn0zF7Ew2DhBbZLpt0eq4BxVSZrzwIcrCQBFFXUj2gyIc8RNIycGMv7SmU7CePtlWWEBb7n6NFYHGiz73ms+Ex3Fd5F+AVihOT9l+EO8rO/cwB+tLQo/ASF5ioGPTZOPjbSyjiQgN7iuKlIEaEJ3/l/anhvfbVZt/ZEH8bhwHJA7VFm1zlkmWMAKXdEyHoLzj6ePxsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BL1PR15MB5362.namprd15.prod.outlook.com (2603:10b6:208:391::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.14; Tue, 10 Dec
 2024 18:13:11 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 18:13:11 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] ceph: improve error handling and
 short/overflow-read logic in __ceph_sync_read()
Thread-Index: AQHbSi+vi5stKyjnU0KFlVxLkP8mXLLfyfcA
Date: Tue, 10 Dec 2024 18:13:11 +0000
Message-ID: <547b3a59c43751dfa793fef35a66f03fafea84ea.camel@ibm.com>
References: <20241209114359.1309965-1-amarkuze@redhat.com>
In-Reply-To: <20241209114359.1309965-1-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BL1PR15MB5362:EE_
x-ms-office365-filtering-correlation-id: b1cf705a-fddd-40ac-046e-08dd19464e7d
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z1BqMkNIRmE3akp1bTFNUjFkWjB4c0xFb1V0RjdUSkJHVWZwRC9kMGtDWjBZ?=
 =?utf-8?B?Ykp6TUswelJRZlJUNUpHLytON2ZIU0FpM005VmVXWlRjN0Y1ZmNwSm5ZWDl4?=
 =?utf-8?B?Z2o0ZGFCcFRCY0hNOWJzRkxUQU1aSTFhdUdWOHhSalR2YVF1ZjBiU2NzZER0?=
 =?utf-8?B?WklKanh5Q0pQdkpyL2lIUHZlN2J2UGl2ZW5VblRrazJ0NE1RS3Nxd3l0b3Zy?=
 =?utf-8?B?ZFQ2ZzdQeC9ac1YxT2tUVkc1RzNzQWZrT05VYlpIZk5xYXl5elc0WnBJVkNw?=
 =?utf-8?B?SE9lYXNvWjhMZGlYWWNhaFFCR2cycDIvdTRacGFRYWJjd3ZwVUthTmpDdDUx?=
 =?utf-8?B?Vm1leHBjdDc3STZBdVNZbTdxbEVaOE5Wa1hDY1NScnYzem00aDY2VmtQbDZ6?=
 =?utf-8?B?N3BXNVd5SnpYV2tPa3RBczBRRGJWdm04cXRTMWFvNEEvSE5JRFFNQUdqZ3lB?=
 =?utf-8?B?c29WcGNQMXRjZFRIdmFHRys4RFZOMU84eWgwdnJIeEY2NUhXQUhQVmY2Q3VV?=
 =?utf-8?B?elRKNlRjYy9OK25ZOVZLQk9BMTByVHlmUnpPdkhkTU1iWFFDcERTRWpNUytW?=
 =?utf-8?B?ZTZIcTBoUXpWMkZ0REV1bHVqVUdBdTJuOVFSQjNsVGdpOW42Ny9JQjU4V2x0?=
 =?utf-8?B?RG9SWGU4WjYvaDc3SSt2dmxKS01MWWtoU0Npd0ZVVVFOREJLWWtKSlpRUjdH?=
 =?utf-8?B?SndkT2FwR3VuVVU1SG9Ka2Z5OERuM3ltTXVsYTdhK0poT0pUbEd3NlFGQ2gy?=
 =?utf-8?B?NzkzclRSRFhjSTd6dy9iRms0OWQxd3ozZ1dyTEJ3N0VNdWFlRkp2K2VOQUV5?=
 =?utf-8?B?bTdMMmEwZFZIUHlLRk1yNk9EelpvSFY1bkN3OXlOeXFqNU9OS09BMmJnemNJ?=
 =?utf-8?B?dE1vSG9tTDZmZGh1MTZnU09LVHgrWjRCRkZvelZYU2FOVGJCc29QWGFNSjNv?=
 =?utf-8?B?UkJSR21EOG55MC9ma1F2SXFjdjJubkNTNnBZRytGSmUzd2N0dUdRaHByYThm?=
 =?utf-8?B?N0J4bDR0Y1NwU2l3ekhWaktubVVZRFFxNXorS3AyT1dlLzN6dURnMXk0YStY?=
 =?utf-8?B?TUtxRUg2TUdyc1ZPeXBGVDQ5ZGhFU25HQWZhNXMvVzVsZ1RXRm04ajRuWkdy?=
 =?utf-8?B?Mm5xSldsck5aSHNmNENDUGFhN21KRHZVM24yNWtYRC9Fd2VNRHhpb3RmZm9Q?=
 =?utf-8?B?ZFArVENKSEx4MFlCbjBjeGMvS0RkMjBGazd3a0ZCcTNxK21QZjhqbzlSUFN1?=
 =?utf-8?B?SFlZMnBmZHpSdlVkT2ZvLzJlTzByQ1RLWk1HTXprYXFqZ3NHR0NwR2pLbWta?=
 =?utf-8?B?VmNvMzdCS1M4WGsrbXJGMkhKRS9PNkcwVVhQc2hsK3QwWkhBVS9DTnljTVhp?=
 =?utf-8?B?S1U4cWNIQ1FFN09RVm54Uzgvd0dQNGhqSnJ6QXE5MXZZYitDUFE2WlRvRENp?=
 =?utf-8?B?bFlhb0lIcnpVenNDVFlySUZoc2hsenY3R0F0U3FhSFo2NjhRb0hEeW4zZEpX?=
 =?utf-8?B?UG9odEFpR3kxUWNoTDZQa0p2UjBkRWVmaVdhS3VNUHZzRThNSDhhR0N5bE5E?=
 =?utf-8?B?Zkc1NTBTQVFsTFd0eDhWdzlDYjI1MExuQ2t0MHp2SWdSV1JuZ09RVDFnWEhR?=
 =?utf-8?B?QUU5bU5NMENSUGMxb1BlbEV2NGcvL3pkUk5lVlF4OXZ0Sms0UDR4TWtPQ1ZJ?=
 =?utf-8?B?SXlVK1dFaVhZUEFqRE0vK2MwbW03WitDZ1h5d1lnUHVBVEFvUGtyY0lQTjRw?=
 =?utf-8?B?UHR1RG45Z3BtZXJyMkxpOUY1dkQ5UFZkRjdBK1VYWkZ3c2piTGZScDMvVDlu?=
 =?utf-8?Q?evlksYrmcjCrlcbEpVOA6EkpaEURKqGF1K3AA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TVh2Zm4yY2xHV1h0dnUvakVjL0ZDZ0prZ2FsUkNBa01xNkk1cFAxWjJJSlVV?=
 =?utf-8?B?cHBmQ2c2MWhCdnp2aFRBZUZHRVgvRzczTUlsZ2FXM29nNG13SE5GQjVCN09X?=
 =?utf-8?B?RklyRjN3TE1sUTNKdjJTcnl5L09vM05rS1ZEbnVzMkhIUm9uVVg3OGo5Kzg2?=
 =?utf-8?B?aXVSOG5BYUpOamFRa25FYTJQUG5UTUk0L0hPSkRDTTRVNG4wWEpXTzlPeXht?=
 =?utf-8?B?UWZ2eUg3RUE2aGw4RXFiUkwxMDcyeUFlSGE1UUFQTkZiWXVVVmVaZjdobVVj?=
 =?utf-8?B?ZTJkNGg4aXNqZGlxNkJ5ZEpSUkNUSURHUE03NTIyYisxS0tZbEFwd1h1c05I?=
 =?utf-8?B?N0xWb0ROL2VqMDh4cjhvb2M0Y3o2Wm12eWpwSjFOVzdjWTNGaVhzRUJTWEZy?=
 =?utf-8?B?RldJVllPM3pKODdKakJaN29xSjBnRGM2Z0dmVHFzT0RYK2VYTkFQZDU0OEgw?=
 =?utf-8?B?V3lIZ1NnWUYxajI5SE5WYjBlVVFZTndiaDdCaEpDcmMydzBRaW1xRkN4VjFC?=
 =?utf-8?B?TDRnY3lZQjc5eUNJUFpPVzRIbFFqWHBnRCt5MElVZ2pqZnZleXRZcW5KcHZJ?=
 =?utf-8?B?UWF3bTQ3RnNlZFdYOVNhSEdJL3JTUjRFanBhWW5SajFyN3RCc1ZLd3ZOZTFY?=
 =?utf-8?B?R0RQR2RwUGJULytOclN6M2VDdUsxN3d2WnlkTVZLRVNzb0l1MTNHTU9CUGhT?=
 =?utf-8?B?c25FUHRXYjVTcWJNTDBzdEF0cmNWN0N4NW9RV1IzOGtlR1pLVWxUU29McTlH?=
 =?utf-8?B?WWZwZjBHMGoyNFhEVExKOTgxWG03SXdxY3d2WllncXN5a2lHWVJHaUNVeWdU?=
 =?utf-8?B?L1pVY3FHZzl5MHBwNzZsM3dSeUxGanJQV2QwSHV1U0o3ZWt5b0FlbEZqLzFV?=
 =?utf-8?B?dWlxUUMybEpadE43SzdtOEJXclZDVUQzWHl6NmhlSmFQYXNybWpQcHd3WWdl?=
 =?utf-8?B?NHpuNWh1TS9UeHMxMnhDa0g2dm5lRDV5bnA1SjZ1d04wRUJsRDJTVFBYK0pK?=
 =?utf-8?B?NU1iRllwWktFc0JmU0Z1ckFvTnJvaFZLWkxzMFNCWWg0NUprWHNsNEJUdG1q?=
 =?utf-8?B?YlJITnFVTUdGRWQwd0JXVXhGems0T1pOdjZYNjU0Q1gyYjVJdFpwQWNtbVFV?=
 =?utf-8?B?dUZDdWhSWlo5T2x0L1pzb3p0eDJ4YzB6a2hkQUVJNTdIQUJ0a2VRZ08vYTlz?=
 =?utf-8?B?TTlMa0tTSXVUb2pPQUUyZkU1TmdueHluWnlqanY1VkVUc1kzNUJIRnI3UTE5?=
 =?utf-8?B?Wm5FK2dUOXRsZTg5c0EvUVZ1TFA0aWpKcUFPcnNIenl4S2xpZHJ6Wk1KYVZk?=
 =?utf-8?B?Y3BNUXQ4bm8yM0Z6YjBWNmYrVStpdjloekhKcUhrNXdheE1rTW80cnVKbEF0?=
 =?utf-8?B?bDQ0blFrdk53V0hwK3Irc28rUldRbXpwSG1tYXRXVkF2Q3NYZ3dKZTJUZGNE?=
 =?utf-8?B?Z25hbmVKWFJ4ZUFLOVdlQ1FvWXEwOXNWRlBUME9RdEp3Z3NSVkNYYzd6cmlI?=
 =?utf-8?B?WGhicVQ0WE82bzUrcW9TOTlLdmxPcUlsZ1FUb2liS2xpaXBhTXZmTGlqRUE1?=
 =?utf-8?B?b08vdTZhclZieTlwMkZWMFVyY3FXOVp4ZHF1aGUvKzRQaUk1WU1VQU4xK0tp?=
 =?utf-8?B?R1pmbmRCNlhLbmxxK3B1Q1lwbDNDTmRQV0FoeE14d3IrVmV6b1RrbThJZ3c5?=
 =?utf-8?B?L01McUJxd0dTdlhjZWtaQSszd2RwS2tJT3dmeVZBWFczdHhTbW5wMmRzN3Iz?=
 =?utf-8?B?Wk54UFdmM3NiMktuLzc3MHlZN0pQZGlyc1pyNTFVcG9pOHZTdTNWS0FqeTVp?=
 =?utf-8?B?YUtrb1k4RCtCRHdKeTdSL09iWWFOWjFyWVFlQVpkOERaWnRoUlNncXdqUkYy?=
 =?utf-8?B?dFNnbTM3N2xGellINTExY21zc29jL2FZMi9LS3c4MUE1VTBDak0zVjBPSHRa?=
 =?utf-8?B?YzA1cXQzRVF5d1dxaldGVG14djRMVlRpak5TUUYrSTlnUUZObFVWWlNZa2k0?=
 =?utf-8?B?bXJ3VHBtWm45ZG5yV1Y2WG9JQVN2am82SzFZK0JTMUZQb2F6YmprRERjVDlE?=
 =?utf-8?B?YUVFWmRGQ0FKQ3B6NEt0TDRDa2JqSHlYNy9aVzFZRjBld0Fwd2lIbUJUcTI5?=
 =?utf-8?B?TUJtajBxMml1S0hOVVdFMTc5dHlKd1NLU1p4NHFKZTZzN29GVk8vWGV2am1N?=
 =?utf-8?Q?XPR/aQi9chQJorFU9ztGbLQ=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1cf705a-fddd-40ac-046e-08dd19464e7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2024 18:13:11.1240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 32vcszM/7+79qazhSamOyETfBaIejjOvZimYRjOm2sMqEp2/7Ito+bXS+k8TQlsy0/eSunDhnYe248tCS/D8jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR15MB5362
X-Proofpoint-ORIG-GUID: 5cN5SFPgvj0_8yUFOkMNTUdW97r3xwtc
X-Proofpoint-GUID: 5cN5SFPgvj0_8yUFOkMNTUdW97r3xwtc
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A990759D2BDAE4EB6CE5F216C488236@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH] ceph: improve error handling and short/overflow-read logic in
 __ceph_sync_read()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0
 suspectscore=0 spamscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=2
 engine=8.19.0-2411120000 definitions=main-2412100130

On Mon, 2024-12-09 at 11:43 +0000, Alex Markuze wrote:
> This patch refines the read logic in __ceph_sync_read() to ensure
> more
> predictable and efficient behavior in various edge cases.
>=20
> - Return early if the requested read length is zero or if the file
> size
> =C2=A0 (`i_size`) is zero.
> - Initialize the index variable (`idx`) where needed and reorder some
> =C2=A0 code to ensure it is always set before use.
> - Improve error handling by checking for negative return values
> earlier.
> - Remove redundant encrypted file checks after failures. Only attempt
> =C2=A0 filesystem-level decryption if the read succeeded.
> - Simplify leftover calculations to correctly handle cases where the
> read
> =C2=A0 extends beyond the end of the file or stops short.
> - This resolves multiple issues caused by integer overflow
> =C2=A0 -
> https://tracker.ceph.com/issues/67524=20
> =C2=A0
> =C2=A0 -
> https://tracker.ceph.com/issues/68981=20
> =C2=A0
> =C2=A0 -
> https://tracker.ceph.com/issues/68980=20
> =C2=A0
>=20
> Signed-off-by: Alex Markuze <amarkuze@redhat.com>
> ---
> =C2=A0fs/ceph/file.c | 29 ++++++++++++++---------------
> =C2=A01 file changed, 14 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index ce342a5d4b8b..8e0400d461a2 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0	if (ceph_inode_is_shutdown(inode))
> =C2=A0		return -EIO;
> =C2=A0
> -	if (!len)
> +	if (!len || !i_size)
> =C2=A0		return 0;
> =C2=A0	/*
> =C2=A0	 * flush any page cache pages in this range.=C2=A0 this
> @@ -1086,7 +1086,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0		int num_pages;
> =C2=A0		size_t page_off;
> =C2=A0		bool more;
> -		int idx;
> +		int idx =3D 0;
> =C2=A0		size_t left;
> =C2=A0		struct ceph_osd_req_op *op;
> =C2=A0		u64 read_off =3D off;
> @@ -1160,7 +1160,14 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0		else if (ret =3D=3D -ENOENT)
> =C2=A0			ret =3D 0;
> =C2=A0
> -		if (ret > 0 && IS_ENCRYPTED(inode)) {

The whole function contains multiple places of checking ret > 0
condition. Frankly speaking, it looks very weird. It is clear that it
is effort to distinguish normal and erroneous execution flow. But, for
my taste, it could be a ground for bugs. I have feelings that
__ceph_sync_read() logic requires refactoring:

if (ret < 0) {
   <report error and stop execution>
} else {
   <continue normal execution flow>
}

What do you think?

> +		if (ret < 0) {
> +			ceph_osdc_put_request(req);
> +			if (ret =3D=3D -EBLOCKLISTED)
> +				fsc->blocklisted =3D true;
> +			break;
> +		}
> +
> +		if (IS_ENCRYPTED(inode)) {
> =C2=A0			int fret;
> =C2=A0
> =C2=A0			fret =3D ceph_fscrypt_decrypt_extents(inode,
> pages,
> @@ -1187,7 +1194,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0		}
> =C2=A0
> =C2=A0		/* Short read but not EOF? Zero out the remainder.
> */
> -		if (ret >=3D 0 && ret < len && (off + ret < i_size)) {
> +		if (ret < len && (off + ret < i_size)) {
> =C2=A0			int zlen =3D min(len - ret, i_size - off -
> ret);
> =C2=A0			int zoff =3D page_off + ret;
> =C2=A0
> @@ -1197,13 +1204,11 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0			ret +=3D zlen;
> =C2=A0		}
> =C2=A0
> -		idx =3D 0;
> -		if (ret <=3D 0)
> -			left =3D 0;
> -		else if (off + ret > i_size)
> -			left =3D i_size - off;
> +		if (off + ret > i_size)
> +			left =3D (i_size > off) ? i_size - off : 0;
> =C2=A0		else
> =C2=A0			left =3D ret;
> +
> =C2=A0		while (left > 0) {
> =C2=A0			size_t plen, copied;
> =C2=A0
> @@ -1222,12 +1227,6 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
> =C2=A0
> =C2=A0		ceph_osdc_put_request(req);
> =C2=A0
> -		if (ret < 0) {
> -			if (ret =3D=3D -EBLOCKLISTED)
> -				fsc->blocklisted =3D true;
> -			break;
> -		}
> -
> =C2=A0		if (off >=3D i_size || !more)
> =C2=A0			break;
> =C2=A0	}

Mostly, cleanup looks good. But I have feelings that this function
requires
more refactoring efforts.

Thanks,
Slava.


