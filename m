Return-Path: <ceph-devel+bounces-3521-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A3AB444F3
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 20:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C98D81BC3960
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 18:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C03D338F5F;
	Thu,  4 Sep 2025 18:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YaKN6T3+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCCB233145;
	Thu,  4 Sep 2025 18:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757008875; cv=fail; b=m+6UzD82BwxqNq5ppM1ZWDhSRsu57hOJ0kmfxLn0hXBzplO/HbFZ5QbOADVv4OaXRZHOim9CtpSoEAnjVMBh7V5/RwaL5nLQUdGRpQpGNPFWZ26yDeBRAmd/nFx/xOxGASVzQblJ2qaAV7/U/0dXpRFiTDzjelcwvnvMNtBFlvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757008875; c=relaxed/simple;
	bh=0hcJKWQytPojc1AbtZVhPjZdA9Jg7RfoEtTLMMdsgLM=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=FMLbfuek6nqIXCzxrinkLdiS6RMBrQ3h/S7tAfrjyM/7bAHpGQPGVyseBGg0MwTaIZ4KHocUxoJM1YO2+3+AiXH+9lrOw8pigKA98j6A/up1PdaNsbkld7gBXNPgqdsoKlRJIF1lZV/Tk0VuXAjO0qOQvroDeAMMeikXiSUvauI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YaKN6T3+; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ae45P012425;
	Thu, 4 Sep 2025 18:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=0hcJKWQytPojc1AbtZVhPjZdA9Jg7RfoEtTLMMdsgLM=; b=YaKN6T3+
	nAj7qUCgxKFwpHflHi1sWBGgMBss/WGRX/iCHLkQk434nWQA01Llnio5X3yD5WwR
	g51kIwse7aj/Ww5dehYoTuLb/YM+tDaEvo5TBkLgrlk5X4YLuzQt2EML0LMIARV6
	CkN93iJkrqdJwKzNe4QnwrSW0itbhjk5L518TpMyXVCeOFWd/doW1Y7M1JM+BaO1
	VzfH7quCyNZodaA2twjkK+Dqul/9/fJMmWaVB6iGRKnPRu/d+p4TNra/L1ZgN55N
	0itvwpSEbiF/xCtgpFpCgcyLlopIuBh/XizHgofgl0bt/wMA5eQXx0iZQz4d8pt/
	FKKpI6DbiQQN/A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usvg3e49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Sep 2025 18:01:09 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 584Hwg7B029080;
	Thu, 4 Sep 2025 18:01:09 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usvg3e45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Sep 2025 18:01:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BXkv1/6My27KA32frueMjVz+r3epDPZ5GmaMiKMSmmahSU7g06dPH47H+vhklfGORtxXzNFLW/bwr/CP4yQuK4g3KDUHMXIo3M5/0W0yv5lU/lh8XvYJOZNocnrehkS0XBJHFBUC38M5Naz/EW+Tnw+UcPI//w7KZgBRnrCl3rNY20t/whyVgckefP1EDH8bSxej5i5+pz3CLugZ/OpFpKV7ppadI2KA0iaU0yvHSTvGSqQflFFRgV1TmjNuLCComr7auZd6WYa8VOhICz8m2e352v+EEpSoZc1Uz4J+BvHdC/iO46usLnMvaktYujSPemT7l6fXGtZsne1qJeG5+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hcJKWQytPojc1AbtZVhPjZdA9Jg7RfoEtTLMMdsgLM=;
 b=xNx11viDwxmdWCOXJaZbELQnBYdd/iJ/d9ztL2YL4Aj+N3f+iKco6ullwLc5h5ortMLGdWfKwxNtNlhLU+nghpWI7fSfzuWnC+d5mHTMg4jwut9OD7IoinCKxARrAUuFtjWb8/Fq79E63Yrr048wvpHhzsPbcL38fXdE0yj57BR1RHjz+z9F8S/IGLNF/1CqgjE/gr2zzV70BKBGUw6BtgysIe/DHFfY47qjCMazeOhX7LvypXQt179HA2FytQdiNU6+JzmJz3z9fVC8AXOxoGvA6DrjQVvRoFe8GAJC2JELsvxFraUj+apG4DhKuak0ItmuzzsBB+x1Cd3QkEjf4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB4687.namprd15.prod.outlook.com (2603:10b6:510:8c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 18:01:07 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.015; Thu, 4 Sep 2025
 18:01:06 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v2 1/2] ceph/mdsc: Move CEPH_CAP_PIN reference
 when r_parent is updated
Thread-Index: AQHcHYRRQfpFk1LIX0ul2RV01YPGb7SDULuA
Date: Thu, 4 Sep 2025 18:01:06 +0000
Message-ID: <18f9adc3daff3342fb09173a7d45140dd2be1137.camel@ibm.com>
References: <20250904101131.1258532-1-amarkuze@redhat.com>
In-Reply-To: <20250904101131.1258532-1-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB4687:EE_
x-ms-office365-filtering-correlation-id: bc394974-c040-4d07-2c4a-08ddebdd0502
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RHFLNG9HTVpWenNac2RRclhzT2JhUXZ3eFhxYklDTlhQMDRoYjNaWUVabWwx?=
 =?utf-8?B?bEREOXNFS1JtTTF5dTEwWTBiSElsZ1NZaElvT3A3ckxDeGVYenphOUpTelFa?=
 =?utf-8?B?T09tN2FsaGFuZlNtQ1BmNFFudjFnNmpUK2ttRVFmZnQwNyt4RG5Wd0tabkhV?=
 =?utf-8?B?dTlDMUc1M29lTWYwYWtuVmtHNXNaKzg0QndWTXFnTEFyNVJWZVNOQS9yQU16?=
 =?utf-8?B?ZlRzQjk5Qy8vTkxKaE5Ud3AyblpORjlIUmpUUHFNWUEvb0ZaS2dab0RGM2Fr?=
 =?utf-8?B?YTlxUVhBYzl1ZWI1Qm1NaUxDTE9zdUlhRDhtQllZblZ3TGZTb2toMTExNHgv?=
 =?utf-8?B?SU1ZeHZtMDZlOElPNjU0WTMvdzcydkJUeTFZT1BqZHNpNU13NE51QUZ3cVBk?=
 =?utf-8?B?dXo0b1FJWDlZZ3NRU3JLSVBlOGFPeVRvSjhMemtWQ0ZNK3Q3TCtsSHFvZHhi?=
 =?utf-8?B?TXhiTVlZODRTaWtXdWM1ZlBaNkkwL2JWbGhyVmQ1SVdjU240VEYydyt1MDNx?=
 =?utf-8?B?Z0Zac1NodGdOOU5obEhZTTh1MmxOZXE3OEZCSEp4cWJrdXlvUVNVZkpvcGtI?=
 =?utf-8?B?L0lzNHk4cTU2bG05QUFidnJSY2VnUWRwVld0cXRtS0srVlFac3BuQjYwemdK?=
 =?utf-8?B?ZnRmVXo5RHJ4OXNmSzRqbTJqaFB6VTJWWWRJRzhCMFFxSElEVGpRaFZHWWRM?=
 =?utf-8?B?V1BuRk44TnFqZEtmVUVrY0ZkYTJjckdwbFlxTm1Hc1RaTTFtZmJmMndUZ3BP?=
 =?utf-8?B?eUYrRmR3LzQyTWxaL3FGZmRUazRNTGxPR1lmemRQckR1YnBTM3dUdUdvRFZK?=
 =?utf-8?B?VzlQZ2xWdW9qYXpyeHFkeHBUdG11cE5kWXQ1WFNYdlVqeCt4aHZpV0l5UFFP?=
 =?utf-8?B?MmVGcTVTZ2tZcTlOY29zNUxXM3k1OUl2Z1kzK1J0V3FsYTZodnFVRnRqdmp6?=
 =?utf-8?B?Mi8vUUZvQ05YcHJ0eVJpVkp6ZUlmYkwrdHhjSmNtVnJuUHJrWDdkelFEVE1j?=
 =?utf-8?B?K2h0K1hWdkJlaVFmcS9yTGtjWEQzT2RSeHRTdTFnci9Eb29Jemp3TlRQeVlj?=
 =?utf-8?B?Wm9ZbjFVSVRwb2gzRXNEMW5tY1NnWnd4SWtMZ2NpMDVwTDVueUdUaDY1cVBL?=
 =?utf-8?B?OU1XVGozZjlsa2orWmM5aWYzSmhSdnZyZExiRm4wdjlVZzRMS0cxRVdBdWRT?=
 =?utf-8?B?b0pDODZOckluYzhjNU8vRloxd2ppUnlaWHBvd0RzVnlvNFI1ZHVqdG5JMUM4?=
 =?utf-8?B?MlM3VEgySnluOFNsRkw3eXVadnBmTkErL1p2anFsVUh5NGxQcitwY1dpZEVq?=
 =?utf-8?B?MjZzb1ZjTG9iUWpYZ0dIZ0k0eUI3UEF3cWQ4YythV3FDaVRKZ0lpTHJ4d1VS?=
 =?utf-8?B?a1cvZ3NVb3NySnhKR0srcHhtZzhyR3JHNHo0TXBqcGU2cHBLRG9YREdUU2Ra?=
 =?utf-8?B?YTZ0eElpR2dNTFFxdEZyRW1wOWUzUDU1aHNseFozSmNLeCsyTGZVRXRETFdv?=
 =?utf-8?B?dVc4T2Y1U0dFcStVSFZEeXRxdWxOZlI0Q3RvRmpsNWhtcmJiM29Qb2N6cjVX?=
 =?utf-8?B?N0J4OEhUc0UvNWZhaTQ2K1Ayd2NvTVdzLzd6MENDODlSVGtqL09ZejQreEw4?=
 =?utf-8?B?SCtmVzNGMDVjSXFLalNvQUJYYW4wb0owQm11YWVFTGU4TlllRXVFL2ZGczAw?=
 =?utf-8?B?UTR4cGxtVTArenZQMGw5V2JFMmZsMGhGM3RUNXRNamhhczZER1NKemJCNmFn?=
 =?utf-8?B?UEg0eVkvQ0lyaGdIUkpUNnRkam1jOWVjdzdBNzhtRGNsVWl4OW9MZlVLaDZF?=
 =?utf-8?B?U0d3ZEd4TGJRZXE4bGYyajNVREl0K1J2U21yMlVaUnNuOE5tVmEvL1MwYjd2?=
 =?utf-8?B?OW43bW8rTWJtazJyVFhodUIxa3dubmxwNkhDL1Z5V0ROR084S2VBdko3NEg5?=
 =?utf-8?B?blpTSmtka3BMMUFqNHVoZEJXMXdzRzZZZU5PRlAyQUU1YmVLaFRqa1dBS1l1?=
 =?utf-8?B?Q0k3WjcyZW5nPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Tk5KYzRRUFZXQ0k0WVg5VWNzYW91ZjVRK0llQlpvby9XTDh5RHBPOFlpTGQ1?=
 =?utf-8?B?K1M4UmhJaXVXUEpWQ1pqZmQzRXBvK3pCZUg4M1VlOUg4b1RsRm4vVmVpL3A4?=
 =?utf-8?B?c2NiSHd5anpXZmJQNUpIMWpSYTh2Q25oMTFoM2E0UFJuc0RPWDVabmhJY1NP?=
 =?utf-8?B?dUdHNkNJQW9oRDZkdkZBMnF6dDd2T3k1ektjSlRkQStMbTgrWTQyOEtCS3Mx?=
 =?utf-8?B?YVhsUG92MzhtZ0JGQnlEVUR3VW1oNytrZHBmaHJUbmszK09SYi9VK091Z2J4?=
 =?utf-8?B?Z0huVzFaam9Ed0lHWDh0N3VobjEyK3ArN3hXNGNlQi93NC83SnlxNngrZTRq?=
 =?utf-8?B?NzBGL3ZkREdGQVBMdXJ4aEQ3bEZLNzhnc2F1ckg4MTFvUjlSSG85QmI4cVBE?=
 =?utf-8?B?M2crLy9qbTlTVmtic3oyN1R1NWhjZTdCYXdQRG1aSjFMODRPVTNaWkVFOVM2?=
 =?utf-8?B?RVdWWUhyNjJLWGlWV3ZFajFBTzVBOS9SQkJWalM0ZldQZkoxdWdCa0tUUzBu?=
 =?utf-8?B?bEVGVDhJTU5XckcyMEFTZzFyWHRXNzFvQ21ZcGg3VmRXRDFNR05HZHhJTlpD?=
 =?utf-8?B?Z3Q2a3RNY2pHZE4vV24rSks2aDRmS3N5VFJrUHhnR1NseHFOSjJNMC8yUFBh?=
 =?utf-8?B?UmY5WXphNUdCekVMd3pmd2d3d1V0WVI3NWFwZXFqZS9Gakk0K3lUSjJDb2F6?=
 =?utf-8?B?WEd2N1ZnZHIrcVV3Zlo0cUE1dWdLUVA3K3Z0V1FYbk85ajVQUlhTNWdkT2tq?=
 =?utf-8?B?bUdvUnBXbVZycytqRWNQUkttbFFJUW5qL3NsRUpUWE1XNTFxd1VkTlZTUTEz?=
 =?utf-8?B?cE02V0MyeDhsOGZUYnE0NDEySU1XTVd1a2Q5aVI0dUc3V3RQRjF4R1cyUmhq?=
 =?utf-8?B?WWJxazAxZnhnRnRLRUpnTnEyOUp1M0ZnT0lzajA3cTFuNFdMMmFBcHJMOWZa?=
 =?utf-8?B?WHJtTzZqUGpmU0pBVVFKV0psek5oOGQ2MlZDZmo3UTZrWHl4STZoSDF3dHNP?=
 =?utf-8?B?d2NkTzdkSUZFTlNWQ1BSbzFWKzl6ODV1cFNuMnZoV0FxRzhUNjFBc3RsQUFq?=
 =?utf-8?B?b2pQbnZjclRYelhSZm9sVk5GbUFXMkJYRDdSdkJHUThGZWU3SmUvRkJ3VXhI?=
 =?utf-8?B?UDVtMHc2aGd1anM3M25mckVGaVlkUkNROUdOaVJlL3ZPdkNJNlhadWllTUVp?=
 =?utf-8?B?R3p6bmorVXdxK3FHT0g0Rm15QTJmNE54V3RHeU1WM3NTQ05TN2Y1R3F2UC9N?=
 =?utf-8?B?cVNPUjJoemxLMVVNbm1iak9LVk11UkZHcVNidSs4aFVoTUpINXRsN3cyNTBq?=
 =?utf-8?B?VzJ5Z2oxaGNja1NUSkg5QWJFRDBnaHFYY3JLL2h5ZkVDUUYwQnlyeEN2L3hZ?=
 =?utf-8?B?d3JvR3JCSWM0dmp6eHltcUhMWXFDOGRNTzB1VU5vVnJJdVJRSThOK1hIampK?=
 =?utf-8?B?dEVZOENCclB2UWJIalJvcFhHTlV2cDkwZjZpZ1cwTVpGRHNCWUR2bUJ5K2VU?=
 =?utf-8?B?akF5S1BucjdaTUFKaHBrK1o5MURqMFA1djdKQTI4clRGY3V1WmxHM0J3b1o1?=
 =?utf-8?B?UGtaUVRMcXd5dzJiUkltbVdNVThXc2FvQTUrN1BrWGF5MWRyRzVmeWpIeTJC?=
 =?utf-8?B?azlKUEJwcmcwYVlJYnRielkzbFBBT3Z5MEpBSEdvd1RlZWNSNzlSQzJQZW9E?=
 =?utf-8?B?cFhDcS8rYTlLVVZHUEZSYlZySFRhRk9DRFhZdGdTMFcva1E3OG9BTG5ienZn?=
 =?utf-8?B?NVh0eG5PNkEvckt0T1BIei9JUEtxZ25raCtRVENRWGU4bHdNWmFML0cyRW54?=
 =?utf-8?B?TEI0UXZkcWNhWUhLQU9HRDkxT3E3OVpZcHJjaDFWZ3MwZnJuOG9GbGR6Q0RB?=
 =?utf-8?B?UFB1bEZLQmcraFQwaCtrTCs4SFJ1alhFV0ZRTHU3bjBBTXp3NXphV0kzSGwy?=
 =?utf-8?B?bGR2M3FoenhrSHNXLzE0Yi83MFhwRGJVbXZrT0c5OWRDMFZUUlh4b0ZhdjBN?=
 =?utf-8?B?MEhZbHRPRGhlWWk5a3cwNHA1aUZPY0EzTU9KdVNWNjU4Zm1veTFDSFJ3YjV2?=
 =?utf-8?B?VzR2WWk0ZTU3Tlo1a09OMVViNDhNRHlHblQ1TkJ3clcwZy9uamtCUERsOFZn?=
 =?utf-8?B?L0xZRlFoYjJBSjNEbzVCc09iVlA5clFXd2g4QVluMjB5L1ZWWTA2c3dSZGV5?=
 =?utf-8?Q?eW/9VS1GM755tf9Tzy0egeM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A87DA8E5A7ABEE4EB325D62530D6B071@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bc394974-c040-4d07-2c4a-08ddebdd0502
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2025 18:01:06.0545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dr4x7y8vJDYvGgzxx0Xnv5H4/XFrc2joLvcpRqL7l99ZspsO57RfaHN2uZpbB4X6HllkOrrO2aaorxvIUUlrhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4687
X-Authority-Analysis: v=2.4 cv=behrUPPB c=1 sm=1 tr=0 ts=68b9d3e5 cx=c_pps
 a=PLcI3SF5L27/RyFVs0pFTA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=RR-q66pgY6fuALBEEg8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 1MEeBO9Rc1ZY_I2ivBN9wb0RdNqjeKDs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfXxcQurl7kXc6b
 YZod4pnw351sy/ofz2YMrLOzxywtAGob8QAJdEc3mijS/cCOeWAuS4Qy6OweRAOtXRatMV4qAO3
 A8NZ2Qsg7mOeMC40iJuMJk5enRSwP14/t7j7S2pg5R7hpJEHrIQsVPa7Di3hWU37crBqIVt6pYC
 NqCsF6aA0qwVaeVjzf9hVTde0AdJeb+7kzxL35qQF/+kZ/Z5KSN/56nOT5Nt7dK9ZTY/Eec/jYf
 MQ+eW+8Cj+anZyy6zbvpZKMsc8SIFK0g3W3hDqQRQne5ZO3x0YzBFPPzNxsLeLcCmTaBgTR9RpV
 B94RqTJYOprzmOV4cAF1YX/WVtI8JczijnKyWW40N6380mbrOB9qZWtvhuVjY+iu7S6w2sEXyQo
 bBWoQVKW
X-Proofpoint-GUID: ZhzBcbKQD7QSZ28DRfPp7zpD8ekLnX3r
Subject: Re:  [PATCH v2 1/2] ceph/mdsc: Move CEPH_CAP_PIN reference when
 r_parent is updated
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508300034

T24gVGh1LCAyMDI1LTA5LTA0IGF0IDEwOjExICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IFdoZW4gdGhlIHBhcmVudCBkaXJlY3RvcnkgbG9jayBpcyBub3QgaGVsZCwgcmVxLT5yX3BhcmVu
dCBjYW4gYmVjb21lIHN0YWxlIGFuZCBpcyB1cGRhdGVkIHRvIHBvaW50IHRvIHRoZSBjb3JyZWN0
IGlub2RlLg0KPiBIb3dldmVyLCB0aGUgYXNzb2NpYXRlZCBDRVBIX0NBUF9QSU4gcmVmZXJlbmNl
IHdhcyBub3QgYmVpbmcgYWRqdXN0ZWQuDQo+IFRoZSBDRVBIX0NBUF9QSU4gaXMgYSByZWZlcmVu
Y2Ugb24gYW4gaW5vZGUgdGhhdCBpcyB0cmFja2VkIGZvciBhY2NvdW50aW5nIHB1cnBvc2VzLg0K
PiBNb3ZpbmcgdGhpcyBwaW4gaXMgaW1wb3J0YW50IHRvIGtlZXAgdGhlIGFjY291bnRpbmcgYmFs
YW5jZWQuIFdoZW4gdGhlIHBpbiB3YXMgbm90IG1vdmVkIGZyb20gdGhlIG9sZCBwYXJlbnQgdG8g
dGhlIG5ldyBvbmUsIGl0IGNyZWF0ZWQgdHdvIHByb2JsZW1zOg0KPiBUaGUgcmVmZXJlbmNlIG9u
IHRoZSBvbGQsIHN0YWxlIHBhcmVudCB3YXMgbmV2ZXIgcmVsZWFzZWQsIGNhdXNpbmcgYSByZWZl
cmVuY2UgbGVhay4NCj4gQSByZWZlcmVuY2UgZm9yIHRoZSBuZXcgcGFyZW50IHdhcyBuZXZlciBh
Y3F1aXJlZCwgY3JlYXRpbmcgdGhlIHJpc2sgb2YgYSByZWZlcmVuY2UgdW5kZXJmbG93IGxhdGVy
IGluIGNlcGhfbWRzY19yZWxlYXNlX3JlcXVlc3QoKS4NCj4gVGhpcyBwYXRjaCBjb3JyZWN0cyB0
aGUgbG9naWMgYnkgcmVsZWFzaW5nIHRoZSBwaW4gZnJvbSB0aGUgb2xkIHBhcmVudCBhbmQgYWNx
dWlyaW5nIGl0IGZvciB0aGUgbmV3IHBhcmVudCB3aGVuIHJfcGFyZW50IGlzIHN3aXRjaGVkLg0K
PiBUaGlzIGVuc3VyZXMgcmVmZXJlbmNlIGFjY291bnRpbmcgc3RheXMgYmFsYW5jZWQuDQoNClRo
aXMgZXhwbGFuYXRpb24gbG9va3MgbXVjaCBjbGVhbmVyLiA6KQ0KDQpUaGFua3MsDQpTbGF2YS4N
Cg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxleCBNYXJrdXplIDxhbWFya3V6ZUByZWRoYXQuY29t
Pg0KPiBSZXZpZXdlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5j
b20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9tZHNfY2xpZW50LmMgfCAxMSArKysrKysrKystLQ0KPiAg
MSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9mcy9jZXBoL21kc19jbGllbnQuYyBiL2ZzL2NlcGgvbWRzX2NsaWVudC5jDQo+
IGluZGV4IGNlMGMxMjlmNDY1MS4uNGU1OTI2ZjM2ZThkIDEwMDY0NA0KPiAtLS0gYS9mcy9jZXBo
L21kc19jbGllbnQuYw0KPiArKysgYi9mcy9jZXBoL21kc19jbGllbnQuYw0KPiBAQCAtMzA1Mywx
MiArMzA1MywxOSBAQCBzdGF0aWMgc3RydWN0IGNlcGhfbXNnICpjcmVhdGVfcmVxdWVzdF9tZXNz
YWdlKHN0cnVjdCBjZXBoX21kc19zZXNzaW9uICpzZXNzaW9uLA0KPiAgCSAqLw0KPiAgCWlmICgh
cGFyZW50X2xvY2tlZCAmJiByZXEtPnJfcGFyZW50ICYmIHBhdGhfaW5mbzEudmluby5pbm8gJiYN
Cj4gIAkgICAgY2VwaF9pbm8ocmVxLT5yX3BhcmVudCkgIT0gcGF0aF9pbmZvMS52aW5vLmlubykg
ew0KPiArCQlzdHJ1Y3QgaW5vZGUgKm9sZF9wYXJlbnQgPSByZXEtPnJfcGFyZW50Ow0KPiAgCQlz
dHJ1Y3QgaW5vZGUgKmNvcnJlY3RfZGlyID0gY2VwaF9nZXRfaW5vZGUobWRzYy0+ZnNjLT5zYiwg
cGF0aF9pbmZvMS52aW5vLCBOVUxMKTsNCj4gIAkJaWYgKCFJU19FUlIoY29ycmVjdF9kaXIpKSB7
DQo+ICAJCQlXQVJOX09OQ0UoMSwgImNlcGg6IHJfcGFyZW50IG1pc21hdGNoIChoYWQgJWxseCB3
YW50ZWQgJWxseCkgLSB1cGRhdGluZ1xuIiwNCj4gLQkJCQkgIGNlcGhfaW5vKHJlcS0+cl9wYXJl
bnQpLCBwYXRoX2luZm8xLnZpbm8uaW5vKTsNCj4gLQkJCWlwdXQocmVxLT5yX3BhcmVudCk7DQo+
ICsJCQkgICAgICAgICAgY2VwaF9pbm8ob2xkX3BhcmVudCksIHBhdGhfaW5mbzEudmluby5pbm8p
Ow0KPiArCQkJLyoNCj4gKwkJCSAqIFRyYW5zZmVyIENFUEhfQ0FQX1BJTiBmcm9tIHRoZSBvbGQg
cGFyZW50IHRvIHRoZSBuZXcgb25lLg0KPiArCQkJICogVGhlIHBpbiB3YXMgdGFrZW4gZWFybGll
ciBpbiBjZXBoX21kc2Nfc3VibWl0X3JlcXVlc3QoKS4NCj4gKwkJCSAqLw0KPiArCQkJY2VwaF9w
dXRfY2FwX3JlZnMoY2VwaF9pbm9kZShvbGRfcGFyZW50KSwgQ0VQSF9DQVBfUElOKTsNCj4gKwkJ
CWlwdXQob2xkX3BhcmVudCk7DQo+ICAJCQlyZXEtPnJfcGFyZW50ID0gY29ycmVjdF9kaXI7DQo+
ICsJCQljZXBoX2dldF9jYXBfcmVmcyhjZXBoX2lub2RlKHJlcS0+cl9wYXJlbnQpLCBDRVBIX0NB
UF9QSU4pOw0KPiAgCQl9DQo+ICAJfQ0KPiAgDQo=

