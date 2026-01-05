Return-Path: <ceph-devel+bounces-4247-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 895DACF566F
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 20:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49A9A301919B
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 19:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8327530F958;
	Mon,  5 Jan 2026 19:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c8ZN+U6y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B376113FEE
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 19:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767641877; cv=fail; b=Ucj5zNaFYsr0jkG3BidXMP+vuwMDZSN9nYuxqJxeOGygRGIyIs4QB3QISYsi83hRWnIeUxZ6g6Fkj+NVtuGlO7nQb2wl+lmo6SN1+ngrmUZ8UnmMzCktvtGSJnsPQBFsFhZKnZWbaHD8IEmfmJlxUkYpokqaMJucezcAfs8U72Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767641877; c=relaxed/simple;
	bh=rXSv+ezqzjMvs51KOiPdenZGC3pFmXOonpvJ12Za7W0=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=OZ2p0o+zOaOxJsCm6vWVULMaQo/PEqRqldSIkmDs3zA+ITStAHYwh2J3sRRZL5QRQtWxxIf5hGkRQJIiuyx5q/1MA4fPSf5wldmN0yIS2PDEJZjjjRiuXC8RSB5vUcfWoFnm7cEUV+9oTSMmcvMUbDInd2pKo9ll28eDcjytS/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c8ZN+U6y; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605Dp97G009799;
	Mon, 5 Jan 2026 19:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=rXSv+ezqzjMvs51KOiPdenZGC3pFmXOonpvJ12Za7W0=; b=c8ZN+U6y
	Kc9dRb4KhWRzZVQCpeoMyap5OAaxsANUacJ7t0n3UUcciPttgfQQBigOe/UDCvjV
	5y0+PucMsMb3LF/Wowo85gtZv4/Sunj7XPDVAbbDGuv/zCg/b+Mnf0h3EzYiBpBx
	SfhI9KKMegv8EmlGWyzfaYGv5NenUz+ZuLJ6MXbLcu+rRmQ3fk1a80MqlfenEJ6r
	3m8mKegPwYQk61RhA5uBDtxmgZD6Xi9KHg4AlXiaGmn3Qy/SrJMlkbN8lc8LgbfZ
	4vP7cwz1nrfb6BWWINm2Xb9KMzLgsmQJqEPItCLv4DMVYxQF+mzrLiDmJe3jjnTy
	euYPnd+Azx5Tsw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betsq0y83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 19:37:52 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605JYMuP016006;
	Mon, 5 Jan 2026 19:37:52 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betsq0y82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 19:37:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d4TVUH/m25CUXgsE4ObKSRQz2tVVbN5zt2bxxXm+WsX6e1+fh2p0/VHw7YbI5CFFEFN/Mq776gwLm28r08phgFI0Sx4X6EpX9yubUPu+V6PO9py5OB7X7yRr8RFGAAToIL721KO3YEbAtqWSG6ZJsu5ORmE77tqFxs+p6li3iNiszUtkkb6vvXUjpZ0v1nF5nNAPZmW4nVKkNBG1Epf+thz/SfA3U70FPp/yGCMS13tnVm0gic3QgWsOkB7sEpkTT3AZrJBV4oW0cis4eNQ2OSwNiAok5nislf8KHJCL9OfrcNv+wUbc/HPtwC0zs2DIon7GZRxmJmufrTXAmyYO5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXSv+ezqzjMvs51KOiPdenZGC3pFmXOonpvJ12Za7W0=;
 b=bNNF9pwCiMO6acipKHUbE+OAxMxfTrflakYP8mRw+KgjYQKGtL+bKv+7ef1iE+40Ma5RVHkHzaFU/OjLwe5K8eXlaBQsG4Ji6vZ3yWWf7NtCFCWJFDe0DkwbK6EG9O5e1okqBn+MGvulZigIE1AZo94PRpnv1NIA/LDD9oKexFQujvwONZ6zLniOcV3wdX+x1yXcK0J9d5HRdv6PPK9SrIfEdwriHTpbGqigE/zuqnBDRoibbkchVQpNXIPcYuuk5MkIAAcJI0y/nRhx1drWz9kTWUAc9WDJddkibhUfCUJcqUPYiuC1gukgVgmP5tcx+j1fHHyeRSwSWvgEykDmhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CH3PR15MB5889.namprd15.prod.outlook.com (2603:10b6:610:128::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 19:37:49 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 19:37:49 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: Alex Markuze <amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH] libceph: return the handler error from
 mon_handle_auth_done()
Thread-Index: AQHcel2fFO4NnZUH2ESWv7EbW+1DtrVEAM8A
Date: Mon, 5 Jan 2026 19:37:49 +0000
Message-ID: <0c55fc3a434624d4eb67babee7108e23e7774cff.camel@ibm.com>
References: <20251231135845.4044168-1-idryomov@gmail.com>
In-Reply-To: <20251231135845.4044168-1-idryomov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CH3PR15MB5889:EE_
x-ms-office365-filtering-correlation-id: eb7c2144-a6f9-4570-0c84-08de4c91e8ec
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eHlPYjM1K3RNZVdGUFlWL2NVTUJFc1VFOWRHQnJPamxMSjl1U3k0QjJVTlg1?=
 =?utf-8?B?S2xMS0ttRXRxS1E0QnlMelljeG1FUjJGMldDd05lU0NjaEZiWFlpZzUyQnRR?=
 =?utf-8?B?VmlVRE01aGJjbVRQYkZweityMTFIeENaM01hZUd6S1dlUlcxR0tPT2pGNVZT?=
 =?utf-8?B?Nlp1U3NnRkM2c0IxUWtMNEVSNWFSSy9iWnJ2ZW80a2ZoeDNvQ0dhcDN3SkpH?=
 =?utf-8?B?c2hvdGd3WkFRWThJVzNHbmp2d085bHNtRjRGZ0xpenFtMXNJelV3NGRHdFNP?=
 =?utf-8?B?QXMzdmRsaHRRR2xXcnpuNFltMm1OLzU3ZjdsZDd4U1hCUVRuNmpYY0pUWXpj?=
 =?utf-8?B?ZW9OSFpHbjJ3a0lINHByK3M1U0U5U0xTejJJQWU4cHVaOVNxVGNVNWlzYXlZ?=
 =?utf-8?B?cVdmeU5MMTJjaVdnRWxDUVVuRFU3ZVllZEVrOWx3SUpVcXdZMzFZN1lsT1dP?=
 =?utf-8?B?dDhaM3lyQW8wUjkyUFYrVVZtbTc1K0w1RXhFcXJYVlJWZzNreFdERzZpWnhD?=
 =?utf-8?B?eHZZemNUYXphaWh6Q0RZUjlXSitKWVk4bE1RSlp5TTVHc2NKc3hZNU5TRXZj?=
 =?utf-8?B?STllK2o0UzRDK1hEdzJWTTJZQ3N4aGVDcExpRlVxbEk5N0NwbzZudTMyQWJT?=
 =?utf-8?B?TzF1VlZrSGI3dG8yUXNvNDcyQlFKMFZmWmw3MjBUV3N3Y3RwOXVVMXJCUEdD?=
 =?utf-8?B?SXFKY3ZiWnBaNXRFYnNneXFpKytmY0dJZDlRSWY3R0Y1d2dKdVByQzNnMFdT?=
 =?utf-8?B?QU1lTzNPaFM4MFRMTmlRbVI4bENtL3czZzRQRUd6V3ZjSDB5dDZLMEFnam9U?=
 =?utf-8?B?YWtIdWg5a21OUHhuRGs5LzlkbmlOZnVwWlZLU3pSZ3loQXlMQW9LOWZMbWIy?=
 =?utf-8?B?Q2UwOEhHbGxQVmV0TVcyTGJJb1dYL3IwRy9pclMwaEVKeUFDNHI5R0VpOHRB?=
 =?utf-8?B?K0VEaFNDSkNkaWxLNFlvR3JoTnJXVjgzbXY5N1NkVE5VRjBFbG5HeUR5dzBL?=
 =?utf-8?B?OUxHTFZHS1I5OTlGOUJweEFneXBVTGJFTGxWVTFVVy9pdXlERjZWMGlZZVMy?=
 =?utf-8?B?N1Bzc3BFWUpnQlNNcU1KeGNuVWdkbDFXQnRZY1drNFlmQ2JOc3B1UkZRbjQv?=
 =?utf-8?B?bC9UQ1VlRWF3eU96dmtFU3M3UjVOd3BZUExmQkI1eENUMWgxTzNrYXVyamJD?=
 =?utf-8?B?UG81RmNaRXRYbFpFdnp0eUlBYzhOd0pJNU9aN3BWOGQxOGJhMVg4S3ZVRFhY?=
 =?utf-8?B?QklzWklvcVdCMDVDcW5jOEw2OGdzcjVVZlhua3dWSHZEUDhRVkp4NXRQY0dw?=
 =?utf-8?B?SWlCOGVXZkMzMytBai9lWTBWbW0zemRCWkNkbXVKNGZ2WndJL1ZUZlJqQ1NG?=
 =?utf-8?B?b0JiUW04QnJGUFVwR3pYT0lQYktEN3A4dThCU0dQMTNqL29UNmVtYWZQZjEv?=
 =?utf-8?B?SzFVd1J0NjF6TXVMdHIyYVRqa2lkUGZndHc2T0c5Z1hOWk44dDZyb3lPc1Ry?=
 =?utf-8?B?a3E4QVhuUmhqSnJ2TjFMYWJMcG1VMHBLZzBUOGpxeFJMUGNSWHovT2ZGNk1i?=
 =?utf-8?B?R3FERElXZkgxQnRpY3BmbjNGWXFSMUhKdWxCVWwxclhrMGVURHRVNkU3MVJK?=
 =?utf-8?B?T1VEc3ZmdEJxUm9nb3JEWmVlYkVIOStNN3c5Y3lmSUFFbkR3UGhsMHEya0pL?=
 =?utf-8?B?Q21XM1NuL0FwWkZXT2tpNCtnZ2x6NjVJazU5aU1ObUhqZXl4emdkZHE0Z3NK?=
 =?utf-8?B?TE40dkdvOGI3QlRINXVqSTR1aC9ua205ODloYi9pZm9QRWlrTzMvU0tQYS85?=
 =?utf-8?B?OERpMUM0QVNNRzJkbEdOMlBncVRaWVZWdHY3SWtMY1dudVkySHJ2cDRKc211?=
 =?utf-8?B?VGk3RUMxVHliWStLMWljTlJyM0YvTGdJU0R0UmRjZC96NlFEb3dmYnlQZTh2?=
 =?utf-8?B?RVU3UU5jUUkxSWgyQ1hpdDVaeE93SzFCSHdyM2hacHkwMmlrQTRLRGFwZFNB?=
 =?utf-8?B?Wkd6TjJndHh3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?amFoQ0hqM29LeEdUaHRlbDVLNlZVSlpqMUgraVY1NTBmVmFhMGJXSDBLVVNY?=
 =?utf-8?B?QXgybU5CU0NlT1BPTDhJSFIvc0J2USs4UmhlTlpEOFZ3dlB0aGdqVVRINUZS?=
 =?utf-8?B?WDRGcTJSeTFIbnB0eFZzdzR4cDYxUHNOODVoOVdyS09kNmVaWDdUWnJuTTZy?=
 =?utf-8?B?cVZFWldnWGpoOXh4S2lOd2xSVldQbWk4emY0OGYrSEY3a1ltVldXaWF1TGtv?=
 =?utf-8?B?czRGVEhyUUJINTZnZy9GS2dhUkYrMUJIUjBmbWNKR25haW15S2hleGxoRTNF?=
 =?utf-8?B?emZMQStBRytCSllHZWFwU1ZVMHBNTHhMWTFkaldIOE1nTGgxMG96a2h2L3ds?=
 =?utf-8?B?Wnl2UlFFWUlzQVp2SGtvbytMWEladGhZMUlVTExCUmlxK3dCZEJYRVI5ZDdS?=
 =?utf-8?B?R1FOTy9yU2NQdmtneVk5MjgrYmhGMUc2eTZtbDVla0p1dFA1c3RJQkJVR3FR?=
 =?utf-8?B?L3NFQXkzdndDV082a29IRnNKS0JzbVpVNmY0M1VoOEZOaElxdGcycWpOaWNp?=
 =?utf-8?B?Z0NxVTllM2RRVDBFSEFIZWlyQVB0TEI5VDhSTVJ1dVkvZjVQT2dobkNTTklZ?=
 =?utf-8?B?MlJwTVpxQ1hYZDAyWEdMSERTMGxMSzE1VFRBdHdEdGpqZVR4clYyeXo3MTdU?=
 =?utf-8?B?YTdmWndnN0xmTW0ycWRHVXd1UGhadU9UZDR1RFNMQ0RSOVBkWWtqa3ZuM01r?=
 =?utf-8?B?anFuZmZvQVNkMlNpWFRwZjNuZUJ6OXNEK2xnVDNTaVd5aXFNbHhVeG9lYWVH?=
 =?utf-8?B?cU8ydmJTb1IwT1EyaWs1aURHa3NpcUp4ZWpuTHpCd1BTTzkyOEwwSENZMzdx?=
 =?utf-8?B?QytyMVVTZjV5MDZKVWVoYVNDOUZTZXNxaFZGdzJ1Z2QrWmRMMktlM1NmcTFX?=
 =?utf-8?B?bTgxK21sUkEzbWxlTlVVOEMvWnRMQy8rc0taTGtHMUN1YjQyQUtxUGQ3ZC9a?=
 =?utf-8?B?aHRXLzUyMFZJdVNiMy8xR1FpMnArY1hiNzVVQjQ1Z3VqM2lISEc4aVNFWlg0?=
 =?utf-8?B?TngzRG5wNWNGSDBMK0tZSnEzUXVhREx3VFRUNFpMVWFqK2UweDhJTDZCNUNB?=
 =?utf-8?B?VXBZVXBOdUtmdUJzLzNhK1hXcHgrdTZqSkowVEdJcFV4K0ZDci9HYWNaY0RB?=
 =?utf-8?B?bXJ6RjV4NUowWjNJZnFLNVNnUnU0dXUrdFNIMzRRVTVWRzhLdDhKZDFvSmtj?=
 =?utf-8?B?MEVMNldCbDR2NGIwcVRIb1BtUlEwS3hBdldDTDZpdnpHQW1WaVFuaGszWS9S?=
 =?utf-8?B?b0R4KzNLOTVRbGRJSGVINzRqd0FhMWVWcTZDcVJFL1FoTEwybWlpcUhxcTBY?=
 =?utf-8?B?SFpaSThFTGY5NU1ZMzFJZ2ZBbk9FRG9uVUo0TzhLN09yZm1GVGh2Y3ZUZnlt?=
 =?utf-8?B?MnhCSmF2bEhzT2poWGRCaVg3dkl6aVZzTmlNRWlYaG5hcll1eW1qcm5oWExQ?=
 =?utf-8?B?cEthOFM4YnNYRldBc0g0MS84Y2hJallJa1pHQ2hVRjR0ckhvcXQzVlAxbTRM?=
 =?utf-8?B?TFlIQWo2YnByay9Bb3ZncXhwZlYxaVlSTno3cjBaVCtrNTdQMDM5VFdsaEpJ?=
 =?utf-8?B?UXBzWExEcjNGTmxBK2hyN1JDeUovRHVScmtWejBrNjJoUUttSzJxMktmWk1v?=
 =?utf-8?B?STJhMnhLRUc2ZUxSM0tOaEJGRFNNVnBOUkRtMjRCaDJyM1MvYVZIVXFXbDZC?=
 =?utf-8?B?aEMybUVBUDV6SmlkVk4wNWZJR2xVbHBMMHBVVXNWRXJkUkVIdzQzNTlaQ2Ji?=
 =?utf-8?B?aEU5RjJNMVJkRzdWbVgzVzRyM2xreGlWTTNhYy9LYXlkekdGMkFjUTEzK1h6?=
 =?utf-8?B?bGVrY1R1SlE2KytTYmFPSlpMNDJLcjZMQkliSW1wRjVtV1RjNTNnN3N0eVdE?=
 =?utf-8?B?eWJQaXJmVVhFbVZDUGZ5Wm9BWVY2RVhoeW5BU0d0enZCdzFXRlhjajNWVmY3?=
 =?utf-8?B?c1RaVGpReW13a1U2TTZBd1Fka0VaTGlUTDlwWFozQ3VtTlhLSU90Q1BCTGxE?=
 =?utf-8?B?c3h2WEpjaGtuMXRNZFpsTGp2NHlxY0FsRVlqaktYSkR4d1A5aGNXMVFKTkcw?=
 =?utf-8?B?SU0xN3pJNjRESkt2cU5SVkJKdGxMNzkvUnRkb3dka0RrR3VJN25OM3lUV1c4?=
 =?utf-8?B?SUZlSFUwNUNmaUo0WUlDbmpRNDBnemhpd1ZveFBTNzMzQVNoVTNJUklXb3RX?=
 =?utf-8?B?cjg0L2Z5QmpCZlBwNldpVTRKcDZtSkM0aXNEZkpwcEt6TTF0eWZCUVhMZEh5?=
 =?utf-8?B?NVMwaHMxQ05qY3VLeWxEa1dma01uWTJ6VnMzc3JGWTJHM3c4OHQ3aHNpbTNx?=
 =?utf-8?B?Q0F5YU5uTVRpVVZhVWsrYlArOG9NcHBnZFMrZjVDZEpCU053d2o4dWRQN3I3?=
 =?utf-8?Q?yrm8D/aiYXMLOrhg/4/1KJ29lTVbME/KpjrCH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22C47C468BC4314C99AD5F419C35694A@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: eb7c2144-a6f9-4570-0c84-08de4c91e8ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 19:37:49.4701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xk+ptXM6Xd3j/uCXGzTKB5lcRj2ceAwKzg0qqaRLkO2Qq7A1cKhM9Ghdt7PpTag05jIDGFGQisLW1G5xk+jy2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB5889
X-Proofpoint-GUID: WO4UMWYKsXiOEC-s2UVmwol2fnY5fg_K
X-Authority-Analysis: v=2.4 cv=Jvf8bc4C c=1 sm=1 tr=0 ts=695c1310 cx=c_pps
 a=vwzr6GK/qOZR+/kkcyjBFA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=P-IC7800AAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=oGyWq3Jur5Qw-nmvnooA:9 a=QEXdDO2ut3YA:10
 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-ORIG-GUID: Qs38aEZKwHm7LHJKieAktqB3MPD_HdTv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE2OCBTYWx0ZWRfX46UKnENDk+I0
 24cerbuRxJDlIPgzFytoc5mJl04T5z6jWcu6GJI/ur9CWeLYnFhJ3nzQ+ch2TUsihzG+rz4vXti
 VhuwXwmgbvK2QjGSHhKv5sDfzHaYuNgJ6Gup6pDHCH2JzL3QXPnEQiyFlyIZacFlGByKa9iemAU
 wPviFj1JHJ69GoNptB3I/UA0MCY/APVi6Z8DuAsplEByXogFKmpxXMahkKVJe9Hkde2HgEbZoSx
 NoqD50XjEqWUXjNV7G0e12d/5OFn2sZcb6uot+gZFVcgMPFYChVaUzpzlvjkii2Zez0T3eNMoxQ
 PWGM5s0A4C4fqpZ2OjPThG3+0b7Hd9sDzN76dS1WjSsoxautl7SAjZyAT7LLpkBcPFaR/E8O/01
 DKaGXMSXRA/+K8Y9x//hn1PEWz6isw6fIg8pw0BSJx2MeUL9IDdF89FjeVsMI3hb/1r9pyqLbu6
 cmp36YjIh0KK1Xmt/CA==
Subject: Re:  [PATCH] libceph: return the handler error from
 mon_handle_auth_done()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601050168

T24gV2VkLCAyMDI1LTEyLTMxIGF0IDE0OjU4ICswMTAwLCBJbHlhIERyeW9tb3Ygd3JvdGU6DQo+
IEN1cnJlbnRseSBhbnkgZXJyb3IgZnJvbSBjZXBoX2F1dGhfaGFuZGxlX3JlcGx5X2RvbmUoKSBp
cyBwcm9wYWdhdGVkDQo+IHZpYSBmaW5pc2hfYXV0aCgpIGJ1dCBpc24ndCByZXR1cm5lZCBmcm9t
IG1vbl9oYW5kbGVfYXV0aF9kb25lKCkuICBUaGlzDQo+IHJlc3VsdHMgaW4gaGlnaGVyIGxheWVy
cyBsZWFybmluZyB0aGF0IChkZXNwaXRlIHRoZSBtb25pdG9yIGNvbnNpZGVyaW5nDQo+IHVzIHRv
IGJlIHN1Y2Nlc3NmdWxseSBhdXRoZW50aWNhdGVkKSBzb21ldGhpbmcgd2VudCB3cm9uZyBpbiB0
aGUNCj4gYXV0aGVudGljYXRpb24gcGhhc2UgYW5kIHJlYWN0aW5nIGFjY29yZGluZ2x5LCBidXQg
bXNncjIgc3RpbGwgdHJ5aW5nDQo+IHRvIHByb2NlZWQgd2l0aCBlc3RhYmxpc2hpbmcgdGhlIHNl
c3Npb24gaW4gdGhlIGJhY2tncm91bmQuICBJbiB0aGUNCj4gY2FzZSBvZiBzZWN1cmUgbW9kZSB0
aGlzIGNhbiB0cmlnZ2VyIGEgV0FSTiBpbiBzZXR1cF9jcnlwdG8oKSBhbmQgbGF0ZXINCj4gbGVh
ZCB0byBhIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBpbnNpZGUgb2YgcHJlcGFyZV9hdXRoX3Np
Z25hdHVyZSgpLg0KPiANCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9m
Zi1ieTogSWx5YSBEcnlvbW92IDxpZHJ5b21vdkBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgbmV0L2Nl
cGgvbW9uX2NsaWVudC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L2NlcGgvbW9uX2NsaWVudC5j
IGIvbmV0L2NlcGgvbW9uX2NsaWVudC5jDQo+IGluZGV4IGMyMjdlY2VjYTkyNS4uZmE4ZGQyYTIw
ZjdkIDEwMDY0NA0KPiAtLS0gYS9uZXQvY2VwaC9tb25fY2xpZW50LmMNCj4gKysrIGIvbmV0L2Nl
cGgvbW9uX2NsaWVudC5jDQo+IEBAIC0xNDE3LDcgKzE0MTcsNyBAQCBzdGF0aWMgaW50IG1vbl9o
YW5kbGVfYXV0aF9kb25lKHN0cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbiwNCj4gIAlpZiAoIXJl
dCkNCj4gIAkJZmluaXNoX2h1bnRpbmcobW9uYyk7DQo+ICAJbXV0ZXhfdW5sb2NrKCZtb25jLT5t
dXRleCk7DQo+IC0JcmV0dXJuIDA7DQo+ICsJcmV0dXJuIHJldDsNCj4gIH0NCj4gIA0KPiAgc3Rh
dGljIGludCBtb25faGFuZGxlX2F1dGhfYmFkX21ldGhvZChzdHJ1Y3QgY2VwaF9jb25uZWN0aW9u
ICpjb24sDQoNCk1ha2VzIHNlbnNlIHRvIG1lLiBMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTog
VmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+DQoNCkFzIGZhciBhcyBJ
IGNhbiBzZWUsIHdlIGhhdmUgdGhlIHNhbWUgc3RyYW5nZSBpbXBsZW1lbnRhdGlvbiBwYXR0ZXJu
IGluDQptb25faGFuZGxlX2F1dGhfYmFkX21ldGhvZCgpIFsxXToNCg0Kc3RhdGljIGludCBtb25f
aGFuZGxlX2F1dGhfYmFkX21ldGhvZChzdHJ1Y3QgY2VwaF9jb25uZWN0aW9uICpjb24sDQoJCQkJ
ICAgICAgaW50IHVzZWRfcHJvdG8sIGludCByZXN1bHQsDQoJCQkJICAgICAgY29uc3QgaW50ICph
bGxvd2VkX3Byb3RvcywgaW50IHByb3RvX2NudCwNCgkJCQkgICAgICBjb25zdCBpbnQgKmFsbG93
ZWRfbW9kZXMsIGludCBtb2RlX2NudCkNCnsNCglzdHJ1Y3QgY2VwaF9tb25fY2xpZW50ICptb25j
ID0gY29uLT5wcml2YXRlOw0KCWJvb2wgd2FzX2F1dGhlZDsNCg0KCW11dGV4X2xvY2soJm1vbmMt
Pm11dGV4KTsNCglXQVJOX09OKCFtb25jLT5odW50aW5nKTsNCgl3YXNfYXV0aGVkID0gY2VwaF9h
dXRoX2lzX2F1dGhlbnRpY2F0ZWQobW9uYy0+YXV0aCk7DQoJY2VwaF9hdXRoX2hhbmRsZV9iYWRf
bWV0aG9kKG1vbmMtPmF1dGgsIHVzZWRfcHJvdG8sIHJlc3VsdCwNCgkJCQkgICAgYWxsb3dlZF9w
cm90b3MsIHByb3RvX2NudCwNCgkJCQkgICAgYWxsb3dlZF9tb2RlcywgbW9kZV9jbnQpOw0KCWZp
bmlzaF9hdXRoKG1vbmMsIC1FQUNDRVMsIHdhc19hdXRoZWQpOw0KCW11dGV4X3VubG9jaygmbW9u
Yy0+bXV0ZXgpOw0KCXJldHVybiAwOw0KfQ0KDQpJZiB3ZSBkb24ndCByZXR1cm4gZXJyb3IgY29k
ZSBhdCBhbGwsIHRoZW4gd2h5IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIGV4cGVjdHMNCm9mIGVy
cm9yIGNvZGUgcmV0dXJuaW5nPyBTaG91bGQgd2UgZXhjaGFuZ2UgcmV0dXJuaW5nIGRhdGEgdHlw
ZSBvbiB2b2lkPw0KDQpUaGFua3MsDQpTbGF2YS4NCg0KWzFdDQpodHRwczovL2VsaXhpci5ib290
bGluLmNvbS9saW51eC92Ni4xOS1yYzQvc291cmNlL25ldC9jZXBoL21vbl9jbGllbnQuYyNMMTQy
Mw0K

