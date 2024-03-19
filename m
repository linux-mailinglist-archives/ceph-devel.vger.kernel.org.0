Return-Path: <ceph-devel+bounces-982-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61EED87F8CB
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 09:03:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D21C61F21B59
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 08:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4A7537ED;
	Tue, 19 Mar 2024 08:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b="o2CrQUW+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2110.outbound.protection.outlook.com [40.107.215.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467B5537E4
	for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 08:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.110
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835337; cv=fail; b=KQMz0DeVdxKM+fcwsn7s/lXCAxk8TSdH7TJBjasrUyFhg5tR34rEC/bcZ8D6Qbzuy0teWYPHS5rcKr1ZX/zGnAfyAH2r/NMY2I2cQhM/8PuehEwlvn3If77Ngyz0H7UGhboMMc245NWThJf16hi1c19stT1ygEUN4ChNaqFFZsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835337; c=relaxed/simple;
	bh=1DNRgmScljacSjTnvvz+lZRYLGicFZ+ycPzV6E/87ww=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uFPk2SiJliLfTGEvwKtT8VhT+qDtKDG/7tk3pDgNVQF69rSVOld4eeB7KKiLCWtXtHHslHVSTA/xOTQ5S+7Q/qc/fIOYvqi8JQ+uoQnyISuNJDNMvpYaSVgQUYJtjweCoMMP5bY7B2RWNkpsSIp0W2sRM8PJh5O0kqznz1Vuff8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com; spf=pass smtp.mailfrom=qnap.com; dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b=o2CrQUW+; arc=fail smtp.client-ip=40.107.215.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qnap.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrN2gBlrq8U2gkCSCorBttn+LvC+QmwHutqzb2hdLF7kJLt9NkA4ZG9wxQyUYMQ9xOpMXIFF3yOxOfETPj2u1XWK94oTywCzjD7zLZZFoUK2uC7Qzb8kvABVSsmWbI+nZw2yBq4GNGKN9kbAxhit9JQTkQONCsZzjjXQmEJSlYxPpib1wC+btZmnyIlNonDoAXOwVKLkLtLWD+nNM0nc1ZYJ9nWbJfbFATqAQ5k9DW4zEYx+g9S7eYH6DoW6ed7kYoPsOfuIBsJp88Iu/c7u0kEqqVBlDDr3aRCF+f8uIcbn2Ogbv6HHzU8U+RO9pp+0JUM8kyiasgB9Lls80LX4BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z24n4j3deie82QGksSGcMAxp6SXiydu6dwb/Q9HYh6I=;
 b=YcSgZh1fd74Ov+zAM31HpHSBImeSKbGTWXaivF9DvLuN8kuOaj7MGIeyT4h8ns/fK6alzH9T3jRkBomlBxUHejDGVDb28sS4Xek1nRWwNfEigCFS4Zr2n6+IvhvaI6KOxBaq9aUULGlbJBOI06SU4MioUOArKR4dSNKHQMI57mQ4KQh4J0tAZ5UBPnf7WMkz78tHTamy0oZdnYDgBA7X6x/7etrjfusX123BXJEHwCT+n76stWfgZfPn6RqrOtNozutrzn4n+hn3ZPTJ0yDxyCoEbCKP3wuGi8XiU3GkdfFSjWQxCblz9YLQMKbevl+okkNNp3SJx3oaZLNc/dkMgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qnap.com; dmarc=pass action=none header.from=qnap.com;
 dkim=pass header.d=qnap.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qnap.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z24n4j3deie82QGksSGcMAxp6SXiydu6dwb/Q9HYh6I=;
 b=o2CrQUW+Q4+qyF/2spsX2nfVgLq885H+4OQOsvzhuYn3uilb0gmRM94xII0SBL+rnHlsExhO+a82kCP4Vvu7nq8BXC4VZU6wy3TWDy/N++14DCKPMgnaKMxSXucxZ+d+pR6Larwl0Fm+H7mkmTyvyYs52Az3jK0vOkk/kd02s6f1m8rjvXml+oHGrXpKL9uJAZaKAaasvKpx2NYh377KN3Y3L8nyix1LJ5n+6vlOXssF2cR+t0unRIZC1niGMGeRkY7iSFK0sLhI649rUa9aszt7MCkv3ZRXvqFG26Ihcu4pnl+5LNVnEHKpEB1jNIUnpu7YjxDjcP9iiE62uhWo/g==
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com (2603:1096:101:ef::7)
 by TY0PR04MB6541.apcprd04.prod.outlook.com (2603:1096:400:271::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.23; Tue, 19 Mar
 2024 08:02:09 +0000
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::4aff:c1d:f18b:5e0]) by SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::4aff:c1d:f18b:5e0%4]) with mapi id 15.20.7386.025; Tue, 19 Mar 2024
 08:02:08 +0000
From: =?iso-2022-jp?B?RnJhbmsgSHNpYW8gGyRCaStLIUBrGyhC?= <frankhsiao@qnap.com>
To: "xiubli@redhat.com" <xiubli@redhat.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"idryomov@gmail.com" <idryomov@gmail.com>
Subject:
 =?iso-2022-jp?B?GyRCMnNKJBsoQjogW1BBVENIIHYzIDEvMl0gY2VwaDogc2tpcCBjb3B5?=
 =?iso-2022-jp?B?aW5nIHRoZSBkYXRhIGV4dGVuZHMgdGhlIGZpbGUgRU9G?=
Thread-Topic: [PATCH v3 1/2] ceph: skip copying the data extends the file EOF
Thread-Index: AQHaeZTqYFQePVrD3ker4pTC3rdNC7E+slkR
Date: Tue, 19 Mar 2024 08:02:07 +0000
Message-ID:
 <SEZPR04MB6972BF98FD1F4CD9D6C93516B72C2@SEZPR04MB6972.apcprd04.prod.outlook.com>
References: <20240319002925.1228063-1-xiubli@redhat.com>
 <20240319002925.1228063-2-xiubli@redhat.com>
In-Reply-To: <20240319002925.1228063-2-xiubli@redhat.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR04MB6972:EE_|TY0PR04MB6541:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 XdL5JqLVtBGlNSIMyZXMj+4jYFeNWQzLrTc+JKjEeklpnux+c+AakdUfwLuHERshQwjEsy1/iHcEWeztSbbp0GO0OokbUh4EyLn6GU4zsKs0oLAdDkFw1MZlvz7+NOVACeMYnUDriASaijUTImk90DxxI7xtxeqKZd+OVZjebmThR9LYgL/v1EY7KYHXqIWYwh6uemL72YI8eOLXuT5nfITbqOjk+Q8cU6l2iE4uFjdX9X1qB+HC6LWDrtz2hES8EMa6GAq9V2swoPzkj8hfXLWbgt0RxhE/AewU2WXH8Oi9fPHnrjdjqs1pitWiejnyHZ9BBpjfzYVxdxu6qYpyTFcNCD7KfLwa/cjEkL8ViSFzehpnHnHQeMk1ch3YZfBuLw9VDjJf+LVzQPXFuIPKrwe7WgwkZSgxfNk+hsy7dBuqZX+hPcA/mb7vKm+PljuYsGbLOZQJJOHg1uIVxv3PObtBP8qd1d/rspsLaG0wZI5yqOm00/K9NgAV4ch635ul5TkB21xuz/AIgfgrh/lVCo7vgLwCMml+ANe8A1MzSvzfCE/UdluqFS8L9n9GLUJJNa+vLNt2rCYgBlvQS0fk/VLGxyZMAispEwiLMpmVt+Q=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR04MB6972.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?UHdpdWtnR29IS0VQQjhRTnlKWlNJcmxYTFVSWFl6OUE3TTRoSnlaWUlJ?=
 =?iso-2022-jp?B?TUdFejBzSUhtM2loenRBc1ZFcUplTzVBSVVxVmRBak5laFBDRmdsRk9t?=
 =?iso-2022-jp?B?ZjhoOGhWbFg3K3JOZlNlSWd6TDMzTW5MUEIvbkpFWU40dGJqQWdWRDRF?=
 =?iso-2022-jp?B?MjBNQ2NWUGNPUFNub3ZJclRsckRKTzV3Snl1eEFqVDd5bmJHZnkxWFdo?=
 =?iso-2022-jp?B?MitkOUxMV1J3UWtmZWJZVEh1NTVYVjdmRVAyVW45YWZNU0IzMWVhbm8z?=
 =?iso-2022-jp?B?LzZnenZJYUFaQjQvS1dJT1l2RzNTUVhVREdtSm0yWkc2dFlhc09URHpX?=
 =?iso-2022-jp?B?YnJOQmhFYmttdDBycW5SSGwwMnE0Q2NIL1Mwc1lPVDI5R2tqcVdTMXNh?=
 =?iso-2022-jp?B?cjhsNmZVLzdXbFVIK01iUVE3SFlTSDMwZjhkOTQrRHZzWVpQZkdCczA0?=
 =?iso-2022-jp?B?R05YdEdwWUNDditvWG5vM0srZGpIYUhVZHNxY2I0YkI2SVJGSHV1ZDFS?=
 =?iso-2022-jp?B?b3Z3b29GOVVkaTN2WThRZ1BIUU0wMUFtYW5hRlkyV0pFMVMrZjYyZm10?=
 =?iso-2022-jp?B?N2t3Ym5BMlloMUJqU3V4ZTA2N0FUWllTWkVyYjVScG9DSzN2ckVLOXYz?=
 =?iso-2022-jp?B?Wm5takNsblcxKzFKVXpZa0sxMHA2VklXeVN0ZEp6VVp2czRMUi9nM3Fp?=
 =?iso-2022-jp?B?UnF6NGhYOFNmOGF1THRwKytONWx1OHFiMTFpU1k4Mis4Nk96UnNqbHI5?=
 =?iso-2022-jp?B?c1YyejFqZXloYjhMekF6dTdjT2tnOUNHTURXcHhVVWNUV0VQcTNZRUVB?=
 =?iso-2022-jp?B?bnBqd3hRWHdYOHRIU0lrbjROckw4a1dPNnNvOTBwS1g2dEJjQXMxRzhD?=
 =?iso-2022-jp?B?SVNaNm85enp2QlpyRDZ5OWpJSnlFdE9RY2FEQ3Y4emtQTGl3ek9VcU9n?=
 =?iso-2022-jp?B?YWhGcVZtZGVpdkxpWVp6Nmh3VkQvbi94WjkwOGNsVG4vZnczOUFzTUFD?=
 =?iso-2022-jp?B?UjBveVRhVXZOV2NCMW53SWVnSW5Qd2x0c01lb0FkWUxqMUJEUFh3YjNW?=
 =?iso-2022-jp?B?MzdMWFc4SWNOcUc1azUwTEg5YkZRR1k4MncwanhvUFdBdTJYYnV5UkdN?=
 =?iso-2022-jp?B?ZVlZZXd5am50aVVuc1BseTBWNEg4Z1FxVjE3VWJyQ0M4ek1OWjFkZWM4?=
 =?iso-2022-jp?B?Rk8wRkozTFoybkVoaVJYd0Rkcm96Z05wbFlHeDgxNVpXa05nd2d4bGwx?=
 =?iso-2022-jp?B?NXNXbDlPVXIwTmVxZHFpeVFpeTg1Y2kzQTY2Zk1DVUpzUXhJSTl4aTFH?=
 =?iso-2022-jp?B?aC9GbnFHNG5CUjdlU25lUnRlVEZhMitSOHZyRXh5cVM4ZGpFaWJjTVVM?=
 =?iso-2022-jp?B?cCtYS1p2NldKQTZQUStiek5hc0RXRUtGZ1lhKzc5TmFqalRwTVZOeFg4?=
 =?iso-2022-jp?B?QlAzRWdZL3BUQ3h3c0tPUHo5amtCVGN0WTBCREVhMFZ1a0l6R0ZVOHJF?=
 =?iso-2022-jp?B?R1NkK1Y4bnRXcCthS0RQMGJaY05IaTkrVzdpbjZaYVMxNWJaUlhVd3gr?=
 =?iso-2022-jp?B?ZHZhR0wvb1AwRDJJcEJSa0ZEYWFoc2h6dXpLRkM2Z3lUdjFuS3RYMVZG?=
 =?iso-2022-jp?B?VnVwN3dnTFBiWnlkeUlEMUNRWENndStKQmExMDl0U2Q0RG82NHR2TEFt?=
 =?iso-2022-jp?B?ODlqUE1jamJNRDh4aFhiU0hzT05TbzJGUG01WEZHNmQ2MUlpemJXYUxh?=
 =?iso-2022-jp?B?dmtJcURXc3lWSSt6c0hLbWsyeTlSRUxaQWR0cTlQK0VKMDN3andaQklM?=
 =?iso-2022-jp?B?aFg0RnVWNHJpZEhwUzYyR2xuMzZ6OTIrRGV6NEpmSEZLMjJZRW5aalFP?=
 =?iso-2022-jp?B?RGd3Zk9XY1RzQkxtSlRyOUJZcTFnTi9sU05ES2p2dG12Mi9EOTVzaXJi?=
 =?iso-2022-jp?B?QzBtVmx0Z1lSempVcmthTDFxTW54WWZlY2VlaDBEZ0gyS21vWGZMZzJ3?=
 =?iso-2022-jp?B?dWFaU2lwY3lCUVdrYXdnRXNvYzk4TlRncVJkK1kvVlBndFQvSHRLUGFN?=
 =?iso-2022-jp?B?SXR0bGRGOFpEaXpJUDc5N093d0NvK3JLSVBCUTFwUHd4LzBYQ3paQzJT?=
 =?iso-2022-jp?B?RGlqOHZqejNEM1ozQmFxQWtNbW5SV3Z3SVJmYXpaYWI1VGxJUXhoWE5G?=
 =?iso-2022-jp?B?SVIrSkVXSDIwUnVlUWE3ZnY0RmovZ2dVSDVsN2diNzJ0YWxWU2NSSEsw?=
 =?iso-2022-jp?B?Y0pNMmxtNkZZa2VHei80bitTTG5rRzBaOD0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: qnap.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR04MB6972.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ae63d8-9f22-4111-e72a-08dc47eadfb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2024 08:02:08.0131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6eba8807-6ef0-4e31-890c-a6ecfbb98568
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sco+btQj3ORVQXVV4aiVBmaOC562d4vTFZSrji3K+HnFXhoJxMojrApglq31jMypcheUl4p12K+kj3tQY3lZHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR04MB6541

Thanks Ilya for pointing this out.
I've tested the new patch and it looks good.

Reviewed-by: Frank Hsiao =1B$Bi+K!@k=1B(B <frankhsiao@qnap.com>
Tested-by: Frank Hsiao =1B$Bi+K!@k=1B(B <frankhsiao@qnap.com>

________________________________________
=1B$B4s7o<T=1B(B: xiubli@redhat.com <xiubli@redhat.com>
=1B$B4s7oF|4|=1B(B: 2024=1B$BG/=1B(B3=1B$B7n=1B(B19=1B$BF|=1B(B =1B$B>e8a=
=1B(B 08:29
=1B$BZ@7o<T=1B(B: ceph-devel@vger.kernel.org
=1B$BI{K\=1B(B: idryomov@gmail.com; jlayton@kernel.org; vshankar@redhat.com=
; mchangir@redhat.com; Frank Hsiao =1B$Bi+K!@k=1B(B; Xiubo Li
=1B$B<g;]=1B(B: [PATCH v3 1/2] ceph: skip copying the data extends the file=
 EOF

From: Xiubo Li <xiubli@redhat.com>

If hits the EOF it will revise the return value to the i_size
instead of the real length read, but it will advance the offset
of iovc, then for the next try it may be incorrectly skipped.

This will just skip advancing the iovc's offset more than i_size.

URL: https://patchwork.kernel.org/project/ceph-devel/list/?series=3D819323
Reported-by: Frank Hsiao =1B$Bi+K!@k=1B(B <frankhsiao@qnap.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Tested-by: Frank Hsiao =1B$Bi+K!@k=1B(B <frankhsiao@qnap.com>
---
 fs/ceph/file.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 24a003eaa5e0..c35878427985 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1200,7 +1200,12 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t=
 *ki_pos,
                }

                idx =3D 0;
-               left =3D ret > 0 ? ret : 0;
+               if (ret <=3D 0)
+                       left =3D 0;
+               else if (off + ret > i_size)
+                       left =3D i_size - off;
+               else
+                       left =3D ret;
                while (left > 0) {
                        size_t plen, copied;

@@ -1229,15 +1234,13 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_=
t *ki_pos,
        }

        if (ret > 0) {
-               if (off > *ki_pos) {
-                       if (off >=3D i_size) {
-                               *retry_op =3D CHECK_EOF;
-                               ret =3D i_size - *ki_pos;
-                               *ki_pos =3D i_size;
-                       } else {
-                               ret =3D off - *ki_pos;
-                               *ki_pos =3D off;
-                       }
+               if (off >=3D i_size) {
+                       *retry_op =3D CHECK_EOF;
+                       ret =3D i_size - *ki_pos;
+                       *ki_pos =3D i_size;
+               } else {
+                       ret =3D off - *ki_pos;
+                       *ki_pos =3D off;
                }

                if (last_objver)
--
2.43.0


