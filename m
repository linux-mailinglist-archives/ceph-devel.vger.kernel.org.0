Return-Path: <ceph-devel+bounces-3330-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF41EB152D1
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jul 2025 20:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1C144E556E
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jul 2025 18:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0679723496F;
	Tue, 29 Jul 2025 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FYGtfYF/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20007BE4E
	for <ceph-devel@vger.kernel.org>; Tue, 29 Jul 2025 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753813622; cv=fail; b=KU+kxZSaoKR6GKk/kFJ4coODPueLVibQPHTUAZsGKOvzx/HejY1Pi8Fh543IzphGv/crrmOEHTUmPcaJyImlRdLlRKfU3zEah3m0n53yyctYXkaCEGBsB3WlvxuZtZa3T3eXpsFV4xBpYRLxThq1UeQn7TVkRPeGpuSBOcWWAqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753813622; c=relaxed/simple;
	bh=VJnDh4Ea1rey0j+akaukLl7ERUH7TIXdCPnmVCGWdE0=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=uohXSWf5dgsmnZuPtFQH+OgZpgeYUehrFno3K3zkUs/Vg+u0GI4VKdCdJ95v1Nxx+UlZR3D381m1yOJ5BBdomZz2ip+5HeIdkaOlj5uaabDC55zJuX4S5/hpRCukXGI583dNGD41t+U6jdYyeuuoi50s3ceGRU2JqR84yhxglS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FYGtfYF/; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56TDcNUZ022116
	for <ceph-devel@vger.kernel.org>; Tue, 29 Jul 2025 18:27:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=/v8PNKjG9IHVvEmsuYu54HygSOMoWB23ru6dMclCU2Q=; b=FYGtfYF/
	q0x7/vivoLQTxBPDRUl8EJjAXwSqhp5jA2l+qQcbE6LStZQB7CdwLSE1D4NECMzi
	KfW2fdN89HWS+WY8TXGNaYMNK+gZEAbeE95F0QuvKCWh2kGKHluc3ydUKJGR0arJ
	imYLJ7DpWvhsdWeWSUQ9YgjE+YdvZVI6CiVeEMowu2DoEuyom4uafKLMEmq4ao2j
	7ZZsx56OFDty3ACjdy83sz5sZfEjmhKdTtb/sDfcSBin3mN6m5iZS1BSwTEMHeFF
	uYiPgIvtaLN72fqn4+0Evg60YgDPG2oX/iihKMhQXvuDWdxEooKNWJvgsaxBSxAi
	WbS6MRloEHY52A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qemrdak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Tue, 29 Jul 2025 18:27:00 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 56TIQEOF024501
	for <ceph-devel@vger.kernel.org>; Tue, 29 Jul 2025 18:26:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qemrdae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 18:26:59 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 56TIQwaw025734;
	Tue, 29 Jul 2025 18:26:58 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2048.outbound.protection.outlook.com [40.107.95.48])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qemrdab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 18:26:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+OWibmfwipUngIgxDC4dEpqMX4lovAA8yX4GR4bR06qjJH/g/O7cBVrfbLQ69Nya/mnxoX3T582UFfKPuokvpQ5mejzyV6UsSFsvVoR8UQhto3zSW3wVKPMehNKxvxmzMOLHw8URQTWJaXpFS5XGhCn7QGCydQayqyXObbC36xOgGdhBYM3sefUA8jYgxeDmMRG4MGPcotNcz2lsviT8j7dRM7KRMi8KWWAHfjYQS/U7HZsU+/yJf5MEpZzIMLI4n1wvWbHwslW+VoKQPOskwI+2tZRkN7dWvfIbQaglS0u1bubm1LyTPWTUMvezCzBS9jJw7+Lva5HCO3TFf1e3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ef1dZRDYrlUHXF6VankpY9ZbmyaandMSF9NtXl6GpHQ=;
 b=ixq1KL9SL1b+A1XZ0icM/I76RVBR5Nc6rAtQqrgO1qrp5x/8E9898heOO1Dcy5HLVqU+g4idETjaqx9gPvTNakr74jizBGL6bALWmIeSLCp9QBauwyFCUISxPBUbSfCsrRlFHQnWu/87maHZ5lSlPT0qQD4lSI5OeMqVYMVG6syTYxhqNcfHTCveLIAySkfbod6bbbY7ZOJPP+8MJhpbtXfR1q+Ggzp002IDl4GN6o/RTZ5042JmQiJIas5Yd7OmtVvK9y3FHhfSZUc6fvRBQd9mJNU9plR0nv4M9xH7ADwwVg6WGzdq3KZSeh9uJnoMz7lQRzBhjvmV0ISCfaJRTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BL1PPF3EEE25392.namprd15.prod.outlook.com (2603:10b6:20f:fc04::e18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Tue, 29 Jul
 2025 18:26:55 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8880.026; Tue, 29 Jul 2025
 18:26:55 +0000
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
Thread-Topic: [EXTERNAL] [PATCH] ceph: Fix multifs mds auth caps issue
Thread-Index: AQHcAKsJcv7MdEr+5k6oOSEC4UfK1bRJa2KA
Date: Tue, 29 Jul 2025 18:26:55 +0000
Message-ID: <3dbbabbd68b58c95a73d02380ce6e48b5803adf2.camel@ibm.com>
References: <20250729170240.118794-1-khiremat@redhat.com>
In-Reply-To: <20250729170240.118794-1-khiremat@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BL1PPF3EEE25392:EE_
x-ms-office365-filtering-correlation-id: b6174543-195c-4e07-e95c-08ddcecd7f63
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WEF4Mm5zK29PMXZCdkNIZDBtN1Z2L1ZoN1c2NGlic0xuVVZGOHpIdktsMndE?=
 =?utf-8?B?Yk8vOEFlZnB1TlVaay9lM1JhS2U0WkxzNWp3aTZJMlNQMEZuaXlRYWdxUTUx?=
 =?utf-8?B?UG5GNysyUVhmaWxycURMK21nbWtTQ3VTRStKVkQ0c09yQThXS1pTZFdDVWF1?=
 =?utf-8?B?Z3dxRVhnRGZUOTFWRUN2SWt1Rks2MXBXOG4yZDNCSXRJVmtZZGV6TVJMY05y?=
 =?utf-8?B?WDMxbDlobUFaN2Z2UHcraEtVSTViVFBBOHF1Nm42ZWwyQ3BHd2VxODUwRndN?=
 =?utf-8?B?MmdDUXVqZ1ZOVjdYSGorNHhiRWFEaWVUL2NGeSt6blFzVmJ3OTZ6aGRnSmtl?=
 =?utf-8?B?eXdSaFR6bnNNRkNETnJPbmpiQ2FvSVFnRkcrVGlzRHA4bHE4ODJzNDZwK2Rj?=
 =?utf-8?B?eXhPcHJCOXQ3RWE3V3lkc2dhczNPbHVpNGI4TkRFRTUzY2YxQm41OFJFSkR3?=
 =?utf-8?B?SlRZcnRQZG14SzZMalpuTG9UU3FUb1FKV1JObXo3elNoRWZTQ3NIblZrMEVW?=
 =?utf-8?B?T0N1VStDY3VLSFB5K01yMUNKNTZnV3VJNCtFbDIzME9uZ09Fa1U5bXFYbXg4?=
 =?utf-8?B?R3hFWXJuSmdGSkc4bmtYNGJYalVhRXZpN3pmRHVkWWE0RWRHZ2J5aHRCVjUz?=
 =?utf-8?B?bTVYbURGdnNHMGpGb2FRRmtJaVVvamdDbnVMUXNYNlVSQ2QyYitEN0h0d1RG?=
 =?utf-8?B?ZlFRVUszSENLUkorY1d4MlU2all2K3dMQ0p5TXRCb2dRYXFlS1U3RmRRZnlZ?=
 =?utf-8?B?ODRFQ2x5emNTbHNMTlZsbWVDNU1ucXdLcWVZUGQxTE5iYkZnRzFzNnp0VUli?=
 =?utf-8?B?NzIzekNJVHp0ampMOXFEN2JmSzVvcVk4ekJnYlFQaERhNkpNV1RBbFlWcE5x?=
 =?utf-8?B?Qm95SVJIZVd2aDZ0SStkVDgwT2VaT3UwM0tkTzVoc24wWEpBcTVCZm5KU1p0?=
 =?utf-8?B?R21JVEtEK1RlNE9PQnRLSHVicUJ6YmhPdWhSeDNIUjlTSm5jRjhDK1VuZ2Nw?=
 =?utf-8?B?TGk5cjNXRlVBR0Rkc29wazVScFpPY2VKc05BQXhWaDBheDdrUGlzR2JYUWFX?=
 =?utf-8?B?MEk5NnJFTXFJN2hQUmNHdU1TQjhJWFFrUGUrZzFKTnJsQnBvWFJQWE5KVXBp?=
 =?utf-8?B?NHNIaHp2MHhPUk4yRlROK3Bvc094RnRycVhMc3RrNExGUmlVWEZKQ2RFeTY3?=
 =?utf-8?B?SDZvcnFGV0RBd09qRENyUm5aMGxmWGpqZm9BMmJxQlVKT0Q3RVNPMUN6YW9n?=
 =?utf-8?B?VXg0dG4ydWdBd0Z1U0pvQkpvWWJxUHJBNGFrUkFpSmpDZWNUZGtWVHhremdF?=
 =?utf-8?B?SitBUTZoTmhubHVDc0dEeUZZVTlMZ3VwOVlWb2ljcHZUU0pDaW85NVdtYTlo?=
 =?utf-8?B?c2VLZjEvbmo4STBiNzhwTVR1SU90aC9uUE1vejFXVEtIbFlJMWlHUjRDbXlQ?=
 =?utf-8?B?OWQ0dDgydi9ZN1lGZkpmd1pLdVBsd0lVL0d1SjVFMUkvVHllUDF2aHJ1WWQv?=
 =?utf-8?B?RmdzTlRSMTFraVVUOVFTd3dkcWllbEd6L0FpY28xS2RMTXNoZGYwOXpST3g1?=
 =?utf-8?B?Z1FyOGZZcFVBNm03N3U1TXlEa3krd0FjL09XSEg3SjhHdlVrTElKTXZMUGpE?=
 =?utf-8?B?SU5naXZOcVgxeUNDUXd2SmRkbFlZVXdNTEtRR3pVUlJRR0taRUFqd21iVlFF?=
 =?utf-8?B?bGE2OW0ydUoxUU9UY3A5SGMvNThHek9WT1l6Y2pCZXBNWWhTaG4zY1JQZjIx?=
 =?utf-8?B?YjBmS1FUbVI4ME5oSUVOOTA0b2F2SmpsUk40d2tQUXAwOFphRU9YL2xwa2Nv?=
 =?utf-8?B?THRPYTNHbVBwdzc2K29GM2k0Zm5uaXh5V3haak82VmRmR2xWMVJCWndEcWZk?=
 =?utf-8?B?V3hCaHRhU3dFN0k3YmNGSWhxNTlXb0p1eDZxN1V4ZWxnTU8wMXZ0UnNwZ3JY?=
 =?utf-8?Q?w1o+ikd0COA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aUlrYW9EWldxclRTbVZVR3RLUTlBWXd1RzIwdUlWRUVQZTU4VzlIRnBKTlRF?=
 =?utf-8?B?MHpNMFpWeWJQU3ltaWFWMjRzUFV0MjgxUG5jZm0rVjdiUjBkdVFVWi9oSTVl?=
 =?utf-8?B?N01DZ1ZmNGhlek5xZzRKd3VjSzhaQ1hxK2ZPZ2E0OW9RWlI1Rk5vdnR3M25X?=
 =?utf-8?B?TXFVL1FsZm1aeHFocTh0WEhvWlRIdzFTTGRvaitER3YybUh5UE1LbFNoUVVQ?=
 =?utf-8?B?TUJua2MzSVAwb1NGUnZ0YjRrcTZianppU2E0dHJFV1VYSUt5bEdmdkh4Vzlw?=
 =?utf-8?B?amtSeXMyQk1Md0lsMWplUUltRzhmZVloMjA4d1FaUm5aTU9EK0U0N1AvZHJ0?=
 =?utf-8?B?WUgwVkZLYXY1L2ZoNWU3d3hTSklrL1V1SEVEaXErdERIVklReE1IV3JWZm93?=
 =?utf-8?B?WXEvenlPKzY2WU5kTU5LeEVtK0dsdkErYjE3T3ZyNVFMeVhXb1lseHNvVlBq?=
 =?utf-8?B?SW9HR2hSZGtBYWw4dVJsVVI3UVJEaTUxS3BMOU5VeUN0SjE5NlM3Y1lXaFpK?=
 =?utf-8?B?SU1ERlRDRllkQThlbnBNVkExOGZNTFRpaGlBeGpKUGVrcVlqaFRoU3dvZktl?=
 =?utf-8?B?bWNqYlZHY1lqaXYrK2ZQYTl4K3hFT0g0TWtTVDFLTVRyRHcvZnFDakpQayti?=
 =?utf-8?B?QUVGcWFQWlBPL1hCQ09MREJZUE44Q3J4cjFNMHVHL1hBNEc1b01NZ2ZFSU5Q?=
 =?utf-8?B?NlQveWFCcTRiUytwS3BqV093SElxaENFazFkVk04WW96ZU96ZUs5KzhRZHYx?=
 =?utf-8?B?dERKeXpSclk0TlR0dnk5ZHBKaWJvNnZaejBsRmxMQm1FVGVEYXhWUjdNZWVQ?=
 =?utf-8?B?YnQvcld6bHFKT1l1ODFFZ2EvMng3T0tyQlFHMHZqbjBoa2JQZW1jNjduZitD?=
 =?utf-8?B?UHB4SVZpWHQxU2tNZXhRZXQ4YkpJMHZJZzM0U0dJTEJCcFFvVGNYVjVpNER2?=
 =?utf-8?B?TllCY0g5aGY2Ym9TR1RKWkZFMHhhcGpwKzV4bzMrSElFaGFTSjk3MVJGS2tw?=
 =?utf-8?B?MmFsaG1XRGFHNkVmaWVqeDZ3TE5sNFJ3ekJUN1ZjSWR5WlRyajd5ZGpuYTU1?=
 =?utf-8?B?aEc3NklsNlROaDcxdXVVdG0rTmZHL2dYUkpPcTFQb3I2Kyt3MnN0TVI0VTFI?=
 =?utf-8?B?MHVFd2hTMnY4am5YTmJOR0RNQ1N1Yk50MzR1UjF1MHpRVHhVSytWUnpKajZK?=
 =?utf-8?B?bTVVQzF1T05ubHVLaDI2UXBub1A0b3ArMCt6OUJzemdFaU0xeDJsVW5FNnhw?=
 =?utf-8?B?MjVoQmRuUkJHR1hhVytaN0lmVHFxRHNlY2YxS09rQVNqSVJUajRldWx2SUsv?=
 =?utf-8?B?c2hVdWY5VjZiNXovNFk4RHRqNEZDeDdZdWFXR1lSK2JuVzFEbzhhWmhhMzUr?=
 =?utf-8?B?SW1xeHNNTGRIYjNtWENkN0JuL1luckhsZ0dmWEF0VWVWSHR5cC8veTQrUjI5?=
 =?utf-8?B?eFhVMC9aRDdkSlkxQlBieXIzdVBmT2RNVVZpdUlEcVN0emdpd2xNTk5jRHJX?=
 =?utf-8?B?RzR5ZjBiNzB1ZnA3djZIUU9Sc255a2F3NTV5djJjL2R5N24yVVlvM0VZK0hT?=
 =?utf-8?B?QzBSV3p5SDZSZlhkeXJiaXlhUHoyOGN5Sy9XTWduWE8wcjFDMGZNaC9YUzFL?=
 =?utf-8?B?TmJ5b0NWeVY3SmsyV0dRR0FVcUpRc29lU3B3a0ZlQWZENlBkSUtGNnRYaDA1?=
 =?utf-8?B?VFRQNGIwWVlCeGpCc2pzMTlFKzA4RzA0VEFJekxQNlBORFlvS05vbjRuOXd0?=
 =?utf-8?B?Wm9Pa3hJQy80U3R1am9xbXFnT3E0M2xZU1ZrWnNDaHFIR2xtS1RUWWpHOHJW?=
 =?utf-8?B?STkzVURDZzdNRm5nZ3BYZDh5Y0RVVTcycUxjc0dBcUwxL3NSaHlJWHFCTzVO?=
 =?utf-8?B?cTRDbUZrYlJ4eldZRE9kNmUrVkhlZjQ3NGhqWjQ0alBGeWZCUWJGQmduZzhW?=
 =?utf-8?B?aTlwYmhhVzNBdm9JQ1JsQjlQeVBYMlVqdkVwNkFia1ZabWtLS0FjZG5QZldm?=
 =?utf-8?B?S283MFlIeVRldXhxK0lWbi9XUjdVM2MwUW1abG12azY1UGJnVTZ3NzJIb0tV?=
 =?utf-8?B?THd3THB1TzZaY1R6RU1jOWdsMGZETDVoNjZWazdtTnUxdTNWZmRRem5zaUFs?=
 =?utf-8?B?MzQ5N1A5YkZlc3FzdEs1WGZtZmRaWnNmK2ozMDdSZHhMSk9kMWhSNTgwZTBo?=
 =?utf-8?Q?BVZYfZrjj9bp5AoE0ULnD94=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6174543-195c-4e07-e95c-08ddcecd7f63
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2025 18:26:55.6984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eN3oq6Ashyyp+fvAaKeR1q/BouTe/7qYl07+TVGC8YootNIOShMY8OMRNYVOzrSd7B18SWsVWvqrI6+PWjhjhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PPF3EEE25392
X-Proofpoint-ORIG-GUID: g4wSguJhfbM4BONcleSFjerqEcAczb0T
X-Proofpoint-GUID: rQZv-HpWKrGNOTEVmQpgmHPbDv8lh0Hn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDE0MCBTYWx0ZWRfXz97ri0C9C0MK
 1Jep7F66bZ5sIOzE3DgVGBB3alz1Cr+3MezYGPgkBM4S3X4Bnp5x6uZopjAYh9lws3B0GkfFoXa
 kNwWyyeRRdpdVyqXdwXmIueupumYypYScSM8Z5VDb6DB3szQ6pKIDuBF51iRB8bk4Ws2tCPpj7I
 uLrTHxWVCnm0UB+wj/URxdiIgW+lWl8uPqBlDotHDkrmmL8gWOxiU4rBtTQuIlvDnVjbVvGwG8U
 JECk3yNJBA7k90hPukm/JaVlVWX6jsIruL08L7irxWEs9auMSBl3A2R7UWzaDSibho6B24JYIOr
 5trvkbc3UZIlcFVt0YsO9pIZZqluWcbBNakyvP/UOYBN6KdqOYT8IjM6QKyddYj+eg780WlWtBD
 hHOVgbCv2KbmU7cnKST9hJCm86ntIW+hVcVJIJCIgLTFwCFxjCc4kb+vr91F4cmXoj6WzSc3
X-Authority-Analysis: v=2.4 cv=BJOzrEQG c=1 sm=1 tr=0 ts=68891273 cx=c_pps
 a=9MCiTn2FFLWeZXu3Q3AfBg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Wb1JkmetP80A:10 a=4u6H09k7AAAA:8 a=P-IC7800AAAA:8 a=20KFwNOVAAAA:8
 a=g80bVyVKSRLWqTF_eSgA:9 a=QEXdDO2ut3YA:10 a=5yerskEF2kbSkDMynNst:22
 a=d3PnA9EDa4IxuAV0gXij:22
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB99B1D26AD05E4AA097AB0ADD5B2481@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=2
 engine=8.19.0-2505280000 definitions=main-2507290140

On Tue, 2025-07-29 at 22:32 +0530, khiremat@redhat.com wrote:
> From: Kotresh HR <khiremat@redhat.com>
>=20
> The mds auth caps check should also validate the
> fsname along with the associated caps. Not doing
> so would result in applying the mds auth caps of
> one fs on to the other fs in a multifs ceph cluster.
> The patch fixes the same.
>=20
> Steps to Reproduce (on vstart cluster):
> 1. Create two file systems in a cluster, say 'a' and 'b'
> 2. ceph fs authorize a client.usr / r
> 3. ceph fs authorize b client.usr / rw
> 4. ceph auth get client.usr >> ./keyring
> 5. sudo bin/mount.ceph usr@.a=3D/ /kmnt_a_usr/
> 6. touch /kmnt_a_usr/file1 (SHOULD NOT BE ALLOWED)
> 7. sudo bin/mount.ceph admin@.a=3D/ /kmnt_a_admin
> 8. echo "data" > /kmnt_a_admin/admin_file1
> 9. rm -f /kmnt_a_usr/admin_file1 (SHOULD NOT BE ALLOWED)
>=20

I think we are missing to explain here which problem or
symptoms will see the user that has this issue. I assume that
this will be seen as the issue reproduction:

With client_3 which has only 1 filesystem in caps is working as expected
mkdir /mnt/client_3/test_3
mkdir: cannot create directory =E2=80=98/mnt/client_3/test_3=E2=80=99: Perm=
ission denied

Am I correct here?

> URL: https://tracker.ceph.com/issues/72167 =20
> Signed-off-by: Kotresh HR <khiremat@redhat.com>
> ---
>  fs/ceph/mds_client.c | 10 ++++++++++
>  fs/ceph/mdsmap.c     | 11 ++++++++++-
>  fs/ceph/mdsmap.h     |  1 +
>  3 files changed, 21 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 9eed6d73a508..ba91f3360ff6 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5640,11 +5640,21 @@ static int ceph_mds_auth_match(struct ceph_mds_cl=
ient *mdsc,
>  	u32 caller_uid =3D from_kuid(&init_user_ns, cred->fsuid);
>  	u32 caller_gid =3D from_kgid(&init_user_ns, cred->fsgid);
>  	struct ceph_client *cl =3D mdsc->fsc->client;
> +	const char *fs_name =3D mdsc->mdsmap->fs_name;
>  	const char *spath =3D mdsc->fsc->mount_options->server_path;
>  	bool gid_matched =3D false;
>  	u32 gid, tlen, len;
>  	int i, j;
> =20
> +	if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {

Should we consider to use strncmp() here?
We should have the limitation of maximum possible name length.

> +		doutc(cl, "fsname check failed fs_name=3D%s  match.fs_name=3D%s\n",
> +		      fs_name, auth->match.fs_name);
> +		return 0;
> +	} else {
> +		doutc(cl, "fsname check passed fs_name=3D%s  match.fs_name=3D%s\n",
> +		      fs_name, auth->match.fs_name);

I assume that we could call the doutc with auth->match.fs_name =3D=3D NULL.=
 So, I am
expecting to have a crash here.

> +	}
> +
>  	doutc(cl, "match.uid %lld\n", auth->match.uid);
>  	if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
>  		if (auth->match.uid !=3D caller_uid)
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 8109aba66e02..f1431ba0b33e 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -356,7 +356,15 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_m=
ds_client *mdsc, void **p,
>  		/* enabled */
>  		ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
>  		/* fs_name */
> -		ceph_decode_skip_string(p, end, bad_ext);
> +	        m->fs_name =3D ceph_extract_encoded_string(p, end, NULL, GFP_NO=
FS);
> +	        if (IS_ERR(m->fs_name)) {
> +			err =3D PTR_ERR(m->fs_name);
> +			m->fs_name =3D NULL;
> +			if (err =3D=3D -ENOMEM)
> +				goto out_err;
> +			else
> +				goto bad;
> +	        }
>  	}
>  	/* damaged */
>  	if (mdsmap_ev >=3D 9) {
> @@ -418,6 +426,7 @@ void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
>  		kfree(m->m_info);
>  	}
>  	kfree(m->m_data_pg_pools);
> +	kfree(m->fs_name);
>  	kfree(m);
>  }
> =20
> diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
> index 1f2171dd01bf..acb0a2a3627a 100644
> --- a/fs/ceph/mdsmap.h
> +++ b/fs/ceph/mdsmap.h
> @@ -45,6 +45,7 @@ struct ceph_mdsmap {
>  	bool m_enabled;
>  	bool m_damaged;
>  	int m_num_laggy;
> +	char *fs_name;

The ceph_mdsmap structure describes servers in the mds cluster [1].
Semantically, I don't see any relation of fs_name with this structure.
As a result, I don't see the point to keep this pointer in this structure.
Why the fs_name has been placed in this structure?

Thanks,
Slava.

>  };
> =20
>  static inline struct ceph_entity_addr *

[1] https://elixir.bootlin.com/linux/v6.16/source/fs/ceph/mdsmap.h#L11

