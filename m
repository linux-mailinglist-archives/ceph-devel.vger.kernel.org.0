Return-Path: <ceph-devel+bounces-870-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E40B9857554
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Feb 2024 05:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C8B528449F
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Feb 2024 04:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B595910961;
	Fri, 16 Feb 2024 04:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b="gQsgf5ig"
X-Original-To: ceph-devel@vger.kernel.org
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2096.outbound.protection.outlook.com [40.107.215.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12A8125C7
	for <ceph-devel@vger.kernel.org>; Fri, 16 Feb 2024 04:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708057493; cv=fail; b=Y+vsIlwB97XHfhZ3fLETAS7WZnxCVMgQB8sadtVaAFEFhM/5Ku9T4iQBx6dO2RHlwUbVKPJZXZkFFP5ZwjmRtfsW3BweWwI/XmizcgrMqhJ+kPGoH6tfNxJmqRjU9au4O51yHL3hp4cKagly7+UXXQv4++wdL/ujbXePdVIIN3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708057493; c=relaxed/simple;
	bh=j8Y96RvC0QHeh8YJjN8rzBuYKH7C/bl3e353DwsyjqU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mYtwitzd7jb0fsohVlAgpIQcoUitsbhQZBg0Vd2icrH+2KLudrTeVmP7OjWyEq5sTpF87x9M9ZD4fqmz39riH0vaHltNnF3FPaOSaZr1I/VExnTiafuZH57Fp8XaXK1FKO0EY5rGKlYgEn+bDc2HRt+1DSDOJu27ajIrgWQdca8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com; spf=pass smtp.mailfrom=qnap.com; dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b=gQsgf5ig; arc=fail smtp.client-ip=40.107.215.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qnap.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7VE9mlvopHIUbq9nc7EvA/BTPh7BVyynW2fLSZtKcH6MJrKPITlRGIertM2jVISQFX8QV472UXUX43tJcX6Xs28EFAbC9PFW5zZJvibUbcwdVuCBBbETXgDSiZiCA7qBkz2jF4WUML4SZtva6jjvu3dPfeemkv/smtShxQctwdXjw+J6YiBcsOPDyMOG1uczDWgTsg00qUHS/mS9FDdbtLuqR8l+sijlrFmQjM2dVOCu6RidFcn1hyhJ549xUnf4svB700O5M1UtgnnGWR0GzTmIVMvBX+5hTS/mcUKfQgonjCfRvg3yCP6nXZ2o8zsscTunFMPOdajCo5vKHLwSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8Y96RvC0QHeh8YJjN8rzBuYKH7C/bl3e353DwsyjqU=;
 b=B00oIpCRmB6HlP3K2MBgq4IIFOVw27bn36U9nMHxiTlCO4yb69NbQi0hD7T1f04HTEjq1oLdN1hPOwsJRRYcl1/aFwAuRiuWkgBpOBraHKC3m12o8YEe9kOBOWMBYgq5oniw1Y/dm9AFxI4ncJtDoIR2C13S7ArdDAgaTKebyDcTdgaqcatC/uV+RAXsJSHq2bjidrd+2LORwoTkzoMYikEVZDapOM9el1knl35isem3Uc9Il0lrMIvaCjjQ2zmXDOf3dVQiz3eKICqcp6Wrj01bOgFtjCUAn/tTZyFg3sFzINMKP1JlXoCnQFp6K9yPcMxS3teu+e/JmffJCODssA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qnap.com; dmarc=pass action=none header.from=qnap.com;
 dkim=pass header.d=qnap.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qnap.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8Y96RvC0QHeh8YJjN8rzBuYKH7C/bl3e353DwsyjqU=;
 b=gQsgf5igNJWPEp/FpMqq+EFTGNul81s9UDOEsdY2dhHIe3HaUM6CrWS5bvp1hqmYmPXVW+FVv59NU7oceTFdwy8pV2VRypfyLdw1cWVbNkZtSu8801VLAsBvr1tM2r2cy5fk2CjFu7JchW0YyWMwkQw+NS0h1atPGLdKlOBRTqFJjYdlFbQzeaCd0ScjLk403sSUDYLDjpFt5+cxzY32tHs8Qayw9QDAKEj5ITchLl3u1heScfxDQ5O+oR3fFFT4idnHsrsdRdlwOee6ilGPKkidEuF569jkMfl2vcwraH2NL2CUXVaVNEa4DUXzf7wHzBXAnYvDqWbMYKYRLAN/ng==
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com (2603:1096:101:ef::7)
 by PUZPR04MB6141.apcprd04.prod.outlook.com (2603:1096:301:da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.31; Fri, 16 Feb
 2024 04:24:47 +0000
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::9f09:7b37:9bd6:cfdd]) by SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::9f09:7b37:9bd6:cfdd%5]) with mapi id 15.20.7292.029; Fri, 16 Feb 2024
 04:24:46 +0000
From: =?big5?B?RnJhbmsgSHNpYW8gv72qa6vF?= <frankhsiao@qnap.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
CC: "jlayton@kernel.org" <jlayton@kernel.org>, "idryomov@gmail.com"
	<idryomov@gmail.com>, "xiubli@redhat.com" <xiubli@redhat.com>
Subject:
 =?big5?B?pl7C0DogUmVhZCBvcGVyYXRpb24gZ2V0cyBFT0YgcmV0dXJuIHdoZW4gdGhlcmUg?=
 =?big5?Q?is_multi-client_read/write_after_linux_5.16-rc1?=
Thread-Topic: Read operation gets EOF return when there is multi-client
 read/write after linux 5.16-rc1
Thread-Index: AQHaTnBMaFmF63blQUOSXPXYY4zuRLEMgof1
Date: Fri, 16 Feb 2024 04:24:46 +0000
Message-ID:
 <SEZPR04MB697298071AB99C3D1A63210EB74C2@SEZPR04MB6972.apcprd04.prod.outlook.com>
References:
 <SEZPR04MB697268A8E75E22B0A0F10129B77B2@SEZPR04MB6972.apcprd04.prod.outlook.com>
In-Reply-To:
 <SEZPR04MB697268A8E75E22B0A0F10129B77B2@SEZPR04MB6972.apcprd04.prod.outlook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qnap.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR04MB6972:EE_|PUZPR04MB6141:EE_
x-ms-office365-filtering-correlation-id: 4966686e-295a-4baa-2904-08dc2ea7352c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 eLUvorjuQIrcWO5JwsOqzB8bIaLlhL7WIZyX8fSTfbt+NhC/PKFFr0BSSu8IX3QtDTsqtn67cItuQ+W8G0FOgSUuxTcsJqoHrLeGIYZZ1Xs3/nEzqFKPIJtf6++hL/td7G3SquDvNHC15rvfQtRgCHZB03UmpV3Xx+MM/3h/slAeqeYTH/UX895SkzbrOFwgKfRolKClIMStaKp63KNTbu2pyT+4+eUAD5HRq6diJHxGHz4yltBKmP/EGqufoORqFVpBE4z3Mt/DuiVpr6qkZwIzzSi569HbwCuaX854J5FiFD2mxTvipuEH9qBrkVVigC99bXIe739vYYn09s3Kly8F+dgLjINQINklmLERAyLVy4K6QP/ip3mIh5vYgsTBryr0NIE3BfvQvorhqJDScYqDql9UMh690yJjjUIQ1KhE4iZSFqdSWslJfrzWN1NZEgwg8+JmosHKOVr0mUGZmOyk5X4NF6nAcEHFuoxj10Uu74xspcQSJxM+qhgHEJXx5ig17XhPBVqDT6Y43M3QPWpmNl0EN7yLLAnvbJV5ynzQohgeNMjO1o5APZw49TcjuIuATR5gh9jdTJQRxJCxliwkZtWmEWghnAf22aT6nDON15kcsGvGtAgXGLn3s1Yz
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR04MB6972.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(346002)(136003)(366004)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(55236004)(478600001)(316002)(71200400001)(54906003)(6506007)(7696005)(9686003)(26005)(41300700001)(2906002)(5660300002)(76116006)(52536014)(66476007)(66556008)(8936002)(4326008)(66946007)(66446008)(64756008)(6916009)(91956017)(86362001)(224303003)(85182001)(38070700009)(33656002)(83380400001)(122000001)(38100700002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?big5?B?MGN2ajhiMXM1WlRCamFiNzRJYmdIR1VNaS9reS9oSlFhVkcrNE1BS1VCWXJ6cUk1?=
 =?big5?B?WG9nNUpDd3dURVVCQ1BkaGcrRXRDVXlneXBONU9qaVBHRGgzcWQ3LzdzVFk4cEo2?=
 =?big5?B?K2VDei9iNlRvMU5XWm9GaCtjSFdZK3dyUnhsQjlLaWRpOUYxOUI0VlAyakd4OEky?=
 =?big5?B?VTNFMjV5dHhkb1VJL3pKMTRxQWRob2w2engvZGxYMW1rQ1duUDIyOTR0NS9pK1RM?=
 =?big5?B?RDVCRWJoenM1MHVmMWlKNGJ1aUxsSDJpZFA4am0yY3FtOC95RE4zQ3EvdkhKYTFo?=
 =?big5?B?bGE3cklLaHlLVDE4VXRvYWNyeGg2MytzNWNiWXZrL1VrMUNMdXdlRHVCMmlDMVcr?=
 =?big5?B?VG5GaHBrM1JsOXFaTld3VTRYNDI0UjQ2V3V5eEZiVXBkNmNUcVE5endFY2ZoN1ZC?=
 =?big5?B?QmQxVlpLTEtsS3l5dDBKeWxYY0hqbDlITmlrelc1endoYlRHSUxsVFlUbGI5VGZp?=
 =?big5?B?S3pJdzEyRElySTFVdVhwRUtoM0ZubnFWVy9HdjUyYk4reXlJOENmMFlFSXhwaEFY?=
 =?big5?B?WERnemlneU5nMmh6aFJpdkZFS0kvSGxHZmd2aXM4eTNXNWVralVrMnhPbEVGQVR3?=
 =?big5?B?WThPb3ZBQWJoZG5pRlQ2akNuVFE4SXpycFBmZGFkMzJwVTdDMWYrODBadVZibGJN?=
 =?big5?B?UWd2Q2lVa05JQlY4YXltWkN3MzVXSlBmc0d4aXZYMkhHOEZBMDFNWEROR1k4YXpu?=
 =?big5?B?S002NU1EUzRheGRFV1RMamhQZE90MjYyRktxa2YyTnRUSWc4VWxkT1M1UHhGcGZX?=
 =?big5?B?N3FkZEV5enBKMTZTeUNjeXBycG41RE1pb1UwODJuNFh2ekFEM1ZidWdIdmhIUjRa?=
 =?big5?B?ZlZJQWEvdTIxaWhZOHFNRFYwSVM0aCtld081TlkxUjJjM3hMTCtYL0ozNVlTOW5Q?=
 =?big5?B?VXhVRi9iTHNRbHJBQWdEZTNKQnZlbUJTQ0gyTFhqTCtFcUxML2VTYm83czJBNHhj?=
 =?big5?B?aU1WWko4dU45d3RaaUlBem1aUUhFZzJRbTQzcThyVmJHeS9URzd0YngyZ1J4WWx0?=
 =?big5?B?MmVYTkRmR2JCSnNkdURtNEcwRWxkQW95bTJCSjhSUkk5M002bmQ2ZWd6ZlQzVjRl?=
 =?big5?B?NHMvWlZiSzRMbFlSc08rc2dicFVnZXVBWWN6elpsWjZZKzl2b3RVc2RQQ0dtRjR2?=
 =?big5?B?TXZPMFlSTkQ4RW8zK0RTV28xYnBzNjdnRGdPemlxOTdLdFIzcGs2ZFR0VFc0MWNp?=
 =?big5?B?Y2pzd0ZndUNka3lJemhqK2pRQnRCZkNKaUhBc2tSNXN5OHhGejNqN2dSRTg1WGtn?=
 =?big5?B?ODdxL3ZrYmx1RUZhQzdHOG1qaE5na0VuSGdlQ2NGejliSUZsRENRbXZ4MXZhSlll?=
 =?big5?B?TmhIRHVXNjdNaDFjQ1F5MUhJN3BSU1lwekRUemJSeVRwYW1KblFFOWRvd0FTRTZQ?=
 =?big5?B?N0Q5U1g4ZzNUNm1yb1BhYnNpVGd1Y3lKSnNKZG9GZ1BhbW5ObnFYL24rR1d0ZW5r?=
 =?big5?B?L2V0alI5MzFqbmZhNlMrUzl6dTc3S2wrSlA1VFcwVldvRk1Xd0EvWWp3Y0IwSjlB?=
 =?big5?B?NGlzaGtNYXVTTy9PamdXR3JKOVlaUFFNeHdaSUs3azlUanI1MmRvaHJUN0dsUmdW?=
 =?big5?B?bnhjcVRDVGxWa0F6bmtlOWM4cGVQSkNhK2FXZFYvc2x4bVdFTFRGaUVjcHlyWHlP?=
 =?big5?B?T3JsRFc5d25pWEpDZFIzZmNzUXkyM3E3SnEveXduM1BmVE1odXh3Y29JdWdkcllK?=
 =?big5?B?b3pjQlZQL0JUYlQ4UjVYL3N0REtaNkhId054S0w0VlYxNlZTdXR4dFk3eFdaa3VY?=
 =?big5?B?WFJsS3FqK0pPQk9kQkVvL2pqQTdZOG1Hc0tZcUJQMmNmdWVzUVNwdER6eEVTaWcv?=
 =?big5?B?cTNGdkZxeElaNTV4eDBEbUtjd2pYTTFMUkltb1ZaaHVsNndZU2lyOWFRZDdMY1lZ?=
 =?big5?B?bEIxYTB5cjc0YWJ2M25HZkVzZnh6aGszSE0yYmtyOTRLL00vVEREUllTWktrRWdR?=
 =?big5?Q?hLrR9ydkINL4FbguUi83UCMFJLYqg8cUcA2oZXZ+IKQ=3D?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: qnap.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR04MB6972.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4966686e-295a-4baa-2904-08dc2ea7352c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2024 04:24:46.6100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6eba8807-6ef0-4e31-890c-a6ecfbb98568
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0YfX676fpkb7uE3EzhrhhtpUAd0DzMt0cvabM09mu9Mtigi974aZlj6Hqn/v3HL/FqaNcUIK2hG48ecgCylGSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB6141

SGksIGl0IGlzIGEgZnJpZW5kbHkgcGluZywgdGhhbmtzLgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwqxSKXzqsw6IEZyYW5rIEhzaWFvIL+9qmurxSA8ZnJhbmtoc2lh
b0BxbmFwLmNvbT4KsUil86TptME6IDIwMjSmfjGk6zI0pOkgpFekyCAxMToyNQqmrKXzqsw6IGNl
cGgtZGV2ZWxAdmdlci5rZXJuZWwub3JnCqVEpq46IFJlYWQgb3BlcmF0aW9uIGdldHMgRU9GIHJl
dHVybiB3aGVuIHRoZXJlIGlzIG11bHRpLWNsaWVudCByZWFkL3dyaXRlIGFmdGVyIGxpbnV4IDUu
MTYtcmMxCgpXaGVuIG11bHRpcGxlIGNlcGgga2VybmVsIGNsaWVudHMgcGVyZm9ybSByZWFkL3dy
aXRlIG9uIHRoZSBzYW1lIGZpbGUsIHRoZSByZWFkCm9wZXJhdGlvbihjZXBoX3N5bmNfcmVhZCkg
cmV0dXJucyBFT0YocmV0ID0gMCkgZXZlbiB0aG91Z2ggdGhlIGZpbGUgaGFzIGJlZW4Kd3JpdHRl
biBieSBhbm90aGVyIGNsaWVudC4KCk15IGVudnMgdXNlIENlcGggcXVpbmN5KHYxNy4yLjYpIGFu
ZCBtb3VudCBjZXBoZnMgYnkgY2VwaCBrZXJuZWwgY2xpZW50LiBGb3IgdGhlCmNsaWVudCBzaWRl
LCBJIHVzZSBTYW1iYSh2NC4xOC44KSB0byBleHBvcnQgdGhlIGZvbGRlciBhcyBzbWIgc2hhcmUg
YW5kIHRlc3QgaXQKd2l0aCBzbWJ0b3J0dXJlLiBUaGUgdGVzdCBjYXNlIGlzIHNtYjIucncucncx
IHdpdGggdGhlIGZvbGxvd2luZyBmYWlsdXJlCm1lc3NhZ2U6Cgp0ZXN0OiBzYW1iYTQuc21iMi5y
dy5ydzEKQ2hlY2tpbmcgZGF0YSBpbnRlZ3JpdHkgb3ZlciAxMCBvcHMKcmVhZCBmYWlsZWQoTlRf
U1RBVFVTX0VORF9PRl9GSUxFKQpmYWlsdXJlOiBzYW1iYTQuc21iMi5ydy5ydzEgWwpFeGNlcHRp
b246IHJlYWQgMCwgZXhwZWN0ZWQgNDQwCl0KCkFmdGVyIHNvbWUgdGVzdGluZywgSSBmaWd1cmVk
IG91dCB0aGF0IHRoZSBmYWlsdXJlIG9ubHkgaGFwcGVucyB3aGVuIEkgaGF2ZQpsaW51eCBrZXJu
ZWwgdmVyc2lvbj49NS4xNi1yYzEsIHNwZWNpZmljYWxseSBhZnRlciBjb21taXQKYzNkOGUwYjVk
ZTQ4N2E3YzQ2Mjc4MTc0NWJjMTc2OTRhNDI2NjY5Ni4gS2VybmVsIGxvZ3MgYXMgYmVsb3cob24g
NS4xNi1yYzEpOgoKCltXZWQgSmFuIDEwIDA5OjQ0OjU2IDIwMjRdIFsxNTMyMjFdIGNlcGhfcmVh
ZF9pdGVyOjE1NTk6IGNlcGg6ICBhaW9fc3luY19yZWFkCjAwMDAwMDAwNzg5ZGNjZWUgMTAwMDAw
MDEwZWYuZmZmZmZmZmZmZmZmZmZmZSAwfjQ0MCBnb3QgY2FwIHJlZnMgb24gRnIKW1dlZCBKYW4g
MTAgMDk6NDQ6NTYgMjAyNF0gWzE1MzIyMV0gY2VwaF9zeW5jX3JlYWQ6ODUyOiBjZXBoOiAgc3lu
Y19yZWFkIG9uIGZpbGUKMDAwMDAwMDBkOWU4NjFmYiAwfjQ0MApbV2VkIEphbiAxMCAwOTo0NDo1
NiAyMDI0XSBbMTUzMjIxXSBjZXBoX3N5bmNfcmVhZDo5MTM6IGNlcGg6ICBzeW5jX3JlYWQgMH40
NDAgZ290IDQ0MCBpX3NpemUgMApbV2VkIEphbiAxMCAwOTo0NDo1NiAyMDI0XSBbMTUzMjIxXSBj
ZXBoX3N5bmNfcmVhZDo5NjY6IGNlcGg6ICBzeW5jX3JlYWQgcmVzdWx0IDAgcmV0cnlfb3AgMgoK
Li4uCgpbV2VkIEphbiAxMCAwOTo0NDo1NyAyMDI0XSBbMTUzMjIxXSBjZXBoX3JlYWRfaXRlcjox
NTU5OiBjZXBoOiAgYWlvX3N5bmNfcmVhZAowMDAwMDAwMDc4OWRjY2VlIDEwMDAwMDAxMGVmLmZm
ZmZmZmZmZmZmZmZmZmUgMH40NDAgZ290IGNhcCByZWZzIG9uIEZyCltXZWQgSmFuIDEwIDA5OjQ0
OjU3IDIwMjRdIFsxNTMyMjFdIGNlcGhfc3luY19yZWFkOjg1MjogY2VwaDogIHN5bmNfcmVhZCBv
biBmaWxlCjAwMDAwMDAwZDllODYxZmIgMH4wCgoKVGhlIGxvZ3MgaW5kaWNhdGUgdGhhdDoKMS4g
Y2VwaF9zeW5jX3JlYWQgbWF5IHJlYWQgZGF0YSBidXQgaV9zaXplIGlzIG9ic29sZXRlIGluIHNp
bXVsdGFuZW91cyBydyBzaXR1YXRpb24KMi4gVGhlIGNvbW1pdCBpbiA1LjE2LXJjMSBjYXAgcmV0
IHRvIGlfc2l6ZSBhbmQgc2V0IHJldHJ5X29wID0gQ0hFQ0tfRU9GCjMuIFdoZW4gcmV0cnlpbmcs
IGNlcGhfc3luY19yZWFkIGdldHMgbGVuPTAgc2luY2UgaW92IGNvdW50IGhhcyBtb2RpZmllZCBp
bgpjb3B5X3BhZ2VfdG9faXRlcgo0LiBjZXBoX3JlYWRfaXRlciByZXR1cm4gMAoKSSdtIG5vdCBz
dXJlIGlmIG15IHVuZGVyc3RhbmRpbmcgaXMgY29ycmVjdC4gQXMgYSByZWZlcmVuY2UsIGhlcmUg
aXMgbXkgc2ltcGxlCnBhdGNoIGFuZCBJIG5lZWQgbW9yZSBjb21tZW50cy4gVGhlIHB1cnBvc2Ug
b2YgdGhlIHBhdGNoIGlzIHRvIHByZXZlbnQKc3luYyByZWFkIGhhbmRsZXIgZnJvbSBkb2luZyBj
b3B5IHBhZ2Ugd2hlbiByZXQgPiBpX3NpemUuCgpUaGFua3MuCgoKZGlmZiAtLWdpdCBhL2ZzL2Nl
cGgvZmlsZS5jIGIvZnMvY2VwaC9maWxlLmMKaW5kZXggMjIwYTQxODMxYjQ2Li41ODk3ZjUyZWU5
OTggMTAwNjQ0Ci0tLSBhL2ZzL2NlcGgvZmlsZS5jCisrKyBiL2ZzL2NlcGgvZmlsZS5jCkBAIC05
MjYsNiArOTI2LDkgQEAgc3RhdGljIHNzaXplX3QgY2VwaF9zeW5jX3JlYWQoc3RydWN0IGtpb2Ni
ICppb2NiLCBzdHJ1Y3QgaW92X2l0ZXIgKnRvLAoKICAgICAgICAgICAgICAgIGlkeCA9IDA7CiAg
ICAgICAgICAgICAgICBsZWZ0ID0gcmV0ID4gMCA/IHJldCA6IDA7CisgICAgICAgICAgICAgICBp
ZiAobGVmdCA+IGlfc2l6ZSkgeworICAgICAgICAgICAgICAgICAgICAgICBsZWZ0ID0gaV9zaXpl
OworICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgd2hpbGUgKGxlZnQgPiAwKSB7CiAg
ICAgICAgICAgICAgICAgICAgICAgIHNpemVfdCBsZW4sIGNvcGllZDsKICAgICAgICAgICAgICAg
ICAgICAgICAgcGFnZV9vZmYgPSBvZmYgJiB+UEFHRV9NQVNLOwpAQCAtOTUyLDcgKzk1NSw3IEBA
IHN0YXRpYyBzc2l6ZV90IGNlcGhfc3luY19yZWFkKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0
IGlvdl9pdGVyICp0bywKICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7CiAgICAgICAgfQoK
LSAgICAgICBpZiAob2ZmID4gaW9jYi0+a2lfcG9zKSB7CisgICAgICAgaWYgKG9mZiA+IGlvY2It
PmtpX3BvcyB8fCBpX3NpemUgPT0gMCkgewogICAgICAgICAgICAgICAgaWYgKG9mZiA+PSBpX3Np
emUpIHsKICAgICAgICAgICAgICAgICAgICAgICAgKnJldHJ5X29wID0gQ0hFQ0tfRU9GOwogICAg
ICAgICAgICAgICAgICAgICAgICByZXQgPSBpX3NpemUgLSBpb2NiLT5raV9wb3M7Cg==

