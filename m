Return-Path: <ceph-devel+bounces-3369-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C900B1EDFB
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Aug 2025 19:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B35C586444
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Aug 2025 17:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BCA31EB5DB;
	Fri,  8 Aug 2025 17:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qpXcqZTL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F091D5AC0;
	Fri,  8 Aug 2025 17:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754675000; cv=fail; b=Nk8uAWXnJ6POfNTRPdy0g2VIqIlPyiZ6Bbcksp8Y7sK0k1k9JYavoJa4KJITTfNA6pBqon/cx+XFhuWRZ5pBLZ7JGeJ83cZzuUOD3/R3LaAc8cz+1jKIq5x3S38x5CcnudCrzL7eHWhAdnu/qhS+iderAlXvb7d2eIpur6yY/lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754675000; c=relaxed/simple;
	bh=15W9mkbOMAQhPZpZ39Ouk1M/SlfH8tslo6yIO2ox2LA=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=pxh8R2NusogRCqTxt9VVOHPA3mk0Il6u5mUwGrdLMqOM4M6zxvGrVO0sHedpQHi6jV+wsBFaWTLJvH+SIu8D8ndJ0vGa7WJU+0QtP0DuKD3UHy1vgA9gI1gZqfIfbKN+D4fr58HgvBhBislY7ic//YOqX0EOq2/wwbwsi5bCt24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qpXcqZTL; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578D1sDR019874;
	Fri, 8 Aug 2025 17:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=15W9mkbOMAQhPZpZ39Ouk1M/SlfH8tslo6yIO2ox2LA=; b=qpXcqZTL
	Htiz9AO4wWr3C94DWipAM7GkFaIufcHd6TTZ4D5eHU7u27NcImXJ/c3M/B2o5yrx
	QnUs4m2wVw8gbtBLWrsgX18SDjyC/P1moUMNcMcdF5fCQ8QmwREZOppVg21BDbzv
	N+TZV00j4CZyKaiTXpb+N+WdAcp/+eW+T+uOjpdJMJPz+Y5jY9P2xxd7/mE0t3KO
	HtrTRxSvNE2S56zK8u+g4ekMJFV+c/FPcLm7lluReByfSW08FQTk4EABNEgjYlUy
	Tf+5cdtmvgFDoP+1aOYZcgZC9x3ADG1stJj9ts3lJDPC3uj6Uo7Kys0uSuSvtGib
	OwEZTalaOqRW9Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48c26u77sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 17:43:14 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 578HYfEj004346;
	Fri, 8 Aug 2025 17:43:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48c26u77sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 17:43:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAfcyeEfX72FLC2uMcwdEItet6HvoEo0yWZkyM6wyAnJWVX40KD0BWQlV4Ja7vjEV5gu8ZhwCgAPKn4blt7Z27FfBSY6rva1eMeN5l7+lKWoE7p7KkEpp67ReaWEvuvJ13dkpgUYROqCgpzD9gaWai8cx9td1hBEwCcTqjYwsYWNoRUiOHjMIyEAjZUYVFN1sc1B6AVEOZwNE2++dhLZmRhjYg8jAJNPAOu1CQC5HnaMg5hpofCceEwiY93zGChQaHUwIvv25xFDdNWZ8DI2JDS5PUMsoEcBeJ4AcOIVV6ekKZS1J/sJZ8vgpAKxsrkuCFgnHH45cbNdcqzN/Tnd0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15W9mkbOMAQhPZpZ39Ouk1M/SlfH8tslo6yIO2ox2LA=;
 b=JfzTmnrWBX7lSc21VIEJZVD+bj/6kkjXWo7iSL5SSri1VwfqP8AfrDiKDjULA+8OPPGi9BYkvbafRCgF05kljomJgIx/V0qMlgwyUCubV0WrmS9QmHpKEHQt/XDZTwLbHjHaV+owTnyIlzy1g1w9dkpbGT8v5MeD6pAGrJIDpLoQIMGA87lDnzCpS25TUuxB0BS8YR870spCbbttdVANsyXWrhyeJXEP7ftrdbVR6+q+rgFis+MSTgu4f6IcSM1PVCnlTZi2pGz1lMJtDDecmz6yZSNk9i0BLgC63qLI6R4S87Y/0pI47M2XoKVtwXWD3Q9UekgTturqMA3o++iVGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB4403.namprd15.prod.outlook.com (2603:10b6:806:192::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.17; Fri, 8 Aug
 2025 17:43:11 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.8989.018; Fri, 8 Aug 2025
 17:43:11 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "max.kellermann@ionos.com" <max.kellermann@ionos.com>,
        Xiubo Li
	<xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Markuze
	<amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH 0/3] net/ceph/messenger: micro-optimizations
 for out_msg
Thread-Index: AQHcBrdg4TA/1EVXS0aOHp0gtPDty7RZCmKA
Date: Fri, 8 Aug 2025 17:43:11 +0000
Message-ID: <0ce76a929137c651371d2b99d36a99dbb2378a37.camel@ibm.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
In-Reply-To: <20250806094855.268799-1-max.kellermann@ionos.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB4403:EE_
x-ms-office365-filtering-correlation-id: ca7c9aff-6021-4298-38da-08ddd6a30b81
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WjZ1N3oxdHhLeitvYzYvQlFJMTYwdk1nY0hJUXY1M0ptRGRmUEdHZ0JHbmZR?=
 =?utf-8?B?Z20yL1BiQ1JXampMZi9mekt0aFNkUjZHbVJzQXRBK0M5RERaR2o1ZHk3MUZ3?=
 =?utf-8?B?eTdKYll5UzJCUjNZYzBRN3VQUHpTbU1VdUxUVlBJQmltQ2JLRVVHbjVDZ1Ji?=
 =?utf-8?B?TlFWQzJjY2VYR2lRMGhHMVdnWVQzNUg4d2pPUlExRzYxVndUa0pPZFhZQVBq?=
 =?utf-8?B?c0RJc3dIQVo3NXhSWCthZm56cWFoRDNmcmFYZ1VoejlKTlRIZEpSS3hsWGdL?=
 =?utf-8?B?L0RxbFpuQU5UMG9mcjRLSENGcHhXNFJsK3FzdWRKZG14N0J6VkxxaS9lUkZq?=
 =?utf-8?B?SWlzL254ZHZrS3MrREdBYy92NjJHYmhaeDVvaXJxSW5hYWZiQjZvWW94VHJN?=
 =?utf-8?B?MWx0TklGODltZUtaejJkdEpadEZOUzBkM2NFbVRJQkhaNEJuUkdNckhSc1ZH?=
 =?utf-8?B?dmFJQndxZUcva1ExSEpqMlAxZFZoYzRrNXBTQWlOaGxmM0x1Vm5HV3dlMERU?=
 =?utf-8?B?WVIzM2xiYjkzeUVVTUg0dFZ0VkdrdjM0VGE2VHZvYkU0M3RpaWlXRkZ0UUxo?=
 =?utf-8?B?dGhYR0RjbmxISC9tUDdYNXVOQzM3Zi80aExidk40L2h6b05zczNYVVlOV2Jy?=
 =?utf-8?B?YjdiUTJSdUpTZnFRbkpnSndGQ2JtcnBRaTE5VENmdndQN3hsR25qajAvTkp1?=
 =?utf-8?B?VjIyWEpPOXRaV2dGeGFpQ29kRWxMWmtQVWQzSTBuRk51SWNTanZQY1YzeUtL?=
 =?utf-8?B?Q1I4cnZReklWNXRFSEZkNzNTTGxCYmNwTmdNc2ZleEFJYTF0V1hpNXQ5dGFQ?=
 =?utf-8?B?RXVkc3dYVVlMM3oxMVhIczBpOUhhUVpGZUpXbEo3RUw4YnhOZmVDZk1ONGJt?=
 =?utf-8?B?SGZmejJ5eVg0bkhwRG9jczN6SVdHUG9GRDlNcm5wZ09BUU1DUHEwSGlsU1hL?=
 =?utf-8?B?NEQvanBFMlV4b3FwQVE2cTVVdFRxdW1CMXhPYkF1Zy8wS0RybjZ2R0p4UjNq?=
 =?utf-8?B?VVdrcGxpbU45SWVkaVFETDRFQ25ZdlA3OXdJc1RscGIvS2RjdXBFdzk4Tjgx?=
 =?utf-8?B?bXcrSVMyd0lzNDZCK2hTbjBURHpTL2dTSzlrWUVla01UeFk3UjBIUGg1WWF5?=
 =?utf-8?B?UmpXbm5WOFZ3ckRBM0NUOE1zYy9EOXVRQm9MZGhicUtOVm5uMS9EOVFmeml5?=
 =?utf-8?B?dDhaR3VEQVVzSkhoRDU2WHc3blhybXJDWjVrNkFzT3lKU1Q1Wm9vVDdpZUtL?=
 =?utf-8?B?OGV4UFc3a05yQjFobkp2M2c0WHlOSmpEc0VkODZQOFI0VEd0dnNOSWpsZm9X?=
 =?utf-8?B?c1FVTlVQM1BSM1krTEhCYXNiOGw1dkJ6emNLOFBaVlk4Q3RpelliK0RtWjNh?=
 =?utf-8?B?MTJMV0s4M214OTNoRmRBeUNzeGZod0VDVng2Vk5sVVJ3U0xWOWczdHAxUVR4?=
 =?utf-8?B?UUxkeHdsYnluNEZDbU5rbG03ZWhJZ3BlMkpubW5XcU9IRWdRNGdNSFR3bHdD?=
 =?utf-8?B?OEZsdVIrT0RFUEFYL0xhbXpWR2FzRHF1NUIya1ZWSmR6VmdMT0R3RCtqY2w1?=
 =?utf-8?B?THI4bEJhWG9wbGJFMGlaRVJMWm5GSHBEY2h0ZzBIYUpZR0xGWUtYQTFJWTZr?=
 =?utf-8?B?NXVjQmRhb0tDTzR3ek92Tk5lMHIvL3h6VGllS2FXaWR5M21aYUhqUUhIM24y?=
 =?utf-8?B?UnNNeVNpRy95SmxnZWZpem5hRnc2cy85TDVNQWFBdm9KeFVEaVZWRjZiWXhW?=
 =?utf-8?B?bHJVTE1BSUJxU1d0L1lxbGdHVW5PSndQdHNyeEJtckhwNjVneDBKZnpXb3VV?=
 =?utf-8?B?T3dqZ0JZZ1M5ZzNZZWdsSHkrTG9vRFVCbjNUalJkdEYrMk1wQURJSjJjM0Zk?=
 =?utf-8?B?NzhBWldjQS96YjhuQ3V4QmNBSGV6amJkbDU1NDY5SDRoUXNySGprNDl0Z1d3?=
 =?utf-8?B?ZW5OSUFqemI0c1pIWllLZUhaMkpNQ214N1d1MjhDc3hHVFlYNDlzV1hDdDR1?=
 =?utf-8?B?RmJwN0FpelNnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VC82bE8vWTdzWWJPVjBFNzVVUDBDVTVtWUdtNnNwRW81aUpsRTMrbUN3SmZh?=
 =?utf-8?B?L1lzQi9tbEtzdXNsdm41bllzM3E3dW5EQTFmZXhVMUNtZVllc0NrQXNaN2tv?=
 =?utf-8?B?QmNlQXdZYmNpcUpGRXVwR3RidU5wSkNwUkk3MGhFcDkxdzJiamdZZzh4UlYv?=
 =?utf-8?B?Z0JqNHhzOEZoYytJYmJ2UHBoTzBWTXRkeWN0U1YxN1g0RmNjM0hNeDhyTFdt?=
 =?utf-8?B?QVJjV3ljUkJyc1ZXT3JDYTBvRWVOU1ZNd2VNbm1pUXJyVFZqRldHcmxORDBq?=
 =?utf-8?B?b1FQdFdmaHNGaTE0eTdqVnF6ZnVwTk5sRlg2dVk3eTFWcHdLSmJURUgxc1Rp?=
 =?utf-8?B?V0NBRVQ2ZzJDOFY2eStrR0tVanRqcjlZYlRUMVBiTUUrclh0UEVxTWszeHlk?=
 =?utf-8?B?ZFVGUUNVV2FzNjNGTko2ek1XMDRaWGEzVTZRZ3c0YzhVVDBTYUZ5dW5uSWRl?=
 =?utf-8?B?SHRXZ2R3Mm03Tzk1ODlkY2J3SFlWaENDaE45ZWcvREtDQnZUK2grZjYxMlRt?=
 =?utf-8?B?MHN3cDJKY1ZXSnVCaE1mZnRxay9VbEdXOVVNcTg0Z0RpZ3ZCM1lsVEZYTnFr?=
 =?utf-8?B?VHRianhOQUhObjBXRWtCeENFUm5QbmlxU2xuUzVZQjVEQXo1eWJQYmpjZGJL?=
 =?utf-8?B?L01wZk9Kb0E4R0tISThSeFR4UUxlQWxqSXFzcnRYQ1ZLYlA5TUozdlBBSGJz?=
 =?utf-8?B?eEMydWhmbzZXVVRuN0dHQ1RYeHl3WldHQ3REd0xkMlZaRDI0WjcybytsSWQ3?=
 =?utf-8?B?Tm1zZnNGa3RMUEhrVGRmUzJjUG4rZTE2dFNJOWpBTE40RnRZb3IyeElOaHV0?=
 =?utf-8?B?U2pxcVQ2OGZRVjEzaDNJaW16S0x2YzY3enQrb09JRXZWRWpDWjdSZ1B6Z041?=
 =?utf-8?B?UDVNZU5seW9BU3BJSDRsMnZuODBVTVRsekMvUW1FRnF1eTh4Sm9xb1ZwRFEx?=
 =?utf-8?B?NEVMSVlReDBqMXdjamZOaVcxT2gvVWxUQWhQdE5pVmkrMW8rN205Y1NtSVNa?=
 =?utf-8?B?QklrZ0ViWlhLYTV1ZzkxVVRCQ3l1eTZGYXNFWDNoMElJbGZmVm5MMFpBYmRU?=
 =?utf-8?B?azc1eTBVdjJtWUZjRDlvN2dyZ21rZ0twRUR6Y0FML0QzTFRINkQ2WFI3ejdV?=
 =?utf-8?B?NDZ5czJWMFlmVklNZnA4TkVMUjlUb2k1a3ZESFhXODNLSFNrNjBDZXZLb3NF?=
 =?utf-8?B?cldBelJhdy9FbnBDNzYvb3FnUkMxcE9tZmFEUnJwak9jTndxKzhYcmkyOE4x?=
 =?utf-8?B?TFRKTXdtL3psY1l5K1lybHdOVnMrV1Bud0I0SmpZeHBIUmM5UVlRWlhIOU1T?=
 =?utf-8?B?TVNrY0ptaHpSRkNjV2ZUZ2Z5MGRmVk0xQTZqUDBSbERtSXpVdlZjdVBMUVg4?=
 =?utf-8?B?Sk80cVpwMDc1YTVNNFpOUTRvcTJWUTJrVzlJZFlabjJ1eUdpVXBNcTNXSENE?=
 =?utf-8?B?T3lZdnpEMGJmWC9odEpTaHhhWWw3MGpJekk5UXA4ZWJJZ2hPQXZmWERtSG95?=
 =?utf-8?B?OVQxdEpQZDVJdzREcVUxV2xzZmFRN2JxeUlsTVZXUWpWbFJud0tOdGhiVjBy?=
 =?utf-8?B?OVZiVjJKcXRSR1RtcHFtbDJZWDNYOXdpZmsyZjZqc1psYmRwTzJtZ3lQMndB?=
 =?utf-8?B?SzF1bHRSUHI4dTMzNXVVOWkxMjM4Sjg2c1p1TTVkREdWWStLeExDS0R4dk9o?=
 =?utf-8?B?enNidWNtYWFrL0QvMFk4cG9zWTc4UlRDQnlzU0ZkRVdUY09WMmlFMnFLczBk?=
 =?utf-8?B?NTVCT3VuUm10c1V4cGNOcnU0SEhjK09LcFIvdTRnK0xLTnVKYXRDQksvU0tu?=
 =?utf-8?B?RGFBa2dld29zakpCc1NnSXZPTExDaytmMytET2U5WkllaTlldFhrNE04NXlI?=
 =?utf-8?B?Y3lhS0tuczNrMnkyUTNNQTNyM01YQ0hFUE94LzdLME1OT21WY0FBeXJpU2xm?=
 =?utf-8?B?N1BOdi9MYkp6c2o4Z3p2Ty9INUwwQnc3UkdYenM1R3lNZytMNHg2clNsVUc1?=
 =?utf-8?B?VGV2dzhtQ3greWVZdmRXQUtXN3NYWUdabkdmd2NvZ1U1VW10TDdtbHpnZ2dq?=
 =?utf-8?B?TmU2VlQ3MC85R2lCR2hwQ01uYnFlMlliYStBZEpFWVlTVytrZkNNdCtNM2U2?=
 =?utf-8?B?eXBtd3oxTG10Z2VXUklQdjdXOURwbVZPemFLYjljTmhaSTV2K3hjTnlkanZO?=
 =?utf-8?Q?1y2FIkys7xGkU6lJ9Nd0tMM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38D03D1C1B341642A207C56C8EFB6485@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7c9aff-6021-4298-38da-08ddd6a30b81
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 17:43:11.7340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6bOOHHl0KqVAJX/hauOVzW1pvc11aXdrpx2claImMkmgDqE0aPRG8DJDNlRf2cjMtF1q8Q9hvTCNHtu8y+4/8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4403
X-Proofpoint-ORIG-GUID: vb2qEtAjqfj20bNLtiUEAb-fM1oXC_Rg
X-Authority-Analysis: v=2.4 cv=F/xXdrhN c=1 sm=1 tr=0 ts=68963732 cx=c_pps
 a=VBa9tr0pwzwl7iNjvTjIUw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=VhKz2HA2trGl_-0r1zEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: YNLATNbk4KBxXWR2yhIajemwz3od6GZ4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDE0MSBTYWx0ZWRfX5AJ6yIDkvDab
 VSGcaen2g/5pobsAmn47fh76rbj80Sof+y+vKyh+sU6k6RBlcQ5D3F5DapVmqhRBLDG29J3fvAZ
 5uaBg9MWSxzrWg928evnfyvS+glTEN78amA3QSYXh0RyMP3gcXr59MU02oh7Rc92Mj3O5LYyjrt
 Re5DxY2kpv0rFlR98mmlHPIlQQUJKt+AuW855jGqWgDocyLRRtnNjXFpnXoxUMPJ7dOqnk9SdRA
 m5prJCbrz0mptq/r/xmGl3HsKT4pUKpj7YUrE0hy+CpgHR5J4yYHINqHYzbWK7GXotkKhyoWSLL
 4Z06g37T73XxmJEySxZ1krxC35GbTI1r2yZCQSX9lpqfC6hJwOIlcBJflbzbAionJwkXt847V5X
 BLyZj9A72h+CuDhcWIKRirWg+WtAaGY/e4JI6ffH3m4SmBJu5Fs/LGzRHUd8VAiV8BStVXvp
Subject: Re:  [PATCH 0/3] net/ceph/messenger: micro-optimizations for out_msg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 suspectscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508080141

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjQ4ICswMjAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gVGhlc2UgcGF0Y2hlcyByZWR1Y2UgcmVsb2FkcyBvZiBjb24tPm91dF9tc2cgYnkgcGFzc2lu
ZyBwb2ludGVycyB0aGF0DQo+IHdlIGFscmVhZHkgaGF2ZSBpbiBsb2NhbCB2YXJpYWJsZXMgKGku
ZS4gcmVnaXN0ZXJzKSBhcyBwYXJhbWV0ZXJzLg0KPiANCj4gQWNjZXNzIHRvIGNvbi0+b3V0X3F1
ZXVlIGlzIG5vdyBnb25lIGNvbXBsZXRlbHkgZnJvbSB2MS92MiBhbmQgb25seQ0KPiBmZXcgcmVm
ZXJlbmNlcyB0byBjb24tPm91dF9tc2cgcmVtYWluLiAgSW4gdGhlIGxvbmcgcnVuLCBJJ2QgbGlr
ZSB0bw0KPiBnZXQgcmlkIG9mIGNvbi0+b3V0X21zZyBjb21wbGV0ZWx5IGFuZCBpbnN0ZWFkIHNl
bmQgdGhlIHdob2xlDQo+IGNvbi0+b3V0X3F1ZXVlIGluIG9uZSBrZXJuZWxfc2VuZG1zZygpIGNh
bGwuICBUaGlzIHBhdGNoIHNlcmllcyBoZWxwcw0KPiB3aXRoIHByZXBhcmluZyB0aGF0Lg0KPiAN
Cj4gTWF4IEtlbGxlcm1hbm4gKDMpOg0KPiAgIG5ldC9jZXBoL21lc3NlbmdlcjogY2VwaF9jb25f
Z2V0X291dF9tc2coKSByZXR1cm5zIHRoZSBtZXNzYWdlIHBvaW50ZXINCj4gICBuZXQvY2VwaC9t
ZXNzZW5nZXJfdlsxMl06IHBhc3MgY2VwaF9tc2cqIGluc3RlYWQgb2YgbG9hZGluZw0KPiAgICAg
Y29uLT5vdXRfbXNnDQo+ICAgbmV0L2NlcGgvbWVzc2VuZ2VyOiBhZGQgZW1wdHkgY2hlY2sgdG8g
Y2VwaF9jb25fZ2V0X291dF9tc2coKQ0KPiANCj4gIGluY2x1ZGUvbGludXgvY2VwaC9tZXNzZW5n
ZXIuaCB8ICAgNiArLQ0KPiAgbmV0L2NlcGgvbWVzc2VuZ2VyLmMgICAgICAgICAgIHwgIDEyICst
LQ0KPiAgbmV0L2NlcGgvbWVzc2VuZ2VyX3YxLmMgICAgICAgIHwgIDU5ICsrKysrKy0tLS0tLQ0K
PiAgbmV0L2NlcGgvbWVzc2VuZ2VyX3YyLmMgICAgICAgIHwgMTYwICsrKysrKysrKysrKysrKyst
LS0tLS0tLS0tLS0tLS0tLQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCAxMTkgaW5zZXJ0aW9ucygrKSwg
MTE4IGRlbGV0aW9ucygtKQ0KDQpJIHdpbGwgYXBwbHkgdGhpcyBwYXRjaHNldCBvbiB0ZXN0aW5n
IGJyYW5jaCBhbmQgZG8gdGhlIHRlc3RpbmcgdG9kYXkuDQoNClRoYW5rcywNClNsYXZhLg0K

