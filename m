Return-Path: <ceph-devel+bounces-3695-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EBA1B8AF38
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Sep 2025 20:39:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8C637C4B7F
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Sep 2025 18:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D47255E34;
	Fri, 19 Sep 2025 18:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lmZSjqyw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0A8258ED2;
	Fri, 19 Sep 2025 18:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758307148; cv=fail; b=hY4GHnAplE+MFfXq89zsBkwAaLJ90CwG42QlkRK5VEPse+CRdwNYFqZ90b8Eo5/ntf101lZwno+U2+t4e7nUGytLEr7fNI1KfNztvUv3FiRobtaTaC/ny2TxpYG7+jrjMBSvmUoqYv5/GfVlLdHWuMUWUSpZ/RvPk1tSl9YJ2xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758307148; c=relaxed/simple;
	bh=bEvH5wG2wU/8sRtGTYXi8VUlaGt4yVAmaohv8xv5sdg=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=NIGI2MxVK/ljWBSGNDp+hGpblqNRay3I5bk9JGl2fR8sGQGqHnPteGKXYwY3grwLdYwvvlOYBP/53547rOnMce/6K+lhN4/MBKvWb58KjCu3wS3NrMjBcdUJDjXnJLX1aj27Wt11HRrRIeGhH7n6uV3F/fYRrjj0QrWLDv5tV6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lmZSjqyw; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58JEkqmq024719;
	Fri, 19 Sep 2025 18:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=bEvH5wG2wU/8sRtGTYXi8VUlaGt4yVAmaohv8xv5sdg=; b=lmZSjqyw
	RqtP53KEZeuu0wEc4EmzjTZvxL4riW/DBFOS6/2ppeee93YoodS9lM5UNJnY1o3v
	rEs/JH61FzcnDWrm3qeJaLcoMVV1L5pcHsS5qV2gn6oEQ/kP28oZAuW9lUr1bkMq
	Tl6zkcY5QF8y8BgycEVh7Kc5cWta2bovokfnTCGkf59L6N7Xmm90bDA7FJ8Nq81I
	YT/jmSX/L1JX8Ed8FifCabxqeFcW4NPikp066DEXRxSOtnkOTnOg8Qab3QsFkWT3
	JXhE1linkBRqqclCeyBrql/Dwr5Hk1nQfDm3bbF6/vSjLRuTFS5uBEfqQvcfXffU
	HYa59jbmYN4qHw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4r1rwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 18:38:59 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58JIMoY9026007;
	Fri, 19 Sep 2025 18:38:59 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013049.outbound.protection.outlook.com [40.93.201.49])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4r1rwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 18:38:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FsrnrJWH36+H9lJOR6IW6CDToDHhYuNFI9/Nf9CUe+Dxi6pKERxl5eoC+kVATwr8jyuGxT6vrkdsUXGwvfGmz0wfz0XQuspciufSSC4LBWGX2N5b1MvnMzRFeryiiTOyxxBwifbVJ60r9AmhGotmi6RtgzYGDoAMS1RqxMg5Sdt5/TANdeEhY9vj20ghcq7aUOmDUsdKM+7gYUkrOErkubiZNMg7JdpVGNbFtczhLdkLFh0W/0v4uBvRR9deE9IAD6M+vLY13bQaY1ijD6osXFxQ12twfNbxc6NO67AA4JCDb8ehjGPBMiUOXRqhdZ8XN6QOlJP+PUgT1CjhX1vWaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEvH5wG2wU/8sRtGTYXi8VUlaGt4yVAmaohv8xv5sdg=;
 b=xfcufMxFz/gyf2lXNlzQLySK8CqF9OYXblh3jf7it0HEgGdY5crcrM1EQvQ1XJX8qk6j1WFwtdr4rQbjGspCs2r6KHCZoez4nNoyLhRAzEcqONg91Of5rwA+tYadMlboKyhchfmDAjOebenrO/aoNrtpXPtpzayYiTo03IlVRomTZt5ENkfR+7xu99vVWQiLLgiLw3KHF9+oprs0stLd01a/ArXe6euvqkmL86DKTby953MtJuEsQ9pTSsdszmHulvNgCv9MYt3cWn71duOGl68VDm5IOb/XGTOT/BeMoFUOyuQTadRessSVr+2t1F4pxDgEHFITsIMoLAmF5oESgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com (2603:10b6:a03:4e4::8)
 by SN7PR15MB5795.namprd15.prod.outlook.com (2603:10b6:806:32e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 19 Sep
 2025 18:38:55 +0000
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::7a72:f65e:b0be:f93f]) by SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::7a72:f65e:b0be:f93f%6]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 18:38:54 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>,
        "liujing@cmss.chinamobile.com"
	<liujing@cmss.chinamobile.com>
CC: Xiubo Li <xiubli@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] ceph: Fix the wrong format specifier
Thread-Index: AQHcKRXPVl+Y/5zLDEqlsXTOFxF4ibSa1yCA
Date: Fri, 19 Sep 2025 18:38:54 +0000
Message-ID: <2542244617e984f3cbb3f64b3383065cf55bbe59.camel@ibm.com>
References: <20250919032713.6534-1-liujing@cmss.chinamobile.com>
In-Reply-To: <20250919032713.6534-1-liujing@cmss.chinamobile.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR15MB5821:EE_|SN7PR15MB5795:EE_
x-ms-office365-filtering-correlation-id: 1852ac04-e5ec-4e6a-57e7-08ddf7abc92c
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?OVdsZ0FsbmtnRk5kaWRrOGx5Um1DTmxtTk9aWXpIRVkxcnR0a3MvWkR1SzZ0?=
 =?utf-8?B?OHp6Y3NvMktOZFJ0ZHNpUHk2b1lBMElqZHNFV1FCVmFvVEU4RXFYUkQzTkZ0?=
 =?utf-8?B?NVJHVU8rT3pVZDBON0Q0bU1YZXEwbUpRTUNEa0liZmxnRjRLTkdFM1Fjb3lR?=
 =?utf-8?B?cGgzQXFFTi9ubko2Zkc0K3NmSTREd0JhUms2V3lHaGx6d1B6SExmd2hzTWQ1?=
 =?utf-8?B?eHp4azhTbnJWZU5RYVYwMysrMzRoZXp1S2pSVDFDcGtVbVNQNzJtRzdVKzJz?=
 =?utf-8?B?OTQyblBBbHR4akNUT205OTJlUlBJcWV2RU1MaG5WcERRWVNDZEtDdm1neGdO?=
 =?utf-8?B?QlByVitYU0ZvQlY0bVMvUDFLZThPTjJjOFJaT0ZqU2RlaklCbU5NZld0RDgv?=
 =?utf-8?B?SHpseXp3Qk1CZmk5anhqZUNKWXVpWlkwVDlaWStGZXZiWk1FNHMza3FHZzQ3?=
 =?utf-8?B?RG0wMnF2QjkxY3Q5U3BQSW9sTUVmcmgxcmNGSXBOWHNiVE0vb3Z6K0p1VTV4?=
 =?utf-8?B?QStMdi9sYU83dytoVFV6alRoRVp6WmtUOWluaGl4dU9LOXRkTHFNM1FKRG9P?=
 =?utf-8?B?VVdQK2JJKzBWbDFNTHdQSnVZRDhOQWxCQW8zWmM1eklSMnI0NWFJOGxzT2Fx?=
 =?utf-8?B?RTIyVFhza2pPVi9ZNWFGaTBRcnhHR0lzOTN5Z0U0T3hLNzFMK3IxcnF5RmFV?=
 =?utf-8?B?WmJVMkR5M0o1S2p3dkNxSFRaK1RNemZxQjFQNVdUQjBBOHg5RmR2VU9DQjZw?=
 =?utf-8?B?MzJxRWdvaTdFQXp0d1J1TzQvenoxS2ZxWlZ6QmVqR2t5U1hjZ0dxdU02aTNU?=
 =?utf-8?B?YnFNSVNPaXltMGVJQkUyOVRiWWphbER0bzVxcWJUeVFZWk1SZFZobDJLMmFI?=
 =?utf-8?B?RS9kZFZ5U0pjZ2hjZWJrRjRGSnpjQk1hYTdDYUNlOXE4RTRHN0lyM09sREFr?=
 =?utf-8?B?SDU1cjQzWXNkSDBwNFNLaHFOVkVLMVpNK3lmazJHVXNFTzR1bG84QUcrZnZp?=
 =?utf-8?B?V3YweDhaeXhUdmo1U2ZkNDV0T2hHMUlPMllFWGJNZldNdThYQTd2NmlSSUI4?=
 =?utf-8?B?c2hNN0ZhVVY4a0ppRkVjSkNYOGNCMmsrcFJrSTUzQjB0OVdrYUkxRkRIdmJX?=
 =?utf-8?B?bW91TjNKTlFoaHYxMjdIUGp1SW5neVBQWDRrR1FQNW52cTd2NE9LQUw4S2M4?=
 =?utf-8?B?RHZrNVJON2VwSVg3VXJyek11MEw3bnFzNDY0QzB4UEtCbEluWFQ3UGt3QVhw?=
 =?utf-8?B?OS9qK0IwbzBGb1llclU5bDdXcW9UM1pLL3V6V2ptZWxkNjBVdWx1TG9USFVG?=
 =?utf-8?B?WCtJZkZsUy9OSFptTnpMQ1Z4bHVpMjZNdWRMSHVYNm5jaklqN3NiTlhiUm94?=
 =?utf-8?B?Zm9kSnBDRHl1Zlg4VG1TR1h4ZFpPUHViNC83bHdKTS9yc2ZXdG9pNmlPOUUr?=
 =?utf-8?B?VUE4UnlqQTdVYXViaUdhNjhUd0tmSERZQ0dQOVQxdHNBTzZlOWQrZTc5Z0NW?=
 =?utf-8?B?bFI5eHRndnFwMEdRQm1pMTVydUlrNHlDenNpdGRXaCt1Sk9ZdWt0L2VGa1pU?=
 =?utf-8?B?eHZSYTg0cXloTnFxeGhTWGhDdWtnajdDOHZ3dmkzeWVSVmlXVitJNzZUeUhE?=
 =?utf-8?B?TEllTzMxT0JaYzlKYnVwWXRBVmdXby85T0d0MUZldGt4K2xpdWVNV0RxblV6?=
 =?utf-8?B?eTIwR3V3TGJrYiswSktFK2dEbHNSeWpCMlk2V1ZpTGFTNVhZYzJXemtQTVY3?=
 =?utf-8?B?OXdBdjAxUzFyZEVGODlObkVhazUyTkxPcWJQY05RaFNVTFIyK0IvTmVkZUE1?=
 =?utf-8?B?c1YxSzVCeG83RW50dFpMNm5SRnZFbU9qclFqVmg3ek01dzJlSFRpMDMwN3RD?=
 =?utf-8?B?UHdCeWdkaTlTSnFwaTRVUzdkNFZIV1hkNFBsbi9aNWp5VkRuc3kvdExxUnpT?=
 =?utf-8?Q?66FyU0cZfPQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB5821.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bHBqanFGcDVtQSs1UmpuWk1JdXA3elBod3k4MitwZVdVOUpMWGN2cU5DTVB0?=
 =?utf-8?B?S0R4ZmVRYVVZWGQwTzlpMGxwYnI4RnVFTitJUStJRlZLem80Q0p6Q21ycmZF?=
 =?utf-8?B?cmhBQlk5a0E2bStkaWlmbExhaGpCa3FiM2QxdUhyOUxzUXVub2p5VXFOakJI?=
 =?utf-8?B?QlhFNnMvSnVNcVVBVWtyVElnSEgwWFZUc1VJTHV2K0hqbE9XaXpiUEFBa290?=
 =?utf-8?B?MGduS3NiN2xiMldCUXJPV1pUOGZ5SzRteHd1VzY5WTdaTmVtcGpXQzNuVmhY?=
 =?utf-8?B?R2g5QytETVBMa1VhNGIya3RVbmVob1h4UGpCRDM5U21wSTlKM2lyNGJwVTNY?=
 =?utf-8?B?UTdvOUxFUWhnMWJYMmlZVDhxTWtVS3lzR3ZIM3E2MTNXNC9QK2djTWdxZE02?=
 =?utf-8?B?U3JoS1kyM01jdmlHeDZFK21PdklTNEdITmpLUnVpcm5zZFhHdnZXUFpocGth?=
 =?utf-8?B?MEh4S0cyZXJoaXNialNNVE9Qdnh5VkJLUTZmeUI0cGxqK1lkMTZCU0F3YmdP?=
 =?utf-8?B?ZjN3WWNNOWxGNnVONUtWNDJRY1M2ZnpBYVU4NGQyK0FRTkwxWVBHbmF2bkJj?=
 =?utf-8?B?NlBiUXUwV1cwS25NT05NTGpjN01obmt1UEtiNXY4QWRUQTNmMkVTY2xQVGVw?=
 =?utf-8?B?M05HNlI2UjV1ZUEzWnY2S2dkRTdlTkJ1YzhKNnhtTlFiWk5TQ2tYOXJ6V1gx?=
 =?utf-8?B?NlVZQXFjV2FLSU1TTjhIaXFZdnJNa3JqRmE4eHA3V3BHTVRkVUhJQkVWQUVS?=
 =?utf-8?B?VmZLRUplV25oV21qVERMK2JlNlNtSmdHcWtzemVUYUlsQ0psMVNqRTFrTHls?=
 =?utf-8?B?SDRxWWY2b05IaUZONm9rd1lONG95eHNjdExyeldzeEViS2xFN2VsSVZMYjBX?=
 =?utf-8?B?VGpoZTZzQngyUVU5c1pNSzJzdE5PRHNJSlZ6MnFBUlZodjU5ODErY0VIWjFY?=
 =?utf-8?B?MkpmYW1mMHpKU1NNalF3NmNsUEl1dyszZzFKcU9vUldpbXRTRGczNXV2dVJY?=
 =?utf-8?B?MGtZQ1Z4TkpyN3JOWHJ5c0pPUllpWGI5UktZQWxYdm96VitpOG4rQ1VKZkZM?=
 =?utf-8?B?T1h1cmpUeUZvYXY1bUpqeFVQWDNEdEZKdmJhS29kanVFMjZGZ2VCWU9acUY3?=
 =?utf-8?B?cXZMN3YvejVrbmNrM1pQKytIZ010SHFJSnJEdlIxRk1WQ2lxdEx3c0dvUVZy?=
 =?utf-8?B?WXY4c1Yxc3J2UTZrdysxWEN3eFd1UlFzYUI0MUc3UGtuM3NqK20zdklpYkI2?=
 =?utf-8?B?ZFd6ZVJoOGcyUXYxL0dJeXYveWtvWGJaaFZnZEdUbXZrd3FnZVVpRE5oZElk?=
 =?utf-8?B?Mm5CUWFXcGZHSHBSakVzRDVCZnRPOFhPNkxzTkQyUWs0MWdkbE1xNmx4WmJ4?=
 =?utf-8?B?SXlkTE9hTS94VElMeEtHcXlwN0U2dlpKK0tLN2gvM0JBb3pKRjN5UnU2TFZQ?=
 =?utf-8?B?OTNpZ2hudlNSd1VaMFJwRWVnNWhvMERxNGc4Q2hYdDZiK1haOEcza1ZVdlVm?=
 =?utf-8?B?MVBsRGdESTJweW96VHcxMXNPUkxKOWVUdHdBbWFyQi9PZ1VRdW9UQnBjb1da?=
 =?utf-8?B?WmFFMGZ1NHVvTlVJb1lSbWNSWTVyWFliK2VwVmUwTXI4clZNeHhqRDlrOFh2?=
 =?utf-8?B?QXJORGZDQ2tnNzk0VE9BS0E5SGFZNWZhUTA3ajZIMUM1YW4wNjR3U0pPTVBP?=
 =?utf-8?B?RFVzMHIrOXVUVGlnWGtTY2pyNkdQdVZNaEFDTDZHQUhiWk8vTDlXYllOV2Fq?=
 =?utf-8?B?K0V2a0Z6UUNVOG5IUHQ1V1NlUGx0d0JqRE1LS2pYWDNhOVFkc0ZVRFQ4d3Az?=
 =?utf-8?B?YTNCTFc3bTcwVU5EeHpmUWY0ZGwrelBDWm1ZczV2Njhrd3BWREZXYnpvKzds?=
 =?utf-8?B?dE9qc3d4TENiOFE0aExrMXhBdExMU2Z3UkYrMW55dnhiSGVJazVvWWoyMFdQ?=
 =?utf-8?B?bWRsa01SWmFnSWR0bXFvbmdIZmV6bmVIZEtnZkwxOWFJejBibWl0MkVUSEtI?=
 =?utf-8?B?b1hiQ1phMkN1VDc4RFdoTWJHR1UrY1FURGVZNlcvTk9YTnpoWDdCSGtveWhI?=
 =?utf-8?B?cjhwM3ZxcnlBTWxKYmd0UXFlLzdZYlNYTUhRd3U1VE14Tnd5dXJLMjA3ejRi?=
 =?utf-8?B?Rzg3cDV4amVXRTJ5TWEzV2FUVlFSdVRtbGFTVTdRY0U4YlNWQXdxMnRIRGtj?=
 =?utf-8?Q?8VNtYyKLUuEkWf9RtuVHObQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58E9C5609833394D8696DC82D735F9F9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR15MB5821.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1852ac04-e5ec-4e6a-57e7-08ddf7abc92c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 18:38:54.2967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q+jplXLgS/CGKDjGvl0AcBUrZcTuXtoWqeXPO1DGr2kSejWIFvgqwK7gTqJbtK/NfB2SSHfjh/nknC6JCCAW5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB5795
X-Proofpoint-ORIG-GUID: 4Nk4uFxBwDVVaabQVHCbFFkdsd4HKF7K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX2fD9+LyhuQRm
 JPPv2XNgKYaPA0egKtuZMoSn/jEYJ4+TLnEEeTTI20hHxJEAD9T5N5Cj991JPZ1mWTpFI65AxmL
 KOBfs74OZKIAfcbn4hhGu1YSFXoWdztbB92F9pmEzxibDHAnQk0jsF6QZ9vqZo/5QEgrh/7jamr
 jI1gZhTy7rfKx8W1JiftInj0T0z0ug/rvBfwZZjikFyD0DgSTKnFby2ntKM8gm3EZdyUweVCGto
 4Pqm+EX8WbW2oVz3C/6dB4V3jTypyh1jRT3YVIYGs6YDarktpEqsCBmi4xzGk+ZIjH2FHVTpbmn
 QlTDxy7feUrMEukS6sp4z+ypNUCZqmtMsmLF2g7iXFoPKU1TAJ73crhX7pwiVKpc3g4t0myNTt6
 Um7sNots
X-Authority-Analysis: v=2.4 cv=R8oDGcRX c=1 sm=1 tr=0 ts=68cda343 cx=c_pps
 a=onUmW/TBZy4T/WhMO3N4DQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=P-IC7800AAAA:8 a=R5C9hjxsAAAA:8 a=G2SUqctSMXRlfaBlJskA:9
 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-GUID: YsDI-NRihT4r5mRSCYQG7WeVFz8o1mKa
Subject: Re:  [PATCH] ceph: Fix the wrong format specifier
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-19_02,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

T24gRnJpLCAyMDI1LTA5LTE5IGF0IDExOjI3ICswODAwLCBsaXVqaW5nIHdyb3RlOg0KPiBpbiB0
aGUgY2VwaF9jb21tb24uYyBmaWxlLCB0byBzdHJpY3RseSBjb21wbHkgd2l0aCB0aGUgcmVxdWly
ZW1lbnRzDQo+IG9mIHRoZSAleCBmb3JtYXQgc3BlY2lmaWVyIGFuZCBhdm9pZCB0eXBlIG1pc21h
dGNoIGFuZCBvdmVyZmxvdw0KPiBpc3N1ZXMsIGQgc2hvdWxkIGJlIGRlZmluZWQgYXMgYW4gdW5z
aWduZWQgaW50IHR5cGUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBsaXVqaW5nIDxsaXVqaW5nQGNt
c3MuY2hpbmFtb2JpbGUuY29tPg0KPiAtLS0NCj4gIG5ldC9jZXBoL2NlcGhfY29tbW9uLmMgfCAy
ICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9uZXQvY2VwaC9jZXBoX2NvbW1vbi5jIGIvbmV0L2NlcGgvY2VwaF9j
b21tb24uYw0KPiBpbmRleCA0YzY0NDE1MzZkNTUuLmQzYzE5YTYzY2FkZCAxMDA2NDQNCj4gLS0t
IGEvbmV0L2NlcGgvY2VwaF9jb21tb24uYw0KPiArKysgYi9uZXQvY2VwaC9jZXBoX2NvbW1vbi5j
DQo+IEBAIC0xOTUsNyArMTk1LDcgQEAgaW50IGNlcGhfcGFyc2VfZnNpZChjb25zdCBjaGFyICpz
dHIsIHN0cnVjdCBjZXBoX2ZzaWQgKmZzaWQpDQo+ICAJaW50IGkgPSAwOw0KPiAgCWNoYXIgdG1w
WzNdOw0KPiAgCWludCBlcnIgPSAtRUlOVkFMOw0KPiAtCWludCBkOw0KPiArCXVuc2lnbmVkIGlu
dCBkOw0KPiAgDQo+ICAJZG91dCgiJXMgJyVzJ1xuIiwgX19mdW5jX18sIHN0cik7DQo+ICAJdG1w
WzJdID0gMDsNCg0KVGhlIG1haW4gYWN0aW9uIGhhcHBlbnMgaGVyZSBbMV06DQoNCnRtcFswXSA9
IHN0clswXTsNCnRtcFsxXSA9IHN0clsxXTsNCmlmIChzc2NhbmYodG1wLCAiJXgiLCAmZCkgPCAx
KQ0KCWJyZWFrOw0KZnNpZC0+ZnNpZFtpXSA9IGQgJiAweGZmOw0KDQpTbywgdG1wIGlzIHR3byBz
eW1ib2xzIGFycmF5IHdpdGggdGVybWluYXRpbmcgJ1wwJyBzeW1ib2wuDQpGaW5hbGx5LCB3ZSBt
YWtlIGNvbnZlcnNpb24gb2YgdHdvIGRpZ2l0cyAob3IgdHdvIGJ5dGVzKSBzdHJpbmcNCmludG8g
dGhlIG51bWJlci4gVGhlIG1heGltdW0gcG9zc2libGUgbnVtYmVyIGNvdWxkIGJlIDB4RkZGRiAo
NjU1MzUpLg0KRnJhbmtseSBzcGVha2luZywgSSBkb24ndCBzZWUgaG93IHdlIGNhbiBoYXZlIHRo
ZSBvdmVyZmxvdyBpc3N1ZSBoZXJlLg0KQ291bGQgeW91IHBsZWFzZSBleHBsYWluIG1vcmUgY2xl
YXJseSB5b3VyIHBvaW50Pw0KDQpUaGFua3MsDQpTbGF2YS4NCg0KWzFdIA0KaHR0cHM6Ly9lbGl4
aXIuYm9vdGxpbi5jb20vbGludXgvdjYuMTctcmM2L3NvdXJjZS9uZXQvY2VwaC9jZXBoX2NvbW1v
bi5jI0wyMTENCg==

