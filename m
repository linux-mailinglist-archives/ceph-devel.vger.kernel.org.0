Return-Path: <ceph-devel+bounces-1800-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB6596F8A9
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 17:52:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5DE6281C84
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 15:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE741D1F60;
	Fri,  6 Sep 2024 15:52:12 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D63374F1
	for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2024 15:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.129.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637932; cv=fail; b=h7zu21hvMxpitzv3MXVVVrgm7gMMmzMmg4prx4YsbK3CFxQNUwxX7XQmcbtnQGYSwVhg81ku5+/joDkLUqUigJg0lJbHsgjdnR8nOfrT6qB+yEDJIVr2rvAT088gV59dW21Dj/AyJIDInju+1H12u3Z3QqppA5m8oVOUjmgZu/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637932; c=relaxed/simple;
	bh=ZnOZavseYbFddeHH0MjxXOmkrmD2ULsHLSdXZIQYi74=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Dnh3x6OO0OwB0kXEtWYGnVRE74BpIq1Ipq0Q0Uo6GR/l5JIoR7cH8zvMdWNeOEBgNjTqTFHaIIL3eJKWJTfmRVZADt2zud+sq3G7B58lIVlmHRlefyYAHnKCb3p+w3vZKpJdqqlkIfk9iUN91tO2ENdx05Jqq2VQwyOfMSm0Hfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studentconnectivity.tech; spf=pass smtp.mailfrom=studentconnectivity.tech; arc=fail smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studentconnectivity.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=studentconnectivity.tech
X-Virus-Scanned: Proofpoint Essentials engine
Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01lp2174.outbound.protection.outlook.com [104.47.74.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1B2B170006F
	for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2024 15:52:07 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X4L4s/XF5MK2pbfOeytJWUrnK2EvfadGOu9HtSWcqfg6ZNvD9IfDTKHbdaN6uqZ+vBH/u8ci+7msuwovDZEQzbEDK7M/yalu4EStF0tzHcOr5fx867snnNSdFPG/Vd/GqSUK6mDfAu0hAIzaCY84dH+NyGlbEer35q5YbN2w01/6jmLd47obDQ4q7lm2K+KM2E82DfrDcia2lQm25pjsxu+Vd2j70FE8ENFjT0ahBBtFPQEkT4A3bgbKQHGxLRVBJULmxh8mZRrF65gEhMp7DVItS8u3CQELaWBIwiIEJMXQ3Mis4N00lrnFg1yYFDoZIkbeqh6WemxTUVWBxqNUrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cO0TAV1FHsGZ1C/RigTu8HIN3cC5rYt4KVs0hJHf/XM=;
 b=OtAMIhny/epwH7tJqOmMTuzAIIoTCUnYp216sS6ERk0ZKlTrcD66Jmp1HCdHvalMznbe0Nb7QJUIODfSLLPkbGSPSsRS9gVqStlvWKqNnKKCeZMuLQCNzG/tS4owxMi/iuKidSyNkqy0LNA7JI7lnjWzlE04pnKfNxlZmmhBXe1T+9XJawvM5sWqiFc35BFdtsOVIPpXnYkMjgEr1/4tLaSqpksLTSaJEcU77h2qomXlB/zieuStUvNYZR3GvUTey9diJlo0uPH0DvcYXU15ir4tyL5lt4OCwBswJwNt5fc/woXae6C+Rjqtzvkm9IlwWNRaS62aFKc+WllAlXrrIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=studentconnectivity.tech; dmarc=pass action=none
 header.from=studentconnectivity.tech; dkim=pass
 header.d=studentconnectivity.tech; arc=none
Received: from PN3P287MB2950.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:22a::22)
 by PN1P287MB3917.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:254::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Fri, 6 Sep
 2024 15:52:04 +0000
Received: from PN3P287MB2950.INDP287.PROD.OUTLOOK.COM
 ([fe80::a62c:9d29:5701:8376]) by PN3P287MB2950.INDP287.PROD.OUTLOOK.COM
 ([fe80::a62c:9d29:5701:8376%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:52:04 +0000
From: Avery Harris <avery.harris@studentconnectivity.tech>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: School Contacts List - 2024
Thread-Topic: Re: School Contacts List - 2024
Thread-Index: AdsARhYF4kDx9VnWCEKAvI2lX7BUfQ==
Disposition-Notification-To: Avery Harris
	<avery.harris@studentconnectivity.tech>
Date: Fri, 6 Sep 2024 15:52:04 +0000
Message-ID:
 <PN3P287MB295084CD20F047527011366AE69E2@PN3P287MB2950.INDP287.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=studentconnectivity.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PN3P287MB2950:EE_|PN1P287MB3917:EE_
x-ms-office365-filtering-correlation-id: 9781400a-8892-4db1-d412-08dcce8bdae8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?wMqnTTvjTMvjszNJ66L+q3Ccb7533N4+496RybHOYWGG+vJ+PPDiObbO2rJK?=
 =?us-ascii?Q?PN8iW0unq/MrLJ7xqXTY4hD8lalhuaj4VQodWnGqhsSGVFBxzvFenAI88ai9?=
 =?us-ascii?Q?zVaRNxKFgDiR3S/UI0YnoLc251bA47U/8N1wPEji89oLaY8ILjEOIW0causU?=
 =?us-ascii?Q?qozk+6K7UKhCIZ66HNJNun8LJeq0RTFtC8Un1Sx7WM0dte0Ko0qyfs7laFuj?=
 =?us-ascii?Q?J9vmrwjjR4SA/3ckPeO8njAuwmDjG/orpTOfs2YWyk3tGFT9EhccTmxE0IdT?=
 =?us-ascii?Q?NSTbRJT6Gl5daGBWZldofMYOMwcBIQGyr7blsAY9iSY4THscKhI2cs8kcLCA?=
 =?us-ascii?Q?/UicDh0F+lkssKBGBFC8j6LWrLNb7zkdbgVEQ2igdt9t7Z1Le9Tp9PxVPUIV?=
 =?us-ascii?Q?ezgck/JY+kI6H1nh9F2+ZPzSYilF/qQqebPmLO48TEIYhotd2TuJljjj0LxO?=
 =?us-ascii?Q?f+xRxRwHfwVwBhNhS54mjvqmn5cK11XYbbqgYkcbdJN17liRgj6OoSyaOvri?=
 =?us-ascii?Q?Nizk7oIfDIjMdai8eQOuv4rVGa0dxOnrRP+aQcbmfmb1TsEZqcYcFpeFuw03?=
 =?us-ascii?Q?dVuMkG6F0sg+DgqMKp6tZx2nSQfVTPKhU1CXU+xsBvJTVMkGGtkHRe+D8kLb?=
 =?us-ascii?Q?TYff40nI6tnzkD32SpziF4GdfjKFwBvs+LLERxiAF6/7lfX0MqMfZOol41gp?=
 =?us-ascii?Q?4lejq2JAbp5MR3J9wLvlXxW17mZ52IxuLFG5tyaBd29tNgmUUvhoAehfVQAI?=
 =?us-ascii?Q?BxcColOk0VvADOcV0ScX8l9/JYdsuht3w48NPQKo3Gd64nfrukhvoRaNsnsB?=
 =?us-ascii?Q?D1XoTge32HL8vkUxOv6MJDfVFV7Ff2AotiRUnIHMJnp3L+W3UDZw/sQWh6Bs?=
 =?us-ascii?Q?WYhS01lIktZLV3RWlhJkXqz0GKS9cBTh5vG5NZtJXhUVHtWz7cNJEe0v3hZS?=
 =?us-ascii?Q?LYfJxTyhRJU9MlfdQI+te4buI+PzFBhKJ8BPNbl7u0WzPQ8w2DOEK/5I0nb1?=
 =?us-ascii?Q?/XJb4StfJC294flICRhc6SgfL0E3wR6fQX2VKcoocTTMVOG2Ul5TVrIl7nuh?=
 =?us-ascii?Q?6T4Mf3TD4Nv3B1kQzGQaJjWECi2x7qfl8eVKNnSIMrj1rsmzuNp7LLUqAprR?=
 =?us-ascii?Q?rWo/HDWZCcx/eoxRHX7i7QycceuyZ/fDuuxFt6ansC72Uenm5K7XwSIhWWO1?=
 =?us-ascii?Q?clXr2g/3vlca1zwf2PqgRUIkammlJZDbytbfoDjUDp20zIZQuAYOnh+hGm0j?=
 =?us-ascii?Q?zTnJX6ploQad3hJCBkVSgxPxkjrw5EjSkidG/SBCFVuPOVdWYuL8P8Rk+pFM?=
 =?us-ascii?Q?cgy81cBWlyjhP5L+1pMT1AehIx3yA3qx0KqXbv9KtFRjgGM54kfpDmPqRjXU?=
 =?us-ascii?Q?lcicOvbCQ2OH1DyUznBC592tOOsfrhoMXGxDrS7DoudghQV1Lg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PN3P287MB2950.INDP287.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?gXSpTg38mkqiBWz3lnvUOvZNceRDPxrUO+EMMAmE6g1yM0fzNr8naMtf/9mr?=
 =?us-ascii?Q?FEJXWk76HiSPV/jEntfX64Yxa25jl0XTuVcTdqNRyC5fa4ffEtuKinbddv3c?=
 =?us-ascii?Q?L3+0iyaARzidUA1OEdDDB7Ov2utl3MrPFD0N1t+dT+M/Mji77niueieMbL4k?=
 =?us-ascii?Q?IGLFIeRvQW86FGTudEt5ciU/PzDHP/fz556jEU005bm/kv99MimyTURi5Wlb?=
 =?us-ascii?Q?VGyB8MhZQ3EMG90U7Du/he0whnMxxZJ019jt7YLMUhqwt9zYH4Xk4H6EybBI?=
 =?us-ascii?Q?0oSGwJDg4O8je8R57WzVUKP/7QwhYFskI5iunikS8M5K1dFj1mDzr5UfXiuI?=
 =?us-ascii?Q?j4ZIetEkS4FGR39FQl5pW8NLaSa09DM3K1Yh/+1itxmnAzR0p8jQ/Zp039om?=
 =?us-ascii?Q?1fCd298o4W6KlNZkrIl96AykVzsvscEQ46YFNBQxitA8Cc6kRG/W3t2jxyJG?=
 =?us-ascii?Q?fy05H7094yN2fkfK3duR7NnlnUyXEG4y6AXExuxhp5d6Vtn1EXolrvhy1ZRk?=
 =?us-ascii?Q?JTmLvaE+xecqtfKL6RdY8EPUPpnEPOgpma5cogEGuTWeJnwcfAe2J5X7eMSD?=
 =?us-ascii?Q?/9NS5MxEnneZUdB8ODcauSxfPOjmx0WwmFCDXDep8/u2vtsfdh1jr/gYvHYm?=
 =?us-ascii?Q?zWwOQ4DoYRwz2dXVU06ZNjA3wNX6mG30HfCL4YNd79SqLL9eC9l7xmvv7PYA?=
 =?us-ascii?Q?8vdmKeChQYb6JxYgMVayk9Wnd9iEuxTUrvgWeDmBDQNi+EgCMBiD4FBKvyCY?=
 =?us-ascii?Q?ny5+zRL2fDq/6oBuYdgM7I1mLcjvmtWJp21YG6z0Sa7qxCXH6inYAc03eaHz?=
 =?us-ascii?Q?FJoBuupJA4gHOO1JYiic7NK4/xQvAVBWf0v604/2S27XfmqY55LpqXTt7YYo?=
 =?us-ascii?Q?Ly78ZMQBETBmzcApL12jkou4t6BkC0pdkRw/72FDKnAhEpFjrw1i6uhcrc5h?=
 =?us-ascii?Q?D172cdOvGiaf/eTWiRARBZXXFwRUN308yzTcuc9Gy+KN2zwCIpCjCXyDLH5+?=
 =?us-ascii?Q?vyupsnHXLIltBI35Kqee2jnpFzGrs8BmlK3/AsAMeTCKZlxSr/tQ3m58m6XH?=
 =?us-ascii?Q?CSVOfnAdsQ+71bEK+bv6CwcEpOY+fOPprNL8Xt6Ow5UnGPJIK/FDPpfjUtHk?=
 =?us-ascii?Q?UeBB93QMJdq8idp3dQeiETi2m/xpkkZAtKKGjV9ylOZAiVqSOxRO/sObU0P6?=
 =?us-ascii?Q?V4Jlr5JcssONAT76evKzFbjli9zuos3PguydhSId6L5lfWiUNErcA6psqVHq?=
 =?us-ascii?Q?ybbxhuUylKziFgdRo1kBuWj0ZrX0yaFduGHuqGhyvafxIScnSICxrqS/5l9C?=
 =?us-ascii?Q?dLBkAuUTxPXvQAUcslU4r3QpW59uW07R2QArqHvKlwoJNiyqwhffOf++Gesw?=
 =?us-ascii?Q?X7bIQHRgDsgWinSsH6JXfKhkXQtpcO/jdCoSSbApUK+2Fub/OYC0uUS3Y67h?=
 =?us-ascii?Q?h5LilATEEAjP8qZ35DZe3u9dqMXTEHYx63fX+IXyDcxl863VCvDGznDg5zGc?=
 =?us-ascii?Q?hU/iCzn6l1k0ljIEX8UMFnt3tO25qYudbEzjhWERMXdi1VPFRzqOl7kxnjaD?=
 =?us-ascii?Q?0ifPVJU/OpN/naW97Wp7YutE1kFowEJn0GLucFQNI0aG7rv2VRXJ26FkdLzq?=
 =?us-ascii?Q?65tayz3lzukyP6qirk3sVg8LeLkwT6iPxr5LkW+hN98CR5FuKex2vufDFPpR?=
 =?us-ascii?Q?fuji+bUWycL8sIKdzrK5KH/uzx0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IUtQy1wxOnkUam2UsXkkHnx+RVwU/DBSAUfMGJngjj4j0FWuxQCOKYoZ85i+9IdxqifDKI3kJfGuAJXo3IdALEtisKG1YK5Hr2FtWYIzn6mo6sFusGAPRkO5TnGH5vedJc0QGrinNKF+SLzb5lp1I4by3QONF73KTJY4VIINOE8d8QtSgdJzbgGXtcJHGbq+igOMxgW1ndx8tRnRpK/s1tTdF9tBZ+d5cvTuXgnDP37+Fw3lCmwkU4ueSSGiopbpezPhN8hdegMOMRjqGPde+NqKp6V/J4ZOkxW9aTpqFdQTVCNXOpTdyXxrnRX9d2JCCDcKhyRmg2vmH5qbCuGjtmw1hTPKx2wmLmNV81Z5jCtzJLxIueKhrAkPH+puwW5YwOZdTsXB70DxLiYTP7y/Z9OdPVgdqITzZGJLBbr835L3Y3mQBNdm5GYzzXDZ1+zSPHSWM6G9n8Lb+sC2tNrwRDopF0XRvB+0K+krOm6FcknZimCMOp3fsGdaSPMjxcz9VO6F7HvKy4V6dsEc4mSOZM1JN/QexXHsgN/+PoSgj2/VASKg/waOCzQTG2kMG/cFgT4GaWr+bW7SOAU2ONHAKKDqQMQ+nUJMDlJ62TpLlMM=
X-OriginatorOrg: studentconnectivity.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PN3P287MB2950.INDP287.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9781400a-8892-4db1-d412-08dcce8bdae8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2024 15:52:04.7735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6f06dc3f-1d44-40c3-b040-812624058af8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W/upC0AZzdmfE7HiAYimCPNvorvEPvoKwPeeTBQmvcxaUyUFJcFLeSRHN8m2gizjftPkZmGweywVv/6do3ZYOC37KIqa7+5fwM/Ph4KCSoN+YkSVUfavlncYVcDggPVp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1P287MB3917
X-MDID: 1725637928-0bSQK7g85l-z
X-MDID-O:
 us4;ut7;1725637928;0bSQK7g85l-z;<avery.harris@studentconnectivity.tech>;44acf0875e9e04fb896aece516012560

Hi there,
=20
Want to expand your outreach to K-12 schools, colleges, universities? Our e=
mail list of principals, superintendents, and key decision-makers is ideal =
for you!=20
=20
Our List Includes:
=20
*	Principals
*	Superintendents
*	Board Members
*	Department Heads
=20
List Contains:- First Name, Last Name, Title, Email, Company Name, Phone Nu=
mbers, etc. in an Excel sheet..
=20
If you're interested, we would be happy to provide you with relevant counts=
, cost and a test file based on your specific requirements.
=20
Looking forward to hearing from you.
=20
Best regards,
Avery Harris
=20
To remove yourself from this mailing list, please reply with the subject li=
ne "LEAVE US."
=20
=20

