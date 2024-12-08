Return-Path: <ceph-devel+bounces-2273-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7A59E8715
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Dec 2024 18:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D167F1883CC9
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Dec 2024 17:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C2614A0A4;
	Sun,  8 Dec 2024 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GIZyOlbo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACD822EE4
	for <ceph-devel@vger.kernel.org>; Sun,  8 Dec 2024 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733679144; cv=fail; b=i8JQGdUPlsulAByuXK4S4/2l4e9qbKdwf4By3sCY29qPijH1xXC80jjvtO/Ffxl27nsQmhj04cM22uFfqHi2R/iV2S/EOY8hTlp3XHKwyp+vMOVGxMRtapO/WkPr1vHlO+CRvVyE64iHx0EKPZVBJzo5WDbP7gbnLEvF1l3kIGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733679144; c=relaxed/simple;
	bh=BS+wFGWzUObQUru6If5tkC7KWiecX7t0173BV0SzP+o=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a+MeAjkbfaSykmL3HOm22Nw/5L+oGslKSnWolvpn0lGD0Nzo82PXeB5grqLlykNfkhzXYho5JTk4G6Y0tZ+GX/WJ5EwoyavyiNcfJIRX2oyXMmTysDO6VbW4vZn1ZfSjn/1sV1zfD3ndJghSBmiVSlQUVQu9jd6byH2m6dvHLCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GIZyOlbo; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B86vFnw012588
	for <ceph-devel@vger.kernel.org>; Sun, 8 Dec 2024 17:32:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BS+wFG
	WzUObQUru6If5tkC7KWiecX7t0173BV0SzP+o=; b=GIZyOlboam8d51CCqMrIQ0
	YzZhFz9troxNR3d3mvV9uYDsxCg1JdWeErZSZUfrDzXWWiCvWGJjq39TBQr2n1AJ
	arrzdF8V9npsT0Hj7umzpMa1goPDWwVlCWRilHFAf8YBLAlqUgnZl173LtkdPB4n
	oMMx2MxCQjujnNGl8cB0M1LdjycnTYmFvYk/1Mb1HXBdePUxDycFSJ1e6gzCAJnP
	4bos2rXr+Ej7RYDgduHdZWb5WWDXdkd1rdxJ1du+bG9uqDHWtgHLR3wnWfKK8gdR
	Fp0Goe3XdaueVN47RHjYEZKNrBBlUYX7kC+6oyj/QMR9CheCZOUsA7I51wzkW7aQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce0x4vm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Sun, 08 Dec 2024 17:32:21 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B8HWKko022824
	for <ceph-devel@vger.kernel.org>; Sun, 8 Dec 2024 17:32:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2045.outbound.protection.outlook.com [104.47.58.45])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce0x4vm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Dec 2024 17:32:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X1k0Zhb1IfzGrdZBBOV52bgfXkh6aoJ+6F+zeG3vsei/l6fKAfndB7VJHbqqfrGApc4tB8YmWLx8TzEAu3eepWV0GVVwsQRLLenHUn9huFp1bTtT/kWLWO/eMf92//l+HpjErveqm1Qw7MUcDOCs07+yRAZ8SL1E05ywkavfNuXeJ5Eyq2hu2ST11pfcuCd4qUehAevgTNTnkHOjDu4cbCHou2CIGCSHmqUo4Y/dto7lIOOkLhBx5wCrFxPAW6CO4muZ1q6hr4NIH7ofQ2cl9QtFiMMgxMfwB1+7X76MrhUfAHKlMlLkauhiNvOhKHwCXI6BmyG/WKUFPE7lCpcNyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HDnmdNl+lHcdGxeujlfzm7Noe4yDjatFlrG4nxk1vy4=;
 b=MP7YuvmKxwpH+VswlOVemNyfGL3q8y9yYndleHAN4xHPpN3NYlC5ECGgSMGYH9lKyysP8LMEPWQ1+LbdJ8jL2EhkTKrSd9/hAxIMiiD+8k8rJl1EC3RmkvFdtWX3o5uBAo7uBVoryddVuK4oeF90VGND8WllqnVU3BDudbCXzGbNWD8h/QaP/UYsMIASquULbqUtt8+ZJKNj5lZMasjGTADf/ZxGHY7VrjJMMCx83Jhwj2jIM3d9T4lcpjDwTfX/uQnaSM/NOE1yAosG0eoQXmrnPw+iiVyzIVsi+ykS3+G/trJ2OLSM7iWfDYAhe/IIIvjand9x7THBDZ98Y+A/jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from CO1PR15MB4876.namprd15.prod.outlook.com (2603:10b6:303:e3::18)
 by SA1PR15MB4321.namprd15.prod.outlook.com (2603:10b6:806:1ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Sun, 8 Dec
 2024 17:32:18 +0000
Received: from CO1PR15MB4876.namprd15.prod.outlook.com
 ([fe80::9887:d635:6513:10f]) by CO1PR15MB4876.namprd15.prod.outlook.com
 ([fe80::9887:d635:6513:10f%7]) with mapi id 15.20.8230.016; Sun, 8 Dec 2024
 17:32:18 +0000
From: Alex Markuze <Alex.Markuze@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Subject: [PATCH] ceph: improve error handling and short/overflow-read logic in
 __ceph_sync_read()
Thread-Topic: [PATCH] ceph: improve error handling and short/overflow-read
 logic in __ceph_sync_read()
Thread-Index: AQHbSZchpaDtxBRPtEiqVZCjH9oDng==
Date: Sun, 8 Dec 2024 17:32:18 +0000
Message-ID:
 <CO1PR15MB4876E2C9F48D78426091DCD092332@CO1PR15MB4876.namprd15.prod.outlook.com>
References: <20241208172930.3975558-1-amarkuze@redhat.com>
In-Reply-To: <20241208172930.3975558-1-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR15MB4876:EE_|SA1PR15MB4321:EE_
x-ms-office365-filtering-correlation-id: adb7c2ef-6dc0-4527-d1a4-08dd17ae43a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?jjiSgKn3K2ONGcfw82o0A+bOyv6KSRJ0un4e/Dm6HrKuDc6hL3tXfTdTQF?=
 =?iso-8859-1?Q?3nN5GgjqBiu97rpzNeeTt1HaJ7SPHUuY6c1t6xfMK+ChMro1NovTc91Ko1?=
 =?iso-8859-1?Q?OqSDkvGi+ljcZn33Vctg6WbZYpVRTRfvHwV6tepFIXqitmCreKjybR8VMI?=
 =?iso-8859-1?Q?MBBI4VOnDqlEeRTWnKXyYLZg4T4jVO1wlr/lVOvHtnvih5sW4BQhGdZeKM?=
 =?iso-8859-1?Q?BhcR6VgH7SxeZQIKVgpMbx/X8lgdH94xePBHuFHOhg31NFEfjZE6cHLYwv?=
 =?iso-8859-1?Q?iVhgTiM0FO49aGdU16dxg3cjkYsSqhHWWsll2ZRvoyroVTj3GjIgZQgMPf?=
 =?iso-8859-1?Q?XR5qQXHGvVVuh7eAAGwt/u3m6a8CFKTqY8LniAXW7N9hcp7OQQ/AWi0jpm?=
 =?iso-8859-1?Q?H5Xnd1RZk+TiMiO/B/uUd+JoRGJ+NRHMd6npjCD/CcWUt7UbZjoJrUusXM?=
 =?iso-8859-1?Q?pvVHDRJyVlf+3sTemMgQdc/TOPmyMaswBABEuCOP6C8hwVDQVOTD/vYFL5?=
 =?iso-8859-1?Q?LoSolShYqWGZteU/a6hFkr1xn2gxAKXB2luMld0PdIn9r8v6cOZZH+ddcq?=
 =?iso-8859-1?Q?H8hfPs2eWyt0NovB9f0j2rQzWysRfPl6uQHopmL4KIh5s1drhYnMlRZeGI?=
 =?iso-8859-1?Q?bHc4GJDqQ3kx7gl79FMq+2mREsVdeSdzulUGwqRT60WgZjQu8iudwr52Kf?=
 =?iso-8859-1?Q?sfoyT5lrLNqDEKER2Tu8fm9pqxvI40tCHVMi1jTZl/EyiFVnlbl0lkz9pr?=
 =?iso-8859-1?Q?MRywo+aSKNwadTO/7TVkjsag/r25fCvtoGDZi10q+yNYBpLIyy/nP3p1O5?=
 =?iso-8859-1?Q?8qlLQKQricM5ErFIWAaqW0C0F1aZJkttpX+Uhai7x6eIV2DvcRlA2r+TuU?=
 =?iso-8859-1?Q?8Uy6DV43Ug9h62OdXQ6qsb/uMRQugGFZdfuEBRSJT0ymxC+oY7REGVl8Ib?=
 =?iso-8859-1?Q?AxUSAidoCGNoCz4qdnZPNydSVo3rfQdcJQFh6iP1DVnVeZzbcaZfQUW6lM?=
 =?iso-8859-1?Q?m4/bXmwoG1gHixve/NBGi4avHD6xH4hRAni5nJEcqThz9QR15wrscF2Vnp?=
 =?iso-8859-1?Q?X9dD05iPjexAMa179nlC8/sLPsU2/Nm+qKzU79+QWDVzQSKYm4dS8c2XVy?=
 =?iso-8859-1?Q?SBSdBBUADdsCFAHZFtzaokQCgnGQfG6WX4jCdxQn6B9ka0pkT4Pn6QieIB?=
 =?iso-8859-1?Q?4rYXQU92KTuoxaADHTqWJUxcXL41kmCuraeQ19gNt/DpECCT8K+cusGUk0?=
 =?iso-8859-1?Q?jTiueBmG0h/VDEUAcFfrGJ9AyleVhWLy//dEca2k4JAuYo8mn/aEJxPZf7?=
 =?iso-8859-1?Q?zqK3gkzJ5ffHnIxbkIW5lUj0214zMKrJw0xc+zK3+eACjp2FJk9+Ekysls?=
 =?iso-8859-1?Q?biMttfKtnLhycusCpU9h5Af31ytfdOfKfZpmM8xW8UksO64zHDXzE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4876.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?g2nOvAxOQ1UjPC5kOlOws5aQVPnALy3VopKx1VutWn105DHQ2m6rpzl95f?=
 =?iso-8859-1?Q?6n2Q0z4NJ8sBfP7+ExL2I4pbaR4Px56uASRkvXfsloN3OPQSOS5wGAJY+c?=
 =?iso-8859-1?Q?ylBudh2cvZ+4j9w8j+2vp4dMc8ldKbTtE5s7C362I0QIoBgGKD8FShrNbx?=
 =?iso-8859-1?Q?u0YOpfH7DtUNun9PeTHGIY7p+ub+NL2f3L/mppwNb1tWSROBBE8E41c9op?=
 =?iso-8859-1?Q?YOgF+hYwfN1nUyaavSSJYzdvf2vdUvR0kDrsuhYLUqbVRhgVTE4+RVIjAJ?=
 =?iso-8859-1?Q?NJMUtQvQKXYLFDW4iL6lzNI12eOut42wxfhqpyBJfUSgO4oxUnI0Bxy4c8?=
 =?iso-8859-1?Q?BDzvYvtgQHs+4vlIOm5NgUhCDwt+UlKQsA23gGrGFXqoAzsptQ4IMk5VI0?=
 =?iso-8859-1?Q?CtDquWHGmbHRztlkyeQOZ7IcEWCeVz3Hy3+858gMKMvHBpW/x1xYkPHSiR?=
 =?iso-8859-1?Q?0IModHIF9ZQbWZXQKgb9/tc7gcXjbIMe2iKH2JBDRZwxoUKnGyWeM1J7LM?=
 =?iso-8859-1?Q?0vDbvI/IU7/bekOrTVuSItHc42ZFUeRpOVWzZnxkovurgYt+IIRk8OtSap?=
 =?iso-8859-1?Q?kqueKgUgmXjE4ys8cw1vZujTw0FCgGZGFEhsJyQD5/azjgbtd+md1IN/UW?=
 =?iso-8859-1?Q?Z0IdbOUnE195+0bRMzZG234Pwu+yEMa9gg3QYjBvFAmCb7ilc8lpPq/Lzq?=
 =?iso-8859-1?Q?6WpU4aF6k7HlnF63x0+gNHCzWBRA0NlQOuWB/Z65SfE3xelco401yl69gs?=
 =?iso-8859-1?Q?46ZyNqyf4ZJHcgg2bi5aBf6D4nMWz3BE6EeuNVqcC9cx+ZfKnO1p3UOH+m?=
 =?iso-8859-1?Q?5myvOYnb99xq/zCSb5iXNbCnwOJpbl+t4nOjnwDnTkmNZuIZ5D5wSaCjya?=
 =?iso-8859-1?Q?Bj7/HM3+l+u41f/mMyCgY+FTnX5H6TkvuHi2jwZYMDw+EFc/IL3FEWVSsu?=
 =?iso-8859-1?Q?tU75vU1+isUf4lmJEsQy+2x49o4KkNU33XOLOTLUut3K4S218VekCos3E0?=
 =?iso-8859-1?Q?PhRnY7hxE2Eu2icDlJK6ZEGuJX6FzBbjnRXaA/z+lScFUmrbEx/ySxV0DY?=
 =?iso-8859-1?Q?+sRk0z0iKFPSna6ghMJ+Cry8SBlbmbD+4BBIshpZYTvXlHD80REx01qwcw?=
 =?iso-8859-1?Q?T3wjhcVd0VToL6aE4IEFRRLRinQu0uJEMTtiK4A60VTU2wB2/QSlU348ko?=
 =?iso-8859-1?Q?Le0XJR56oD75iOfeSiQe9kVNMIrTEeOeCtRuVQJ3xz41eRBsfXYoydPdqP?=
 =?iso-8859-1?Q?sg8HqOLB7zfrfGGZDa0WI0RufAgIAz6nk0i2masSx6zKgrVi417OeZVIfE?=
 =?iso-8859-1?Q?Dm5RumMBOX39kDvKtp8sH1UjHEYJvo6ypXs/aD7009k0AgDSDLegCBD1Q6?=
 =?iso-8859-1?Q?e1Gl3gVx9iio5jPCvixfbIianoa4xqrnNyU+rmSy94rO358pXbIYE004iB?=
 =?iso-8859-1?Q?Q9ZAaH8xnIXKnwvQQN+jRoK0HeW4tbK4XN/v79WBQ/LimnOT98/P3tA/T/?=
 =?iso-8859-1?Q?WHNs+PFpGJ8xN8OSeDhcR5Lt37BsSJLsBSO+MsQjgVhhLautWrubK7giDa?=
 =?iso-8859-1?Q?yHZN9qnzAQaPKTv/tPDyqsEeRlGVk5ZV7q7OWGF+9SEZ1nOpdQZcx6/Bin?=
 =?iso-8859-1?Q?Dd+dIzi/FKTkHtGCUqFGyW3p/r0VgdypxiRgwpespv+nh+XPx5De04dw?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4876.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb7c2ef-6dc0-4527-d1a4-08dd17ae43a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2024 17:32:18.3141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BOtOZ+1MNJoVuyx1COkNrkugFjfh2k0zX7tsbImr9RgVT5cGgCm446pyXzLrC1QfOxsJtJf1aAOU4LpKKgWcXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4321
X-Proofpoint-GUID: fhhKva3Yg8tA2RUkZLeCe0J1GCv8pkyt
X-Proofpoint-ORIG-GUID: ZLadhcCe9QzGJU87_VAUDk7q5HvaGY2v
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1011 impostorscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412080145

This patch refines the read logic in __ceph_sync_read() to ensure more
predictable and efficient behavior in various edge cases.

- Return early if the requested read length is zero or if the file size
=A0 (`i_size`) is zero.
- Initialize the index variable (`idx`) where needed and reorder some
=A0 code to ensure it is always set before use.
- Improve error handling by checking for negative return values earlier.
- Remove redundant encrypted file checks after failures. Only attempt
=A0 filesystem-level decryption if the read succeeded.
- Simplify leftover calculations to correctly handle cases where the read
=A0 extends beyond the end of the file or stops short.
- This resolves multiple issues caused by integer overflow
=A0 - https://tracker.ceph.com/issues/67524=20
=A0 - https://tracker.ceph.com/issues/68981=20
=A0 - https://tracker.ceph.com/issues/68980=20

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
=A0fs/ceph/file.c | 29 ++++++++++++++---------------
=A01 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ce342a5d4b8b..8e0400d461a2 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t =
*ki_pos,
=A0=A0=A0=A0=A0=A0=A0=A0 if (ceph_inode_is_shutdown(inode))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EIO;
=A0
-=A0=A0=A0=A0=A0=A0 if (!len)
+=A0=A0=A0=A0=A0=A0 if (!len || !i_size)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
=A0=A0=A0=A0=A0=A0=A0=A0 /*
=A0=A0=A0=A0=A0=A0=A0=A0=A0 * flush any page cache pages in this range.=A0 =
this
@@ -1086,7 +1086,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t =
*ki_pos,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int num_pages;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t page_off;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool more;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int idx;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int idx =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t left;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct ceph_osd_req_op *op;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 read_off =3D off;
@@ -1160,7 +1160,14 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t=
 *ki_pos,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else if (ret =3D=3D -ENOEN=
T)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 re=
t =3D 0;
=A0
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret > 0 && IS_ENCRYPTED(ino=
de)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret < 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ceph_os=
dc_put_request(req);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret=
 =3D=3D -EBLOCKLISTED)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 fsc->blocklisted =3D true;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (IS_ENCRYPTED(inode)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 in=
t fret;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fr=
et =3D ceph_fscrypt_decrypt_extents(inode, pages,
@@ -1187,7 +1194,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t =
*ki_pos,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Short read but not EOF?=
 Zero out the remainder. */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret >=3D 0 && ret < len && =
(off + ret < i_size)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret < len && (off + ret < i=
_size)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 in=
t zlen =3D min(len - ret, i_size - off - ret);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 in=
t zoff =3D page_off + ret;
=A0
@@ -1197,13 +1204,11 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_=
t *ki_pos,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 re=
t +=3D zlen;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 idx =3D 0;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret <=3D 0)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 left =
=3D 0;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else if (off + ret > i_size)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 left =
=3D i_size - off;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (off + ret > i_size)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 left =
=3D (i_size > off) ? i_size - off : 0;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 le=
ft =3D ret;
+
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 while (left > 0) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 si=
ze_t plen, copied;
=A0
@@ -1222,12 +1227,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t=
 *ki_pos,
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ceph_osdc_put_request(req);
=A0
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret < 0) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret=
 =3D=3D -EBLOCKLISTED)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 fsc->blocklisted =3D true;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (off >=3D i_size || !mo=
re)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 br=
eak;
=A0=A0=A0=A0=A0=A0=A0=A0 }
--
2.34.1

