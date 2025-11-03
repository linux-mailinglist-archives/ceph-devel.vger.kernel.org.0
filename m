Return-Path: <ceph-devel+bounces-3917-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B100C2E512
	for <lists+ceph-devel@lfdr.de>; Mon, 03 Nov 2025 23:50:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD7F13B8C7A
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Nov 2025 22:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7559E2FC861;
	Mon,  3 Nov 2025 22:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dJOLsoJs"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B46E2FBE05
	for <ceph-devel@vger.kernel.org>; Mon,  3 Nov 2025 22:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762210202; cv=fail; b=n3nH5czBQYyQRrbLijeKdEuAC7Gx9TTHshNsT/XENMNdv2nKENAoSD+Cqgg5T7FCB5burNIhSCNscK451HmB66RaRdaUX7r7oIYgY+Ek/Tfwx6IxBJ3C4I1h1DL36S38eR9rY4IX8utZ18mQLAu2pBiWFCwVY9ERiRjsdp3z3xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762210202; c=relaxed/simple;
	bh=ywi3J3DXTOzCTsbWb/nr/eXOcloug6kuDOPZMlQeY0s=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=N0hbkXoAMJRw+VjDjTLrqkOcU6ODnFtHLKbW0v6S4KTPq+Ead20yRU456KAkSMva/cQK8ASV+pqO66FAbVml5Y3QchwVZWqiawofruYuFGZgEgroPO2qg5RLVBGfaDfyauv2IQFZFTXsVJwEpmjR1pEWQYeO/pqS8nOpIOwwvSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dJOLsoJs; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3EUIga015970;
	Mon, 3 Nov 2025 22:49:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=ywi3J3DXTOzCTsbWb/nr/eXOcloug6kuDOPZMlQeY0s=; b=dJOLsoJs
	aS4GadjlAlaq3uAypRIe5eRWtpVrRgI0s4c1idbgEODjOb/PDjpq/57VT3oyjZKe
	46+sakW95VbnFgt/oskjnxuIAkRs4wCoj8aHswW497R3jwT0BjTSL7xY7wOqAGw5
	rY1do78lsUV6IPs2GVLyipiWOWCsRIVWCOls1asjHneunT8Coe+7iyjV0QGOV7H1
	p6QEy3AHkjNWiTPgw6E3o3rFJdMgLHQaA6JdRhXNzOwgJttMwuuf8sSEIIR8kx6C
	wQsmqFtHkhQHuErR2HKzmGChjAhK1OH6WmGTUtii+YygZjvSIRtI3nRhqMn6XRUV
	1pQCnoPmf5gtLg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a57mr12nf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 22:49:56 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A3MkPSv024744;
	Mon, 3 Nov 2025 22:49:56 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013055.outbound.protection.outlook.com [40.107.201.55])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a57mr12ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 22:49:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HfZTj5QOmEVTZHOKFptbuxY0QJdsWFGORqEM5ZUysduSkg7Hu74hk7vrPT+28t0Bf/GMMwQZ8vUCfO0bzUyWh1xmLJtvcMB/cDFtSUc/G7gEQau5pXqMbZDvzCRf7eZtmiRCxYkkNtqJSXtjjmLgkNX17jrl+2MYUY5e2fscDDnN3XXyGOJkzO80Q+LoIrf2zvJ0tcVaD/TJvm7V/t037wuYfcnha2kz22Sut6O0VggG8DxnhT3QPZRmnxCOQSuk/G69YmFhepbskmidxspv92w4Dvc3NZf5rivf+GzV+eYpYmuj/ShXm1FVXuJcksjWD6SyAaZITY4poCEO7mJifQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywi3J3DXTOzCTsbWb/nr/eXOcloug6kuDOPZMlQeY0s=;
 b=DEf9u2TIA5sTwJvSWhfGz4st8JlN2bhxM2BVH/domE+jLnJX/ZjDjla+Tt0/O7inB8borGS4HgmgCotF0fLPvyhU2/8DWWiqtDz53ltE6akn8dSf5UhxGD4pCTgVcOHld3+3q/+UAQ1siuNKKl2SdGKVLKERP38BOMt/PFlICRQuVkU0wYWp/OGU0pT5+SAcKpyxG+jg4gqnU3e95tdISL8iUoa2UtUO+Z+yz/almXPrTl+a8Fl3ttD6WV+ZJmSQzPCV9CK/K5MNc4BX0ZExIuKTCXbWsj/mtp3K82tDVQewXLuQjE+yUJj1sqo/ycC7ze6150ipRZWx4qTlSMcfKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB5812.namprd15.prod.outlook.com (2603:10b6:a03:4e3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 22:49:53 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 22:49:53 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: Alex Markuze <amarkuze@redhat.com>,
        Patrick Donnelly
	<pdonnell@redhat.com>,
        David Howells <dhowells@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH 2/2] libceph: drop started parameter of
 __ceph_open_session()
Thread-Index: AQHcTQxYS04lAxmSKEqi4hZ+iTD9RbThjj2A
Date: Mon, 3 Nov 2025 22:49:53 +0000
Message-ID: <88d57afe9173f4341058941f08e3b82febbf9c7a.camel@ibm.com>
References: <20251103215329.1856726-1-idryomov@gmail.com>
	 <20251103215329.1856726-3-idryomov@gmail.com>
In-Reply-To: <20251103215329.1856726-3-idryomov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB5812:EE_
x-ms-office365-filtering-correlation-id: f0846f67-cfe9-4830-db87-08de1b2b4df3
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Rmc0MmNRZ2xpYjlwbkxrK2o0VXFwTXR0eEtydGVNY2lkWlJYNzZ2K01Ecjk3?=
 =?utf-8?B?L0tMM1NQNUtwWXdac095OW5FejdJaGFsS2ZLUjJVUFoyRG9QeTlNblFQNzFP?=
 =?utf-8?B?S1I4aEx5QlVwSmJCazUxNzlSQnlMNGE1cGhEckZvcjFsSy9HcDRmV2RVeTdB?=
 =?utf-8?B?QmFqaEk0SFN5TDZVOU5FZWo2Y1NMbWxVaWZWbU5yUUZxbWVGRDlUUGtaZmhv?=
 =?utf-8?B?ZG1DMmJSWS9pSThrakFaOGlWZEo1T2J1WWdnNnVxOUJjRlhJOHBqYzBkejdq?=
 =?utf-8?B?dXErS3ZiSDRna01oUlFGNVhJRHIwU3BneXlHK1FjSnBGTVY1OER6UFdoTG81?=
 =?utf-8?B?YnRHejFHY1NXbnJpY2lsZDV4YkU2ZS9LbFREVVp2MTRicXk5ZjR1UlpWaVda?=
 =?utf-8?B?K3Y1Wmtna05XZHJDN3lSMEk3SXdwTWROQnVMWXVVdlhjVHZHelNoYzhLckpq?=
 =?utf-8?B?M0pQTEFaWG5YTUZsa2d6M09sVEJkc3I3WHc0S1oyQzJnSk1Tb0JONlBlTVlD?=
 =?utf-8?B?ZDlaTzcvUWhNdE81RW1lQUw0NlVFbVRkOE5DNmNKdXVnRzJKME4vZFNsbTJB?=
 =?utf-8?B?cTdWS0lyYzJBcDI0U2I2QWJtSTZEV0ROc0djVlJFaG80N2taUHVPd3RnbUlN?=
 =?utf-8?B?STh6NXVCWURjSFBCNmVtUFpIMTRkVjFOSjdpYUt2SjlQZnI0UnhrM3RqQysw?=
 =?utf-8?B?NnZTQlY1MnhUaEFmT1FjeHNLeHRFTnhoRG01Y3cxeGxmWEM3VUowMVJ4VUdB?=
 =?utf-8?B?dWx3Y1NDWDRIVHVvbXRLVVdDdS8wOFhFUjNPZ3RXTjBTaldSd1VTMlUrZFhX?=
 =?utf-8?B?M3gxVk8vZEx5VFdPMWJNdUttcG1VZ3ZKcjM1QURVZVI3eXNmb1NOazU1bzRE?=
 =?utf-8?B?TldZZ0JGZ3JZZm1ieFp5eXI4emhiNmdXZ2dua3JXR2x2bENSSTlyQXY0WHBn?=
 =?utf-8?B?dkUrQVpzRVExQlppWjVrTkFhcFZDTmhOQ09STVQ4Q3ZaK3piZWlITzJGYWVk?=
 =?utf-8?B?SmdKRkcycjFzSStzYi9KTFRmMjhCRVU1VDVOSm0zd0hFNXJwOXZKU2x2Mnhn?=
 =?utf-8?B?ZUlURmxLanJ2akJhUEtSclBqUHVHSEJCeHYwMzFHbE5pODlZOWprU0ppY2g3?=
 =?utf-8?B?Q3RHTkR4RkxaZDN1UGVaZC9DSEp3Z0J0VEdqSVN2azI2MUxxRDMzRGZLVENY?=
 =?utf-8?B?UnVZTzNsNTluSFkrQ2lhMG5pbFF4Ris2SnFjR3FFazdTZUtpaXloRnpnVjQv?=
 =?utf-8?B?RDB0dmdSc1BmQmYwTW1IVmRvSHdDT3pFRGxudmcreEdXZUFyVE1ySktKSktU?=
 =?utf-8?B?blJVSzVXbVVNTlVreDNONGlLdkF2SGdxUHM2TWpRS1M1UTYxSk5tc3J5aGxM?=
 =?utf-8?B?S0JlSnlWT3JOZW9iS1lhbXRhdytOQnBrZnEvMmJyZnVqd2ZvSjZHUWk1Z3RQ?=
 =?utf-8?B?WVg3ODRERmYrRkp3dGl0UTc5M21KWjBiaC9aRE9NRjlRRzdsQUIyRkdQU0VG?=
 =?utf-8?B?ZURVWnMrb0doczc3TkRneUR2QldmbkZ6MkF2RTlPeThRUi9tQmhlNjZmaGpN?=
 =?utf-8?B?UEt0TkxTSXIwSWczdk84WE93bTVKQ05zT25YYTIxb1hCcGdWeUgwRmR5ek13?=
 =?utf-8?B?bU4vVnhHVlk4WDVCNGU2ZzVZdnFGNEJMcFRJamNlRlFSR0ZTZ2dIK2JmVENM?=
 =?utf-8?B?TVErdkFwdkxHZHloK3dlRWVvanhSNEFBbzN0TEhEZGtlVnFGTEh4TW5aZDMv?=
 =?utf-8?B?SEhWK2Rnb2lDOHcwRHJWQ0Rvd0RibG9pWTNzOWFzZ0lCZEtaeTI4M3B3UTAw?=
 =?utf-8?B?RityUXUrVzN2czg2WjFLV3Zvc1ZjWmZhTExtTXVBQktDZlBSNmR4ZlZRMm9t?=
 =?utf-8?B?VU9FNm0ydEdQZXU5OFM0OFFGc0p6d2xrWmxvVVAxTUZkMlJnbDhiUzlGcThM?=
 =?utf-8?B?T0h6a2xUUjlvaFJOcHJzay9GbTNwNFN3dStBWDcyUlNKUGVsTlpJTXZSZWFU?=
 =?utf-8?B?LzRwU2x4Yzl4SUNobm95aVdjb2t2enFXSXlMbytCalllMldUbHNsZnhrL1hL?=
 =?utf-8?Q?n00lm3?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a1k4NDFWTFVsQmc4WmN3dkNCQS8ydVllS0ZaUzA5RDZqOER6eThwM3kwenBP?=
 =?utf-8?B?eEd1MWpMaWtia3FVMnloL21nVWJhaWJaRVUySjIzMFp3U3lZaFZZRTdLWlAx?=
 =?utf-8?B?dnAzWW5aNWp1TkM1aVFxR3BZS1NyUjNtdWI4MHF0YWYwNnlQczJYMVcvajZC?=
 =?utf-8?B?VFBMcXMvS0hFcFptMUZ2V0VlMGQvYTJONmZ1Q3NNUnJGWGJmdWpDRTV5ZUNH?=
 =?utf-8?B?a3BrMDQweG9ZMEFhaTEzQmF1bThvNVo0RzF4VXRhV0Q1clU3THR5RDd2b05L?=
 =?utf-8?B?RXZrdVlESVZWQldTUGJaY1R6L3dPck1uRVVweFU5ZmU0SU5rMXMyT3l4Tnd5?=
 =?utf-8?B?NUkyRWhGUVB6ZlhlUmtRVVY3Vmk5aUhLVE9PMjJUb2Q4a1luWEQxTTgvV05o?=
 =?utf-8?B?enBWYXBjeCtQQ25QS0JnbCtwV0RPTUFmb3krRVp5cHRGYTJGUmZMVTlhWW82?=
 =?utf-8?B?dWZiQkZ3cHJyOEVLNzRYWEpBcW9ic3BGWGRUaVZxczBTRDNxRjhPUnNlYkhB?=
 =?utf-8?B?WmZ2dDAyTUU4cDdqOWRjNjlEWGdsdWlDMGhXNGx3ZXFSUHNlVTZhUnMvcWhj?=
 =?utf-8?B?VVlVVzFOTWtxcnN0aTlIbmpCV1hON2cvVFYwQlRFZ1AzTlFidkMzNFU3Nnho?=
 =?utf-8?B?TDhyaExyWFZKYWwyNDJyNXZVVHlRVk0xdE5YMFdnN3E1UGhxazFpb3dZZUta?=
 =?utf-8?B?QzFKT2J3NGNXdGpOaElyaW9yQ0pQNUFiNzJSUTR3OE1JenYzam12aDZ3Ylpw?=
 =?utf-8?B?b1lMS0JDaXF6NjM1MURIVW5qRUdVTk42UUxHLy95TGVYTUsrenhYYms1ZVJC?=
 =?utf-8?B?SXZINzBKalFNdHRhc090clVkN0QwOHg4WXFxQkFrYnc4b01Gdkd2b0xCc2k0?=
 =?utf-8?B?RXEvbHdQSW9JQi9oaE5MYmhYcnJydXEzTjlsRmZsZHRvS1dKUXhhdHB3QjJE?=
 =?utf-8?B?WEw1VHhiSXVXWk1zRzdwT2F0QUJ6VHc0QTdaQmlPZytNSDllc1REVnhyenFa?=
 =?utf-8?B?L3h2ZUhSd2dYS0JGQkp3Tnk4SGJBbkIweDM3cDRZSFQ1QTNsbWFRSkFyRFFW?=
 =?utf-8?B?OWxiS3I3NklFNTJuSTRxTU8xa21HM1JpTzlVdFB0ZTlzQkVLYWF4SEVveERm?=
 =?utf-8?B?SzlNalVOWndnYTZ0TU5FcFJwTzlQOG9WcjhtdWI4MVFTbUdmWnVBTUdGNHcw?=
 =?utf-8?B?N2dlbVhNVWY3QzB1ZXBmTHkyeXhoSnE2eXNrbWd6ZVNkUUtTcE1MMmxMZk5i?=
 =?utf-8?B?KzhtTEllalptc295SDQ4akxtN2JXdU4zMmpOT056Z2diN1BxcE84Z2hialJs?=
 =?utf-8?B?NERTUWdJTno1cXpDM2E1eHA4WDRHUlliZTNRdGZINGNtd01XZUFXeFoydSti?=
 =?utf-8?B?M09uMlFxZ2ZwNDd3OEdMeVdFNVJsSlVraGM3aW9PbTd4RjRmM2VGRlZrUENm?=
 =?utf-8?B?dVYzelhrbk1qM29JQzI5TzB1Z2h1eWFaeUR1QUdBRHVXT09xRC83STUyNHhu?=
 =?utf-8?B?clkrSlRydTJmMWFqRkUvdkVtTGRUeXBNZ1ZKK3oxU25LaDNYb010TEZVdVB4?=
 =?utf-8?B?Z1Fic2dqNjNKaFV3dnJtNXVYZUFNS21xenFCcUR3UE5tOE9Wd2g2VzBWR1hv?=
 =?utf-8?B?dmtmTEJNNGZDQTlwMzc4N0k1Sm45MDBKZ2dkcmZHQUIzaU5yalhCL0JIKy9E?=
 =?utf-8?B?TzAyU2s1NmdodC9TU2JLOVI5Ty95RUhQeXNReklDcDB5VE9zQ0hEaTZqcXg0?=
 =?utf-8?B?WlF5dEpmS1U1K1Q3K29qUnBGNG9RdU96WVc3bnQ1aGIrekV4K2ZMWTZnc0FQ?=
 =?utf-8?B?NUpUMVY4NnE2emZJU3d4WTNhK1lhdlU1VzhMMnhVWDBQaXJHQ1FpVW9lQjdu?=
 =?utf-8?B?NzUrMS81UFI3ZXZOaHRLM2NHNlFoWHFOa0YzdjY5UnlEallLanAvME9nS0Rt?=
 =?utf-8?B?bHN3WC9HT3RqVFNwWmhGN01KWTU4Tld0eDNhb3BWeGc2bUo3V2JjN1duZGVv?=
 =?utf-8?B?UGdUd09VcGhCakRjLzNyN29LbGxiZWZFdTg2OGdVWld1M2c5VWx0MVoyR29p?=
 =?utf-8?B?QXg4V3BXZTBxRDhsZXJNOVhpc1RkR1VialptLzVrSVdDZUw1Q3VOc05YTnp3?=
 =?utf-8?B?Y1dUcTNRN3lMZEVsUWVKYU9JM2VVMjVOQ2VhNExnRkhJWml1Ky9aZ2RwTktJ?=
 =?utf-8?Q?ZzIoaw4xJm8lG6Uy2c8clws=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A68E666DB1E1B14AA2EDC3ABCDCC27FB@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f0846f67-cfe9-4830-db87-08de1b2b4df3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2025 22:49:53.8292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ObRUu8cgxDSumEQ8ZjaxwHPUdXKvaIKt52kcoyZZcvETYKoSqRd2t6V1fnhxCh2XyD9apR592vwHGnIJA1/l8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5812
X-Proofpoint-GUID: -pID4pBUisE77Apj_ODzOn7eIvuRGwSL
X-Authority-Analysis: v=2.4 cv=MKhtWcZl c=1 sm=1 tr=0 ts=69093194 cx=c_pps
 a=PNGgPGJBypDwtINamOK0jA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=nCBUSlAokKwHtYj6JGEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: SBjD7ubVrSC3G1Jsex3zVLa2pKmYfMx3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAwMSBTYWx0ZWRfX41VjThiJFTLz
 3O13jw2wBHO1C2kTSUaLeOtGAEwieu8RnCL2z8rNfsLe4wCBpz0FFOz+xHPg/JqCS94mSGWVGB6
 HHCUuTrxCfsnRRxPH9iY/LgQmfVwsizBwddPMRRN5yywCenD8PFqZwB0sGhQWsjgeZ5zZRkvvza
 XHT8VYcGVDDUEwmCvzXvrEtKuR6VF4yGpJbKdfPshzStkDoGtU4zbC4/ThXt4lJZQhHPC7PnvmZ
 lVci1ftIU+MzLBC2yxBD/WsHCTLwxYvO3JVYlYIa1sJTbcKMYizNKYBezCxnu5hC5nWROtiHeh4
 gKg30vsDSBVw7hXLqgrr+fTGYlXBOQtXyneJ3Xz+h37cN1RaVvBqv/l9dYfrIPdC9d/P0FRPJcV
 Cj8cUYCAXAfy2xgO/A8/1JWnanDG5A==
Subject: Re:  [PATCH 2/2] libceph: drop started parameter of
 __ceph_open_session()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_05,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010001

T24gTW9uLCAyMDI1LTExLTAzIGF0IDIyOjUzICswMTAwLCBJbHlhIERyeW9tb3Ygd3JvdGU6DQo+
IFdpdGggdGhlIHByZXZpb3VzIGNvbW1pdCByZXZhbXBpbmcgdGhlIHRpbWVvdXQgaGFuZGxpbmcs
IHN0YXJ0ZWQgaXNuJ3QNCj4gdXNlZCBhbnltb3JlLiAgSXQgY291bGQgYmUgdGFrZW4gaW50byBh
Y2NvdW50IGJ5IGFkanVzdGluZyB0aGUgaW5pdGlhbA0KPiB2YWx1ZSBvZiB0aGUgdGltZW91dCwg
YnV0IHRoZXJlIGlzIGxpdHRsZSBwb2ludCBhcyBib3RoIGNhbGxlcnMgY2FwdHVyZQ0KPiB0aGUg
dGltZXN0YW1wIHNob3J0bHkgYmVmb3JlIGNhbGxpbmcgX19jZXBoX29wZW5fc2Vzc2lvbigpIC0t
IHRoZSBvbmx5DQo+IHRoaW5nIG9mIG5vdGUgdGhhdCBoYXBwZW5zIGluIHRoZSBpbnRlcmltIGlz
IHRha2luZyBjbGllbnQtPm1vdW50X211dGV4DQo+IGFuZCB0aGF0IGlzbid0IGV4cGVjdGVkIHRv
IHRha2UgbXVsdGlwbGUgc2Vjb25kcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IElseWEgRHJ5b21v
diA8aWRyeW9tb3ZAZ21haWwuY29tPg0KPiAtLS0NCj4gIGZzL2NlcGgvc3VwZXIuYyAgICAgICAg
ICAgICAgfCAyICstDQo+ICBpbmNsdWRlL2xpbnV4L2NlcGgvbGliY2VwaC5oIHwgMyArLS0NCj4g
IG5ldC9jZXBoL2NlcGhfY29tbW9uLmMgICAgICAgfCA1ICsrLS0tDQo+ICAzIGZpbGVzIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9m
cy9jZXBoL3N1cGVyLmMgYi9mcy9jZXBoL3N1cGVyLmMNCj4gaW5kZXggNDhmMTg0YWVhMWJiLi4y
MGNiMzM2ZWJjOWYgMTAwNjQ0DQo+IC0tLSBhL2ZzL2NlcGgvc3VwZXIuYw0KPiArKysgYi9mcy9j
ZXBoL3N1cGVyLmMNCj4gQEAgLTExNTIsNyArMTE1Miw3IEBAIHN0YXRpYyBzdHJ1Y3QgZGVudHJ5
ICpjZXBoX3JlYWxfbW91bnQoc3RydWN0IGNlcGhfZnNfY2xpZW50ICpmc2MsDQo+ICAJCWNvbnN0
IGNoYXIgKnBhdGggPSBmc2MtPm1vdW50X29wdGlvbnMtPnNlcnZlcl9wYXRoID8NCj4gIAkJCQkg
ICAgIGZzYy0+bW91bnRfb3B0aW9ucy0+c2VydmVyX3BhdGggKyAxIDogIiI7DQo+ICANCj4gLQkJ
ZXJyID0gX19jZXBoX29wZW5fc2Vzc2lvbihmc2MtPmNsaWVudCwgc3RhcnRlZCk7DQo+ICsJCWVy
ciA9IF9fY2VwaF9vcGVuX3Nlc3Npb24oZnNjLT5jbGllbnQpOw0KPiAgCQlpZiAoZXJyIDwgMCkN
Cj4gIAkJCWdvdG8gb3V0Ow0KPiAgDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2NlcGgv
bGliY2VwaC5oIGIvaW5jbHVkZS9saW51eC9jZXBoL2xpYmNlcGguaA0KPiBpbmRleCA3MzNlN2Y5
M2RiNjYuLjYzZTBlMmFhMWNlOSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9jZXBoL2xp
YmNlcGguaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2NlcGgvbGliY2VwaC5oDQo+IEBAIC0zMDYs
OCArMzA2LDcgQEAgc3RydWN0IGNlcGhfZW50aXR5X2FkZHIgKmNlcGhfY2xpZW50X2FkZHIoc3Ry
dWN0IGNlcGhfY2xpZW50ICpjbGllbnQpOw0KPiAgdTY0IGNlcGhfY2xpZW50X2dpZChzdHJ1Y3Qg
Y2VwaF9jbGllbnQgKmNsaWVudCk7DQo+ICBleHRlcm4gdm9pZCBjZXBoX2Rlc3Ryb3lfY2xpZW50
KHN0cnVjdCBjZXBoX2NsaWVudCAqY2xpZW50KTsNCj4gIGV4dGVybiB2b2lkIGNlcGhfcmVzZXRf
Y2xpZW50X2FkZHIoc3RydWN0IGNlcGhfY2xpZW50ICpjbGllbnQpOw0KPiAtZXh0ZXJuIGludCBf
X2NlcGhfb3Blbl9zZXNzaW9uKHN0cnVjdCBjZXBoX2NsaWVudCAqY2xpZW50LA0KPiAtCQkJICAg
ICAgIHVuc2lnbmVkIGxvbmcgc3RhcnRlZCk7DQo+ICtleHRlcm4gaW50IF9fY2VwaF9vcGVuX3Nl
c3Npb24oc3RydWN0IGNlcGhfY2xpZW50ICpjbGllbnQpOw0KPiAgZXh0ZXJuIGludCBjZXBoX29w
ZW5fc2Vzc2lvbihzdHJ1Y3QgY2VwaF9jbGllbnQgKmNsaWVudCk7DQo+ICBpbnQgY2VwaF93YWl0
X2Zvcl9sYXRlc3Rfb3NkbWFwKHN0cnVjdCBjZXBoX2NsaWVudCAqY2xpZW50LA0KPiAgCQkJCXVu
c2lnbmVkIGxvbmcgdGltZW91dCk7DQo+IGRpZmYgLS1naXQgYS9uZXQvY2VwaC9jZXBoX2NvbW1v
bi5jIGIvbmV0L2NlcGgvY2VwaF9jb21tb24uYw0KPiBpbmRleCAyODVlOTgxNzMwZTUuLmU3MzRl
NTdiZTA4MyAxMDA2NDQNCj4gLS0tIGEvbmV0L2NlcGgvY2VwaF9jb21tb24uYw0KPiArKysgYi9u
ZXQvY2VwaC9jZXBoX2NvbW1vbi5jDQo+IEBAIC03ODgsNyArNzg4LDcgQEAgRVhQT1JUX1NZTUJP
TChjZXBoX3Jlc2V0X2NsaWVudF9hZGRyKTsNCj4gIC8qDQo+ICAgKiBtb3VudDogam9pbiB0aGUg
Y2VwaCBjbHVzdGVyLCBhbmQgb3BlbiByb290IGRpcmVjdG9yeS4NCj4gICAqLw0KPiAtaW50IF9f
Y2VwaF9vcGVuX3Nlc3Npb24oc3RydWN0IGNlcGhfY2xpZW50ICpjbGllbnQsIHVuc2lnbmVkIGxv
bmcgc3RhcnRlZCkNCj4gK2ludCBfX2NlcGhfb3Blbl9zZXNzaW9uKHN0cnVjdCBjZXBoX2NsaWVu
dCAqY2xpZW50KQ0KPiAgew0KPiAgCURFRklORV9XQUlUX0ZVTkMod2FpdCwgd29rZW5fd2FrZV9m
dW5jdGlvbik7DQo+ICAJbG9uZyB0aW1lb3V0ID0gY2VwaF90aW1lb3V0X2ppZmZpZXMoY2xpZW50
LT5vcHRpb25zLT5tb3VudF90aW1lb3V0KTsNCj4gQEAgLTg0NCwxMiArODQ0LDExIEBAIEVYUE9S
VF9TWU1CT0woX19jZXBoX29wZW5fc2Vzc2lvbik7DQo+ICBpbnQgY2VwaF9vcGVuX3Nlc3Npb24o
c3RydWN0IGNlcGhfY2xpZW50ICpjbGllbnQpDQo+ICB7DQo+ICAJaW50IHJldDsNCj4gLQl1bnNp
Z25lZCBsb25nIHN0YXJ0ZWQgPSBqaWZmaWVzOyAgLyogbm90ZSB0aGUgc3RhcnQgdGltZSAqLw0K
PiAgDQo+ICAJZG91dCgib3Blbl9zZXNzaW9uIHN0YXJ0XG4iKTsNCj4gIAltdXRleF9sb2NrKCZj
bGllbnQtPm1vdW50X211dGV4KTsNCj4gIA0KPiAtCXJldCA9IF9fY2VwaF9vcGVuX3Nlc3Npb24o
Y2xpZW50LCBzdGFydGVkKTsNCj4gKwlyZXQgPSBfX2NlcGhfb3Blbl9zZXNzaW9uKGNsaWVudCk7
DQo+ICANCj4gIAltdXRleF91bmxvY2soJmNsaWVudC0+bW91bnRfbXV0ZXgpOw0KPiAgCXJldHVy
biByZXQ7DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28g
PFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

