Return-Path: <ceph-devel+bounces-3594-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2564DB53C26
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 21:16:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3699F1B22F9A
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 19:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA8225484D;
	Thu, 11 Sep 2025 19:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="snQO6jaD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174A417C21C
	for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 19:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757618210; cv=fail; b=KWTjY1VHBjM/AxmDr+TsuGSPkeCNQaqOor3CfG1RRvES2l8wTGtqLsrbvVcMI23bc0WWc0BgKxSIpSiRdlZRGlg9KmUejmeouc+wd52DlJsueW+3CkFQpUXbTCMOKyLcdnbS0kgeOS3E9E73iQMgc2PlKj3mgGD+xUXNkrvZXTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757618210; c=relaxed/simple;
	bh=qwO1/g6FGEzHUA15XNRjfsE0qXtjQNgBYNGvOER19AY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=fyDh6KLgTG88QVEOvjPBo4dweB2QBy0shzUgiizNU0IYYhgwJPyKKKi+R8v2UD4DUFBly0RwtGPbyUDIdGw19m8yWQUTxhUfdW4IUG+lox3Ek/wijlIlt7uAiXwFB435F5czqjiiV/+gHoz+FJ3WRez1HP/RBIHwpO2KXWIyIWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=snQO6jaD; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BG15fo011307
	for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 19:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=FOy8cyG/r+cU66DJOMo1co4VJ+v/Q6ti19x41JDODME=; b=snQO6jaD
	sw/g9r9wWya+VhH1lhCdM3xInP/X5grqrRS7ImH8ISBYNJhNzjG0Wc4bzncfBH2c
	qh2OM6wJUxIUAXpmsm8DyV3BJsucT6ImdVSHDm2bidOMUONrU5/UNqVA3MY60II9
	WNAl47fhRrWBnWVT1/z06e67FN38AGujwqS/Zsx6GPVWTAUyRC38XmsUKJ/tR/aE
	XUapTIUeRq2shTAejr5JTTgH/CZRgM3HinYH4pz2OLOfG4GXe5pmZ6EmoAdlxn0j
	WV7dJcViQmYDjDPCb8ut0Cj6+/KkoMDkJT9Bl0X6QcIbnWmoqDQCqyXz8iJp/91s
	Awf5TLTWLdo59w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bct61fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 19:16:47 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58BIw7Du029535
	for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 19:16:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bct61fq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 19:16:47 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58BJGkHB006743;
	Thu, 11 Sep 2025 19:16:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bct61fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 19:16:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KGg0GY2SQpBzI0Xa3vzPr+ZLrsG9d64BUxTswyJ10KB+62HXvVBvW3s0ZaXjp1Cbo/gDzqacQhz5B9izUUZm+TjTB2DnfhD3knnfHfovitRoZU/HXbGQPBcdWCyy9Go9LCblUl7U5DzM9t2A9LUCyQ+RKzR8dJb0xbZKicg1bdCCexJZl68BfQQWVMrzYjqI2myeJ+pY805QId+U/NDeN3mFX/GzmWzATQy0F7d9b1sVzM/UemC1mBpMdF6qp4Lnqh4qmKcK3l+H6QaL/KsDIkWLz2fA+9OirffoxHArF6dStdl/UFMvWsJs2eV/O+boSAy1PrQd0WpIk2JJqYiBeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MtTDL7TmQjpeXYfyULs2Oe3i6q8/UfZTt6Z3eWyuSGE=;
 b=UaNpYDrudtiMPae78Ei5KEQE5qxBHXe70HZEWy5zoawXDoHspHsDe5LeR9iJg3TknWl7KlUmGNwq7D02BrLp5Ziqafo3cQLKjeUF7z99U2safKfXvi1CzjT7bh7MdkMmWw1Juqx31Rm6bLn1uWBLYy4zQaT+MS7p/vufNQQ9sQZ1faC+QKFGBjM4aBrWtN//BEreuXx9uMTXUCeQ6CTVXCicFdl8m3QRYX4Bjgm5eL7Wt2wUbNyg8YThHRE3tuIqiRRxadFP09tDaiiLeyA5OBGUjrhNsv0gCppCtIsqjJOfmpo5zXRpsG3X0Y1t7DojIEhvEgglEqu4qqS7hOrSCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA0PR15MB3872.namprd15.prod.outlook.com (2603:10b6:806:91::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.24; Thu, 11 Sep
 2025 19:16:44 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 19:16:43 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Kotresh
 Hiremath Ravishankar <khiremat@redhat.com>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        Alex Markuze
	<amarkuze@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Venky Shankar
	<vshankar@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH v4] ceph: Fix multifs mds auth caps issue
Thread-Index: AQHcIv9p6MhdM+/V00CxNBbYMobbfrSOWziA
Date: Thu, 11 Sep 2025 19:16:43 +0000
Message-ID: <bf1a10a3d6a85bb95f58327b6155f09abf283db4.camel@ibm.com>
References: <20250911093235.29845-1-khiremat@redhat.com>
In-Reply-To: <20250911093235.29845-1-khiremat@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA0PR15MB3872:EE_
x-ms-office365-filtering-correlation-id: b53566f5-046c-4569-4fe1-08ddf167bea3
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MzNOYllnUE96cEFGaE05UG9lRHFaTjU4YTlxenFQZWg1ellTcmw2Rmlham5p?=
 =?utf-8?B?R3gzdHI0dzFFMWd3SjZCMkcyR3cwc2I5SVlLMGV4SWpCUnc2OFRBVVNnQVFw?=
 =?utf-8?B?OFZJZm1Wdkw5Tjl0aGhxcjlObzMxSGlzbWlWeS95MktsV2dVQTV3b2Y3VWl3?=
 =?utf-8?B?N213RmNmMDM0bkw2bzk5K2dHZVVVWUhpdExlYTk4WTNGNHlYV0RMSXVFMzlL?=
 =?utf-8?B?dkFTbmc2ak9DeGxaT2Nud05YWlVBWERpalR1UFBLQjJtNzh4Zk9JeDE3ZFhO?=
 =?utf-8?B?bXRBRWg4U0IzdVBydStVaG5KenFnWG1MZG4wTFVKSEtsN0ZoenVBQ0R2SUdV?=
 =?utf-8?B?RTdtcW54aHFwSzJEQVFaTWpGSHZ4YXdkR2RUam4rTXgrb2YxVWxLQ3NleTVp?=
 =?utf-8?B?ZzlUMkgxL0pSU0xBVHZkNVJDVlN6ZVNRUHZqaDMvWHVVRGM1V1VFV2kyeWxt?=
 =?utf-8?B?bU8vY3laZTZ3Ni9VL1JNSFFBSmFPc0xBeGtMaGFjek83cUxNNWhsQXY0dWZG?=
 =?utf-8?B?Wk9UaXBaUTg5VmVpRFF3TWdYZytJaVBKSTIwNnNSV1pNN0RJcjR6UUpnbytq?=
 =?utf-8?B?MmZEdlFvYmtpSkhFYTMzZXNMS1pPQ3NXQzN4Y0RKcUFHU2JCbjZWZ1NpcVUv?=
 =?utf-8?B?eUlQT2ZodHY0Z1VGSVA0NHdPa2pzWFBKZ3VHUU9iNGNRajlXMmFEM3kvdk9D?=
 =?utf-8?B?TG52cVpqOFl2dkc0SUo5cE9hckwrN2Y2L0gyT2h4aGpUWFM0d1JlOUVheTB5?=
 =?utf-8?B?R3FDK3YzeDNMS08wSUFBbDBINXYvYTdiNnI5M3VkM2JSL3h5M1ZJVFh6QXhN?=
 =?utf-8?B?Z3R2RC9nMVhCbTVFRFZTVGhZRm5pSUE1UUk2SFFpTjlra0tWanNobzFSM3Mx?=
 =?utf-8?B?V3ZRa3hhMmlmOWdGSmc2dklicXdJa0gwci9adldQa2xqNHE4TG43L3VUQyt3?=
 =?utf-8?B?Ukgrd0NIa2k3b2ZRY2FjOENDQnFqV25yazF0bkRrMGpYcUt6RW5qZ2RrT1c5?=
 =?utf-8?B?a3BjaGc4aElJMTMzTFpxUlBndVZ5RkJWaG1mamxoek9wdnZUNE5hSlhja3ov?=
 =?utf-8?B?ckJhZ3hoOFJoYUtWVStKN2VpS1dJbWphZWNodmN6cTlSVWFlMUZLalBSRzdl?=
 =?utf-8?B?WVpvZnNONDlBeElESUoyUEZKQUpqUVBqTTY2cGp4MFozZ3ZGS0FEZ2ZIUU5K?=
 =?utf-8?B?cFAweVk1d3cvN2Ywc2tVdi9iOWV5Q2QvRzZJZVZGZll2UDFjNFdmdFUreU9W?=
 =?utf-8?B?NGJlSmRsZitkbmU3WSt4dlAvbmtIK2Y4YmxRQ016Tm1UUVp3WjVNV3VJaDRm?=
 =?utf-8?B?N2xic2xiSXhnRi9CdWMvZlVQL0FCaXRaTU1DTGRhRVNDQzNYVTZRUlhjM3Nn?=
 =?utf-8?B?NWw0ZEUyRXFXN1JRb2FrMTRzbzQyaG5YcGduWFRQbWtuaE9GeVNGQzFsNGU3?=
 =?utf-8?B?YTdOWU1vSXZrUGtSdy9ZRWJGY1RCeFVTNFhKbTlyU1crWjFlMFFCVVhBZXhJ?=
 =?utf-8?B?Rk1KZFB6NFUveFN6MDNLejYwSThldGoyeTdJSlEvMlNheHppT0FSdVF6UFpT?=
 =?utf-8?B?OUVEc2dvSGlscDY5YjZPNE9OWjdFQWcxOXl3TElVQndOdjlhbXBmNlNDZ3JM?=
 =?utf-8?B?SG9sak1BbVJkR1lLMWZmL1g5K1ZTcWRxbnJQZU53LzBkQTY0ZXdNVXJ6WGxu?=
 =?utf-8?B?NWdNSWVOMjVhaDlXcVB4K0VZTTJkZTVKNmpjeng0L1FaNmtXMFZaNUp2bStH?=
 =?utf-8?B?dTZUbHNWVmM4WDNUbnBrNkErU1U1MDk4cldpeVJpZkIrTW83UUF1MU5YTm1k?=
 =?utf-8?B?S1pUZGNENlZvSUpSelNmNndicDAzWXFKMjd2ZnZTMUlMNjRIV25FRGRMUmlt?=
 =?utf-8?B?R1hNYm5PM0pVUHUxakM2NDByWHY0S25pUk12Wnh2ZE5mODlLcFUyN0dpTWI4?=
 =?utf-8?Q?7/KdF8Ha4p4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d2RNR08vVXpjTWhMUTNoQnpDWGtJbG9WNkVoT2prUGtpNVd6UWN3S0x6N3NR?=
 =?utf-8?B?a0w2clFLR0xrREhnVTdXVVJ6bkpMNkl3R3FLNUhwVVNnUlZHSDhyemRjSHJM?=
 =?utf-8?B?SjBPWWdGZ1p4M3NvbnRyQnQvNVI1NnpaZGppNldXcFlseFE0T2J5NWc5UHdu?=
 =?utf-8?B?TlVUdG03VCtIOVUwcVlhUGFUNlRBMHZhUHFxZWJyNXEyd2dkQXg1aGdBRGlN?=
 =?utf-8?B?cmE0bHp3QmdsVURvWi9XY1VsYS93N2t4cHhhaUlSVlRmai8wYzJtTkg0b3lp?=
 =?utf-8?B?TzdVTVg4WHdXem40Wk55clErZDJHODh6T2JJUVAxUzFkRlNSSGhwcHE5N25I?=
 =?utf-8?B?Q3NOZ1ZDWWI4YVlKRW50ZVNMUmQraTJNclhFeHdTL1o5ZEpUOHZXcHdWZWNP?=
 =?utf-8?B?Y3lXVG9oR0J2SWMwVFU0K2Y3bEFnUmFsNEhobnJRT3ZjS1JJVE5NUGd0SnhI?=
 =?utf-8?B?blh0cE9rRXFxS3B3aVhLK2xrdEErUDFmWFN2b2ZTTE9lUisxQ3dYM0l4N3Zt?=
 =?utf-8?B?MHZQMFkzZDcrQy9vTlluV2N5ZndyalBjdmVqZDBEdDBzSm9SQXJHUGdEWlRL?=
 =?utf-8?B?THdaVzdQZmlvalBBN2RVQWRmTTdURDlaaDZuMTNtZGtONnJhUUJBdGc5bmVh?=
 =?utf-8?B?RkE4Wk9FU0ZjMGZCdm40UXRqRlJiNFNrZHFWMVRwWktWMENCemkwRFhFbDdJ?=
 =?utf-8?B?T3F4M3ZsZy9NSU5JcExpLy9wdCtGdklLTzFhSk1RWXRlcGNsMnJNS1d1THhm?=
 =?utf-8?B?QzdPODJTL1dzQTlFRU4xOUtPcHNpNDllNVQ3T2VON1VIanhyK3psMlZSNDZF?=
 =?utf-8?B?RHhXQmcvNTlYeEpNSmphY1VKWlBEaGxPMDR0b3VZcDB3Q0s2alpZaU5qR0lW?=
 =?utf-8?B?N3lKWlBKSlgwVDk3Zm9vTHJqejVCZFdLcFR2RVRRc3Q1aWtwMGJDYVpQUUVY?=
 =?utf-8?B?RDlHN2lJWlYvNEpPQjRMVU8vL0ora1Z1ZlhPSWlEaTJiL0ZZVkRBU2EwVjlx?=
 =?utf-8?B?RzUwNjhUdHRaelB4TGFhTUVRb1ZPY0VNeTBSd3NtK2dGZlA0OFVPSndCWE9U?=
 =?utf-8?B?eDFUM01aVnBldkM4K2FQNGpWMGxNcDJoT081OHU0bVViRk9hMkRtVHZzT1lF?=
 =?utf-8?B?OEVqZHVQekRVMWpWRDJWVTlsbHpTNjVOQVdmaTRobFFUZnIrWUhPaUdTaG9V?=
 =?utf-8?B?MC8xSlB5azJ2UTRGcXJZSG1iZzBuMHM1VEJzK0RKNFBtS2ZoK0JxYTFEbFVE?=
 =?utf-8?B?SS9kb2g5SDh3Nm1wWXZyQjJLMTc5ckkwMVA0OGMrendFRlcwU2ZweGV2MEE0?=
 =?utf-8?B?dkQxakRUck01K0hhWmV1UGdtaHM5MkFRWGtiSjFURUh4OE9TYm5KMFYzc2hN?=
 =?utf-8?B?Nm9XTmF4VTV1a3ZlSVc3WDFjMWNLQkswTVF2bXpvdW96cTBTdUVJem95LzRL?=
 =?utf-8?B?a1JITkx3ekd2U1pvN1FkU212OUhlOEhXbDFuWHNreWJqM2NvS1M5SXNyUW9X?=
 =?utf-8?B?MlkxMUUxcVg3N3U1aHFDbkk3b3lnTjYzWGxORTRRZEE1RHBQUVZaZmQrc0M3?=
 =?utf-8?B?T2xobnNmbXpwUDFndkR2a2lGR2hSUWJZQnVrRUNwRTF4Nlk2cG5leTRDN05J?=
 =?utf-8?B?K0Ezc3dReCtLRDZHLzFjOXFWZFVtaFRIWXFITC9NU2pzTXJOYUJYQUxxQ3lz?=
 =?utf-8?B?Ykh0Nk9MMmMvQUgzd2N4eDRJVXpyV3FvdFMrc2publZIdGw1MnVvdWprdjB3?=
 =?utf-8?B?Tm00US9vUlNJQ0ozMEljS2VobStlSGQxTUl2c3N5L2V3Tzg1WXRvUXA4d0FC?=
 =?utf-8?B?UzlnQVNkQjczUHJvdHFuWGdYYVh0Zk1rTjE0NklXZVRpaXpzb0VOUmpIdFdJ?=
 =?utf-8?B?ZStpbHFETEdNL3E4R0xiN2FRcjZmck5kRFZyazRmN1psMk1BdC9PNENiZjhV?=
 =?utf-8?B?cTQ5dEV3aTNkeDg3Q2FLMjloRitxUXUwWTduV1RUeG54bk5ORXl3eWJRR2da?=
 =?utf-8?B?dzlseW1ObWlZRWhidVowc1ZuY1NvMEhMblhwUXhYeHE5QTNyckIrRktHZVdT?=
 =?utf-8?B?b3RqWkJ2OWJoNmQxaU9GdU9pL2MwTVB0WXFDd29UUlJlSUFjYWxlR2ZHVVpJ?=
 =?utf-8?B?UlBmRVNxcHFUemo0NlpYenZRSCtVSE9oOGhlS2Z6dTI4YlRLamRTMUIxMHE4?=
 =?utf-8?Q?RV56FfaHLLJDwnwRUhWm95Y=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b53566f5-046c-4569-4fe1-08ddf167bea3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2025 19:16:43.8739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Da42FkIIO66szMv4dZmiBk3xdEAre9UhnQf16I4WyG79KS3iKV9o0lbhzNT/4ZhfCXhQLV1VVudEa9nbtfrcJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3872
X-Proofpoint-GUID: J-uHM_-yvHbUinYClBal94hW-tG4AS_i
X-Proofpoint-ORIG-GUID: m2LIc4D7TpM2FPBn0ep2dcLEEDkzF2TU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfXwBIGQAUXDQnD
 viV2vOR8cRfm2n2kfgrPrwigvYomNRipK7wKD33WapDKVv2aleUCcT48hIdk98mP2bAYDEskwy1
 QhoUNa2PXrNbNpRqnhO7hcMGMsCgA1oJwpi/QMq6V/00qgfkfgsnvDwfeCgUkC+ktCZZ8h5BfU8
 WMocQymaZQQ8guCdMvn35AV6TG1Ygr4ahkmzMeycu5zzL2xc/kVrFngasRup20+joLjqPWmp4nj
 M03g393rwGpoWTg7xrqEOk7EwOOrTC4XZehGh0dmOS/aIOp4Fawefnt4Ze/hHFusbziNPzh4XeE
 KiXHG0k4thTgrfAbpgnJ0cKWke4Cy2nZhqzwa7/sjxcdVeW2pgB+oNVwUEjSaDPj30oQ4oeBaCW
 pXfaumUG
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c3201f cx=c_pps
 a=mPRsBdMmtaw0UBVQVR4TAg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=4u6H09k7AAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=d5vVk2aQQ6LFQLm6LTQA:9 a=QEXdDO2ut3YA:10 a=5yerskEF2kbSkDMynNst:22
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1C328FBF9A60D4794111699E8DEC6AC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH v4] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2507300000 definitions=main-2509060010

On Thu, 2025-09-11 at 15:02 +0530, khiremat@redhat.com wrote:
> From: Kotresh HR <khiremat@redhat.com>
>=20
> The mds auth caps check should also validate the
> fsname along with the associated caps. Not doing
> so would result in applying the mds auth caps of
> one fs on to the other fs in a multifs ceph cluster.
> The bug causes multiple issues w.r.t user
> authentication, following is one such example.
>=20
> Steps to Reproduce (on vstart cluster):
> 1. Create two file systems in a cluster, say 'fsname1' and 'fsname2'
> 2. Authorize read only permission to the user 'client.usr' on fs 'fsname1'
>     $ceph fs authorize fsname1 client.usr / r
> 3. Authorize read and write permission to the same user 'client.usr' on f=
s 'fsname2'
>     $ceph fs authorize fsname2 client.usr / rw
> 4. Update the keyring
>     $ceph auth get client.usr >> ./keyring
>=20
> With above permssions for the user 'client.usr', following is the
> expectation.
>   a. The 'client.usr' should be able to only read the contents
>      and not allowed to create or delete files on file system 'fsname1'.
>   b. The 'client.usr' should be able to read/write on file system 'fsname=
2'.
>=20
> But, with this bug, the 'client.usr' is allowed to read/write on file
> system 'fsname1'. See below.
>=20
> 5. Mount the file system 'fsname1' with the user 'client.usr'
>      $sudo bin/mount.ceph usr@.fsname1=3D/ /kmnt_fsname1_usr/
> 6. Try creating a file on file system 'fsname1' with user 'client.usr'. T=
his
>    should fail but passes with this bug.
>      $touch /kmnt_fsname1_usr/file1
> 7. Mount the file system 'fsname1' with the user 'client.admin' and creat=
e a
>    file.
>      $sudo bin/mount.ceph admin@.fsname1=3D/ /kmnt_fsname1_admin
>      $echo "data" > /kmnt_fsname1_admin/admin_file1
> 8. Try removing an existing file on file system 'fsname1' with the user
>    'client.usr'. This shoudn't succeed but succeeds with the bug.
>      $rm -f /kmnt_fsname1_usr/admin_file1
>=20
> For more information, please take a look at the corresponding mds/fuse pa=
tch
> and tests added by looking into the tracker mentioned below.
>=20
> v2: Fix a possible null dereference in doutc
> v3: Don't store fsname from mdsmap, validate against
>     ceph_mount_options's fsname and use it
> v4: Code refactor, better warning message and
>     fix possible compiler warning
>=20
> URL: https://tracker.ceph.com/issues/72167 =20
> Signed-off-by: Kotresh HR <khiremat@redhat.com>
> ---
>  fs/ceph/mds_client.c |  8 ++++++++
>  fs/ceph/mdsmap.c     | 13 ++++++++++++-
>  fs/ceph/super.c      | 14 --------------
>  fs/ceph/super.h      | 14 ++++++++++++++
>  4 files changed, 34 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 179130948041..97f9de888713 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5689,11 +5689,19 @@ static int ceph_mds_auth_match(struct ceph_mds_cl=
ient *mdsc,
>  	u32 caller_uid =3D from_kuid(&init_user_ns, cred->fsuid);
>  	u32 caller_gid =3D from_kgid(&init_user_ns, cred->fsgid);
>  	struct ceph_client *cl =3D mdsc->fsc->client;
> +	const char *fs_name =3D mdsc->fsc->mount_options->mds_namespace;
>  	const char *spath =3D mdsc->fsc->mount_options->server_path;
>  	bool gid_matched =3D false;
>  	u32 gid, tlen, len;
>  	int i, j;
> =20
> +	doutc(cl, "fsname check fs_name=3D%s  match.fs_name=3D%s\n",
> +	      fs_name, auth->match.fs_name ? auth->match.fs_name : "");
> +	if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {
> +		/* fsname check failed, try next one */

I am still thinking that "check failed" sounds too strong here. Names simply
don't match to each others and we need to check next one. But "check failed"
sounds like error condition but not the normal flow. Potentially, I used the
word "fail" too frequently for commenting the error conditions. :)

> +		return 0;
> +	}
> +
>  	doutc(cl, "match.uid %lld\n", auth->match.uid);
>  	if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
>  		if (auth->match.uid !=3D caller_uid)
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 8109aba66e02..de457470d07c 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -353,10 +353,21 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_=
mds_client *mdsc, void **p,
>  		__decode_and_drop_type(p, end, u8, bad_ext);
>  	}
>  	if (mdsmap_ev >=3D 8) {
> +		u32 fsname_len;
>  		/* enabled */
>  		ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
>  		/* fs_name */
> -		ceph_decode_skip_string(p, end, bad_ext);
> +		ceph_decode_32_safe(p, end, fsname_len, bad_ext);
> +
> +		/* validate fsname against mds_namespace */
> +		if (!namespace_equals(mdsc->fsc->mount_options, (const char *)*p, fsna=
me_len)) {
> +			pr_warn_client(cl, "fsname %*pE doesn't match mds_namespace %s\n",
> +				       (int)fsname_len, (char *)*p,
> +				       mdsc->fsc->mount_options->mds_namespace);
> +			goto bad;
> +		}
> +		// skip fsname after validation
> +		ceph_decode_skip_n(p, end, fsname_len, bad);
>  	}
>  	/* damaged */
>  	if (mdsmap_ev >=3D 9) {
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 0e6787501b2f..2c6c45b2056d 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -246,20 +246,6 @@ static void canonicalize_path(char *path)
>  	path[j] =3D '\0';
>  }
> =20
> -/*
> - * Check if the mds namespace in ceph_mount_options matches
> - * the passed in namespace string. First time match (when
> - * ->mds_namespace is NULL) is treated specially, since
> - * ->mds_namespace needs to be initialized by the caller.
> - */
> -static int namespace_equals(struct ceph_mount_options *fsopt,
> -			    const char *namespace, size_t len)
> -{
> -	return !(fsopt->mds_namespace &&
> -		 (strlen(fsopt->mds_namespace) !=3D len ||
> -		  strncmp(fsopt->mds_namespace, namespace, len)));
> -}
> -
>  static int ceph_parse_old_source(const char *dev_name, const char *dev_n=
ame_end,
>  				 struct fs_context *fc)
>  {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 8cba1ce3b8b0..bb992f12e3b0 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -104,6 +104,20 @@ struct ceph_mount_options {
>  	struct fscrypt_dummy_policy dummy_enc_policy;
>  };
> =20
> +/*
> + * Check if the mds namespace in ceph_mount_options matches
> + * the passed in namespace string. First time match (when
> + * ->mds_namespace is NULL) is treated specially, since
> + * ->mds_namespace needs to be initialized by the caller.
> + */
> +static inline int namespace_equals(struct ceph_mount_options *fsopt,
> +				   const char *namespace, size_t len)
> +{
> +	return !(fsopt->mds_namespace &&
> +		 (strlen(fsopt->mds_namespace) !=3D len ||
> +		  strncmp(fsopt->mds_namespace, namespace, len)));
> +}
> +
>  /* mount state */
>  enum {
>  	CEPH_MOUNT_MOUNTING,

Looks good.

Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Let me run xfstests on your patch. I'll be back with the results ASAP.

Thanks,
Slava.

