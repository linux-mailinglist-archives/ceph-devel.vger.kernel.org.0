Return-Path: <ceph-devel+bounces-4256-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 928A1CF5D87
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 23:35:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EE8E23063248
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 22:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45E827BF7C;
	Mon,  5 Jan 2026 22:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gb+tauVT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0D4239E81;
	Mon,  5 Jan 2026 22:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767652498; cv=fail; b=hB8Vcq6vuzHB7w019Ta6p+JjRE9jQ8ZX5+REasaxM9B29r6/CgiAPVIMYc02GEgrBRjxMj+ur8b/pNIj1cddt+omc8h1avGacrAgahObOWQ8NSB69flutX/gw+6+aca73dZM6OZkjCQ+fDBcFvp2GNXrmipVRIaYYjAH+Vj8DrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767652498; c=relaxed/simple;
	bh=rx6ivaPYjqWRXV22EKkGBcLcMNHXfnAanPyEBNEK99Q=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=bwJKuaVeJwqKZUGzFdk/7BNllybtEl+HpvnVJYw9KmFwuJYTqvSrG27kXYacrrcIP3ZSX8Jif+j15dDYfduguFAgIcVDfw6h3buguxKRsMCX/Zdl0WzZPVjdvPzyfUOIAy1RAYV6cfy96xvxIey4pXn1niD/t7jir4n0DRABEM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gb+tauVT; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605Lih2a025190;
	Mon, 5 Jan 2026 22:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=rx6ivaPYjqWRXV22EKkGBcLcMNHXfnAanPyEBNEK99Q=; b=gb+tauVT
	TBv/qxWQ06QUzEEgjuL2z81223BlizpE1wOJb0sM/B6TNFKbZTm7cLcW8NNXXjRg
	l/Hg1iDKXsTri4apFJ9u93cLRjWDMCSXynYfGEfP7gFQY06fhcD4dhy1eoz7msBl
	a9lO+qBmIpjrzKACVNzjwCr9XRE/dRNcICABaFU9W4g8V3Ii4SuNOZRfikQQ1jMT
	UOAMtPURBuWzL3nvSYOyI8Dd4wHRy/PEvyT24Tcw2qCdTWhUBoBDVTkAYLYxcEjz
	rUD5GIwGpRZ9oprRXDI3tPW8nAMpI4XRBTN1vFZdNnmf6VANw6ZPN2X0D7teLU6y
	vgHRpuNirsCV6g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm71f78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 22:34:53 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 605MYqEe024685;
	Mon, 5 Jan 2026 22:34:52 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010040.outbound.protection.outlook.com [52.101.201.40])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm71f76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 22:34:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W+clhxPvTSQBktDhO8Ymv56V5Q8nFhs5PXZbVXWZOKAwrAyI8UJu6nAPuQGffuqXZYb9caDO3eZvug69CRJN7C9/in99S01LzrKQUyBpVvptfZCemL7ixPtA2AkdjlsncNzHnVZl8o/OxIkyUwT62uABInrnqlVAQ9gh3BpLjF2svHH4Roki+lMJihbaZKGNRum5eenjppomOHp07j8B7mfHRDbROeZQGfcbh128/0Bt+cnBRo4ftb6rrE2yIlE6gWA5JAlujUWUBXaFm0cd6a4JuhM2+Pwhj1GAI4rC+UIgSnnitvkLzeQD+epxdvKqLYoYZ5ipSu6RXdTxp4JBNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rx6ivaPYjqWRXV22EKkGBcLcMNHXfnAanPyEBNEK99Q=;
 b=DH0HWQgZdghdOL47SGJS1BEOCHpSisr+0RIFJ/NSXMIzWQQoZSbmcKne4wBxgQnY/IEFbRgEaPUfsrzWk/3bRcHdbJLuzzSH1eimcWHaJJZ9LuyW+IXTzrHijnNCsBWvgMwwXQBEJrDlWvFy0DqgzMBPJMJqvBXW9sls4LwZMphaomftIHaTQCX/GFTyxjvpW75N4GmsSswfvHKpJO9EE1sGHDusUR+leUt6g8XlX2zH8Fq/pSWXEElQH4QeA+ceOp0wSb99XiT7/KOB2Hq3CIxBN+W1x4xwxV/4si1053ZeNJ9oK80+14/USR9RMtPjFKUmBB8Z966EL0+8vVsmRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4519.namprd15.prod.outlook.com (2603:10b6:a03:378::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 22:34:50 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 22:34:50 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        "cfsworks@gmail.com" <cfsworks@gmail.com>
CC: Milind Changire <mchangir@redhat.com>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH 5/5] ceph: Fix write storm on fscrypted files
Thread-Index: AQHcegDybaCnLjTaI06xqhgK+zEKRrVEMv0A
Date: Mon, 5 Jan 2026 22:34:50 +0000
Message-ID: <912bf88ff3b77203c2df37aa4744139a2ea0a98c.camel@ibm.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
	 <20251231024316.4643-6-CFSworks@gmail.com>
In-Reply-To: <20251231024316.4643-6-CFSworks@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4519:EE_
x-ms-office365-filtering-correlation-id: 554e06fb-f68e-4775-3a57-08de4caaa389
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YWZhTGlJTkdBbXFlWkRORER3Rk1XQUdCb1EvWGFsS0J3SitNSkFDWmt6cXhz?=
 =?utf-8?B?SGZONGxQaXBzNVUydXF5NXlhWVFsOWFvekgzQUpKY29JbGx6YjRsQThZeXN5?=
 =?utf-8?B?a0ZUbE5oYmV0TFpTaGViNXIzakN6UEU1T1FvZ0RKdmVLWHdEWnUxM1VFOWg1?=
 =?utf-8?B?d3YyZjRaMHVhN0d2QlJocmdTVENxeno0a0FrWnlqa0RXR2R5a2pUc1lUWFU0?=
 =?utf-8?B?ckczUmloZkI0UzVWUUUxTi9iWVNNb09CakxzRDgzMkgxbFNrWHN1bE5GNDA2?=
 =?utf-8?B?dXcrK3E3MkZGMkVRZ1ZMUHpjdFdDZnYyN3hKekxpdkcwcmwvNTNOdzA2V3ha?=
 =?utf-8?B?YUc3d2tMcXdwRTY1NnhjbkJwZURvczhIRzhKdFFQeC9nOTdOejJuZS9oM1dt?=
 =?utf-8?B?ck42bzA3NlFjSWttbE1jMnR0Zzd6SkU2dnpEM014STlEU2I5THJKTVBaQytk?=
 =?utf-8?B?SkNtSGtUa09wMWR2WkJESXBva3o5dTVxbzVNUjUzUjJCN1Q0RHdJTG9iR1dn?=
 =?utf-8?B?OUVaVHhuNGFxTzZZODRaVlZUQURpRWNtT3I2K1Z6MkhLYmFJYlZXWlB4UGRL?=
 =?utf-8?B?YlFPbHk3NWY4b2ZRTUFTViszU3cvVWpmOGQ1TDJnNHFVNmZXRjB2V1c3dlh5?=
 =?utf-8?B?NEVla1ZrckVYN0pwYk9jSk9VcFMyK0x4SFI2RjhONE5BUStlMG5PbVNFdjFE?=
 =?utf-8?B?WThuOFFSazRhNktTWW4vU2xZUWxzZnEyZ294NjVhTmZSdnltcXc1YkV3eXFS?=
 =?utf-8?B?ZXVhWGovYzBycitpZUxuWmlOSFpJQ3RMSStOTWlHVDFadlBnNTZMVEEwV3JO?=
 =?utf-8?B?VHR5dXpwb0ZPWjdkdGdHcCtJWHJGYVh3MHd2YmFZMk5vVEN0S01QTExTVTlC?=
 =?utf-8?B?aUlvYnVSa3Vicm1sWitBWFYyZUtwN3BTSlk1NWQvUCtGcmtaWXJxYmFrL1dx?=
 =?utf-8?B?TzFZOHNNcmlDUU5rMWtBSlY2MVM1N2hSVHJNSWtNV2dRTVlneXFGdEhhSDdH?=
 =?utf-8?B?NW9XQmtBczk4Qjc4a0xlVElDNHpJMmQ2SGVnN1Vqc0UzZW4raEMzQUFoNEkx?=
 =?utf-8?B?Y1VzRlAvME1iVCtTR0lURGYyWGZETmJUTk9pNUNyaWFKZUlpNmczTC9raE9J?=
 =?utf-8?B?OFJ4OFp1SFpsMnlOVVlQaFZOVkVtSXBjS0Q1Vk10Mi9EbGVRRVg4WE94c2pN?=
 =?utf-8?B?TE8zT0JpTzlRM3VCVTFrQ3M4NDRWZm5OVzlxUWpTQ0FiUXJpejZXdUY2RDZO?=
 =?utf-8?B?MDdxcHU5ZnI3c3BkL1RjY0hXMG5WM0FJTTViTTd6K0JXNVQ2aWtpTVJPOG1z?=
 =?utf-8?B?aGx6WEtVN2JDTjZTek1JUEFXM0JDc2dnQ2cycER5WWViY1dxWmh4eC8ydnJM?=
 =?utf-8?B?cW16YmVnOU9BbzVnNDUvLzVXbm9mcnNGYVhhekZ5d2F6MHlpN1NaRTdGbEpo?=
 =?utf-8?B?cE41dm1rUEtLY1B4UUZHckRHK25sYU5zc1p0Zkg0Z28vRXBkdHExNXE2OWky?=
 =?utf-8?B?OEw2L3RSZU5makJ2YXlUN2JVYUp0ZGgxdXhScE5wQzhNdGhhSVoxOXQrTXhq?=
 =?utf-8?B?MDl3eEl2QXl1QUd0YnZWeHhwSmsvR3FtZXlKaWNEOEp4c2VXY3dFUnczaEVT?=
 =?utf-8?B?YTcxdEpjVENySDFhSHgrYXF4b1ZZRlNhdHRsTlhNcGZyVS9CMzU1dVlITlBw?=
 =?utf-8?B?ZWY4V2VoWHY3Y0h4Sm9GamR2a043NXdRT0lsUEhFWFNqWTE5SnBYT3d4Y1hq?=
 =?utf-8?B?aVE5dFFHYkt1VEs2eTZXVno4V2szQXVzeGN0LzhjOHNCSkxscVpQVkNLMGh2?=
 =?utf-8?B?UWs3V2tFOFlENHI2aWNEU2N1MEdnU2xDUzlLelV5djc4TDFqdStkMXhsN0F1?=
 =?utf-8?B?dGFVQTJhbm9XSE1aMTNxS21aTDl4NmV4QmcrREgwaXhsVjhoaHBEWW93YzFE?=
 =?utf-8?B?d2lCSlNBdjZmTHVCcUZtdFRtd2RSZ2pua0JOVnkzK0xpNXNyVlh1MmpURFdW?=
 =?utf-8?B?R0cwTWJZUU9sUnJ2cXdkenJNY1ovaTYzMmpEQzRIczBoWkFYRURuVG0ydUUz?=
 =?utf-8?Q?jvPijZ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bi9iZVZzT2JDQ0Uyc1BJUE1CWVRBc0xEY1Yrd1FiYzMyUUJuUTRLNGo2TUNU?=
 =?utf-8?B?SVBOQjBkMnJlMVphNUpWL01NRjhJbmhsMXkrRFZDcTJza0grbS9tRHV5NnNl?=
 =?utf-8?B?d0tnZXBZVUR3R0VVTHIyNnlxRXptWE9Wbjc1MXB5bkwxTDJLc0wvbHQ3eFUw?=
 =?utf-8?B?UDJ4bVdJcUorbW5GQXRQaVl4Y2UxWldRaHg0QWtpb0tZL1YrZGxqbEZyNkJL?=
 =?utf-8?B?TWo3d1dINFFnVTR6R21PMHJTOTdGUFlsR1NmNlBrZnVtcDRsU3puNWNvd1pr?=
 =?utf-8?B?eDJ1QmoyK05ZTWg1TjdBK0lIZ29wdStjbDdaL0drQ0IxZzY4OG1jVUVhZDdy?=
 =?utf-8?B?bk13YnZuSU9oQlI3bmhGMlhNWlVoVE5DQy9SUTl4WUVmS2NsWm9GY1hTMzFN?=
 =?utf-8?B?NUJiRXFEdGZzcnBVRzJCVC9zZ2ZXc2F1dmRURkZhY2hLb2ZtTm5TWkZhT1I5?=
 =?utf-8?B?TFY4S2F6cjRPQTlISmdIcjBUWTlwaWFvVUJzWU9hdzRweGlKQWNoZUdHQVRY?=
 =?utf-8?B?aXhjR2ttR0x1SjA3T1h4TjVqUWxoSkVpc3RnRHQyS0pLNURJNGNYL0NpckpE?=
 =?utf-8?B?dy9Ub0JCNmI4czk2R2YxN05iYmVnUW1RRGhzaHR3YUYvdysrNm4wS0xydzUw?=
 =?utf-8?B?S2wzWTVuanJRWmE3SGxmTDQ4UnFYcWpOMnZmNVNIZHI1cTY0VzZhMVByeXcv?=
 =?utf-8?B?WkljNTQxSXlxbUtKMmw5dGg0QTZNc3BKdHEvQWtGc0tHN2hMTXo3dzl0SHdF?=
 =?utf-8?B?cGxvWU1SVFFyYmV3K21tZ3gvY3JENVJTNi9mT3d5MVhkTmtJdjhxTGdoeTM0?=
 =?utf-8?B?dGZHNkovdG9iTXJzc1pFTzVhZ0cwczMxODNDRHNzdVV4ZHpEWmNrT1R3NUdu?=
 =?utf-8?B?QTk2WnhWejhyRG1XY3NFcnFEeXNEMkhrRjVnL3N6S1hWeUVHNFBjdGFQWEYw?=
 =?utf-8?B?SXE4TndYMVg0RlpQdE9aMGtmRkNGRUZCQlZHNnpJOFZ2dFo4cDdPRjNXZEVm?=
 =?utf-8?B?YVFiamRTOFdyamUvVXpodmFHMjNtTytlZG1CdWVZNWxkeUVyL3BkR283YmNu?=
 =?utf-8?B?bUN6RkI2UC9vcmxVNWpxOFQveFIreit2QzFVQkgvdDgrZ1pWZldSZ3lrcnU0?=
 =?utf-8?B?eTN5WExMQWkvS1ZIRWJKNThlbzFXcDBWMkszOUdtTFZZZ2tuUTlDK01aV2Ns?=
 =?utf-8?B?S29selIza0lVRlFWRVJOcWxJak1oWU1UVHNmMEw4ZmVUNGpRVDJCcDk5YVY1?=
 =?utf-8?B?M0dtL1NXZCs1VDMwbTEvYlppb3hTclpodld5Yllya3JZOEI0b0dZMHZ2TitW?=
 =?utf-8?B?YkE3anVRaDJHa3pqNklKUTBKang0bXhBVk1kT2sxMjRGckNvUTFBOGhaVTVB?=
 =?utf-8?B?TGhpMVRWZFR3aG9xbFg5MUdRQjhkaGdDSGJVL0hVL2xET21xZUx0VHV2VkVt?=
 =?utf-8?B?VDhKaHQ3dWVsbmdRbExVVjF2WDFIejloamdCQkdEVFhGUzlsZlFyOVRlZmQ4?=
 =?utf-8?B?RHA5MWwreDY4V0pKdmVSYm4ra1VadkdTaVZPRGJHMzYxd2pmTW9VWHNhVGtZ?=
 =?utf-8?B?cTJwdGpnVjY2cEZZZCtXTTBPanN5L1cwbzZ2cjNjd1lVclJQMC82cGYyejh6?=
 =?utf-8?B?WW54cXpXN1ZOWjZnSndxblF4UHl5QjRNU0ZpWE0vRFVSQWZaNGFqTktjWU1i?=
 =?utf-8?B?S05RcE8zZS9ZVVNhSWpLVC9QUk45TFpDV1BMVnRGQ3ovK21hVmlNM1o5VlYw?=
 =?utf-8?B?bnorVmZFMGVSNXNYeUFSb001ejUxS3dBaEh0VFhXakFhZ0RYZ1Vsb1A1R054?=
 =?utf-8?B?QjlwRE1Pc1U3STNsN1pzZHpWSmdESS9neU1kVXpQMUxFcU9iZnp2ZForTjlx?=
 =?utf-8?B?L0g5S2dzMWNXMjhzL1pwbkZWZW1QOWU5WXdpeWIzdXVSTWhQQWRqYWM3UkZ5?=
 =?utf-8?B?ajNVbTNXYUxUU0lpWXBsMllIQXpLK1NSdVVkcjdJUmpIOVNQYmpGRjllNnhs?=
 =?utf-8?B?bnZiZHVERmxoZWZUQTFGaVVmNjBlby81bDZWam1ORllBWGJJZFBzYytsR0VM?=
 =?utf-8?B?U0ZHc1R4cnpiUzhGejRBa2FHVlVVdzNIRzFhejAzL2lUcEhaL2s4ZmUvWk96?=
 =?utf-8?B?ZnNySlY1eTd1d2F6QmNLM3oyaG5YdnVGdzdEZmtiOFRncmVOak9ESUdqYkJM?=
 =?utf-8?B?Z282ZHJ2MVlPbm1jWDd3cXMxRk0wZ2JHWWgzZmVCaHJJN3ZSTW1uWk1kYXJZ?=
 =?utf-8?B?dlJZM1RhQlA1OUxpM3hqc0tPbnEyQWZsV1pqTzNhTnNZcHJIRHF3WVVSb05I?=
 =?utf-8?B?VlJUSk5DMWlsMGpaT1k4bVJoTk1RR2tVMkM3R0FxQzNKYXVDQzlzTG1YSmd6?=
 =?utf-8?Q?AcU6+bpS+TReNMs/DdwhzU8nLP5KjZaAteG+U?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <416855632DB708418AD7D4D792C01C64@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 554e06fb-f68e-4775-3a57-08de4caaa389
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 22:34:50.4993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5sM7xwc+i0EUT/gH+sQVMBHKMZDr1c9fh+m1oiC5N/RHwL2+MEuZSVo22xjDu+VVHmPrHzz2MSbvtGhsJWw3nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4519
X-Authority-Analysis: v=2.4 cv=OdmVzxTY c=1 sm=1 tr=0 ts=695c3c8d cx=c_pps
 a=TO2QspbEOyvqwnNCDF3LgQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=UVi10kQktOAIvh4BhRQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: kWgnuMEmCrZLPAg-vi4nTjTCODen6AyJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE5NCBTYWx0ZWRfXyj61U7jSa68a
 qz70KqEjHn/bB/BAd95gZV9yLqyeVsDM53GMF6nyATXzU05CqXw0tFTkKEOdwXrfxzLCf4feqKm
 yc5GaXzfANER7fj5satuwjP+hkzbn4NLrJc5QVQ2BbtkfTMLFdYddkYQf1eja3x5Ha62KeUbc4z
 Vx8Q7t4tPRz4CfAx2ZbJaikbY+86v4/ZUaZwzhR7BkDWT3lM6vGqktuywjvx4S6t5vW1A4pr9Ew
 hEab+e+HuzqIQgNIyKw/mpEpJr4EcMB3FUzYsYGeVqOIqnciovlqJVkMJ3inYMTfWMJOigSbIXe
 idMSwdQlsg7U2LBsXT5djhtP1Ia9CyU9wWe4HV8tOEncdRDkgfhjsTCwDqZKtX7W6b72XmFc4z+
 buWLMzMmag1woj/5PiknPqzqL3WnJ3N7ORaUeYZ1OKYVAN2ccbRq0ukzkz76VO8d5y1RMSTusTS
 T9Utq6Bj4E7QCPsz8LA==
X-Proofpoint-ORIG-GUID: uckP_sdc8CH-pU9FukeObHfTyuMrpVkS
Subject: Re:  [PATCH 5/5] ceph: Fix write storm on fscrypted files
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601050194

T24gVHVlLCAyMDI1LTEyLTMwIGF0IDE4OjQzIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
Q2VwaEZTIHN0b3JlcyBmaWxlIGRhdGEgYWNyb3NzIG11bHRpcGxlIFJBRE9TIG9iamVjdHMuIEFu
IG9iamVjdCBpcyB0aGUNCj4gYXRvbWljIHVuaXQgb2Ygc3RvcmFnZSwgc28gdGhlIHdyaXRlYmFj
ayBjb2RlIG11c3QgY2xlYW4gb25seSBmb2xpb3MNCj4gdGhhdCBiZWxvbmcgdG8gdGhlIHNhbWUg
b2JqZWN0IHdpdGggZWFjaCBPU0QgcmVxdWVzdC4NCj4gDQo+IENlcGhGUyBhbHNvIHN1cHBvcnRz
IFJBSUQwLXN0eWxlIHN0cmlwaW5nIG9mIGZpbGUgY29udGVudHM6IGlmIGVuYWJsZWQsDQo+IGVh
Y2ggb2JqZWN0IHN0b3JlcyBtdWx0aXBsZSB1bmJyb2tlbiAic3RyaXBlIHVuaXRzIiBjb3Zlcmlu
ZyBkaWZmZXJlbnQNCj4gcG9ydGlvbnMgb2YgdGhlIGZpbGU7IGlmIGRpc2FibGVkLCBhICJzdHJp
cGUgdW5pdCIgaXMgc2ltcGx5IHRoZSB3aG9sZQ0KPiBvYmplY3QuIFRoZSBzdHJpcGUgdW5pdCBp
cyAodXN1YWxseSkgcmVwb3J0ZWQgYXMgdGhlIGlub2RlJ3MgYmxvY2sgc2l6ZS4NCj4gDQo+IFRo
b3VnaCB0aGUgd3JpdGViYWNrIGxvZ2ljIGNvdWxkLCBpbiBwcmluY2lwbGUsIGxvY2sgYWxsIGRp
cnR5IGZvbGlvcw0KPiBiZWxvbmdpbmcgdG8gdGhlIHNhbWUgb2JqZWN0LCBpdHMgY3VycmVudCBk
ZXNpZ24gaXMgdG8gbG9jayBvbmx5IGENCj4gc2luZ2xlIHN0cmlwZSB1bml0IGF0IGEgdGltZS4g
RXZlciBzaW5jZSB0aGlzIGNvZGUgd2FzIGZpcnN0IHdyaXR0ZW4sDQo+IGl0IGhhcyBkZXRlcm1p
bmVkIHRoaXMgc2l6ZSBieSBjaGVja2luZyB0aGUgaW5vZGUncyBibG9jayBzaXplLg0KPiBIb3dl
dmVyLCB0aGUgcmVsYXRpdmVseS1uZXcgZnNjcnlwdCBzdXBwb3J0IG5lZWRlZCB0byByZWR1Y2Ug
dGhlIGJsb2NrDQo+IHNpemUgZm9yIGVuY3J5cHRlZCBpbm9kZXMgdG8gdGhlIGNyeXB0byBibG9j
ayBzaXplIChzZWUgJ2ZpeGVzJyBjb21taXQpLA0KPiB3aGljaCBjYXVzZXMgYW4gdW5uZWNlc3Nh
cmlseSBoaWdoIG51bWJlciBvZiB3cml0ZSBvcGVyYXRpb25zICh+MTAyNHggYXMNCj4gbWFueSwg
d2l0aCA0TWlCIG9iamVjdHMpIGFuZCBncm9zc2x5IGRlZ3JhZGVkIHBlcmZvcm1hbmNlLg0KDQpE
byB5b3UgaGF2ZSBhbnkgYmVuY2htYXJraW5nIHJlc3VsdHMgdGhhdCBwcm92ZSB5b3VyIHBvaW50
Pw0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiANCj4gRml4IHRoaXMgKGFuZCBjbGFyaWZ5IGludGVu
dCkgYnkgdXNpbmcgaV9sYXlvdXQuc3RyaXBlX3VuaXQgZGlyZWN0bHkgaW4NCj4gY2VwaF9kZWZp
bmVfd3JpdGVfc2l6ZSgpIHNvIHRoYXQgZW5jcnlwdGVkIGlub2RlcyBhcmUgd3JpdHRlbiBiYWNr
IHdpdGgNCj4gdGhlIHNhbWUgbnVtYmVyIG9mIG9wZXJhdGlvbnMgYXMgaWYgdGhleSB3ZXJlIHVu
ZW5jcnlwdGVkLg0KPiANCj4gRml4ZXM6IDk0YWYwNDcwOTI0YyAoImNlcGg6IGFkZCBzb21lIGZz
Y3J5cHQgZ3VhcmRyYWlscyIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25l
ZC1vZmYtYnk6IFNhbSBFZHdhcmRzIDxDRlN3b3Jrc0BnbWFpbC5jb20+DQo+IC0tLQ0KPiAgZnMv
Y2VwaC9hZGRyLmMgfCAzICsrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvYWRkci5jIGIvZnMvY2Vw
aC9hZGRyLmMNCj4gaW5kZXggYjM1NjlkNDRkNTEwLi5jYjFkYThlMjdjMmIgMTAwNjQ0DQo+IC0t
LSBhL2ZzL2NlcGgvYWRkci5jDQo+ICsrKyBiL2ZzL2NlcGgvYWRkci5jDQo+IEBAIC0xMDAwLDcg
KzEwMDAsOCBAQCB1bnNpZ25lZCBpbnQgY2VwaF9kZWZpbmVfd3JpdGVfc2l6ZShzdHJ1Y3QgYWRk
cmVzc19zcGFjZSAqbWFwcGluZykNCj4gIHsNCj4gIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gbWFw
cGluZy0+aG9zdDsNCj4gIAlzdHJ1Y3QgY2VwaF9mc19jbGllbnQgKmZzYyA9IGNlcGhfaW5vZGVf
dG9fZnNfY2xpZW50KGlub2RlKTsNCj4gLQl1bnNpZ25lZCBpbnQgd3NpemUgPSBpX2Jsb2Nrc2l6
ZShpbm9kZSk7DQo+ICsJc3RydWN0IGNlcGhfaW5vZGVfaW5mbyAqY2kgPSBjZXBoX2lub2RlKGlu
b2RlKTsNCj4gKwl1bnNpZ25lZCBpbnQgd3NpemUgPSBjaS0+aV9sYXlvdXQuc3RyaXBlX3VuaXQ7
DQo+ICANCj4gIAlpZiAoZnNjLT5tb3VudF9vcHRpb25zLT53c2l6ZSA8IHdzaXplKQ0KPiAgCQl3
c2l6ZSA9IGZzYy0+bW91bnRfb3B0aW9ucy0+d3NpemU7DQo=

