Return-Path: <ceph-devel+bounces-3765-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EA44BAE4B4
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Sep 2025 20:24:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BA037A4C21
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Sep 2025 18:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65E02264AB;
	Tue, 30 Sep 2025 18:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IJtHrKn+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6CE33EC;
	Tue, 30 Sep 2025 18:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759256675; cv=fail; b=H4cZssxkYSz5ac2+prc0V02vDump7VR2BZOSMuLdTWN/PQYBM8u/ht6MkiVXywFUCzhw5dBvL75QhU3t83/WzcChwNamMsNbdbakf4RhHbUx4GiVrIL8DzXWbYSIq/3ueoMY7B1ybuHDWP1TbXALvcV5t9Y2fMcLYNw3j6znRDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759256675; c=relaxed/simple;
	bh=DaENb2siV6eT1dE3BFZp5tapJE1FY+jOoppPDq3MWMY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=BFQilxQmuqqpx3DB5qNCxM950Wjvzr4WUFmUDB3Ot4AQVsZJPreZYxHk+lGDsY6kwBEHUkLB7iZbfDxIG8TZtgSjA/ANs2wzOiYJjGY1pUFkFPrjbTxWnFwynJD/5bdUV9UGFmNEW5O0pxIInZYyTtOGaLHovYD9oCvb65rVNEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IJtHrKn+; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UEea41003329;
	Tue, 30 Sep 2025 18:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=DaENb2siV6eT1dE3BFZp5tapJE1FY+jOoppPDq3MWMY=; b=IJtHrKn+
	U84LFruam8KERlsi01iixTDduJfMeHjcnnSkawc2oB+3+a2ubpvPMprKmQ6Z7+kc
	8NMVW4IzFK2pGTcEP7INl4zk8LQE8BlD1aZ30ctCTllmvTV9KEpjhMGV0bF89X1v
	loWA7U94Qx0gp6fe5AfW0R4QcPi3xA1HMwRZtimg31Ikg+syF6pv7CrNbpk5mONq
	63Mx9KuAQ0azrjl9NmBmZksh5mMmzBHs9m80Hfq7FjBLQj1r9CmAvzdvEHQG4ovd
	v3g20G2xjI24V+hm/NRkhpcQxEckZOmT2F1tjq4QcAcTvxfcFJkVb6yXMoeErS16
	77pCui/TKz8xOw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7n7trgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 18:24:22 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58UIOLuT028537;
	Tue, 30 Sep 2025 18:24:21 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010030.outbound.protection.outlook.com [52.101.61.30])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7n7trgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 18:24:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADOzb7gk8rVZasKwptRcb6Ee3DBcU58ng1kZ/8oPq2mJeub+4I3burzC5FMOdGTvtmeWypnzMEBFE0MK+SdACSOM6AHz0hVCZAxjmfaXyQfhMgPvbaHNJ5KCLDer/Umz/MnoSB7JfybgHZQ2qb4ytrpEd1UmKwN/iS3K5kaBAMzfiKlp1KNK4O/6Va65tdscDRJIu0jx9gs+hXovFdtiScYSnu/lNKymskO2PLlHIWapu9wbZdfNnQAnes9A3+ff+xVVVGuRzotT2cvq6Zyk3+OXXMMZ3aVmcEUX2LwLogAgeMdY6505IusV4dTPvH9IC8Ozz2FtyhJ77OlJbJId9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaENb2siV6eT1dE3BFZp5tapJE1FY+jOoppPDq3MWMY=;
 b=sKdFQvYb7vkHPnrMvwhs8Thl9qGtFQMAnns0cdoJ7JJ+7i5LraOAFjIXkawWTUjszJS15ltmaHSTDD4ZrF/QnIBn87Q6WVqzzB5KqiLzJ6V+elWmSXKwuDOl9mh243KfDRdW9xKUkrCKxlCnkMk3T6d4jLjNBmQKkGkZifnTT1+i8ccGeDiZc6VOKfVI7+oREOz1HD36aa2vqH+EzPmIHZ2U9D9ptvRijntAN5+JAeoaQP3LFK4ptGKtsS8n+bLqHRFzn90/Bt1r4g14hZsuyXRTgbJrLi22bQZqdy4I9qwXG8TlifKNRM1fHY5DGnbtUu0TPAEjViUpNmHk+TBfiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB5660.namprd15.prod.outlook.com (2603:10b6:510:287::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 18:24:19 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Tue, 30 Sep 2025
 18:24:19 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "ethanwu@synology.com" <ethanwu@synology.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "ethan198912@gmail.com" <ethan198912@gmail.com>
Thread-Topic: [EXTERNAL] [PATCH] ceph/006: test snapshot data integrity after
 punch hole operations
Thread-Index: AQHcMd/3/542ZxFJdUyxU7JeI4QbdrSsCx0A
Date: Tue, 30 Sep 2025 18:24:19 +0000
Message-ID: <7d9866d591e7fe4e5f3336aaa13107db402a608d.camel@ibm.com>
References: <20250930075743.2404523-1-ethanwu@synology.com>
In-Reply-To: <20250930075743.2404523-1-ethanwu@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB5660:EE_
x-ms-office365-filtering-correlation-id: 97a96006-3de5-4caf-f13e-08de004e921f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QjVLWW1oSGFsbTFsL3daRVZyd3VxdnFFdlFnU0VTS1BPTXNFTkRCOU9LU1dy?=
 =?utf-8?B?TVg0NWg2R1JLYm81MFFiL00yMEJDRk9MUHl6V0NtemlKUEM3SGlORXNlVVBs?=
 =?utf-8?B?UnhVWkZ6djVvZTRqdHNhbVVCU0pvU1ZVRHEySmRXSVIvOFFZSFVHV2IvRXpM?=
 =?utf-8?B?ZmFIQkZRMVdSRVFtdmgzU1RrRDUwREw2VnJJemd6blpsOW4xd3JoZ1Y0RlE0?=
 =?utf-8?B?NFc0cEVNaWpQUWZMcTFYeWc1R25kc1VYMHpIQy9kNVNtK3hSRlJRekp0TjZ0?=
 =?utf-8?B?TUNXUWtjZmZKYjFQZmQ4K0llNXE2eGwrNkR3QlNQbkhrWk80RFkrSzNMVEZx?=
 =?utf-8?B?SHA0VUdFckJNZUtYa3ZNSkpPUzNETU5rWTBSMDJsVDYyQnpyR0s0aEdzZ0Vs?=
 =?utf-8?B?NHZDSWJuYnVlREluZkxBMFEwV1VWdmV0bDF4MzVvOEpjdXBENWNjSVdTS3FF?=
 =?utf-8?B?VjZSNkdqN3dQMTN1dmJVdUZqb0d1dWVBK1lpaXV0elI2emFIdHVvaC9EUUpp?=
 =?utf-8?B?L2dYNDRVeUcvc2FaQnhoMjBLZFhMeFlCYjE0M0VhczgzWjEvMWZWdFlxRHFx?=
 =?utf-8?B?amJ5U2JzTWZLUVh1ZjI4OVgyQTZyUFVwRmlQaEZUTmVjSHRBcGh0OVZ5OFlX?=
 =?utf-8?B?Rmo5ZWtsdkMvS2Q3MXBNU2Q2ek16eEpVYUxQbWR0Z3JrRFZER3Zjc1JEWjgw?=
 =?utf-8?B?d0FFUFVjZFBPZ3BHWDU1cURWWm8wdGlURjZPdXV0d2grSThLWDFvMncvMEFH?=
 =?utf-8?B?NFplQmk3NE5WRWJxOGVLQXR4MUQzWWo0UWxDQ3NlcDZvTW5qWG9lUDhUQnFv?=
 =?utf-8?B?QlVnY012SFhsY2ZiaG85bjg2K1RVWUNtN0tvSVVGRXZsdWxXbE9HRUVYRjBD?=
 =?utf-8?B?RkcrUnZRUWp2WlRiRldKYXRXaUV2QzI1SVFYeXZ6OXk5ajVkZHpVNHdXaWhl?=
 =?utf-8?B?c1ZnM1JEOW4vdmtzUWY1MWZXd3pNaGVVWnp3TUFmTmdXbmxvZVFoWFU3TUtu?=
 =?utf-8?B?RTJsWENtV01INWNMZUJSdWtieXZCbHk0QTQ0Zk5RbVZsQ3NBTWRqUDk5WHln?=
 =?utf-8?B?dGRrNDJJb2QrbDhTeGV5SkVmYkVhQkl4ZUxRZWJRV0tKZTc1VEFSdTNReC9y?=
 =?utf-8?B?MEpEQkRSMlpxamYraWtiajRabHhvajM4dlk0RUtwRFdzZ2l6eTYyTlhzMFNa?=
 =?utf-8?B?ZmcvQnh4bDVjdGdXSDBPZFg4eUxTY041N01sS2p4NjhKZngwSGl3ZDFycU1q?=
 =?utf-8?B?SGZTMGw5UjYvM3lzVkRSMUtvajZ3M096M0lSdHhVK1pveGtuTDloSUhXYmxw?=
 =?utf-8?B?YmpmblBrQ2NCV1hwSlBkZnZaSUFPRmh0NHdCeTJmaFZ1cVNlMFJNOE5Pc0Zs?=
 =?utf-8?B?V0lUWUI5bzY1U0NvQi9DdCtTK0V2WU1pUGUxMkJOZEFiam1SNHhmb0tZVi94?=
 =?utf-8?B?RnNLc2RCYlVIaEJUUHRCM0hReHFtZXN0bWd2RGRlWGFDbUI3aG9UZCs2S09M?=
 =?utf-8?B?aWl2eVY5cFNvU3BQRC8zQVdxNFlNWUxCVXpDMEVZQy9wUzMzamNwNWxiK3J4?=
 =?utf-8?B?THFnblZYZkg2MHkxOSs1ZW54eUpnYzdqTlhSUGZiYTZBQnpaam5FNTJMc1h5?=
 =?utf-8?B?ZUoranIrSEtCNjFDUml0VVNOcW5paGV1WmhsVDNKNXE3cWJSS1F1S2s5bUFC?=
 =?utf-8?B?MmdFZXhuZlVUSytjcDBHQXhEVlZ5cjkzK0hyNDNaTklKMnZQb3M3Nndscmsv?=
 =?utf-8?B?YzM1dFNYNDJHcGEzZHZZNk03Vm41bERocDBGQU9uVGV6WEpjQko2OGtFcERt?=
 =?utf-8?B?b3RmeWZjckVOWU5aWGJ6b3plb0VycmtvQjN3TUFocHZpVkIzVW41ZnRkcy9O?=
 =?utf-8?B?Z283Z3FURGExeWdVVS9PY0syaTZyb2tVMllJcU1scE9tdy9HdnBDMUxITmxP?=
 =?utf-8?B?NGpXTDdZZytpNHlMWTF2bnpIdWFxZ2VQQTRlbFlmRnFpZzloK29yOUVtUncr?=
 =?utf-8?B?S3BVbThKd1E0RzRoUlp5azhia1FpMUtXWno0aU1sSm5pU0xnNTBYczR2ZHhn?=
 =?utf-8?Q?IFPcok?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UnZxREk3R1hTYTRLTWRaOXZXY1dzbmpIVTE1UXdNbThPVFdOQ1VHdXlZaU9o?=
 =?utf-8?B?MVpib0E2NXMwc2F3VGtINWU5cmVvcHYxR3ArRERjdkJlaW8xTWR2dVkwcEVt?=
 =?utf-8?B?czFKZHVoUmJya1JuZEs4aXl5dG9NSFpUcDh3MEhySC9tZ0ZEYTZmcVZLTU9z?=
 =?utf-8?B?SEFSVnNQNDNGYy9ocDBwR0VzUjdLWVdOM2JuUkwwVHBTWS9wYU5aSlArWVkz?=
 =?utf-8?B?dE84YXZkRmVpd2NsMTF0YTFnNlhxQUFjZEpBTFRDR2RwZERGZjFpWXYwczZC?=
 =?utf-8?B?ckg3WU56Y1NjSXE1eHNaTXpyVEQyQjZqNEdjOEVib3YvbklycGFmRnVsMHo1?=
 =?utf-8?B?Z2MvRlF0ZHYwZVk0VEllbDlzN2crdzZUQnJKVkpVcHJGa3N3TWZrVzhrN2VY?=
 =?utf-8?B?aTh5UnZ3T3hDbENvNXRaWERjcHJrK0tmYlZKVjFPZ2poajNUeHNCbUJLZENB?=
 =?utf-8?B?L3ZqdHpxa2xXQnVPb0Z6cys4ZTY2d2V2Q0hFU1NQYVlndmVGQldZa0pIcmJu?=
 =?utf-8?B?ODNPOWtxSXFneno5ZGVOOG4yUGdQTTA4MnlLbHVHMDdrS3NxZmg5U2ZlMEhI?=
 =?utf-8?B?RXdVYTVZRzdIT2h5V1NCeDhzYU54TC9BYmRScjZCczV6THJZSjBrcXcxb2k1?=
 =?utf-8?B?VGFsT3FyNFNhWVNQRWtMNFptMnBPbGJham9wV1BqR3J6TTFEcmJOSWFlUkVm?=
 =?utf-8?B?Wng1QkJoSmtXZVg2Nlc2ZHcxbmlTWmpLOE9JbkxrYUdPYnZZTXdYdTkxZ2RL?=
 =?utf-8?B?VVExNldhR2pGKzEwRGJSNjUyNDZLckZram9KZUczUGpzVTZQSzZ2dStSdXEw?=
 =?utf-8?B?WThyT2FmVGxCRitqUVYrdUpZczRwUGN5NWU3UHZ0SDFiZzBVRGNyenBNd0F6?=
 =?utf-8?B?aWd6dFNYY2lRWkl5UVN3Z2hqNjIzT0g1VkwzUVp3dWV2bTQ1eU1FcGloeDBZ?=
 =?utf-8?B?Y1ErbFdFcm9kSFd4N0gzRGorUkNwYVpZb0JNNjMxZUJTRnQxN1BPKys4a2pz?=
 =?utf-8?B?UU1lbUJNdGxEbzFaSVNyMG9Mc3kwRzdBdXZBRXhGZkRQWnhxaUZDbjlPNlRx?=
 =?utf-8?B?TzlpbnNyOEU5UVV4OUhUZThMWVJ3dVJocmJVYUFhVmhpUVA2MTluSzV5c05a?=
 =?utf-8?B?NEpYUDkraDYvVkZDUjB0bm8wS3RncFNneVU5YjQxUlpLM2JnYmc4cXlValVM?=
 =?utf-8?B?UlpwNmVzSGlsbzVYalRDMWhxbHo0WVUvSml0RlprL3kvRFlpN1V2ckpVblJq?=
 =?utf-8?B?UHFZTEc5S2l6aW5pY3VTZndoMk5Pa3hqUmtaM21leGtoajgxZktndlRrVVpT?=
 =?utf-8?B?VFB4TVQvcEtlVE9tdGdnUWxiMXU1UlJmRG5ZdFIxaDM5YnViZWdNQmZ0NUlz?=
 =?utf-8?B?R28wSGlvY09aWXE2d1JMam9mU2ptUWcrUWFWeUtwNEtYaWFJOFc5ZGZGcUxT?=
 =?utf-8?B?VkdjQzdaNzFwVzZPQVJEK0M4ZkxuamxsclF5andPSTJQR0tQYXRuYlV2UmdO?=
 =?utf-8?B?dEg0RHZQRWlRSEp2VmVtb3VpSDFjVjJURko4bEtJUkZpdGVpZ2tXQS9ENWp5?=
 =?utf-8?B?ZEtSZGdqaWRzWG9OcWJCakpMKzFoNk0raWdPUHh6SE0zK21iQ2ZIdHZocmhr?=
 =?utf-8?B?aDcySVVBMFYwQnZRazNBOUs5R0tvYVNPMWpxTEExcHBBRHlTSUxwdlg3NHBS?=
 =?utf-8?B?OVBhc2lrdDRWK1owbUFlSkp3ZnZKdG5nUHRwNk5lVDVLM1VnSndWVGVOWkVw?=
 =?utf-8?B?QjFkSlJjQWM1cTdCOTZRek1yZUlqeHV4K1lkWEhpN09ZL01ubk9KU0ZqMHVm?=
 =?utf-8?B?aGtveER4WmtBTVU3cFdWNFd4aGlySFdVNzNGNm96cCtQOHFyVkZab2pZWjUz?=
 =?utf-8?B?K0FKRUFRSHZ2RFlac0lTSjJ1YituWUFwWFkrRVZSZ3o2SUR0eU5xZUxObkpJ?=
 =?utf-8?B?WkVLY3h4RWxTdTZHNzllTytWc3BsdW1rdDdvNWFsZW5hMTZLa05OWDNnaUVH?=
 =?utf-8?B?RlU3TWRpdzR5bWxLOGY0RmZBaHZidk5zclB5TTRTaHJQaGsyM0Y4ckRJMzh2?=
 =?utf-8?B?M0NpNTY5SE9WZUFORTd4VnR3Nm1FcE92TDA1YjlmRGZmUFdpSmF0VHY5Y2dx?=
 =?utf-8?B?WnVqQzA4c2hka2V1NGt1dFhTd0pEa3NFUTE3VGcrRzdTejljMHFVNFBQZlE4?=
 =?utf-8?Q?CgL+BBmVI6mLDLus+TQ4DaE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84CE29E6563A204CB7E01854DBA37E48@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a96006-3de5-4caf-f13e-08de004e921f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 18:24:19.1946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +YlQbE/UIf6p+5EdIf3wZQQphMIb6AxtY8A2dAf5vxdrqKonSYTPyNay6G19y6mRHZP7dCZsOmGMA/CkK3Cw/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5660
X-Proofpoint-ORIG-GUID: FwwhXU2N-Ngjk2ZEhbRHoEcmoECtLWVO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfXzEnXRKr849MO
 qoj5Lfc84jmnqhybyhjD7jrrfnLp5lwraMm3ZLdrM+O0c+ey8RMQ9QxCz+4vRFSS2InoeOnZ/qx
 hb4Iu7xCKi/LQS8DBT8Vuy7Ps3dhn/yuan8s02TogJo6qqAN55XDAvvW9cJ2FnBrbHWkfY/neFv
 gWKTDDIrPoEC9k4I466qVyWcZBSBN9glO79UABOG5X733qkS/dXdbW4Ie/fcdrYcxykeVbQN41/
 kiCxtkbgsvkl6kfJkjG0d37cyB17R89un3fHD7DlYPtil/0qeehRhGFwwxgMAkJYlpNAV5WRjAT
 jX6LbTBxycr5mdw7iCXBmBjmF2COWmS8+jHGe3mL3hUKKcHqIeKTh1v7sw+FhYH6ElB4+dVSgOY
 OTiysF61jl86Kzyf2G8GSandfUS3Xw==
X-Proofpoint-GUID: bFOh2-ZjpJ8XaOHWYxYdSWScGo5VSB9I
X-Authority-Analysis: v=2.4 cv=T7qBjvKQ c=1 sm=1 tr=0 ts=68dc2056 cx=c_pps
 a=eGdyP8VkvOZnUY1FLHxo4w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=LM7KSAFEAAAA:8 a=lN1YcwaGv4G8IMDOPSUA:9 a=QEXdDO2ut3YA:10
Subject: Re:  [PATCH] ceph/006: test snapshot data integrity after punch hole
 operations
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 clxscore=1011 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

T24gVHVlLCAyMDI1LTA5LTMwIGF0IDE1OjU3ICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBBZGQg
dGVzdCB0byB2ZXJpZnkgdGhhdCBDZXBoIHNuYXBzaG90cyBwcmVzZXJ2ZSBvcmlnaW5hbCBmaWxl
IGRhdGENCj4gd2hlbiB0aGUgbGl2ZSBmaWxlIGlzIG1vZGlmaWVkIHdpdGggcHVuY2ggaG9sZSBv
cGVyYXRpb25zLiBUaGUgdGVzdA0KPiBjcmVhdGVzIGEgZmlsZSwgdGFrZXMgYSBzbmFwc2hvdCwg
cHVuY2hlcyBtdWx0aXBsZSBob2xlcyBpbiB0aGUNCj4gb3JpZ2luYWwgZmlsZSwgdGhlbiB2ZXJp
ZmllcyB0aGUgc25hcHNob3QgZGF0YSByZW1haW5zIHVuY2hhbmdlZC4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IGV0aGFud3UgPGV0aGFud3VAc3lub2xvZ3kuY29tPg0KPiAtLS0NCj4gIHRlc3RzL2Nl
cGgvMDA2ICAgICB8IDU4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCj4gIHRlc3RzL2NlcGgvMDA2Lm91dCB8ICAyICsrDQo+ICAyIGZpbGVzIGNoYW5nZWQs
IDYwIGluc2VydGlvbnMoKykNCj4gIGNyZWF0ZSBtb2RlIDEwMDc1NSB0ZXN0cy9jZXBoLzAwNg0K
PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRlc3RzL2NlcGgvMDA2Lm91dA0KPiANCj4gZGlmZiAtLWdp
dCBhL3Rlc3RzL2NlcGgvMDA2IGIvdGVzdHMvY2VwaC8wMDYNCj4gbmV3IGZpbGUgbW9kZSAxMDA3
NTUNCj4gaW5kZXggMDAwMDAwMDAuLjNmNGI0NTQ3DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIv
dGVzdHMvY2VwaC8wMDYNCj4gQEAgLTAsMCArMSw1OCBAQA0KPiArIyEvYmluL2Jhc2gNCj4gKyMg
U1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gKyMgQ29weXJpZ2h0IChDKSAyMDI1
IFN5bm9sb2d5IEFsbCBSaWdodHMgUmVzZXJ2ZWQuDQo+ICsjDQo+ICsjIEZTIFFBIFRlc3QgTm8u
IGNlcGgvMDA2DQo+ICsjDQo+ICsjIFRlc3QgdGhhdCBzbmFwc2hvdCBkYXRhIHJlbWFpbnMgaW50
YWN0IGFmdGVyIHB1bmNoIGhvbGUgb3BlcmF0aW9ucw0KPiArIyBvbiB0aGUgb3JpZ2luYWwgZmls
ZS4NCj4gKyMNCj4gKy4gLi9jb21tb24vcHJlYW1ibGUNCj4gK19iZWdpbl9mc3Rlc3QgYXV0byBx
dWljayBzbmFwc2hvdA0KPiArDQo+ICsuIGNvbW1vbi9maWx0ZXINCj4gKw0KPiArX3JlcXVpcmVf
dGVzdA0KPiArX3JlcXVpcmVfeGZzX2lvX2NvbW1hbmQgInB3cml0ZSINCj4gK19yZXF1aXJlX3hm
c19pb19jb21tYW5kICJmcHVuY2giDQo+ICtfZXhjbHVkZV90ZXN0X21vdW50X29wdGlvbiAidGVz
dF9kdW1teV9lbmNyeXB0aW9uIg0KPiArDQo+ICsjIFRPRE86IFVwZGF0ZSB3aXRoIGZpbmFsIGNv
bW1pdCBTSEEgd2hlbiBtZXJnZWQNCj4gK19maXhlZF9ieV9rZXJuZWxfY29tbWl0IDFiN2I0NzRi
M2E3OCBcDQo+ICsJImNlcGg6IGZpeCBzbmFwc2hvdCBjb250ZXh0IG1pc3NpbmcgaW4gY2VwaF96
ZXJvX3BhcnRpYWxfb2JqZWN0Ig0KPiArDQo+ICt3b3JrZGlyPSRURVNUX0RJUi90ZXN0LSRzZXEN
Cj4gK3NuYXBkaXI9JHdvcmtkaXIvLnNuYXAvc25hcDENCj4gK3JtZGlyICRzbmFwZGlyIDI+L2Rl
di9udWxsDQo+ICtybSAtcmYgJHdvcmtkaXINCj4gK21rZGlyICR3b3JrZGlyDQo+ICsNCj4gKyRY
RlNfSU9fUFJPRyAtZiAtYyAicHdyaXRlIC1TIDB4YWIgMCAxMDQ4NTc2IiAkd29ya2Rpci9mb28g
PiAvZGV2L251bGwNCj4gKw0KPiArbWtkaXIgJHNuYXBkaXINCj4gKw0KPiArb3JpZ2luYWxfbWQ1
PSQobWQ1c3VtICRzbmFwZGlyL2ZvbyB8IGN1dCAtZCcgJyAtZjEpDQo+ICsNCj4gKyMgUHVuY2gg
c2V2ZXJhbCBob2xlcyBvZiB2YXJpb3VzIHNpemVzIGF0IGRpZmZlcmVudCBvZmZzZXRzDQo+ICsk
WEZTX0lPX1BST0cgLWMgImZwdW5jaCAwIDQwOTYiICR3b3JrZGlyL2Zvbw0KPiArJFhGU19JT19Q
Uk9HIC1jICJmcHVuY2ggMTYzODQgODE5MiIgJHdvcmtkaXIvZm9vDQo+ICskWEZTX0lPX1BST0cg
LWMgImZwdW5jaCA2NTUzNiAxNjM4NCIgJHdvcmtkaXIvZm9vDQo+ICskWEZTX0lPX1BST0cgLWMg
ImZwdW5jaCAyNjIxNDQgMzI3NjgiICR3b3JrZGlyL2Zvbw0KPiArJFhGU19JT19QUk9HIC1jICJm
cHVuY2ggMTAyNDAwMCA0MDk2IiAkd29ya2Rpci9mb28NCj4gKw0KPiArIyBNYWtlIHN1cmUgd2Ug
ZG9uJ3QgcmVhZCBmcm9tIGNhY2hlDQo+ICtlY2hvIDMgPiAvcHJvYy9zeXMvdm0vZHJvcF9jYWNo
ZXMNCj4gKw0KPiArc25hcHNob3RfbWQ1PSQobWQ1c3VtICRzbmFwZGlyL2ZvbyB8IGN1dCAtZCcg
JyAtZjEpDQo+ICsNCj4gK2lmIFsgIiRvcmlnaW5hbF9tZDUiICE9ICIkc25hcHNob3RfbWQ1IiBd
OyB0aGVuDQo+ICsgICAgZWNobyAiRkFJTDogU25hcHNob3QgZGF0YSBjaGFuZ2VkIGFmdGVyIHB1
bmNoIGhvbGUgb3BlcmF0aW9ucyINCj4gKyAgICBlY2hvICJPcmlnaW5hbCBtZDVzdW06ICRvcmln
aW5hbF9tZDUiDQo+ICsgICAgZWNobyAiU25hcHNob3QgbWQ1c3VtOiAkc25hcHNob3RfbWQ1Ig0K
PiArZmkNCj4gKw0KPiArZWNobyAiU2lsZW5jZSBpcyBnb2xkZW4iDQo+ICsNCj4gKyMgc3VjY2Vz
cywgYWxsIGRvbmUNCj4gK3N0YXR1cz0wDQo+ICtleGl0DQo+IGRpZmYgLS1naXQgYS90ZXN0cy9j
ZXBoLzAwNi5vdXQgYi90ZXN0cy9jZXBoLzAwNi5vdXQNCj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQN
Cj4gaW5kZXggMDAwMDAwMDAuLjY3NWMxYjdjDQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdGVz
dHMvY2VwaC8wMDYub3V0DQo+IEBAIC0wLDAgKzEsMiBAQA0KPiArUUEgb3V0cHV0IGNyZWF0ZWQg
YnkgMDA2DQo+ICtTaWxlbmNlIGlzIGdvbGRlbg0KDQpPbmUgaWRlYSBoYXMgY3Jvc3NlZCBteSBt
aW5kLiBJIHRoaW5rIHdlIG5lZWQgdG8gY2hlY2sgc29tZWhvdyB0aGF0IHNuYXBzaG90cw0Kc3Vw
cG9ydCBoYXMgYmVlbiBlbmFibGVkLiBPdGhlcndpc2UsIEkgYmVsaWV2ZSB0aGF0IHRlc3Qgd2ls
bCBmYWlsLiBCdXQgaXQgd2lsbA0KYmUgYmV0dGVyIHRvIGluZm9ybSBhYm91dCBuZWNlc3NpdHkg
dG8gZW5hYmxlIHRoZSBzbmFwc2hvdHMgc3VwcG9ydC4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

