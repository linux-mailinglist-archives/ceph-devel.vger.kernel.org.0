Return-Path: <ceph-devel+bounces-3071-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 190DBAD0744
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 19:15:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 736E4189458A
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 17:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D9628A3F8;
	Fri,  6 Jun 2025 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kapMSgXb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3854628A1EE;
	Fri,  6 Jun 2025 17:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749230132; cv=fail; b=HY1icVjbJV1tB42BI3QuLKVZNx7dkUUKeiZxGVY5pOLykgg/P3+IYPwaMdaIvoVnW/uxhzGsOk+MMdDcB0596qkoqV0+Wxim3XFdw6xLtxOvMSvpcR4wBqtq5mTuyawULjZmKyK7Cudb1TNvur9UffHXPM+mV5pV85aij55J/Ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749230132; c=relaxed/simple;
	bh=wi+ZYUrYQlonXQM1cN7Y3rFRSRJMQEsPU/5Ku7OO7Tg=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=NrTMb+ujwv3hO6fys+eFeYFfZVHvI/3evKaEeAvatFhUIKws4WdnxwdcQdDkQwSLnX1d+EBgj0oJEB05ZZoxRurcUbdK83zo2HglkeWLKyl5IGZ6PvDZauCZTFtj0Uo5I2ZKHomH3yoUjflz4Xt+kh3VGymwWJ3Ml7C/gg+CIX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kapMSgXb; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 556FDVlu032448;
	Fri, 6 Jun 2025 17:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=wi+ZYUrYQlonXQM1cN7Y3rFRSRJMQEsPU/5Ku7OO7Tg=; b=kapMSgXb
	Oscythraq1eBEMBrlvcJWm7JhslNT3kaCOkP184oKFDtAdFhqrtRtAms5HFIvct8
	3sv0noGwMvrpwf4Y4rIfDevCUWgpLxKsCX0JTtMutLNmezdb0CLQfqh5SDP/BkyL
	O2+FR1O6IX5hG+H/MfBGOzXArNGSgQjsuQ7FooDKvrk/o2ny7oiQTxr6WJr2RrOj
	MvI/IK8F7Go4P30vn6RHR1NxztuiwnEMbNpC2rsja9C8kzNkr+Omg2ud1OWNsRTa
	rXQxSkWuYLJBac/Nahl62J++9/+F+pVYZpsknnrXWvAk/E5Ko+hw0BkwShnqGbBk
	6tBN2epD3YWduQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 473j1y4v8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 17:15:26 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 556HFPT0028869;
	Fri, 6 Jun 2025 17:15:25 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 473j1y4v85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 17:15:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ve/EibFfijicsoS+wUzVSTgtkV/AS1SXKSM/MMmRIvCQRUMPiC8JI29IPcEzNAngonZ7R210vwwoWifAW+ItN5PbuJNiG1iguHvTkXrexWOVBzqw9/5n7ghW9FbhItqdRgjcJSFw70YB//FRB+/7eJovNCJLWFs/MrVEcSnJJcev2hWfyf32mJu9VTurIyMW/v4h/mc68HxTuTSp2joHyO9RCnQ85FCIhDZnkK8MUdXbBkP6lE1Lq1Sc3DZlCgJuPxo+FxYySEjb3x9Bf9rrvwKyVpk6MsF2AT7pyQ7kjc3pII2Qf27ipZgj3BTjdawt/7rNJxnuO6CdJAziWWPuYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wi+ZYUrYQlonXQM1cN7Y3rFRSRJMQEsPU/5Ku7OO7Tg=;
 b=DYEA6r1jddVGTPA7WpD9i06ovDAtWYgF/CR9z3e4c7PYT+O0PhQkQSZ9VsxYLz+D5G6TkmJujkpNPSgyxcvqaBWfu5QIcodlKGgWG06MeeFwSWpDHjuBVMN7QYzmp0NQavLg5ehi2PQ3cV9LJG5B7ku9hTIxQRUYnQMdNoI6pB55zWxV35dpTKR1DXdUrsBmHm2inyDXKrxCUxA5/ahG5kQ5VnI9DiWF6NOAa3D2KTZ1NeVO23uWJxdrEFGEALdxKxwjZi6L+2DWjqDkD4r3AnoPUKGYt2YK4RlANrv+yRBdterPNkWa5EXIOQ7GH1A00RlM8exiRH8WMDT/YsG7Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH7PR15MB6059.namprd15.prod.outlook.com (2603:10b6:510:243::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.24; Fri, 6 Jun
 2025 17:15:21 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8813.018; Fri, 6 Jun 2025
 17:15:21 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "max.kellermann@ionos.com" <max.kellermann@ionos.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>
CC: Xiubo Li <xiubli@redhat.com>, Alex Markuze <amarkuze@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [PATCH] fs/ceph/io: make ceph_start_io_*()
 killable
Thread-Index: AQHbyKb5tFKUiuV04kGNfjNavnZanrP2efAAgAAB6wA=
Date: Fri, 6 Jun 2025 17:15:21 +0000
Message-ID: <b4ac9be24677c76a04c99aab04f572abaa4cf8af.camel@ibm.com>
References: <20241206165014.165614-1-max.kellermann@ionos.com>
		 <CAKPOu+8eQfqJ9tVz-DzDzqKPEtQVCooxtxe1+OZanu5gi3oQzQ@mail.gmail.com>
	 <CAOi1vP-dARssCkj-2FiKDJLRv9+Dq+_GE3pfQy4BseF_8sjUNQ@mail.gmail.com>
In-Reply-To:
 <CAOi1vP-dARssCkj-2FiKDJLRv9+Dq+_GE3pfQy4BseF_8sjUNQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH7PR15MB6059:EE_
x-ms-office365-filtering-correlation-id: dc10d518-f7a7-48d5-199e-08dda51db7b1
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NE9JUTFEcW1wMWd3ZUd2SENpZ1lsY3lHejNSOHltRWh0SWFqSHFjdkdpK1lK?=
 =?utf-8?B?LzRxTmg0dzEwMlptY3J4dzdCZC9PcDlGbm4rQXFaODU5OVUxeENFUVVWWmNC?=
 =?utf-8?B?YnZtRnVtc3RhN2tHTldSeFlYdDZzMWpYVzdUWS9UbHFVQU5xN080NmhNTzY1?=
 =?utf-8?B?elUza0lkTkU2MTFyUHpiVGpsMXlGQnZFdnVSdXBtRGE1bi9CbU5jZkt0ZWNs?=
 =?utf-8?B?MS9pQStTVVc1SThUWFZKMndBUGF5ZEphZkpiak1STEVwR0NFK2U1aGI2KzR5?=
 =?utf-8?B?MklabnFsTDVjMTJId3djRGZ4eFQ0OWNKeXNFVlhTYjljMS9BSmhSVDFQRkp5?=
 =?utf-8?B?ZkxmYW83Tnp5dVViK3YxT3ZLOWpzUVo5VXFBb0VNSmIwdFBzWXFPc2xUaFJv?=
 =?utf-8?B?enpUZ2JhM0FQVXBYUHhUWGJCZkd0RTZpWTNITXZsUXNyRDRRVUw2NWIvTzBH?=
 =?utf-8?B?Q0UvQi9YWDVDK3Q5RHlQTWpKTkZjekNBZGFJT1MrSWNmaml3VSs3L1ZEYSt2?=
 =?utf-8?B?UW1xby8rK1JVcTJPMkhmdktXZmpDMzB4R0U0Z1NwZi94NWNnL0FYTklNY21F?=
 =?utf-8?B?YkVML1ZZb0RtS2xWS3JnMGRhSGtIRWx1aGtFYmRPSWJUREZSWlhSb0dDSEQr?=
 =?utf-8?B?VExjNUU1ZVNNbGh6T1pWaCtFUGI3ZXRSNkRTVDNmd2VUcGhMR1YvNUprU2w5?=
 =?utf-8?B?OEpmbVIrN1Ivb3Y3T21UaStQc2xDUWtuVXNBQzRPS2cwVytGeUFFOUptaklu?=
 =?utf-8?B?aTFTOHV0MU5TQU1FdURPeGtWbjR0SjdTTEtEa2RNUUdZaVhuaWdsMWFIeC9F?=
 =?utf-8?B?dVN3ZjZGbnFHc3N4SGNyWGx4bVVpb0thbnZoQ3pJUHlSaFpOcmljQnJQYzdj?=
 =?utf-8?B?VlNyUndEazhoY1JTRXkvcmtPdi90K0NuMjBwc3ZPU1IrMjVDRHFPN29VN25y?=
 =?utf-8?B?ajR0WHJzSktpN1VyVEQwSUJrYWVNTGdGdWtHRFQ0dG1wSDdHRVYwMHRQcmxy?=
 =?utf-8?B?YTBOWGJNdjlQdGRBMWZ5Z040U2R0bmlKSkxta3dWVjB6d2lRZ2JuZTFLbVJ1?=
 =?utf-8?B?REtDaTZUalY5dy9XWENuR0ppemUxcjFhM0w2SHRJMWxDR21kUjA2RzhrMEt6?=
 =?utf-8?B?YUhWKzJRdkkvQjhQL2hlYXZuSldFd0tCcVBEVElmZkEzdmdGdFUzVktuQW44?=
 =?utf-8?B?dG5mYmFnTzQwNWNEUWpRSUJ6cEFPd1BVTVNtK1JqY1hCdUMzcGRKOHdtY0Nn?=
 =?utf-8?B?U3A0am5zWXcvUEdUV2k5emkyQ29Hc0pKVWtmQzl4TnA2QnFocVJQZTdDQjRV?=
 =?utf-8?B?RWZhVFBrVkdCanIxS1NDRzFzYjlYRnlpdXRxcm5udVdzSGU0OCtIcURvanAv?=
 =?utf-8?B?VXVkWURNOCszekVHUGRIdmJEK1dPUFdVNS80V1BGc2hoei9YQ2txVTBpajh5?=
 =?utf-8?B?Rm9TaFNtOW5wSTVqRlA2UVV2c3pZNGJEUWJ3bDdYNXlhSVNnUVppeTNybFdo?=
 =?utf-8?B?aVViRDlINUN5bGhIdGh3cXRWWXZ4VlNqQ1hGN1NLd1N5akZDODIzK1hkS0Ev?=
 =?utf-8?B?QTQvMnN4Q1VHLys1cnoySzh4MXBBV0dGUjc3YzNEUVZpb2JtWWY5SnlxVTZZ?=
 =?utf-8?B?QXhyRjNSeHl4MUZKejlGVTM3d3FjU2xrUFBScmZ3cmIvRFluK0tXUG4yR1Bi?=
 =?utf-8?B?RWliRjNUWEZVeURjSzZtRWpaSytOTkUzc0M5TzNQMVdIbUJZRGo5T3V1ZmJ6?=
 =?utf-8?B?L2RJbjhueWpuNTRIdDBlUGVxQnFNYmtRU3RTM1FKQjRkbzFtWEh4MHhzeEdO?=
 =?utf-8?B?SVcraFhCOFNPNlZYL1VxN2lEUGloN1JVRTd6c3FDeVVsTTlqbld1UE9rTmVX?=
 =?utf-8?B?WTAvV0M1S2JkaXIzNWwwL0ZaOE5iUE1YaDNHaE5VcUZ2UTRRdDBJeTZTZUFv?=
 =?utf-8?B?WVlwMU5PaEdMdHJNSk8xcDBibGlXTEdSVVZKdndBQUZaclNTS2JUZDZVa0Y3?=
 =?utf-8?Q?pU2w+wUm8UQ+mQYcVR4nZVaQ70plsk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dGR3RVBpcU5KZzZNaElxRTkzaldCV290bXMvZDh1SFo2aHEvZlVnNDJoY1VK?=
 =?utf-8?B?SWVadnZxTVRUSndMaXNtUkdxN2J2Mi95bWJQMVBZRFlpYmRNN2VWUXB3dFU3?=
 =?utf-8?B?akhydWwzMFMxaDQyMTN1T0Qva0d5Qk9qOHJqcnA2a3BEdHhpUHloclpFUS80?=
 =?utf-8?B?WHBnU0tPM2J6WGFJTUZuTmJNT3JxSzJiK1FxSFdzTU1lTVUveWFtQzNhOXN1?=
 =?utf-8?B?dGVXbldkVkNKN0VjMFcwZ3NSTTd3V01DLzNZdjZoUHlST3RtMUdvV3VlZDlP?=
 =?utf-8?B?L3hZL0VyNGNXeEM0V2l5eVFSRnRkbDFvcDFjS3B3T0hZSWZ6UDZmT0VoZCtL?=
 =?utf-8?B?bUpJYnJXanZ5RkFlWnRXMGtPQ0JlMTE2T3pUZVNTeWJpZXFaaHNuU0RucXBq?=
 =?utf-8?B?emEzYkQ2bEtZdW44WTRzb3ZleFVQZG55WDNMN1k5dGc5WW54TWVOWW9RMUFR?=
 =?utf-8?B?bUpmN3dsV3c3WG9MWkdmRnpFMnNxLy94UzVNMUI0ck5aNzRWYldFaDRTdUZO?=
 =?utf-8?B?dHBaV2ZVbDdaajZZRndrSlZ6MFZVQzJGZDlsbmhJdmFpU0t6alBnYzFHK2hJ?=
 =?utf-8?B?QW5YeWpXYlp0RjdlRnhFTlNWV2NTd0puMmYxd0RLTWxhMmlxM3NZYWRmRXdR?=
 =?utf-8?B?NC8yOWhKR1R1S1Q2b1Zpajd3Q2pJV2VSWE85NWZObDlnQVFQWEVQd3g4K3dv?=
 =?utf-8?B?Q3pIUTNlQlFhdk5VN2w1aUtDdURvRTFvWkY1aDcvVHdyZ0lydmJtVkFxVEln?=
 =?utf-8?B?VHdSRzZESUVscWx4TEkweWxueXEwYW1FYS9wdzJMdVBjMUtUK0J1RDBQWU9S?=
 =?utf-8?B?aVZnNVpGUHBobHNiS2pLYkdGc2lKVGN2YUkzeDFoUmdKb0s3Qi9OcXpYOFBF?=
 =?utf-8?B?UmNkdEQyWWFUdUJUeGk1UXFGWW9uZjhpeUZaS3BmWEltSjZvaERDYWFkd2dt?=
 =?utf-8?B?eFhQTEtYWnNQMXdiWjVKQW9Ha1Q4OEFJRW9EN2h6V1RUcS9CUzB6ZU5NMTBl?=
 =?utf-8?B?ZFo2T0NNMkUzRnJVUDcvZTNTWkRKUXZEV0ZiemhlU2xPaTg0WityOUh2MmJD?=
 =?utf-8?B?anpWTEVTNjhIa296WGxCazRaV2ZrMmczVXNBZ2NGUjRFM0RTVmcwZ3h3SGFT?=
 =?utf-8?B?SGpKVW0rRjN6UTMydmNFSDRDM0pIVm1aclJ6OHRKZ3hpZGdMelVwZHRpRnFr?=
 =?utf-8?B?ZmtNSmxRZ1pPVnFENjNyWm4xRktzbDRSOGZOcmdoVjhHZkpQSWpKSnZHRHAv?=
 =?utf-8?B?WnVwRVpJcTFQV0dnOEZQaXFHY2dEZ1VUOXVqVlRZanJpREMxRkFmRytZdjhh?=
 =?utf-8?B?b0EzNnZUR1MzR1o4SVMvVHFNSkhheDNyN1VlSC8rQVh6MjQ1S292LzZOVEZO?=
 =?utf-8?B?SEwrMGZvemx6RDF5SElxWi8yeGZpeWVJejNuQjBxd2pwZThKVnp1S3A3bVJD?=
 =?utf-8?B?c05Ga08xWCtqSDFCM1ZEZzdrYnVDSTZpLzFPb0owMUlEQ2ExWlR0bDY2Umpr?=
 =?utf-8?B?dlZzd1N1MUtXMGZUZmFoQldMRjU1aDNUMFJQbkpLRkEyZjVtZjFDSk5IaU9k?=
 =?utf-8?B?OURCWlBYY3RCdVBsYUJUVmk1eTNONjFwU3FWd1VXMElvS1REd0ZnWWpEYi94?=
 =?utf-8?B?TEZwajYvR2hCUzFOWXhlY3RMdnJKeXlLQ2JHMjlTdWZ4R1NsN0cxNnFwM1NV?=
 =?utf-8?B?NXdKS1E4OHhDUWpETjFkK1k5eFFmSkFlY1BKSnpCZUlDUG9OY3lFWXVMMjdI?=
 =?utf-8?B?ak5VMDRDS29WWTk1ZStxay92STVIdU92NGRSNm9GZTZ1emMyY0V5WGQwQXly?=
 =?utf-8?B?OHZVcnVNa0ZUdEVYZllPdm1QaTgvZHptNmdmc3FMUzFESGFBNTkrTU80TW15?=
 =?utf-8?B?QWVJZGk3MnRkZ210andaZkcvVkJQOEFkMkdKQkJuemJMWUFMRHFTKzd5SVNF?=
 =?utf-8?B?VmdFSFFtTnNpSVpKaXN4WGlTWmZmK0VQMTllcHBTYXAwVEdNK3E0TitVcWU4?=
 =?utf-8?B?eDExUXg2bTBJTkdZNEQ2L0lDaUgvUjVTejVlMW5YdkxieW05Y21OZlFPQUw3?=
 =?utf-8?B?ZnU5Ny9mSG9hS1JwVFJoK2JtaGVzQlZTZFhKOEYxS3ZlMWJ2Y1RUZDhWRTBh?=
 =?utf-8?B?MkdPOWJuKzhRdHJXNXlPVFl4RzJKQjJsdGdoaW12eVZZL3daOS82T2hpeTNB?=
 =?utf-8?Q?wY+uv4/y/lfj9jY+vb9H5SM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36C0F8244BE91F44864E7C47CFC80184@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: dc10d518-f7a7-48d5-199e-08dda51db7b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2025 17:15:21.0919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7qLlUjD5UaS22fdDbVepeDA8ONA9wWR43sWUX85ADjOruMHpIDfCy/+B6UKYsh/tSMPWhvrvLq+Gn+HR2wnm5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB6059
X-Authority-Analysis: v=2.4 cv=Nezm13D4 c=1 sm=1 tr=0 ts=6843222e cx=c_pps a=goyIOV2bt6J9IcaSbUmyVw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6IFa9wvqVegA:10 a=UgJECxHJAAAA:8 a=GWVmYJgQ4_uNsfoetYcA:9 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-GUID: f-dGgacYHfhINoAYHdQNwJYs2egFf0Tw
X-Proofpoint-ORIG-GUID: IDtM61IfYk-EbxZFQQQX8xFCZ9xFxBHf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA2MDE0OCBTYWx0ZWRfX8MR19kF8TzXo aJcM1zTYFNQP3GJl7zxnHZh+grxRfaflN47KXNZ7IFLu1hWlTsDvVDEw9/CU1l+tMKWSa7yQyjg 1F7faILRuG8ypIdRsZaxHXmJKQvkUSXGT9BwSrbULTBvfVEPApkgIiza2N9TpgVGbmcX5/LNM2F
 xuRQKgzM/5rfdL8MRsnVR1l8SpkxARLOpMofQCCJxamG3SdJu/r7Wwut/3NRvL7Wn5eKkPLQM0/ E6bYTAEZQ7Usu0VUx7fFuqiudPMqBYEyZUrUzdGCS3TIZ9VeLvpYQpXXlGxC/7Pr5GsCCn6qN9x FGCZaOXRetFKh8gIBBYbgibVtu1a6g5drgjUnghOzW05MyhFUsSVl059j9xygkdIUIs2GUXoLFn
 EMXAA/jXLUk5NHSvaJF/0T8SfQJhIf/Yf2qzm4reCQU6gN9MMYV9fjhJSoIz8xKkftHO2ILr
Subject: RE: [PATCH] fs/ceph/io: make ceph_start_io_*() killable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-06_06,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 bulkscore=0 phishscore=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506060148

SGkgSWx5YSwNCg0KT24gRnJpLCAyMDI1LTA2LTA2IGF0IDE5OjA4ICswMjAwLCBJbHlhIERyeW9t
b3Ygd3JvdGU6DQo+IE9uIE1vbiwgTWF5IDE5LCAyMDI1IGF0IDEyOjE14oCvUE0gTWF4IEtlbGxl
cm1hbm4NCj4gPG1heC5rZWxsZXJtYW5uQGlvbm9zLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gV2hh
dCBoYXBwZW5lZCB0byB0aGlzIHBhdGNoIHN1Ym1pc3Npb24/IFNpbWlsYXIgcGF0Y2hlcyB3ZXJl
IGFjY2VwdGVkDQo+ID4gaW4gTkZTIGFuZCBWRlMgY29yZS4NCj4gDQo+IEhpIFNsYXZhLA0KPiAN
Cj4gQ2FuIHlvdSB0YWtlIGFub3RoZXIgbG9vaz8gIEl0IGRvZXNuJ3QgbWFrZSBzZW5zZSB0byBk
ZXZpYXRlIGZyb20gTkZTDQo+IG9yIG90aGVyIGZpbGVzeXN0ZW1zIGluIHRoaXMgYXJlYS4NCj4g
DQo+IA0KDQpJIHNlZSB0aGUgcG9pbnQuIE91ciBsYXN0IGRpc2N1c3Npb24gaGFzIGZpbmlzaGVk
IHdpdGggc3RhdGVtZW50IHRoYXQgTWF4DQpkb2Vzbid0IGNhcmUgYWJvdXQgdGhpcyBwYXRjaCBz
ZXQgYW5kIHdlIGRvbid0IG5lZWQgdG8gcGljayBpdCB1cC4gSWYgaGUgY2hhbmdlZA0KaGlzIG1p
bmQsIHRoZW4gSSBjYW4gcmV0dXJuIHRvIHRoZSByZXZpZXcgb2YgdGhlIHBhdGNoLiA6KSBNeSB1
bmRlcnN0YW5kaW5nIHdhcw0KdGhhdCBoZSBwcmVmZXJzIGFub3RoZXIgcGVyc29uIGZvciB0aGUg
cmV2aWV3LiA6KSBUaGlzIGlzIHdoeSBJIGtlZXAgc2lsZW5jZS4NCg0KVGhhbmtzLA0KU2xhdmEu
IA0KDQo+IA0KPiA+IA0KPiA+IE9uIEZyaSwgRGVjIDYsIDIwMjQgYXQgNTo1MOKAr1BNIE1heCBL
ZWxsZXJtYW5uIDxtYXgua2VsbGVybWFubkBpb25vcy5jb20+IHdyb3RlOg0KPiA+ID4gDQo+ID4g
PiBUaGlzIGFsbG93cyBraWxsaW5nIHByb2Nlc3NlcyB0aGF0IHdhaXQgZm9yIGEgbG9jayB3aGVu
IG9uZSBwcm9jZXNzIGlzDQo+ID4gPiBzdHVjayB3YWl0aW5nIGZvciB0aGUgQ2VwaCBzZXJ2ZXIu
ICBUaGlzIGlzIHNpbWlsYXIgdG8gdGhlIE5GUyBjb21taXQNCj4gPiA+IDM4YTEyNWIzMTUwNCAo
ImZzL25mcy9pbzogbWFrZSBuZnNfc3RhcnRfaW9fKigpIGtpbGxhYmxlIikuDQo+ID4gPiANCj4g
PiA+IFNpZ25lZC1vZmYtYnk6IE1heCBLZWxsZXJtYW5uIDxtYXgua2VsbGVybWFubkBpb25vcy5j
b20+DQo+ID4gPiAtLS0NCj4gPiA+ICBmcy9jZXBoL2ZpbGUuYyB8IDIyICsrKysrKysrKysrKyst
LS0tLS0tLS0NCj4gPiA+ICBmcy9jZXBoL2lvLmMgICB8IDQ0ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKy0tLS0tLS0tLS0tDQo+ID4gPiAgZnMvY2VwaC9pby5oICAgfCAgOCArKysr
Ky0tLQ0KPiA+ID4gIDMgZmlsZXMgY2hhbmdlZCwgNTEgaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRp
b25zKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2ZpbGUuYyBiL2ZzL2Nl
cGgvZmlsZS5jDQo+ID4gPiBpbmRleCA0YjhkNTllYmRhMDAuLmQ3OWMwNzc0ZGM2ZSAxMDA2NDQN
Cj4gPiA+IC0tLSBhL2ZzL2NlcGgvZmlsZS5jDQo+ID4gPiArKysgYi9mcy9jZXBoL2ZpbGUuYw0K
PiA+ID4gQEAgLTIxMjcsMTAgKzIxMjcsMTEgQEAgc3RhdGljIHNzaXplX3QgY2VwaF9yZWFkX2l0
ZXIoc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3QgaW92X2l0ZXIgKnRvKQ0KPiA+ID4gICAgICAg
ICBpZiAoY2VwaF9pbm9kZV9pc19zaHV0ZG93bihpbm9kZSkpDQo+ID4gPiAgICAgICAgICAgICAg
ICAgcmV0dXJuIC1FU1RBTEU7DQo+ID4gPiANCj4gPiA+IC0gICAgICAgaWYgKGRpcmVjdF9sb2Nr
KQ0KPiA+ID4gLSAgICAgICAgICAgICAgIGNlcGhfc3RhcnRfaW9fZGlyZWN0KGlub2RlKTsNCj4g
PiA+IC0gICAgICAgZWxzZQ0KPiA+ID4gLSAgICAgICAgICAgICAgIGNlcGhfc3RhcnRfaW9fcmVh
ZChpbm9kZSk7DQo+ID4gPiArICAgICAgIHJldCA9IGRpcmVjdF9sb2NrDQo+ID4gPiArICAgICAg
ICAgICAgICAgPyBjZXBoX3N0YXJ0X2lvX2RpcmVjdChpbm9kZSkNCj4gPiA+ICsgICAgICAgICAg
ICAgICA6IGNlcGhfc3RhcnRfaW9fcmVhZChpbm9kZSk7DQo+ID4gPiArICAgICAgIGlmIChyZXQp
DQo+ID4gPiArICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiA+IA0KPiA+ID4gICAgICAg
ICBpZiAoIShmaS0+ZmxhZ3MgJiBDRVBIX0ZfU1lOQykgJiYgIWRpcmVjdF9sb2NrKQ0KPiA+ID4g
ICAgICAgICAgICAgICAgIHdhbnQgfD0gQ0VQSF9DQVBfRklMRV9DQUNIRTsNCj4gPiA+IEBAIC0y
MjgzLDcgKzIyODQsOSBAQCBzdGF0aWMgc3NpemVfdCBjZXBoX3NwbGljZV9yZWFkKHN0cnVjdCBm
aWxlICppbiwgbG9mZl90ICpwcG9zLA0KPiA+ID4gICAgICAgICAgICAgKGZpLT5mbGFncyAmIENF
UEhfRl9TWU5DKSkNCj4gPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gY29weV9zcGxpY2VfcmVh
ZChpbiwgcHBvcywgcGlwZSwgbGVuLCBmbGFncyk7DQo+ID4gPiANCj4gPiA+IC0gICAgICAgY2Vw
aF9zdGFydF9pb19yZWFkKGlub2RlKTsNCj4gPiA+ICsgICAgICAgcmV0ID0gY2VwaF9zdGFydF9p
b19yZWFkKGlub2RlKTsNCj4gPiA+ICsgICAgICAgaWYgKHJldCkNCj4gPiA+ICsgICAgICAgICAg
ICAgICByZXR1cm4gcmV0Ow0KPiA+ID4gDQo+ID4gPiAgICAgICAgIHdhbnQgPSBDRVBIX0NBUF9G
SUxFX0NBQ0hFOw0KPiA+ID4gICAgICAgICBpZiAoZmktPmZtb2RlICYgQ0VQSF9GSUxFX01PREVf
TEFaWSkNCj4gPiA+IEBAIC0yMzYyLDEwICsyMzY1LDExIEBAIHN0YXRpYyBzc2l6ZV90IGNlcGhf
d3JpdGVfaXRlcihzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBpb3ZfaXRlciAqZnJvbSkNCj4g
PiA+ICAgICAgICAgICAgICAgICBkaXJlY3RfbG9jayA9IHRydWU7DQo+ID4gPiANCj4gPiA+ICBy
ZXRyeV9zbmFwOg0KPiA+ID4gLSAgICAgICBpZiAoZGlyZWN0X2xvY2spDQo+ID4gPiAtICAgICAg
ICAgICAgICAgY2VwaF9zdGFydF9pb19kaXJlY3QoaW5vZGUpOw0KPiA+ID4gLSAgICAgICBlbHNl
DQo+ID4gPiAtICAgICAgICAgICAgICAgY2VwaF9zdGFydF9pb193cml0ZShpbm9kZSk7DQo+ID4g
PiArICAgICAgIGVyciA9IGRpcmVjdF9sb2NrDQo+ID4gPiArICAgICAgICAgICAgICAgPyBjZXBo
X3N0YXJ0X2lvX2RpcmVjdChpbm9kZSkNCj4gPiA+ICsgICAgICAgICAgICAgICA6IGNlcGhfc3Rh
cnRfaW9fd3JpdGUoaW5vZGUpOw0KPiA+ID4gKyAgICAgICBpZiAoZXJyKQ0KPiA+ID4gKyAgICAg
ICAgICAgICAgIGdvdG8gb3V0X3VubG9ja2VkOw0KPiA+ID4gDQo+ID4gPiAgICAgICAgIGlmIChp
b2NiLT5raV9mbGFncyAmIElPQ0JfQVBQRU5EKSB7DQo+ID4gPiAgICAgICAgICAgICAgICAgZXJy
ID0gY2VwaF9kb19nZXRhdHRyKGlub2RlLCBDRVBIX1NUQVRfQ0FQX1NJWkUsIGZhbHNlKTsNCj4g
PiA+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2lvLmMgYi9mcy9jZXBoL2lvLmMNCj4gPiA+IGluZGV4
IGM0NTY1MDliMzFjMy4uMjczNTUwM2JjNDc5IDEwMDY0NA0KPiA+ID4gLS0tIGEvZnMvY2VwaC9p
by5jDQo+ID4gPiArKysgYi9mcy9jZXBoL2lvLmMNCj4gPiA+IEBAIC00NywyMCArNDcsMzAgQEAg
c3RhdGljIHZvaWQgY2VwaF9ibG9ja19vX2RpcmVjdChzdHJ1Y3QgY2VwaF9pbm9kZV9pbmZvICpj
aSwgc3RydWN0IGlub2RlICppbm9kZSkNCj4gPiA+ICAgKiBOb3RlIHRoYXQgYnVmZmVyZWQgd3Jp
dGVzIGFuZCB0cnVuY2F0ZXMgYm90aCB0YWtlIGEgd3JpdGUgbG9jayBvbg0KPiA+ID4gICAqIGlu
b2RlLT5pX3J3c2VtLCBtZWFuaW5nIHRoYXQgdGhvc2UgYXJlIHNlcmlhbGlzZWQgdy5yLnQuIHRo
ZSByZWFkcy4NCj4gPiA+ICAgKi8NCj4gPiA+IC12b2lkDQo+ID4gPiAraW50DQo+ID4gPiAgY2Vw
aF9zdGFydF9pb19yZWFkKHN0cnVjdCBpbm9kZSAqaW5vZGUpDQo+ID4gPiAgew0KPiA+ID4gICAg
ICAgICBzdHJ1Y3QgY2VwaF9pbm9kZV9pbmZvICpjaSA9IGNlcGhfaW5vZGUoaW5vZGUpOw0KPiA+
ID4gKyAgICAgICBpbnQgZXJyOw0KPiA+ID4gDQo+ID4gPiAgICAgICAgIC8qIEJlIGFuIG9wdGlt
aXN0ISAqLw0KPiA+ID4gLSAgICAgICBkb3duX3JlYWQoJmlub2RlLT5pX3J3c2VtKTsNCj4gPiA+
ICsgICAgICAgZXJyID0gZG93bl9yZWFkX2tpbGxhYmxlKCZpbm9kZS0+aV9yd3NlbSk7DQo+ID4g
PiArICAgICAgIGlmIChlcnIpDQo+ID4gPiArICAgICAgICAgICAgICAgcmV0dXJuIGVycjsNCj4g
PiA+ICsNCj4gPiA+ICAgICAgICAgaWYgKCEoUkVBRF9PTkNFKGNpLT5pX2NlcGhfZmxhZ3MpICYg
Q0VQSF9JX09ESVJFQ1QpKQ0KPiA+ID4gLSAgICAgICAgICAgICAgIHJldHVybjsNCj4gPiA+ICsg
ICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gPiA+ICAgICAgICAgdXBfcmVhZCgmaW5vZGUtPmlf
cndzZW0pOw0KPiA+ID4gKw0KPiA+ID4gICAgICAgICAvKiBTbG93IHBhdGguLi4uICovDQo+ID4g
PiAtICAgICAgIGRvd25fd3JpdGUoJmlub2RlLT5pX3J3c2VtKTsNCj4gPiA+ICsgICAgICAgZXJy
ID0gZG93bl93cml0ZV9raWxsYWJsZSgmaW5vZGUtPmlfcndzZW0pOw0KPiA+ID4gKyAgICAgICBp
ZiAoZXJyKQ0KPiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBlcnI7DQo+ID4gPiArDQo+ID4g
PiAgICAgICAgIGNlcGhfYmxvY2tfb19kaXJlY3QoY2ksIGlub2RlKTsNCj4gPiA+ICAgICAgICAg
ZG93bmdyYWRlX3dyaXRlKCZpbm9kZS0+aV9yd3NlbSk7DQo+ID4gPiArDQo+ID4gPiArICAgICAg
IHJldHVybiAwOw0KPiA+ID4gIH0NCj4gPiA+IA0KPiA+ID4gIC8qKg0KPiA+ID4gQEAgLTgzLDEx
ICs5MywxMyBAQCBjZXBoX2VuZF9pb19yZWFkKHN0cnVjdCBpbm9kZSAqaW5vZGUpDQo+ID4gPiAg
ICogRGVjbGFyZSB0aGF0IGEgYnVmZmVyZWQgd3JpdGUgb3BlcmF0aW9uIGlzIGFib3V0IHRvIHN0
YXJ0LCBhbmQgZW5zdXJlDQo+ID4gPiAgICogdGhhdCB3ZSBibG9jayBhbGwgZGlyZWN0IEkvTy4N
Cj4gPiA+ICAgKi8NCj4gPiA+IC12b2lkDQo+ID4gPiAraW50DQo+ID4gPiAgY2VwaF9zdGFydF9p
b193cml0ZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQ0KPiA+ID4gIHsNCj4gPiA+IC0gICAgICAgZG93
bl93cml0ZSgmaW5vZGUtPmlfcndzZW0pOw0KPiA+ID4gLSAgICAgICBjZXBoX2Jsb2NrX29fZGly
ZWN0KGNlcGhfaW5vZGUoaW5vZGUpLCBpbm9kZSk7DQo+ID4gPiArICAgICAgIGludCBlcnIgPSBk
b3duX3dyaXRlX2tpbGxhYmxlKCZpbm9kZS0+aV9yd3NlbSk7DQo+ID4gPiArICAgICAgIGlmICgh
ZXJyKQ0KPiA+ID4gKyAgICAgICAgICAgICAgIGNlcGhfYmxvY2tfb19kaXJlY3QoY2VwaF9pbm9k
ZShpbm9kZSksIGlub2RlKTsNCj4gPiA+ICsgICAgICAgcmV0dXJuIGVycjsNCj4gPiA+ICB9DQo+
ID4gPiANCj4gPiA+ICAvKioNCj4gPiA+IEBAIC0xMzMsMjAgKzE0NSwzMCBAQCBzdGF0aWMgdm9p
ZCBjZXBoX2Jsb2NrX2J1ZmZlcmVkKHN0cnVjdCBjZXBoX2lub2RlX2luZm8gKmNpLCBzdHJ1Y3Qg
aW5vZGUgKmlub2RlKQ0KPiA+ID4gICAqIE5vdGUgdGhhdCBidWZmZXJlZCB3cml0ZXMgYW5kIHRy
dW5jYXRlcyBib3RoIHRha2UgYSB3cml0ZSBsb2NrIG9uDQo+ID4gPiAgICogaW5vZGUtPmlfcndz
ZW0sIG1lYW5pbmcgdGhhdCB0aG9zZSBhcmUgc2VyaWFsaXNlZCB3LnIudC4gT19ESVJFQ1QuDQo+
ID4gPiAgICovDQo+ID4gPiAtdm9pZA0KPiA+ID4gK2ludA0KPiA+ID4gIGNlcGhfc3RhcnRfaW9f
ZGlyZWN0KHN0cnVjdCBpbm9kZSAqaW5vZGUpDQo+ID4gPiAgew0KPiA+ID4gICAgICAgICBzdHJ1
Y3QgY2VwaF9pbm9kZV9pbmZvICpjaSA9IGNlcGhfaW5vZGUoaW5vZGUpOw0KPiA+ID4gKyAgICAg
ICBpbnQgZXJyOw0KPiA+ID4gDQo+ID4gPiAgICAgICAgIC8qIEJlIGFuIG9wdGltaXN0ISAqLw0K
PiA+ID4gLSAgICAgICBkb3duX3JlYWQoJmlub2RlLT5pX3J3c2VtKTsNCj4gPiA+ICsgICAgICAg
ZXJyID0gZG93bl9yZWFkX2tpbGxhYmxlKCZpbm9kZS0+aV9yd3NlbSk7DQo+ID4gPiArICAgICAg
IGlmIChlcnIpDQo+ID4gPiArICAgICAgICAgICAgICAgcmV0dXJuIGVycjsNCj4gPiA+ICsNCj4g
PiA+ICAgICAgICAgaWYgKFJFQURfT05DRShjaS0+aV9jZXBoX2ZsYWdzKSAmIENFUEhfSV9PRElS
RUNUKQ0KPiA+ID4gLSAgICAgICAgICAgICAgIHJldHVybjsNCj4gPiA+ICsgICAgICAgICAgICAg
ICByZXR1cm4gMDsNCj4gPiA+ICAgICAgICAgdXBfcmVhZCgmaW5vZGUtPmlfcndzZW0pOw0KPiA+
ID4gKw0KPiA+ID4gICAgICAgICAvKiBTbG93IHBhdGguLi4uICovDQo+ID4gPiAtICAgICAgIGRv
d25fd3JpdGUoJmlub2RlLT5pX3J3c2VtKTsNCj4gPiA+ICsgICAgICAgZXJyID0gZG93bl93cml0
ZV9raWxsYWJsZSgmaW5vZGUtPmlfcndzZW0pOw0KPiA+ID4gKyAgICAgICBpZiAoZXJyKQ0KPiA+
ID4gKyAgICAgICAgICAgICAgIHJldHVybiBlcnI7DQo+ID4gPiArDQo+ID4gPiAgICAgICAgIGNl
cGhfYmxvY2tfYnVmZmVyZWQoY2ksIGlub2RlKTsNCj4gPiA+ICAgICAgICAgZG93bmdyYWRlX3dy
aXRlKCZpbm9kZS0+aV9yd3NlbSk7DQo+ID4gPiArDQo+ID4gPiArICAgICAgIHJldHVybiAwOw0K
PiA+ID4gIH0NCj4gPiA+IA0KPiA+ID4gIC8qKg0KPiA+ID4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgv
aW8uaCBiL2ZzL2NlcGgvaW8uaA0KPiA+ID4gaW5kZXggZmE1OTRjZDc3MzQ4Li4wOGQ1ODI1M2Y1
MzMgMTAwNjQ0DQo+ID4gPiAtLS0gYS9mcy9jZXBoL2lvLmgNCj4gPiA+ICsrKyBiL2ZzL2NlcGgv
aW8uaA0KPiA+ID4gQEAgLTIsMTEgKzIsMTMgQEANCj4gPiA+ICAjaWZuZGVmIF9GU19DRVBIX0lP
X0gNCj4gPiA+ICAjZGVmaW5lIF9GU19DRVBIX0lPX0gNCj4gPiA+IA0KPiA+ID4gLXZvaWQgY2Vw
aF9zdGFydF9pb19yZWFkKHN0cnVjdCBpbm9kZSAqaW5vZGUpOw0KPiA+ID4gKyNpbmNsdWRlIDxs
aW51eC9jb21waWxlcl9hdHRyaWJ1dGVzLmg+IC8vIGZvciBfX211c3RfY2hlY2sNCj4gPiA+ICsN
Cj4gPiA+ICtfX211c3RfY2hlY2sgaW50IGNlcGhfc3RhcnRfaW9fcmVhZChzdHJ1Y3QgaW5vZGUg
Kmlub2RlKTsNCj4gPiA+ICB2b2lkIGNlcGhfZW5kX2lvX3JlYWQoc3RydWN0IGlub2RlICppbm9k
ZSk7DQo+ID4gPiAtdm9pZCBjZXBoX3N0YXJ0X2lvX3dyaXRlKHN0cnVjdCBpbm9kZSAqaW5vZGUp
Ow0KPiA+ID4gK19fbXVzdF9jaGVjayBpbnQgY2VwaF9zdGFydF9pb193cml0ZShzdHJ1Y3QgaW5v
ZGUgKmlub2RlKTsNCj4gPiA+ICB2b2lkIGNlcGhfZW5kX2lvX3dyaXRlKHN0cnVjdCBpbm9kZSAq
aW5vZGUpOw0KPiA+ID4gLXZvaWQgY2VwaF9zdGFydF9pb19kaXJlY3Qoc3RydWN0IGlub2RlICpp
bm9kZSk7DQo+ID4gPiArX19tdXN0X2NoZWNrIGludCBjZXBoX3N0YXJ0X2lvX2RpcmVjdChzdHJ1
Y3QgaW5vZGUgKmlub2RlKTsNCj4gPiA+ICB2b2lkIGNlcGhfZW5kX2lvX2RpcmVjdChzdHJ1Y3Qg
aW5vZGUgKmlub2RlKTsNCj4gPiA+IA0KPiA+ID4gICNlbmRpZiAvKiBGU19DRVBIX0lPX0ggKi8N
Cj4gPiA+IC0tDQo+ID4gPiAyLjQ1LjINCj4gPiA+IA0K

