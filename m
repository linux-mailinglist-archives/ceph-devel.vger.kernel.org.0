Return-Path: <ceph-devel+bounces-3735-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B578CBA1316
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 21:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70B7F62472F
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 19:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F547257858;
	Thu, 25 Sep 2025 19:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AsplN/Bg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C3E54F81
	for <ceph-devel@vger.kernel.org>; Thu, 25 Sep 2025 19:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758828710; cv=fail; b=Lccb6hBHLqdK3O0WE5NSE9WPYBbcygfEp6oBqQckMMrQgXmLY3/Ul+GHh6JoCjhNHHwAGdq3dpRNV3tsu9O42mPlulIaa+8JG8c1lposBdau/zpo7DxQi/Ix/Hj+XMcTPW+qbnpKhBaOjP+p59AYV03QurtENzQoY/p/5d8lQyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758828710; c=relaxed/simple;
	bh=QqvKlupA8hv7c9e7+gCDOQq0G5HoRVAYLSK2efQI+Tk=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=A2jzFSJExQtCibwm9U1WCk0SneIt2CtGs/oOeDX/nLn/Af4a5vpyW6fQTfv6PaxrxO+6PaDDozTTSHaF1dGb/gI4DFrWURxQebbgqwjT4cYCRdBfMiQKFVNZjDvyvuV0rPEDucf6Uzn7nwGrOtlFsmqvZLjH025COun0hYCpPyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AsplN/Bg; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58PIlq66029541;
	Thu, 25 Sep 2025 19:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=QqvKlupA8hv7c9e7+gCDOQq0G5HoRVAYLSK2efQI+Tk=; b=AsplN/Bg
	KpjZ2MbFxvnNau/ALvCVbxjkhdiEhQOgswZJAtt9Pd6p0m6eGpMLHUfH/dlcPCm2
	6tuRucxfovC/EG6KJBoqyRdE8KyQTx8ae04PC1wRUpTXaBU+Fz4hfwCvSpDsuMOH
	6C+FDGkYMysOWRPEicMzUYyVz9eC5Ed/dWFhJQZf70kEaqb3nTQKQ8/NCIBnYAzY
	dI3JO49dKSeqcpehKEV9HMP4kQbw4Cd/VjsiSujQiMFjVJUXASv7YVoCFGgP5Rcd
	CsPE+tmWEj+irPIvfFuVxBgjjTn4eBYtujEz43Om+ueTn7HAT/HSzx/i/2U1X3cA
	fJp0nQrZKZOwqQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbb3r6xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 19:31:34 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58PJFGZG023085;
	Thu, 25 Sep 2025 19:31:34 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012003.outbound.protection.outlook.com [52.101.43.3])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbb3r6xn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 19:31:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pswZiXeNN7MbmucA0MTSyCskEpRr5Sif7mqkOyV/oghIEwGtZZ9DH97RTgCamSfHAbl9FQWKgLo8YOf/alsQxG/u7LGUVAq7Kkp9OymBRMzB2QCfVve+0ehXyvohwQPkz9ahgkYdEN8nb4DnNbhn1xguyjxY0T2jFJLYhVhL02YgqC81qc1qLFKEz8o48mPaLoz6W5+ja/R0Gya3Jil42Yk2zMcvdtafOAZJckWRS919lDb2eblYvQgyDcDB1p7s6hZscWPKirpaWmdihPXi9X5OabCwnfTV76iuXrfwScrolEvU+i6fcg7pT3dJB4kVLreNXAhGYRUdn4JzRB1a6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqvKlupA8hv7c9e7+gCDOQq0G5HoRVAYLSK2efQI+Tk=;
 b=WhP3Tk58OEoq0TBZFHrFbF0v4Z4H+MfyCDFbcVGakyuWJ2roVrgdWp+g0EAH6Fxk4wIvW0TMPKBAzMfNNWCRerEzTGngkkVazHS+bDtHf099TPfU0CeaZTHFnY9hi/hkdIcwbvVXNVRCg2WSLHra6FtgR/qqAfod3BSAxbcFkxBhTJPK7DSBolk1ibTN+8+aRu+2AgEprBPF7AHgoU7ydp3vBqbPZfcm4+e9seRbLx2k6iB0tm1j3EjvXTDjZHfEV2UABn70ZrxPNcO4d8uC8Ky/jE+16lupdR5U4tpRC4M4UWnyqJzkKueTo21rNI4eiJC+0+W/5DjUpfst9Cq7Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA0PR15MB3904.namprd15.prod.outlook.com (2603:10b6:806:85::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Thu, 25 Sep
 2025 19:31:32 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Thu, 25 Sep 2025
 19:31:31 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethan198912@gmail.com" <ethan198912@gmail.com>
CC: "ethanwu@synology.com" <ethanwu@synology.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: fix snapshot context missing in
 ceph_zero_partial_object
Thread-Index: AQHcLgaTOVkisHhJgUyzfffA1F/3ErSkSfCA
Date: Thu, 25 Sep 2025 19:31:31 +0000
Message-ID: <aaec30ab3625df9f727d10878556915a0a681dd0.camel@ibm.com>
References: <20250924095807.27471-1-ethanwu@synology.com>
	 <20250924095807.27471-2-ethanwu@synology.com>
	 <396d9279317ff76f26eabf541281ff94fda5505d.camel@ibm.com>
	 <CACKp3fk4Bs75G5pEFV0Hyd3Ft0-3HxF58n50gzojMGv1fSJbNw@mail.gmail.com>
In-Reply-To:
 <CACKp3fk4Bs75G5pEFV0Hyd3Ft0-3HxF58n50gzojMGv1fSJbNw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA0PR15MB3904:EE_
x-ms-office365-filtering-correlation-id: 56886433-40bb-4f53-b3a8-08ddfc6a21b5
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WWxHNnpJZGlTL2hUdnJSa1haQzRjWUFLU2dQR0RwU051dTVsRkRnenJKOVhk?=
 =?utf-8?B?bW0rTDdOcUZrVlhodERLTmVxZTAxWUZ4TElIUWluTmZtc2lkUnhtUDJSb1Nv?=
 =?utf-8?B?bGVUaXFua0p3Ymc2Ny9MZDEzTXVJdk9GaEl3TWpVVmwzc2tuQklSRVQzY0FM?=
 =?utf-8?B?NzNvKzRKbzVEdFp5a3NucGIvdExCUFNrZVlLenFxRkVNemNDN3k2SEdDeU4y?=
 =?utf-8?B?T3N4emx5NjhDYW41QjJSU3pkclBIaVpqMVpLak9UYzJTWUlNajdXZno2d0Ri?=
 =?utf-8?B?NVVtdkwrTWZCRFVqM2xyZUJwYnFCUndqSGFHWkdNZVRya2hNM1NsQWRCandY?=
 =?utf-8?B?T2dSZ0RqL2Y3QllXWFZITE92SlJJOTh3Y2JoSXNkODNUVE9EdlY3NXBHYWJ3?=
 =?utf-8?B?OER1VkwrR01VMWVBYzFMQXhORTlsSEM1QU5DSmN3SGYyTmFHMytMaDJhVzZs?=
 =?utf-8?B?RlJRVEV5Tkx3VEJiU0l2QkxEWSt2RDlhMTIyaWIyRTZWUUxRdndaeGZXcmYz?=
 =?utf-8?B?NEhLMm0rMThXZXJKZ0hNZE85d3U3MW5tdDVwdUpSck9POVBRbzAvaitRNG56?=
 =?utf-8?B?bzZTUzdOU291ZzkxdytQbFBnUndKQ2E3N21hZzNHWGZ6cGhKK2tqM3VPUnph?=
 =?utf-8?B?aXhWeldCSFVNTk5Ka3l4aEUva3ZiTElFTnRyd2lHeENLa3BmOFl2WkhyK2NR?=
 =?utf-8?B?RERUY0hrMTF6N09IalNoVXhZOUFXT1BPYkk2YjNDTDRmQTA0VWdYdUcvWDJr?=
 =?utf-8?B?L0tYUnJrS2plZ3kxZVBZTW1PT1U5RldPSENFRFFneFFJSjR2Vi9OWXNiUjRX?=
 =?utf-8?B?UzAxUnplVlk1dDZzR2phc0s0eUUwZkd4eEl4c2lMeEdyM3BvKys2MFd4UFlF?=
 =?utf-8?B?bjVYZ2RuMVMrc3I2WXRwQ1Bvbkg1K1llcitvMGJDc0NKNWZVVEFCaGw3VjFx?=
 =?utf-8?B?VTg5VmZHdnhnc1c5ZldMVEJveVpKWDdVckJnNkNiUGMzMWJGREdxaUxCZm5i?=
 =?utf-8?B?WUxQQkZFb203SzhrMXV0M242YWtlODVIMWoxM1crNFZyWHptQUxBeko3OG5L?=
 =?utf-8?B?YkwyVlh4K1dVZW5BdzJuZjFPa3B2STBzVmNCamVnM1VaUE5ySFRhcVQ5SW5h?=
 =?utf-8?B?dnlVaElmU2J6VkhXaDlua3BGcVE5a0h2cklmNlhVeGp5MngvRGdyY0ZmOXlv?=
 =?utf-8?B?aVVqUUxveEN1a3Y3cFdCZzVEdGZXNWFGQnZnZ0hYeGFoNFdpZVdLTmZLMEwx?=
 =?utf-8?B?RDhld2FSY2RQQktHU2c3Vi9YK2xWOWovYkxYVzFLS3d5VnJUaXhBVmtsTmJs?=
 =?utf-8?B?YlIxL2ZoRXBrckhSL2Ywam81VnRSZ3YxU2JPa1JlL2JFQXplZVN0ajJmaG1r?=
 =?utf-8?B?U1Irb3N5clJpOEtkQXhhTW8vcFRSM1Z4SXV6cFBpN0dDSUJzTTVGUkM5L2tQ?=
 =?utf-8?B?NWwwOHU3VlVUcmdEdnhmSmlqdm1GckVYRlpkRlZ3ci9SbEVac3J6eVFYa3k1?=
 =?utf-8?B?SmZENEszbVpkQXEzMVArbnUzR3ZodUhPdzI4c1NOWkFTMjROYlFlM09uaFFm?=
 =?utf-8?B?SVgzSFdaYVJHcU9iVC9wN3E1L3NNU2RGZzFSYUg1THlDY3laeHJ5ZjU2WFJh?=
 =?utf-8?B?WndNaFhPTmxCOEtqa0NhUzlialNJTjl0MENUMlhMd2Z2bUpiQWpuM3dlcjJs?=
 =?utf-8?B?clhqVm5ZaXNGSEV5N1BSSTVmOHhQM1hGdW9kSDFxTDRsL01ZUTF5YWY0ZGxy?=
 =?utf-8?B?UUdLblJjMytGcER3Q1cxd2tpUmllVTZ3UGNGSHZ2M3hBWEowNVVHU2wyNFhz?=
 =?utf-8?B?b01wTmkvQTBoZ0habHB4aTAzZDhDZkF4bm5wSG81TTc1TDYvZnhVWC9reERh?=
 =?utf-8?B?UEdmYjZ6MEdGKytkVDlkRnRYN1VSeWpJN0NXaE45VXBZTXVraTB6MFdSdDdZ?=
 =?utf-8?B?MER6aEpyYlg4V1BlZGRjQVRjc0ZuaTVMNXpXTENGdm51bUl3cXI4K0FodEh3?=
 =?utf-8?Q?1t1uugDIVrhVRsgiPjm4LNtLBLVrYw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MXlRdVhsVWF1TTF1NnZDSGpBZitlTkVhSEhzaEtzWFE2UzdpUy95dHl4azZl?=
 =?utf-8?B?dHE0QUVFQ2t5d1BKUlZ6NkRyWSsvWmhzMFVMVE93TG0vN0FET1pldjExcE5T?=
 =?utf-8?B?Y21kVE4xR2J5SmVybCszc0hESjM5NzVTc1B0N3RSczZsZ29JcXNwdWNnbkha?=
 =?utf-8?B?Y2QrTWlWeHNJMC8rdGFKOGtuNG9aR09GUGNIc1ZVUzFYMDNXUVpSemN6Q2tz?=
 =?utf-8?B?VkFxQk45WGtDK01GWmFnWFRhZ0s2NlRoVnlVazJFOUkyZVE1dmdBVnRyYjBM?=
 =?utf-8?B?bUJ0NGFnTE5tUCtPTEloWmN6YTZkdUJpajI3aDMwN1dieHBDeXdVQnQxbmk2?=
 =?utf-8?B?NzBMNENRSVdBMXF0TkZXRklRQUdlU1FNUGpOMjQxRjZoRTlBOHg5MzlBVERR?=
 =?utf-8?B?YW5LU2NXZUw1eEFtNW1Vc29CeFhjeEZ5V0J0QXdCUm5IOVRDcEN2UmxpSmkz?=
 =?utf-8?B?VFI2dXJEbFRMSEVaYkVWVThQbmp1S0IrdkREajZBenR6alZZRDU1U3hwOURH?=
 =?utf-8?B?bTlyVHNyZC9qKzYzQUpTcDFTZStGM1ZpdEVjTmxEOTNyT0RqYnRUcWlCVjBn?=
 =?utf-8?B?Y1lQT1c5Q0ZMTnhpczMvVDQwdktZZittSkgxTFdoQ2h6SG1NVXlhUzUwcWtn?=
 =?utf-8?B?N3pneVpSL2czZ1BuYjFMb0xFemFQWEVGeitiRWpyVEV5bkJXZTJYaWdVOXdo?=
 =?utf-8?B?em14WHI4K0VmUmwwbGpVMTBwWEhHSm9MVkRKQ01uWCtkQXpoN2JpN2l6MElU?=
 =?utf-8?B?eVNITzFaY3dRQTdRWHE2VG81RllGZWpHbmtXN3VLWDMxYlFWMldYOVdBa29D?=
 =?utf-8?B?bFVmQzhOOGdaTkNrbHV1WXNRUjJxOUZEQW5RQUJVYjV6K1BWTytuVFNELzl3?=
 =?utf-8?B?UHFTbFF0SmNUK01zcHlxOXdtWWtGYWlBeUxrRTlwaVJ5bWMyT0YrZXhvdEdP?=
 =?utf-8?B?WWxnTzRlTzhaeUtuVEkxWGZjdGQ3VmtYVTFyUm1qMmFlM1MzUlkvME55WllR?=
 =?utf-8?B?MU1qQnYrbTVXN0dwcWFOZmxRaXpRbTVvN1NuWm1BUHdxeFA2VmVkYUUvMFdq?=
 =?utf-8?B?eGhWVWhCUVNXeDN5ckNaRFIwc1AzTmZXaFFXRXo0MWNmMzlGcDRyRHdDVEdr?=
 =?utf-8?B?WFNIa2VETnI2YmlORUp4OHM4L1NTWUNvNm5UUGp0OFB3M3NaUDhtSmJxODNW?=
 =?utf-8?B?M2tqeVVsZGg4WU5YWEpUU0VKN3dTSFF0SHk1MFZZckZpNEVuRmRJZytUSjFN?=
 =?utf-8?B?MnpxLzRSTVpucEdxcVZ2azVWelowVEN0dHdJSUZIdlBsaE9acFZsSjJTZlBP?=
 =?utf-8?B?blNWN3V5ZE1tcFJMN0UrOG1kSHgrM0lnVkxLdnZTNXBwbGErQUtockg5cTNt?=
 =?utf-8?B?UUc4d09MYys4ZXpzM1dmOHkyZXlRcndKdHZaZGVRNVhTNU01YnZhalR5V0tB?=
 =?utf-8?B?VmNtd0x5RW9kcEtyY09hakdheU5LOEtvSml0Qkd6enFvSFVydllLN0l2bER5?=
 =?utf-8?B?MElOajlTQ2grQnZBcW9mUnc3eFpJUjNFZGtHSmNuTzE0OTY2Z3RNL3drRE1G?=
 =?utf-8?B?OGx4TlpXVFdEeTltaDVEemNFWjVaU1ZQYlcxMlg1OGdMTDN2U3JkSUNYNHA1?=
 =?utf-8?B?Y0ZSUFBZMWh5bmxPUEdRdWE4TFhUbUZhYm9QcEtVdlNtU2UyMExXUDZ6UzU1?=
 =?utf-8?B?eHZxK1dVSmpuTG9NK25IdFRYR29wL0F2R21JWWk4RkpnVHNFNnkxY2lpTHFO?=
 =?utf-8?B?TnRZYThENFlqSHpOWGVDclJjeGU4MW52Q3RUM1drVWp2L0NjeUMrTTd5RFlp?=
 =?utf-8?B?czdNM0lQbjNYS3VHdVJ3aFhUcmhzL3l5R2EvZWRNR3BTS1pHeVNSbUMyUG5Z?=
 =?utf-8?B?dXBTdTZ3ZTltZlN3WHVFc3Y5Y1ppcEtQeE10R0pIKzZEcmlFOXlqZ0pTVkZL?=
 =?utf-8?B?VzRWMUMvbXhBNDlicW93QjIrNEMzeCtweC82V2wxcmdvQ1FyUUhMZkN5NGtQ?=
 =?utf-8?B?NVJzWDBCbXp6WmcrWmN5d2V3U0oyRjFnMVJzZzl6ejczQ3p6di9VN2Z0UGdP?=
 =?utf-8?B?TmcvQWZ0SFhkYVdwM290WEVEc0tFZ01YZEFBL0JiRlk4RUREcXVmMjl4T0Jm?=
 =?utf-8?B?OXJ6MjFOVHRuQ3k4Zkh1Ymhzbm9NY1pLbjRYZEs5V0hhS2JRR3ZpcnlTWVZR?=
 =?utf-8?Q?EjV+1obeWAFM66efHiXwxYU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AFA0C74D6FBDF4E83613624729BE645@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 56886433-40bb-4f53-b3a8-08ddfc6a21b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 19:31:31.8382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yz9ld9+W+vW/D/aZbnWN/U852prJ1FX+WA7Jt91+BhKK5VLkjHmYmm58C2NlT//EhqXZ3N85liw5dtX+0svUUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3904
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3NCBTYWx0ZWRfX0BkSr1Z2bBqL
 6xEJ/hlL8iBlmzzcHZhq0kCzy9W8Th1AHrXs2+ThhdaPC2FbZoAW0A2gN/GDSb0e7a8OO78wnrZ
 eXInCujsLxNmsslVUhhnYdo7umxU4HEvV3H02slCKz+wjgb5W7vbP41jjYDjNvpzVBLUOyxSQVd
 YSC9mYxOnTxPWU+lIEnMmIZkYq1H2JXCDAfmrGZcXOc1xMze+NgF3RK4+qo1ww8EdbCCw6jS3gt
 UTh4fgVCA/xy2qln3XwQMYEoF2SS0tBfvulENEfN6oArwDzV37IpSFIKW0Viu8/1Q5QzQgZoy0M
 5XWiX28L7GRmPuS4L1LyaspZ6oj38Kprv+q5+7aTOyMn+IQtIhih9dMnsps39tqiruSrFGdmDp3
 0s2MNAweHrUe5Qsbqwk/I6Fc6TtsJA==
X-Proofpoint-GUID: 6Lvbwe7mbL00wKNM5gebaolc6yJbFpAx
X-Authority-Analysis: v=2.4 cv=T/qBjvKQ c=1 sm=1 tr=0 ts=68d59896 cx=c_pps
 a=ayBBURk7jZ4GzqZFlR2IhQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=LM7KSAFEAAAA:8 a=l9M8jkphym1R6I8tHycA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: M54DNvj5blUsLuNwofgYZGtwUrct22VB
Subject: RE: [PATCH] ceph: fix snapshot context missing in
 ceph_zero_partial_object
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250174

T24gVGh1LCAyMDI1LTA5LTI1IGF0IDE4OjI0ICswODAwLCB0enVjaGllaCB3dSB3cm90ZToNCj4g
VmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+IOaWvCAyMDI15bm0Oeac
iDI15pelIOmAseWbmyDkuIrljYgyOjI25a+r6YGT77yaDQo+ID4gDQo+ID4gT24gV2VkLCAyMDI1
LTA5LTI0IGF0IDE3OjU4ICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiA+ID4gVGhlIGNlcGhfemVy
b19wYXJ0aWFsX29iamVjdCBmdW5jdGlvbiB3YXMgbWlzc2luZyBwcm9wZXIgc25hcHNob3QNCj4g
PiA+IGNvbnRleHQgZm9yIGl0cyBPU0Qgd3JpdGUgb3BlcmF0aW9ucywgd2hpY2ggY291bGQgbGVh
ZCB0byBkYXRhDQo+ID4gPiBpbmNvbnNpc3RlbmNpZXMgaW4gc25hcHNob3RzLg0KPiA+ID4gDQo+
ID4gPiBSZXByb2R1Y2VyOg0KPiA+ID4gZGQgaWY9L2Rldi91cmFuZG9tIG9mPS9tbnQvbXljZXBo
ZnMvZm9vIGJzPTY0SyBjb3VudD0xDQo+ID4gPiBta2RpciAvbW50L215Y2VwaGZzLy5zbmFwL3Nu
YXAxDQo+ID4gPiBtZDVzdW0gL21udC9teWNlcGhmcy8uc25hcC9zbmFwMS9mb28NCj4gPiA+IGZh
bGxvY2F0ZSAtcCAtbyAwIC1sIDQwOTYgL21udC9teWNlcGhmcy9mb28NCj4gPiA+IGVjaG8gMyA+
IC9wcm9jL3N5cy92bS9kcm9wL2NhY2hlcw0KPiA+ID4gbWQ1c3VtIC9tbnQvbXljZXBoZnMvLnNu
YXAvc25hcDEvZm9vICMgZ2V0IGRpZmZlcmVudCBtZDVzdW0hIQ0KPiA+ID4gDQo+ID4gDQo+ID4g
SSBhc3N1bWUgdGhhdCBpdCdzIG5vdCBjb21wbGV0ZSByZXByb2R1Y3Rpb24gcmVjaXBlLiBJdCBu
ZWVkcyB0byBlbmFibGUgdGhlDQo+ID4gc3VwcG9ydCBvZiBzbmFwc2hvdCBmZWF0dXJlIGFzIHdl
bGwuDQo+IA0KPiBJIHVzZSAuLi9zcmMvdnN0YXJ0LnNoIC0tbmV3IC14IC0tbG9jYWxob3N0IC0t
Ymx1ZXN0b3JlDQo+IHRvIGRlcGxveSB0aGUgY2VwaGZzIGVudmlyb25tZW50IGFuZCB0aGUgZnMg
YWxsb3dfc25hcHMgaXMgZW5hYmxlZCBieSBkZWZhdWx0Lg0KPiBidXQgY2xpZW50IHNuYXAgYXV0
aCBpcyBuZWVkZWQuDQo+IEkgdXNlIHRoZSBmb2xsb3dpbmcgY29tbWFuZCB0byBncmFudCB0aGUg
YXV0aA0KPiAuL2Jpbi9jZXBoIGF1dGggY2FwcyBjbGllbnQuZnNfYSBtZHMgJ2FsbG93IHJ3cHMg
ZnNuYW1lPWEnIG1vbiAnYWxsb3cNCj4gciBmc25hbWU9YScgb3NkICdhbGxvdyBydyB0YWcgY2Vw
aGZzIGRhdGE9YScNCj4gDQo+ID4gDQo+ID4gPiB3aWxsIGdldCB0aGUgc2FtZQ0KPiA+ID4gDQo+
ID4gPiBGaXhlczogYWQ3YTYwZGU4ODJhYyAoImNlcGg6IHB1bmNoIGhvbGUgc3VwcG9ydCIpDQo+
ID4gPiBTaWduZWQtb2ZmLWJ5OiBldGhhbnd1IDxldGhhbnd1QHN5bm9sb2d5LmNvbT4NCj4gPiA+
IC0tLQ0KPiA+ID4gIGZzL2NlcGgvZmlsZS5jIHwgMTcgKysrKysrKysrKysrKysrKy0NCj4gPiA+
ICAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4g
DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9maWxlLmMgYi9mcy9jZXBoL2ZpbGUuYw0KPiA+
ID4gaW5kZXggYzAyZjEwMGY4NTUyLi41OGNjMmNiYWU4YmMgMTAwNjQ0DQo+ID4gPiAtLS0gYS9m
cy9jZXBoL2ZpbGUuYw0KPiA+ID4gKysrIGIvZnMvY2VwaC9maWxlLmMNCj4gPiA+IEBAIC0yNTcy
LDYgKzI1NzIsNyBAQCBzdGF0aWMgaW50IGNlcGhfemVyb19wYXJ0aWFsX29iamVjdChzdHJ1Y3Qg
aW5vZGUgKmlub2RlLA0KPiA+ID4gICAgICAgc3RydWN0IGNlcGhfaW5vZGVfaW5mbyAqY2kgPSBj
ZXBoX2lub2RlKGlub2RlKTsNCj4gPiA+ICAgICAgIHN0cnVjdCBjZXBoX2ZzX2NsaWVudCAqZnNj
ID0gY2VwaF9pbm9kZV90b19mc19jbGllbnQoaW5vZGUpOw0KPiA+ID4gICAgICAgc3RydWN0IGNl
cGhfb3NkX3JlcXVlc3QgKnJlcTsNCj4gPiA+ICsgICAgIHN0cnVjdCBjZXBoX3NuYXBfY29udGV4
dCAqc25hcGM7DQo+ID4gPiAgICAgICBpbnQgcmV0ID0gMDsNCj4gPiA+ICAgICAgIGxvZmZfdCB6
ZXJvID0gMDsNCj4gPiA+ICAgICAgIGludCBvcDsNCj4gPiA+IEBAIC0yNTg2LDEyICsyNTg3LDI1
IEBAIHN0YXRpYyBpbnQgY2VwaF96ZXJvX3BhcnRpYWxfb2JqZWN0KHN0cnVjdCBpbm9kZSAqaW5v
ZGUsDQo+ID4gDQo+ID4gQXMgZmFyIGFzIEkgY2FuIHNlZSwgeW91IGFyZSBjb3ZlcmluZyB0aGUg
emVyb2luZyBjYXNlLiBJIGFzc3VtZSB0aGF0IG90aGVyIHR5cGUNCj4gPiBvZiBvcGVyYXRpb25z
IChsaWtlIG1vZGlmeWluZyB0aGUgZmlsZSdzIGNvbnRlbnQpIHdvcmtzIHdlbGwuIEFtIEkgY29y
cmVjdD8gSGF2ZQ0KPiA+IHlvdSB0ZXN0ZWQgdGhpcz8NCj4gDQo+IFllcywgSSd2ZSBjaGVja2Vk
IGFsbCBjZXBoX29zZGNfbmV3X3JlcXVlc3QNCj4gT25seSB0aGVzZSAyIHBsYWNlcyBtaXNzZXMg
c25hcCBjb250ZXh0LCB3cml0ZSBvcGVyYXRpb24gd29ya3MgYXMgZXhwZWN0ZWQuDQo+IA0KDQpH
cmVhdCEgTWFrZXMgc2Vuc2UuDQoNCj4gPiANCj4gPiBXZSBkZWZpbml0ZWx5IGhhdmUgbm90IGVu
b3VnaCB4ZnN0ZXN0cyBhbmQgdW5pdC10ZXN0cy4gV2UgaGF2ZW4ndCBDZXBoIHNwZWNpZmljDQo+
ID4gdGVzdCBpbiB4ZnN0ZXN0cyBmb3IgY292ZXJpbmcgc25hcHNob3RzIGZ1bmN0aW9uYWxpdHku
IEl0IHdpbGwgYmUgcmVhbGx5IGdyZWF0DQo+ID4gaWYgc29tZWJvZHkgY2FuIHdyaXRlIHRoaXMg
dGVzdChzKS4gOikNCj4gPiANCj4gDQo+IEkgY2FuIGFkZCB0aGlzIHRlc3QgaW50byB4ZnN0ZXN0
cyBvciBjZXBoIHVuaXQtdGVzdHMsDQo+IHdoaWNoIHBsYWNlIGRvIHlvdSBwcmVmZXIgdG8gYWRk
IHRoaXMgdGVzdCBvbj8NCj4gDQo+ID4gDQoNCldlIGhhdmUgYWxyZWFkeSBzZXZlcmFsIENlcGgg
c3BlY2lhbGl6ZWQgdGVzdHMgaW4geGZzdGVzdHMgc3VpdGUuIFNvLCBpdCB3aWxsIGJlDQpzbGln
aHRseSBtb3JlIGVhc3kgdG8gYWRkIHRoZSBhbm90aGVyIHRlc3QgdGhlcmUuIEkgaGF2ZSBzdGFy
dGVkIHRvIHdvcmsgb24NCnVuaXQtdGVzdHMgZm9yIENlcGhGUyBrZXJuZWwgY2xpZW50IHJlY2Vu
dGx5LiBXZSBkb24ndCBoYXZlIHRoZSBLdW5pdC1iYXNlZA0KdW5pdC10ZXN0IGluZnJhc3RydWN0
dXJlIGZvciBDZXBoIGluIHVwc3RyZWFtIHlldC4gSSB0aGluayB4ZnN0ZXN0cyBjb3VsZCBiZQ0K
bW9yZSB1c2VmdWwgYW5kIGVhc3kgdGFyZ2V0IHJpZ2h0IG5vdy4NCg0KVGhhbmtzLA0KU2xhdmEu
DQo=

