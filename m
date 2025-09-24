Return-Path: <ceph-devel+bounces-3724-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46AACB9B2A2
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 20:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1388319C648E
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 18:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3085631353C;
	Wed, 24 Sep 2025 18:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HYFRBWya"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853F32E0923
	for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 18:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758737174; cv=fail; b=s54IdAAow+l3LIFOXNhNFyBfgUqsrCd/EaL+SBQGsLbtYujOUDONPnC1YlIv2kmg1z/AwVOyhqtmL/u/Rv9ghRMzV9cnCvhT5wBUXbhgUYrArW65gL3e6LsH73qF3w41BEKEEpF3biow0pz058b4h/sWyA8z4MrKrnnkZ89CW+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758737174; c=relaxed/simple;
	bh=308zumwKtrA0LY5Kn8RjTHD90g95o+69iFS0vHyUMYg=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=t9bb79tr07M9Cbuvgs/w1svM20pwraMKAPh98HjCdMF8aFATuVbsLwuJdKZ09zX1LZ2u0gqmpCTCBN5aN/VAAxOz9GfZuSLFy345KNFERSIT1661/TpnIMwlIOI0b5w+02j5LBpE6K4Dnu/vPVjiOeWG7XkSnZdVqIX0TwMEAyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HYFRBWya; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OBUNZg002011;
	Wed, 24 Sep 2025 18:05:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=308zumwKtrA0LY5Kn8RjTHD90g95o+69iFS0vHyUMYg=; b=HYFRBWya
	TWrM+WR4yKotjKWklaHzD6xRQgKVp14JrLO79Sdrmrt14ELpFtIjwAduGsowqIFL
	JWuRtd6fknsrNmi9LBDn7FO3xjkkHeU7ekqPWIAAu9AQlI7iqMbFnceTX+ciTw6J
	+2He2X7Ql9xJAS2HhPHh9oyjOBcvpViBOKVq9KHzzYsSj75e520FNctRqT06aIRL
	heD1y1TNlDLqoQmOyfp1O7YNJREMKcNZQ7ZyVC+qnUpnWRMOYpwJgmXpw+HaP0re
	YAD8eVSG3Gg6GWwPt+cFp6HjxTqxFra+AAs0X4peurmcnEdtNheooy+ZFJVdYygp
	nvGKzvnby55zmg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499ksc19ag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:05:54 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58OHpmns031301;
	Wed, 24 Sep 2025 18:05:54 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012042.outbound.protection.outlook.com [40.93.195.42])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499ksc19aa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:05:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XQ3KB7rXHoW6MHnyi6uGjIHcnl2u/AMzFi4a/7VEE3iBi1JGY9bd50iO/yaIMY67ABB3o93fIOa3oaGHeqFgPK53+DM7oAvmQzoQQW4OM3nHoJaMWN08KQxg/AfSQMdRfzKX9ZK6o2lspOgzMnCAKan0ncwlctb2hU+PBumh9/fqE1Yr6eTWahPcKgjW3xBihV7JllCivfi0Y4IlHaFw/KtyOWaWqNDMLvTGCWy5+QYISe4oOZcaQvQwO1u8SPB+JFzjYt3tLxhinRkNplNBPjp2qljcImwiyErOZ3PyX2T4MK2jkXtQvU0VQKOup4I/vcfGOZu3lGtgTyelH0Z9ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=308zumwKtrA0LY5Kn8RjTHD90g95o+69iFS0vHyUMYg=;
 b=mAlpDzXT5RT83lDvHDO4Rb1CSWxZq/4QYF7FcMu7jO37682bGnvDmnNGLn4UsCrhKlDUXWGKHCR3ZjjonYtO5BcLE5wz4iLg7Nk9mTWCTscKga3dt8mwql0k8E+HpUruNaVR7nZIMtRHdA/0dBbMtQtEk5x1cbV6BW6cok34Vu7suZ5O4/Ai4oJoGNJsZEwwP9aHaxWuh+BOTL+vCmqkX/0CVt53+KuvMk1VSZpdQstFoyIrmTm1+L157BfolqWeSfR4UJhzZl7vA9e7AZZR8Dp5I9+MAVbSuJledaMqUvjdW+5wNfoC7B/zcJYg31tq+njryWgmqS/1f+h1XwCbwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH8PR15MB6182.namprd15.prod.outlook.com (2603:10b6:510:23a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Wed, 24 Sep
 2025 18:05:51 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Wed, 24 Sep 2025
 18:05:50 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "ethan198912@gmail.com" <ethan198912@gmail.com>
CC: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
        "ethanwu@synology.com"
	<ethanwu@synology.com>
Thread-Topic: [EXTERNAL] [PATCH] ceph: fix missing snapshot context in write
 operations
Thread-Index: AQHcLTnLAvPvqgiXs0eQAjFqHc7IHbSioUOA
Date: Wed, 24 Sep 2025 18:05:50 +0000
Message-ID: <433efdc7ddfabb7f1dfb798ef2ac496603f5c3a0.camel@ibm.com>
References: <20250924095807.27471-1-ethanwu@synology.com>
In-Reply-To: <20250924095807.27471-1-ethanwu@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH8PR15MB6182:EE_
x-ms-office365-filtering-correlation-id: ce4fd82e-d442-47d3-c2ba-08ddfb94fe93
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?c3hmVnZkcXJzOEdIeFdEWGJIaEltZWJKQ0ZiNGFJeXhiNDR5M0JzY0RKVDEy?=
 =?utf-8?B?M1Z5bENqaHlVb3JvdkxNaUVvbk1ZWHdYaGpaTDRENG5JZm13SXR0Vlpjc2JR?=
 =?utf-8?B?cDV2K0V1a3RKbFVhcStKN0NuS055UWZrY0lRdWFoZVR4YndCWXc3TG1Xbll4?=
 =?utf-8?B?UGp0TnhaZHV1WncxcTRET2d0bWwwWHlKR0V1emRRMkZYQ2Rldk1BS216U3dt?=
 =?utf-8?B?YjRGekpUS1BTUkJiL2VSbFhOUkRXNGZMUWdYQm5iMHJ5VVc5SlZSd2JSSDFh?=
 =?utf-8?B?QXNVY3kwcXFVQlVPU2dQNXhPV2dUdXBIbjVWOE8wbEtYTTVCcFFJYUlPaG1J?=
 =?utf-8?B?ZGZlZGJadFVJOUxNc1hJTUdxYXk1dGJ3L05WMm1kQlNvZ1dLYUE2N3ZVWGta?=
 =?utf-8?B?Rk0yb3lKUTRMSC9wdEZYTnVtc3NQTmU3WEt2eFVDTjJsZG9LRFliUGhDNkdW?=
 =?utf-8?B?eFZhV2RFYWFSc2FDVEM4N0JrclZyQUROMUlYZWlmaSswem5HcFpBWURZOWUz?=
 =?utf-8?B?N1ROeXFmOUI0RWU1MTdmbjkvdUI5V0tpMFhPdUpjK0FxaFZLRG1pdDhheXRJ?=
 =?utf-8?B?U0ZmdTBxZTNqdzQraHZ3a3Z3eXI5WVlCYjAxbm51V2tYWkRaQVRBSThBYWxl?=
 =?utf-8?B?dm5ETVIzZ1BzSkRudG93Slg4VmtFQnVLOG9UMVF4a1duZlV5SXI2U3NiM202?=
 =?utf-8?B?YmE1c21ENEUwK3l4TEF0c21ySWszcyt1Si8rRmt4M2dkRzFmZkRhZzRSKzRE?=
 =?utf-8?B?aEp1clVLQVRWWUVmQlFGNXduOFdUUGJPOHRUdXdtVXQwNlFZU0R4TWh5bUtX?=
 =?utf-8?B?RFJFMlh4enBLMHpxZW9aamVpTFJMaWx5a0FMMHk0MEtZSXR4YzhFOHpBbDJs?=
 =?utf-8?B?TDFxZC9FUGtaS0ZEbndMbG9YTWxjbWo4dW5rVFFaWHV0MWJGYlNOcVJCRUQ5?=
 =?utf-8?B?TmgzakhkVHNIQml2a3d6cWYvT3hCWUV4eU10eHF0eXlTMVBQWXJZS1EzVHN2?=
 =?utf-8?B?UFNpRGNMRmJKdnRtakZwRHAxdTNFM3B1K1dZZ29rQUpSSUxEY05nZ0x4WU4v?=
 =?utf-8?B?MWN3cTlPaEc2WG01aWtTTDVaaTRtdllWZ0lOM1R5MnEweDhqWm10M3dEUGJ0?=
 =?utf-8?B?Y0lMemtNY1lBOHh4LzhqRHhGZGREZlhMeTVBTkxLY2I4YXBIOFRvM2h1aFlh?=
 =?utf-8?B?Y0psM3JoT2NHNlBXUVQ2ekVJQjdOdFFpWm1OMDlCZjJ3OWZmekNmTGpsTzl2?=
 =?utf-8?B?YmJRK3phVW9MalB3a2Zza1ZKMnZOelZGSGpQL1kzcWx0a3BuTmZNd1M3TGFw?=
 =?utf-8?B?SXNGazhoMFF4eW9ZbGFRNXJ1dzFFUk9QUGtqcVliRU9hbU8xU0NENFdPUnU2?=
 =?utf-8?B?WXY4YlV5V2w5NWlVbmRaSVJVL3lZUFJFaGlYS09NUTJlSEl3ZTdVVkNLdTFv?=
 =?utf-8?B?bUNsaytINjNyZHEyd0ZBM0lZbWcwalY0VkJKUUFiWnEybHZONHg1Z2djZ3hV?=
 =?utf-8?B?NXczNTlCN0xyN2ZIalNrNTRGYWNpVHE1cGxXWUtYOThvNjRJdGJxT2F1UkpD?=
 =?utf-8?B?d2xGeUhvbmoxUjFURmx1cTcwRCtpRm9rVGFjcUJBbjAycFZQUHo1TEZyZWxo?=
 =?utf-8?B?UDNscG9vcmp0alQvakd3M25nU0R2NCt6c3p5aHpnSUJITXVUWjFXM2Q1eUt2?=
 =?utf-8?B?ZFpZajNHeGt1WUhzQjVtYlY4aTNOV1JVRlo5TkM2Y1lUN3pKQ3BCR203Tk53?=
 =?utf-8?B?LzhFWHplRWswYzNqRVAzcWhxSnZMWkRWYy9taHQzRWM2U2RjcVBDOWUrbXNI?=
 =?utf-8?B?cEJpbWZENEEzbmZNeVRMSXdMZUxwT2FCeVhxMGI0dUYyWmFubzNPdFRpNHo4?=
 =?utf-8?B?STg4cWYyZndnbTF5NUFhT3RVVDN1b1JOdVpPcnR5Qk5vbEpWK0xzWG90MlNh?=
 =?utf-8?B?cUVhdDh4VHRoU0g4OUFPYmRkSWZGcHcrZUNpMFB2VzBZYTVOOXN3RFQ3VmN2?=
 =?utf-8?Q?SsA8oSg411F8Affrju1+jVST6h0qZg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aTlScTZ1aG9oQ0JXVURFTWpGOVhLRG5aWGtGcStzbHBVYlIvQnRrV0o0UHll?=
 =?utf-8?B?RThlTkt4Tmd3czR2QVAyNmdCRXlvQnhxRFB2S1dFMSs5REFzaDUrd1dWdnYz?=
 =?utf-8?B?SDZSelBibHhlbWdxd0U2d0pRRllHblpMeUY0YjNGTHlZWnhvZVh2ay95c0p0?=
 =?utf-8?B?ZUZ6clc3a3ZWOHJWU0ZSSDZ2N1hmdEdsLzlLRVY1ZUJTRTN6dHlzTkp1WUY5?=
 =?utf-8?B?dnZwb2JzZ24zQ1hRR0I0bW93d1JKYkFqT3RFK0dkakVQTmY0OUZnNVltZFFQ?=
 =?utf-8?B?dEtrUzV2NXNXM1YrTWhHVEtLdUxPQU9talZYaFZTbmRYRE1JN2tvTk83cjhW?=
 =?utf-8?B?RzhiSmV2dkxxb1lveXpZZHppUzQvRlUyM2d0TDJiTkQ1NEFHNnJnYmFCMTJj?=
 =?utf-8?B?cnNiazBrM3dZbkFEVDFCTVQ4TmQ3U0xIU3JHbHFndmh4bHk3dk91dXhNbkhQ?=
 =?utf-8?B?QThsRjFZRjV1dnMwbi9ZcU9IWGZhNWNDeWFWTmsvWm1ldU83dlJDWFd1ajhT?=
 =?utf-8?B?VlZJdXpxYnByK2VBdC93WjJrN2pQWlk0eFh2Z0RIdW5vVFUzMjU4bTViMmdy?=
 =?utf-8?B?WTh1a1Z6VHdoNzZITHpnRmoxVTBPajVWZEhxT0JWWENDUnRzTk84YmorQUJn?=
 =?utf-8?B?NXdhQXNGMmxoUEkwMFZsNW1DaEZjaWdRT2tmbkE3U0lMOGN1aHRlUkVOSlla?=
 =?utf-8?B?TEhEdW9IUkdicTUrVGt4MWJSeGxEZEtFK1pKR2g1ODVrSlBibGJxcjllbHdL?=
 =?utf-8?B?MkR0eDBCUWFudnkxNnNIc0cxOGErV3FtWDNwZ1gzczQvSjBtTGhUblBsZm0r?=
 =?utf-8?B?MlA1NnQ5ZDhoOXV1TkRxd0kyVjQvTlpDN2ZTNnVVTHdzVUF0QXFTN2dsdUFS?=
 =?utf-8?B?dGVtSDZtVkxtZnVNYkpKNlNCeWFISDFtYlI5VERJRzF4cHZzOVBqRE4xUUtq?=
 =?utf-8?B?MUZZQzd1czZ5WWJBbTFpbFVpdHZSUVNTMit4c2s4aWs0cmI0RFBMSGlNbVQ1?=
 =?utf-8?B?MUI0YU9CTklNazEzOUFHdmgvTlRqY2pSdVh1MnBsM3hKajM5WDAyVm8yNHJv?=
 =?utf-8?B?S050bnNEVzBkeER3bG1RdzgvOUJZekpKemRXdGxUc0xQNEU0ZjJ1ZFhOejR6?=
 =?utf-8?B?SDNKWWl0T0gxTHNJbnFxbE1EaWtiRi9pT1NSdnJCeXdJclNLTGxKTmMvSGZZ?=
 =?utf-8?B?OFcxQWNDTE5Zb3hQa1pNcW9laUZPTVJVUXJkSUF6ZEVlOHAvUjlrNitkN3R6?=
 =?utf-8?B?OTlRaFZwdDJDZTA2NnJKak5iZXhXY2hVVFVYL1JUdEVTUkNzbnk2TXBqLzNR?=
 =?utf-8?B?dkpnakNpUUErUFJTOWhXTE5iQkFGeUEwMHNJUHYxbVpiUEVvNXhnc2pYemNr?=
 =?utf-8?B?ZHhMbGY0d1lFK1d6YUhmbkcyM2tlc2t0R3hDYWZYaUJ4UVNER1FhaFBvbWdq?=
 =?utf-8?B?cnU3YnpVVThpdkpReWxMVnUydlB6QWRCUHhuMEZ5WVdrdTIybzdqeSthZFZs?=
 =?utf-8?B?bWhNb0JEQzM1Mm9UUkkxeWFiNGE0emFPc0xxTDhBV0tXdlViczlaWk14bE1t?=
 =?utf-8?B?Q3FTL2c2MXdsRFV6QkZJb055ZXJXQ1daZ1VHR1QxMVB0U1YrOGZXWkFVQjBo?=
 =?utf-8?B?SXgxeElTOURMTnd1NXNnbEx6Qm1aVHdTeERpb0I3WlI3YW5Ec2FPYVJOQVc2?=
 =?utf-8?B?VG5rakwxL2RqR1hlcUNSVlNaT0xFQmtKRVgzMDBHR215ZGIyZ0h3OFNxS1lN?=
 =?utf-8?B?OEhGOVJ5dEs4VUxvTnB2bTlSU3RTWWtLdi9MVnQzeFphM3FuTVR4Nmx6dUR4?=
 =?utf-8?B?K1BOQnFrV0xxSnM2Z21EREZWMzhCUStmZnJzdndKdkRZQVpVZFlSeVFUaEI0?=
 =?utf-8?B?VFRxZmNiMi9vY0NlYVZtQ1VNT3VjNHNESGhrbDNZc2diL0NHYzZPWHFyVXVZ?=
 =?utf-8?B?K1Z0K085c0xFbVVlMlZuZmFGOUxJOHFZUndHbW96S0RBYVIrUnVYWDk2NHRo?=
 =?utf-8?B?cEJYdWhTMnQ1UXBjUW9EdE00TkU5Vmllc2NoMk1HN1owdWFJL083TGQxMUh6?=
 =?utf-8?B?amVCdTE1ZUpIY1JjbGo2NW5EQVRqbUdtaHRkZlJKYldvOENJbDdqUi9UelNr?=
 =?utf-8?B?aTlMcTJ5VjMrMG96MHhsaVQxOXJIWnZ1RzlKOStBK0o1TmhYc0xnamFBMWlO?=
 =?utf-8?Q?kzKkOm3IyA21LawHbZlOdgI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <303BA09CA66BE34FB83F90783A22C022@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4fd82e-d442-47d3-c2ba-08ddfb94fe93
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2025 18:05:50.0862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7uVBW3g+PVXwL6br212fnfpkNZHcDRMaHmlmjCkqabjlTjWLVq1F1vn/23nFa90tL0mhMXXO0ipeZeCoTY2Isw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR15MB6182
X-Proofpoint-ORIG-GUID: sYWqEBwy-tfYxpk5x6a5nDC37dr9kzgR
X-Proofpoint-GUID: nmbR3NX6kgHyLf00L8IzwT39pcKgAuTE
X-Authority-Analysis: v=2.4 cv=SdH3duRu c=1 sm=1 tr=0 ts=68d43303 cx=c_pps
 a=WIVU+UPliRI2+OFOdf1Qsw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=1hL7ykf2qNw15pntqXAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyMCBTYWx0ZWRfXwNtNkQH3gbPW
 to/H93kEBnTT5ezbDaUCt05wiEOs3TK2UfK+K5bbssVdzawyHBmhiSWKyCKrjAnw+nD9V/mqmT+
 oeJA7SCvh3KQcuQooptWOOZy6dJMzRXvhzZr4JrGEwJhfIeBzydmD2IkBcDCBKPtOTWc5Kt7Sf5
 EPpsJAwPtxcy6GA+yx23PmLPLg3y3tdOXyqPJQAz2k19fNJUduneLrUxcNHN2qcC8+33ZPyB1De
 MEDzIIZ/WuVNadU+WIlUO1SVYNmcGYH7IlD/o3pyOWLeEc5C3tS0+kQv5TDqy0Xr23obag0yaqC
 zt5P+KttDTE15HmApA+qH/jRDdoZHY+Cg8juVb2tIzbw5Fetd10xBiBZu7TPWS4jh6U9viRSma9
 3lRr3ZLW
Subject: Re:  [PATCH] ceph: fix missing snapshot context in write operations
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 clxscore=1011 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200020

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE3OjU4ICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBUaGlz
IHNlcmllcyBhZGRyZXNzZXMgdHdvIGluc3RhbmNlcyB3aGVyZSBDZXBoIGZpbGVzeXN0ZW0gb3Bl
cmF0aW9ucw0KPiB3ZXJlIG1pc3NpbmcgcHJvcGVyIHNuYXBzaG90IGNvbnRleHQgaGFuZGxpbmcs
IHdoaWNoIGNvdWxkIGxlYWQgdG8NCj4gZGF0YSBpbmNvbnNpc3RlbmNpZXMgaW4gc25hcHNob3Rz
Lg0KPiANCg0KSXQgZG9lc24ndCBsb29rIGxpa2Ugc2VyaWVzLiBZb3UgY2FuIHByZXBhcmUgcGF0
Y2ggc2V0IGJ5IHVzaW5nIGNvbW1hbmQ6DQoNCmdpdCBmb3JtYXQtcGF0Y2ggLS1jb3Zlci1sZXR0
ZXIgLTIgSEVBRA0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiBUaGUgaXNzdWUgb2NjdXJzIGluIHR3
byBzY2VuYXJpb3M6DQo+IDEuIGNlcGhfemVyb19wYXJ0aWFsX29iamVjdCgpIGR1cmluZyBmYWxs
b2NhdGUgcHVuY2ggaG9sZSBvcGVyYXRpb25zDQo+IDIuIGNlcGhfdW5pbmxpbmVfZGF0YSgpIHdo
ZW4gY29udmVydGluZyBpbmxpbmUgZGF0YSB0byByZWd1bGFyIG9iamVjdHMNCj4gDQo+IEJvdGgg
ZnVuY3Rpb25zIHdlcmUgcGFzc2luZyBOVUxMIHNuYXBzaG90IGNvbnRleHQgdG8gT1NEIHdyaXRl
IG9wZXJhdGlvbnMNCj4gaW5zdGVhZCBvZiBhY3F1aXJpbmcgdGhlIGFwcHJvcHJpYXRlIGNvbnRl
eHQgZnJvbSBlaXRoZXIgcGVuZGluZyBjYXAgc25hcHMNCj4gb3IgdGhlIGlub2RlJ3MgaGVhZCBz
bmFwYy4gVGhpcyBjb3VsZCByZXN1bHQgaW4gc25hcHNob3QgZGF0YSBjb3JydXB0aW9uDQo+IHdo
ZXJlIHN1YnNlcXVlbnQgcmVhZHMgZnJvbSBzbmFwc2hvdHMgd291bGQgcmV0dXJuIG1vZGlmaWVk
IGRhdGEgaW5zdGVhZA0KPiBvZiB0aGUgb3JpZ2luYWwgc25hcHNob3QgY29udGVudC4NCj4gDQo+
IFRoZSBmaXggZW5zdXJlcyB0aGF0IHByb3BlciBzbmFwc2hvdCBjb250ZXh0IGlzIGFjcXVpcmVk
IGFuZCBwYXNzZWQgdG8NCj4gYWxsIE9TRCB3cml0ZSBvcGVyYXRpb25zIGluIHRoZXNlIGNvZGUg
cGF0aHMuDQo+IA0KPiBldGhhbnd1ICgyKToNCj4gICBjZXBoOiBmaXggc25hcHNob3QgY29udGV4
dCBtaXNzaW5nIGluIGNlcGhfemVyb19wYXJ0aWFsX29iamVjdA0KPiAgIGNlcGg6IGZpeCBzbmFw
c2hvdCBjb250ZXh0IG1pc3NpbmcgaW4gY2VwaF91bmlubGluZV9kYXRhDQo+IA0KPiAgZnMvY2Vw
aC9hZGRyLmMgfCAxOSArKysrKysrKysrKysrKysrKy0tDQo+ICBmcy9jZXBoL2ZpbGUuYyB8IDE3
ICsrKysrKysrKysrKysrKystDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDMzIGluc2VydGlvbnMoKyks
IDMgZGVsZXRpb25zKC0pDQo=

