Return-Path: <ceph-devel+bounces-1271-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEBC38FF16B
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 17:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12823B2BC4F
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 15:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8AE5197541;
	Thu,  6 Jun 2024 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="B3oCsUw9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2117.outbound.protection.outlook.com [40.107.14.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C648197533;
	Thu,  6 Jun 2024 15:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.14.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688572; cv=fail; b=Bu5nmLNsMg8n52FBP3WMtqVcErq5AC9ZD0HOVyiiCj4r2dkVVOQPRR9HxsbBc9C4ReFvRTX2hy8+DdWeGwIucpka8VfocRbPkrZ/JNCw1wzpCOMOEKL806xE2lW4hvvlaCruc86yGrge446FT7Ya7+JHUhmld4oQY4v7VKeYcHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688572; c=relaxed/simple;
	bh=dZWjvD0EamzuloqDXZL5XoDwsuwkNsHbW9ux+cJao0w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qJtIsusF2dWlS8hKlKOd7BL5GoXC+wLl8GreKliXU4XmFplnTd+2+iTQiW7R0f6O81uABH5Skf78yKnnc45ecHc8ClY9pZBaPRN6RNyXhmjt2H4Q0kAXTQldx/LEvq1keDaCYQ8/k4TuMj+w1aly4LZdlvGpdALxL32owuJbUyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=B3oCsUw9; arc=fail smtp.client-ip=40.107.14.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsGEyA4fvZPD2doPMtHMYxqaRVBh4wNA6Jw8Y1QT/q1QRcZSYVeAJjLXwq8oQrUMqmGAKn2LsJDLZBAbdpeBmwnN+Tvp2vJVHihXHTLfPjfOzFrjN7ZHylVCzar/tJgXK+JNO5TOS+OvzLYG6HXG4i0KvpoR/8hG5p+3wSs6WAIIt9cW7mkgoOC0UYaJH6rZzVZtgWsG4VtPbGfftZSGbDL8fcNK4Ru50X724M0iMGP7ZXzfE7PzYaAC4q3TQ210Z1XruS3WHFDDomycOnL8zx8NoQXvTLiZImiZFn8/8q6InwSBFjXh3OPvZN6fK16LH7nCcSFKnaPlxocF3r6D7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NISSnZkWYXZnRsZUzb8tGRoApSSHibf0rQgTbQU4WMQ=;
 b=BY1/zot9463hNn1v9MEJ3HZbwYQdv3jTTB2nBzgLV1KG8kCGeG7mMCOWHAf7boDH1OwZtCJduXgvYJar5gThOR+ZmXwKhFRxsne7x6uJr+HiPQNzodJIlnOfpjSw3kpfCDZAvRasdRT5YN1mMQ5scxIJUEvfwhqzvDJmbL5sC4iEGvqTtv3SnxvDFTBQw5fHuB1T1in9vVs0I6aDwiaAzs3nbj4fy6t0ZiXiMU4KTE8+nfdO190bZxEGPNPAjwvQSLtPmtb0eSOMqoyq+dC5BXfiHCdJ3CN+lMdGltHjSzJlYlSKodmV+mqnAOGyTNnhnr6XzTJkU8NL8bVEm4mLow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NISSnZkWYXZnRsZUzb8tGRoApSSHibf0rQgTbQU4WMQ=;
 b=B3oCsUw9w1blm8OZVgVzVyd0ENLnup4OZ4G/t75bOEuJuBIgSYDKDQLiE5PiFd4lH2400wGv2z7D3a2p9VYOCOXweZu4FX1AWy3l0Cq3in2ktl08Z1DnhG6npmc1bJEFsUbOR3MMtumrPssKtHFShdWNb4yMrn0ogyfSNDe4BoNtPt0eFY+fv5NIyu4xGjE3Hz3Yq3M7I0VK1CXjazoeilbHJLTb7WFlrPRqoUBkZZiv5bus0pWRjCid2sD++MKbsvBfosCwIJu/qkjTFySExz31EJvNJlEs+ZXc2/UpFlwI0ACtO2qyX78Ch3tyGSCfa4HP8VqF0DV2stfVQ7TnlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by AS4PR04MB9458.eurprd04.prod.outlook.com (2603:10a6:20b:4ea::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Thu, 6 Jun
 2024 15:42:46 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 15:42:46 +0000
Message-ID: <a854c7e0-543a-4eff-96e8-b0ac009fd182@volumez.com>
Date: Thu, 6 Jun 2024 18:42:43 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com,
 edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-2-ofir.gal@volumez.com>
 <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me>
 <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com>
 <86e60615-9286-4c9c-bffc-72304bd3cc1f@grimberg.me>
 <20240604042738.GA28853@lst.de>
 <62c2b8cd-ce6a-4e13-a58c-a6b30a0dcf17@grimberg.me>
 <ef7ea4a8-c0e4-4fd9-9abb-42ae95090fc8@grimberg.me>
 <b13305d7-35c8-432e-bea1-616410a9da15@volumez.com>
 <20240606130832.GA5925@lst.de>
 <ace6e7a9-3a77-43eb-ad86-83eabc42cdb4@volumez.com>
 <20240606135233.GA8879@lst.de>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <20240606135233.GA8879@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::20) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|AS4PR04MB9458:EE_
X-MS-Office365-Filtering-Correlation-Id: 9790d9bb-748f-4041-75f1-08dc863f501b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGF3Q2RLSXlDaC91U3QrRDR3Y1JxSmljaC9nbXNQMjdyVjFJanc5Wi92TC9x?=
 =?utf-8?B?a2cyS1kxdWEwLzFKWUd6U2g0NzJwK0JvdlNidWNkbkdYaTlZOGxJU1VBQjRK?=
 =?utf-8?B?aUYrbUpSRUppd3VhL1gvNVpoRkhiVUl0Q29XRG5TQkg2KzFzeFBHMHdjTG1t?=
 =?utf-8?B?Q0tLUys3Qmk5YlBxWE80eTJ3ek9MWWUvaWppSk11RHpJUElNUTBoZEhsUzlL?=
 =?utf-8?B?VUxPTU1sRE45TThpcS9ud2hsb3luQXZ3UldYdWZvYXNBdnpwSWtqdElITHlC?=
 =?utf-8?B?M0trRTdMd0FpeHRVVW9ob1JuNHBvOVd2V3pDM3IxUXphamhUT1VMWW50TW9t?=
 =?utf-8?B?RFMzUFE2MGMvVVY2cDBCcDJQYWRBR2dkSmZWUXlyZnplUmdtOXR2MGhIazVs?=
 =?utf-8?B?bFE4SUxyN0M5cnljMStDZFlOSGxzRG1udHk0aTU4dGRjU0w5OTFBZERxUm9G?=
 =?utf-8?B?SmxvYUptdkRWM0VhZWdodlJJVFhDa0xoKzRHek1UWXEwSVdQWTUyVEJHRXB0?=
 =?utf-8?B?Y0Z3bWdFSndGTVFaZGJsSDQ2TEY5UGxRQVVzbSt6WlFYS05TYlRMUm04VGQ4?=
 =?utf-8?B?QTVPLy9lRU1Rb1dlMExMRXBVNDFmdmNBdlJRTDdMRFVBSm5jZ2pQRW1YWjBt?=
 =?utf-8?B?Q0Zhb0l6Tm85UzlQQmNlR2s0NjRGVHBUam42MVZWbkxZVVNPZEcrQm44emRp?=
 =?utf-8?B?MlVDc0hOdS85aWd0N0ZQbGtKQ3EweEkvd3ZVbUUvRFZJbXpHZnJZTklhYnR3?=
 =?utf-8?B?RW9TUUJIZ1g5NndjNHV0dWZvTTZJdHBXVWllQmJsNHlsbTRJd3l2c2doSUd4?=
 =?utf-8?B?c09zZHo3WnlRSDg1ZHE0SFpYUjA2ZHEvZmpIOHJGVTJlazg3NlNvVXJTam4y?=
 =?utf-8?B?UlE1NDdRQVJtUFc2N1JzNVJBalFGU1dPVGo5cFA0VDJqTDZiSEZBT1hwZWVD?=
 =?utf-8?B?c0V2TGhqWnlVdUxFNS9MNzBGQmFJT2pxTVBDVzRBRTdERzBGbnh4M2g2dURT?=
 =?utf-8?B?TXR5MmxJekpybS9nREJqV2w0RkZmWmdSWjVTVnFSRW13NHAwZkVUakt3R29z?=
 =?utf-8?B?U3BmWmN3QUM5cWxpOVhzNi9BeVBicmhaTnIzL0pqZER0MFJ6L2FRZlNWelJR?=
 =?utf-8?B?WkhwNjdOaUI1WDVsanVFQ1duVkFPRmk5L3VlRlVXN3c3MkFYVDR3ODZGZUxZ?=
 =?utf-8?B?a0N1bnFBUUlLUkNUd1JSTThnT1VvN01UL1pxNS9IYVl2dVRjdzZiMDZvMkha?=
 =?utf-8?B?ci9mT050dmtqQjhSMXR6T3o2SHcxSTZHUnpNT1RWeU5Kd2VLcmowR2FvK2dh?=
 =?utf-8?B?QWtZNSt2TDVza2hiU1dGK2ZYUEJnTTBOcCtXZjloUldjUXpzdS9wTEZrOXlm?=
 =?utf-8?B?TldoZUlrYkZZcjVSNzBkekF3am9zV0RVQnZrcFpqUWN0TjU2cXMra0RDTGpR?=
 =?utf-8?B?dnB1OU40emx3bWtyQXIrNVRCVkxCMURhRGl5cEg1Y0lOd2lQN1cxbVFrSzlW?=
 =?utf-8?B?Q2dZdHBFVTdPcDVFbTB2cEJvTStlYUNWdk8vaWRBcFV6VFlQZHgrMDcrZ2ZI?=
 =?utf-8?B?cGpsY2xQUHRSNVFtQmlFVmM3aVdYVSs2ZVNlSUEyNXRpVndhY0VNZWlQQmNU?=
 =?utf-8?B?aHVpZThTTHNDRE9JV0VQeVd5eURyUVo1WjdKY2QwcEk4U0h2OWlNRXNzQ085?=
 =?utf-8?B?cFVjQWd1MElVNkJZTndRNlV4WmZQcUdpcTdyV2RzL3NBTlM5YmxXZmlDYzc2?=
 =?utf-8?Q?vBvtOwm9B9VHT+T14p6GYm9D7gRhyN0XISip8LQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzFSd1pZOHBXQk1EM2xJcTdFcER5djVDcGRVeG5Rbkk4NFFBRHFTd3NTWGNM?=
 =?utf-8?B?ZEtkY1hKS1Q4cHhOeG1mM1dSZzFqSDNBU21QclpDc2J2STU3N1NxMXo1a2p6?=
 =?utf-8?B?bEs0N3RaY21NT3FQR2V6Z1lVMGVEai9lRkpYMlNWbnhjYkoyU0d0OU12cWlV?=
 =?utf-8?B?TWs1S08vaEdLTzRTalMvdDVRK1gyRUliSFVZU29TQ2g0RC9NVmVTVlZBRXo0?=
 =?utf-8?B?a28zeXVPeS9NMDJZM1BxSGtzUG1vMldLcWtJVEFkUVMySHBxZllpMnd2cU91?=
 =?utf-8?B?RlEra0xPNzAzK0xXK3J1RjUvbWJwT3dkRVlXQW8rVktvcGV3UytpWFh6WVkx?=
 =?utf-8?B?UmRocEFpelM0NGhPaVNFclJUZUlNUWRTYTczNVRYVFN5d1RFQUxvc2grL3hV?=
 =?utf-8?B?Y09tQmVNeWJCMENVWHcwcEVkOG1NbHBZZDJhMzlFczRSaGtENUZXUHZaTU9H?=
 =?utf-8?B?OTZJUWNaVE9YNHlSOXhUZ2hsclV0Qnk0VEg0Y1BwQkgvK21Na0FvaVpDa2VC?=
 =?utf-8?B?aG1mZXIzTEM3TDZFNndaVFJka3JMalc0ai82NnROcWxpeHFndzFzcVFiSWlX?=
 =?utf-8?B?SWlVY29keFROcUxwZlhqK215K0ZyZVpLV3gzQmZxZmdROWgzTXpvTEtGOWR6?=
 =?utf-8?B?eVdabTAzQTg2U2NLc2t0UGhWMktsM3JaalUyWWNOY0I3cC9Lak9sSFNqNDYw?=
 =?utf-8?B?YTgySk9HQ3dtVWdXVE1nQXU2YVdmdithV2paZ3l5cmJaVjQxL2NTbzFyY2ds?=
 =?utf-8?B?cS9FWDFDNWVsSmpLS05Vay9SejRhVGpJU3o3QkxLbkl3ZXV3djc2MFJja1J5?=
 =?utf-8?B?bW55T09QVklxalZsWE96cWJ1M2tjbTdqSlo3S0FNQU9Hck1FVlFBY09sVzFC?=
 =?utf-8?B?T1QwNkVEY2YxbXZkak9HVndlQy9pa2wrR0Q2TDlzZTF4K2VFOG1rdncrRE1T?=
 =?utf-8?B?eGJCem9tZ0huK1JkOEh4M0NDR29GQVE4MGlMUmY3aE1iMEdzNlJUK0QrZGdL?=
 =?utf-8?B?WVhoR2cxeGpSSzc5dkd2cHA4b2l1citwakNxTnVOSFNBZUNHbmpRN3d5dFlM?=
 =?utf-8?B?QzByNEFrZGVmN2ppVGRrYlNpSE93ZHI5cVN1RGFMNDFUS0xrRkxHQmFVWStp?=
 =?utf-8?B?MStNU256UGw0NXFhZ1R4VnNTVUhWaUlzTG5SeHRkMDBVeDJDS3E2WFM2OHVG?=
 =?utf-8?B?bEJBY0lnZVpua1JBQXlWTXpDNG83WW1BMytxL0JFaGJ5WFFnUytpY3hjNVJJ?=
 =?utf-8?B?RWdjNVVUWmd2dFQxYTR1Y0FZdU5QMHhVblhRWGpSWTBWdC9rZlpUYWI4RHhl?=
 =?utf-8?B?WEt5NHlmOFQ0QUorci9QSGF5T0NBczhNSXFUOGk4bDROcWpsZUpHVmM0U0lv?=
 =?utf-8?B?aEM5QloydmR6a1dRcTFpNUNkKzNmbitFR3p1OEcrT0U4S28wUDU2MDVrcEVC?=
 =?utf-8?B?Q1hxRmltTE11WldkOEFiTElBK0dxeGJ2eGlSbzUybzVXOG1iMGRONW9qTlox?=
 =?utf-8?B?N3RVdHRYNGd1RFljWS8xcE5malo5K25Qc3dFWkMyZEI3MkFxSkZMUDJ6Vm5K?=
 =?utf-8?B?anJwdG10dEtUa0JRWWZJQzc4MDIvblIwN3BUNW9wQXhJQ3VRaHhaTlQ5dzMz?=
 =?utf-8?B?RWJjWE1mQlFROEZGaWJDekRVd0V6NHNCWHhMUi9oa1oydy9ad0NpSkFuV0N3?=
 =?utf-8?B?TkFPZHNKa1R4YlBCRVRjOGFReHkvYXBCU3d6WjAyNmNMTFhWLzZScm9kR054?=
 =?utf-8?B?aTVDVEV3aGJHa0E2Qm40aXVUSXlmVE95anh2bk9qQVdzaFJHeUYrems1Tnhv?=
 =?utf-8?B?eTFVbEZVSlBmSHBpTE9iRjlZVnpuUWlhOEFBMEZWbEVma1d5N3lEdzlDT0dD?=
 =?utf-8?B?V3JTb3h3Z0dHWjJvT0VPZHZ3UjdCOHVYNWRPeitleFY5VmpSRDBoZmJyZFNt?=
 =?utf-8?B?MHd6SDVWREphYW1SVTRTd09oRGZyblVUb0Y0ckI3RTJmZEduSyt6TkpCZ1BM?=
 =?utf-8?B?L0hwUkxYQ21zUTUwK3ZXeXRzQVpPWWVGL0ZoazNXZ0hBN0hhcVJ4aDIzZ1JF?=
 =?utf-8?B?TGpleFFuRU9zaGEwWFgzdXd0M1FiRDZqZDk5VkJTOVdKSWE2WldPaVNCajNl?=
 =?utf-8?Q?cXivcGUJ1kQhSfHzmGahxqOyq?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9790d9bb-748f-4041-75f1-08dc863f501b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 15:42:46.6397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMgZcLE9DAPyRqJpYBMukYdezA0WRr30zhbA8Ysdtk20fzQRTlr0657/uVoUkEbsx9QE3GUXTIiSdVDdA9D5DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9458



On 06/06/2024 16:52, Christoph Hellwig wrote:
> On Thu, Jun 06, 2024 at 04:18:29PM +0300, Ofir Gal wrote:
>> I agree. Do we want to proceed with my patch or would we prefer a more
>> efficient solution?
> We'll need something for sure.  I don't like the idea of hacking
> special cases that call into the networking code into the core block
> layer, so I think it'll have to be something more like your original
> patch.
Ok, I'm sending v3 in case we need it.

