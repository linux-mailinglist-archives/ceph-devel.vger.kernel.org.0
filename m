Return-Path: <ceph-devel+bounces-3489-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38F54B3AA6E
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 20:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB678206594
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 18:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 575B830F552;
	Thu, 28 Aug 2025 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dOqW9DUF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF4E2C11F3
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 18:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756407306; cv=fail; b=CQsF39DldN6hLpZiW0Wz4a0GxdbnWiCR4vJrugQlyTCnFmAh67ADIvW5WD0JP0RPMT+YD74t7cYXE2dZIYe9uCiNfUyP61oNX99Ed3UuJosv35A6UD6naX7A0Fx/dXqrBe8JEWV8aHcjGN59vd2h0aGXwfa65mCQJyxmKZTxUXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756407306; c=relaxed/simple;
	bh=42erA6bKjs54gZRbDWxM8D03tlXVPb8lWL1tMIAJL/8=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=BQkj3yvpASixuGV/5PIhYrwV1gpNCzEZ9YP+SV4tGlBZUTh9uum/kTE0tKA9Dym8HfyNfo4kk6IGuIba2kquFg+LwzXyJhl353RSO184JM4H7rnC6I4tzyTO2+3DNSyy+MJqezsiPVCQwQpZI1Osly8wcHp6lbnWRo8NPtDVVlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dOqW9DUF; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SFY6MS013197
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 18:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=4pWRZlWBcFMgfKIscOTOs7jKsfp3BgLwxOfdUvooPTI=; b=dOqW9DUF
	wmw6DB46U6sgqMkRsVzgZCifAYfNj3RC6bZEE5NOt3Cy8rA0xfivICSU0uFB7SLc
	IDa/eWb4qrmnlsCr47+3Zm6vYZKcgmkhdnpcQ03QQEg8992RkU/Mf0UbEpdKg7bG
	UhMzsd3TYtjDjXQ9NQk9dj/pC6zeQ69eO11+uO0nUBsNoU6e0iNM/tcYxPn3OfVc
	dgZ/KgkdoyMr/yLiPVMSKSvbazVDTnNTkPqCRnSQxRAYnzXw9l6qd7knTe/OGDfe
	UNvepiHlTKLSu157bMoidxraSXB+0WWv+/1xzInsuBsqkJhWKS99H0khkTOix53G
	lqp6FdynUt42mw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48tsv990fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 18:55:03 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57SIrwnH013494
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 18:55:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48tsv990fh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Aug 2025 18:55:02 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57SIt2gD017272;
	Thu, 28 Aug 2025 18:55:02 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48tsv990fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Aug 2025 18:55:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BYHXGT6fVPCKbbK9dXkXmvBTL78n/5c13XhgJXxxoT1pYZQfRy31DnV2YqIVMc5gwc2YWw8dJXaoAT4P+kcGskpG5NeMad1k3sWSLwrVMHlYtnhrBX2/kGeukzqgiCFqNz6onZ0e4Dq4WFc0mjVdMRcy2I0JpzAl7+fBq1C8wVv8/6bGOQocJFQTw3Q3OQcxudNCE+eAds0aVWUSWUJwR2HBDyzZEmJxmd6gi6oOeEfjOx9LrynaxoYdL0ShvmoCrHGbZXiTQ9MhvpCkADvZ73/9FVOoeyI0EA9cEAguDlIHXAEnh+OFZH6/UWQcQZP8/yIG9lxqeKv7mJQ4Tp1tRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbmtheUlaXDxFidqF7T4DNAc9wexDrebb4B4lVL+Z94=;
 b=m+ABpx1LUEIyuNa8ulFirRSA2x83iQuinY/OW6GmeO37raUkEVxcPupu4DGWRZgoQB/4XJb/+7dEqOwmJ2F0N2OonInw3EUJyRA4AF+DeY0/rwbMwgpoBZ7sD64oAwNk9uyMzz7JgSYQxK5DwT/SO4kOpXUM86xsLaDNA7qdeo1OFwAp8DuoqXgBd4WgjX3qQuM10wP0QXNV6zFbE/uMQg/Poh6lotbcZCemzMnXiVi3z07MR5aTx3MzI1E6cHOSJKvcJaA1DkrR+WwUD1lw0tvnsMsWw7TYlzgtp4ip5aLRJd9d38Kl6WbloelDgtbv31UQ4OmxuAvAaQYq6PahzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CH3PR15MB6237.namprd15.prod.outlook.com (2603:10b6:610:15d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 18:54:55 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9031.023; Thu, 28 Aug 2025
 18:54:55 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "max.kellermann@ionos.com" <max.kellermann@ionos.com>,
        Xiubo Li
	<xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Markuze
	<amarkuze@redhat.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] fs/ceph/addr: always call
 ceph_shift_unused_folios_left()
Thread-Index: AQHcF37TjyxHalgGV0mBo181XsScDbR4a30A
Date: Thu, 28 Aug 2025 18:54:55 +0000
Message-ID: <791306ab6884aa732c58ccabd9b89e3fd92d2cb0.camel@ibm.com>
References: <20250827181708.314248-1-max.kellermann@ionos.com>
In-Reply-To: <20250827181708.314248-1-max.kellermann@ionos.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CH3PR15MB6237:EE_
x-ms-office365-filtering-correlation-id: 031be215-73f8-436e-0df5-08dde66460fa
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NTcvVG1VRUZDWUFUZDhhRGNOQUNCTnpXS3BXNXpjSVNlSndWZ3VDMXVic3dL?=
 =?utf-8?B?UlJobnR2UUZJVzhJa2g0SE5va01yUWkwaU4rdmV6K0EvOEdpaFZoeHY3cVBO?=
 =?utf-8?B?RlJLNlhlZXV0eFkzdVRiVGptSzkwWDlYN01LT20yMDg4UWwyTmIzclVrbEtF?=
 =?utf-8?B?ZlZoNHhtMUpPNGRZVFYveEJPYmpMcXFIOVpTU0NTT2pVOG5uOWJ6cFNtV2I0?=
 =?utf-8?B?aU9JdXpGeCt2UUdGNytnWHVkNUZNTlR2YU5PU3FCQTZ4czlwK0FWVWQwY0Jk?=
 =?utf-8?B?b1EyczRIWjJ2YUo2Qk1LRTZOQ3VVVkZNREo0eVJaRmZvZDVJMEkrc3RiQ3NN?=
 =?utf-8?B?c0UyYzRqTjJLVWRsWUsrTUxJZ3BiYnBFenF1cDZGNTlhREV4UisycmNmbTVw?=
 =?utf-8?B?NStDaXA3RVpqZkN4R3hCMjhpR1gvenlpN1JHV1lvWTh4RTFMaW9wRGJocUFz?=
 =?utf-8?B?L0R4V1N4Q2ZZdXFOSUhCODhyOWkwNDZMa3dNdFJ1NHFHd01MblBGcmozTlp1?=
 =?utf-8?B?b2Zmejc4RUpBM3dWcWNxc3Z2bTZBUzdOd09CM0lPOS9DaWN4NTBZTUg3Y2pz?=
 =?utf-8?B?M1kzNThMdkNYL2tGR2kxazlmOU5SOWxJRyt3dUVWYmZQbm5Sa3EvVVRjU1lL?=
 =?utf-8?B?cHRkcENvV3JEZm0rUFQvZ1FMbHJmRldiclUwZjR0dFhYRWpLV0pkN05QdGxj?=
 =?utf-8?B?OUNPRE9KN0tqaEJCSE5GZ0pyQ05sV2tWNUZVSEpVQ1FWZ3VCeU82YVdkaWZO?=
 =?utf-8?B?N1F5K3hoRU5RcW9vYkN4amgwQUJTaFhoN292cldoUjhyN3lEUmNEeWVuOUJv?=
 =?utf-8?B?cTJmWEg1U0k4WWIzbklYc0FZMVlLbWVTb2h6ZDV3WmNGOGZ0cmJnY0VvaStN?=
 =?utf-8?B?UUFVL1VreXJUTW54cDNPQlUyYTIyUGhlTGJzQ3hiWjRUNUxoYnVXZzRLN0dB?=
 =?utf-8?B?bzZZTUJmNEUyNzk4VFkzZ2hnWmNFSjRoRUkvTGdtZkovMEpoVk0wdUZaYjNW?=
 =?utf-8?B?U1dzWXpJNmFVVWNndWk1dGNGNDdGcnR4aFZUclViRzBrSmJVQTBWUVFSbW9l?=
 =?utf-8?B?NXV0U1ozMU9XWndpektiV25PcnlZMldMVUFjeWVRbXhmWGVtcjZIdXhZQ0xP?=
 =?utf-8?B?QWx3RXgzVHlURWlTNnZkd0VGL1RKNXgxY1ZxY1plaTJ3WXV6K0RIUmtSL1N0?=
 =?utf-8?B?eHRVVEZ0cFlhTUp0ZEh5RzAweS80dnJPSVRwQlRHSVc3NnU5dGE2YmZZZVBB?=
 =?utf-8?B?V0MvR1ZOSnFyTXNWa09oV25yaC8zSFd2YnJqR2U2ZmZYb1E1V0xoL3U5SEpz?=
 =?utf-8?B?anIrbzZDcFV2MjdEaWFzbGRNSTdnUll3cjRJRHkybUpDZW1MZjUyT1lTclNK?=
 =?utf-8?B?M1g4eDRiWVZnVDlvL25NOXFOMUl6K2E2SDJpZGFKM0FVOW81RUpsd0J0emQy?=
 =?utf-8?B?MkRLdWhrdlI2U0FCMGtUUlJ3bURPdkNnRFVaUkFtUkM5d1cwMlJCVDNHcVNt?=
 =?utf-8?B?c0dJbWtpOUZrN21aQzhzMXRyTFF1aFRQdDlEdEVyY0JEdmhiWk5lWW14ZzIy?=
 =?utf-8?B?ekVmaWZuSjkwaCtTKytGS2xuOThCODIzMUZWRTBQUGJTR2ZlMnJIMUF2c2Ux?=
 =?utf-8?B?TEV1NHhRRXduWjN5Wmt2ekE2WUNMVW1FeGxNNkVkRnh6OVJDdzF2QisvTktt?=
 =?utf-8?B?YTJZdlBBZ1lhd0dWenp3dURkUXNDbCtPTUtDemlROGw0bFN2a1ZOOVlUckc0?=
 =?utf-8?B?dm5PNE9EbDdIMzh0VzNtajJuMHBIeEdPRkNKRE9Md3BWbE5ycjhTLzZ4MldO?=
 =?utf-8?B?b1pOQUNheXdzM3BkNW1nZDQvbnlkaEJDNFBSaFFtbUJiVllRaGlneGxyL21X?=
 =?utf-8?B?bnRoSE9jU2dyRGZDNnZlbk9mTjFsRHcyVkQ2RUEvSkhMVEwxbGxWSSsrUVpl?=
 =?utf-8?B?MDgzNHh6N0xjMzNZd2J6dTF2eTBPL200QlJhVHYvNjVqdHNjYXdTVFgxbnZF?=
 =?utf-8?Q?k3Bzb2T+cRY1vL50bDx7vDHCX68P+E=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T1lEVW5mOVM5OW1LL1NvZHRYeUhaMUw1UW40blg1Znp6TWM4WTRWeVEwbXJM?=
 =?utf-8?B?T292NndMUEhaMDRpdnFqVHFlajRwNUJqOXg5TnQvTnFMUmxXRmN4dU5JR2Nt?=
 =?utf-8?B?Y2Z6S3UwdTdTaTBzUFdoOVc4NFhXMTVJVE12emhDalc0YXVyUHE1U0pGejdS?=
 =?utf-8?B?ckROV2Y0K21yM1lOSVF6YUhHNmlQRWtCeWYrUW5xNEtwL2JYSG9pc0JvTnR3?=
 =?utf-8?B?b2xGbDhPQVpDcHVMb0FDekVvbUMxbmV0YUova2pEY2t3aWh3ZG0zdXd3ekJq?=
 =?utf-8?B?YmlpeUJCVlMwYlkzQ0VDTm1ZalpsaE5maFpHVWhsZzluNE1GNGluOVcyL1Zx?=
 =?utf-8?B?TFVDQVBzZFZGU0NxT25TaEkzVCs2a0tGR0ZIWkg4Z3JQd0hSY2dCcUlKaE1W?=
 =?utf-8?B?bFB4OXc2OGpuS1ZRNXBWQ3VwdXUvaG9DN0d0OFFvcjk5OFhJaUVuSVBRQjlo?=
 =?utf-8?B?R29TcmNwVU0vZVBIQzg1L3VMS21SSFJFQUh5d25GbEdPK1pRVTdSVVkwZlpE?=
 =?utf-8?B?bm5JcFlmZFg2bTRWUGxnU050R01VaTRkVkQ3N2FndHlkK3hTRzlzWUpFc2h5?=
 =?utf-8?B?TWdEcnhkcnJkdVpsUHRqQjhzTzJxTkdwUHZ4bHNjMXFTQlNQNmtlTU5udm8v?=
 =?utf-8?B?Mllac25zbXZ1VjMwbWlidlZRQ2tXTnhrL0VINExuUG9zUE85V1BMQUZUZ1NT?=
 =?utf-8?B?Y09hU3QrMEpvRTZsWTdqNFpIblovQThyZC9GY3FmTkluTiszN0dXOTUvaENt?=
 =?utf-8?B?WklEVHJ0WGk4K0lIMitkampwM2tYaGVEVUFuZ1VPSnBra1BMQmZWekRoajRq?=
 =?utf-8?B?VDZIUjBhakVlc0UxcXp3UTZORW0yVmZROUtEZDNsVUVXbkU5Uk5FSjhFclNZ?=
 =?utf-8?B?U3RVdzM4VzBKa2x5eE5Sd2VDM0VMQyt1Z0hWTElSN0x5VTVra2tVZzU1RHJU?=
 =?utf-8?B?OTJEdXhzbjgwc3lmVGtJVkRLNE9FeFZGWDlsYjVvbTRTekhMZzE0RDBabkVl?=
 =?utf-8?B?RU1qaTFZVXJGVGNwL0k4a2V6NU1aR2ZqRDVaWUlqTEdqMGJOWGxZRGlhbWRi?=
 =?utf-8?B?ekw5RVk4L2YxTk1nd3pWelVjQXR6Z2FTZjRkS2xlTHJQb2ZSREgza3N1RXBC?=
 =?utf-8?B?SVJqcTlMdStGZUpBV2Fka2czNWZGSDhKci81dmZZREVBS3ZBa1JGaHhCNjRR?=
 =?utf-8?B?WHJHSElkTmo3a3B5WHFJZGdoTkliZmk1bUxrRnRheSs5SVJHMURQV1gxb3gx?=
 =?utf-8?B?RlJ4alRzWklWcWkrTmxudDlESklUMHloWTdPQW95dVI3ZWZpRDhBOGp2TGFY?=
 =?utf-8?B?amhzeXFIVjNMOTMyMFVXUjl1RkJZaGhoS2FkNUtWRGoxcmR6WXVXWHc3UTdL?=
 =?utf-8?B?Q3RVTDRINW5uS2lHQjBuT1dYMUxuM0dNWjBvU2RJY3E2Z3Q3MU1EVlFNak1K?=
 =?utf-8?B?TUdNM1VIN05vclhoVFo5SVlOb0tWUnVPbUhvTE5EVEROZ3V2bmNuN2xWaE1t?=
 =?utf-8?B?dTdPWGtObGZkWVVxYitrZ1o0TW5iYnJEUlNscE5SOG1jeUZYb0ljVFpGeDMv?=
 =?utf-8?B?SFJPMCtLU203VVBqeXFLZnkyazB3VmZNNE5CZ0ZzWXdOOFVWR1VwcC9PTk5s?=
 =?utf-8?B?dGpORW1LTXBlR29PY0grTG9NLzRVRUZXczU4WWlxYUxNU1RiZGQ1QVlIMTZO?=
 =?utf-8?B?TURPSHpteEVKVjhna3J2UE9wNHdrRnV1MC9GV3hsWG51M202STdGR0ljR0VK?=
 =?utf-8?B?MFJ5RFN2eVBTcmhRZTRlKyswejQwMFNjK1l0TE1aZUFoWmZEVk9IQ1lyWXNH?=
 =?utf-8?B?VzdrdmxBeDdweXJvcURYVzdxdkpOUExYR2llcjlGZThJNEtvQ0lmNk1HTUxX?=
 =?utf-8?B?bHdpZTJhYjFUQU1GYzVVUnV4eEhVNmZrUlNMbmpwUGd6WGovMXUvNTkrak94?=
 =?utf-8?B?c053K0V3d0VzNUlzaFFUbFMrSWRkaTc0RjkxQUkyR21mZVNkTno5UlVrU2ha?=
 =?utf-8?B?K3hvZjJpUU4xMFZTZDM2Mkx3aldVVlplR1dKaEk2aDBnOW1NRTlyVzQvTURs?=
 =?utf-8?B?MGZ4RFdpTEZ2TTNTTUpjMVBJQWM5alJscC84dy93N3N3alVUN1BhMVhBNURy?=
 =?utf-8?B?U2FadVcyT21nVmlkZVM0OXl5YWlYNytMZURFemxOWitwTXhVci9tRUVESEdy?=
 =?utf-8?Q?q8atS2uxc9VdQ7eEcw5YIT0=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 031be215-73f8-436e-0df5-08dde66460fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 18:54:55.4067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4tbDnO14cUVlJiXWafrP190UErF9fZA4g90efnyFWzMpHIFIPzR52d02L+Gj61iT49oa7AfrcMzfnlckRYLtng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB6237
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI4MDEyNyBTYWx0ZWRfX5AGZjBWRL/y1
 yTsdQC2TnJAzhzhEnMUQSxm9DJ6b8M+l/p29l41rtCni9V1KgCzBSK8zqgbvF+8MAdPwkeQIj9E
 UHEvsC4OWO30BO1Do1eIQgSSYtYP54kQ+chFwBhexwz77X4Wmj4ztZs4xsVQi5o1oLUEcsdmdWp
 ohRL3t0I9BnpeH3HrfN7kagL4tsILGG9i9065pO32+qCtGnArwtlpu3ouRZSOiBytiW+wqHqCxx
 mrkcInsJYdgLF0k1fSisJB75qgKJtE4Wq5ENt75V9A3nlpkeWzCri6bfOhhBIcapCgy7Lm8Doyc
 FknWwdSubXMw0cp+4Fghqow4gm7j7Yx2uL3fccMx1MTxBl8B0IVRCN2u29YecLcprDxrGk6qvmB
 2a8VmhzH
X-Authority-Analysis: v=2.4 cv=GqtC+l1C c=1 sm=1 tr=0 ts=68b0a607 cx=c_pps
 a=pQ+KsM6LmSH6jegO19AYIQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=UgJECxHJAAAA:8 a=ev65FxswufqXk3zQTs4A:9
 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-GUID: nTyAlkpsf_Pc4t6TGHXos1MHLd4qVkXy
X-Proofpoint-ORIG-GUID: 8agW1wONoG_Jzi7CYnIBlc41A2dHjO2o
Content-Type: text/plain; charset="utf-8"
Content-ID: <434070AF36F92644B299F923A53EC35B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH] fs/ceph/addr: always call
 ceph_shift_unused_folios_left()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2507300000 definitions=main-2508280127

On Wed, 2025-08-27 at 20:17 +0200, Max Kellermann wrote:
> The function ceph_process_folio_batch() sets folio_batch entries to
> NULL, which is an illegal state.  Before folio_batch_release() crashes
> due to this API violation, the function
> ceph_shift_unused_folios_left() is supposed to remove those NULLs from
> the array.
>=20
> However, since commit ce80b76dd327 ("ceph: introduce
> ceph_process_folio_batch() method"), this shifting doesn't happen
> anymore because the "for" loop got moved to
> ceph_process_folio_batch(), and now the `i` variable that remains in
> ceph_writepages_start() doesn't get incremented anymore, making the
> shifting effectively unreachable much of the time.
>=20
> Later, commit 1551ec61dc55 ("ceph: introduce ceph_submit_write()
> method") added more preconditions for doing the shift, replacing the
> `i` check (with something that is still just as broken):
>=20
> - if ceph_process_folio_batch() fails, shifting never happens
>=20
> - if ceph_move_dirty_page_in_page_array() was never called (because
>   ceph_process_folio_batch() has returned early for some of various
>   reasons), shifting never happens
>=20
> - if `processed_in_fbatch` is zero (because ceph_process_folio_batch()
>   has returned early for some of the reasons mentioned above or
>   because ceph_move_dirty_page_in_page_array() has failed), shifting
>   never happens
>=20
> Since those two commits, any problem in ceph_process_folio_batch()
> could crash the kernel, e.g. this way:
>=20
>  BUG: kernel NULL pointer dereference, address: 0000000000000034
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  PGD 0 P4D 0
>  Oops: Oops: 0002 [#1] SMP NOPTI
>  CPU: 172 UID: 0 PID: 2342707 Comm: kworker/u778:8 Not tainted 6.15.10-cm=
4all1-es #714 NONE
>  Hardware name: Dell Inc. PowerEdge R7615/0G9DHV, BIOS 1.6.10 12/08/2023
>  Workqueue: writeback wb_workfn (flush-ceph-1)
>  RIP: 0010:folios_put_refs+0x85/0x140
>  Code: 83 c5 01 39 e8 7e 76 48 63 c5 49 8b 5c c4 08 b8 01 00 00 00 4d 85 =
ed 74 05 41 8b 44 ad 00 48 8b 15 b0 >
>  RSP: 0018:ffffb880af8db778 EFLAGS: 00010207
>  RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000003
>  RDX: ffffe377cc3b0000 RSI: 0000000000000000 RDI: ffffb880af8db8c0
>  RBP: 0000000000000000 R08: 000000000000007d R09: 000000000102b86f
>  R10: 0000000000000001 R11: 00000000000000ac R12: ffffb880af8db8c0
>  R13: 0000000000000000 R14: 0000000000000000 R15: ffff9bd262c97000
>  FS:  0000000000000000(0000) GS:ffff9c8efc303000(0000) knlGS:000000000000=
0000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000034 CR3: 0000000160958004 CR4: 0000000000770ef0
>  PKRU: 55555554
>  Call Trace:
>   <TASK>
>   ceph_writepages_start+0xeb9/0x1410
>=20
> The crash can be reproduced easily by changing the
> ceph_check_page_before_write() return value to `-E2BIG`.
>=20

I cannot reproduce the crash/issue. If ceph_check_page_before_write() retur=
ns
`-E2BIG`, then nothing happens. There is no crush and no write operations c=
ould
be processed by file system driver anymore. So, it doesn't look like recipe=
 to
reproduce the issue. I cannot confirm that the patch fixes the issue without
clear way to reproduce the issue.

Could you please provide more clear explanation of the issue reproduction p=
ath?

Thanks,
Slava.


> (Interestingly, the crash happens only if `huge_zero_folio` has
> already been allocated; without `huge_zero_folio`,
> is_huge_zero_folio(NULL) returns true and folios_put_refs() skips NULL
> entries instead of dereferencing them.  That makes reproducing the bug
> somewhat unreliable.  See
> https://lore.kernel.org/20250826231626.218675-1-max.kellermann@ionos.com =
=20
> for a discussion of this detail.)
>=20
> My suggestion is to move the ceph_shift_unused_folios_left() to right
> after ceph_process_folio_batch() to ensure it always gets called to
> fix up the illegal folio_batch state.
>=20
> Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
> Link: https://lore.kernel.org/ceph-devel/aK4v548CId5GIKG1@swift.blarg.de/=
 =20
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  fs/ceph/addr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 8b202d789e93..8bc66b45dade 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1687,6 +1687,7 @@ static int ceph_writepages_start(struct address_spa=
ce *mapping,
> =20
>  process_folio_batch:
>  		rc =3D ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
> +		ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
>  		if (rc)
>  			goto release_folios;
> =20
> @@ -1695,8 +1696,6 @@ static int ceph_writepages_start(struct address_spa=
ce *mapping,
>  			goto release_folios;
> =20
>  		if (ceph_wbc.processed_in_fbatch) {
> -			ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
> -
>  			if (folio_batch_count(&ceph_wbc.fbatch) =3D=3D 0 &&
>  			    ceph_wbc.locked_pages < ceph_wbc.max_pages) {
>  				doutc(cl, "reached end fbatch, trying for more\n");

