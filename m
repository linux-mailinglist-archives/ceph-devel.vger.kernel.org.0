Return-Path: <ceph-devel+bounces-3522-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B152B44571
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 20:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 304F3A40E30
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 18:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477DD2459C5;
	Thu,  4 Sep 2025 18:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ile7B3dG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEF11E573F;
	Thu,  4 Sep 2025 18:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757010739; cv=fail; b=XXSFmAJaNVy5yF91QapCOH0wrVcaCX1ZJvcrrZIHb6s4j+wazQW/Erg1fa3K43MUn0CmQNJS5/nvKGSJE05iQp482fSGp0R1e9rHeDoDaVacrmRX32GvQ6FD1CRl+j3ntCVFU2sQmPl4OcSKP1RLV5lDmw5AcAemVJioP9ppGF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757010739; c=relaxed/simple;
	bh=ROhJ2p4T7XUbNhGdg3JyE4YsJGhbznVnhVa3b7oGEtw=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=JZLAjAh4QzByd13/aUzGqeQbQUUIZYVKmzc5lk3bXLkffkxRYY2ELOALbISN8iskhbzM0ROgMdV0/iNzWDhVzKdJXDIncWZZM0n1PBdlN5lY6UlvJaDkaVoLH7cG5qmKqUQLlzSawMU2pU58BWWZf3MOL3WsL4tgPd/zsHTv14I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ile7B3dG; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5849WX1f005211;
	Thu, 4 Sep 2025 18:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=ROhJ2p4T7XUbNhGdg3JyE4YsJGhbznVnhVa3b7oGEtw=; b=ile7B3dG
	iIz7NoGqtXNMVpZSeDQ29O79MtzdAym1d+rHmazgSmqFMBumMdQKjOu0lKg3oMjI
	XFJnR/ZKnvuVMaJhfkh/maP7EzjvVC1J1y5M5j3WRX9blecK0Gwv+Qf4aSwBwaJp
	GFz+itnjgqwe83fiQ2ReN0eeidIgMYE9R8gBgYEE+pChOXom7mvZfTBPg72kydSr
	KNfa1Ga/xuLkzWt7CO+jSFV3AD9xOt+HP3dbz1TNkrjG/NRWE8TLrf20UfdJw/ue
	g73Nn5DyHfGpiQfHkmL3A3lkGbc6lVIYVlqdv5ASSIzMCkSduZCGfxomFbK94/LE
	0GgO4dZjorj/Vg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usv3c438-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Sep 2025 18:32:14 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 584ITe87014444;
	Thu, 4 Sep 2025 18:32:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usv3c436-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Sep 2025 18:32:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8WAMwIahie1LCTwINoMR9wkTYxIgd50Ziriak1U9/L6fAAVk9QadKTF38f2etts0zi1ZgwtdfTtd3b0On4dMCYmq+Pphg0vSQULoJgItL9pAldOQXkG2pGLjf8Be3E6h+pmtoZIJ1OaduDmKTEAEBF6UOZU0HKwg/SzLoyYmeNaedNLYFyHBM8UAsBUpA2OU1sth7CwFHHOVASiXTUUXhYHdy6d5bOHHzVfC+n4ScQuMA458xOIqyhSB6jSUnkbfAYK6PNfbPAddFygJyEClc46BgQpzZqhB3cBRfv1rU7SyLqYNXbx7k0Q93sE1yT4wgHyBN6EK/1LarjSNC9G3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROhJ2p4T7XUbNhGdg3JyE4YsJGhbznVnhVa3b7oGEtw=;
 b=NqfxevhzcmGvDoPetGDxo79oMM/KiauPQ2rsah9FXBh85zADbf0EbeeLJVu8GLbxWGHH/XegJ/RIlc6VPVQFNCW2bDalamZbynBVjYhUhlmdj1SFdjJd5d2KFpnV9i8X2ir6nr5omdN4d7m2Qn171K69sRrmVhcOJcF6i1OBu6YpTCbP8SCW8HM+CF+8ObZaqQ1/ZnpWcAbI86n6abmVZKiR+yryQvvyZv4MuHRD/p+l7w3IH9tir462IZJPCICEr7J+dsdBk0phPH5osgIOXbeF1f3jF/Qxqsp24JsznKgWrqSby1gi1p61YvRr68CKSp3NqDnAIEGiIIR0vzRivg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB5257.namprd15.prod.outlook.com (2603:10b6:806:229::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Thu, 4 Sep
 2025 18:32:10 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.015; Thu, 4 Sep 2025
 18:32:07 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v2 2/2] ceph/inode: drop extra reference from
 ceph_get_reply_dir() in ceph_fill_trace()
Thread-Index: AQHcHYR3QP/wi4KnmUWXoB9XJcujX7SDWWUA
Date: Thu, 4 Sep 2025 18:32:07 +0000
Message-ID: <ecdf72c0856f79142af5d951c7cb479cba6c8fb3.camel@ibm.com>
References: <20250904101234.1258643-1-amarkuze@redhat.com>
In-Reply-To: <20250904101234.1258643-1-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB5257:EE_
x-ms-office365-filtering-correlation-id: 3bac4b7e-1370-4581-2e61-08ddebe15a82
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QWJBazVMWnJjd3BxdHRIVE5WViswY1Q0YTRhaEZLaUpTZUFQRmlLV3pMM1Bx?=
 =?utf-8?B?am54cVNvem9jeDZHSzZYTFBLMXd4VGhwVlRoRXNGcmVxNnlaemk0YUV6Y2tJ?=
 =?utf-8?B?TkZEU1dqSVNXY3lwYWFSeEZHRHdzWXFoQkZuQ0hZNGFRZ2JGVmVDZ1VNd1VX?=
 =?utf-8?B?emdBTU1ENEpCV2ZoY0VDdUJVc3ErSXJ2L2s3b0pHU2FteExIWCs4RXVaOS9E?=
 =?utf-8?B?eS9YcERUNzVTTzZiSjl4SWJpbkk3Smw0QkYwUEFUVTFwKzgraVNzWFFtMTRR?=
 =?utf-8?B?T0JiYjRGd2ZOUnRmK0lVMHJzdERxcGJJUDVRd0tKTmpPT3hrZWVQV3JQU3Jr?=
 =?utf-8?B?WXRsMEZqYURDU2JvUHNXRVFwV1FnSnd0ZFpyd2RFS3p6L3VtN1IrQzNlZHFx?=
 =?utf-8?B?d2k3ZmMzaUkrOTVYNFNpdDcreldwa2xVSk9Ndi9mU29nK29EYmVTWERYSmUw?=
 =?utf-8?B?YjNDTVUrbHdSRVdzaVRkOHY0dlBYR1hqWE1JZ2ZjVi9mcnRGWHlvZCtRRitK?=
 =?utf-8?B?NmpyZ1RYNm9Hc2pIRVE5MnRuTndlb1d4WHBIS3dmYUN0dTBWL3RScjIzVWZB?=
 =?utf-8?B?MklJbGhUcFQ4SHY2WEF3eGROTDVnUW5UYlphaE1aRzdjcmxTZGxrZy9YOGsv?=
 =?utf-8?B?OW5JeHBoQU1uOXRxdGUwSkU2QXVRQjhlQllWdGNmaERoWG11cGErVFk4OTJy?=
 =?utf-8?B?V2JhbzU2UTg1Y2NyR2lkc1hjdFVYTy9pK3F4OG1vNzB5SWZMTngrYURTa3BE?=
 =?utf-8?B?dmlxckMvTDQwV09BNDFEaFFuMUNjelRkUjRGbUJrMjFOYlNDZ0piZVdJYmJm?=
 =?utf-8?B?M1pVbjZGTGx3NEROUEF2R3dNdlRKUUdIdVFFQlNGTEVYWFAwNU9RK0hFL1pY?=
 =?utf-8?B?TG01T0ZSVUZyOHVSUnNRSVlRZHVNTk1wTmdjTEVyaWFjN2dBeGZnejE4OEZk?=
 =?utf-8?B?OGU3T0VBdHBUc0Y3UzdOMkw4S0V3UThSUCtQTXV4cUlucERTMGU2eGxtWUhS?=
 =?utf-8?B?MDl3RWJDTWd3VytGNExXakRhNnowS3owSW1QcE4zMGdKY1lzcllTeGNCdVlB?=
 =?utf-8?B?cmNrSEsxdUFVbTdaVjEzS1Jaa3BpMDhtbzBSZnZmQmRQazl3ZTU0VmN1ejJy?=
 =?utf-8?B?SnlMNDd2T2pndmxEb0Qzd0I0QnQ1NjJCR216ekxxakl6M0tOeGhoeVJNQmNW?=
 =?utf-8?B?NWpuZmVGTXFYZVk5Y05TQ0FrZXpQWXBOU3FFMGZjVGdiZUVxdWdUbVlSN3dQ?=
 =?utf-8?B?QzBLVjNJVUlXSVUrMHJ1UExXS2lVNC9ycGRrOXNIZk4zVXBxSEpFMWZhWmJJ?=
 =?utf-8?B?K1E4Y01ESjdabTBtNjFObzJxQ2tCYnFhUkRXUCsvTXp5eGZ1NmgxQy9Tb1NN?=
 =?utf-8?B?VVMvUGh4WG5ORVpzUUEvRGltWGI1VVlsRkROTWQxUDJ1dE95b0JySXBwaVpN?=
 =?utf-8?B?VmYvbVBVK3E3S0cxYVZzemc3TlBWMFptZWZicGkzWEtkSDBaU0RBNDh3eDkv?=
 =?utf-8?B?eDFBMDJqQ0ordVZyd1lLUks5bE1TemJiRSszRFRYUGJNanBLZmwvMFArWTV0?=
 =?utf-8?B?MXIwS0dxTW1WR25xY0dtNXJ2czJmL3N2SU4vdVFXNkIwSzBrTEEwdXBUS2ph?=
 =?utf-8?B?YTREZ1RLdlRtQytjdU1DbTlIcmh1S3EyRVRybSs0T3FZVVZ6cGhweEpWTm5P?=
 =?utf-8?B?alg2ckFkSUNtNVcyQmxja3hveEY0OGFZaHpjSTh4NkgwTVFrVEUzcDIweGFL?=
 =?utf-8?B?MGpoV3grb0tDKzE1WnNld3hxM0gvdnUxa2hWdDhTMkR0ZWZjZUNabVVuNnRY?=
 =?utf-8?B?T3o4Z2krQ3Q2QXIxaXlEWGkrZkdyVE1kb082OWk3eUR3aVJoanZ5ZittUE92?=
 =?utf-8?B?NEsrU0VvR3I4SmZIeUNOaGxaWUJ5NHR0cmU0WkRnTUFsT2lhYVN0L2lROU5H?=
 =?utf-8?B?YlRMNzRJTlZBNktPNWdUY1FnNGJqaWJETHgxcTBIZlNZWXJGdXBZQnY5bWVV?=
 =?utf-8?B?eFdvSDVPVjlBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Sm9vMCtQTHppVWR4ajQwRHhhaDhUMGh2aUpwckFUVFRLVVNrZUpCTTRocXlS?=
 =?utf-8?B?TFEyNmF4YmtURThNUWQ2eDlnem1haWZRa0U4SndRWkRiejFHY3hYSEtXd1J5?=
 =?utf-8?B?elYvTmpRRi9uaFA4ZWpoQWllSmNUUXg4allVR0ZwTGFhZWcyTnhKNTR5MnFr?=
 =?utf-8?B?N2JvVXJJcXhlS2dJNmpzZThTYlNmUmxwY2xMdVdvaklTRkd2cXpvVWRiejU2?=
 =?utf-8?B?TzZXMEVreXgydFUwc3FwMkJrdW1qUC91UnlNeHBTcHhvTUQ1MkpPVFh1NG9E?=
 =?utf-8?B?OVR2YWM0Q05tSG85MEdUVVNzVGpFUXBVcFpRcFRwb3A0b29iTTdUYWdORzZG?=
 =?utf-8?B?VnhKZU1EZHlNcW9lZHp2T3YrUURzUXBxQ3dYdGIyTHc3S1dmUXlqU3FyRUov?=
 =?utf-8?B?Wlk1ejhTZ3pFd3c5RDdvSlJoRngrNTJ6R0haZERRRmFsbzFqZy9FU3ducXk4?=
 =?utf-8?B?Q0ZyNi9adXUzOE1rcHE0SmdxRXpzUlFiTmZXbEZBcm5jaS9sVUFJdTdTdjRD?=
 =?utf-8?B?ck5HcFRPR1JGYVRwUkZRNUsrRU9rSlZTTnJNekk3ZGEzU2w4NVoxcGwxTFcy?=
 =?utf-8?B?aHlFdDNJNXpNZWd2SUNYRkIvL2VIb2l0MVJNRDFSYWt0a2ZHUitRb2tuM0RQ?=
 =?utf-8?B?R1pPM0pWS0F3NHhiODJlS2pxOW51c0R3YithK0kwWkovMmtIaUJ6ZlcwQ24v?=
 =?utf-8?B?VCtHRVFPTHBuZk5SYkkvN01lUFFZUFNFcFFoaG9sbUVBYURoblhOQ0hZZGpz?=
 =?utf-8?B?Q2NkY0hEZHplc0ZvTWFlQ0l4eEFhbDVBYUdVclk2cWZkUjhSak5HQXNBb3po?=
 =?utf-8?B?TStiTmZoTzNGYkt6RStCeW5oYjZKejl1N0RnMDBOei9hV0ZFV0c3QnNDMTR1?=
 =?utf-8?B?RzQwN21jdVBUM3krTXBjR253a3hDOVRkTjh5UDBsUzJmZWI1bXZTRGYvSzFp?=
 =?utf-8?B?NEx6Z1VEZHBNMnhvRVFBeGVJMHJiOFZCY2owN29yUC84VmIycTVDUkZYRDRQ?=
 =?utf-8?B?S05xeE1LelNtUUtKTVgweDlJL0FTZGhUa256NGFvM2ZzV2N6RC9LVzVKQ01w?=
 =?utf-8?B?akdsQk9DRWhkb1pSRHEzTUJUNDBPTUpmbjkxSklRYlRkMURheEt4VWIxM1Zq?=
 =?utf-8?B?MGhONkpUdk83M2RzUnJ3bitSY29tVW1jSzF6N05valk2WGZjSUtXYVljZ3Rj?=
 =?utf-8?B?NGYydjlVdHJPZVlsd0pRNGp6Tjc2b1JjVWRGZGFnYXFEdTdDeGErOHdnSkpM?=
 =?utf-8?B?OU9tUTluRzd1bFRXOUFBYmdlSThKY1dnSEhXdDUwQkxwVUIxK1RYSmhBcTg2?=
 =?utf-8?B?cmMxNlBiMjBmTnVzZVpKWlArN2N1NGcyTzdua2dLdm90d0ZQMDVQNnI0QjBs?=
 =?utf-8?B?ZHkyanMwVFdDUEFkVzZNSWdjUFFaUC9GUFZnbWE5T0tybDFGZ3orUngydkFW?=
 =?utf-8?B?Q2l6TnkzT2ZNdmRQYzh6U1Rucmh2UU9jVktUbXNrRmlnMVhBSVdmVXI1UEZI?=
 =?utf-8?B?NC94ZmlwRDFPZTdmMmxBYWJGMzhHcnRidStuZnRpeTdTcHJETVdmekhnd1hY?=
 =?utf-8?B?dG45TnVRczFzZXhaQ3VuVnJ1V3RmWGUyWmJoTDMrNW9GTHUvd0tiNUhMdDBP?=
 =?utf-8?B?WTNTZ2NQUlgrR3pGL0dBMGxPYWRQUTZvc1h4ZmxJQW1nQWtrQlp3SVhLTEJ3?=
 =?utf-8?B?Y3ZIYURmUHMwWTFGZ0xtNithc3J0TzUrNHU5RHFxQ210KzdBVDNmbk9EM0JZ?=
 =?utf-8?B?SCtVM0tvL0twSm1YeGRLZ0lmS25rYS9HMEYzN1NESms2SE1ySnR0RFpNNkZW?=
 =?utf-8?B?QjRiOWFXMW9XUEs4TEJ0bVB4SEhJdiswdmVwWllRbC9lcy9tV0FySlkyRXpq?=
 =?utf-8?B?MmVEMFpzMmNsbDFscm9DalltQWhScGhXUHFHT1F0RHRvZS9DREhOU3oyZWNH?=
 =?utf-8?B?NVZFOVRnVUh4Zmd3OFBlaHorUVowWVFNeGtWTGZYWHhvQkNYcUQydDJOVjda?=
 =?utf-8?B?ejVqZVFaTXI0cFkyOFBIcUVGUmhVUWNoc0hTaU9selpvSGdaazN5REJJejlW?=
 =?utf-8?B?Y1h4Z2F3WisxNHJuVGswQ3JlOC9Hb1Z3Z29DM21YQWFlVVBpQmcxd0VJTk9m?=
 =?utf-8?B?Q0M3akYzd1VVbFArZE9FWjh5b0ZpNG9SeVIwTXJHT0drYm9mU253N1dueUov?=
 =?utf-8?Q?ZAYwD7pLk/PtLCRjVGgcdMc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27F56E886D74294D8DD3854EAD80E950@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bac4b7e-1370-4581-2e61-08ddebe15a82
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2025 18:32:07.5002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qnV7A40kMqT/SEcd/25/0kURuqJiI6p+SW2MchHrFXXq9RnVS7gyb1ZrWkG0uaUaFG0z9PbDNf6qPGEjNZ9c8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5257
X-Proofpoint-ORIG-GUID: hlOe9hpJ5-Kv_Y2IpByDCYU4_0GIU9KC
X-Authority-Analysis: v=2.4 cv=FPMbx/os c=1 sm=1 tr=0 ts=68b9db2e cx=c_pps
 a=SzVIhQP/G3AuXdMMEvt//w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=8TYJizoqB-uRcDfSra0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: N9cbCaG2FxaZZ4cxkU2XyTnn2ZU8IIX_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfX+fUu1BaUOXiM
 VxFq9okw+YxpS8G2OL86Oun435Anmcu5Ddys9DmZE4z5a1IBACstWHGWRrKY08hc7JPF4Wvc+OS
 0lZVGZ0eOW9jkKk9BpaN/K31USeUNB8uKskTWSMJM48Nk2nZEAoXI820y0q/UZAQMVD+p4IbJJA
 owN7dGVpv5KqN81mhCqKsBzPPtVpwAfhJDvFrhTlPjje/biS9XBLPyQu/ja4s+WrGQbsVyOahkB
 uzbPqY+4eMCCneQfwX6v5Pq8+EGNCSDuH/E1HGIf6w8P4vXiva7LR/SGTwMamOY4ZV7M0xNedux
 7iwSeF6TCMpXdWf+sR0sy2VHnFhPHDsEGaCAQ/Ew+Odgl3E8+jHunZ/3Qymb3DGaqVJvCUKFQIB
 rqeXeLyQ
Subject: Re:  [PATCH v2 2/2] ceph/inode: drop extra reference from
 ceph_get_reply_dir() in ceph_fill_trace()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300034

T24gVGh1LCAyMDI1LTA5LTA0IGF0IDEwOjEyICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IGNlcGhfZ2V0X3JlcGx5X2RpcigpIG1heSByZXR1cm4gYSBkaWZmZXJlbnQsIHJlZmVyZW5jZWQg
aW5vZGUgd2hlbiByX3BhcmVudCBpcyBzdGFsZSBhbmQgdGhlIHBhcmVudCBkaXJlY3RvcnkgbG9j
ayBpcyBub3QgaGVsZC4NCj4gY2VwaF9maWxsX3RyYWNlKCkgdXNlZCB0aGF0IGlub2RlIGJ1dCBm
YWlsZWQgdG8gZHJvcCB0aGUgcmVmZXJlbmNlIHdoZW4gaXQgZGlmZmVyZWQgZnJvbSByZXEtPnJf
cGFyZW50LCBsZWFraW5nIGFuIGlub2RlIHJlZmVyZW5jZS4NCj4gDQo+IEtlZXAgdGhlIGRpcmVj
dG9yeSBpbm9kZSBpbiBhIGxvY2FsIGFuZCBpcHV0KCkgaXQgYXQgZnVuY3Rpb24gZW5kIGlmIGl0
IGRvZXMgbm90IG1hdGNoIHJlcS0+cl9wYXJlbnQuDQoNCkkgYXNzdW1lIHRoYXQgeW91IG1lYW4g
ImluIGEgbG9jYWwgdmFyaWFibGUiPw0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IE1hcmt1
emUgPGFtYXJrdXplQHJlZGhhdC5jb20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9pbm9kZS5jIHwgMzAg
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTkgaW5z
ZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9p
bm9kZS5jIGIvZnMvY2VwaC9pbm9kZS5jDQo+IGluZGV4IDQ3MGVlNTk1ZWNmMi4uY2ZmYTJjZDdi
NTMwIDEwMDY0NA0KPiAtLS0gYS9mcy9jZXBoL2lub2RlLmMNCj4gKysrIGIvZnMvY2VwaC9pbm9k
ZS5jDQo+IEBAIC0xNTg0LDYgKzE1ODQsNyBAQCBpbnQgY2VwaF9maWxsX3RyYWNlKHN0cnVjdCBz
dXBlcl9ibG9jayAqc2IsIHN0cnVjdCBjZXBoX21kc19yZXF1ZXN0ICpyZXEpDQo+ICAJc3RydWN0
IGNlcGhfdmlubyB0dmlubywgZHZpbm87DQo+ICAJc3RydWN0IGNlcGhfZnNfY2xpZW50ICpmc2Mg
PSBjZXBoX3NiX3RvX2ZzX2NsaWVudChzYik7DQo+ICAJc3RydWN0IGNlcGhfY2xpZW50ICpjbCA9
IGZzYy0+Y2xpZW50Ow0KPiArCXN0cnVjdCBpbm9kZSAqcGFyZW50X2RpciA9IE5VTEw7DQo+ICAJ
aW50IGVyciA9IDA7DQo+ICANCj4gIAlkb3V0YyhjbCwgIiVwIGlzX2RlbnRyeSAlZCBpc190YXJn
ZXQgJWRcbiIsIHJlcSwNCj4gQEAgLTE2MDEsOSArMTYwMiwxMyBAQCBpbnQgY2VwaF9maWxsX3Ry
YWNlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBjZXBoX21kc19yZXF1ZXN0ICpyZXEp
DQo+ICAJCSAqIHJfcGFyZW50IG1heSBiZSBzdGFsZSwgaW4gY2FzZXMgd2hlbiBSX1BBUkVOVF9M
T0NLRUQgaXMgbm90IHNldCwNCj4gIAkJICogc28gd2UgbmVlZCB0byBnZXQgdGhlIGNvcnJlY3Qg
aW5vZGUNCj4gIAkJICovDQo+IC0JCXN0cnVjdCBpbm9kZSAqZGlyID0gY2VwaF9nZXRfcmVwbHlf
ZGlyKHNiLCByZXEtPnJfcGFyZW50LCByaW5mbyk7DQo+IC0JCWlmIChkaXIpIHsNCj4gLQkJCWVy
ciA9IGNlcGhfZmlsbF9pbm9kZShkaXIsIE5VTEwsICZyaW5mby0+ZGlyaSwNCj4gKwkJcGFyZW50
X2RpciA9IGNlcGhfZ2V0X3JlcGx5X2RpcihzYiwgcmVxLT5yX3BhcmVudCwgcmluZm8pOw0KPiAr
CQlpZiAodW5saWtlbHkoSVNfRVJSKHBhcmVudF9kaXIpKSkgew0KPiArCQkJZXJyID0gUFRSX0VS
UihwYXJlbnRfZGlyKTsNCj4gKwkJCWdvdG8gZG9uZTsNCj4gKwkJfQ0KPiArCQlpZiAocGFyZW50
X2Rpcikgew0KPiArCQkJZXJyID0gY2VwaF9maWxsX2lub2RlKHBhcmVudF9kaXIsIE5VTEwsICZy
aW5mby0+ZGlyaSwNCj4gIAkJCQkJICAgICAgcmluZm8tPmRpcmZyYWcsIHNlc3Npb24sIC0xLA0K
PiAgCQkJCQkgICAgICAmcmVxLT5yX2NhcHNfcmVzZXJ2YXRpb24pOw0KPiAgCQkJaWYgKGVyciA8
IDApDQo+IEBAIC0xNjEyLDE0ICsxNjE3LDE0IEBAIGludCBjZXBoX2ZpbGxfdHJhY2Uoc3RydWN0
IHN1cGVyX2Jsb2NrICpzYiwgc3RydWN0IGNlcGhfbWRzX3JlcXVlc3QgKnJlcSkNCj4gIAkJCVdB
Uk5fT05fT05DRSgxKTsNCj4gIAkJfQ0KPiAgDQo+IC0JCWlmIChkaXIgJiYgcmVxLT5yX29wID09
IENFUEhfTURTX09QX0xPT0tVUE5BTUUgJiYNCj4gKwkJaWYgKHBhcmVudF9kaXIgJiYgcmVxLT5y
X29wID09IENFUEhfTURTX09QX0xPT0tVUE5BTUUgJiYNCj4gIAkJICAgIHRlc3RfYml0KENFUEhf
TURTX1JfUEFSRU5UX0xPQ0tFRCwgJnJlcS0+cl9yZXFfZmxhZ3MpICYmDQo+ICAJCSAgICAhdGVz
dF9iaXQoQ0VQSF9NRFNfUl9BQk9SVEVELCAmcmVxLT5yX3JlcV9mbGFncykpIHsNCj4gIAkJCWJv
b2wgaXNfbm9rZXkgPSBmYWxzZTsNCj4gIAkJCXN0cnVjdCBxc3RyIGRuYW1lOw0KPiAgCQkJc3Ry
dWN0IGRlbnRyeSAqZG4sICpwYXJlbnQ7DQo+ICAJCQlzdHJ1Y3QgZnNjcnlwdF9zdHIgb25hbWUg
PSBGU1RSX0lOSVQoTlVMTCwgMCk7DQo+IC0JCQlzdHJ1Y3QgY2VwaF9mbmFtZSBmbmFtZSA9IHsg
LmRpcgk9IGRpciwNCj4gKwkJCXN0cnVjdCBjZXBoX2ZuYW1lIGZuYW1lID0geyAuZGlyCT0gcGFy
ZW50X2RpciwNCj4gIAkJCQkJCSAgICAubmFtZQk9IHJpbmZvLT5kbmFtZSwNCj4gIAkJCQkJCSAg
ICAuY3RleHQJPSByaW5mby0+YWx0bmFtZSwNCj4gIAkJCQkJCSAgICAubmFtZV9sZW4JPSByaW5m
by0+ZG5hbWVfbGVuLA0KPiBAQCAtMTYyOCwxMCArMTYzMywxMCBAQCBpbnQgY2VwaF9maWxsX3Ry
YWNlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBjZXBoX21kc19yZXF1ZXN0ICpyZXEp
DQo+ICAJCQlCVUdfT04oIXJpbmZvLT5oZWFkLT5pc190YXJnZXQpOw0KPiAgCQkJQlVHX09OKHJl
cS0+cl9kZW50cnkpOw0KPiAgDQo+IC0JCQlwYXJlbnQgPSBkX2ZpbmRfYW55X2FsaWFzKGRpcik7
DQo+ICsJCQlwYXJlbnQgPSBkX2ZpbmRfYW55X2FsaWFzKHBhcmVudF9kaXIpOw0KPiAgCQkJQlVH
X09OKCFwYXJlbnQpOw0KPiAgDQo+IC0JCQllcnIgPSBjZXBoX2ZuYW1lX2FsbG9jX2J1ZmZlcihk
aXIsICZvbmFtZSk7DQo+ICsJCQllcnIgPSBjZXBoX2ZuYW1lX2FsbG9jX2J1ZmZlcihwYXJlbnRf
ZGlyLCAmb25hbWUpOw0KPiAgCQkJaWYgKGVyciA8IDApIHsNCj4gIAkJCQlkcHV0KHBhcmVudCk7
DQo+ICAJCQkJZ290byBkb25lOw0KPiBAQCAtMTY0MCw3ICsxNjQ1LDcgQEAgaW50IGNlcGhfZmls
bF90cmFjZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBzdHJ1Y3QgY2VwaF9tZHNfcmVxdWVzdCAq
cmVxKQ0KPiAgCQkJZXJyID0gY2VwaF9mbmFtZV90b191c3IoJmZuYW1lLCBOVUxMLCAmb25hbWUs
ICZpc19ub2tleSk7DQo+ICAJCQlpZiAoZXJyIDwgMCkgew0KPiAgCQkJCWRwdXQocGFyZW50KTsN
Cj4gLQkJCQljZXBoX2ZuYW1lX2ZyZWVfYnVmZmVyKGRpciwgJm9uYW1lKTsNCj4gKwkJCQljZXBo
X2ZuYW1lX2ZyZWVfYnVmZmVyKHBhcmVudF9kaXIsICZvbmFtZSk7DQo+ICAJCQkJZ290byBkb25l
Ow0KPiAgCQkJfQ0KPiAgCQkJZG5hbWUubmFtZSA9IG9uYW1lLm5hbWU7DQo+IEBAIC0xNjU5LDcg
KzE2NjQsNyBAQCBpbnQgY2VwaF9maWxsX3RyYWNlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0
cnVjdCBjZXBoX21kc19yZXF1ZXN0ICpyZXEpDQo+ICAJCQkJICAgICAgZG5hbWUubGVuLCBkbmFt
ZS5uYW1lLCBkbik7DQo+ICAJCQkJaWYgKCFkbikgew0KPiAgCQkJCQlkcHV0KHBhcmVudCk7DQo+
IC0JCQkJCWNlcGhfZm5hbWVfZnJlZV9idWZmZXIoZGlyLCAmb25hbWUpOw0KPiArCQkJCQljZXBo
X2ZuYW1lX2ZyZWVfYnVmZmVyKHBhcmVudF9kaXIsICZvbmFtZSk7DQo+ICAJCQkJCWVyciA9IC1F
Tk9NRU07DQo+ICAJCQkJCWdvdG8gZG9uZTsNCj4gIAkJCQl9DQo+IEBAIC0xNjc0LDEyICsxNjc5
LDEyIEBAIGludCBjZXBoX2ZpbGxfdHJhY2Uoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgc3RydWN0
IGNlcGhfbWRzX3JlcXVlc3QgKnJlcSkNCj4gIAkJCQkgICAgY2VwaF9zbmFwKGRfaW5vZGUoZG4p
KSAhPSB0dmluby5zbmFwKSkgew0KPiAgCQkJCWRvdXRjKGNsLCAiIGRuICVwIHBvaW50cyB0byB3
cm9uZyBpbm9kZSAlcFxuIiwNCj4gIAkJCQkgICAgICBkbiwgZF9pbm9kZShkbikpOw0KPiAtCQkJ
CWNlcGhfZGlyX2NsZWFyX29yZGVyZWQoZGlyKTsNCj4gKwkJCQljZXBoX2Rpcl9jbGVhcl9vcmRl
cmVkKHBhcmVudF9kaXIpOw0KPiAgCQkJCWRfZGVsZXRlKGRuKTsNCj4gIAkJCQlkcHV0KGRuKTsN
Cj4gIAkJCQlnb3RvIHJldHJ5X2xvb2t1cDsNCj4gIAkJCX0NCj4gLQkJCWNlcGhfZm5hbWVfZnJl
ZV9idWZmZXIoZGlyLCAmb25hbWUpOw0KPiArCQkJY2VwaF9mbmFtZV9mcmVlX2J1ZmZlcihwYXJl
bnRfZGlyLCAmb25hbWUpOw0KPiAgDQo+ICAJCQlyZXEtPnJfZGVudHJ5ID0gZG47DQo+ICAJCQlk
cHV0KHBhcmVudCk7DQo+IEBAIC0xODY5LDYgKzE4NzQsOSBAQCBpbnQgY2VwaF9maWxsX3RyYWNl
KHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBjZXBoX21kc19yZXF1ZXN0ICpyZXEpDQo+
ICAJCQkJCSAgICAmZHZpbm8sIHB0dmlubyk7DQo+ICAJfQ0KPiAgZG9uZToNCj4gKwkvKiBEcm9w
IGV4dHJhIHJlZiBmcm9tIGNlcGhfZ2V0X3JlcGx5X2RpcigpIGlmIGl0IHJldHVybmVkIGEgbmV3
IGlub2RlICovDQo+ICsJaWYgKHVubGlrZWx5KCFJU19FUlJfT1JfTlVMTChwYXJlbnRfZGlyKSAm
JiBwYXJlbnRfZGlyICE9IHJlcS0+cl9wYXJlbnQpKQ0KDQpUaGUgJyYmJyBpbXBsaWVzIHRvIGNo
ZWNrIGJvdGggY29uZGl0aW9ucy4gSG93ZXZlciwgaWYgd2UgaGF2ZSBwYXJlbnRfZGlyIGVxdWFs
DQp0byBOVUxMIG9yIHNvbWUgZXJyb3IgY29kZSwgdGhlbiBpdCBkb2Vzbid0IG1ha2Ugc2Vuc2Ug
dG8gY2hlY2sgdGhlIHNlY29uZA0KY29uZGl0aW9uLiBJIGRvbid0ICB0aGluayB0aGF0IGl0IGNv
dWxkIGludHJvZHVjZSBzb21lIGlzc3VlIGhlcmUuIEJ1dCwNCnBvdGVudGlhbGx5LCBpdCBjb3Vs
ZCBiZSB0aGUgcmVhc29uIG9mIHJhcmVseSB0cmlnZ2VyZWQgYW5kIG5vbi10cml2aWFsIGlzc3Vl
Lg0KV2hhdCBkbyB5b3UgdGhpbms/IERvIEkgaGF2ZSBwb2ludCBoZXJlPw0KDQpXaGF0IGlmIHdl
IGNhbiBkbyBsaWtlIHRoaXM6DQoNCnBhcmVudF9kaXIgPSBwYXJlbnRfZGlyICE9IHJlcS0+cl9w
YXJlbnQgPyBwYXJlbnRfZGlyIDogTlVMTDsNCmlmIChwYXJlbnRfZGlyKQ0KICAgIGlwdXQocGFy
ZW50X2Rpcik7DQoNCg0KPiArCQlpcHV0KHBhcmVudF9kaXIpOw0KDQpQb3RlbnRpYWxseSwgd2Ug
Y291bGQganVtcCBoZXJlIGlmIHdlIGhhdmUgdGhlIGVycm9yLg0KDQo+ICAJZG91dGMoY2wsICJk
b25lIGVycj0lZFxuIiwgZXJyKTsNCj4gIAlyZXR1cm4gZXJyOw0KPiAgfQ0KDQpNb3N0bHksIGxv
b2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5
a29AaWJtLmNvbT4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

